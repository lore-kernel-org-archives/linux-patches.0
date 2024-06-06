Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77449196C8C;
	Thu,  6 Jun 2024 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683129; cv=none; b=rcWIxlmtu/9Q5OQcziRoHPt3M87ka+pq6YXcH+GGMGV3hVTFXZCbuB8HN7357kufCggy+yxPH7imDGgfHSQ86oB+wnj4wlZyE+gCO56PaZZcV90aG76vq1+xumFHgBvl++N5m/7uIILWa76ieG2zpcLYtOPmQt1bObg+CZ3uWZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683129; c=relaxed/simple;
	bh=neTAFpGxNSMtBO+J+Up0uXLWrkzxVEZY0o9tsDZ/zLw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pOydpIhcIan0aRFznaFLisDSYJlbYBF48XpUYIjG/d4H46Nx6KQFB3m2iTNa3hGr724VCZNEm4biaorbPMQe/PZWAjdrxw8EYBt4jvq+6JDuD+vxjO/mAP+nNWmARnPnnRh6B6aXPWbWwfpm6ZNnQDjfpvoYwZdcwbrqfOEFUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSlnJfVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSlnJfVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F2EC2BD10;
	Thu,  6 Jun 2024 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683129;
	bh=neTAFpGxNSMtBO+J+Up0uXLWrkzxVEZY0o9tsDZ/zLw=;
	h=From:To:Cc:Subject:Date:From;
	b=uSlnJfVGPYeLfidYMiMCyyolv8+v+peMtAQjvOWcV69CUsF4+qhXy4NSN9mzAOXpP
	 7SKYtJXImsqIKxvaWQxMgdvSK4k8B1uSRWS/w3s07p3D9agSPx5GyzD2PFMPeAXUqf
	 UrfQ5zIB+Tdh/lzD5Pit0hUCFGYbwtmNM9RSnMV4=
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
Subject: [PATCH 6.1 000/473] 6.1.93-rc1 review
Date: Thu,  6 Jun 2024 15:58:49 +0200
Message-ID: <20240606131659.786180261@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.93-rc1
X-KernelTest-Deadline: 2024-06-08T13:17+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.93 release.
There are 473 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.93-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.93-rc1

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Set lower bound of start tick time

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: prevent pt_regs corruption for secondary idle threads

Guenter Roeck <linux@roeck-us.net>
    hwmon: (shtc1) Fix property misspelling

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/uaccess: Use YZ asm constraint for ld

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lparcfg: drop error message from guest name lookup

Yue Haibing <yuehaibing@huawei.com>
    ipvlan: Dont Use skb->sk in ipvlan_process_v{4,6}_outbound

Shay Agroskin <shayagr@amazon.com>
    net: ena: Fix redundant device NUMA node override

David Arinzon <darinzon@amazon.com>
    net: ena: Reduce lines with longer column width boundary

David Arinzon <darinzon@amazon.com>
    net: ena: Add dynamic recycling mechanism for rx buffers

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix RGMII error in KSZ DSA driver

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: stm32: Don't warn about spurious interrupts

Arnd Bergmann <arnd@arndb.de>
    drm/i915/guc: avoid FIELD_PREP warning

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix comparison to constant symbols, 'm', 'n'

Eric Garver <eric@garver.life>
    netfilter: nft_fib: allow from forward/input without iif selector

Florian Westphal <fw@strlen.de>
    netfilter: tproxy: bail out if IP has been disabled on the device

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: skbuff vlan metadata mangle support

Florian Westphal <fw@strlen.de>
    netfilter: nft_payload: rebuild vlan header on h_proto access

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: rebuild vlan header when needed

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: move struct nft_payload_set definition where it belongs

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix accounting if a VLAN already exists

Xiaolei Wang <xiaolei.wang@windriver.com>
    net:fec: Add fec_enet_deinit()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Allow delete from sockmap/sockhash only if update is allowed

Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
    net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Read sk->sk_hash under bindlock during bind().

Roded Zats <rzats@paloaltonetworks.com>
    enic: Validate length of nl attributes in enic_set_vf_port

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Adjust G814JZR to use SPI init for amp

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Amend G634 quirk to enable rear speakers

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Add quirk for ASUS ROG G634Z

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Remove debugfs at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: jack: Use guard() for locking

Friedrich Vock <friedrich.vock@gmx.de>
    bpf: Fix potential integer overflow in resolve_btfids

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    dma-buf/sw-sync: don't enable IRQ from sync_print_obj()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix UDP GSO for encapsulated packets

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5e: Fix IPsec tunnel mode offload feature check

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Lag, do bond only if slaves agree on roce state

Mathieu Othacehe <othacehe@gnu.org>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix ns enable/disable possible hang

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: handle NUMA_NO_NODE correctly

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: fix node id validation

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Don't mark message DMA mapped when no transfer in it is

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: restore vlan q-in-q match support

Eric Dumazet <edumazet@google.com>
    netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: Interpret .set_channels() input differently

Henry Wang <xin.wang2@amd.com>
    drivers/xen: Improve the late XenStore init protocol

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    nfc: nci: Fix kcov check in nci_rx_work()

Paolo Abeni <pabeni@redhat.com>
    net: relax socket state check at accept time.

Paolo Abeni <pabeni@redhat.com>
    inet: factor out locked section of inet_accept() in a new helper

Jason Xing <kernelxing@tencent.com>
    tcp: remove 64 KByte limit for initial tp->rcv_wnd value

Dae R. Jeong <threeearcat@gmail.com>
    tls: fix missing memory barrier in tls_init

Wei Fang <wei.fang@nxp.com>
    net: fec: avoid lock evasion when reading pps_enable

Jacob Keller <jacob.e.keller@intel.com>
    Revert "ixgbe: Manual AN-37 for troublesome link partners for X550 SFI"

Matthew Bystrin <dev.mbstr@gmail.com>
    riscv: stacktrace: fixed walk_stackframe()

Guo Ren <guoren@kernel.org>
    riscv: stacktrace: Make walk_stackframe cross pt_regs frame

Jiri Pirko <jiri@nvidia.com>
    virtio: delete vq in vp_find_vqs_msix() when request_irq() fails

Yang Li <yang.lee@linux.alibaba.com>
    rv: Update rv_en(dis)able_monitor doc to match kernel-doc

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    arm64: asm-bug: Add .align 2 to the end of __BUG_ENTRY

Aaron Conole <aconole@redhat.com>
    openvswitch: Set the skbuff pkt_type for proper pmtud support.

Olga Kornievskaia <kolga@netapp.com>
    pNFS/filelayout: fixup pNfs allocation modes

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix shift-out-of-bounds in dctcp_update_alpha().

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix memleak in seg6_hmac_init_algo

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Update unix_sk(sk)->oob_skb under sk_receive_queue lock.

Dan Aloni <dan.aloni@vastdata.com>
    rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL

Dan Aloni <dan.aloni@vastdata.com>
    sunrpc: fix NFSACL RPC retry on soft mount

Martin Kaiser <martin@kaiser.cx>
    nfs: keep server info for remounts

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Fixup smatch warning for ambiguous return

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2552: Add TX path for capturing AUDIO-OUT data

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix uninit-value in nci_rx_work

Taehee Yoo <ap420073@gmail.com>
    selftests: net: kill smcrouted in the cleanup logic in amt.sh

Andrea Mayer <andrea.mayer@uniroma2.it>
    ipv6: sr: fix missing sk_buff release in seg6_input_core

Florian Fainelli <florian.fainelli@broadcom.com>
    net: Always descend into dsa/ folder with CONFIG_NET_DSA enabled

Masahiro Yamada <masahiroy@kernel.org>
    x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y

Namhyung Kim <namhyung@kernel.org>
    perf/arm-dmc620: Fix lockdep assert in ->event_init()

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: bd71828: Don't overwrite runtime voltages

