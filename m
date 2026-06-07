Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5D078C9C;
	Sun,  7 Jun 2026 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826584; cv=none; b=ffEx8nMpi5bxi1Sm90fAv/sycrumIDqvOyQZGzcZddRRMaOez3Oe1x1kRQ45xLdO9eIa0qRNKUP/C3P9zQBFcQwrBSrMf1Rl3KijcahGnVHAXFaZBvsi1K2QoMEE3L3JiUo1XtTXppe+cn1PlBpbSvD0Rg71qNoGgBLbg4M5hwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826584; c=relaxed/simple;
	bh=tpBSCqSvP62y9lofRFD8Tje/YPudb0ROe0A9dkzPfyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u/jh8nsQPlO1QYpy1xMLjLaqwYhsc6Lm47lEVFbX3ggqWUb8qvN22wDQt9dsEiH5tihgJEYn4Zp3al3AHWuMmNoqeJZFets3pG9Q2R9qrtJXhCyrKVi2InVCilcLL/JlnkZurmaii+EQWloOKascbVt/tpNpjfcSZlkqMC8plCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8eSDfqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8eSDfqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEAD1F00893;
	Sun,  7 Jun 2026 10:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826581;
	bh=rjGHvyQwJnHYSM206itCAeiFtrg0v8iTvfLod7XWkqc=;
	h=From:To:Cc:Subject:Date;
	b=o8eSDfqEZoujGw5YkxHxH31tYk3oXFpjgd23Soo2PyLGmspHiidVkiTKeyjezDnZF
	 4rqV4RBF/fheVHwQVHWAgpTHJS3kHurDSEr1n1EbxLrwPMXLhIphsIdFkrAJtAgrQD
	 BZFGGBZ8p1ntC57AVi4a7vjXfkq32saxKfp7TNhs=
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
Subject: [PATCH 7.0 000/332] 7.0.12-rc1 review
Date: Sun,  7 Jun 2026 11:56:09 +0200
Message-ID: <20260607095728.031258202@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.0.12-rc1
X-KernelTest-Deadline: 2026-06-09T09:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.0.12 release.
There are 332 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.0.12-rc1

Jassi Brar <jassisinghbrar@gmail.com>
    mailbox: Fix NULL message support in mbox_send_message()

Wei-Cheng Chen <weichengc@nvidia.com>
    xhci: tegra: Fix ghost USB device on dual-role port unplug

Robert Marko <robert.marko@sartura.hr>
    net: phy: micrel: fix LAN8814 QSGMII soft reset

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/adm1266) serialize GPIO PMBus accesses with pmbus_lock

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pmbus_lock

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Add support for guarded PMBus lock

Saurav Sachidanand <sauravsc@amazon.com>
    i2c: tegra: make tegra_i2c_mutex_unlock() return void

Zeng Heng <zengheng4@huawei.com>
    arm64: tlb: Flush walk cache when unsharing PMD tables

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP 16 Piston OmniBook X

Fernando Antunez Antonio <fer.antunez24antonio@gmail.com>
    ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP Envy X360 15-fh0xxx

David Howells <dhowells@redhat.com>
    rxrpc: Fix RESPONSE packet verification to extract skb to a linear buffer

Lukas Wunner <lukas@wunner.de>
    platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery

David E. Box <david.e.box@linux.intel.com>
    platform/x86/intel/vsec: Make driver_data info const

David E. Box <david.e.box@linux.intel.com>
    platform/x86/intel/vsec: Refactor base_addr handling

Lorenzo Stoakes <ljs@kernel.org>
    Revert "mm/hugetlbfs: update hugetlbfs to use mmap_prepare"

Jacques Nilo <jnilo@free.fr>
    serial: 8250_dw: dispatch SysRq character in dw8250_handle_irq()

Jacques Nilo <jnilo@free.fr>
    serial: 8250: dispatch SysRq character in serial8250_handle_irq()

Jacques Nilo <jnilo@free.fr>
    serial: core: introduce guard(uart_port_lock_check_sysrq_irqsave)

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

Ziyi Guo <n7l8m4@u.northwestern.edu>
    drm/amdgpu: check num_entries in GEM_OP GET_MAPPING_INFO

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix amdgpu_hmm_range_get_pages

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix calling VM invalidation in amdgpu_hmm_invalidate_gfx

Michael Bommarito <michael.bommarito@gmail.com>
    drm/amdgpu: fix lock leak on ENOMEM in AMDGPU_GEM_OP_GET_MAPPING_INFO

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

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Use DC_OFF wake reference to block DC6 on vblank enable

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Block DC states on vblank enable when Panel Replay supported

Pranay Samala <pranay.samala@intel.com>
    drm/i915/color: Fix HDR pre-CSC LUT programming loop

Zhenghang Xiao <kipreyyy@gmail.com>
    drm/gem: fix race between change_handle and handle_delete

Berkant Koc <me@berkoc.com>
    drm/hyperv: validate VMBus packet size in receive callback

Berkant Koc <me@berkoc.com>
    drm/hyperv: validate resolution_count and fix WIN8 fallback

Alexandru Hossu <hossu.alexandru@gmail.com>
    scsi: target: iscsi: Validate CHAP_R length before base64 decode

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: target: iscsi: Bound iscsi_encode_text_output() appends to rsp_buf

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: target: iscsi: Fix CRC overread and double-free in iscsit_handle_text_cmd()

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: scsi_transport_fc: Widen FPIN pname walker counter to u32

