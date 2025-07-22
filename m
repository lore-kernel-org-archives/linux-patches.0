Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124C02EAB9C;
	Tue, 22 Jul 2025 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192621; cv=none; b=vGOQw/ZIDze765e+nGDL9BhxifWkqbM9BOwwAq+zAEyTWVINJ4248Tzxu3zVw5LplrT15LPjU4u44vS/9ATTzAUHEYh+Im9dFhzGynXjFqZ29/9tOC9JhAsHhNN3X0dmoo9ImOknyXhYzJrm2V+7PcpHr43EcKIj5vOIRD8L00Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192621; c=relaxed/simple;
	bh=w0rcqpyWDLnLXX57ZesNTKupHQrxfoKrd9XVBBQ1QtU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TyeRaxFUbY1GLx+Wgkv6MHd3o2QfzhBFwN8XE0hgfgSQnKmNRu45hVGBdRxk+IfBg1NMvmE+L+oCVukBtVUyuzHl36eHS6+pRDNGbMSaVzMxcUTw8wpHe7X8Aj0dXrEqZf/qxjodg+gD6WVEwIjpaEWdo8KJwHemC9V8lwnc5Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfAaxMo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfAaxMo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126B8C4CEF1;
	Tue, 22 Jul 2025 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192620;
	bh=w0rcqpyWDLnLXX57ZesNTKupHQrxfoKrd9XVBBQ1QtU=;
	h=From:To:Cc:Subject:Date:From;
	b=pfAaxMo72wsczAJHtf0b3j8IY/U92fEyv2HzdnUsVUjHVBjPOaShkSrb+03BhqCfh
	 4znbOsbi8UKuKHJBC/F2LgXnSn2r6lRKVkDrIwijyio5cLkh46vZQmD9qNbMGZ7Ao1
	 iO2hmtLaWuaqhNNklhBBR1/noCourw1+7Yca3IWc=
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
Subject: [PATCH 6.12 000/158] 6.12.40-rc1 review
Date: Tue, 22 Jul 2025 15:43:04 +0200
Message-ID: <20250722134340.596340262@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.40-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.40-rc1
X-KernelTest-Deadline: 2025-07-24T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.40 release.
There are 158 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.40-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.40-rc1

Stefan Metzmacher <metze@samba.org>
    smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Move page fault init after topology init

Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
    drm/xe/mocs: Initialize MOCS index early

Chen Ridong <chenridong@huawei.com>
    sched,freezer: Remove unnecessary warning in __thaw_task

Johan Hovold <johan+linaro@kernel.org>
    i2c: omap: fix deprecated of_property_read_bool() use

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: omap: Fix an error handling path in omap_i2c_probe()

Jayesh Choudhary <j-choudhary@ti.com>
    i2c: omap: Add support for setting mux

Ihor Solodrai <ihor.solodrai@pm.me>
    selftests/bpf: Set test path for token/obj_priv_implicit_token_envvar

Miguel Ojeda <ojeda@kernel.org>
    rust: use `#[used(compiler)]` to fix build and `modpost` with Rust >= 1.89.0

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix multicast packets received count

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: dwc3: qcom: Don't leave BCR asserted

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Don't try to recover devices lost during warm reset.

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing of delayed work used for post resume purposes

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: fix detection of high tier USB3 devices behind suspended hubs

Boris Burkov <boris@bur.io>
    btrfs: fix block group refcount race in btrfs_create_pending_block_groups()

Al Viro <viro@zeniv.linux.org.uk>
    clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    sched: Change nr_uninterruptible type to unsigned long

Breno Leitao <leitao@debian.org>
    efivarfs: Fix memory leak of efivarfs_fs_info in fs_context error paths

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Fix handling of BPF arena relocations

Icenowy Zheng <uwu@icenowy.me>
    drm/mediatek: only announce AFBC if really supported

Jason-JH Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Add wait_event_timeout when disabling plane

Chen Ridong <chenridong@huawei.com>
    Revert "cgroup_freezer: cgroup_freezing: Check if not frozen"

David Howells <dhowells@redhat.com>
    rxrpc: Fix transmission of an abort in response to an abort

David Howells <dhowells@redhat.com>
    rxrpc: Fix recv-recv race of completed call

