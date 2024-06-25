Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BFDFBEF;
	Tue, 25 Jun 2024 09:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308182; cv=none; b=me2/rEoMPW0433ukKrjPBs7H5ho89qiyJKk1+GKskuWEG2vpnWkQ7lRqOS/C91E7CsDs4e6cb7SsB9HtsSMwXzUqLenfuJzzomRsKfpiS3A556sxElpOMcc5NyaCD3Cfb+LSY/daK2CipUzPAUuSKvvb1cMCYD2xq0Tm+AvIqNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308182; c=relaxed/simple;
	bh=anBPENRf1POq31wQykTkXO828kiaHprzpVK+7Z/0YaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e+eNxcmVGkpvex+U7gvD5lM6X5Vppg84sV13WelGeLuTz5J2b1SVLy5yKkzbpFdtmqeISQ1Y2u7iDIaG/vSVZGADiGv65nfl6hPwIhB7xYfjKb1i9F9/npRMykm4zG/VsS+1R2UK0cWkBbWqyrcpGlynlnt70qwrdx7in4ULr3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apU6e5nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apU6e5nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E087BC32781;
	Tue, 25 Jun 2024 09:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308182;
	bh=anBPENRf1POq31wQykTkXO828kiaHprzpVK+7Z/0YaE=;
	h=From:To:Cc:Subject:Date:From;
	b=apU6e5nr++T6ndMD9zB/Hx3MRLY1Qv1mm3Vx3tncuUZ0K3RfhE3Tm4AAgYnohEVJZ
	 mrTAmF50fLY12QZId2SohRXVq12CQMcDkkqNwc82IbkVu/286nz5rpKPnoWLvNszlb
	 M+zS1fGoGvycf/2Z6+bkOG53r0/ZkVd+9869qaEM=
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
Subject: [PATCH 6.9 000/250] 6.9.7-rc1 review
Date: Tue, 25 Jun 2024 11:29:18 +0200
Message-ID: <20240625085548.033507125@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.7-rc1
X-KernelTest-Deadline: 2024-06-27T08:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.7 release.
There are 250 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.7-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default"

Andrew Ballance <andrewjballance@gmail.com>
    hid: asus: asus_report_fixup: fix potential read out of bounds

Linus Torvalds <torvalds@linux-foundation.org>
    kprobe/ftrace: fix build error due to bad function definition

Davide Caratti <dcaratti@redhat.com>
    net/sched: unregister lockdep keys in qdisc_create/qdisc_alloc error path

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof-sdw: really remove FOUR_SPEAKER quirk

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: check M3 buffer size as well whey trying to reuse it

Martin Leung <martin.leung@amd.com>
    drm/amd/display: revert Exit idle optimizations before HDCP execution

Tony Luck <tony.luck@intel.com>
    x86/cpu: Fix x86_match_cpu() to match just X86_VENDOR_INTEL

Tony Luck <tony.luck@intel.com>
    x86/cpu/vfm: Add new macros to work with (vendor/family/model) values

Jeff Johnson <quic_jjohnson@quicinc.com>
    tracing: Add MODULE_DESCRIPTION() to preemptirq_delay_test

Bart Van Assche <bvanassche@acm.org>
    nbd: Fix signal handling

Bart Van Assche <bvanassche@acm.org>
    nbd: Improve the documentation of the locking assumptions

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Use ordered WQ for G2H handler

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32: qspi: Clamp stm32_qspi_get_mode() output to CCR_BUSWIDTH_4

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Change PM notifier priority to the minimum

Frank Li <Frank.Li@nxp.com>
    arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32: qspi: Fix dual flash mode sanity test in stm32_qspi_setup()

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal: int340x: processor_thermal: Support shared interrupts

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema

Paolo Bonzini <pbonzini@redhat.com>
    virt: guest_memfd: fix reference leak on hwpoisoned page

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema

Grygorii Tertychnyi <grembeter@gmail.com>
    i2c: ocores: set IACK bit after core is enabled

GUO Zihua <guozihua@huawei.com>
    ima: Avoid blocking in RCU read-side critical section

Peter Xu <peterx@redhat.com>
    mm/page_table_check: fix crash on ZONE_DEVICE

Eric Dumazet <edumazet@google.com>
    tcp: clear tp->retrans_stamp in tcp_rcv_fastopen_synack()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: userspace_pm: fixed subtest names

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: fix getting incorrect lruvec when replacing a shmem folio

Ran Xiaokai <ran.xiaokai@zte.com.cn>
    mm: huge_memory: fix misused mapping_large_folio_support() for anon folios

Rafael Aquini <aquini@redhat.com>
    mm: mmap: allow for the maximum number of bits for randomizing mmap_base by default

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: mipsmtregs: Fix target register for MFTC0

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: 8250_dw: Revert "Move definitions to the shared header"

Ard Biesheuvel <ardb@kernel.org>
    efi/x86: Free EFI memory map only when installing a new one.

Aleksandr Nogikh <nogikh@google.com>
    kcov: don't lose track of remote references during softirqs

Peter Oberparleiter <oberpar@linux.ibm.com>
    gcov: add support for GCC 14

Dmitry Safonov <0x7f454c46@gmail.com>
    net/tcp_ao: Don't leak ao_info on error-path

