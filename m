Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A88F13D8A4;
	Thu, 13 Feb 2025 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460174; cv=none; b=sfq6LFN1uo1wUgm1UeGQfA6bHCQdgytPFw3LrHoJUo/677YdKHIqQcOjn1oMJnmzD/SLFHyU/2z5RTTdlZSS+XeH+8sk3+OSUlBOyyCdmBf0x95sxcbhRon9dG/qqXB74ktalN+XKFRhSa5vV3TuRwZVazqZ+SgapGpgxtVC96w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460174; c=relaxed/simple;
	bh=2pzJ73XzUNjr+cE6t2tcSOxxSOFM7hl8cWaHseg20vk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rbiLrJT2hOGKV7KB89iboclhrV7PGtftgwQBvkKo+gGFAc7z7ZW72a5W1dMGqljQuFHlZE/xWipbJZjIGZdZJbiC2dFXgm0V1qM8ntsGAg2c4nehGZ1YplMz5cOIa0VE9SqIWCTfzgdNu3Xi916l48KCxEG2tjScaa/q5DTAHHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skLQ8BFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skLQ8BFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A2DC4CEE4;
	Thu, 13 Feb 2025 15:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460174;
	bh=2pzJ73XzUNjr+cE6t2tcSOxxSOFM7hl8cWaHseg20vk=;
	h=From:To:Cc:Subject:Date:From;
	b=skLQ8BFjfJwQ9z4zW+TNF4v3NmUegnGHBFhxuE0983wvI0AnqdE8qIG7Py+oX2c/m
	 3cCIQCFUG/OjbPatnNyk3p9nZgTPxWrIkvfMCskGgG+k0H7Drqr3lWJipa2qZmfT9H
	 wZ4odA0ROihXSFucjH2nF1T6vTyroJiInqZ7zE/4=
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
Subject: [PATCH 6.6 000/273] 6.6.78-rc1 review
Date: Thu, 13 Feb 2025 15:26:12 +0100
Message-ID: <20250213142407.354217048@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.78-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.78-rc1
X-KernelTest-Deadline: 2025-02-15T14:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.78 release.
There are 273 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.78-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.78-rc1

Sean Christopherson <seanjc@google.com>
    KVM: x86: Re-split x2APIC ICR into ICR+ICR2 for AMD (x2AVIC)

Sean Christopherson <seanjc@google.com>
    KVM: x86: Make x2APIC ID 100% readonly

Sean Anderson <sean.anderson@linux.dev>
    tty: xilinx_uartps: split sysrq handling

Steve Wahl <steve.wahl@hpe.com>
    x86/mm/ident_map: Use gbpages only where full GB page should be mapped.

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: fix AF_INET6 variable

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent excessive coalescing on receive

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: only set fullmesh for subflow endp

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix NULL pointer dereference in object->file

Filipe Manana <fdmanana@suse.com>
    btrfs: avoid monopolizing a core when activating a swap file

Koichiro Den <koichiro.den@canonical.com>
    Revert "btrfs: avoid monopolizing a core when activating a swap file"

Su Yue <glass.su@suse.com>
    ocfs2: check dir i_size in ocfs2_find_entry

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: use dev_set_mac_address() for Get MC MAC Address handling

Bence Csókás <csokas.bence@prolan.hu>
    spi: atmel-qspi: Memory barriers after memory-mapped I/O

Csókás, Bence <csokas.bence@prolan.hu>
    spi: atmel-quadspi: Create `atmel_qspi_ops` to support newer SoC families

WangYuli <wangyuli@uniontech.com>
    MIPS: ftrace: Declare ftrace_get_parent_ra_addr() as static

Michal Simek <michal.simek@amd.com>
    rtc: zynqmp: Fix optional clock name property

Thomas Weißschuh <linux@weissschuh.net>
    ptp: Ensure info->enable callback is always set

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    pinctrl: samsung: fix fwnode refcount cleanup if platform_get_irq_optional() fails

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Stop timerlat tracer on signal

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Stop timerlat tracer on signal

Tomas Glozar <tglozar@redhat.com>
    rtla: Add trace_instance_stop

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_top: Set OSNOISE_WORKLOAD for kernel threads

Tomas Glozar <tglozar@redhat.com>
    rtla/timerlat_hist: Set OSNOISE_WORKLOAD for kernel threads

Tomas Glozar <tglozar@redhat.com>
    rtla/osnoise: Distinguish missing workload option

Steven Rostedt <rostedt@goodmis.org>
    tracing/osnoise: Fix resetting of tracepoints

Jan Kiszka <jan.kiszka@siemens.com>
    scripts/gdb: fix aarch64 userspace detection in get_current_task

Wei Yang <richard.weiyang@gmail.com>
    maple_tree: simplify split calculation