Michael Bommarito <michael.bommarito@gmail.com>
    scsi: fcoe: Reject FIP descriptors with zero fip_dlen in CVL walker

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: property: Cap recursion depth in __tb_property_parse_dir()

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
    USB: serial: mct_u232: fix memory corruption with small endpoint

Johan Hovold <johan@kernel.org>
    USB: serial: mxuport: fix memory corruption with small endpoint

Johan Hovold <johan@kernel.org>
    USB: serial: keyspan: fix missing indat transfer sanity check

Johan Hovold <johan@kernel.org>
    USB: serial: digi_acceleport: fix memory corruption with small endpoints

Zhang Cen <rollkingzzc@gmail.com>
    USB: serial: cypress_m8: validate interrupt packet headers

Zhang Cen <rollkingzzc@gmail.com>
    USB: serial: belkin_sa: validate interrupt status length

Wanquan Zhong <wanquan.zhong@fibocom.com>
    USB: serial: option: add missing RSVD(5) flag for Rolling RW135R-GL

Jan Volckaert <janvolck@gmail.com>
    USB: serial: option: add MeiG SRM813Q

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Don't update power_supply on power role change if not connected

Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
    usb: typec: ucsi: Check if power role change actually happened before handling

Sebastian Reichel <sebastian.reichel@collabora.com>
    usb: typec: tcpm: improve handling of DISCOVER_MODES failures

Dan Carpenter <error27@gmail.com>
    usb: typec: tipd: Fix error code in tps6598x_probe()

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

Wentao Liang <vulab@iscas.ac.cn>
    usb: musb: omap2430: Fix use-after-free in omap2430_probe()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: xilinx: fix error handling in zynqmp init error paths

Michal Pecio <michal.pecio@gmail.com>
    usb: core: Fix up Interrupt IN endpoints with bogus wBytesPerInterval

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: convert ci_role_switch to local variable

Guangshuo Li <lgs201920130244@gmail.com>
    uio: uio_pci_generic_sva: fix double free of devm_kzalloc() memory

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

Hang Cao <caohang@eswincomputing.com>
    dt-bindings: usb: Fix EIC7700 USB reset's issue

Hongling Zeng <zenghongling@kylinos.cn>
    gpib: cb7210: Fix region leak when request_irq fails

Nicolás Bazaes <contacto@bazaes.cl>
    Input: synaptics - add LEN2058 to SMBus passlist for ThinkPad E490

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: atmel_mxt_ts - fix boundary check in mxt_prepare_cfg_mem

Xiaolei Wang <xiaolei.wang@windriver.com>
    misc: rp1: Send IACK on IRQ activate to fix kdump/kexec

Ali Ganiyev <ali.qaniyev@gmail.com>
    ksmbd: OOB read regression in smb_check_perm_dacl() ACE-walk loops

Dmitriy Zharov <contact@zharov.dev>
    Input: xpad - add support for ASUS ROG RAIKIRI II

Qbeliw Tanaka <q.tanaka@gmx.com>
    Input: xpad - add "Nova 2 Lite" from GameSir

David Carlier <devnexen@gmail.com>
    dma-buf: fix UAF in dma_buf_fd() tracepoint

Shaomin Chen <eeesssooo020@gmail.com>
    xfrm: iptfs: reset runtime state when cloning SAs

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: Fix speaker output on ASUS ROG Strix G615LP

Jingguo Tan <tanjingguo@huawei.com>
    xfrm: esp: restore combined single-frag length gate

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: do not set stream state in event and trigger callbacks

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm-dai: close stream only when running

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    netfilter: conntrack: tcp: do not force CLOSE on invalid-seq RST without direction check

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: firewire-motu: Protect register DSP event queue positions

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Fix 2i2 Gen 4 direct monitor gain on firmware 2417

Michael Bommarito <michael.bommarito@gmail.com>
    xfrm: ah: use skb_to_full_sk in async output callbacks

Herbert Xu <herbert@gondor.apana.org.au>
    xfrm: ipcomp: Free destination pages on acomp errors

Maoyi Xie <maoyixie.tju@gmail.com>
    xfrm: route MIGRATE notifications to caller's netns

Ashutosh Desai <ashutoshdesai993@gmail.com>
    nfc: hci: fix out-of-bounds read in HCP header parsing

Arnd Bergmann <arnd@arndb.de>
    iommu, debugobjects: avoid gcc-16.1 section mismatch warnings

Lee Jones <lee@kernel.org>
    HID: wacom: Fix OOB write in wacom_hid_set_device_mode()

Santhosh Kumar K <s-k6@ti.com>
    spi: spi-mem: avoid mutating op template in spi_mem_supports_op()

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

Michael Bommarito <michael.bommarito@gmail.com>
    octeontx2-af: validate body pcifunc in rvu_mbox_handler_rep_event_notify

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

Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
    x86/ftrace: Relocate %rip-relative percpu refs in dynamic trampolines

Chaitanya Sabnis <chaitanya.msabnis@gmail.com>
    i2c: davinci: fix division by zero on missing clock-frequency

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

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: chemical: scd30: fix division by zero in write_raw

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: chemical: mhz19b: reject oversized serial replies

Svyatoslav Ryhel <clamor95@gmail.com>
    iio: Fix iio_multiply_value use in iio_read_channel_processed_scale

Felix Gu <ustc.gu@gmail.com>
    iio: light: veml6070: Fix resource leak in probe error path

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

Shuvam Pandey <shuvampandey1@gmail.com>
    iio: adc: nxp-sar-adc: zero-initialize dma_slave_config

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: adc: nxp-sar-adc: Avoid division by zero

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: nxp-sar-adc: fix division by zero in write_raw