William Liu <will@willsroot.io>
    net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree

Joseph Huang <Joseph.Huang@garmin.com>
    net: bridge: Do not offload IGMP/MLD messages

Dong Chenchen <dongchenchen2@huawei.com>
    net: vlan: fix VLAN 0 refcount imbalance of toggling filtering during runtime

Jakub Kicinski <kuba@kernel.org>
    tls: always refresh the queue when reading sock

Zigit Zo <zuozhijie@bytedance.com>
    virtio-net: fix recursived rtnl_lock() during probe()

Li Tian <litian@redhat.com>
    hv_netvsc: Set VF priv_flags to IFF_NO_ADDRCONF before open to prevent IPv6 addrconf

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to adjust outgoing MTU

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Prepare to stop SR-IOV support prior GT reset

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Move VFs reprovisioning to worker

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Sanitize VF scratch registers on FLR

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack: fix crash due to removal of uninitialised entry

Felix Fietkau <nbd@nbd.name>
    net: fix segmentation after TCP/UDP fraglist GRO

Yue Haibing <yuehaibing@huawei.com>
    ipv6: mcast: Delay put pmc->idev in mld_del_delrec()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_size when LRO is used

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: QCA: Fix downloading wrong NVM for WCN6855 GF variant without board ID

Christian Eggers <ceggers@arri.de>
    Bluetooth: hci_core: add missing braces when using macro parameters

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: If an unallowed command is received consider it a failure

Alessandro Gasbarroni <alex.gasbarroni@gmail.com>
    Bluetooth: hci_sync: fix connectable extended advertising when using static random address

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix null-ptr-deref in l2cap_sock_resume_cb()

Andreas Schwab <schwab@suse.de>
    riscv: traps_misaligned: properly sign extend value in misaligned load handler

Nam Cao <namcao@linutronix.de>
    riscv: Enable interrupt during exception handling

Ming Lei <ming.lei@redhat.com>
    loop: use kiocb helpers to fix lockdep warning

Oliver Neukum <oneukum@suse.com>
    usb: net: sierra: check for no status endpoint

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: check correct pointer in fwlog debugfs

Dave Ertman <david.m.ertman@intel.com>
    ice: add NULL check in eswitch lag check

Marius Zachmann <mail@mariuszachmann.de>
    hwmon: (corsair-cpro) Validate the size of the received input buffer

Paolo Abeni <pabeni@redhat.com>
    selftests: net: increase inter-packet timeout in udpgro.sh

Brett Werling <brett.werling@garmin.com>
    can: tcan4x5x: fix reset gpio usage during probe

Sean Nyekjaer <sean@geanix.com>
    can: tcan4x5x: add option for selecting nWKRQ voltage

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: remove scan request n_channels counted_by

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix callback lock for TLS handshake

Yu Kuai <yukuai3@huawei.com>
    nvme: fix misaccounting of nvme-mpath inflight I/O

Sean Anderson <sean.anderson@linux.dev>
    net: phy: Don't register LEDs for genphy

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Fix various oops due to inet_sock type confusion.

John Garry <john.g.garry@oracle.com>
    nvme: fix endianness of command word prints in nvme_log_err_passthru()

Zheng Qixing <zhengqixing@huawei.com>
    nvme: fix inconsistent RCU list manipulation in nvme_ns_add_to_ctrl_list()

Al Viro <viro@zeniv.linux.org.uk>
    fix a leak in fcntl_dirnotify()

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix use-after-free in cifs_oplock_break

Kuniyuki Iwashima <kuniyu@google.com>
    rpl: Fix use-after-free in rpl_do_srh_inline().

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix race condition on qfq_aggregate

Ming Lei <ming.lei@redhat.com>
    block: fix kobject leak in blk_unregister_queue

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: emaclite: Fix missing pointer increment in aligned_read()

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix the incorrect return value in __cachefiles_write()

Andrea Righi <arighi@nvidia.com>
    selftests/sched_ext: Fix exit selftest hang on UP

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject %p% format string in bprintf-like helpers

Richard Zhu <hongxing.zhu@nxp.com>
    arm64: dts: imx95: Correct the DMA interrupter number of pcie0_ep

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: fix for clearing command status register

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    soundwire: amd: fix for handling slave alerts after link is down