Hsin-Te Yuan <yuanhsinte@chromium.org>
    ASoC: mediatek: mt8192: fix register configuration for tdm

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/cs_dsp_ctl: Use private_free for control cleanup

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: make superblock data array index computation sparse friendly

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails

Rob Clark <robdclark@chromium.org>
    drm/msm: Enable clamp_to_idle for 7c3

Luca Ceresoli <luca.ceresoli@bootlin.com>
    Revert "drm/bridge: ti-sn65dsi83: Fix enable error path"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid confusing "transmit timed out" message

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid recursive cec_claim_log_addrs

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-api: add locking in cec_release()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-adap: always cancel work in cec_transmit_msg_fh

Randy Dunlap <rdunlap@infradead.org>
    media: sunxi: a83-mips-csi2: also select GENERIC_PHY

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the declaration of kasan_map_memory

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for get_thread_reg

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for __switch_mm

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp

Dongliang Mu <mudongliangabcd@gmail.com>
    media: flexcop-usb: fix sanity check of bNumEndpoints

Marek Szyprowski <m.szyprowski@samsung.com>
    Input: cyapa - add missing input core locking to suspend/resume functions

Azeem Shaikh <azeemshaikh38@gmail.com>
    scsi: qla2xxx: Replace all non-returning strlcpy() with strscpy()

Dan Carpenter <dan.carpenter@linaro.org>
    media: stk1160: fix bounds checking in stk1160_copy_video()

Michael Walle <mwalle@kernel.org>
    drm/bridge: tc358775: fix support for jeida-18 and jeida-24

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use variable length array instead of fixed size

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use 64 bit variable to avoid 32 bit overflow

Johannes Berg <johannes.berg@intel.com>
    um: vector: fix bpfflash parameter evaluation

Roberto Sassu <roberto.sassu@huawei.com>
    um: Add winch to winch_handlers before registering winch IRQ

Duoming Zhou <duoming@zju.edu.cn>
    um: Fix return value in ubd_init()

Wojciech Macek <wmacek@chromium.org>
    drm/mediatek: dp: Fix mtk_dp_aux_transfer return value

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: dp: Add support for embedded DisplayPort aux-bus

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    drm/mediatek: dp: Move PHY registration to new function

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Always flush the slave INTF on the CTL

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Print dual-DSI-adjusted pclk instead of original mode pclk

Fenglin Wu <quic_fenglinw@quicinc.com>
    Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Fix ITAPDLY for HS400 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add ITAPDLYSEL in sdhci_j721e_4bit_set_clock

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add OTAP/ITAP delay enable

Vignesh Raghavendra <vigneshr@ti.com>
    mmc: sdhci_am654: Drop lookup for deprecated ti,otap-del-sel

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Write ITAPDLY for DDR52 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add tuning algorithm for delay chain

Karel Balej <balejk@matfyz.cz>
    Input: ioc3kbd - add device table

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Input: ioc3kbd - convert to platform remove callback returning void

Arnd Bergmann <arnd@arndb.de>
    Input: ims-pcu - fix printf string overflow

Sven Schnelle <svens@linux.ibm.com>
    s390/boot: Remove alt_stfle_fac_list from decompressor

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of nvme dump block

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of len fields in nvme reipl block

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: Use standard stack frame layout

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Generate unwind information for C modules

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/vdso64: filter out munaligned-symbols flag for vdso

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/vdso: filter out mno-pic-data-is-text-relative cflag

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix callchain parse error with kernel tracepoint events again

Ian Rogers <irogers@google.com>
    perf stat: Don't display metric header for non-leader uncore events

Chao Yu <chao@kernel.org>
    f2fs: fix to add missing iput() in gc_data_segment()

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    perf daemon: Fix file leak in daemon_session__control

Ian Rogers <irogers@google.com>
    libsubcmd: Fix parse-options memory leak

Wolfram Sang <wsa+renesas@sang-engineering.com>
    serial: sh-sci: protect invalidating RXDMA on shutdown

Chao Yu <chao@kernel.org>
    f2fs: compress: don't allow unaligned truncation on released compress inode

Chao Yu <chao@kernel.org>
    f2fs: fix to release node block count in error path of f2fs_new_node_page()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to update i_compr_blocks correctly

Ian Rogers <irogers@google.com>
    perf report: Avoid SEGV in report__setup_sample_type()

Ian Rogers <irogers@google.com>
    perf ui browser: Avoid SEGV on title

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_LOCATE_DSM with PCI Firmware r3.3

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_DPC_ENABLE_DSM with PCI Firmware r3.3

Randy Dunlap <rdunlap@infradead.org>
    extcon: max8997: select IRQ_DOMAIN instead of depending on it

Ian Rogers <irogers@google.com>
    perf ui browser: Don't save pointer to stack memory

He Zhe <zhe.he@windriver.com>
    perf bench internals inject-build-id: Fix trap divide when collecting just one DSO

Huai-Yuan Liu <qq810974084@gmail.com>
    ppdev: Add an error check in register_device

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ppdev: Remove usage of the deprecated ida_simple_xx() API

Dan Carpenter <dan.carpenter@linaro.org>
    stm class: Fix a double free in stm_register_device()

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Clear uac pointer when freed.

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Fix race condition use of controls after free during gadget unbind.

Chen Ni <nichen@iscas.ac.cn>
    watchdog: sa1100: Fix PTR_ERR_OR_ZERO() vs NULL check in sa1100dog_probe()

Matti Vaittinen <mazziesaccount@gmail.com>
    watchdog: bd9576: Drop "always-running" property

Rafał Miłecki <rafal@milecki.pl>
    dt-bindings: pinctrl: mediatek: mt7622: fix array properties

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    VMCI: Fix an error handling path in vmci_guest_probe_device()

Miklos Szeredi <mszeredi@redhat.com>
    ovl: remove upper umask handling from ovl_create_upper()

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix unassigned instruction op (discovered by MemorySanitizer)

Michal Simek <michal.simek@amd.com>
    microblaze: Remove early printk call from cpuinfo-static.c

Michal Simek <michal.simek@amd.com>
    microblaze: Remove gcc flag for non existing early_printk.c file

Marco Pagani <marpagan@redhat.com>
    fpga: region: add owner module and take its refcount

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix access to resource selector registers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Safe access for TRCQCLTR

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not save/restore Data trace control registers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not hardcode IOMEM access for register restore

Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>
    iio: pressure: dps310: support negative temperature values

Ian Rogers <irogers@google.com>
    perf docs: Document bpf event modifier

Anshuman Khandual <anshuman.khandual@arm.com>
    coresight: etm4x: Fix unbalanced pm_runtime_enable()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: stm32: Fixing err code to not indicate success

Chao Yu <chao@kernel.org>
    f2fs: fix to check pinfile flag in f2fs_move_file_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to relocate check condition in f2fs_fallocate()

Jinyoung CHOI <j-young.choi@samsung.com>
    f2fs: fix typos in comments

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties

Wolfram Sang <wsa+renesas@sang-engineering.com>
    dt-bindings: PCI: rcar-pci-host: Add optional regulators

James Clark <james.clark@arm.com>
    perf tests: Make "test data symbol" more robust on Neoverse N1

Namhyung Kim <namhyung@kernel.org>
    perf test: Add 'datasym' test workload

Namhyung Kim <namhyung@kernel.org>
    perf test: Add 'brstack' test workload

Namhyung Kim <namhyung@kernel.org>
    perf test: Add 'sqrtloop' test workload

Namhyung Kim <namhyung@kernel.org>
    perf test: Add 'leafloop' test workload

Namhyung Kim <namhyung@kernel.org>
    perf test: Add 'thloop' test workload

Namhyung Kim <namhyung@kernel.org>
    perf test: Add -w/--workload option