Milos Reljin <milos_reljin@outlook.com>
    net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: wait for the last response to Deselect Package before configuring channel

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix copy buffer page size

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix registered buffer page address

Anandu Krishnan E <quic_anane@quicinc.com>
    misc: fastrpc: Deregister device nodes properly in error scenarios

Vimal Agrawal <vimal.agrawal@sophos.com>
    misc: misc_minor_alloc to use ida for all dynamic/misc dynamic minors

Ivan Stepchenko <sid@itb.spb.ru>
    mtd: onenand: Fix uninitialized retlen in do_otp_read()

Nick Chan <towinchenmi@gmail.com>
    irqchip/apple-aic: Only handle PMC interrupt as FIQ when configured so

Frank Li <Frank.Li@nxp.com>
    i3c: master: Fix missing 'ret' assignment in set_speed()

Dan Carpenter <dan.carpenter@linaro.org>
    NFC: nci: Add bounds checking in nci_hci_create_pipe()

Pekka Pessi <ppessi@nvidia.com>
    mailbox: tegra-hsp: Clear mailbox before using message

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    nilfs2: fix possible int overflows in nilfs_fiemap()

Matthew Wilcox (Oracle) <willy@infradead.org>
    ocfs2: handle a symlink read error correctly

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix incorrect CPU endianness conversion causing mount failure

Mike Snitzer <snitzer@kernel.org>
    pnfs/flexfiles: retry getting layout segment for reads

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: -f: no reconnect

Alex Williamson <alex.williamson@redhat.com>
    vfio/platform: check the bounds of read/write syscalls

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/rw: commit provided buffer state on async

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix io_req_prep_async with provided buffers

Jens Axboe <axboe@kernel.dk>
    io_uring/net: don't retry connect operation on EPOLLERR

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix multishots with selected buffers

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: set word length to 1

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: fix reading from non zero offset

Sascha Hauer <s.hauer@pengutronix.de>
    nvmem: imx-ocotp-ele: simplify read beyond device check

Jennifer Berringer <jberring@redhat.com>
    nvmem: core: improve range check for nvmem_cell_write()

Luca Weiss <luca.weiss@fairphone.com>
    nvmem: qcom-spmi-sdam: Set size in struct nvmem_config

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - unregister previously registered algos in error path

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    crypto: qce - fix goto jump in error path

Niklas Cassel <cassel@kernel.org>
    ata: libata-sff: Ensure that we cannot write outside the allocated buffer

Catalin Marinas <catalin.marinas@arm.com>
    mm: kmemleak: fix upper boundary check for physical address objects

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Remove redundant NULL assignment

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Support partial control reads

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix event flags in uvc_ctrl_send_events

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Fix crash during unbind if gpio unit is in use

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix logging SP & EQ status only for UB9702

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix UB9702 VC map

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix use of non-existing registers on UB9702

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub9x3: Fix extra fwnode_handle_put()

Mehdi Djait <mehdi.djait@linux.intel.com>
    media: ccs: Fix cleanup order in ccs_probe()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Fix CCS static data parsing for large block sizes

Sam Bobrowicz <sam@elite-embedded.com>
    media: ov5640: fix get_light_freq on auto

Naushir Patuck <naush@raspberrypi.com>
    media: imx296: Add standby delay during probe

Cosmin Tanislav <demonsingur@gmail.com>
    media: mc: fix endpoint iteration

Lubomir Rintel <lkundrak@v3.sk>
    media: mmp: Bring back registration of the device

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: qcom: smem_state: fix missing of_node_put in error path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    soc: mediatek: mtk-devapc: Fix leaking IO map on error paths

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: as73211: fix channel handling in only-color triggered buffer

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Clean up parsed CCS static data on parse failure

Marco Elver <elver@google.com>
    kfence: skip __GFP_THISNODE allocations on NUMA systems

Gabriele Monaco <gmonaco@redhat.com>
    rv: Reset per-task monitors also for idle tasks

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Change to kvalloc() in eventlog/acpi.c

Aubrey Li <aubrey.li@linux.intel.com>
    ACPI: PRM: Remove unnecessary strict handler address checks

Wentao Liang <vulab@iscas.ac.cn>
    xfs: Add error handling for xfs_reflink_cancel_cow_range

Wentao Liang <vulab@iscas.ac.cn>
    xfs: Propagate errors from xfs_reflink_cancel_cow_range in xfs_dax_write_iomap_end

Conor Dooley <conor.dooley@microchip.com>
    pwm: microchip-core: fix incorrect comparison with max period

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Disable Tegra234 sce-fabric node

Sumit Gupta <sumitg@nvidia.com>
    arm64: tegra: Fix typo in Tegra234 dce-fabric compatible