Radu Sabau <radu.sabau@analog.com>
    iio: adc: ad4695: Fix call ordering in offload buffer postenable

Salah Triki <salah.triki@gmail.com>
    iio: adc: viperboard: Fix error handling in vprbrd_iio_read_raw

Salah Triki <salah.triki@gmail.com>
    iio: adc: mt6359: fix unchecked return value in mt6358_read_imp

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: fix powerdown control on dual-channel devices

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: acquire lock when doing powerdown control

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: fix input raw value check

Rodrigo Alencar <rodrigo.alencar@analog.com>
    iio: dac: ad5686: fix ref bit initialization for single-channel parts

Salah Triki <salah.triki@gmail.com>
    iio: dac: max5821: fix return value check in powerdown sync

Kim Seer Paller <kimseer.paller@analog.com>
    iio: dac: ad3530r: Fix AD3531/AD3531R powerdown mode strings

David Carlier <devnexen@gmail.com>
    iio: adc: npcm: fix unbalanced clk_disable_unprepare()

Christofer Jonason <christofer.jonason@guidelinegeo.com>
    iio: adc: xilinx-xadc: Fix sequencer mode in postdisable for dual mux

Nathan Chancellor <nathan@kernel.org>
    Disable -Wattribute-alias for clang-23 and newer

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: fix lockdep false positive by removing unneeded lock

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: fix deadlock on shared proxy's parent removal

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: shared: undo the vote of the proxy on GPIO free

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

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Ignore Port I/O requests of length '0'

Michael Roth <michael.roth@amd.com>
    KVM: SEV: Require in-GHCB scratch area if GHCB v2+ is in use

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Flush the current TLB when transitioning from xAVIC => x2AVIC

Qiang Ma <maqianga@uniontech.com>
    KVM: arm64: PMU: Preserve AArch32 counter low bits

Mark Brown <broonie@kernel.org>
    KVM: arm64: Correctly cap ZCR_EL2 provided by a guest hypervisor

Wentao Guan <guanwentao@uniontech.com>
    USB: cdc-acm: Fix bit overlap and move quirk definitions to header

Alice Ryhl <aliceryhl@google.com>
    rust_binder: avoid calling pending_oneway_finished() on TF_UPDATE_TXN

Matthew Maurer <mmaurer@google.com>
    rust_binder: Avoid holding lock when dropping delivered_death

Ben Hutchings <benh@debian.org>
    parport: Fix race between port and client registration

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: xpad - fix out-of-bounds access for Share button

Doruk Tan Ozturk <doruk@0sec.ai>
    Bluetooth: hci_sync: fix UAF in hci_le_create_cis_sync

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    Bluetooth: hci_qca: Use 100 ms SSR delay for rampatch and NVM loading

Pavitra Jha <jhapavitra98@gmail.com>
    Bluetooth: hci_conn: Fix memory leak in hci_le_big_terminate()

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

Steve French <stfrench@microsoft.com>
    smb: client: fix uninitialized variable in smb2_writev_callback

Stepan Ionichev <sozdayvek@gmail.com>
    auxdisplay: line-display: fix OOB read on zero-length message_store()

Dev Jain <dev.jain@arm.com>
    mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one

Richard Chang <richardycc@google.com>
    zram: fix use-after-free in zram_writeback_endio

Pratyush Yadav (Google) <pratyush@kernel.org>
    memfd: deny writeable mappings when implying SEAL_WRITE

Sunny Patel <nueralspacetech@gmail.com>
    mm/migrate_device: fix pgtable leak in migrate_vma_insert_huge_pmd_page

Alexandre Ghiti <alex@ghiti.fr>
    mm: memcontrol: propagate NMI slab stats to memcg vmstats

Linpu Yu <linpu5433@gmail.com>
    ipc: limit next_id allocation to the valid ID range

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()

Mikulas Patocka <mpatocka@redhat.com>
    hpfs: fix a crash if hpfs_map_dnode_bitmap fails

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/vmalloc: do not trigger BUG() on BH disabled context

Shuai Zhang <shuai.zhang@oss.qualcomm.com>
    Bluetooth: btusb: Allow firmware re-download when version matches

hlleng <a909204013@gmail.com>
    HID: quirks: Add ALWAYS_POLL quirk for SIGMACHIP USB mouse

Johan Hovold <johan@kernel.org>
    USB: serial: cypress_m8: fix memory corruption with small endpoint

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
    iio: pressure: bmp280: fix stack leak in bmp580 trigger handler

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    iio: imu: adis16550: fix stack leak in trigger handler

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    iio: imu: st_lsm6dsx: fix stack leak in tagged FIFO buffer

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Apply Intel DPCD workaround when SDP on prior line used

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Read Intel DPCD workaround register

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Add defininitions for INTEL_WA_REGISTER_CAPS DPCD register

Andrei Vagin <avagin@google.com>
    Revert "x86/fpu: Refine and simplify the magic number check during signal return"

Fernando Fernandez Mancera <fmancera@suse.de>
    Revert "ipv6: preserve insertion order for same-scope addresses"

Pavel Begunkov <asml.silence@gmail.com>
    net: skbuff: fix pskb_carve leaking zcopy pages

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: fix possible infinite loop in fib6_select_path()

Jiayuan Chen <jiayuan.chen@linux.dev>
    ipv6: fix possible infinite loop in rt6_fill_node()

Jingguo Tan <tanjingguo@huawei.com>
    vsock/virtio: bind uarg before filling zerocopy skb