Louis Chauvet <louis.chauvet@bootlin.com>
    dmaengine: xilinx: xdma: Fix data synchronisation in xdma_channel_isr()

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Do not enable LPM if no LPM states are supported by the HBA

Bart Van Assche <bvanassche@acm.org>
    scsi: usb: uas: Do not query the IO Advice Hints Grouping mode page for USB/UAS devices

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix NULL pointer dereference in ocfs2_abort_trigger()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix NULL pointer dereference in ocfs2_journal_dirty()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: dma: fsl-edma: fix dma-channels constraints

Michael Strauss <michael.strauss@amd.com>
    drm/amd/display: Attempt to avoid empty TUs when endpoint is DPIA

Roman Li <roman.li@amd.com>
    drm/amd/display: Remove redundant idle optimization check

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu: fix locking scope when flushing tlb

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: fix UBSAN warning in kv_dpm.c

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix UBSAN warning in kv_dpm.c

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mso: using joiner is not possible with eDP MSO

Pablo Caño <pablocpascual@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14AHP9

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on N14AP7

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for ProBook 445/465 G11.

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix monitor channel with chanctx emulation

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix encoding fid for lower only root

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Ensure created mkeys always have a populated rb_key

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Follow rb_key.ats when creating new mkeys

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Remove extra unlock on error path

Honggang LI <honggangli@163.com>
    RDMA/rxe: Fix data copy for IB_SEND_INLINE

Sean Christopherson <seanjc@google.com>
    KVM: x86: Always sync PIR to IRR prior to scanning I/O APIC routes

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Disassociate vcpus from redistributor region on teardown

Breno Leitao <leitao@debian.org>
    KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()

Hui Li <lihui@loongson.cn>
    LoongArch: Fix multiple hardware watchpoint issues

Hui Li <lihui@loongson.cn>
    LoongArch: Trigger user-space watchpoints correctly

Hui Li <lihui@loongson.cn>
    LoongArch: Fix watchpoint setting error

Steve French <stfrench@microsoft.com>
    cifs: fix typo in module parameter enable_gcm_256

Joel Slebodnick <jslebodn@redhat.com>
    scsi: ufs: core: Free memory allocated for model before reinit

Boris Burkov <boris@bur.io>
    btrfs: retry block group reclaim without infinite loop

Ignat Korchagin <ignat@cloudflare.com>
    net: do not leave a dangling sk pointer, when socket creation fails

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: dp83tg720: get master/slave configuration in link down state

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: improve reset check

Oleksij Rempel <o.rempel@pengutronix.de>
    net: stmmac: Assign configured channel value to EXTTS event

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: dp83tg720: wake up PHYs in managed mode

Baokun Li <libaokun1@huawei.com>
    ext4: fix slab-out-of-bounds in ext4_mb_find_good_group_avg_frag_lists()

Baokun Li <libaokun1@huawei.com>
    ext4: avoid overflow when setting values via sysfs

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Evaluate orphan _REG under EC device

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Ignore optional access flags for MRs

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Add check for srq max_sge attribute

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Fix unwind flow as part of mlx5_ib_stage_init_init

Xi Ruoyao <xry111@xry111.site>
    LoongArch: Only allow OBJTOOL & ORC unwinder if toolchain supports -mthin-add-sub

Sudeep Holla <sudeep.holla@arm.com>
    firmware: psci: Fix return value from psci_system_suspend()

Chenliang Li <cliang01.li@samsung.com>
    io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/vf: Don't touch GuC irq registers if using memory irqs

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-imx: imx51: revert burst length calculation back to bits_per_word

Dave Martin <Dave.Martin@arm.com>
    x86/resctrl: Don't try to free nonexistent RMIDs

Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
    spi: Fix SPI slave probe failure

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Ignore camera graph port nodes on all Dell Tiger, Alder and Raptor Lake models

Raju Rangoju <Raju.Rangoju@amd.com>
    ACPICA: Revert "ACPICA: avoid Info: mapping multiple BARs. Your kernel is fine."

Max Krummenacher <max.krummenacher@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: enable hysteresis on slow input pin

Fabio Estevam <festevam@gmail.com>
    arm64: dts: imx93-11x11-evk: Remove the 'no-sdio' property

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: freescale: imx8mp-venice-gw73xx-2x: fix BT shutdown GPIO

Liu Ying <victor.liu@nxp.com>
    arm: dts: imx53-qsb-hdmi: Disable panel instead of deleting node

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mp: Fix TC9595 input clock on DH i.MX8M Plus DHCOM SoM

Julien Panis <jpanis@baylibre.com>
    thermal/drivers/mediatek/lvts_thermal: Return error in case of invalid efuse data

Kalle Niemi <kaleposti@gmail.com>
    regulator: bd71815: fix ramp values

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix missing kmem_cache_destroy()

Arnd Bergmann <arnd@arndb.de>
    dmaengine: fsl-edma: avoid linking both modules

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix kmemleak in ioat_pci_probe()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix error path in ioat3_dma_probe()

Nikita Shubin <n.shubin@yadro.com>
    dmaengine: ioatdma: Fix leaking on version mismatch

