Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A472F7EFE;
	Sun,  7 Jun 2026 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826607; cv=none; b=e+/k2pScdOEeGu3WBKl0IzYQj8D3IO0WaDWbxQ5HoirOKPAZjEs+sv9gQb54oWMIlTXG8cAL24yr16WRrAVDl/Kd9DYf/jdTbJVcjx5ri/gihtEati4MLRgJcwPamBs9rmtNu+LTx/EUSQb7oP1S28TGh3kXxUycINHBkrXHr2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826607; c=relaxed/simple;
	bh=72qZlKgGeyexwAZraYnT3uoNYlk+jupBfnl1XzQIoJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S0/fnpJG0DgrqzoRXi+8iad2j0P6qv65FYELsNN/zun9HbC9sgJdAAE8cUhBSLCtTfmGQXUvf3Rtgr5Dy/dvls7bV2lOt4/aoVj+AI7ed93BHkY0dmwsJwBIbA4Gypo0L2A+e26s4AOQN+i7Z0bRWNXGTZAVtqfx2oe9vMxUfo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LztD6AxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LztD6AxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179781F00893;
	Sun,  7 Jun 2026 10:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826603;
	bh=8iKI2Lf2OJ8Vl8yZ0IZxNeJuTVV42DtL98NecAmAx2g=;
	h=From:To:Cc:Subject:Date;
	b=LztD6AxCEqtx9KU7E5956Z9I2zrTV/yJSfi0ad/8HUa1lh9eN+/7zJUURLiT4Z3Fv
	 tjbFN1JhVMXlCSEVeqTij2AKy+o5XBnG071ca5UFoqDhfYIjcisO59RS20zyCMEOF7
	 7wcoRQKhq4ZuHgQLNME3SXR8NzWhWUTA9HmVP4VY=
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
Subject: [PATCH 6.12 000/307] 6.12.93-rc1 review
Date: Sun,  7 Jun 2026 11:56:37 +0200
Message-ID: <20260607095727.647295505@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.93-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.93-rc1
X-KernelTest-Deadline: 2026-06-09T09:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.93 release.
There are 307 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 09 Jun 2026 09:56:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.93-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.93-rc1

Pratyush Yadav (Google) <pratyush@kernel.org>
    memfd: deny writeable mappings when implying SEAL_WRITE

Liu Ye <liuye@kylinos.cn>
    mm/memfd: fix spelling and grammatical issues

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    mm: perform all memfd seal checks in a single place

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/adm1266) serialize GPIO PMBus accesses with pmbus_lock

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/adm1266) serialize NVMEM blackbox read with pmbus_lock

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pmbus_lock

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    x86/ftrace: Relocate %rip-relative percpu refs in dynamic trampolines

Ingo Molnar <mingo@kernel.org>
    x86/alternatives: Rename 'apply_relocation()' to 'text_poke_apply_relocation()'

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Don't update power_supply on power role change if not connected

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: target: iscsi: Fix CRC overread and double-free in iscsit_handle_text_cmd()

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: property: Cap recursion depth in __tb_property_parse_dir()

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Check if power role change actually happened before handling

Wentao Liang <vulab@iscas.ac.cn>
    usb: musb: omap2430: Fix use-after-free in omap2430_probe()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: xilinx: fix error handling in zynqmp init error paths

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: firewire-motu: Protect register DSP event queue positions

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: fix ref bit initialization for single-channel parts

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: scd30: fix division by zero in write_raw

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: chemical: scd30: Use guard(mutex) to allow early returns

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()

Shardul Bankar <shardul.b@mpiricsoftware.com>
    mptcp: do not drop partial packets

Paolo Abeni <pabeni@redhat.com>
    mptcp: handle first subflow closing consistently

Paolo Abeni <pabeni@redhat.com>
    mptcp: introduce the mptcp_init_skb helper

Dawei Feng <dawei.feng@seu.edu.cn>
    octeontx2-pf: avoid double free of pool->stack on AQ init failure

Zeng Heng <zengheng4@huawei.com>
    arm64: tlb: Flush walk cache when unsharing PMD tables

Paolo Abeni <pabeni@redhat.com>
    mptcp: reset rcv wnd on disconnect

Paolo Abeni <pabeni@redhat.com>
    mptcp: cleanup fallback dummy mapping generation

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    ring-buffer: Flush and stop persistent ring buffer on panic

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    ice: fix VF queue configuration with low MTU values

Li Xiasong <lixiasong1@huawei.com>
    mptcp: pm: fix ADD_ADDR timer infinite retry on option space insufficient

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: drop nanoseconds width specifier

Michael Bommarito <michael.bommarito@gmail.com>
    net: hsr: defer node table free until after RCU readers

Lukas Wunner <lukas@wunner.de>
    platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery

Alistair Popple <apopple@nvidia.com>
    mm/memory: fix spurious warning when unmapping device-private/exclusive pages

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: scarlett2: Allow flash writes ending at segment boundary

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Return ENOSPC for out-of-bounds flash writes

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    Bluetooth: hci_qca: Convert timeout from jiffies to ms

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    Bluetooth: hci_qca: Migrate to serdev specific shutdown function

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    serdev: Provide a bustype shutdown function

David Howells <dhowells@redhat.com>
    rxrpc: Fix RESPONSE packet verification to extract skb to a linear buffer

David Howells <dhowells@redhat.com>
    rxrpc: Fix DATA decrypt vs splice() by copying data to buffer in recvmsg

Aleksandr Nogikh <nogikh@google.com>
    x86/kexec: Disable KCOV instrumentation after load_segments()

Brian Gerst <brgerst@gmail.com>
    x86/boot: Disable stack protector for early boot code

Tushar Dave <tdave@nvidia.com>
    iommu: Skip PASID validation for devices without PASID capability

Wei-Cheng Chen <weichengc@nvidia.com>
    xhci: tegra: Fix ghost USB device on dual-role port unplug

Johan Hovold <johan@kernel.org>
    USB: serial: digi_acceleport: fix memory corruption with small endpoints

Johan Hovold <johan@kernel.org>
    USB: serial: cypress_m8: fix memory corruption with small endpoint

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: zs: Convert to use a platform device

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: zs: Switch to using channel reset

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: zs: Fix bootconsole handover lockup

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: dz: Convert to use a platform device

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: dz: Fix bootconsole handover lockup

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: dz: Fix bootconsole message clobbering at chip reset

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check for pdd drm file first in CRIU restore path

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix a vulnerability of integer overflow in kfd debugger

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: fix NULL pointer bug in svm_range_set_attr