Eric Biggers <ebiggers@google.com>
    crypto: qce - fix priority to be less than ARMv8 CE

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sm8550: correct MDSS interconnects

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8550: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8550: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8450: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix CDSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8350: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6375: Fix MPSS memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6375: Fix CDSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6375: Fix ADSP memory length

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm6350: Fix uart1 interconnect path

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6350: Fix MPSS memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6350: Fix ADSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: Fix ADSP memory base and length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: Fix CDSP memory length

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6115: Fix MPSS memory length

Andreas Kemnade <andreas@kemnade.info>
    ARM: dts: ti/omap: gta04: fix pm issues caused by spi module

Romain Naour <romain.naour@skf.com>
    ARM: dts: dra7: Add bus_dma_limit for l4 cfg bus

Denis Arefev <arefev@swemel.ru>
    ubi: Add a check for ubi_num

Nathan Chancellor <nathan@kernel.org>
    x86/boot: Use '-std=gnu11' to fix build with GCC 15

Miguel Ojeda <ojeda@kernel.org>
    rust: init: use explicit ABI to clean warning in future compilers

Nathan Chancellor <nathan@kernel.org>
    kbuild: Move -Wenum-enum-conversion to W=2

Long Li <longli@microsoft.com>
    scsi: storvsc: Set correct data length for sending SCSI command without payload

Eric Biggers <ebiggers@google.com>
    scsi: ufs: qcom: Fix crypto key eviction

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Move FCE Trace buffer allocation to user control

Kai Mäkisara <Kai.Makisara@kolumbus.fi>
    scsi: st: Don't set pos_unknown just after device recognition

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk

Georg Gottleuber <ggo@tuxedocomputers.com>
    nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk

Zijun Hu <quic_zijuhu@quicinc.com>
    PCI: endpoint: Finish virtual EP removal in pci_epf_remove_vepf()

Werner Sembach <wse@tuxedocomputers.com>
    PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1

Brad Griffis <bgriffis@nvidia.com>
    arm64: tegra: Fix Tegra234 PCIe interrupt-map

Kuan-Wei Chiu <visitorckw@gmail.com>
    ALSA: hda: Fix headset detection failure due to unstable sort

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Enable headset mic on Positivo C6400

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    Revert "media: uvcvideo: Require entities to have a non-zero unique ID"

Jens Axboe <axboe@kernel.dk>
    block: don't revert iter for -EIOCBQUEUED

Mateusz Jończyk <mat.jonczyk@o2.pl>
    mips/math-emu: fix emulation of the prefx instruction

Hou Tao <houtao1@huawei.com>
    dm-crypt: track tag_offset in convert_context

Hou Tao <houtao1@huawei.com>
    dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()

Narayana Murty N <nnmlinux@linux.ibm.com>
    powerpc/pseries/eeh: Fix get PE state translation

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Extend the maximum number of watchpoints

Kexy Biscuit <kexybiscuit@aosc.io>
    MIPS: Loongson64: remove ROM Size unit in boardinfo

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Do not probe the serial port if its slot in sci_ports[] is in use

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    serial: sh-sci: Drop __initdata macro for port_cfg

Stephan Gerhold <stephan.gerhold@linaro.org>
    soc: qcom: socinfo: Avoid out of bounds read of serial number

Mario Limonciello <mario.limonciello@amd.com>
    ASoC: acp: Support microphone from Lenovo Go S

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: document scope of NCM implementation

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: fix DPE OoB read

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: break up NCM header size computation

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: refactor NCM datagram loop

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: check that DPE points past NCM header

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: use static NDP16 location in URB

Foster Snowhill <forst@pen.gy>
    usbnet: ipheth: fix possible overflow in DPE length check

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Don't prepare BOT write request twice

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: ep_autoconfig with fullspeed endpoint

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Decrement command ref count on cleanup

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: gadget: f_tcm: Translate error to sense

Shayne Chen <shayne.chen@mediatek.com>
    wifi: mt76: mt7915: add module param to select 5 GHz or 6 GHz on MT7916

Fiona Klute <fiona.klute@gmx.de>
    wifi: rtw88: sdio: Fix disconnection after beacon loss

Nick Morrow <usbwifi2024@gmail.com>
    wifi: mt76: mt7921u: Add VID/PID for TP-Link TXE50UH

Marcel Hamer <marcel.hamer@windriver.com>
    wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8821ae: Fix media status report

Heiko Stuebner <heiko@sntech.de>
    HID: hid-sensor-hub: don't use stale platform-data on remove

Zijun Hu <quic_zijuhu@quicinc.com>
    of: reserved-memory: Fix using wrong number of cells to get property 'alignment'

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Fix of_find_node_opts_by_path() handling of alias+path+options

Zijun Hu <quic_zijuhu@quicinc.com>
    of: Correct child specifier used as input of the 2nd nexus node

Bao D. Nguyen <quic_nguyenb@quicinc.com>
    scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions

Kuan-Wei Chiu <visitorckw@gmail.com>
    perf bench: Fix undefined behavior in cmpworker()