Siddharth Vadapalli <s-vadapalli@ti.com>
    dmaengine: ti: k3-udma-glue: Fix of_k3_udma_glue_parse_chn_by_id()

Li RongQing <lirongqing@baidu.com>
    dmaengine: idxd: Fix possible Use-After-Free in irq_process_work_list

Biju Das <biju.das.jz@bp.renesas.com>
    regulator: core: Fix modpost error "regulator_get_regmap" undefined

Honggang LI <honggangli@163.com>
    RDMA/rxe: Fix responder length checking for UD request packets

Charles Keepax <ckeepax@opensource.cirrus.com>
    spi: cs42l43: Correct SPI root clock speed

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/crypto: Add generated P8 asm to .gitignore

Abel Vesa <abel.vesa@linaro.org>
    phy: qcom: qmp-combo: Switch from V6 to V6 N4 register offsets

Abel Vesa <abel.vesa@linaro.org>
    phy: qcom-qmp: pcs: Add missing v6 N4 register offsets

Abel Vesa <abel.vesa@linaro.org>
    phy: qcom-qmp: qserdes-txrx: Add missing registers offsets

Joao Paulo Goncalves <joao.goncalves@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: Fix GPU speed

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix the max msix vectors macro

Oliver Neukum <oneukum@suse.com>
    net: usb: rtl8150 fix unintiatilzed variables in rtl8150_get_link_ksettings

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Restore PTP tx_avail count in case of skb_pad() error

Marcin Szycik <marcin.szycik@linux.intel.com>
    ice: Fix VSI list rule with ICE_SW_LKUP_LAST type

Jianguo Wu <wujianguo@chinatelecom.cn>
    netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core

Jianguo Wu <wujianguo@chinatelecom.cn>
    seg6: fix parameter passing when calling NF_HOOK() in End.DX4 and End.DX6 behaviors

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: Fix suspicious rcu_dereference_protected()

Geetha sowjanya <gakula@marvell.com>
    octeontx2-pf: Fix linking objects into multiple modules

Simon Horman <horms@kernel.org>
    octeontx2-pf: Add error handling to VLAN unoffload handling

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: fixing XDP for fully checksummed packets handling

Heng Qi <hengqi@linux.alibaba.com>
    virtio_net: checksum offloading handling fix

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: No need to calculate speed divider when offload is disabled

Simon Horman <horms@kernel.org>
    selftests: openvswitch: Use bash as interpreter

Dan Carpenter <dan.carpenter@linaro.org>
    ptp: fix integer overflow in max_vclocks_store

Xin Long <lucien.xin@gmail.com>
    sched: act_ct: add netns into the key of tcf_ct_flow_table

Xin Long <lucien.xin@gmail.com>
    tipc: force a dst refcount before doing decryption

David Ruth <druth@chromium.org>
    net/sched: act_api: fix possible infinite loop in tcf_idr_check_alloc()

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: phy: mxl-gpy: Remove interrupt mask clearing from config_init

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: lan743x: Support WOL at both the PHY and MAC appropriately

Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
    net: lan743x: disable WOL upon resume to restore full data path operation

Stefan Wahren <wahrenst@gmx.net>
    qca_spi: Make interrupt remembering atomic

Yue Haibing <yuehaibing@huawei.com>
    netns: Make get_net_ns() handle zero refcount net

Eric Dumazet <edumazet@google.com>
    xfrm6: check ip6_dst_idev() return value in xfrm6_get_saddr()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL dereference in rt6_probe()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent possible NULL deref in fib6_nh_init()

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netrom: Fix a memory leak in nr_heartbeat_expiry()

Ajrat Makhmutov <rautyrauty@gmail.com>
    ALSA: hda/realtek: Enable headset mic on IdeaPad 330-17IKB 81DM

Jakub Kicinski <kuba@kernel.org>
    netdev-genl: fix error codes when outputting XDP features

Florian Westphal <fw@strlen.de>
    bpf: Avoid splat in pskb_pull_reason

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: tas2781: Component should be unbound before deconstruction

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l41: Component should be unbound before deconstruction

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l56: Component should be unbound before deconstruction

Ondrej Mosnacek <omosnace@redhat.com>
    cipso: fix total option length computation

Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
    net: mvpp2: use slab_build_skb for oversized frames

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: allocate dummy checksums for zoned NODATASUM writes

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix reg_set_min_max corruption of fake_reg

Wojciech Drewek <wojciech.drewek@intel.com>
    ice: implement AQ download pkg retry

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix 200G link speed message log

En-Wei Wu <en-wei.wu@canonical.com>
    ice: avoid IRQ collision to fix init failure on ACPI S3 resume

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA/hda: intel-dsp-config: Document AVS as dsp_driver option

Dustin L. Howett <dustin@howett.net>
    ALSA: hda/realtek: Remove Framework Laptop 16 from quirks

Remi Pommarel <repk@triplefau.lt>
    wifi: mac80211: Recalc offload when monitor stop

Shaul Triebitz <shaul.triebitz@intel.com>
    wifi: iwlwifi: mvm: fix ROC version check

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Build event generation tests only as modules

Christian Marangi <ansuelsmth@gmail.com>
    mips: bmips: BCM6358: make sure CBR is correctly set

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    MIPS: Routerboard 532: Fix vendor retry check code

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Fix missing System Reset message handling