Shitalkumar Gandhi <shital.gandhi45@gmail.com>
    serial: fsl_lpuart: fix rx buffer and DMA map leaks in start_rx_dma

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: zs: Fix swapped RI/DSR modem line transition counting

Hongling Zeng <zenghongling@kylinos.cn>
    serial: sh-sci: fix memory region release in error path

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    serial: qcom_geni: fix kfifo underflow when flush precedes DMA completion IRQ

Prasanna S <prasanna.s@oss.qualcomm.com>
    serial: qcom-geni: fix UART_RX_PAR_EN bit position

Myeonghun Pak <mhun512@gmail.com>
    serial: altera_jtaguart: handle uart_add_one_port() failures

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Disregard vblank time when no displays are connected

Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
    drm/i915: Fix potential UAF in TTM object purge

Berkant Koc <me@berkoc.com>
    drm/hyperv: validate VMBus packet size in receive callback

Berkant Koc <me@berkoc.com>
    drm/hyperv: validate resolution_count and fix WIN8 fallback

Alexandru Hossu <hossu.alexandru@gmail.com>
    scsi: target: iscsi: Validate CHAP_R length before base64 decode

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: target: iscsi: Bound iscsi_encode_text_output() appends to rsp_buf

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: scsi_transport_fc: Widen FPIN pname walker counter to u32

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: property: Reject dir_len < 4 to prevent size_t underflow

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: property: Reject u32 wrap in tb_property_entry_valid()

Michael Bommarito <michael.bommarito@gmail.com>
    usb: gadget: f_fs: serialize DMABUF cancel against request completion

Michael Bommarito <michael.bommarito@gmail.com>
    usb: gadget: f_fs: copy only received bytes on short ep0 read

Seungjin Bae <eeodqql09@gmail.com>
    usb: gadget: dummy_hcd: Reject hub port requests for non-existent ports

Jeremy Erazo <mendozayt13@gmail.com>
    usb: gadget: composite: fix integer underflow in WebUSB GET_URL handling

Guangshuo Li <lgs201920130244@gmail.com>
    usb: gadget: f_hid: fix device reference leak in hidg_alloc()

Guangshuo Li <lgs201920130244@gmail.com>
    usb: gadget: net2280: Fix double free in probe error path

Kai Aizen <kai.aizen.dev@gmail.com>
    usb: gadget: uvc: hold opts->lock across XU walks in uvc_function_bind

Johan Hovold <johan@kernel.org>
    USB: serial: mct_u232: fix missing interrupt-in transfer sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: mxuport: fix memory corruption with small endpoint

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: fix missing indat transfer sanity check

Zhang Cen <rollkingzzc@gmail.com>
    USB: serial: cypress_m8: validate interrupt packet headers

Zhang Cen <rollkingzzc@gmail.com>
    USB: serial: belkin_sa: validate interrupt status length

Wanquan Zhong <wanquan.zhong@fibocom.com>
    USB: serial: option: add missing RSVD(5) flag for Rolling RW135R-GL

Jan Volckaert <janvolck@gmail.com>
    USB: serial: option: add MeiG SRM813Q

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: tcpm: improve handling of DISCOVER_MODES failures

Heitor Alves de Siqueira <halves@igalia.com>
    usb: usbtmc: reject interrupt endpoints with small wMaxPacketSize

Heitor Alves de Siqueira <halves@igalia.com>
    usb: usbtmc: check URB actual_length for interrupt-IN notifications

Michael Bommarito <michael.bommarito@gmail.com>
    usbip: vudc: Fix use after free bug in vudc_remove due to race condition

Sam Burkels <sam@1a38.nl>
    usb: storage: Add quirks for PNY Elite Portable SSD

Stephen J. Fuhry <fuhrysteve@gmail.com>
    USB: quirks: add NO_LPM for Lenovo ThinkPad USB-C Dock Gen2 hub controllers

Michal Pecio <michal.pecio@gmail.com>
    usb: core: Fix up Interrupt IN endpoints with bogus wBytesPerInterval

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: convert ci_role_switch to local variable

Tudor Ambarus <tudor.ambarus@linaro.org>
    tty: serial: samsung: Remove redundant port lock acquisition in rx helpers

Zhaoyang Yu <2426767509@qq.com>
    tty: serial: pch_uart: add check for dma_alloc_coherent()

Guangshuo Li <lgs201920130244@gmail.com>
    counter: Fix refcount leak in counter_alloc() error path

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: Fix limiting of convert_arg in waveform_ai_cmdtest()

Ian Abbott <abbotti@mev.co.uk>
    comedi: comedi_test: fix check for valid scan_begin_src in waveform_ai_cmdtest()

Nicolás Bazaes <contacto@bazaes.cl>
    Input: synaptics - add LEN2058 to SMBus passlist for ThinkPad E490

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem

Ali Ganiyev <ali.qaniyev@gmail.com>
    ksmbd: OOB read regression in smb_check_perm_dacl() ACE-walk loops

Dmitriy Zharov <contact@zharov.dev>
    Input: xpad - add support for ASUS ROG RAIKIRI II

Qbeliw Tanaka <q.tanaka@gmx.com>
    Input: xpad - add "Nova 2 Lite" from GameSir

Jingguo Tan <tanjingguo@huawei.com>
    xfrm: esp: restore combined single-frag length gate

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: close stream only when running

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Fix 2i2 Gen 4 direct monitor gain on firmware 2417

Michael Bommarito <michael.bommarito@gmail.com>
    xfrm: ah: use skb_to_full_sk in async output callbacks

Maoyi Xie <maoyixie.tju@gmail.com>
    xfrm: route MIGRATE notifications to caller's netns

Ashutosh Desai <ashutoshdesai993@gmail.com>
    nfc: hci: fix out-of-bounds read in HCP header parsing

Arnd Bergmann <arnd@arndb.de>
    iommu, debugobjects: avoid gcc-16.1 section mismatch warnings

Lee Jones <lee@kernel.org>
    HID: wacom: Fix OOB write in wacom_hid_set_device_mode()

Minh Nguyen <minhnguyen.080505@gmail.com>
    net: skbuff: fix missing zerocopy reference in pskb_carve helpers

Kuniyuki Iwashima <kuniyu@google.com>
    ip6: vti: Use ip6_tnl.net in vti6_changelink().

Michael Bommarito <michael.bommarito@gmail.com>
    l2tp: use refcount_inc_not_zero in l2tp_session_get_by_ifname