Xianwei Zhao <xianwei.zhao@amlogic.com>
    arm64: dts: meson: fix S4 power-controller node

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: qcm2290: Fix mas_snoc_bimc QoS port assignment

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: add proper sched.h include for sched_set_fifo()

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix probe path for Endpoint mode

Arnd Bergmann <arnd@arndb.de>
    greybus: arche-ctrl: move device table to its right location

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Fix bitwise types

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Update uart_driver_registered on driver removal

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Lock port->lock when calling uart_handle_cts_change()

Arnd Bergmann <arnd@arndb.de>
    firmware: dmi-id: add a release callback function

Chen Ni <nichen@iscas.ac.cn>
    dmaengine: idma64: Add check for dma_set_max_seg_size

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix invalid PDI offset

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Get rid of duplicate --group option item

Randy Dunlap <rdunlap@infradead.org>
    counter: linux/counter.h: fix Excess kernel-doc description warning

Chao Yu <chao@kernel.org>
    f2fs: fix to wait on page writeback in __clone_blkaddrs()

Chao Yu <chao@kernel.org>
    f2fs: multidev: fix to recognize valid zero block address

Rui Miguel Silva <rmfrfs@gmail.com>
    greybus: lights: check return of get_channel_from_mode

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: core: Leave private pointer NULL when no private data supplied

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Add missing libgen.h header needed for using basename()

Ian Rogers <irogers@google.com>
    perf record: Delete session after stopping sideband thread

Neil Armstrong <neil.armstrong@linaro.org>
    scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW major version > 5

Cheng Yu <serein.chengyu@huawei.com>
    sched/core: Fix incorrect initialization of the 'burst' parameter in cpu_max_write()

Vitalii Bursov <vitaly@bursov.com>
    sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level

Eric Dumazet <edumazet@google.com>
    af_packet: do not call packet_read_pending() from tpacket_destruct_skb()

Eric Dumazet <edumazet@google.com>
    netrom: fix possible dead-lock in nr_rt_ioctl()

Chris Lew <quic_clew@quicinc.com>
    net: qrtr: ns: Fix module refcnt

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: fix vlan use-after-free

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: bridge: increase IGMP/MLD exclude timeout membership interval

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: xmit: make sure we have at least eth header len bytes

Eric Dumazet <edumazet@google.com>
    net: add pskb_may_pull_reason() helper

Leon Romanovsky <leon@kernel.org>
    RDMA/IPoIB: Fix format truncation compilation errors

Edward Liaw <edliaw@google.com>
    selftests/kcmp: remove unused open mode

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix gss_free_in_token_pages()

Dan Carpenter <dan.carpenter@linaro.org>
    ext4: fix potential unnitialized variable

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: remove unused parameter from ext4_mb_new_blocks_simple()

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: try all groups in ext4_mb_new_blocks_simple

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: fix unit mismatch in ext4_mb_new_blocks_simple

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: simplify calculation of blkoff in ext4_mb_new_blocks_simple

Aleksandr Aprelkov <aaprelkov@usergate.com>
    sunrpc: removed redundant procp check

David Hildenbrand <david@redhat.com>
    drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()

Christoph Hellwig <hch@lst.de>
    virt: acrn: stop using follow_pfn

Jan Kara <jack@suse.cz>
    ext4: avoid excessive credit estimate in ext4_tmpfile()

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Add VEX versions of VPDPBUSD, VPDPBUSDS, VPDPWSSD and VPDPWSSDS

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map

Marc Gonzalez <mgonzalez@freebox.fr>
    clk: qcom: mmcc-msm8998: fix venus clock issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm6350: fix DisplayPort clocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8450: fix DisplayPort clocks

Duoming Zhou <duoming@zju.edu.cn>
    lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: r9a07g043: Add clock and reset entry for PLIC

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779a0: Fix CANFD parent clock

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Use __iowrite64_copy() for write combining stores

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix incorrect rxe_put in error path

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Replace pr_xxx by rxe_dbg_xxx in rxe_net.c

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix seg fault in rxe_comp_queue_pkt

Catalin Popescu <catalin.popescu@leica-geosystems.com>
    clk: rs9: fix wrong default value for clock amplitude

Alexandre Mergnat <amergnat@baylibre.com>
    clk: mediatek: mt8365-mm: fix DPI0 parent

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Modify the print level of CQE error

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Use complete parentheses in macros

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix GMV table pagesize

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix UAF for cq async event

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix deadlock on SRQ async events.

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: Fix return value in hns_roce_map_mr_sg

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Adding remote atomic access flag to updatable flags

Jaewon Kim <jaewon02.kim@samsung.com>
    clk: samsung: exynosautov9: fix wrong pll clock id value

Detlev Casanova <detlev.casanova@collabora.com>
    drm/rockchip: vop2: Do not divide height twice for YUV

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/mipi-dsi: use correct return type for the DSC functions

Marek Vasut <marex@denx.de>
    drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/panel: novatek-nt35950: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: dpc3433: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: tc358775: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611uxc: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt8912b: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: icn6211: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: anx7625: Don't log an error when DSI host can't be found

Steven Rostedt <rostedt@goodmis.org>
    ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value

Aleksandr Mishin <amishin@t-argos.ru>
    drm: vc4: Fix possible null pointer dereference

Huai-Yuan Liu <qq810974084@gmail.com>
    drm/arm/malidp: fix a possible null pointer dereference

Zhipeng Lu <alexious@zju.edu.cn>
    media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries

Randy Dunlap <rdunlap@infradead.org>
    fbdev: sh7760fb: allow modular build

Fabio Estevam <festevam@denx.de>
    media: dt-bindings: ovti,ov2680: Fix the power supply names

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Request IRQ earlier

Douglas Anderson <dianders@chromium.org>
    drm/msm/dp: Avoid a long timeout for AUX transfer if nothing connected

Douglas Anderson <dianders@chromium.org>
    drm/msm/dp: Return IRQ_NONE for unhandled interrupts

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: allow voltage swing / pre emphasis of 3

Armin Wolf <W_Armin@gmx.de>
    platform/x86: xiaomi-wmi: Fix race condition when reporting key events

Aleksandr Mishin <amishin@t-argos.ru>
    drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference

Ricardo Ribalda <ribalda@chromium.org>
    media: radio-shark2: Avoid led_names truncations

Arnd Bergmann <arnd@arndb.de>
    media: rcar-vin: work around -Wenum-compare-conditional warning

Aleksandr Burakov <a.burakov@rosalinux.ru>
    media: ngene: Add dvb_ca_en50221_init return value check

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix potential integer overflow

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix ASRC module initialization

Arnd Bergmann <arnd@arndb.de>
    fbdev: sisfb: hide unused variables

Arnd Bergmann <arnd@arndb.de>
    powerpc/fsl-soc: hide unused const variable

Justin Green <greenjustin@chromium.org>
    drm/mediatek: Add 0 size check to mtk_drm_gem_obj

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: vclk: fix calculation of 59.94 fractional rates

Aleksandr Mishin <amishin@t-argos.ru>
    ASoC: kirkwood: Fix potential NULL dereference

Arnd Bergmann <arnd@arndb.de>
    fbdev: shmobile: fix snprintf truncation

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    mtd: rawnand: hynix: fixed typo

Aapo Vienamo <aapo.vienamo@linux.intel.com>
    mtd: core: Report error if first mtd_otp_size() call fails in mtd_otp_nvmem_add()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: ssm4567: Do not ignore route checks

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Disable route checks for Skylake boards

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix potential index out of bounds in color transformation function

Douglas Anderson <dianders@chromium.org>
    drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesn't assert

Douglas Anderson <dianders@chromium.org>
    drm/dp: Don't attempt AUX transfers when eDP panels are not powered

Drew Davenport <ddavenport@chromium.org>
    drm/panel-samsung-atna33xc20: Use ktime_get_boottime for delays

