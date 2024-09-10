Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D9A18FC99;
	Tue, 10 Sep 2024 10:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962443; cv=none; b=hBmlTLlmAETCdaoUA0WveX9RcjS5eszCRCTSyEWykORrMLnxLz8Vo+C7xEyCne5pnVXIU9BYWvnHPPPH9GM8WoKZEwJm93xnsKkTYK48zXiJNlnlrQp+uX4MAc0saBMNQxVMFMsD8NfJ1DTKc//NoE9DZ68Xroxm5BoaQE+URrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962443; c=relaxed/simple;
	bh=qDNsPdt0b4q6WYhtRLJY+ezGwPmnMrJVPyONwSFZ2ok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=idLKSVv2/3G56HmiZNUzYIjseK7xxI/rspkVDcJdfnh1NliFT2iSo2HZo9//PJoRqtoPFU9jr3Qh2X45SAVyv7yA9FGI83vqCfaygnOVo2h3PpKz8ixGlXnwGY5kHVFnRFxoeX5PNETiMFlINZ74Oby79ey0ZTRSJdSMINzF4cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZcWAU9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZcWAU9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AE5C4CEC3;
	Tue, 10 Sep 2024 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962442;
	bh=qDNsPdt0b4q6WYhtRLJY+ezGwPmnMrJVPyONwSFZ2ok=;
	h=From:To:Cc:Subject:Date:From;
	b=LZcWAU9uwxG42eMkFm1DUu6GBA+KYsHugRRtn/TxcKVIfPN3fB3eAqQ9C0PDc08k1
	 KmNkgonwhwRWTN5xYeyhVbkrUibDUc/YJzYe5uQXFqtIdYKy121c9KsKcWcwSbPEZ0
	 nhzeVC09iDWx+Jyjcu3PYqCZOpO5rTAHS5LMosyo=
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
Subject: [PATCH 5.4 000/121] 5.4.284-rc1 review
Date: Tue, 10 Sep 2024 11:31:15 +0200
Message-ID: <20240910092545.737864202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.284-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.284-rc1
X-KernelTest-Deadline: 2024-09-12T09:25+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.284 release.
There are 121 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.284-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.284-rc1

Zhang Changzhong <zhangchangzhong@huawei.com>
    cx82310_eth: fix error return code in cx82310_bind()

Daniel Borkmann <daniel@iogearbox.net>
    net, sunrpc: Remap EPERM in case of connection failure in xs_tcp_setup_socket

Roland Xu <mu001999@outlook.com>
    rtmutex: Drop rt_mutex::wait_lock before scheduling

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/i915/fence: Mark debug_fence_free() with __maybe_unused

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/i915/fence: Mark debug_fence_init_onstack() with __maybe_unused

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix kernel crash if commands allocation fails

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    arm64: acpi: Harden get_cpu_for_acpi_id() against missing CPU entry

James Morse <james.morse@arm.com>
    arm64: acpi: Move get_cpu_for_acpi_id() to a header

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: processor: Fix memory leaks in error paths of processor_add()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    ACPI: processor: Return an error if acpi_processor_get_info() fails in processor_add()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: protect references to superblock parameters exposed in sysfs

Qing Wang <wangqing@vivo.com>
    nilfs2: replace snprintf in show functions with sysfs_emit

Zheng Yejian <zhengyejian@huaweicloud.com>
    tracing: Avoid possible softlockup in tracing_iter_reset()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Rename ring_buffer_read() to read_buffer_iter_advance()

Sven Schnelle <svens@linux.ibm.com>
    uprobes: Use kzalloc to allocate xol area

Daniel Lezcano <daniel.lezcano@linaro.org>
    clocksource/drivers/timer-of: Remove percpu irq related code

Jacky Bai <ping.bai@nxp.com>
    clocksource/drivers/imx-tpm: Fix next event not taking effect sometime

Jacky Bai <ping.bai@nxp.com>
    clocksource/drivers/imx-tpm: Fix return -ETIME when delta exceeds INT_MAX

David Fernandez Gonzalez <david.fernandez.gonzalez@oracle.com>
    VMCI: Fix use-after-free when removing resource in vmci_resource_remove()