Zhengchuan Liang <zcliangcn@gmail.com>
    xfrm: input: hold netns during deferred transport reinjection

Qi Tang <tpluszz77@gmail.com>
    ipv6: validate extension header length before copying to cmsg

Maoyi Xie <maoyixie.tju@gmail.com>
    ip6: vti: Use ip6_tnl.net in vti6_siocdevprivate().

Zhengchuan Liang <zcliangcn@gmail.com>
    ipv6: exthdrs: refresh nh after handling HAO option

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: fix error handling in prepare and set_params

Justin Iurman <justin.iurman@gmail.com>
    ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()

Junrui Luo <moonafterrain@outlook.com>
    macsec: fix replay protection at XPN lower-PN wrap

Yuqi Xu <xuyq21@lenovo.com>
    bpf: sockmap: fix tail fragment offset in bpf_msg_push_data

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: send: append trailer after expanding head

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: elan_i2c - validate firmware size before use

Dan Carpenter <error27@gmail.com>
    usb: dwc2: Fix use after free in debug code

Peter Chen <peter.chen@cixtech.com>
    usb: cdns3: plat: fix unbalanced pm_runtime_forbid() call permanently leaks the runtime PM usage counter across bind/unbind cycles

Peter Chen <peter.chen@cixtech.com>
    usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acquisition failure

Yongchao Wu <yongchao.wu@autochips.com>
    usb: cdns3: gadget: fix request skipping after clearing halt

Johan Hovold <johan@kernel.org>
    USB: serial: omninet: fix memory corruption with small endpoint

Benoît Monin <benoit.monin@bootlin.com>
    iio: buffer: Fix DMA fence leak in iio_buffer_enqueue_dmabuf()

Felix Gu <ustc.gu@gmail.com>
    iio: buffer: hw-consumer: fix use-after-free in error path

Aldo Conte <aldocontelk@gmail.com>
    iio: light: cm3323: fix reg_conf not being initialized correctly

Advait Dhamorikar <advaitd@mechasystems.com>
    iio: magnetometer: st_magn: fix default DRDY pin selection for LIS2MDL

Salah Triki <salah.triki@gmail.com>
    iio: temperature: tsys01: fix broken PROM checksum validation

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: ssp_sensors: cancel delayed work_refresh on remove

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: gyro: adis16260: fix division by zero in write_raw

David Carlier <devnexen@gmail.com>
    iio: gyro: itg3200: fix i2c read into the wrong stack location

Salah Triki <salah.triki@gmail.com>
    iio: adc: viperboard: Fix error handling in vprbrd_iio_read_raw

Salah Triki <salah.triki@gmail.com>
    iio: adc: mt6359: fix unchecked return value in mt6358_read_imp

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: acquire lock when doing powerdown control

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: fix input raw value check

Salah Triki <salah.triki@gmail.com>
    iio: dac: max5821: fix return value check in powerdown sync

David Carlier <devnexen@gmail.com>
    iio: adc: npcm: fix unbalanced clk_disable_unprepare()

Christofer Jonason <christofer.jonason@guidelinegeo.com>
    iio: adc: xilinx-xadc: Fix sequencer mode in postdisable for dual mux

Nathan Chancellor <nathan@kernel.org>
    Disable -Wattribute-alias for clang-23 and newer

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Don't explicitly pass PSC buffer to snp_begin_psc()

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Use READ_ONCE() when reading entries/indices from PSC buffer

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Check PSC request indices against the actual size of the buffer

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Compute the correct max length of the in-GHCB scratch area

Sean Christopherson <seanjc@google.com>
    KVM: SEV: WARN if KVM attempts to setup scratch area with min_len==0

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Use the size of the PSC header as the minimum size for PSC requests

Michael Roth <michael.roth@amd.com>
    KVM: SEV: Require in-GHCB scratch area if GHCB v2+ is in use

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Flush the current TLB when transitioning from xAVIC => x2AVIC

Qiang Ma <maqianga@uniontech.com>
    KVM: arm64: PMU: Preserve AArch32 counter low bits

Wentao Guan <guanwentao@uniontech.com>
    USB: cdc-acm: Fix bit overlap and move quirk definitions to header

Ben Hutchings <benh@debian.org>
    parport: Fix race between port and client registration

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: xpad - fix out-of-bounds access for Share button

Doruk Tan Ozturk <doruk@0sec.ai>
    Bluetooth: hci_sync: fix UAF in hci_le_create_cis_sync

Muhammad Bilal <meatuni001@gmail.com>
    Bluetooth: ISO: serialize iso_sock_clear_timer with socket lock

Muhammad Bilal <meatuni001@gmail.com>
    Bluetooth: ISO: fix UAF in iso_recv_frame

Muhammad Bilal <meatuni001@gmail.com>
    Bluetooth: HIDP: fix missing length checks in hidp_input_report()

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: fix chan ref leak in l2cap_chan_timeout() on !conn

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: use chan timer to close channels in cleanup_listen()

Stepan Ionichev <sozdayvek@gmail.com>
    auxdisplay: line-display: fix OOB read on zero-length message_store()

Linpu Yu <linpu5433@gmail.com>
    ipc: limit next_id allocation to the valid ID range

Mikulas Patocka <mpatocka@redhat.com>
    hpfs: fix a crash if hpfs_map_dnode_bitmap fails

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    Bluetooth: btusb: Allow firmware re-download when version matches

hlleng <a909204013@gmail.com>
    HID: quirks: Add ALWAYS_POLL quirk for SIGMACHIP USB mouse

Thomas Fourier <fourier.thomas@gmail.com>
    Input: ims-pcu - fix usb_free_coherent() size in ims_pcu_buffers_free()

Henri A <contact@henrialfonso.com>
    media: rc: igorplugusb: fix control request setup packet

Johan Hovold <johan@kernel.org>
    USB: serial: safe_serial: fix memory corruption with small endpoint

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: ucsi: validate connector number in ucsi_connector_change()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm/tcpci_maxim: validate header NDO against RX_BYTE_CNT

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: wcove: don't write past struct pd_message in wcove_read_rx_buffer()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: altmodes/displayport: validate count before reading Status Update VDO

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: ucsi: displayport: NAK DP_CMD_CONFIGURE without a payload VDO

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: bound altmode_desc[] per iteration in svdm_consume_modes()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: tcpm: validate VDO count in Discover Identity ACK handlers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: typec: ucsi: ccg: reject firmware images without a ':' record header

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    iio: imu: st_lsm6dsx: fix stack leak in tagged FIFO buffer

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: prevent TVLV entry number overflow