Marek Vasut <marex@denx.de>
    drm/lcdif: Do not disable clocks on already suspended hardware

Geert Uytterhoeven <geert+renesas@glider.be>
    dev_printk: Add and use dev_no_printk()

Geert Uytterhoeven <geert+renesas@glider.be>
    printk: Let no_printk() use _printk()

Jagan Teki <jagan@amarulasolutions.com>
    drm/bridge: Fix improper bridge init order with pre_enable_prev_first

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: qca: Fix error code in qca_read_fw_build_info()

Sebastian Urban <surban@surban.net>
    Bluetooth: compute LE flow credits based on recvbuf space

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Consolidate code around sk_alloc into a helper function

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: SO_KEEPALIVE: fix getsockopt support

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix reference count leak issue of net_device

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix reference count leak issues of ax25_dev

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Use kernel universal linked list to implement ax25_dev_list

Puranjay Mohan <puranjay@kernel.org>
    riscv, bpf: make some atomic operations fully ordered

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Emit a barrier for BPF_FETCH instructions

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Discard command completions in internal error

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Add a timeout to acquire the command queue semaphore

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix invalid unregister error path

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix incorrect unregister order

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: add missing seg6_local_exit

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix overwriting ct original tuple for ICMPv6

Eric Dumazet <edumazet@google.com>
    net: usb: smsc95xx: stop lying about skb->truesize

Breno Leitao <leitao@debian.org>
    af_unix: Fix data races in unix_release_sock/unix_stream_sendmsg

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Locking fixes

Jakub Kicinski <kuba@kernel.org>
    selftests: net: move amt to socat for better compatibility

Jakub Kicinski <kuba@kernel.org>
    eth: sungem: remove .ndo_poll_controller to avoid deadlocks

gaoxingwang <gaoxingwang1@huawei.com>
    net: ipv6: fix wrong start position when receive hop-by-hop fragment

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix reboot hang on Mac IIci

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Fix spinlock race in kernel thread creation

Eric Dumazet <edumazet@google.com>
    net: usb: sr9700: stop lying about skb->truesize

Eric Dumazet <edumazet@google.com>
    usb: aqc111: stop lying about skb->truesize

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Handle "no sensors" in PM operations

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwl8k: initialize cmd->addr[] properly

Robert Richter <rrichter@amd.com>
    x86/numa: Fix SRAT lookup of CFMWS ranges with numa_fill_memblks()

Kent Overstreet <kent.overstreet@linux.dev>
    kernel/numa.c: Move logging out of numa.h

Himanshu Madhani <himanshu.madhani@oracle.com>
    scsi: qla2xxx: Fix debugfs output for fw_resource_count

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: qedf: Ensure the copied buf is NUL terminated

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: bfa: Ensure the copied buf is NUL terminated

Chen Ni <nichen@iscas.ac.cn>
    HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors

Mickaël Salaün <mic@digikod.net>
    kunit: Fix kthread reference

Valentin Obst <kernel@valentinobst.de>
    selftests: default to host arch for LLVM builds

John Hubbard <jhubbard@nvidia.com>
    selftests/resctrl: fix clang build failure: use LOCAL_HDRS

John Hubbard <jhubbard@nvidia.com>
    selftests/binderfs: use the Makefile's rules, not Make's implicit rules

Jiri Olsa <jolsa@kernel.org>
    libbpf: Fix error message in attach_kprobe_multi

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset

Guenter Roeck <linux@roeck-us.net>
    Revert "sh: Handle calling csum_partial with misaligned data"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: ar5523: enable proper endpoint verification

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: carl9170: add a proper sanity check for endpoints

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"

Eric Dumazet <edumazet@google.com>
    net: give more chances to rcu in netdev_wait_allrefs_any()

Hao Chen <chenhao418@huawei.com>
    drivers/perf: hisi: hns3: Actually use devm_add_action_or_reset()

Junhao He <hejunhao3@huawei.com>
    drivers/perf: hisi: hns3: Fix out-of-bound access when valid event group

Junhao He <hejunhao3@huawei.com>
    drivers/perf: hisi_pcie: Fix out-of-bound access when valid event group

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sti: Simplify probe function using devm functions

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sti: Prepare removing pwm_chip from driver data

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sti: Convert to platform remove callback returning void

Eric Dumazet <edumazet@google.com>
    tcp: avoid premature drops in tcp_add_backlog()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: mv88e6xxx: Avoid EEPROM timeout without EEPROM on 88E6250-family switches

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: mv88e6xxx: Add support for model-specific pre- and post-reset handlers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: populate board data for WCN3990

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix a fd leak in error paths in open_netns

Su Hui <suhui@nfschina.com>
    wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()

Aleksandr Mishin <amishin@t-argos.ru>
    thermal/drivers/tsens: Fix null pointer dereference

Ard Biesheuvel <ardb@kernel.org>
    x86/purgatory: Switch to the position-independent small code model

Yuri Karpov <YKarpov@ispras.ru>
    scsi: hpsa: Fix allocation size for Scsi_Host private data

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix the failure of adding phy with zero-address to port

Aleksandr Mishin <amishin@t-argos.ru>
    cppc_cpufreq: Fix possible null pointer dereference

Gabriel Krisman Bertazi <krisman@suse.de>
    udp: Avoid call to compute_score on multiple sites

Lorenz Bauer <lmb@isovalent.com>
    net: remove duplicate reuseport_lookup functions

Lorenz Bauer <lmb@isovalent.com>
    net: export inet_lookup_reuseport and inet6_lookup_reuseport

Juergen Gross <jgross@suse.com>
    x86/pat: Fix W^X violation false-positives when running as Xen PV guest

Juergen Gross <jgross@suse.com>
    x86/pat: Restructure _lookup_address_cpa()

Juergen Gross <jgross@suse.com>
    x86/pat: Introduce lookup_address_in_pgd_attr()

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: exit() callback is optional

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix umount cgroup2 error in test_sockmap

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/64: Clear most of CR4 in startup_64(), except PAE, MCE and LA57

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix "ignore unlock failures after withdraw"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't forget to complete delayed withdraw

Arnd Bergmann <arnd@arndb.de>
    ACPI: disable -Wstringop-truncation

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/loongson-pch-msi: Fix off-by-one on allocation error path

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/alpine-msi: Fix off-by-one in allocation error path

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: LPSS: Advertise number of chip selects via property

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling interrupts

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing CGC enable

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing unipro mode

Abel Vesa <abel.vesa@linaro.org>
    scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing reset bit

Anton Protopopov <aspsk@isovalent.com>
    bpf: Pack struct bpf_fib_lookup

Arnd Bergmann <arnd@arndb.de>
    wifi: carl9170: re-fix fortified-memset warning

Alexander Lobakin <aleksander.lobakin@intel.com>
    bitops: add missing prototype check

Arnd Bergmann <arnd@arndb.de>
    mlx5: stop warning for 64KB pages

Adham Faris <afaris@nvidia.com>
    net/mlx5e: Fail with messages when params are not valid for XSK

Arnd Bergmann <arnd@arndb.de>
    qed: avoid truncating work queue length

Armin Wolf <W_Armin@gmx.de>
    ACPI: Fix Generic Initiator Affinity _OSC bit

Shrikanth Hegde <sshegde@linux.ibm.com>
    sched/fair: Add EAS checks before updating root_domain::overutilized

Guixiong Wei <weiguixiong@bytedance.com>
    x86/boot: Ignore relocations in .notes sections in walk_relocs() too

Yonghong Song <yonghong.song@linux.dev>
    bpftool: Fix missing pids during link show

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't force enable power save on non-running vdevs

Duoming Zhou <duoming@zju.edu.cn>
    wifi: brcmfmac: pcie: handle randbuf allocation failure

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: poll service ready message before failing

Yu Kuai <yukuai3@huawei.com>
    block: support to account io_ticks precisely