Simon Trimmer <simont@opensource.cirrus.com>
    ALSA: hda: cs35l41: Possible null pointer dereference in cs35l41_hda_unbind()

Viresh Kumar <viresh.kumar@linaro.org>
    OPP: Fix required_opp_tables for multiple genpds using same table

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Do not wait for disconnected devices when resuming

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Install address space handler at the namespace root

Peng Ma <andypma@tencent.com>
    cpufreq: amd-pstate: fix memory leak on CPU EPP exit

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: qcom-pmic-typec: split HPD bridge alloc and registration

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Collect hot-reset devices to local buffer

Dave Jiang <dave.jiang@intel.com>
    cxl: Add post-reset warning if reset results in loss of previously committed HDM decoders

Alexander Stein <alexander.stein@ew.tq-group.com>
    i2c: lpi2c: Avoid calling clk_get_rate during transfer

Linus Torvalds <torvalds@linux-foundation.org>
    tty: add the option to have a tty reject a new ldisc

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: remove XHCI_TRUST_TX_LENGTH quirk

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: function: Remove usage of the deprecated ida_simple_xx() API

Parker Newman <pnewman@connecttech.com>
    serial: exar: adding missing CTI and Exar PCI ids

Esben Haabendal <esben@geanix.com>
    serial: imx: Introduce timeout when waiting on transmitter empty

Songyang Li <leesongyang@outlook.com>
    MIPS: Octeon: Add PCIe link status check

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: don't set RO when shutting down f2fs

Mario Limonciello <mario.limonciello@amd.com>
    PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports

Roman Smirnov <r.smirnov@omp.ru>
    udf: udftime: prevent overflow in udf_disk_stamp_to_time()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi_glink: drop special handling for CCI_BUSY

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Don't set "linux,phy_charger_detect" property on Lenovo Yoga Tab2 1380

Joao Pinto <Joao.Pinto@synopsys.com>
    Avoid hw_desc array overrun in dw-axi-dmac

Alex Henrie <alexhenrie24@gmail.com>
    usb: misc: uss720: check for incompatible versions of the Belkin F5U002

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi_glink: rework quirks implementation

Yunlei He <heyunlei@oppo.com>
    f2fs: remove clear SB_INLINECRYPT flag in default_options

Chao Yu <chao@kernel.org>
    f2fs: fix to detect inconsistent nat entry during truncation

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: gadget: uvc: configfs: ensure guid to be valid before set

Stephen Brennan <stephen.s.brennan@oracle.com>
    kprobe/ftrace: bail out if ftrace was killed

Baokun Li <libaokun1@huawei.com>
    ext4: fix uninitialized ratelimit_state->lock access in __ext4_fill_super()

Jan Kara <jack@suse.cz>
    ext4: do not create EA inode under buffer lock

Aleksandr Aprelkov <aaprelkov@usergate.com>
    iommu/arm-smmu-v3: Free MSIs in case of ENOMEM

Tzung-Bi Shih <tzungbi@kernel.org>
    power: supply: cros_usbpd: provide ID table for avoiding fallback match

Ben Fradella <bfradell@netapp.com>
    platform/x86: p2sb: Don't init until unassigned resources have been assigned

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/io: Avoid clang null pointer arithmetic warnings

Fullway Wang <fullwaywang@outlook.com>
    media: mtk-vcodec: potential null pointer deference in SCP

Ricardo Ribalda <ribalda@chromium.org>
    media: intel/ipu6: Fix build with !ACPI

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries: Enforce hcall result buffer validity and size

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirks for Lenovo 13X

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add quirks for HP Omen models using CS35L41

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Add Lenovo Yoga Tablet 2 Pro 1380F/L data

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Unregister devices in reverse order

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: mask irqs in timeout path before hard reset

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: include pp bcast irq in timeout handler check

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: add mask irq callback to gp and pp

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk for Dell SKU 0C0F

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add JD2 quirk for HP Omen 14

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Make cpuset hotplug processing synchronous

Arvid Norlander <lkml@vorpal.se>
    platform/x86: toshiba_acpi: Add quirk for buttons on Z830

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Workaround register access in idle race with cursor

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Exit idle optimizations before HDCP execution

Uri Arev <me@wantyapps.xyz>
    Bluetooth: ath3k: Fix multiple issues reported by checkpatch.pl

David Arinzon <darinzon@amazon.com>
    net: ena: Add validation for completion descriptors consistency

Jakub Kicinski <kuba@kernel.org>
    selftests: net: fix timestamp not arriving in cmsg_time.sh

Jose E. Marchesi <jose.marchesi@oracle.com>
    bpf: avoid uninitialized warnings in verifier_global_subprogs.c

Takashi Iwai <tiwai@suse.de>
    ACPI: video: Add backlight=native quirk for Lenovo Slim 7 16ARH7

Luke D. Jones <luke@ljones.dev>
    HID: asus: fix more n-key report descriptors if n-key quirked

Sean O'Brien <seobrien@chromium.org>
    HID: Add quirk for Logitech Casa touchpad

Leon Yen <leon.yen@mediatek.com>
    wifi: mt76: mt7921s: fix potential hung tasks during chip recovery