Naman Jain <namjain@linux.microsoft.com>
    Drivers: hv: vmbus: Fix rescind handling in uio_hv_generic

Saurabh Sengar <ssengar@linux.microsoft.com>
    uio_hv_generic: Fix kernel NULL pointer dereference in hv_uio_rescind

Geert Uytterhoeven <geert+renesas@glider.be>
    nvmem: Fix return type of devm_nvmem_device_get() in kerneldoc

Carlos Llamas <cmllamas@google.com>
    binder: fix UAF caused by offsets overwrite

Guillaume Stols <gstols@baylibre.com>
    iio: adc: ad7606: remove frstdata check for serial mode

Matteo Martelli <matteomartelli3@gmail.com>
    iio: fix scale application in iio_convert_raw_to_processed_unlocked

David Lechner <dlechner@baylibre.com>
    iio: buffer-dmaengine: fix releasing dma channel on error

Aleksandr Mishin <amishin@t-argos.ru>
    staging: iio: frequency: ad9834: Validate frequency parameter value

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations

Michael Ellerman <mpe@ellerman.id.au>
    ata: pata_macio: Use WARN instead of BUG

Kent Overstreet <kent.overstreet@linux.dev>
    lib/generic-radix-tree.c: Fix rare race in __genradix_ptr_alloc()

Stefan Wiehler <stefan.wiehler@nokia.com>
    of/irq: Prevent device address out-of-bounds read in interrupt map walk

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: sanity check symbolic link size

Oliver Neukum <oneukum@suse.com>
    usbnet: ipheth: race between ipheth_close and error handling

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: uinput - reject requests with unreasonable number of slots

Camila Alvarez <cam.alvarez.i@gmail.com>
    HID: cougar: fix slab-out-of-bounds Read in cougar_report_fixup

David Sterba <dsterba@suse.com>
    btrfs: initialize location to fix -Wmaybe-uninitialized in btrfs_lookup_dentry()

Dan Williams <dan.j.williams@intel.com>
    PCI: Add missing bridge lock to pci_bus_lock()

Josef Bacik <josef@toxicpanda.com>
    btrfs: clean up our handling of refs == 0 in snapshot delete

Josef Bacik <josef@toxicpanda.com>
    btrfs: replace BUG_ON with ASSERT in walk_down_proc()

Zqiang <qiang.zhang1211@gmail.com>
    smp: Add missing destroy_work_on_stack() call in smp_call_on_cpu()

Sascha Hauer <s.hauer@pengutronix.de>
    wifi: mwifiex: Do not return unused priv in mwifiex_get_priv_by_id()

Andreas Ziegler <ziegler.andreas@siemens.com>
    libbpf: Add NULL checks to bpf_object__{prev_map,next_map}

Guenter Roeck <linux@roeck-us.net>
    hwmon: (w83627ehf) Fix underflows seen when writing limit attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Fix underflows seen when writing limit attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm95234) Fix underflows seen when writing limit attributes

Guenter Roeck <linux@roeck-us.net>
    hwmon: (adc128d818) Fix underflows seen when writing limit attributes

Krishna Kumar <krishnak@linux.ibm.com>
    pci/hotplug/pnv_php: Fix hotplug driver crash on Powernv

Zijun Hu <quic_zijuhu@quicinc.com>
    devres: Initialize an uninitialized struct member

Johannes Berg <johannes.berg@intel.com>
    um: line: always fill *error_out in setup_one_line()

Waiman Long <longman@redhat.com>
    cgroup: Protect css->cgroup write under css_set_lock

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Handle volatile descriptor status read

Benjamin Marzinski <bmarzins@redhat.com>
    dm init: Handle minors larger than 255

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: topology: Properly initialize soc_enum values

Pawel Dembicki <paweldembicki@gmail.com>
    net: dsa: vsc73xx: fix possible subblocks range of CAPT block

Jonas Gorski <jonas.gorski@bisdn.de>
    net: bridge: br_fdb_external_learn_add(): always set EXT_LEARN

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: fdb: convert added_by_external_learn to use bitops

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: fdb: convert added_by_user to bitops

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: fdb: convert is_sticky to bitops

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: fdb: convert is_static to bitops

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: fdb: convert is_local to bitops