Chaitanya Kulkarni <kch@nvidia.com>
    block: open code __blk_account_io_done()

Chaitanya Kulkarni <kch@nvidia.com>
    block: open code __blk_account_io_start()

Yu Kuai <yukuai3@huawei.com>
    md: fix resync softlockup when bitmap size is less than array size

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix missing mutex_destroy() at module removal

Chun-Kuang Hu <chunkuang.hu@kernel.org>
    soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE

Ilya Denisyev <dev@elkcl.ru>
    jffs2: prevent xattr node from overflowing the eraseblock

Maxime Ripard <mripard@kernel.org>
    ARM: configs: sunxi: Enable DRM_DW_HDMI

Nikita Kiryushin <kiryushin@ancud.ru>
    rcu: Fix buffer overflow in print_cpu_stall_info()

Nikita Kiryushin <kiryushin@ancud.ru>
    rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow

Jens Axboe <axboe@kernel.dk>
    io_uring: use the right type for work_llist empty check

Jens Axboe <axboe@kernel.dk>
    io_uring: don't use TIF_NOTIFY_SIGNAL to test for availability of task_work

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix tracepoint subchannel type field

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha512-avx2 - add missing vzeroupper

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha256-avx2 - add missing vzeroupper

Eric Biggers <ebiggers@google.com>
    crypto: x86/nh-avx2 - add missing vzeroupper

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp - drop platform ifdef checks

Al Viro <viro@zeniv.linux.org.uk>
    parisc: add missing export of __cmpxchg_u8()

Arnd Bergmann <arnd@arndb.de>
    nilfs2: fix out-of-range warning

Brian Kubisiak <brian@kubisiak.com>
    ecryptfs: Fix buffer size for tag 66 packet

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    firmware: raspberrypi: Use correct device for DMA mappings

Guenter Roeck <linux@roeck-us.net>
    mm/slub, kunit: Use inverted data to corrupt kmem cache

Aleksandr Mishin <amishin@t-argos.ru>
    crypto: bcm - Fix pointer arithmetic

Eric Sandeen <sandeen@redhat.com>
    openpromfs: finish conversion to the new mount API

Dan Carpenter <dan.carpenter@linaro.org>
    nvmet: prevent sprintf() overflow in nvmet_subsys_nsid_exists()

Linus Torvalds <torvalds@linux-foundation.org>
    epoll: be better about file lifetimes

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix nvme status code when namespace is disabled

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix possible memory leak when tearing down a controller

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-auth: replace pr_debug() with pr_err() to report an error.

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-auth: return the error code to the nvmet_auth_host_hash() callers

Nilay Shroff <nilay@linux.ibm.com>
    nvme: find numa distance only if controller has valid numa id

Linus Torvalds <torvalds@linux-foundation.org>
    x86/mm: Remove broken vsyscall emulation code from the page fault code

Lancelot SIX <lancelot.six@amd.com>
    drm/amdkfd: Flush the process wq before creating a kfd_process

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add VCO speed parameter for DCN31 FPU

Swapnil Patel <swapnil.patel@amd.com>
    drm/amd/display: Add dtbclk access to dcn315

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-dsp-config: harden I2C/I2S codec detection

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: da7219-aad: fix usage of device_get_named_child_node()

Zqiang <qiang.zhang1211@gmail.com>
    softirq: Fix suspicious RCU usage in __do_softirq()

Peter Colberg <peter.colberg@intel.com>
    fpga: dfl-pci: add PCI subdevice ID for Intel D5005 card

Dongli Zhang <dongli.zhang@oracle.com>
    genirq/cpuhotplug, x86/vector: Prevent vector leak during CPU offline

Gerd Hoffmann <kraxel@redhat.com>
    KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID

Hagar Hemdan <hagarhem@amazon.com>
    efi: libstub: only free priv.runtime_map when allocated

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Omit physical KASLR when memory reservations exist

Oliver Upton <oliver.upton@linux.dev>
    KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715-sdca: volume step modification

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715: add vendor clear control register

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: vqmmc-ipq4019: fix module autoloading

Derek Fang <derek.fang@realtek.com>
    ASoC: dt-bindings: rt5645: add cbj sleeve gpio property

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5645: Fix the electric noise due to the CBJ contacts floating

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: irq_helpers: duplicate IRQ name

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Apply Asus T100TA quirk to Asus T100TAM too

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Fix boot crash when maxcpus < first housekeeping CPU

Clément Léger <cleger@rivosinc.com>
    selftests: sud_test: return correct emulated syscall value on RISC-V

Bibo Mao <maobibo@loongson.cn>
    LoongArch: Lately init pmu after smp is online

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu/mes: fix use-after-free issue

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: Fix the ring buffer size for queue VM flush

Felix Kuehling <felix.kuehling@amd.com>
    drm/amdgpu: Update BO eviction priorities

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Set color_mgmt_changed to true on unsuspend

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FN920C04 compositions

Rob Herring <robh@kernel.org>
    dt-bindings: rockchip: grf: Add missing type to 'pcie-phy' node

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class

Richard Kinder <richard.kinder@gmail.com>
    wifi: mac80211: ensure beacon is non-S1G prior to extracting the beacon timestamp field

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't use rate mask for scanning

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: Add missing dependencies of FIPS_SIGNATURE_SELFTEST

Takashi Iwai <tiwai@suse.de>
    ALSA: Fix deadlocks with kctl removals at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix NULL module pointer assignment at card init

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for ProBook 440/460 G11.

Nandor Kracser <bonifaido@gmail.com>
    ksmbd: ignore trailing slashes in share paths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: avoid to send duplicate oplock break notifications

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Break dir enumeration if directory contents error

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix case when index is reused during tree transformation

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Taking DOS names into account during link counting

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Remove max link count info display during driver init

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential hang in nilfs_detach_log_writer()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix unexpected freezing of nilfs_segctor_sync()

Thorsten Blum <thorsten.blum@toblux.com>
    net: smc91x: Fix m68k kernel compilation for ColdFire CPU

Brennan Xavier McManus <bxmcmanus@gmail.com>
    tools/nolibc/stdlib: fix memory error in realloc()

Shuah Khan <skhan@linuxfoundation.org>
    tools/latency-collector: Fix -Wformat-security compile warns

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Fix a race between readers and resize checks

Ken Milmore <ken.milmore@gmail.com>
    r8169: Fix possible ring buffer corruption on fragmented Tx packets.

Heiner Kallweit <hkallweit1@gmail.com>
    Revert "r8169: don't try to disable interrupts if NAPI is, scheduled already"

Ming Lei <ming.lei@redhat.com>
    io_uring: fail NOP if non-zero op flags is passed in

Pin-yen Lin <treapking@chromium.org>
    serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup

Doug Berger <opendmb@gmail.com>
    serial: 8250_bcm7271: use default_mux_rate if possible

Dan Carpenter <dan.carpenter@linaro.org>
    speakup: Fix sizeof() vs ARRAY_SIZE() bug

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing receive state reset after mode switch

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix possible out-of-bounds in gsm0_receive()

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix possible use-after-free issue in ftrace_location()

Daniel J Blueman <daniel@quora.org>
    x86/tsc: Trust initial offset in architectural TSC-adjust MSRs


-------------