Lingbo Kong <quic_lingbok@quicinc.com>
    wifi: ath12k: fix the problem that down grade phy mode operation

Breno Leitao <leitao@debian.org>
    netpoll: Fix race condition in netpoll_owner_active

Tamim Khan <tamim@fusetak.com>
    ACPI: resource: Skip IRQ override on Asus Vivobook Pro N6506MV

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    net: dsa: realtek: do not assert reset on remove

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    net: dsa: realtek: keep default LED state in rtl8366rb

Kunwu Chan <chentao@kylinos.cn>
    kselftest: arm64: Add a null pointer check

Shiqi Liu <shiqiliu@hust.edu.cn>
    arm64/sysreg: Update PIE permission encodings

Davide Caratti <dcaratti@redhat.com>
    net/sched: fix false lockdep warning on qdisc root lock

Daniel Golle <daniel@makrotopia.org>
    net: sfp: add quirk for ATS SFP-GE-T 1000Base-TX module

Marek Behún <kabel@kernel.org>
    net: sfp: enhance quirk for Fibrestore 2.5G copper SFP module

Manish Rangankar <mrangankar@marvell.com>
    scsi: qedi: Fix crash while reading debugfs attribute

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix kernel crash during resume

Guenter Schafranek <gschafra@web.de>
    ACPI: resource: Do IRQ override on GMxBGxx (XMG APEX 17 M23)

Wander Lairson Costa <wander@redhat.com>
    drop_monitor: replace spin_lock by raw_spin_lock

Hans de Goede <hdegoede@redhat.com>
    ACPI: x86: Add PNP_UART1_SKIP quirk for Lenovo Blade2 tablets

Adrian Hunter <adrian.hunter@intel.com>
    clocksource: Make watchdog and suspend-timing multiplication overflow safe

Eric Dumazet <edumazet@google.com>
    af_packet: avoid a false positive warning in packet_setsockopt()

Arnd Bergmann <arnd@arndb.de>
    wifi: ath9k: work around memset overflow warning

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: 8852c: add quirk to set PCI BER for certain platforms

Eric Dumazet <edumazet@google.com>
    batman-adv: bypass empty buckets in batadv_purge_orig_ref()

Jian Wen <wenjianhn@gmail.com>
    devlink: use kvzalloc() to allocate devlink instance resources

Alexei Starovoitov <ast@kernel.org>
    bpf: Avoid kfree_rcu() under lock in bpf_lpm_trie.

Yonghong Song <yonghong.song@linux.dev>
    selftests/bpf: Fix flaky test btf_map_in_map/lookup_update

Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
    selftests/bpf: Prevent client connect before server bind in test_tc_tunnel.sh

Rand Deeb <rand.sec96@gmail.com>
    ssb: Fix potential NULL pointer dereference in ssb_device_uevent()

Justin Stitt <justinstitt@google.com>
    block/ioctl: prefer different overflow check

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: defconfig: select INTERCONNECT_QCOM_SM6115 as built-in

Kees Cook <keescook@chromium.org>
    ubsan: Avoid i386 UBSAN handler crashes with Clang

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_usbpd_notify: provide ID table for avoiding fallback match

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: cros_usbpd_logger: provide ID table for avoiding fallback match

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Fix invalid context warning when enable srcu barrier testing

Zqiang <qiang.zhang1211@gmail.com>
    rcutorture: Make stall-tasks directly exit when rcutorture tests end

Paul E. McKenney <paulmck@kernel.org>
    rcutorture: Fix rcu_torture_one_read() pipe_count overflow comment

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: work around a potential audit memory leak

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - Add the err memory release process to qm uninit

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/sec - Fix memory leak for sec resource release

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Disable BH when taking works lock on MT path

Kemeng Shi <shikemeng@huaweicloud.com>
    fs/writeback: bail out if there is no more inodes for IO and queued once


-------------