Oliver Neukum <oneukum@suse.com>
    usbnet: modern method to get random MAC

Jakub Kicinski <kuba@kernel.org>
    net: usb: don't write directly to netdev->dev_addr

Len Baker <len.baker@gmx.com>
    drivers/net/usb: Remove all strcpy() uses

Ondrej Zary <linux@zary.sk>
    cx82310_eth: re-enable ethernet mode after router reboot

Cong Wang <cong.wang@bytedance.com>
    tcp_bpf: fix return value of tcp_bpf_sendmsg()

Aleksandr Mishin <amishin@t-argos.ru>
    platform/x86: dell-smbios: Fix error path in dell_smbios_init()

Daiwei Li <daiweili@google.com>
    igb: Fix not clearing TimeSync interrupts for 82580

Kuniyuki Iwashima <kuniyu@amazon.com>
    can: bcm: Remove proc entry when dev is unregistered.

Jules Irenge <jbi.octave@gmail.com>
    pcmcia: Use resource_size function on resource object

Chen Ni <nichen@iscas.ac.cn>
    media: qcom: camss: Add check for v4l2_fwnode_endpoint_parse

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Add workaround for Errata #i2037 (AM65x SR 1.0)

Shantanu Goel <sgoel01@yahoo.com>
    usb: uas: set host status byte on data completion error

Arend van Spriel <arend.vanspriel@broadcom.com>
    wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3

Jan Kara <jack@suse.cz>
    udf: Avoid excessive partition lengths

Yunjian Wang <wangyunjian@huawei.com>
    netfilter: nf_conncount: fix wrong variable type

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Remove put_pid()/put_cred() in copy_peercred().

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Do not allow mapping IRQ 0 and 1

Konstantin Andreev <andreev@swemel.ru>
    smack: unix sockets: fix accept()ed socket label

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add input value sanity checks to HDMI channel map controls

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix state management in error path of log writing function

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix missing cleanup on rollforward recovery error

Toke Høiland-Jørgensen <toke@redhat.com>
    sched: sch_cake: fix bulk flow accounting logic for host fairness

Eric Dumazet <edumazet@google.com>
    ila: call nf_unregister_net_hooks() sooner

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix the trion pll postdiv set rate API

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix the pll post div mask

Peter Griffin <peter.griffin@linaro.org>
    clk: hi6220: use CLK_OF_DECLARE_DRIVER

Peter Griffin <peter.griffin@linaro.org>
    reset: hi6220: Add support for AO reset controller

Jann Horn <jannh@google.com>
    fuse: use unsigned type for getxattr/listxattr size truncation

Joanne Koong <joannelkoong@gmail.com>
    fuse: update stats for pages in dropped aux writeback list

Liao Chen <liaochen4@huawei.com>
    mmc: sdhci-of-aspeed: fix module autoloading

Sam Protsenko <semen.protsenko@linaro.org>
    mmc: dw_mmc: Fix IDMAC operation with pages bigger than 4K

Ma Ke <make24@iscas.ac.cn>
    irqchip/gic-v2m: Fix refcount leak in gicv2m_of_init()

Zheng Qixing <zhengqixing@huawei.com>
    ata: libata: Fix memory leak for error path in ata_host_alloc()

Christoffer Sandberg <cs@tuxedo.de>
    ALSA: hda/conexant: Add pincfg quirk to enable top speakers on Sirius devices

robelin <robelin@nvidia.com>
    ASoC: dapm: Fix UAF for snd_soc_pcm_runtime object

Stephen Hemminger <stephen@networkplumber.org>
    sch/netem: fix use after free in netem_dequeue

Richard Fitzgerald <rf@opensource.cirrus.com>
    i2c: Use IS_REACHABLE() for substituting empty ACPI functions

Jan Kara <jack@suse.cz>
    udf: Limit file size to 4TB

Breno Leitao <leitao@debian.org>
    virtio_net: Fix napi_skb_cache_put warning

Stanislav Fomichev <sdf@google.com>
    net: set SOCK_RCU_FREE before inserting socket into hashtable