Nathan Chancellor <nathan@kernel.org>
    efi: libstub: Use '-std=gnu11' to fix build with GCC 15

Zijun Hu <quic_zijuhu@quicinc.com>
    blk-cgroup: Fix class @block_class's subsystem refcount leakage

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-mm: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-img: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-bdp: add missing dummy clk

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-aud: fix conversion to mtk_clk_simple_probe

Daniel Golle <daniel@makrotopia.org>
    clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe

Anastasia Belova <abelova@astralinux.ru>
    clk: qcom: clk-rpmh: prevent integer overflow in recalc_rate

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: dispcc-sm6350: Add missing parent_map for a clock

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-sm6350: Add missing parent_map for two clocks

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8550: Do not turn off PCIe GDSCs during gdsc_disable()

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: fix alpha mode configuration

Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
    media: i2c: ds90ub960: Fix UB9702 refclk register access

Cody Eksal <masterr3c0rd@epochal.quest>
    clk: sunxi-ng: a100: enable MMC clock reparenting

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection

Fedor Pchelkin <pchelkin@ispras.ru>
    Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes

Haoxiang Li <haoxiang_li2024@163.com>
    drm/komeda: Add check for komeda_get_layer_fourcc_list()

Brian Geffon <bgeffon@google.com>
    drm/i915: Fix page cleanup on DMA remap failure

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/i915/guc: Debug print LRC state entries only if the context is pinned

Tom Chung <chiahsuan.chung@amd.com>
    Revert "drm/amd/display: Use HW lock mgr for PSR1"

Prike Liang <Prike.Liang@amd.com>
    drm/amdkfd: only flush the validate MES contex

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Mark MM activity as unsupported

Dan Carpenter <dan.carpenter@linaro.org>
    ksmbd: fix integer overflows on 32 bit systems

David Hildenbrand <david@redhat.com>
    KVM: s390: vsie: fix some corner-cases when grabbing vsie pages

Sean Christopherson <seanjc@google.com>
    KVM: Explicitly verify target vCPU is online in kvm_get_vcpu()

Jakob Unterwurzacher <jakobunt@gmail.com>
    arm64: dts: rockchip: increase gmac rx_delay on rk3399-puma

Thomas Zimmermann <tzimmermann@suse.de>
    drm/rockchip: cdn-dp: Use drm_connector_helper_hpd_irq_event()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: timer: Always evaluate the need for a soft timer

Dan Carpenter <dan.carpenter@linaro.org>
    binfmt_flat: Fix integer overflow bug on 32 bit systems

Nam Cao <namcao@linutronix.de>
    fs/proc: do_task_stat: Fix ESP not readable during coredump

Thomas Zimmermann <tzimmermann@suse.de>
    m68k: vga: Fix I/O defines

Heiko Carstens <hca@linux.ibm.com>
    s390/futex: Fix FUTEX_OP_ANDN implementation

Meetakshi Setiya <msetiya@microsoft.com>
    smb: client: change lease epoch type from unsigned int to __u16

Ruben Devos <devosruben6@gmail.com>
    smb: client: fix order of arguments of tracepoints

Maarten Lankhorst <dev@lankhorst.se>
    drm/modeset: Handle tiled displays in pan_display_atomic.

Sebastian Wiese-Wagner <seb@fastmail.to>
    ALSA: hda/realtek: Enable Mute LED on HP Laptop 14s-fq1xxx

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    leds: lp8860: Write full EEPROM, not only half of it

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: s3c64xx: Fix compilation warning

David Howells <dhowells@redhat.com>
    rxrpc: Fix call state set to not include the SERVER_SECURING state

Ido Schimmel <idosch@nvidia.com>
    net: sched: Fix truncation of offloaded action statistics

Willem de Bruijn <willemb@google.com>
    tun: revert fix group permission check

Cong Wang <cong.wang@bytedance.com>
    netem: Update sch->q.qlen before qdisc_tree_reduce_backlog()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: property: Fix return value for nval == 0 in acpi_data_prop_read()

Juergen Gross <jgross@suse.com>
    x86/xen: add FRAME_END to xen_hypercall_hvm()

Juergen Gross <jgross@suse.com>
    x86/xen: fix xen_hypercall_hvm() to not clobber %rbx

Eric Dumazet <edumazet@google.com>
    net: rose: lock the socket in rose_bind()

Jacob Moroni <mail@jakemoroni.com>
    net: atlantic: fix warning during hot unplug

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: Improve interrupt support

David Howells <dhowells@redhat.com>
    rxrpc: Fix the rxrpc_connection attend queue handling

Yan Zhai <yan@cloudflare.com>
    udp: gso: do not drop small packets when PMTU reduces

Lenny Szubowicz <lszubowi@redhat.com>
    tg3: Disable tg3 PCIe AER on system reboot

Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
    vmxnet3: Fix tx queue race condition with XDP