Horatiu Vultur <horatiu.vultur@microchip.com>
    phy: mscc: Use PHY_ID_MATCH_EXACT for VSC8584, VSC8582, VSC8575, VSC856X

Will Deacon <will@kernel.org>
    arm64: io: Extract user memory type in ioremap_prot()

Will Deacon <will@kernel.org>
    arm64: io: Rename ioremap_prot() to __ioremap_prot()

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Apply Intel DPCD workaround when SDP on prior line used

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/dp: Add eDP 1.5 bit definition

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Read Intel DPCD workaround register

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Add defininitions for INTEL_WA_REGISTER_CAPS DPCD register

Nathan Chancellor <nathan@kernel.org>
    HID: core: Fix size_t specifier in hid_report_raw_event()

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: introduce hid_safe_input_report()

Benjamin Tissoires <bentiss@kernel.org>
    HID: pass the buffer size to hid_report_raw_event

Vicki Pfau <vi@endrift.com>
    HID: core: Add printk_ratelimited variants to hid_warn() etc

Jakub Kicinski <kuba@kernel.org>
    inet: frags: flush pending skbs in fqdir_pre_exit()

Jakub Kicinski <kuba@kernel.org>
    inet: frags: add inet_frag_queue_flush()

Oliver Neukum <oneukum@suse.com>
    media: rc: ttusbir: fix inverted error logic

Sean Young <sean@mess.org>
    media: rc: fix race between unregister and urb/irq callbacks

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    mm/page_alloc: clear page->private in free_pages_prepare()

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: avoid double decrement of bla.num_requests

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: avoid empty VLAN responses

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: fix TOCTOU race for reported vlans

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: directly shut down timer on cleanup

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: Restore GFP_DMA for CHSC allocation

Sven Eckelmann <sven@narfation.org>
    batman-adv: tp_meter: avoid role confusion in tp_list

Sven Eckelmann <sven@narfation.org>
    batman-adv: iv: recover OGM scheduling after forward packet error

Sven Eckelmann <sven@narfation.org>
    batman-adv: tvlv: reject oversized TVLV packets

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: avoid NULL-ptr deref for claim via dropped interface

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: reject oversized local TVLV buffers

Sven Eckelmann <sven@narfation.org>
    batman-adv: tvlv: abort OGM send on tvlv append failure

Sven Eckelmann <sven@narfation.org>
    batman-adv: v: stop OGMv2 on disabled interface

Yeoreum Yun <yeoreum.yun@arm.com>
    perf: Fix dangling cgroup pointer in cpuctx

Pavel Begunkov <asml.silence@gmail.com>
    net: skbuff: fix pskb_carve leaking zcopy pages

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: fix possible infinite loop in fib6_select_path()

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: fix possible infinite loop in rt6_fill_node()

Zhenghang Xiao <kipreyyy@gmail.com>
    sctp: fix race between sctp_wait_for_connect and peeloff

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: Add NULL guards in teardown path to prevent panic on attach failure

Marco Scardovi <scardracs@disroot.org>
    gpio: rockchip: convert bank->clk to devm_clk_get_enabled()

Dan Carpenter <error27@gmail.com>
    gpio: virtuser: Fix uninitialized data bug in gpio_virtuser_direction_do_write()

Heitor Alves de Siqueira <halves@igalia.com>
    Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp

Zhenghang Xiao <kipreyyy@gmail.com>
    Bluetooth: l2cap: clear chan->ident on ECRED reconfiguration success

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Drain pending requests at net namespace exit

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Take a long-lived file reference at submit

Al Viro <viro@zeniv.linux.org.uk>
    remove pointless includes of <linux/fdtable.h>

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Pass negative errno through handshake_complete()

Chuck Lever <chuck.lever@oracle.com>
    nvme-tcp: store negative errno in queue->tls_err

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Use spin_lock_bh for hn_lock

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_mirred: Fix return code in early mirred redirect error paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop

Jamal Hadi Salim <jhs@mojatatu.com>
    net: Introduce skb tc depth field to track packet loops

Eric Dumazet <edumazet@google.com>
    net/sched: act_mirred: add loop detection

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net/sched: act_mirred: Move the recursion counter struct netdev_xmit

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fix packet loop on netem when duplicate is on

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Revert "net/sched: Restrict conditions for adding duplicating netems to qdisc tree"

Rahul Chandelkar <rc@rexion.ai>
    ipv6: rpl: fix hdrlen overflow in ipv6_rpl_srh_decompress()

Jakub Kicinski <kuba@kernel.org>
    ethtool: eeprom: add more safeties to EEPROM Netlink fallback

Jakub Kicinski <kuba@kernel.org>
    ethtool: eeprom: add missing ethnl_ops_begin() / _complete() during fallback

Jakub Kicinski <kuba@kernel.org>
    ethtool: strset: fix header attribute index in ethnl_req_get_phydev()

Jakub Kicinski <kuba@kernel.org>
    ethtool: pse-pd: fix missing ethnl_ops_complete()

Jakub Kicinski <kuba@kernel.org>
    ethtool: linkstate: fix unbalanced ethnl_ops_complete() on PHY lookup error

Jakub Kicinski <kuba@kernel.org>
    ethtool: coalesce: cap profile updates at NET_DIM_PARAMS_NUM_PROFILES

Oliver Hartkopp <socketcan@hartkopp.net>
    bonding: refuse to enslave CAN devices

Zhao Dongdong <zhaodongdong@kylinos.cn>
    Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: codecs: simple-mux: Fix enum control bounds check

Eric Dumazet <edumazet@google.com>
    tunnels: do not assume transport header in iptunnel_pmtud_check_icmp()

Eric Dumazet <edumazet@google.com>
    vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu()

Eric Dumazet <edumazet@google.com>
    tunnels: load network headers after skb_cow() in iptunnel_pmtud_build_icmp[v6]()

Li Ming <ming.li@zohomail.com>
    cxl/test: Update mock dev array before calling platform_device_add()

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: validate fw->size against start_cmd_payload_size

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: validate start_cmd_payload_size from module

Danielle Ratson <danieller@nvidia.com>
    net: ethtool: Add support for writing firmware blocks using EPL payload

Danielle Ratson <danieller@nvidia.com>
    net: ethtool: Add new parameters and a function to support EPL

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: fix u16-to-u8 truncation of msleep_pre_rpl

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: require exact CDB reply length

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: fix cleanup if socket used for flashing multiple devices

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: check fw_flash_in_progress under rtnl_lock

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: avoid leaking a netdev ref on module flash errors

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix hkey leak when indir_size is 0