Diffstat:

 .../devicetree/bindings/media/i2c/ovti,ov2680.yaml |  18 +-
 .../devicetree/bindings/pci/rcar-pci-host.yaml     |  14 +
 .../bindings/pinctrl/mediatek,mt7622-pinctrl.yaml  |  92 +++---
 .../devicetree/bindings/soc/rockchip/grf.yaml      |   1 +
 Documentation/devicetree/bindings/sound/rt5645.txt |   6 +
 Documentation/driver-api/fpga/fpga-region.rst      |  13 +-
 .../device_drivers/ethernet/amazon/ena.rst         |  32 ++
 Makefile                                           |   4 +-
 arch/arm/configs/sunxi_defconfig                   |   1 +
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi          |  13 +-
 arch/arm64/include/asm/asm-bug.h                   |   1 +
 arch/loongarch/include/asm/perf_event.h            |   3 +-
 arch/loongarch/kernel/perf_event.c                 |   2 +-
 arch/m68k/kernel/entry.S                           |   4 +-
 arch/m68k/mac/misc.c                               |  36 +--
 arch/microblaze/kernel/Makefile                    |   1 -
 arch/microblaze/kernel/cpu/cpuinfo-static.c        |   2 +-
 arch/parisc/kernel/parisc_ksyms.c                  |   1 +
 arch/powerpc/include/asm/hvcall.h                  |   2 +-
 arch/powerpc/include/asm/uaccess.h                 |  11 +
 arch/powerpc/platforms/pseries/lpar.c              |   6 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  10 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/riscv/kernel/cpu_ops_sbi.c                    |   2 +-
 arch/riscv/kernel/cpu_ops_spinwait.c               |   3 +-
 arch/riscv/kernel/entry.S                          |   3 +-
 arch/riscv/kernel/stacktrace.c                     |  29 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  20 +-
 arch/s390/boot/startup.c                           |   1 -
 arch/s390/kernel/ipl.c                             |  10 +-
 arch/s390/kernel/setup.c                           |   2 +-
 arch/s390/kernel/vdso32/Makefile                   |   5 +-
 arch/s390/kernel/vdso64/Makefile                   |   6 +-
 arch/s390/net/bpf_jit_comp.c                       |   8 +-
 arch/sh/kernel/kprobes.c                           |   7 +-
 arch/sh/lib/checksum.S                             |  67 ++---
 arch/um/drivers/line.c                             |  14 +-
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/drivers/vector_kern.c                      |   2 +-
 arch/um/include/asm/kasan.h                        |   1 -
 arch/um/include/asm/mmu.h                          |   2 -
 arch/um/include/asm/processor-generic.h            |   1 -
 arch/um/include/shared/kern_util.h                 |   2 +
 arch/um/include/shared/skas/mm_id.h                |   2 +
 arch/um/os-Linux/mem.c                             |   1 +
 arch/x86/Kconfig.debug                             |   5 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +
 arch/x86/crypto/nh-avx2-x86_64.S                   |   1 +
 arch/x86/crypto/sha256-avx2-asm.S                  |   1 +
 arch/x86/crypto/sha512-avx2-asm.S                  |   1 +
 arch/x86/entry/vsyscall/vsyscall_64.c              |  28 +-
 arch/x86/include/asm/pgtable_types.h               |   2 +
 arch/x86/include/asm/processor.h                   |   1 -
 arch/x86/include/asm/sparsemem.h                   |   2 -
 arch/x86/kernel/apic/vector.c                      |   9 +-
 arch/x86/kernel/tsc_sync.c                         |   6 +-
 arch/x86/kvm/cpuid.c                               |  21 +-
 arch/x86/lib/x86-opcode-map.txt                    |  10 +-
 arch/x86/mm/fault.c                                |  33 +--
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/mm/pat/set_memory.c                       |  68 ++++-
 arch/x86/purgatory/Makefile                        |   3 +-
 arch/x86/tools/relocs.c                            |   9 +
 arch/x86/um/shared/sysdep/archsetjmp.h             |   7 +
 block/blk-core.c                                   |   9 +-
 block/blk-merge.c                                  |   2 +
 block/blk-mq.c                                     |  60 ++--
 block/blk.h                                        |   1 +
 block/genhd.c                                      |   2 +-
 crypto/asymmetric_keys/Kconfig                     |   2 +
 drivers/accessibility/speakup/main.c               |   2 +-
 drivers/acpi/acpi_lpss.c                           |   1 +
 drivers/acpi/acpica/Makefile                       |   1 +
 drivers/acpi/numa/srat.c                           |   5 +
 drivers/block/null_blk/main.c                      |   3 +
 drivers/bluetooth/btqca.c                          |   4 +-
 drivers/char/ppdev.c                               |  21 +-
 drivers/clk/clk-renesas-pcie.c                     |  10 +-
 drivers/clk/mediatek/clk-mt8365-mm.c               |   2 +-
 drivers/clk/qcom/dispcc-sm6350.c                   |  11 +-
 drivers/clk/qcom/dispcc-sm8450.c                   |  20 +-
 drivers/clk/qcom/mmcc-msm8998.c                    |   8 +
 drivers/clk/renesas/r8a779a0-cpg-mssr.c            |   2 +-
 drivers/clk/renesas/r9a07g043-cpg.c                |   9 +
 drivers/clk/samsung/clk-exynosautov9.c             |   8 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/cpufreq/cpufreq.c                          |  11 +-
 drivers/crypto/bcm/spu2.c                          |   2 +-
 drivers/crypto/ccp/sp-platform.c                   |  14 +-
 drivers/dma-buf/sync_debug.c                       |   4 +-
 drivers/dma/idma64.c                               |   4 +-
 drivers/extcon/Kconfig                             |   3 +-
 drivers/firmware/dmi-id.c                          |   7 +-
 drivers/firmware/efi/libstub/fdt.c                 |   4 +-
 drivers/firmware/efi/libstub/x86-stub.c            |  28 +-
 drivers/firmware/raspberrypi.c                     |   7 +-
 drivers/fpga/dfl-pci.c                             |   3 +
 drivers/fpga/fpga-region.c                         |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 -
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   8 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../amd/display/dc/clk_mgr/dcn315/dcn315_clk_mgr.c |   8 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   5 +
 .../gpu/drm/amd/display/dc/dml/dcn31/dcn31_fpu.c   |   2 +
 drivers/gpu/drm/arm/malidp_mw.c                    |   5 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   3 +
 drivers/gpu/drm/bridge/chipone-icn6211.c           |   6 +-
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |   6 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   6 +-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/bridge/tc358775.c                  |  27 +-
 drivers/gpu/drm/bridge/ti-dlpc3433.c               |  17 +-
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   1 -
 drivers/gpu/drm/display/drm_dp_helper.c            |  35 +++
 drivers/gpu/drm/drm_bridge.c                       |  10 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h      |   6 +-
 drivers/gpu/drm/mediatek/Kconfig                   |   1 +
 drivers/gpu/drm/mediatek/mtk_dp.c                  | 137 +++++++--
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   3 +
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |  17 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |   3 -
 drivers/gpu/drm/msm/dp/dp_aux.c                    |  32 +-
 drivers/gpu/drm/msm/dp/dp_aux.h                    |   3 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |  16 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.h                   |   2 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |  12 +-
 drivers/gpu/drm/msm/dp/dp_link.c                   |  22 +-
 drivers/gpu/drm/msm/dp/dp_link.h                   |  14 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  10 +-
 drivers/gpu/drm/mxsfb/lcdif_drv.c                  |   6 +-
 drivers/gpu/drm/panel/panel-edp.c                  |   3 +
 drivers/gpu/drm/panel/panel-novatek-nt35950.c      |   6 +-
 drivers/gpu/drm/panel/panel-samsung-atna33xc20.c   |  32 +-
 drivers/gpu/drm/panel/panel-simple.c               |   3 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  22 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   2 +
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |  10 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   5 +
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  29 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |  31 +-
 drivers/hwtracing/stm/core.c                       |  11 +-
 drivers/iio/adc/stm32-adc.c                        |   1 +
 drivers/iio/industrialio-core.c                    |   6 +-
 drivers/iio/pressure/dps310.c                      |  11 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  24 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  12 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   7 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   1 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  15 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   6 +-
 drivers/infiniband/hw/mlx5/mem.c                   |   8 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   3 +-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   6 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  46 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   8 +-
 drivers/input/misc/ims-pcu.c                       |   4 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   7 +-
 drivers/input/mouse/cyapa.c                        |  12 +-
 drivers/input/serio/ioc3kbd.c                      |  13 +-
 drivers/interconnect/qcom/qcm2290.c                |   2 +-
 drivers/irqchip/irq-alpine-msi.c                   |   2 +-
 drivers/irqchip/irq-loongson-pch-msi.c             |   2 +-
 drivers/macintosh/via-macii.c                      |  11 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/media/cec/core/cec-adap.c                  |  24 +-
 drivers/media/cec/core/cec-api.c                   |   5 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c      |  10 +-
 drivers/media/pci/ngene/ngene-core.c               |   4 +-
 drivers/media/platform/renesas/rcar-vin/rcar-vin.h |   2 +-
 .../platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig    |   1 +
 drivers/media/radio/radio-shark2.c                 |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |  20 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |  10 +-
 drivers/mmc/host/sdhci_am654.c                     | 205 +++++++++----
 drivers/mtd/mtdcore.c                              |   6 +-
 drivers/mtd/nand/raw/nand_hynix.c                  |   2 +-
 drivers/net/Makefile                               |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  50 +++-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   6 +
 drivers/net/dsa/mv88e6xxx/global1.c                |  89 ++++++
 drivers/net/dsa/mv88e6xxx/global1.h                |   2 +
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h   |   6 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          | 326 +++++++--------------
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |  49 ++--
 drivers/net/ethernet/amazon/ena/ena_eth_com.h      |  15 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       | 160 ++++++----
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   4 +
 drivers/net/ethernet/cisco/enic/enic_main.c        |  12 +
 drivers/net/ethernet/cortina/gemini.c              |  12 +-
 drivers/net/ethernet/freescale/fec_main.c          |  10 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  14 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  19 +-
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c  |  11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |  56 +---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  46 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  23 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  12 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   9 +-
 drivers/net/ethernet/smsc/smc91x.h                 |   4 +-
 drivers/net/ethernet/sun/sungem.c                  |  14 -
 drivers/net/ipvlan/ipvlan_core.c                   |   4 +-
 drivers/net/phy/micrel.c                           |   1 +
 drivers/net/usb/aqc111.c                           |   8 +-
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/usb/smsc95xx.c                         |  26 +-
 drivers/net/usb/sr9700.c                           |  10 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  14 +
 drivers/net/wireless/ath/ath10k/core.c             |   3 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  26 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   9 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   3 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  32 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  15 +-
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   1 +
 drivers/nvme/host/multipath.c                      |   3 +-
 drivers/nvme/target/auth.c                         |   8 +-
 drivers/nvme/target/configfs.c                     |  20 ++
 drivers/nvme/target/core.c                         |   5 +-
 drivers/nvme/target/nvmet.h                        |   1 +
 drivers/nvme/target/tcp.c                          |  11 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   3 +
 drivers/pci/pcie/edr.c                             |  28 +-
 drivers/perf/arm_dmc620_pmu.c                      |   9 +-
 drivers/perf/hisilicon/hisi_pcie_pmu.c             |  14 +-
 drivers/perf/hisilicon/hns3_pmu.c                  |  16 +-
 drivers/platform/x86/xiaomi-wmi.c                  |  18 ++
 drivers/pwm/pwm-sti.c                              |  48 +--
 drivers/regulator/bd71828-regulator.c              |  58 +---
 drivers/regulator/irq_helpers.c                    |   3 +
 drivers/regulator/vqmmc-ipq4019-regulator.c        |   1 +
 drivers/s390/cio/trace.h                           |   2 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   4 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |   3 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   8 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |  20 +-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   5 +-
 drivers/soundwire/cadence_master.c                 |   2 +-
 drivers/spi/spi-stm32.c                            |   2 +-
 drivers/spi/spi.c                                  |   4 +
 drivers/staging/greybus/arche-apb-ctrl.c           |   1 +
 drivers/staging/greybus/arche-platform.c           |   9 +-
 drivers/staging/greybus/light.c                    |   8 +-
 drivers/staging/media/atomisp/pci/sh_css.c         |   1 +
 drivers/thermal/qcom/tsens.c                       |   2 +-
 drivers/tty/n_gsm.c                                | 140 ++++++---
 drivers/tty/serial/8250/8250_bcm7271.c             |  99 ++++---
 drivers/tty/serial/8250/8250_mtk.c                 |   8 +-
 drivers/tty/serial/max3100.c                       |  22 +-
 drivers/tty/serial/sc16is7xx.c                     |   2 +-
 drivers/tty/serial/sh-sci.c                        |   5 +
 drivers/ufs/core/ufshcd.c                          |   4 +-
 drivers/ufs/host/cdns-pltfrm.c                     |   2 +-
 drivers/ufs/host/ufs-qcom.c                        |  13 +-
 drivers/ufs/host/ufs-qcom.h                        |  21 +-
 drivers/usb/gadget/function/u_audio.c              |  21 +-
 drivers/video/fbdev/Kconfig                        |   4 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   2 +-
 drivers/video/fbdev/sis/init301.c                  |   3 +-
 drivers/virt/acrn/mm.c                             |  61 +++-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/bd9576_wdt.c                      |  12 +-
 drivers/watchdog/sa1100_wdt.c                      |   5 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  36 ++-
 fs/ecryptfs/keystore.c                             |   4 +-
 fs/eventpoll.c                                     |  38 ++-
 fs/ext4/mballoc.c                                  | 134 ++++-----
 fs/ext4/namei.c                                    |   2 +-
 fs/f2fs/checkpoint.c                               |   4 +-
 fs/f2fs/compress.c                                 |   2 +-
 fs/f2fs/data.c                                     |  10 +-
 fs/f2fs/extent_cache.c                             |   4 +-
 fs/f2fs/file.c                                     |  96 +++---
 fs/f2fs/gc.c                                       |   9 +-
 fs/f2fs/namei.c                                    |   2 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |   2 +-
 fs/gfs2/glock.c                                    |   4 +-
 fs/gfs2/glops.c                                    |   3 +
 fs/gfs2/util.c                                     |   1 -
 fs/jffs2/xattr.c                                   |   3 +
 fs/nfs/filelayout/filelayout.c                     |   4 +-
 fs/nfs/fs_context.c                                |   9 +-
 fs/nfs/nfs4state.c                                 |  12 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/segment.c                                |  38 ++-
 fs/nilfs2/the_nilfs.c                              |  20 +-
 fs/ntfs3/dir.c                                     |   1 +
 fs/ntfs3/fslog.c                                   |   3 +-
 fs/ntfs3/index.c                                   |   6 +
 fs/ntfs3/inode.c                                   |   7 +-
 fs/ntfs3/ntfs.h                                    |   2 +-
 fs/ntfs3/record.c                                  |  11 +-
 fs/ntfs3/super.c                                   |   2 -
 fs/openpromfs/inode.c                              |   8 +-
 fs/overlayfs/dir.c                                 |   3 -
 fs/smb/server/mgmt/share_config.c                  |   6 +-
 fs/smb/server/oplock.c                             |  21 +-
 include/drm/display/drm_dp_helper.h                |   6 +
 include/drm/drm_mipi_dsi.h                         |   6 +-
 include/linux/acpi.h                               |   2 +-
 include/linux/bitops.h                             |   1 +
 include/linux/counter.h                            |   1 -
 include/linux/dev_printk.h                         |  25 +-
 include/linux/fpga/fpga-region.h                   |  13 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/numa.h                               |  26 +-
 include/linux/printk.h                             |   2 +-
 include/linux/skbuff.h                             |  19 +-
 include/media/cec.h                                |   1 +
 include/net/ax25.h                                 |   3 +-
 include/net/bluetooth/bluetooth.h                  |   2 +
 include/net/bluetooth/l2cap.h                      |  11 +-
 include/net/inet6_hashtables.h                     |  16 +
 include/net/inet_common.h                          |   2 +
 include/net/inet_hashtables.h                      |  18 +-
 include/net/mac80211.h                             |   3 +
 include/net/netfilter/nf_tables_core.h             |  10 -
 include/trace/events/asoc.h                        |   2 +
 include/uapi/linux/bpf.h                           |   2 +-
 io_uring/io_uring.h                                |   3 +-
 io_uring/nop.c                                     |   2 +
 kernel/Makefile                                    |   1 +
 kernel/bpf/verifier.c                              |  10 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/dma/map_benchmark.c                         |   6 +-
 kernel/irq/cpuhotplug.c                            |  16 +-
 kernel/numa.c                                      |  26 ++
 kernel/rcu/tasks.h                                 |   2 +-
 kernel/rcu/tree_stall.h                            |   3 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/fair.c                                |  53 ++--
 kernel/sched/isolation.c                           |   7 +-
 kernel/sched/topology.c                            |   2 +-
 kernel/softirq.c                                   |  12 +-
 kernel/trace/ftrace.c                              |  39 ++-
 kernel/trace/ring_buffer.c                         |   9 +
 kernel/trace/rv/rv.c                               |   2 +
 lib/kunit/try-catch.c                              |   9 +-
 lib/slub_kunit.c                                   |   2 +-
 lib/test_hmm.c                                     |   8 +-
 net/ax25/ax25_dev.c                                |  48 +--
 net/bluetooth/af_bluetooth.c                       |  21 ++
 net/bluetooth/bnep/sock.c                          |  10 +-
 net/bluetooth/hci_sock.c                           |  10 +-
 net/bluetooth/iso.c                                |  10 +-
 net/bluetooth/l2cap_core.c                         |  56 +++-
 net/bluetooth/l2cap_sock.c                         |  99 +++++--
 net/bluetooth/rfcomm/sock.c                        |  13 +-
 net/bluetooth/sco.c                                |  10 +-
 net/bridge/br_device.c                             |   6 +
 net/bridge/br_mst.c                                |  16 +-
 net/core/dev.c                                     |   3 +-
 net/ipv4/af_inet.c                                 |  34 ++-
 net/ipv4/inet_hashtables.c                         |  29 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +
 net/ipv4/tcp_dctcp.c                               |  13 +-
 net/ipv4/tcp_ipv4.c                                |  13 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv4/udp.c                                     |  55 ++--
 net/ipv6/inet6_hashtables.c                        |  27 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/ipv6/seg6.c                                    |   5 +-
 net/ipv6/seg6_hmac.c                               |  42 ++-
 net/ipv6/seg6_iptunnel.c                           |  11 +-
 net/ipv6/udp.c                                     |  61 ++--
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/rate.c                                |   6 +-
 net/mac80211/scan.c                                |   1 +
 net/mac80211/tx.c                                  |  13 +-
 net/mptcp/sockopt.c                                |   2 -
 net/netfilter/nfnetlink_queue.c                    |   2 +
 net/netfilter/nft_fib.c                            |   8 +-
 net/netfilter/nft_payload.c                        | 111 +++++--
 net/netrom/nr_route.c                              |  19 +-
 net/nfc/nci/core.c                                 |  17 +-
 net/openvswitch/actions.c                          |   6 +
 net/openvswitch/flow.c                             |   3 +-
 net/packet/af_packet.c                             |   3 +-
 net/qrtr/ns.c                                      |  27 ++
 net/sunrpc/auth_gss/svcauth_gss.c                  |  10 +-
 net/sunrpc/clnt.c                                  |   1 +
 net/sunrpc/svc.c                                   |   2 -
 net/sunrpc/xprtrdma/verbs.c                        |   6 +-
 net/tls/tls_main.c                                 |  10 +-
 net/unix/af_unix.c                                 |  39 ++-
 net/wireless/trace.h                               |   4 +-
 scripts/kconfig/symbol.c                           |   6 +-
 sound/core/init.c                                  |  20 +-
 sound/core/jack.c                                  |  46 ++-
 sound/core/timer.c                                 |  10 +
 sound/hda/intel-dsp-config.c                       |  27 +-
 sound/pci/hda/hda_cs_dsp_ctl.c                     |  47 ++-
 sound/pci/hda/patch_realtek.c                      |  16 +-
 sound/soc/codecs/da7219-aad.c                      |   6 +-
 sound/soc/codecs/rt5645.c                          |  25 ++
 sound/soc/codecs/rt715-sdca.c                      |   8 +-
 sound/soc/codecs/rt715-sdw.c                       |   1 +
 sound/soc/codecs/tas2552.c                         |  15 +-
 sound/soc/intel/avs/boards/ssm4567.c               |   1 -
 sound/soc/intel/avs/cldma.c                        |   2 +-
 sound/soc/intel/avs/path.c                         |   1 +
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/bxt_rt298.c                 |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  24 +-
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |   2 +
 sound/soc/intel/boards/kbl_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/kbl_da7219_max98927.c       |   4 +
 sound/soc/intel/boards/kbl_rt5660.c                |   1 +
 sound/soc/intel/boards/kbl_rt5663_max98927.c       |   2 +
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   1 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   2 +
 sound/soc/intel/boards/skl_nau88l25_max98357a.c    |   1 +
 sound/soc/intel/boards/skl_rt286.c                 |   1 +
 sound/soc/kirkwood/kirkwood-dma.c                  |   3 +
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c         |   4 +-
 tools/arch/x86/lib/x86-opcode-map.txt              |  10 +-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |   4 +-
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/include/nolibc/stdlib.h                      |   2 +-
 tools/include/uapi/linux/bpf.h                     |   2 +-
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/lib/subcmd/parse-options.c                   |   8 +-
 tools/perf/Documentation/perf-list.txt             |   1 +
 tools/perf/bench/inject-buildid.c                  |   2 +-
 tools/perf/builtin-annotate.c                      |   2 -
 tools/perf/builtin-daemon.c                        |   4 +-
 tools/perf/builtin-record.c                        |   4 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/tests/Build                             |   2 +
 tools/perf/tests/builtin-test.c                    |  29 ++
 tools/perf/tests/tests.h                           |  27 ++
 tools/perf/tests/workloads/Build                   |  13 +
 tools/perf/tests/workloads/brstack.c               |  40 +++
 tools/perf/tests/workloads/datasym.c               |  40 +++
 tools/perf/tests/workloads/leafloop.c              |  34 +++
 tools/perf/tests/workloads/noploop.c               |  32 ++
 tools/perf/tests/workloads/sqrtloop.c              |  45 +++
 tools/perf/tests/workloads/thloop.c                |  53 ++++
 tools/perf/ui/browser.c                            |   6 +-
 tools/perf/ui/browser.h                            |   2 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   2 +
 tools/perf/util/intel-pt.c                         |   2 +
 tools/perf/util/probe-event.c                      |   1 +
 tools/perf/util/stat-display.c                     |   3 +
 tools/testing/selftests/bpf/network_helpers.c      |   2 +
 tools/testing/selftests/bpf/test_sockmap.c         |   2 +-
 .../selftests/filesystems/binderfs/Makefile        |   2 -
 tools/testing/selftests/kcmp/kcmp_test.c           |   2 +-
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |  50 ++++
 tools/testing/selftests/lib.mk                     |  12 +-
 tools/testing/selftests/net/amt.sh                 |  20 +-
 .../selftests/net/forwarding/bridge_igmp.sh        |   6 +-
 .../testing/selftests/net/forwarding/bridge_mld.sh |   6 +-
 tools/testing/selftests/resctrl/Makefile           |   4 +-
 .../selftests/syscall_user_dispatch/sud_test.c     |  14 +
 tools/tracing/latency/latency-collector.c          |   8 +-
 480 files changed, 4208 insertions(+), 2400 deletions(-)