Christoph Hellwig <hch@lst.de>
    block: initialize integrity buffer to zero before writing it to media

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Enforce alignment of frame and interval

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip wbscl_set_scaler_filter if filter is null

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: make hash table duplicates more survivable

Casey Schaufler <casey@schaufler-ca.com>
    smack: tcp: ipv4, fix incorrect labeling

Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
    usb: typec: ucsi: Fix null pointer dereference in trace

Simon Holesch <simon@holesch.de>
    usbip: Don't submit special requests twice

Shannon Nelson <shannon.nelson@amd.com>
    ionic: fix potential irq name truncation

Leesoo Ahn <lsahn@ooseel.net>
    apparmor: fix possible NULL pointer dereference

Michael Chen <michael.chen@amd.com>
    drm/amdkfd: Reconcile the definition and use of oem_id in struct kfd_topology_device

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix mc_data out-of-bounds read warning

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix ucode out-of-bounds read warning

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix Coverity INTEGER_OVERFLOW within dal_gpio_service_create

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check num_valid_sets before accessing reader_wm_sets[]

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Stop amdgpu_dm initialize when stream nums greater than 6

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check gpio_id before used as array index

Tim Huang <Tim.Huang@amd.com>
    drm/amdgpu: fix overflowed array index read warning

Ma Jun <Jun.Ma2@amd.com>
    drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr

ZHANG Yuntian <yt@radxa.com>
    net: usb: qmi_wwan: add MeiG Smart SRM825L

Richard Fitzgerald <rf@opensource.cirrus.com>
    i2c: Fix conditional for substituting empty ACPI functions