Björn Töpel <bjorn@kernel.org>
    net: Avoid checksumming unreadable skb tail on trim

Alexander Stein <alexander.stein@ew.tq-group.com>
    gpio: mxc: fix irq_high handling

Dan Carpenter <error27@gmail.com>
    accel/ivpu: prevent uninitialized data bug in debugfs

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: fix potential OOB access in supervision frame handling

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: Intel: bytcht_es8316: Fix MCLK leak on init errors

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcm: oss: Fix setup list UAF on proc write error

Eric Dumazet <edumazet@google.com>
    ipv4: free net->ipv4.sysctl_local_reserved_ports after unregister_net_sysctl_table()

David Jeffery <djeffery@redhat.com>
    scsi: core: Run queues for all non-SDEV_DEL devices from scsi_run_host_queues

Breno Leitao <leitao@debian.org>
    net/iucv: fix locking in .getsockopt

Alexandra Winter <wintera@linux.ibm.com>
    net/smc: Do not re-initialize smc hashtables

Ilya Maximets <i.maximets@ovn.org>
    net: netlink: don't set nsid on local notifications

Ilya Maximets <i.maximets@ovn.org>
    net: netlink: fix sending unassigned nsid after assigned one

Ziyu Zhang <ziyuzhang201@gmail.com>
    vsock: keep poll shutdown state consistent

Weiming Shi <bestswngs@gmail.com>
    tun: free page on build_skb failure in tun_xdp_one()

Weiming Shi <bestswngs@gmail.com>
    tun: free page on short-frame rejection in tun_xdp_one()

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix OOB read in compat_mtw_from_user

Florian Westphal <fw@strlen.de>
    netfilter: xt_cpu: prefer raw_smp_processor_id

Chris Mason <clm@meta.com>
    netfilter: synproxy: refresh tcphdr after skb_ensure_writable

Deepanshu Kartikey <kartikey406@gmail.com>
    kernel/fork: validate exit_signal in kernel_clone()

Florian Schmaus <florian.schmaus@codasip.com>
    kunit: fix use-after-free in debugfs when using kunit.filter

Carl Lee <carl.lee@amd.com>
    nfc: nxp-nci: i2c: use rising-edge IRQ on ACPI systems

David Ahern <dahern@nvidia.com>
    xfrm: Check for underflow in xfrm_state_mtu

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix use-after-free race in nfc_llcp_recv_cc()

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix use-after-free in llcp_sock_release()

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: always unmask interrupts in el0_softstp()

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: remove debug exception registration infrastructure

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: split bkpt32 exception entry

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: split brk64 exception entry

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: split hardware watchpoint exception entry

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: split single stepping exception entry

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: refactor reinstall_suspended_bps()

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: split hardware breakpoint exception entry

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: entry: Add entry and exit functions for debug exceptions

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: remove break/step handler registration infrastructure

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: call step handlers statically

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: call software breakpoint handlers statically

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: refactor aarch32_break_handler()

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: debug: clean up single_step_handler logic

Mostafa Saleh <smostafa@google.com>
    arm64: Introduce esr_is_ubsan_brk()

Kevin Hao <haokexin@gmail.com>
    net: cpsw_new: Fix potential unregister of netdev that has not been registered yet

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fix uninitialized closure object

Victor Nogueria <victor@mojatatu.com>
    net/sched: sch_sfb: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Usama Arif <usama.arif@linux.dev>
    xfrm: move policy_bydst RCU sync from per-netns .exit to .pre_exit

Jeremy Kerr <jk@codeconstruct.com.au>
    net: mctp: ensure our nlmsg responses are initialised

Davide Caratti <dcaratti@redhat.com>
    net/sched: cls_fw: fix NULL dereference of "old" filters before change()

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Release indirect CSD GEM reference on CPU job free

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Fix use-after-free of CPU job query arrays on error path

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Input: usbtouchscreen - clamp NEXIO data_len/x_len to URB buffer size


-------------