Frank Wunderlich <frank-w@public-files.de>
    net: pcs: pcs-mtk-lynxi: fix bpi-r3 serdes configuration

Zhenghang Xiao <kipreyyy@gmail.com>
    sctp: fix race between sctp_wait_for_connect and peeloff

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: Skip redundant detach on already-detached port

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: Add NULL guards in teardown path to prevent panic on attach failure

Marco Scardovi <scardracs@disroot.org>
    gpio: rockchip: teardown bugs and resource leaks

Marco Scardovi <scardracs@disroot.org>
    gpio: rockchip: convert bank->clk to devm_clk_get_enabled()

Dan Carpenter <error27@gmail.com>
    gpio: virtuser: Fix uninitialized data bug in gpio_virtuser_direction_do_write()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    gpio: adnp: fix flow control regression caused by scoped_guard()

Heitor Alves de Siqueira <halves@igalia.com>
    Bluetooth: hci_sync: Reset device counters in hci_dev_close_sync()

Heitor Alves de Siqueira <halves@igalia.com>
    Bluetooth: hci_sync: Set HCI_CMD_DRAIN_WORKQUEUE during device close

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix possible crash on l2cap_ecred_conn_rsp

Zhenghang Xiao <kipreyyy@gmail.com>
    Bluetooth: l2cap: clear chan->ident on ECRED reconfiguration success

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: use __dpll_device_change_ntf() and remove change_work

Ivan Vecera <ivecera@redhat.com>
    dpll: export __dpll_device_change_ntf() for use under dpll_lock

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: add die temperature reporting for supported chips

Ivan Vecera <ivecera@redhat.com>
    dpll: zl3073x: detect DPLL channel count from chip ID at runtime

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Drain pending requests at net namespace exit

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Take a long-lived file reference at submit

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: hand off the pinned file reference to accept_doit

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Pass negative errno through handshake_complete()

Chuck Lever <chuck.lever@oracle.com>
    nvme-tcp: store negative errno in queue->tls_err

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: Use spin_lock_bh for hn_lock

Jijie Shao <shaojijie@huawei.com>
    net: hibmcge: move dma_rmb() after dma_sync_single_for_cpu() in RX path

Jijie Shao <shaojijie@huawei.com>
    net: hibmcge: disable Relaxed Ordering to fix RX packet corruption

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_mirred: Fix return code in early mirred redirect error paths

Kito Xu (veritas501) <hxzene@gmail.com>
    net/sched: act_mirred: Fix blockcast recursion bypass leading to stack overflow

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop

Jamal Hadi Salim <jhs@mojatatu.com>
    net: Introduce skb tc depth field to track packet loops

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
    ethtool: tsinfo: don't pass ERR_PTR to genlmsg_cancel on prepare failure

Jakub Kicinski <kuba@kernel.org>
    ethtool: tsinfo: fix uninitialized stats on the by-PHC path

Jakub Kicinski <kuba@kernel.org>
    ethtool: tsconfig: fix missing ethnl_ops_complete()

Jakub Kicinski <kuba@kernel.org>
    ethtool: pse-pd: fix missing ethnl_ops_complete()

Jakub Kicinski <kuba@kernel.org>
    ethtool: linkstate: fix unbalanced ethnl_ops_complete() on PHY lookup error

Jakub Kicinski <kuba@kernel.org>
    ethtool: tsconfig: fix reply error handling

Jakub Kicinski <kuba@kernel.org>
    ethtool: coalesce: cap profile updates at NET_DIM_PARAMS_NUM_PROFILES

Ido Schimmel <idosch@nvidia.com>
    bridge: Fix sleep in atomic context in sysfs path

Ido Schimmel <idosch@nvidia.com>
    bridge: Fix sleep in atomic context in netlink path

Oliver Hartkopp <socketcan@hartkopp.net>
    bonding: refuse to enslave CAN devices

Zhao Dongdong <zhaodongdong@kylinos.cn>
    Bluetooth: 6lowpan: check skb_clone() return value in send_mcast_pkt()

Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
    drm/xe: Restore IDLEDLY regiter on engine reset

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: codecs: simple-mux: Fix enum control bounds check

Sean Shen <grayhat@foxmail.com>
    ksmbd: fix FSCTL permission bypass by adding a permission check for FSCTL_SET_SPARSE

Eric Dumazet <edumazet@google.com>
    tunnels: do not assume transport header in iptunnel_pmtud_check_icmp()

Eric Dumazet <edumazet@google.com>
    vxlan: do not reuse cached ip_hdr() value after skb_tunnel_check_pmtu()

Eric Dumazet <edumazet@google.com>
    tunnels: load network headers after skb_cow() in iptunnel_pmtud_build_icmp[v6]()

Keith Busch <kbusch@kernel.org>
    blk-mq: reinsert cached request to the list

Li Ming <ming.li@zohomail.com>
    cxl/test: Update mock dev array before calling platform_device_add()

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: validate fw->size against start_cmd_payload_size

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: validate start_cmd_payload_size from module

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: fix u16-to-u8 truncation of msleep_pre_rpl

Jakub Kicinski <kuba@kernel.org>
    ethtool: cmis: require exact CDB reply length

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: fix cleanup if socket used for flashing multiple devices

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: check fw_flash_in_progress under rtnl_lock

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: avoid racy updates to dev->ethtool bitfield

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: avoid leaking a netdev ref on module flash errors

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: call ethnl_ops_complete() on module flash errors

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: avoid device context leak on reply-build failure

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix hkey leak when indir_size is 0

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix indir_table and hkey leak on get_rxfh failure

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix falsely ignoring indir table updates

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: add missing errno on RSS context delete

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: avoid modifying the RSS context response