Philip Mueller <philm@manjaro.org>
    drm: panel-orientation-quirks: Add quirk for OrangePi Neo


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/acpi.h                      |  12 +++
 arch/arm64/kernel/acpi_numa.c                      |  11 --
 arch/um/drivers/line.c                             |   2 +
 block/bio-integrity.c                              |  11 +-
 drivers/acpi/acpi_processor.c                      |  15 +--
 drivers/android/binder.c                           |   1 +
 drivers/ata/libata-core.c                          |   4 +-
 drivers/ata/pata_macio.c                           |   7 +-
 drivers/base/devres.c                              |   1 +
 drivers/clk/hisilicon/clk-hi6220.c                 |   3 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   6 +-
 drivers/clocksource/timer-imx-tpm.c                |  16 ++-
 drivers/clocksource/timer-of.c                     |  17 +--
 drivers/clocksource/timer-of.h                     |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c           |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cgs.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_crat.h              |   2 -
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c          |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_topology.h          |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   5 +-
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c  |   3 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c   |   3 +
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c |  17 ++-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 ++
 drivers/gpu/drm/i915/i915_sw_fence.c               |   8 +-
 drivers/hid/hid-cougar.c                           |   2 +-
 drivers/hv/vmbus_drv.c                             |   1 +
 drivers/hwmon/adc128d818.c                         |   4 +-
 drivers/hwmon/lm95234.c                            |   9 +-
 drivers/hwmon/nct6775.c                            |   2 +-
 drivers/hwmon/w83627ehf.c                          |   4 +-
 drivers/iio/adc/ad7606.c                           |  28 +----
 drivers/iio/adc/ad7606.h                           |   2 +
 drivers/iio/adc/ad7606_par.c                       |  46 +++++++-
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   4 +-
 drivers/iio/inkern.c                               |   8 +-
 drivers/input/misc/uinput.c                        |  14 +++
 drivers/iommu/dmar.c                               |   2 +-
 drivers/irqchip/irq-armada-370-xp.c                |   4 +
 drivers/irqchip/irq-gic-v2m.c                      |   6 +-
 drivers/md/dm-init.c                               |   4 +-
 drivers/media/platform/qcom/camss/camss.c          |   5 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  18 +++-
 drivers/misc/vmw_vmci/vmci_resource.c              |   3 +-
 drivers/mmc/host/dw_mmc.c                          |   4 +-
 drivers/mmc/host/sdhci-of-aspeed.c                 |   1 +
 drivers/net/dsa/vitesse-vsc73xx-core.c             |  10 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  10 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   2 +-
 drivers/net/usb/ch9200.c                           |   4 +-
 drivers/net/usb/cx82310_eth.c                      |  56 ++++++++--
 drivers/net/usb/ipheth.c                           |   4 +-
 drivers/net/usb/kaweth.c                           |   3 +-
 drivers/net/usb/mcs7830.c                          |   4 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/sierra_net.c                       |   6 +-
 drivers/net/usb/sr9700.c                           |   4 +-
 drivers/net/usb/sr9800.c                           |   5 +-
 drivers/net/usb/usbnet.c                           |  23 ++--
 drivers/net/virtio_net.c                           |   8 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   3 +
 drivers/nvme/target/tcp.c                          |   4 +-
 drivers/nvmem/core.c                               |   6 +-
 drivers/of/irq.c                                   |  15 ++-
 drivers/pci/controller/dwc/pci-keystone.c          |  44 +++++++-
 drivers/pci/hotplug/pnv_php.c                      |   3 +-
 drivers/pci/pci.c                                  |  35 +++---
 drivers/pcmcia/yenta_socket.c                      |   6 +-
 drivers/platform/x86/dell-smbios-base.c            |   5 +-
 drivers/reset/hisilicon/hi6220_reset.c             |  69 +++++++++++-
 drivers/staging/iio/frequency/ad9834.c             |   2 +-
 drivers/uio/uio_hv_generic.c                       |  11 +-
 drivers/usb/storage/uas.c                          |   1 +
 drivers/usb/typec/ucsi/ucsi.h                      |   2 +-
 drivers/usb/usbip/stub_rx.c                        |  77 +++++++++-----
 fs/btrfs/extent-tree.c                             |  32 ++++--
 fs/btrfs/inode.c                                   |   2 +-
 fs/fuse/file.c                                     |   8 +-
 fs/fuse/xattr.c                                    |   4 +-
 fs/nfs/super.c                                     |   2 +
 fs/nilfs2/recovery.c                               |  35 +++++-
 fs/nilfs2/segment.c                                |  10 +-
 fs/nilfs2/sysfs.c                                  | 117 ++++++++++++---------
 fs/squashfs/inode.c                                |   7 +-
 fs/udf/super.c                                     |  24 ++++-
 include/linux/i2c.h                                |   2 +-
 include/linux/ring_buffer.h                        |   3 +-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/events/uprobes.c                            |   3 +-
 kernel/locking/rtmutex.c                           |   4 +-
 kernel/smp.c                                       |   1 +
 kernel/trace/ring_buffer.c                         |  23 ++--
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_functions_graph.c               |   2 +-
 lib/generic-radix-tree.c                           |   2 +
 net/bridge/br_fdb.c                                | 116 ++++++++++----------
 net/bridge/br_input.c                              |   2 +-
 net/bridge/br_private.h                            |  17 +--
 net/bridge/br_switchdev.c                          |   6 +-
 net/can/bcm.c                                      |   4 +
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/tcp_bpf.c                                 |   2 +-
 net/ipv6/ila/ila.h                                 |   1 +
 net/ipv6/ila/ila_main.c                            |   6 ++
 net/ipv6/ila/ila_xlat.c                            |  13 ++-
 net/netfilter/nf_conncount.c                       |   8 +-
 net/sched/sch_cake.c                               |  11 +-
 net/sched/sch_netem.c                              |   9 +-
 net/sunrpc/xprtsock.c                              |   7 ++
 net/unix/af_unix.c                                 |   9 +-
 net/wireless/scan.c                                |  46 +++++---
 security/apparmor/apparmorfs.c                     |   4 +
 security/smack/smack_lsm.c                         |  14 ++-
 sound/hda/hdmi_chmap.c                             |  18 ++++
 sound/pci/hda/patch_conexant.c                     |  11 ++
 sound/soc/soc-dapm.c                               |   1 +
 sound/soc/soc-topology.c                           |   2 +
 tools/lib/bpf/libbpf.c                             |   4 +-
 122 files changed, 946 insertions(+), 423 deletions(-)