Andy Yan <andyshrk@163.com>
    arm64: dts: rockchip: Add cd-gpios for sdcard detect on Cool Pi 4B

Andy Yan <andyshrk@163.com>
    arm64: dts: rockchip: Add cd-gpios for sdcard detect on Cool Pi CM5

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix initialization of data for instructions that write to subdevice

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix use of uninitialized data in insn_rw_emulate_bits()

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fix some signed shift left operations

Ian Abbott <abbotti@mev.co.uk>
    comedi: Fail COMEDI_INSNLIST ioctl if n_insns is too large

Ian Abbott <abbotti@mev.co.uk>
    comedi: das6402: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: das16m1: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: aio_iiro_16: Fix bit shift out of bounds

Ian Abbott <abbotti@mev.co.uk>
    comedi: pcl812: Fix bit shift out of bounds

Maud Spierings <maudspierings@gocontroll.com>
    iio: common: st_sensors: Fix use of uninitialize device structs

Markus Burri <markus.burri@mt.com>
    iio: backend: fix out-of-bound write

Chen Ni <nichen@iscas.ac.cn>
    iio: adc: stm32-adc: Fix race in installing chained IRQ handler

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Reorder mode_list[] entries

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Fix MAX1363_4X_CHANS/MAX1363_8X_CHANS[]

Chen-Yu Tsai <wens@csie.org>
    iio: adc: axp20x_adc: Add missing sentinel to AXP717 ADC channel maps

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: Fix use after free in fxls8962af_fifo_flush

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Don't disable channels that aren't enabled

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Cleanup resources in stack-order

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix use-after-free in crypt_message when using async crypto

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Fix bpf_arch_text_poke() with new_addr == NULL again

Maulik Shah <maulik.shah@oss.qualcomm.com>
    pmdomain: governor: Consider CPU latency tolerance from pm_domain_cpu_gov

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: properly reset Rx ring descriptor

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix the using of Rx buffer DMA

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: remove duplicate page_pool_put_full_page()

Markus Blöchl <markus@blochl.de>
    net: stmmac: intel: populate entire system_counterval_t in get_time_fn() callback

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Workaround for Errata i2312

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    mmc: sdhci-pci: Quirk for broken command queuing on Intel GLK-based Positivo models

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: bcm2835: Fix dma_unmap_sg() nents value

Nathan Chancellor <nathan@kernel.org>
    memstick: core: Zero initialize id_reg in h_memstick_read_dev_id()

Jan Kara <jack@suse.cz>
    isofs: Verify inode mode when loading from disk

Dan Carpenter <dan.carpenter@linaro.org>
    dmaengine: nbpfaxi: Fix memory corruption in probe()

Daniel Lezcano <daniel.lezcano@linaro.org>
    cpuidle: psci: Fix cpuhotplug routine with PREEMPT_RT=y

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btintel: Check if controller is ISO capable on btintel_classify_pkt_type

Yun Lu <luyun@kylinos.cn>
    af_packet: fix soft lockup issue caused by tpacket_snd()

Yun Lu <luyun@kylinos.cn>
    af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()

Jakob Unterwurzacher <jakob.unterwurzacher@cherry.de>
    arm64: dts: rockchip: use cs-gpios for spi1 on ringneck

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw73xx: fix TPM SPI frequency

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw72xx: fix TPM SPI frequency

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw71xx: fix TPM SPI frequency

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: Keep LDO5 always on

Meng Li <Meng.Li@windriver.com>
    arm64: dts: add big-endian property back into watchdog node

Tim Harvey <tharvey@gateworks.com>
    arm64: dts: imx8mp-venice-gw74xx: fix TPM SPI frequency

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Nathan Chancellor <nathan@kernel.org>
    phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()

Paolo Abeni <pabeni@redhat.com>
    mptcp: reset fallback status gracefully at disconnect() time

Paolo Abeni <pabeni@redhat.com>
    mptcp: plug races between subflow fail and subflow creation

Paolo Abeni <pabeni@redhat.com>
    mptcp: make fallback action and fallback decision atomic

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/poll: fix POLLERR handling

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for ASUS ROG Strix G712LWS