Björn Töpel <bjorn@kernel.org>
    net: Avoid checksumming unreadable skb tail on trim

Michał Grzelak <michal.grzelak@intel.com>
    drm/i915/aux: use polling when irqs are unavailable

Alexander Stein <alexander.stein@ew.tq-group.com>
    gpio: mxc: fix irq_high handling

Dan Carpenter <error27@gmail.com>
    accel/ivpu: prevent uninitialized data bug in debugfs

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: fix potential OOB access in supervision frame handling

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    net/mlx5: HWS: Reject unsupported remove-header action

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: Intel: bytcht_es8316: Fix MCLK leak on init errors

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcm: oss: Fix setup list UAF on proc write error

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: hda: cs35l56: Fix system name string leaks

Eric Dumazet <edumazet@google.com>
    ipv4: free net->ipv4.sysctl_local_reserved_ports after unregister_net_sysctl_table()

Ewan D. Milne <emilne@redhat.com>
    scsi: scsi_debug: Add missing newline in scsi_debug_device_reset()

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
    tap: free page on error paths in tap_get_user_xdp()

Weiming Shi <bestswngs@gmail.com>
    tun: free page on short-frame rejection in tun_xdp_one()

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_tables: fix dst corruption in same register operation

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: fix OOB read in compat_mtw_from_user

Florian Westphal <fw@strlen.de>
    netfilter: xt_cpu: prefer raw_smp_processor_id

Chris Mason <clm@meta.com>
    netfilter: synproxy: refresh tcphdr after skb_ensure_writable

e521588 <alessandro.schino@sbb.ch>
    esp: fix page frag reference leak on skb_to_sgvec failure

Deepanshu Kartikey <kartikey406@gmail.com>
    kernel/fork: validate exit_signal in kernel_clone()

Dhabaleshwar Das <dhabal123@gmail.com>
    accel/rocket: fix UAF via dangling GEM handle in create_bo

Florian Schmaus <florian.schmaus@codasip.com>
    kunit: fix use-after-free in debugfs when using kunit.filter

Liu Kai <lukace97@outlook.com>
    HID: remove duplicate hid_warn_ratelimited definition

Hongtao Lee <lihongtao@kylinos.cn>
    tools/bootconfig: Fix buf leaks in apply_xbc

Carl Lee <carl.lee@amd.com>
    nfc: nxp-nci: i2c: use rising-edge IRQ on ACPI systems

David Ahern <dahern@nvidia.com>
    xfrm: Check for underflow in xfrm_state_mtu

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix use-after-free race in nfc_llcp_recv_cc()

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix use-after-free in llcp_sock_release()

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fix uninitialized closure object

Victor Nogueria <victor@mojatatu.com>
    net/sched: sch_sfb: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Usama Arif <usama.arif@linux.dev>
    xfrm: move policy_bydst RCU sync from per-netns .exit to .pre_exit

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: button: Enable wakeup GPEs for ACPI buttons at probe time

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: button: Fix ACPI GPE handler leak during removal

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Input: usbtouchscreen - clamp NEXIO data_len/x_len to URB buffer size


-------------