Jiasheng Jiang <jiashengjiangcool@gmail.com>
    ice: Add check for devm_kzalloc()

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: Correct overlaying of PHY and MAC Wake-on-LAN

Daniel Wagner <wagi@kernel.org>
    nvme-fc: use ctrl state getter

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: put Rx buffers after being done with current frame

Hans Verkuil <hverkuil@xs4all.nl>
    gpu: drm_dp_cec: fix broken CEC adapter properties check

Prasad Pandit <pjp@fedoraproject.org>
    firmware: iscsi_ibft: fix ISCSI_IBFT Kconfig entry

Daniel Wagner <wagi@kernel.org>
    nvme: handle connectivity loss in nvme_set_queue_count

Paul Fertser <fercerpav@gmail.com>
    net/ncsi: fix locking in Get MAC Address handling

Peter Delevoryas <peter@pjd.dev>
    net/ncsi: Add NC-SI 1.2 Get MC MAC Address command

Paolo Bonzini <pbonzini@redhat.com>
    KVM: e500: always restore irqs

Sean Christopherson <seanjc@google.com>
    KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults

Sean Christopherson <seanjc@google.com>
    KVM: PPC: e500: Mark "struct page" pfn accessed before dropping mmu_lock

Sean Christopherson <seanjc@google.com>
    KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()

Armin Wolf <W_Armin@gmx.de>
    platform/x86: acer-wmi: Ignore AC events

Illia Ostapyshyn <illia@yshyn.com>
    Input: allocate keycode for phone linking

Yu-Chun Lin <eleanor15x@gmail.com>
    ASoC: amd: Add ACPI dependency to fix build error

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-pcm: don't use soc_pcm_ret() on .prepare callback

Hans de Goede <hdegoede@redhat.com>
    platform/x86: int3472: Check for adev == NULL

Robin Murphy <robin.murphy@arm.com>
    iommu/arm-smmu-v3: Clean up more on probe failure

Richard Acayan <mailingradian@gmail.com>
    iommu/arm-smmu-qcom: add sdm670 adreno iommu compatible

David Woodhouse <dwmw@amazon.co.uk>
    x86/kexec: Allocate PGD for x86_64 transition page tables separately

Liu Ye <liuye@kylinos.cn>
    selftests/net/ipsec: Fix Null pointer dereference in rtattr_pack()

Dan Carpenter <dan.carpenter@linaro.org>
    tipc: re-order conditions in tipc_crypto_key_rcv()

Yuanjie Yang <quic_yuanjiey@quicinc.com>
    mmc: sdhci-msm: Correctly set the load for the regulator

Maciej S. Szmigiero <mail@maciej.szmigiero.name>
    net: wwan: iosm: Fix hibernation by re-binding the driver around it

Mazin Al Haddad <mazin@getstate.dev>
    Bluetooth: MGMT: Fix slab-use-after-free Read in mgmt_remove_adv_monitor_sync

Borislav Petkov <bp@alien8.de>
    APEI: GHES: Have GHES honor the panic= setting

Randolph Ha <rha051117@gmail.com>
    i2c: Force ELAN06FA touchpad I2C bus freq to 100KHz

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: avoid memory leak

Stefan Dösinger <stefan@codeweavers.com>
    wifi: brcmfmac: Check the return value of of_property_read_string_index()

Vadim Fedorenko <vadfed@meta.com>
    net/mlx5: use do_aux_work for PHC overflow checks

Even Xu <even.xu@intel.com>
    HID: Wacom: Add PCI Wacom device support

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    clk: qcom: Make GCC_8150 depend on QCOM_GDSC

Hans de Goede <hdegoede@redhat.com>
    mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: don't emit warning in tomoyo_write_control()

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Respect quirk_max_rate for non-UHS SDIO card

Stas Sergeev <stsp2@yandex.ru>
    tun: fix group permission check

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: add crystal_cap check to avoid setting as overflow value

Leo Stone <leocstone@gmail.com>
    safesetid: check size of policy writes

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP CTS KSV list wait timer

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP CTS compare V matching

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP encryption when R0 ready

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: fix HDCP Bstatus check

Hermes Wu <hermes.wu@ite.com.tw>
    drm/bridge: it6505: Change definition MAX_HDCP_DOWN_STREAM_COUNT

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix Mode Cutoff in DSC Passthrough to DP2.1 Monitor

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/vc4: hdmi: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/sti: hdmi: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/radeon: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/exynos: hdmi: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/amd/display: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: ite-it66121: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/bridge: anx7625: use eld_mutex to protect access to connector->eld

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/connector: add mutex to protect ELD from concurrent access

Kuan-Wei Chiu <visitorckw@gmail.com>
    printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX

Dongwon Kim <dongwon.kim@intel.com>
    drm/virtio: New fence for every plane update

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/amd_nb: Restrict init function to AMD-based systems