Diffstat:

 .../devicetree/bindings/dma/fsl,edma.yaml          |   4 +-
 .../devicetree/bindings/i2c/atmel,at91sam-i2c.yaml |   2 +-
 .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml    |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/nxp/imx/imx53-qsb-common.dtsi    |   2 +-
 arch/arm/boot/dts/nxp/imx/imx53-qsb-hdmi.dtso      |   6 +-
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   3 +-
 .../arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi |   2 +-
 .../boot/dts/freescale/imx8mp-venice-gw73xx.dtsi   |   2 +-
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts       |   2 +-
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts  |   1 -
 arch/arm64/configs/defconfig                       |   1 +
 arch/arm64/include/asm/sysreg.h                    |  24 +--
 arch/arm64/kvm/vgic/vgic-init.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  15 +-
 arch/arm64/kvm/vgic/vgic.h                         |   2 +-
 arch/csky/kernel/probes/ftrace.c                   |   3 +
 arch/loongarch/Kconfig                             |   5 +-
 arch/loongarch/Kconfig.debug                       |   1 +
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/kernel/ftrace_dyn.c                 |   3 +
 arch/loongarch/kernel/hw_breakpoint.c              |  96 +++++----
 arch/loongarch/kernel/ptrace.c                     |  47 +++--
 arch/mips/bmips/setup.c                            |   3 +-
 arch/mips/include/asm/mipsmtregs.h                 |   2 +-
 arch/mips/pci/ops-rc32434.c                        |   4 +-
 arch/mips/pci/pcie-octeon.c                        |   6 +
 arch/parisc/kernel/ftrace.c                        |   3 +
 arch/powerpc/crypto/.gitignore                     |   2 +
 arch/powerpc/include/asm/hvcall.h                  |   8 +-
 arch/powerpc/include/asm/io.h                      |  24 +--
 arch/powerpc/kernel/kprobes-ftrace.c               |   3 +
 arch/riscv/kernel/probes/ftrace.c                  |   3 +
 arch/s390/kernel/ftrace.c                          |   3 +
 arch/x86/include/asm/cpu_device_id.h               |  98 ++++++++++
 arch/x86/include/asm/efi.h                         |   1 -
 arch/x86/kernel/cpu/match.c                        |   4 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   3 +-
 arch/x86/kernel/kprobes/ftrace.c                   |   3 +
 arch/x86/kvm/x86.c                                 |   9 +-
 arch/x86/platform/efi/memmap.c                     |  12 +-
 block/ioctl.c                                      |   2 +-
 drivers/acpi/acpica/acevents.h                     |   4 +
 drivers/acpi/acpica/evregion.c                     |   6 +-
 drivers/acpi/acpica/evxfregn.c                     |  54 ++++++
 drivers/acpi/acpica/exregion.c                     |  23 +--
 drivers/acpi/ec.c                                  |  28 ++-
 drivers/acpi/internal.h                            |   5 +-
 drivers/acpi/mipi-disco-img.c                      |  28 ++-
 drivers/acpi/resource.c                            |  13 ++
 drivers/acpi/video_detect.c                        |   8 +
 drivers/acpi/x86/utils.c                           |  20 +-
 drivers/ata/ahci.c                                 |   8 +
 drivers/block/nbd.c                                |  34 ++--
 drivers/bluetooth/ath3k.c                          |  25 ++-
 drivers/cpufreq/amd-pstate.c                       |   7 +
 drivers/crypto/hisilicon/qm.c                      |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   4 +-
 drivers/cxl/core/pci.c                             |  29 +++
 drivers/cxl/cxl.h                                  |   2 +
 drivers/cxl/pci.c                                  |  22 +++
 drivers/dma/Kconfig                                |   2 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   6 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h              |   1 +
 drivers/dma/idxd/irq.c                             |   4 +-
 drivers/dma/ioat/init.c                            |  55 +++---
 drivers/dma/ti/k3-udma-glue.c                      |   5 +-
 drivers/dma/xilinx/xdma.c                          |   4 +-
 drivers/firmware/efi/memmap.c                      |   9 -
 drivers/firmware/psci/psci.c                       |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |  66 ++++---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 -
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |  23 ++-
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |  72 +++++++
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h    |   2 +
 .../gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c |   2 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c         |   2 +
 drivers/gpu/drm/i915/display/intel_dp.c            |   4 +
 drivers/gpu/drm/lima/lima_bcast.c                  |  12 ++
 drivers/gpu/drm/lima/lima_bcast.h                  |   3 +
 drivers/gpu/drm/lima/lima_gp.c                     |   8 +
 drivers/gpu/drm/lima/lima_pp.c                     |  18 ++
 drivers/gpu/drm/lima/lima_sched.c                  |   9 +
 drivers/gpu/drm/lima/lima_sched.h                  |   1 +
 drivers/gpu/drm/radeon/sumo_dpm.c                  |   2 +
 drivers/gpu/drm/xe/xe_guc.c                        |   4 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   4 +
 drivers/hid/hid-asus.c                             |  51 +++--
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-multitouch.c                       |   6 +
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |  19 +-
 drivers/i2c/busses/i2c-ocores.c                    |   2 +-
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   4 +-
 drivers/infiniband/hw/mana/mr.c                    |   1 +
 drivers/infiniband/hw/mlx5/main.c                  |   4 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   8 +-
 drivers/infiniband/hw/mlx5/srq.c                   |  13 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  13 ++
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   2 +-
 drivers/media/pci/intel/ipu-bridge.c               |  66 +++++--
 .../mediatek/vcodec/common/mtk_vcodec_fw_scp.c     |   2 +
 drivers/net/dsa/realtek/rtl8366rb.c                |  87 ++-------
 drivers/net/dsa/realtek/rtl83xx.c                  |   7 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |  37 +++-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   2 +
 drivers/net/ethernet/amazon/ena/ena_regs_defs.h    |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           |  23 ++-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   6 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   5 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |   2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   5 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  44 ++++-
 drivers/net/ethernet/microchip/lan743x_main.c      |  48 ++++-
 drivers/net/ethernet/microchip/lan743x_main.h      |  28 +++
 drivers/net/ethernet/qualcomm/qca_debug.c          |   6 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |  16 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |   3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  40 ++--
 drivers/net/phy/dp83tg720.c                        |  38 +++-
 drivers/net/phy/mxl-gpy.c                          |  58 ++++--
 drivers/net/phy/sfp.c                              |  21 +-
 drivers/net/usb/ax88179_178a.c                     |  18 +-
 drivers/net/usb/rtl8150.c                          |   3 +-
 drivers/net/virtio_net.c                           |  32 ++-
 drivers/net/wireless/ath/ath.h                     |   6 +-
 drivers/net/wireless/ath/ath12k/core.c             |   1 -
 drivers/net/wireless/ath/ath12k/mac.c              |  16 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |  61 ++++--
 drivers/net/wireless/ath/ath12k/qmi.h              |   2 +
 drivers/net/wireless/ath/ath9k/main.c              |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   2 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   2 -
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |   2 -
 drivers/net/wireless/mediatek/mt76/sdio.c          |   3 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  18 ++
 drivers/net/wireless/realtek/rtw89/core.h          |  10 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  19 ++
 drivers/net/wireless/realtek/rtw89/pci.h           |   5 +
 drivers/net/wireless/realtek/rtw89/rtw8851be.c     |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |   1 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |  23 +++
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c     |   1 +
 drivers/opp/core.c                                 |  31 ++-
 drivers/pci/pci.c                                  |  17 ++
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          | 189 +++++++++++++++---
 drivers/phy/qualcomm/phy-qcom-qmp-pcs-v6-n4.h      |  32 +++
 .../phy/qualcomm/phy-qcom-qmp-qserdes-txrx-v6_n4.h |  13 ++
 drivers/phy/qualcomm/phy-qcom-qmp.h                |   2 +
 drivers/platform/chrome/cros_usbpd_logger.c        |   9 +-
 drivers/platform/chrome/cros_usbpd_notify.c        |   9 +-
 drivers/platform/x86/p2sb.c                        |  29 +--
 drivers/platform/x86/toshiba_acpi.c                |  36 +++-
 drivers/platform/x86/x86-android-tablets/core.c    |   8 +-
 drivers/platform/x86/x86-android-tablets/dmi.c     |  18 ++
 drivers/platform/x86/x86-android-tablets/lenovo.c  | 216 +++++++++++++++++++++
 .../x86/x86-android-tablets/x86-android-tablets.h  |   1 +
 drivers/pmdomain/core.c                            |  10 +
 drivers/power/supply/cros_usbpd-charger.c          |  11 +-
 drivers/ptp/ptp_sysfs.c                            |   3 +-
 drivers/regulator/bd71815-regulator.c              |   2 +-
 drivers/regulator/core.c                           |   1 +
 drivers/scsi/qedi/qedi_debugfs.c                   |  12 +-
 drivers/scsi/sd.c                                  |   4 +
 drivers/spi/spi-cs42l43.c                          |   2 +-
 drivers/spi/spi-imx.c                              |  14 +-
 drivers/spi/spi-stm32-qspi.c                       |  12 +-
 drivers/spi/spi.c                                  |  10 +-
 drivers/ssb/main.c                                 |   4 +-
 .../int340x_thermal/processor_thermal_device_pci.c |   3 +-
 drivers/thermal/mediatek/lvts_thermal.c            |   6 +-
 drivers/thermal/thermal_core.c                     |   6 +
 drivers/tty/serial/8250/8250_dw.c                  |  27 +++
 drivers/tty/serial/8250/8250_dwlib.h               |  32 ---
 drivers/tty/serial/8250/8250_exar.c                |  42 ++++
 drivers/tty/serial/imx.c                           |   7 +-
 drivers/tty/tty_ldisc.c                            |   6 +
 drivers/tty/vt/vt.c                                |  10 +
 drivers/ufs/core/ufshcd.c                          |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   8 +-
 drivers/usb/gadget/function/f_hid.c                |   6 +-
 drivers/usb/gadget/function/f_printer.c            |   6 +-
 drivers/usb/gadget/function/rndis.c                |   4 +-
 drivers/usb/gadget/function/uvc_configfs.c         |  14 +-
 drivers/usb/host/xhci-pci.c                        |  15 +-
 drivers/usb/host/xhci-rcar.c                       |   6 +-
 drivers/usb/host/xhci-ring.c                       |  15 +-
 drivers/usb/host/xhci.h                            |   4 +-
 drivers/usb/misc/uss720.c                          |  22 ++-
 drivers/usb/storage/scsiglue.c                     |   6 +
 drivers/usb/storage/uas.c                          |   7 +
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec.c      |  10 +-
 drivers/usb/typec/ucsi/ucsi_glink.c                |  22 +--
 drivers/vfio/pci/vfio_pci_core.c                   |  78 +++++---
 fs/btrfs/bio.c                                     |   4 +-
 fs/btrfs/block-group.c                             |  11 +-
 fs/ext4/mballoc.c                                  |   4 +
 fs/ext4/super.c                                    |  22 +--
 fs/ext4/sysfs.c                                    |  24 ++-
 fs/ext4/xattr.c                                    | 113 +++++------
 fs/f2fs/node.c                                     |  12 +-
 fs/f2fs/super.c                                    |  12 +-
 fs/fs-writeback.c                                  |   7 +-
 fs/ocfs2/journal.c                                 | 192 ++++++++++--------
 fs/ocfs2/ocfs2.h                                   |  27 +++
 fs/ocfs2/super.c                                   |   4 +-
 fs/overlayfs/export.c                              |   6 +-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/udf/udftime.c                                   |  11 +-
 include/acpi/acpixf.h                              |   4 +
 include/linux/bpf_verifier.h                       |   2 +
 include/linux/cpuset.h                             |   3 -
 include/linux/kcov.h                               |   2 +
 include/linux/kprobes.h                            |   7 +
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/mod_devicetable.h                    |   2 +
 include/linux/pagemap.h                            |   4 +
 include/linux/pci.h                                |   7 +-
 include/linux/pm_domain.h                          |   6 +
 include/linux/security.h                           |   5 +-
 include/linux/tty_driver.h                         |   8 +
 include/net/netns/netfilter.h                      |   3 +
 include/net/sch_generic.h                          |   1 +
 include/scsi/scsi_devinfo.h                        |   4 +-
 io_uring/rsrc.c                                    |   1 -
 io_uring/sqpoll.c                                  |   8 +
 kernel/auditfilter.c                               |   5 +-
 kernel/bpf/lpm_trie.c                              |  13 +-
 kernel/bpf/verifier.c                              |  14 +-
 kernel/cgroup/cpuset.c                             | 141 ++++++--------
 kernel/cpu.c                                       |  48 -----
 kernel/gcov/gcc_4_7.c                              |   4 +-
 kernel/kcov.c                                      |   1 +
 kernel/kprobes.c                                   |   6 +
 kernel/padata.c                                    |   8 +-
 kernel/power/process.c                             |   2 -
 kernel/rcu/rcutorture.c                            |  16 +-
 kernel/time/clocksource.c                          |  42 ++--
 kernel/trace/Kconfig                               |   4 +-
 kernel/trace/ftrace.c                              |   1 +
 kernel/trace/preemptirq_delay_test.c               |   1 +
 lib/ubsan.h                                        |  41 ++--
 mm/huge_memory.c                                   |  28 +--
 mm/memcontrol.c                                    |   3 +-
 mm/page_table_check.c                              |  11 +-
 mm/shmem.c                                         |   2 +-
 net/batman-adv/originator.c                        |   2 +
 net/core/drop_monitor.c                            |  20 +-
 net/core/filter.c                                  |   5 +
 net/core/net_namespace.c                           |   9 +-
 net/core/netdev-genl.c                             |  16 +-
 net/core/netpoll.c                                 |   2 +-
 net/core/sock.c                                    |   3 +
 net/devlink/core.c                                 |   6 +-
 net/ipv4/cipso_ipv4.c                              |  12 +-
 net/ipv4/tcp_ao.c                                  |   6 +-
 net/ipv4/tcp_input.c                               |   1 +
 net/ipv6/route.c                                   |   4 +-
 net/ipv6/seg6_local.c                              |   8 +-
 net/ipv6/xfrm6_policy.c                            |   8 +-
 net/mac80211/driver-ops.c                          |  17 ++
 net/mac80211/iface.c                               |  22 +--
 net/mac80211/util.c                                |   2 +-
 net/netfilter/core.c                               |  13 +-
 net/netfilter/ipset/ip_set_core.c                  |  11 +-
 net/netfilter/nf_conntrack_standalone.c            |  15 --
 net/netfilter/nf_hooks_lwtunnel.c                  |  67 +++++++
 net/netfilter/nf_internals.h                       |   6 +
 net/netrom/nr_timer.c                              |   3 +-
 net/packet/af_packet.c                             |  26 +--
 net/sched/act_api.c                                |   3 +-
 net/sched/act_ct.c                                 |  16 +-
 net/sched/sch_api.c                                |   1 +
 net/sched/sch_generic.c                            |   4 +
 net/sched/sch_htb.c                                |  22 +--
 net/tipc/node.c                                    |   1 +
 security/apparmor/audit.c                          |   6 +-
 security/apparmor/include/audit.h                  |   2 +-
 security/integrity/ima/ima.h                       |   2 +-
 security/integrity/ima/ima_policy.c                |  15 +-
 security/security.c                                |   6 +-
 security/selinux/include/audit.h                   |   4 +-
 security/selinux/ss/services.c                     |   5 +-
 security/smack/smack_lsm.c                         |   4 +-
 sound/core/seq/seq_ump_convert.c                   |   2 +
 sound/hda/intel-dsp-config.c                       |   2 +-
 sound/pci/hda/cs35l41_hda.c                        |   6 +-
 sound/pci/hda/cs35l56_hda.c                        |   4 +-
 sound/pci/hda/patch_realtek.c                      |  15 +-
 sound/pci/hda/tas2781_hda_i2c.c                    |   4 +-
 sound/soc/intel/boards/sof_sdw.c                   |  18 ++
 tools/arch/arm64/include/asm/sysreg.h              |  24 +--
 tools/testing/selftests/arm64/tags/tags_test.c     |   4 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  26 +--
 .../selftests/bpf/progs/verifier_global_subprogs.c |   7 +
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  13 +-
 tools/testing/selftests/net/cmsg_sender.c          |  20 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  46 +++--
 .../selftests/net/openvswitch/openvswitch.sh       |   2 +-
 virt/kvm/guest_memfd.c                             |   5 +-
 virt/kvm/kvm_main.c                                |   5 +-
 308 files changed, 3159 insertions(+), 1398 deletions(-)