Diffstat:

 Documentation/netlink/specs/handshake.yaml         |   8 +
 Makefile                                           |   4 +-
 arch/alpha/include/asm/Kbuild                      |   1 +
 arch/arc/include/asm/Kbuild                        |   1 +
 arch/arm/include/asm/Kbuild                        |   1 +
 arch/arm64/include/asm/debug-monitors.h            |  34 +--
 arch/arm64/include/asm/esr.h                       |   5 +
 arch/arm64/include/asm/exception.h                 |  14 +-
 arch/arm64/include/asm/io.h                        |  24 +-
 arch/arm64/include/asm/kgdb.h                      |  12 +
 arch/arm64/include/asm/kprobes.h                   |   8 +
 arch/arm64/include/asm/ring_buffer.h               |  10 +
 arch/arm64/include/asm/system_misc.h               |   4 -
 arch/arm64/include/asm/tlb.h                       |   2 +-
 arch/arm64/include/asm/traps.h                     |   6 +
 arch/arm64/include/asm/uprobes.h                   |  11 +
 arch/arm64/kernel/acpi.c                           |   2 +-
 arch/arm64/kernel/debug-monitors.c                 | 258 ++++++++-------------
 arch/arm64/kernel/entry-common.c                   | 148 +++++++++++-
 arch/arm64/kernel/hw_breakpoint.c                  |  60 ++---
 arch/arm64/kernel/kgdb.c                           |  39 +---
 arch/arm64/kernel/probes/kprobes.c                 |  31 +--
 arch/arm64/kernel/probes/kprobes_trampoline.S      |   2 +-
 arch/arm64/kernel/probes/uprobes.c                 |  24 +-
 arch/arm64/kernel/traps.c                          |  80 +------
 arch/arm64/kvm/pmu-emul.c                          |   4 +-
 arch/arm64/mm/fault.c                              |  75 ------
 arch/arm64/mm/ioremap.c                            |   7 +-
 arch/csky/include/asm/Kbuild                       |   1 +
 arch/hexagon/include/asm/Kbuild                    |   1 +
 arch/loongarch/include/asm/Kbuild                  |   1 +
 arch/m68k/include/asm/Kbuild                       |   1 +
 arch/microblaze/include/asm/Kbuild                 |   1 +
 arch/mips/dec/platform.c                           | 109 ++++++++-
 arch/mips/include/asm/Kbuild                       |   1 +
 arch/nios2/include/asm/Kbuild                      |   1 +
 arch/openrisc/include/asm/Kbuild                   |   1 +
 arch/parisc/include/asm/Kbuild                     |   1 +
 arch/powerpc/include/asm/Kbuild                    |   1 +
 arch/riscv/include/asm/Kbuild                      |   1 +
 arch/riscv/include/asm/syscall_wrapper.h           |   4 +
 arch/s390/include/asm/Kbuild                       |   1 +
 arch/sh/include/asm/Kbuild                         |   1 +
 arch/sparc/include/asm/Kbuild                      |   1 +
 arch/um/include/asm/Kbuild                         |   1 +
 arch/x86/include/asm/Kbuild                        |   1 +
 arch/x86/include/asm/text-patching.h               |   2 +-
 arch/x86/kernel/Makefile                           |  16 ++
 arch/x86/kernel/alternative.c                      |   6 +-
 arch/x86/kernel/callthunks.c                       |   6 +-
 arch/x86/kernel/ftrace.c                           |   7 +
 arch/x86/kvm/svm/avic.c                            |  35 ++-
 arch/x86/kvm/svm/sev.c                             |  68 ++++--
 arch/x86/mm/Makefile                               |   2 +
 arch/xtensa/include/asm/Kbuild                     |   1 +
 drivers/accel/ivpu/ivpu_debugfs.c                  |   2 +-
 drivers/auxdisplay/line-display.c                  |   2 +-
 drivers/bluetooth/btusb.c                          |   8 +-
 drivers/bluetooth/hci_qca.c                        |  38 ++-
 drivers/comedi/drivers/comedi_test.c               |   5 +-
 drivers/counter/counter-core.c                     |   3 +-
 drivers/gpio/gpio-mxc.c                            |   2 +-
 drivers/gpio/gpio-rockchip.c                       |   6 +-
 drivers/gpio/gpio-virtuser.c                       |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   3 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   4 +
 drivers/gpu/drm/bridge/sil-sii8620.c               |   1 +
 drivers/gpu/drm/hyperv/hyperv_drm_proto.c          | 113 +++++++--
 drivers/gpu/drm/i915/display/intel_display_types.h |   1 +
 drivers/gpu/drm/i915/display/intel_dpcd.h          |  15 ++
 drivers/gpu/drm/i915/display/intel_psr.c           |  34 ++-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |  28 ++-
 drivers/gpu/drm/v3d/v3d_sched.c                    |  16 +-
 drivers/gpu/drm/v3d/v3d_submit.c                   |  22 +-
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   6 +-
 drivers/hid/hid-core.c                             |  62 ++++-
 drivers/hid/hid-gfrm.c                             |   4 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-logitech-hidpp.c                   |   2 +-
 drivers/hid/hid-multitouch.c                       |   2 +-
 drivers/hid/hid-picolcd_cir.c                      |   1 +
 drivers/hid/hid-primax.c                           |   2 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-vivaldi-common.c                   |   2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   7 +-
 drivers/hid/usbhid/hid-core.c                      |  11 +-
 drivers/hid/wacom_sys.c                            |  19 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hwmon/pmbus/adm1266.c                      |  54 ++++-
 drivers/iio/adc/mt6359-auxadc.c                    |   1 +
 drivers/iio/adc/npcm_adc.c                         |  25 +-
 drivers/iio/adc/viperboard_adc.c                   |   4 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |  11 +-
 drivers/iio/buffer/industrialio-hw-consumer.c      |   4 +-
 drivers/iio/chemical/scd30_core.c                  |  65 +++---
 drivers/iio/common/ssp_sensors/ssp_dev.c           |   1 +
 drivers/iio/dac/ad5686.c                           |  16 +-
 drivers/iio/dac/ad5686.h                           |   1 +
 drivers/iio/dac/max5821.c                          |   9 +-
 drivers/iio/gyro/adis16260.c                       |   3 +
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   2 +-
 drivers/iio/industrialio-buffer.c                  |   1 +
 drivers/iio/light/cm3323.c                         |   5 +-
 drivers/iio/magnetometer/st_magn_core.c            |  13 +-
 drivers/iio/temperature/tsys01.c                   |   2 +-
 drivers/input/joystick/xpad.c                      |  14 +-
 drivers/input/misc/ims-pcu.c                       |   2 +-
 drivers/input/mouse/elan_i2c_core.c                |   5 +
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/input/touchscreen/usbtouchscreen.c         |   5 +
 drivers/iommu/io-pgtable-arm-v7s.c                 |  18 +-
 drivers/iommu/iommu.c                              |  25 +-
 drivers/md/bcache/super.c                          |   3 +-
 drivers/media/cec/core/cec-core.c                  |   2 +-
 drivers/media/common/siano/smsir.c                 |   1 +
 drivers/media/i2c/ir-kbd-i2c.c                     |   2 +
 drivers/media/pci/bt8xx/bttv-input.c               |   3 +-
 drivers/media/pci/cx23885/cx23885-input.c          |   1 +
 drivers/media/pci/cx88/cx88-input.c                |   3 +-
 drivers/media/pci/dm1105/dm1105.c                  |   1 +
 drivers/media/pci/mantis/mantis_input.c            |   1 +
 drivers/media/pci/saa7134/saa7134-input.c          |   1 +
 drivers/media/pci/smipcie/smipcie-ir.c             |   1 +
 drivers/media/pci/ttpci/budget-ci.c                |   1 +
 drivers/media/rc/ati_remote.c                      |   6 +-
 drivers/media/rc/ene_ir.c                          |   2 +-
 drivers/media/rc/fintek-cir.c                      |   3 +-
 drivers/media/rc/igorplugusb.c                     |   3 +-
 drivers/media/rc/iguanair.c                        |   1 +
 drivers/media/rc/img-ir/img-ir-hw.c                |   3 +-
 drivers/media/rc/img-ir/img-ir-raw.c               |   3 +-
 drivers/media/rc/imon.c                            |   3 +-
 drivers/media/rc/ir-hix5hd2.c                      |   2 +-
 drivers/media/rc/ir_toy.c                          |   1 +
 drivers/media/rc/ite-cir.c                         |   2 +-
 drivers/media/rc/mceusb.c                          |   1 +
 drivers/media/rc/rc-ir-raw.c                       |   5 -
 drivers/media/rc/rc-loopback.c                     |   1 +
 drivers/media/rc/rc-main.c                         |   6 +-
 drivers/media/rc/redrat3.c                         |   4 +-
 drivers/media/rc/st_rc.c                           |   2 +-
 drivers/media/rc/streamzap.c                       |   7 +-
 drivers/media/rc/sunxi-cir.c                       |   1 +
 drivers/media/rc/ttusbir.c                         |   4 +-
 drivers/media/rc/winbond-cir.c                     |   2 +-
 drivers/media/rc/xbox_remote.c                     |   5 +-
 drivers/media/usb/au0828/au0828-input.c            |   1 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   1 +
 drivers/media/usb/dvb-usb/dvb-usb-remote.c         |   6 +-
 drivers/media/usb/em28xx/em28xx-input.c            |   1 +
 drivers/net/bonding/bond_main.c                    |   6 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   2 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  72 +++---
 drivers/net/ethernet/ti/cpsw_new.c                 |   4 +-
 drivers/net/macsec.c                               |   3 +-
 drivers/net/phy/mscc/mscc.h                        |   8 +-
 drivers/net/phy/mscc/mscc_main.c                   |  23 +-
 drivers/net/tun.c                                  |   5 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 +-
 drivers/net/wireguard/send.c                       |  20 +-
 drivers/nfc/nxp-nci/i2c.c                          |  21 +-
 drivers/nvme/host/tcp.c                            |   2 +-
 drivers/parport/share.c                            |  11 +-
 drivers/platform/x86/intel/vsec.c                  |  36 +--
 drivers/s390/cio/chsc.c                            |   4 +-
 drivers/s390/cio/chsc_sch.c                        |  20 +-
 drivers/s390/cio/scm.c                             |   2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/scsi_lib.c                            |  27 ++-
 drivers/scsi/scsi_transport_fc.c                   |  77 +++---
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/media/av7110/av7110_ir.c           |   1 +
 drivers/target/iscsi/iscsi_target.c                |   6 +-
 drivers/target/iscsi/iscsi_target_auth.c           |  19 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   7 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |  62 +++--
 drivers/target/iscsi/iscsi_target_parameters.h     |   2 +-
 drivers/thunderbolt/property.c                     |  32 ++-
 drivers/tty/serdev/core.c                          |  21 ++
 drivers/tty/serial/altera_jtaguart.c               |   7 +-
 drivers/tty/serial/dz.c                            | 171 +++++++-------
 drivers/tty/serial/fsl_lpuart.c                    |  15 +-
 drivers/tty/serial/pch_uart.c                      |  19 +-
 drivers/tty/serial/qcom_geni_serial.c              |  16 +-
 drivers/tty/serial/samsung_tty.c                   |   8 -
 drivers/tty/serial/sh-sci.c                        |   2 +-
 drivers/tty/serial/zs.c                            | 218 +++++++----------
 drivers/tty/serial/zs.h                            |   1 -
 drivers/usb/cdns3/cdns3-gadget.c                   |  12 +-
 drivers/usb/cdns3/cdns3-plat.c                     |  11 +-
 drivers/usb/chipidea/core.c                        |  16 +-
 drivers/usb/class/cdc-acm.c                        |   2 -
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/class/usbtmc.c                         |  14 ++
 drivers/usb/core/config.c                          |   9 +-
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc2/hcd.c                             |   4 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     |  26 ++-
 drivers/usb/gadget/composite.c                     |   5 +-
 drivers/usb/gadget/function/f_fs.c                 |  26 ++-
 drivers/usb/gadget/function/f_hid.c                |   3 +-
 drivers/usb/gadget/function/f_uvc.c                |  28 ++-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   4 +
 drivers/usb/gadget/udc/net2280.c                   |   4 +-
 drivers/usb/host/xhci-tegra.c                      |  77 +++---
 drivers/usb/musb/omap2430.c                        |   3 +-
 drivers/usb/serial/belkin_sa.c                     |   3 +
 drivers/usb/serial/cypress_m8.c                    |  20 +-
 drivers/usb/serial/digi_acceleport.c               |  23 +-
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/mct_u232.c                      |   5 +
 drivers/usb/serial/mxuport.c                       |   8 +
 drivers/usb/serial/omninet.c                       |   9 +-
 drivers/usb/serial/option.c                        |   9 +-
 drivers/usb/serial/safe_serial.c                   |  11 +
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/altmodes/displayport.c           |   2 +
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   9 +
 drivers/usb/typec/tcpm/tcpm.c                      | 117 ++++++----
 drivers/usb/typec/tcpm/wcove.c                     |  13 +-
 drivers/usb/typec/ucsi/displayport.c               |   4 +
 drivers/usb/typec/ucsi/ucsi.c                      |  24 +-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
 drivers/usb/usbip/vudc_dev.c                       |   1 +
 drivers/usb/usbip/vudc_transfer.c                  |   3 +-
 fs/fcntl.c                                         |   1 -
 fs/file_table.c                                    |   1 -
 fs/hpfs/alloc.c                                    |   2 +-
 fs/hugetlbfs/inode.c                               |   5 -
 fs/notify/fanotify/fanotify.c                      |   1 -
 fs/notify/fanotify/fanotify_user.c                 |   1 -
 fs/overlayfs/copy_up.c                             |   1 -
 fs/proc/base.c                                     |   1 -
 fs/smb/server/smbacl.c                             |   8 +-
 include/asm-generic/ring_buffer.h                  |  13 ++
 include/drm/display/drm_dp.h                       |   1 +
 include/kunit/test.h                               |   1 +
 include/linux/compat.h                             |   4 +
 include/linux/compiler-clang.h                     |   6 +
 include/linux/compiler_attributes.h                |  11 +
 include/linux/compiler_types.h                     |   4 +
 include/linux/hid.h                                |  17 +-
 include/linux/hid_bpf.h                            |  14 +-
 include/linux/memfd.h                              |  23 +-
 include/linux/mm.h                                 |  55 -----
 include/linux/netdevice_xmit.h                     |  10 +
 include/linux/parport.h                            |   1 +
 include/linux/serdev.h                             |   1 +
 include/linux/skbuff.h                             |   2 +
 include/linux/syscalls.h                           |   4 +
 include/media/rc-core.h                            |   2 -
 include/net/inet_frag.h                            |  18 +-
 include/net/ipv6_frag.h                            |   9 +-
 include/net/xfrm.h                                 |   3 +-
 io_uring/io_uring.c                                |   1 -
 ipc/util.c                                         |   2 +-
 kernel/bpf/bpf_inode_storage.c                     |   1 -
 kernel/bpf/bpf_task_storage.c                      |   1 -
 kernel/bpf/token.c                                 |   1 -
 kernel/events/core.c                               |  16 +-
 kernel/exit.c                                      |   1 -
 kernel/fork.c                                      |  11 +-
 kernel/module/dups.c                               |   1 -
 kernel/module/kmod.c                               |   1 -
 kernel/trace/ring_buffer.c                         |  22 ++
 kernel/umh.c                                       |   1 -
 lib/debugobjects.c                                 |   2 +-
 lib/kunit/executor.c                               |  19 +-
 lib/kunit/test.c                                   |   1 +
 mm/damon/sysfs-schemes.c                           |   8 +-
 mm/memfd.c                                         |  56 ++++-
 mm/memory.c                                        |   2 +-
 mm/mmap.c                                          |  12 +-
 mm/page_alloc.c                                    |   1 +
 mm/shmem.c                                         |   6 -
 net/batman-adv/bat_iv_ogm.c                        |  82 +++++--
 net/batman-adv/bat_v_ogm.c                         |  59 +++--
 net/batman-adv/bridge_loop_avoidance.c             |  57 +++--
 net/batman-adv/soft-interface.c                    |   1 +
 net/batman-adv/tp_meter.c                          |  67 +++---
 net/batman-adv/translation-table.c                 |  57 ++++-
 net/batman-adv/tvlv.c                              |  28 ++-
 net/batman-adv/tvlv.h                              |   2 +-
 net/batman-adv/types.h                             |  42 +++-
 net/bluetooth/6lowpan.c                            |   2 +
 net/bluetooth/hci_sync.c                           |  12 +-
 net/bluetooth/hidp/core.c                          |  23 +-
 net/bluetooth/iso.c                                |  12 +-
 net/bluetooth/l2cap_core.c                         |  41 +++-
 net/bluetooth/l2cap_sock.c                         |  16 +-
 net/bridge/netfilter/ebtables.c                    |  30 +++
 net/core/filter.c                                  |   2 +-
 net/core/skbuff.c                                  |  45 +++-
 net/ethtool/cmis.h                                 |  20 +-
 net/ethtool/cmis_cdb.c                             | 103 ++++++--
 net/ethtool/cmis_fw_update.c                       | 214 ++++++++++++-----
 net/ethtool/coalesce.c                             |   6 +
 net/ethtool/eeprom.c                               |  10 +-
 net/ethtool/linkstate.c                            |   6 +-
 net/ethtool/module.c                               |  26 +--
 net/ethtool/netlink.c                              |   4 +-
 net/ethtool/netlink.h                              |   4 +-
 net/ethtool/pse-pd.c                               |  10 +-
 net/ethtool/rss.c                                  |   3 +-
 net/ethtool/strset.c                               |   2 +-
 net/handshake/genl.c                               |   3 +-
 net/handshake/genl.h                               |   1 +
 net/handshake/handshake-test.c                     |   2 +-
 net/handshake/handshake.h                          |   6 +-
 net/handshake/netlink.c                            |  22 +-
 net/handshake/request.c                            |  64 +++--
 net/handshake/tlshd.c                              |   6 +-
 net/hsr/hsr_forward.c                              |   4 +-
 net/hsr/hsr_framereg.c                             |   6 +-
 net/ipv4/ah4.c                                     |   2 +-
 net/ipv4/esp4.c                                    |   4 +-
 net/ipv4/inet_fragment.c                           |  51 +++-
 net/ipv4/ip_fragment.c                             |  18 +-
 net/ipv4/ip_tunnel_core.c                          |  22 +-
 net/ipv4/sysctl_net_ipv4.c                         |   2 +-
 net/ipv6/ah6.c                                     |   2 +-
 net/ipv6/datagram.c                                |  54 ++++-
 net/ipv6/esp6.c                                    |   4 +-
 net/ipv6/exthdrs.c                                 |   6 +-
 net/ipv6/ip6_vti.c                                 |  23 +-
 net/ipv6/route.c                                   |   5 +
 net/iucv/af_iucv.c                                 |  20 +-
 net/key/af_key.c                                   |   6 +-
 net/l2tp/l2tp_core.c                               |  11 +-
 net/mctp/device.c                                  |   1 +
 net/mctp/neigh.c                                   |   1 +
 net/mctp/route.c                                   |   1 +
 net/mptcp/pm.c                                     |  40 +++-
 net/mptcp/pm_netlink.c                             |  16 +-
 net/mptcp/protocol.c                               |  92 +++++---
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |   8 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   3 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +
 net/netfilter/xt_cpu.c                             |   2 +-
 net/netlink/af_netlink.c                           |  11 +-
 net/nfc/hci/core.c                                 |  10 +
 net/nfc/llcp_core.c                                |  11 +
 net/nfc/llcp_sock.c                                |   2 +
 net/nfc/nci/hci.c                                  |  10 +
 net/rxrpc/ar-internal.h                            |  12 +-
 net/rxrpc/call_event.c                             |  27 +--
 net/rxrpc/call_object.c                            |   2 +
 net/rxrpc/conn_event.c                             |  30 +--
 net/rxrpc/insecure.c                               |   8 +-
 net/rxrpc/recvmsg.c                                |  68 ++++--
 net/rxrpc/rxkad.c                                  | 115 ++++-----
 net/sched/act_mirred.c                             |  77 ++++--
 net/sched/cls_fw.c                                 |   6 +-
 net/sched/sch_netem.c                              |  47 +---
 net/sched/sch_sfb.c                                |   2 +-
 net/sctp/socket.c                                  |   2 +
 net/smc/af_smc.c                                   |   4 +-
 net/vmw_vsock/af_vsock.c                           |  49 ++--
 net/vmw_vsock/hyperv_transport.c                   |   9 +-
 net/vmw_vsock/virtio_transport_common.c            |  14 +-
 net/vmw_vsock/vmci_transport.c                     |   8 +-
 net/xfrm/xfrm_input.c                              |  16 +-
 net/xfrm/xfrm_policy.c                             |  17 +-
 net/xfrm/xfrm_state.c                              |  23 +-
 net/xfrm/xfrm_user.c                               |   5 +-
 security/apparmor/domain.c                         |   1 -
 sound/core/oss/pcm_oss.c                           |  18 +-
 .../motu/motu-register-dsp-message-parser.c        |  14 +-
 sound/soc/codecs/simple-mux.c                      |   2 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  29 ++-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  43 ++--
 sound/usb/mixer_scarlett2.c                        |  38 ++-
 tools/testing/cxl/test/cxl.c                       | 105 ++++-----
 tools/testing/selftests/mm/hmm-tests.c             |  50 ++++
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   6 +-
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |  10 +-
 382 files changed, 3974 insertions(+), 2279 deletions(-)