Edip Hazuri <edip@medip.dev>
    ALSA: hda/realtek - Fix mute LED for HP Victus 16-r0xxx

Clayton King <clayton.king@amd.com>
    drm/amd/display: Free memory allocation

Melissa Wen <mwen@igalia.com>
    drm/amd/display: Disable CRTC degamma LUT for DCN401

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Increase reset counter only on success

Eeli Haapalainen <eeli.haapalainen@protonmail.com>
    drm/amdgpu/gfx8: reset compute ring wptr on the GPU on resume

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.89.0

Tomas Glozar <tglozar@redhat.com>
    tracing/osnoise: Fix crash in timerlat_dump_stack()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add down_write(trace_event_sem) when adding trace event

Nathan Chancellor <nathan@kernel.org>
    tracing/probes: Avoid using params uninitialized in parse_btf_arg()

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: do not bypass hid_hw_raw_request

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure __hid_request reserves the report ID as the first byte

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure the allocated report buffer can contain the reserved report ID

Sheng Yong <shengyong1@xiaomi.com>
    dm-bufio: fix sched in atomic context

Naman Jain <namjain@linux.microsoft.com>
    tools/hv: fcopy: Fix irregularities with size of ring buffer

Cheng Ming Lin <chengminglin@mxic.com.tw>
    spi: Add check for 8-bit transfer with 8 IO mode support

Thomas Fourier <fourier.thomas@gmail.com>
    pch_uart: Fix dma_sync_sg_for_device() nents value

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - set correct controller type for Acer NGR200

Michael C. Pratt <mcpratt@pm.me>
    nvmem: layouts: u-boot-env: remove crc32 endianness conversion

Steffen Bätz <steffen@innosonix.de>
    nvmem: imx-ocotp: fix MAC address byte length

Stefan Wahren <wahrenst@gmx.net>
    Revert "staging: vchiq_arm: Create keep-alive thread during probe"

Alok Tiwari <alok.a.tiwari@oracle.com>
    thunderbolt: Fix bit masking in tb_dp_port_set_hops()

Mario Limonciello <mario.limonciello@amd.com>
    thunderbolt: Fix wake on connect at runtime

Clément Le Goffic <clement.legoffic@foss.st.com>
    i2c: stm32f7: unmap DMA mapped buffer

Clément Le Goffic <clement.legoffic@foss.st.com>
    i2c: stm32: fix the device used for the DMA map

Xinyu Liu <1171169449@qq.com>
    usb: gadget: configfs: Fix OOB read on empty string write

Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
    usb: dwc2: gadget: Fix enter to hibernation for UTMI+ PHY

Drew Hamilton <drew.hamilton@zetier.com>
    usb: musb: fix gadget state on disconnect

Ryan Mann (NDI) <rmann@ndigital.com>
    USB: serial: ftdi_sio: add support for NDI EMGUIDE GEMINI

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W640

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 (ECM) composition