Carlos Llamas <cmllamas@google.com>
    lockdep: Fix upper limit for LOCKDEP_*_BITS configs

Suleiman Souhlal <suleiman@google.com>
    sched: Don't try to catch up excess steal time.

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert BUG_ON in btrfs_reloc_cow_block() to proper error handling

Hao-ran Zheng <zhenghaoran154@gmail.com>
    btrfs: fix data race when accessing the inode's disk_i_size at btrfs_drop_extents()

Sven Schnelle <svens@linux.ibm.com>
    s390/stackleak: Use exrl instead of ex in __stackleak_poison()

Kees Cook <kees@kernel.org>
    exec: fix up /proc/pid/comm in the execveat(AT_EMPTY_PATH) case

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Ensure adequate HUGE_MAX_HSTATE

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free when attempting to join an aborted transaction

Filipe Manana <fdmanana@suse.com>
    btrfs: fix assertion failure when splitting ordered extent after transaction abort


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/boot/dts/ti/omap/dra7-l4.dtsi             |   2 +
 arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi         |  10 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   6 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm6350.dtsi               |   6 +-
 arch/arm64/boot/dts/qcom/sm6375.dtsi               |  10 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               | 492 ++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   4 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |   9 +-
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |   2 +-
 arch/arm64/kvm/arch_timer.c                        |   4 +-
 arch/arm64/mm/hugetlbpage.c                        |  12 +
 arch/loongarch/include/uapi/asm/ptrace.h           |  10 +
 arch/loongarch/kernel/ptrace.c                     |   6 +-
 arch/m68k/include/asm/vga.h                        |   8 +-
 arch/mips/kernel/ftrace.c                          |   2 +-
 arch/mips/loongson64/boardinfo.c                   |   2 -
 arch/mips/math-emu/cp1emu.c                        |   2 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |  21 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   6 +-
 arch/s390/include/asm/futex.h                      |   2 +-
 arch/s390/include/asm/processor.h                  |   3 +-
 arch/s390/kvm/vsie.c                               |  25 +-
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/include/asm/kexec.h                       |  18 +-
 arch/x86/include/asm/kvm_host.h                    |   2 +
 arch/x86/kernel/amd_nb.c                           |   4 +
 arch/x86/kernel/machine_kexec_64.c                 |  45 +-
 arch/x86/kvm/lapic.c                               |  64 ++-
 arch/x86/kvm/svm/svm.c                             |   2 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +
 arch/x86/mm/ident_map.c                            |  23 +-
 arch/x86/pci/fixup.c                               |  30 ++
 arch/x86/xen/xen-head.S                            |   5 +-
 block/blk-cgroup.c                                 |   1 +
 block/fops.c                                       |   5 +-
 drivers/acpi/apei/ghes.c                           |  10 +-
 drivers/acpi/prmt.c                                |   4 +-
 drivers/acpi/property.c                            |  10 +-
 drivers/ata/libata-sff.c                           |  18 +-
 drivers/char/misc.c                                |  37 +-
 drivers/char/tpm/eventlog/acpi.c                   |  15 +-
 drivers/clk/mediatek/clk-mt2701-aud.c              |  10 +
 drivers/clk/mediatek/clk-mt2701-bdp.c              |   1 +
 drivers/clk/mediatek/clk-mt2701-img.c              |   1 +
 drivers/clk/mediatek/clk-mt2701-mm.c               |   1 +
 drivers/clk/mediatek/clk-mt2701-vdec.c             |   1 +
 drivers/clk/qcom/Kconfig                           |   1 +
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 +
 drivers/clk/qcom/clk-rpmh.c                        |   2 +-
 drivers/clk/qcom/dispcc-sm6350.c                   |   7 +-
 drivers/clk/qcom/gcc-mdm9607.c                     |   2 +-
 drivers/clk/qcom/gcc-sm6350.c                      |  22 +-
 drivers/clk/qcom/gcc-sm8550.c                      |   8 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a100.c             |   6 +-
 drivers/cpufreq/s3c64xx-cpufreq.c                  |  11 +-
 drivers/crypto/qce/aead.c                          |   2 +-
 drivers/crypto/qce/core.c                          |  13 +-
 drivers/crypto/qce/sha.c                           |   2 +-
 drivers/crypto/qce/skcipher.c                      |   2 +-
 drivers/firmware/Kconfig                           |   2 +-
 drivers/firmware/efi/libstub/Makefile              |   2 +-
 drivers/gpio/gpio-pca953x.c                        |  19 -
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   2 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   6 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |   3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |   1 -
 .../drm/arm/display/komeda/komeda_wb_connector.c   |   4 +
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   2 +
 drivers/gpu/drm/bridge/ite-it6505.c                |  83 ++--
 drivers/gpu/drm/bridge/ite-it66121.c               |   2 +
 drivers/gpu/drm/display/drm_dp_cec.c               |  14 +-
 drivers/gpu/drm/drm_connector.c                    |   1 +
 drivers/gpu/drm/drm_edid.c                         |   6 +
 drivers/gpu/drm/drm_fb_helper.c                    |  14 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |   2 +
 drivers/gpu/drm/i915/display/skl_universal_plane.c |   4 -
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |   6 +-
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |  20 +-
 drivers/gpu/drm/radeon/radeon_audio.c              |   2 +
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |   9 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |   2 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   4 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   7 +
 drivers/gpu/drm/virtio/virtgpu_plane.c             |  58 ++-
 drivers/hid/hid-sensor-hub.c                       |  21 +-
 drivers/hid/wacom_wac.c                            |   5 +
 drivers/i2c/i2c-core-acpi.c                        |  22 +
 drivers/i3c/master.c                               |   2 +-
 drivers/iio/light/as73211.c                        |  24 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  17 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c         |   1 +
 drivers/irqchip/irq-apple-aic.c                    |   3 +-
 drivers/leds/leds-lp8860.c                         |   2 +-
 drivers/mailbox/tegra-hsp.c                        |   6 +-
 drivers/md/dm-crypt.c                              |  27 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   6 +-
 drivers/media/i2c/ccs/ccs-data.c                   |  14 +-
 drivers/media/i2c/ds90ub913.c                      |   1 -
 drivers/media/i2c/ds90ub953.c                      |   1 -
 drivers/media/i2c/ds90ub960.c                      | 123 +++---
 drivers/media/i2c/imx296.c                         |   2 +
 drivers/media/i2c/ov5640.c                         |   1 +
 drivers/media/platform/marvell/mmp-driver.c        |  21 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |   8 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  98 ++--
 drivers/media/usb/uvc/uvc_video.c                  |  21 +
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/media/v4l2-core/v4l2-mc.c                  |   2 +-
 drivers/mfd/lpc_ich.c                              |   3 +-
 drivers/misc/fastrpc.c                             |   8 +-
 drivers/mmc/core/sdio.c                            |   2 +
 drivers/mmc/host/sdhci-msm.c                       |  53 ++-
 drivers/mtd/nand/onenand/onenand_base.c            |   1 +
 drivers/mtd/ubi/build.c                            |   2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  16 +-
 drivers/net/ethernet/broadcom/tg3.c                |  58 +++
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   3 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  79 ++--
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  24 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |   2 +
 drivers/net/tun.c                                  |   2 +-
 drivers/net/usb/ipheth.c                           |  69 ++-
 drivers/net/vmxnet3/vmxnet3_xdp.c                  |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   8 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  21 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   3 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   4 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |   2 +
 drivers/net/wireless/realtek/rtw89/phy.c           |  13 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   2 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  56 ++-
 drivers/nvme/host/core.c                           |   8 +-
 drivers/nvme/host/fc.c                             |   9 +-
 drivers/nvme/host/pci.c                            |   4 +-
 drivers/nvmem/core.c                               |   2 +
 drivers/nvmem/imx-ocotp-ele.c                      |  16 +-
 drivers/nvmem/qcom-spmi-sdam.c                     |   1 +
 drivers/of/base.c                                  |   8 +-
 drivers/of/of_reserved_mem.c                       |   4 +-
 drivers/pci/endpoint/pci-epf-core.c                |   1 +
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +-
 drivers/platform/x86/acer-wmi.c                    |   4 +
 drivers/platform/x86/intel/int3472/discrete.c      |   3 +
 drivers/platform/x86/intel/int3472/tps68470.c      |   3 +
 drivers/ptp/ptp_clock.c                            |   8 +
 drivers/pwm/pwm-microchip-core.c                   |   2 +-
 drivers/rtc/rtc-zynqmp.c                           |   4 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_dfs.c                     | 122 ++++-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   3 +
 drivers/scsi/qla2xxx/qla_init.c                    |  28 +-
 drivers/scsi/st.c                                  |   6 +
 drivers/scsi/st.h                                  |   1 +
 drivers/scsi/storvsc_drv.c                         |   1 +
 drivers/soc/mediatek/mtk-devapc.c                  |  18 +-
 drivers/soc/qcom/smem_state.c                      |   3 +-
 drivers/soc/qcom/socinfo.c                         |   2 +-
 drivers/spi/atmel-quadspi.c                        | 118 +++--
 drivers/tty/serial/sh-sci.c                        |  25 +-
 drivers/tty/serial/xilinx_uartps.c                 |  10 +-
 drivers/ufs/host/ufs-qcom.c                        |  18 +-
 drivers/usb/gadget/function/f_tcm.c                |  52 +--
 drivers/vfio/platform/vfio_platform_common.c       |  10 +
 fs/binfmt_flat.c                                   |   2 +-
 fs/btrfs/file.c                                    |   2 +-
 fs/btrfs/inode.c                                   |   4 +-
 fs/btrfs/ordered-data.c                            |  12 +
 fs/btrfs/relocation.c                              |  14 +-
 fs/btrfs/transaction.c                             |   4 +-
 fs/cachefiles/interface.c                          |  14 +-
 fs/cachefiles/ondemand.c                           |  30 +-
 fs/exec.c                                          |  29 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  27 +-
 fs/nilfs2/inode.c                                  |   6 +-
 fs/ocfs2/dir.c                                     |  25 +-
 fs/ocfs2/super.c                                   |   2 +-
 fs/ocfs2/symlink.c                                 |   5 +-
 fs/proc/array.c                                    |   2 +-
 fs/smb/client/cifsglob.h                           |  14 +-
 fs/smb/client/dir.c                                |   6 +-
 fs/smb/client/smb1ops.c                            |   2 +-
 fs/smb/client/smb2inode.c                          | 108 ++---
 fs/smb/client/smb2ops.c                            |  18 +-
 fs/smb/client/smb2pdu.c                            |   2 +-
 fs/smb/client/smb2proto.h                          |   2 +-
 fs/smb/server/transport_ipc.c                      |   9 +
 fs/xfs/xfs_inode.c                                 |   7 +-
 fs/xfs/xfs_iomap.c                                 |   6 +-
 include/drm/drm_connector.h                        |   5 +-
 include/linux/binfmts.h                            |   4 +-
 include/linux/kvm_host.h                           |   9 +
 include/linux/mlx5/driver.h                        |   1 -
 include/net/sch_generic.h                          |   2 +-
 include/rv/da_monitor.h                            |   4 +
 include/trace/events/rxrpc.h                       |   1 +
 include/uapi/linux/input-event-codes.h             |   1 +
 include/ufs/ufs.h                                  |   4 +-
 io_uring/io_uring.c                                |   5 +-
 io_uring/net.c                                     |   5 +
 io_uring/poll.c                                    |   4 +
 io_uring/rw.c                                      |  10 +
 kernel/printk/printk.c                             |   2 +-
 kernel/sched/core.c                                |   6 +-
 kernel/trace/trace_osnoise.c                       |  17 +-
 lib/Kconfig.debug                                  |   8 +-
 lib/maple_tree.c                                   |  23 +-
 mm/kfence/core.c                                   |   2 +
 mm/kmemleak.c                                      |   2 +-
 net/bluetooth/l2cap_sock.c                         |   7 +-
 net/bluetooth/mgmt.c                               |  12 +-
 net/ipv4/udp.c                                     |   4 +-
 net/ipv6/udp.c                                     |   4 +-
 net/mptcp/pm_netlink.c                             |   3 +-
 net/mptcp/protocol.c                               |   1 +
 net/ncsi/internal.h                                |   2 +
 net/ncsi/ncsi-cmd.c                                |   3 +-
 net/ncsi/ncsi-manage.c                             |  38 +-
 net/ncsi/ncsi-pkt.h                                |  10 +
 net/ncsi/ncsi-rsp.c                                |  58 ++-
 net/nfc/nci/hci.c                                  |   2 +
 net/rose/af_rose.c                                 |  24 +-
 net/rxrpc/ar-internal.h                            |   2 +-
 net/rxrpc/call_object.c                            |   6 +-
 net/rxrpc/conn_event.c                             |  21 +-
 net/rxrpc/conn_object.c                            |   1 +
 net/rxrpc/input.c                                  |   2 +-
 net/rxrpc/sendmsg.c                                |   2 +-
 net/sched/sch_netem.c                              |   2 +-
 net/tipc/crypto.c                                  |   4 +-
 rust/kernel/init.rs                                |   2 +-
 scripts/Makefile.extrawarn                         |   5 +-
 scripts/gdb/linux/cpus.py                          |   2 +-
 security/safesetid/securityfs.c                    |   3 +
 security/tomoyo/common.c                           |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   8 +-
 sound/pci/hda/hda_auto_parser.h                    |   1 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/Kconfig                              |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  28 ++
 sound/soc/soc-pcm.c                                |  32 +-
 tools/perf/bench/epoll-wait.c                      |   7 +-
 tools/testing/selftests/net/ipsec.c                |   3 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   2 +-
 tools/testing/selftests/net/udpgso.c               |  26 ++
 tools/tracing/rtla/src/osnoise.c                   |   2 +-
 tools/tracing/rtla/src/timerlat_hist.c             |  26 +-
 tools/tracing/rtla/src/timerlat_top.c              |  27 +-
 tools/tracing/rtla/src/trace.c                     |   8 +
 tools/tracing/rtla/src/trace.h                     |   1 +
 258 files changed, 2392 insertions(+), 1203 deletions(-)