Diffstat:

 .../devicetree/bindings/usb/eswin,eic7700-usb.yaml |   7 +-
 Documentation/netlink/specs/handshake.yaml         |   8 +
 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/include/asm/tlb.h                       |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  16 +-
 arch/arm64/kvm/nested.c                            |   5 +
 arch/arm64/kvm/pmu-emul.c                          |   4 +-
 arch/arm64/kvm/sys_regs.c                          |  11 +-
 arch/mips/dec/platform.c                           | 109 ++++++++++-
 arch/riscv/include/asm/syscall_wrapper.h           |   4 +
 arch/x86/kernel/fpu/signal.c                       |  11 +-
 arch/x86/kernel/ftrace.c                           |   7 +
 arch/x86/kvm/svm/avic.c                            |  35 +++-
 arch/x86/kvm/svm/sev.c                             |  76 ++++---
 block/blk-mq.c                                     |   2 +-
 drivers/accel/ivpu/ivpu_debugfs.c                  |   2 +-
 drivers/accel/rocket/rocket_gem.c                  |  17 +-
 drivers/acpi/acpica/evxfgpe.c                      |  50 ++++-
 drivers/acpi/button.c                              |  24 ++-
 drivers/android/binder/allocation.rs               |   8 +
 drivers/android/binder/process.rs                  |   7 +-
 drivers/android/binder/transaction.rs              |  11 +-
 drivers/auxdisplay/line-display.c                  |   2 +-
 drivers/block/zram/zram_drv.c                      |   6 +-
 drivers/bluetooth/btusb.c                          |   8 +-
 drivers/bluetooth/hci_qca.c                        |   4 +-
 drivers/comedi/drivers/comedi_test.c               |   5 +-
 drivers/counter/counter-core.c                     |   3 +-
 drivers/dma-buf/dma-buf.c                          |   6 +-
 drivers/dpll/dpll_netlink.c                        |  13 +-
 drivers/dpll/zl3073x/core.c                        | 116 +++--------
 drivers/dpll/zl3073x/core.h                        |  59 +++---
 drivers/dpll/zl3073x/dpll.c                        |  52 +++--
 drivers/dpll/zl3073x/dpll.h                        |   4 +-
 drivers/dpll/zl3073x/i2c.c                         |  37 ++--
 drivers/dpll/zl3073x/regs.h                        |   2 +
 drivers/dpll/zl3073x/spi.c                         |  37 ++--
 drivers/gpib/cb7210/cb7210.c                       |  10 +-
 drivers/gpio/gpio-adnp.c                           |   4 +-
 drivers/gpio/gpio-mxc.c                            |   2 +-
 drivers/gpio/gpio-rockchip.c                       |  23 ++-
 drivers/gpio/gpio-shared-proxy.c                   |   9 +
 drivers/gpio/gpio-virtuser.c                       |   4 +-
 drivers/gpio/gpiolib-shared.c                      |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   7 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   8 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   3 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   4 +
 drivers/gpu/drm/drm_gem.c                          |   2 +
 drivers/gpu/drm/hyperv/hyperv_drm_proto.c          | 113 +++++++++--
 drivers/gpu/drm/i915/display/intel_color.c         |   2 +-
 drivers/gpu/drm/i915/display/intel_display_core.h  |   1 +
 drivers/gpu/drm/i915/display/intel_display_irq.c   |   8 +-
 drivers/gpu/drm/i915/display/intel_display_types.h |   3 +
 drivers/gpu/drm/i915/display/intel_dp_aux.c        |  20 +-
 drivers/gpu/drm/i915/display/intel_dpcd.h          |  15 ++
 drivers/gpu/drm/i915/display/intel_psr.c           |  69 +++++--
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |  28 +--
 drivers/gpu/drm/xe/xe_guc_ads.c                    |   5 +
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/wacom_sys.c                            |  13 +-
 drivers/hid/wacom_wac.h                            |   1 +
 drivers/hwmon/pmbus/adm1266.c                      |   7 +
 drivers/hwmon/pmbus/pmbus.h                        |   5 +
 drivers/hwmon/pmbus/pmbus_core.c                   |   8 +
 drivers/i2c/busses/i2c-davinci.c                   |   2 +-
 drivers/i2c/busses/i2c-tegra.c                     |  15 +-
 drivers/iio/adc/ad4695.c                           |  23 +--
 drivers/iio/adc/mt6359-auxadc.c                    |   1 +
 drivers/iio/adc/npcm_adc.c                         |  25 +--
 drivers/iio/adc/nxp-sar-adc.c                      |  24 ++-
 drivers/iio/adc/viperboard_adc.c                   |   4 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |  11 +-
 drivers/iio/buffer/industrialio-hw-consumer.c      |   4 +-
 drivers/iio/chemical/mhz19b.c                      |  17 ++
 drivers/iio/chemical/scd30_core.c                  |   2 +-
 drivers/iio/common/ssp_sensors/ssp_dev.c           |   1 +
 drivers/iio/dac/ad3530r.c                          |  54 +++--
 drivers/iio/dac/ad5686.c                           |  56 ++++--
 drivers/iio/dac/ad5686.h                           |   1 +
 drivers/iio/dac/max5821.c                          |   9 +-
 drivers/iio/gyro/adis16260.c                       |   3 +
 drivers/iio/gyro/itg3200_buffer.c                  |   2 +-
 drivers/iio/imu/adis16550.c                        |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   2 +-
 drivers/iio/industrialio-buffer.c                  |   1 +
 drivers/iio/inkern.c                               |   6 +-
 drivers/iio/light/cm3323.c                         |   5 +-
 drivers/iio/light/veml6070.c                       |  14 +-
 drivers/iio/magnetometer/st_magn_core.c            |  13 +-
 drivers/iio/pressure/bmp280-core.c                 |   2 +-
 drivers/iio/temperature/tsys01.c                   |   2 +-
 drivers/input/joystick/xpad.c                      |  14 +-
 drivers/input/misc/ims-pcu.c                       |   2 +-
 drivers/input/mouse/elan_i2c_core.c                |   5 +
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/input/touchscreen/usbtouchscreen.c         |   5 +
 drivers/iommu/io-pgtable-arm-v7s.c                 |  18 +-
 drivers/mailbox/mailbox.c                          |  15 +-
 drivers/mailbox/tegra-hsp.c                        |   2 +-
 drivers/md/bcache/super.c                          |   3 +-
 drivers/media/rc/igorplugusb.c                     |   2 +-
 drivers/misc/rp1/rp1_pci.c                         |   1 +
 drivers/net/bonding/bond_main.c                    |   6 +
 drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c  |   3 +
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c  |   6 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_rep.c    |   8 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c       |   4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  78 +++++---
 drivers/net/macsec.c                               |   3 +-
 drivers/net/pcs/pcs-mtk-lynxi.c                    |   3 +
 drivers/net/phy/micrel.c                           |  15 +-
 drivers/net/tap.c                                  |   2 +
 drivers/net/tun.c                                  |   5 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 +-
 drivers/net/wireguard/send.c                       |  20 +-
 drivers/nfc/nxp-nci/i2c.c                          |  21 +-
 drivers/nvme/host/tcp.c                            |   2 +-
 drivers/parport/share.c                            |  11 +-
 drivers/platform/x86/intel/vsec.c                  |  91 ++++-----
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/scsi_debug.c                          |   2 +-
 drivers/scsi/scsi_lib.c                            |  27 ++-
 drivers/scsi/scsi_transport_fc.c                   |  77 ++++----
 drivers/spi/spi-mem.c                              |  15 +-
 drivers/target/iscsi/iscsi_target.c                |   5 +-
 drivers/target/iscsi/iscsi_target_auth.c           |  19 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   7 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |  62 ++++--
 drivers/target/iscsi/iscsi_target_parameters.h     |   2 +-
 drivers/thunderbolt/property.c                     |  32 ++-
 drivers/tty/serial/8250/8250_dw.c                  |   2 +-
 drivers/tty/serial/8250/8250_port.c                |   7 +-
 drivers/tty/serial/altera_jtaguart.c               |   7 +-
 drivers/tty/serial/dz.c                            | 171 ++++++++--------
 drivers/tty/serial/fsl_lpuart.c                    |  15 +-
 drivers/tty/serial/pch_uart.c                      |  19 +-
 drivers/tty/serial/qcom_geni_serial.c              |  16 +-
 drivers/tty/serial/samsung_tty.c                   |   8 -
 drivers/tty/serial/sh-sci.c                        |   2 +-
 drivers/tty/serial/zs.c                            | 218 ++++++++-------------
 drivers/tty/serial/zs.h                            |   1 -
 drivers/uio/uio_pci_generic_sva.c                  |   7 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |  12 +-
 drivers/usb/cdns3/cdns3-plat.c                     |  11 +-
 drivers/usb/chipidea/core.c                        |  16 +-
 drivers/usb/class/cdc-acm.c                        |   2 -
 drivers/usb/class/cdc-acm.h                        |   2 +
 drivers/usb/class/usbtmc.c                         |  14 ++
 drivers/usb/core/config.c                          |   9 +-
 drivers/usb/core/quirks.c                          |   4 +
 drivers/usb/dwc2/hcd.c                             |   4 +-
 drivers/usb/dwc3/dwc3-xilinx.c                     |  27 +--
 drivers/usb/gadget/composite.c                     |   5 +-
 drivers/usb/gadget/function/f_fs.c                 |  26 ++-
 drivers/usb/gadget/function/f_hid.c                |   3 +-
 drivers/usb/gadget/function/f_uvc.c                |  28 ++-
 drivers/usb/gadget/udc/dummy_hcd.c                 |   4 +
 drivers/usb/gadget/udc/net2280.c                   |   4 +-
 drivers/usb/host/xhci-tegra.c                      |  75 ++++---
 drivers/usb/musb/omap2430.c                        |   3 +-
 drivers/usb/serial/belkin_sa.c                     |   3 +
 drivers/usb/serial/cypress_m8.c                    |  20 +-
 drivers/usb/serial/digi_acceleport.c               |  23 ++-
 drivers/usb/serial/keyspan.c                       |   4 +
 drivers/usb/serial/mct_u232.c                      |  26 ++-
 drivers/usb/serial/mxuport.c                       |   8 +
 drivers/usb/serial/omninet.c                       |   9 +-
 drivers/usb/serial/option.c                        |   9 +-
 drivers/usb/serial/safe_serial.c                   |  11 ++
 drivers/usb/storage/unusual_uas.h                  |   7 +
 drivers/usb/typec/altmodes/displayport.c           |   2 +
 drivers/usb/typec/tcpm/tcpci_maxim_core.c          |   9 +
 drivers/usb/typec/tcpm/tcpm.c                      | 117 ++++++-----
 drivers/usb/typec/tcpm/wcove.c                     |  13 +-
 drivers/usb/typec/tipd/core.c                      |   1 +
 drivers/usb/typec/ucsi/displayport.c               |   4 +
 drivers/usb/typec/ucsi/ucsi.c                      |  24 ++-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |   5 +
 drivers/usb/usbip/vudc_dev.c                       |   1 +
 drivers/usb/usbip/vudc_transfer.c                  |   3 +-
 fs/hpfs/alloc.c                                    |   2 +-
 fs/hugetlbfs/inode.c                               |  46 ++---
 fs/smb/client/smb2pdu.c                            |   2 +-
 fs/smb/server/smb2pdu.c                            |  11 ++
 fs/smb/server/smbacl.c                             |   8 +-
 include/acpi/acpixf.h                              |   5 +
 include/kunit/test.h                               |   1 +
 include/linux/compat.h                             |   4 +
 include/linux/compiler-clang.h                     |   6 +
 include/linux/compiler_attributes.h                |  11 ++
 include/linux/compiler_types.h                     |   4 +
 include/linux/dpll.h                               |   1 +
 include/linux/hid.h                                |   2 -
 include/linux/hugetlb.h                            |   8 +-
 include/linux/hugetlb_inline.h                     |  12 +-
 include/linux/intel_vsec.h                         |   4 +-
 include/linux/mailbox_controller.h                 |   3 +
 include/linux/parport.h                            |   1 +
 include/linux/serial_core.h                        |  12 ++
 include/linux/skbuff.h                             |   2 +
 include/linux/syscalls.h                           |   4 +
 include/net/netfilter/nf_tables.h                  |   7 +
 include/net/xfrm.h                                 |   3 +-
 ipc/util.c                                         |   2 +-
 kernel/fork.c                                      |  11 +-
 lib/debugobjects.c                                 |   2 +-
 lib/kunit/executor.c                               |  19 +-
 lib/kunit/test.c                                   |   1 +
 mm/damon/sysfs-schemes.c                           |   8 +-
 mm/hugetlb.c                                       |  75 +++----
 mm/memcontrol.c                                    |   6 +
 mm/memfd.c                                         |  12 +-
 mm/migrate_device.c                                |   4 +-
 mm/rmap.c                                          |   2 +
 mm/vmalloc.c                                       |   2 +-
 net/bluetooth/6lowpan.c                            |   2 +
 net/bluetooth/hci_conn.c                           |   4 +-
 net/bluetooth/hci_sync.c                           |  16 +-
 net/bluetooth/hidp/core.c                          |  23 ++-
 net/bluetooth/iso.c                                |  12 +-
 net/bluetooth/l2cap_core.c                         |  41 +++-
 net/bluetooth/l2cap_sock.c                         |  16 +-
 net/bridge/br_netlink.c                            |  17 +-
 net/bridge/br_switchdev.c                          |   1 -
 net/bridge/br_sysfs_if.c                           |  30 ++-
 net/bridge/netfilter/ebtables.c                    |  30 +++
 net/core/filter.c                                  |   2 +-
 net/core/skbuff.c                                  |  45 ++++-
 net/ethtool/cmis.h                                 |   4 +-
 net/ethtool/cmis_cdb.c                             |   9 +-
 net/ethtool/cmis_fw_update.c                       |  44 +++--
 net/ethtool/coalesce.c                             |   6 +
 net/ethtool/eeprom.c                               |  10 +-
 net/ethtool/linkstate.c                            |   6 +-
 net/ethtool/module.c                               |  41 ++--
 net/ethtool/netlink.c                              |   4 +-
 net/ethtool/netlink.h                              |   4 +-
 net/ethtool/pse-pd.c                               |  10 +-
 net/ethtool/rss.c                                  |  37 ++--
 net/ethtool/strset.c                               |   2 +-
 net/ethtool/tsconfig.c                             |  15 +-
 net/ethtool/tsinfo.c                               |  19 +-
 net/handshake/genl.c                               |   3 +-
 net/handshake/genl.h                               |   1 +
 net/handshake/handshake-test.c                     |  10 +-
 net/handshake/handshake.h                          |   6 +-
 net/handshake/netlink.c                            |  29 ++-
 net/handshake/request.c                            |  81 ++++++--
 net/handshake/tlshd.c                              |   6 +-
 net/hsr/hsr_forward.c                              |   4 +-
 net/ipv4/ah4.c                                     |   2 +-
 net/ipv4/esp4.c                                    |  16 +-
 net/ipv4/ip_tunnel_core.c                          |  22 ++-
 net/ipv4/sysctl_net_ipv4.c                         |   2 +-
 net/ipv6/addrconf.c                                |   2 +-
 net/ipv6/ah6.c                                     |   2 +-
 net/ipv6/datagram.c                                |  54 ++++-
 net/ipv6/esp6.c                                    |  16 +-
 net/ipv6/exthdrs.c                                 |   6 +-
 net/ipv6/ip6_vti.c                                 |  23 ++-
 net/ipv6/route.c                                   |   5 +
 net/iucv/af_iucv.c                                 |  20 +-
 net/key/af_key.c                                   |   6 +-
 net/l2tp/l2tp_core.c                               |  11 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   3 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +
 net/netfilter/nft_bitwise.c                        |  18 +-
 net/netfilter/nft_byteorder.c                      |  13 +-
 net/netfilter/xt_cpu.c                             |   2 +-
 net/netlink/af_netlink.c                           |  11 +-
 net/nfc/hci/core.c                                 |  10 +
 net/nfc/llcp_core.c                                |  11 ++
 net/nfc/llcp_sock.c                                |   2 +
 net/nfc/nci/hci.c                                  |  10 +
 net/rxrpc/ar-internal.h                            |   7 +-
 net/rxrpc/conn_event.c                             |  30 ++-
 net/rxrpc/insecure.c                               |   5 +-
 net/rxrpc/rxgk.c                                   |  98 +++------
 net/rxrpc/rxgk_app.c                               |  46 ++---
 net/rxrpc/rxgk_common.h                            |  92 +--------
 net/rxrpc/rxkad.c                                  |  29 +--
 net/sched/act_mirred.c                             |  77 +++++---
 net/sched/sch_netem.c                              |  47 +----
 net/sched/sch_sfb.c                                |   2 +-
 net/sctp/socket.c                                  |   2 +
 net/smc/af_smc.c                                   |   4 +-
 net/vmw_vsock/af_vsock.c                           |  49 +++--
 net/vmw_vsock/hyperv_transport.c                   |   9 +-
 net/vmw_vsock/virtio_transport_common.c            |  26 ++-
 net/vmw_vsock/vmci_transport.c                     |   8 +-
 net/xfrm/xfrm_input.c                              |  16 +-
 net/xfrm/xfrm_ipcomp.c                             |  12 +-
 net/xfrm/xfrm_iptfs.c                              |  28 ++-
 net/xfrm/xfrm_policy.c                             |  17 +-
 net/xfrm/xfrm_state.c                              |  23 ++-
 net/xfrm/xfrm_user.c                               |   5 +-
 sound/core/oss/pcm_oss.c                           |  18 +-
 .../motu/motu-register-dsp-message-parser.c        |  11 +-
 sound/hda/codecs/realtek/alc269.c                  |  12 +-
 sound/hda/codecs/side-codecs/cs35l56_hda.c         |  17 +-
 sound/soc/codecs/simple-mux.c                      |   2 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  29 ++-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |  43 ++--
 sound/usb/mixer_scarlett2.c                        |  33 +++-
 tools/bootconfig/main.c                            |   4 +-
 tools/testing/cxl/test/cxl.c                       | 105 ++++------
 tools/testing/selftests/net/ioam6.sh               |   2 +-
 316 files changed, 3289 insertions(+), 1907 deletions(-)