Haotien Hsu <haotienh@nvidia.com>
    phy: tegra: xusb: Disable periodic tracking on Tegra234

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Decouple CYA_TRK_CODE_UPDATE_ON_IDLE from trk_hw_mode

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Fix unbalanced regulator disable in UTMI PHY mode


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi     |   3 +-
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |   1 +
 .../boot/dts/freescale/imx8mp-venice-gw71xx.dtsi   |   2 +-
 .../boot/dts/freescale/imx8mp-venice-gw72xx.dtsi   |   2 +-
 .../boot/dts/freescale/imx8mp-venice-gw73xx.dtsi   |   2 +-
 .../boot/dts/freescale/imx8mp-venice-gw74xx.dts    |   2 +-
 arch/arm64/boot/dts/freescale/imx95.dtsi           |   2 +-
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |  23 +++++
 .../arm64/boot/dts/rockchip/rk3588-coolpi-cm5.dtsi |   1 +
 arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts |   1 +
 arch/riscv/kernel/traps.c                          |  10 +-
 arch/riscv/kernel/traps_misaligned.c               |   2 +-
 arch/s390/net/bpf_jit_comp.c                       |  10 +-
 block/blk-sysfs.c                                  |   1 +
 drivers/block/loop.c                               |   5 +-
 drivers/bluetooth/btintel.c                        |   2 +-
 drivers/bluetooth/btusb.c                          |  78 ++++++++------
 drivers/comedi/comedi_fops.c                       |  30 +++++-
 drivers/comedi/drivers.c                           |  17 +--
 drivers/comedi/drivers/aio_iiro_16.c               |   3 +-
 drivers/comedi/drivers/das16m1.c                   |   3 +-
 drivers/comedi/drivers/das6402.c                   |   3 +-
 drivers/comedi/drivers/pcl812.c                    |   3 +-
 drivers/cpuidle/cpuidle-psci.c                     |  23 +++--
 drivers/dma/nbpfaxi.c                              |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   9 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c              |   1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  11 +-
 .../amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |   3 +-
 drivers/gpu/drm/mediatek/mtk_crtc.c                |  36 ++++++-
 drivers/gpu/drm/mediatek/mtk_crtc.h                |   1 +
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c            |   1 +
 drivers/gpu/drm/mediatek/mtk_ddp_comp.h            |   9 ++
 drivers/gpu/drm/mediatek/mtk_disp_drv.h            |   1 +
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c            |   7 ++
 drivers/gpu/drm/mediatek/mtk_plane.c               |  12 ++-
 drivers/gpu/drm/mediatek/mtk_plane.h               |   3 +-
 drivers/gpu/drm/xe/xe_gt.c                         |  15 +--
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c                | 114 ++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf.h                |   6 ++
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c        |   3 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h          |  10 ++
 drivers/hid/hid-core.c                             |  21 ++--
 drivers/hwmon/corsair-cpro.c                       |   5 +
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-omap.c                      |  30 +++++-
 drivers/i2c/busses/i2c-stm32.c                     |   8 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  24 ++---
 drivers/iio/accel/fxls8962af-core.c                |   2 +
 drivers/iio/accel/st_accel_core.c                  |  10 +-
 drivers/iio/adc/axp20x_adc.c                       |   1 +
 drivers/iio/adc/max1363.c                          |  43 ++++----
 drivers/iio/adc/stm32-adc-core.c                   |   7 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |  36 +++----
 drivers/iio/common/st_sensors/st_sensors_trigger.c |  20 ++--
 drivers/iio/industrialio-backend.c                 |   5 +-
 drivers/input/joystick/xpad.c                      |   2 +-
 drivers/md/dm-bufio.c                              |   6 +-
 drivers/memstick/core/memstick.c                   |   2 +-
 drivers/mmc/host/bcm2835.c                         |   3 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   3 +-
 drivers/mmc/host/sdhci_am654.c                     |   9 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |  80 +++++++++++----
 drivers/net/can/m_can/tcan4x5x.h                   |   2 +
 drivers/net/ethernet/intel/ice/ice_debugfs.c       |   2 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  12 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   8 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   9 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |  20 ++--
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   2 -
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   2 +-
 drivers/net/hyperv/netvsc_drv.c                    |   5 +-
 drivers/net/phy/phy_device.c                       |   6 +-
 drivers/net/usb/sierra_net.c                       |   4 +
 drivers/net/virtio_net.c                           |   2 +-
 drivers/nvme/host/core.c                           |  18 ++--
 drivers/nvme/target/tcp.c                          |   4 +-
 drivers/nvmem/imx-ocotp-ele.c                      |   5 +-
 drivers/nvmem/imx-ocotp.c                          |   5 +-
 drivers/nvmem/layouts/u-boot-env.c                 |   6 +-
 drivers/phy/tegra/xusb-tegra186.c                  |  77 ++++++++------
 drivers/phy/tegra/xusb.h                           |   1 +
 drivers/pmdomain/governor.c                        |  18 +++-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |  13 ++-
 drivers/soundwire/amd_manager.c                    |   4 +-
 drivers/spi/spi.c                                  |  14 ++-
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |  69 +++++++------
 drivers/thunderbolt/switch.c                       |  10 +-
 drivers/thunderbolt/tb.h                           |   2 +-
 drivers/thunderbolt/usb4.c                         |  12 +--
 drivers/tty/serial/pch_uart.c                      |   2 +-
 drivers/usb/core/hub.c                             |  36 ++++++-
 drivers/usb/core/hub.h                             |   1 +
 drivers/usb/dwc2/gadget.c                          |  40 +++++---
 drivers/usb/dwc3/dwc3-qcom.c                       |   8 +-
 drivers/usb/gadget/configfs.c                      |   4 +
 drivers/usb/musb/musb_gadget.c                     |   2 +
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   3 +
 drivers/usb/serial/option.c                        |   5 +
 fs/btrfs/block-group.c                             |   3 +
 fs/cachefiles/io.c                                 |   2 -
 fs/cachefiles/ondemand.c                           |   4 +-
 fs/efivarfs/super.c                                |   6 ++
 fs/isofs/inode.c                                   |   9 +-
 fs/namespace.c                                     |   5 +
 fs/notify/dnotify/dnotify.c                        |   8 +-
 fs/smb/client/file.c                               |  10 +-
 fs/smb/client/smb2ops.c                            |   7 +-
 fs/smb/client/smbdirect.c                          |  31 +++++-
 include/net/bluetooth/hci_core.h                   |  22 ++--
 include/net/cfg80211.h                             |   2 +-
 include/net/netfilter/nf_conntrack.h               |  15 ++-
 include/trace/events/rxrpc.h                       |   3 +
 io_uring/net.c                                     |  12 ++-
 io_uring/poll.c                                    |   2 -
 kernel/bpf/helpers.c                               |  11 +-
 kernel/cgroup/legacy_freezer.c                     |   8 +-
 kernel/freezer.c                                   |  15 +--
 kernel/sched/loadavg.c                             |   2 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/trace/trace_events.c                        |   5 +
 kernel/trace/trace_osnoise.c                       |   2 +-
 kernel/trace/trace_probe.c                         |   2 +-
 net/8021q/vlan.c                                   |  42 ++++++--
 net/8021q/vlan.h                                   |   1 +
 net/bluetooth/hci_sync.c                           |   4 +-
 net/bluetooth/l2cap_core.c                         |  26 ++++-
 net/bluetooth/l2cap_sock.c                         |   3 +
 net/bluetooth/smp.c                                |  21 +++-
 net/bluetooth/smp.h                                |   1 +
 net/bridge/br_switchdev.c                          |   3 +
 net/ipv4/tcp_offload.c                             |   1 +
 net/ipv4/udp_offload.c                             |   1 +
 net/ipv6/mcast.c                                   |   2 +-
 net/ipv6/rpl_iptunnel.c                            |   8 +-
 net/mptcp/options.c                                |   3 +-
 net/mptcp/pm.c                                     |   8 +-
 net/mptcp/protocol.c                               |  56 ++++++++--
 net/mptcp/protocol.h                               |  29 ++++--
 net/mptcp/subflow.c                                |  30 ++++--
 net/netfilter/nf_conntrack_core.c                  |  26 +++--
 net/packet/af_packet.c                             |  27 +++--
 net/phonet/pep.c                                   |   2 +-
 net/rxrpc/call_accept.c                            |   1 +
 net/rxrpc/output.c                                 |   3 +
 net/rxrpc/recvmsg.c                                |  19 +++-
 net/sched/sch_htb.c                                |   4 +-
 net/sched/sch_qfq.c                                |  30 ++++--
 net/smc/af_smc.c                                   |  14 +++
 net/smc/smc.h                                      |   8 +-
 net/tls/tls_strp.c                                 |   3 +-
 rust/Makefile                                      |   1 +
 rust/kernel/lib.rs                                 |   1 +
 rust/macros/module.rs                              |  10 +-
 scripts/Makefile.build                             |   2 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 tools/hv/hv_fcopy_uio_daemon.c                     |  91 ++++++++++++++--
 tools/lib/bpf/libbpf.c                             |  20 ++--
 tools/objtool/check.c                              |   1 +
 tools/testing/selftests/bpf/prog_tests/token.c     |  19 ++--
 tools/testing/selftests/net/udpgro.sh              |   8 +-
 tools/testing/selftests/sched_ext/exit.c           |   8 ++
 166 files changed, 1416 insertions(+), 554 deletions(-)


