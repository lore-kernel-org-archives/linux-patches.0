Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479ED2E36E8;
	Tue, 22 Jul 2025 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192007; cv=none; b=qxsDnUWM1eDMNR/BjqofY38c95DunK3K0V+qT2V0xIFxxxPnU/oC7l9lxYE0+KiWOBBMgglm6197Xr5a7XiVHnJPOtewB7mc5kEkjm5PPYvxERNqDKZuYkin0QzK9yGa848M5dQbobTuVdMr8ABfJFmYUP8gzVdJEbR/pUv/yGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192007; c=relaxed/simple;
	bh=QRFDcyKqLWaedS6UMHL8OTtI2p9yrMYu+BmweiiucRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=efdfoAz/89NUhAS70FUX6FPTZuVYam0vJG03cYeOqbkntqStbtPvl3sp+/92LySgv5J7uY8CuCu4jAZeDAR2RIwPtxRSu49Mx4Eh1AmvguXfG/Twzq0GNdpjeuJy8BVXhsE7AKHESuzIZfp7LlOs0xoILDwTGTmSQBy0rdnDzvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyJqZeM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyJqZeM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4AFC4CEEB;
	Tue, 22 Jul 2025 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192006;
	bh=QRFDcyKqLWaedS6UMHL8OTtI2p9yrMYu+BmweiiucRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=OyJqZeM8QVLexld77mcguPqGLwuRUQbQek01GXjScqatawl7FxoGZvB4fa5Yyznet
	 4dHjJjpPk9K9/aVxt8i4/veuNljdIwOTwnFcCvd/mzGHKIcx0a/QRgIEZbo6HRhAI2
	 6NpCvDMkvkd2bGi9e0PLYs4ecSGVt0Ojw3Igoa+s=
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
Subject: [PATCH 6.1 00/79] 6.1.147-rc1 review
Date: Tue, 22 Jul 2025 15:43:56 +0200
Message-ID: <20250722134328.384139905@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.147-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.147-rc1
X-KernelTest-Deadline: 2025-07-24T13:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.147 release.
There are 79 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.147-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.147-rc1

Michael C. Pratt <mcpratt@pm.me>
    nvmem: layouts: u-boot-env: remove crc32 endianness conversion

Alexander Gordeev <agordeev@linux.ibm.com>
    mm/vmalloc: leave lazy MMU mode on PTE mapping error

Christian Eggers <ceggers@arri.de>
    Bluetooth: HCI: Set extended advertising data synchronously

Arun Raghavan <arun@asymptotic.io>
    ASoC: fsl_sai: Force a software reset when starting in consumer mode

Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
    usb: dwc3: qcom: Don't leave BCR asserted

Drew Hamilton <drew.hamilton@zetier.com>
    usb: musb: fix gadget state on disconnect

Paul Cercueil <paul@crapouillou.net>
    usb: musb: Add and use inline functions musb_{get,set}_state

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Don't try to recover devices lost during warm reset.

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing of delayed work used for post resume purposes

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: Fix flushing and scheduling of delayed work that tunes runtime pm

Mathias Nyman <mathias.nyman@linux.intel.com>
    usb: hub: fix detection of high tier USB3 devices behind suspended hubs

Al Viro <viro@zeniv.linux.org.uk>
    clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns

Hamish Martin <hamish.martin@alliedtelesis.co.nz>
    HID: mcp2221: Set driver data before I2C adapter add

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    sched: Change nr_uninterruptible type to unsigned long

Chen Ridong <chenridong@huawei.com>
    Revert "cgroup_freezer: cgroup_freezing: Check if not frozen"

William Liu <will@willsroot.io>
    net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree

Joseph Huang <Joseph.Huang@garmin.com>
    net: bridge: Do not offload IGMP/MLD messages

Dong Chenchen <dongchenchen2@huawei.com>
    net: vlan: fix VLAN 0 refcount imbalance of toggling filtering during runtime

Jakub Kicinski <kuba@kernel.org>
    tls: always refresh the queue when reading sock

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix attempting to adjust outgoing MTU

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack: fix crash due to removal of uninitialised entry

Yue Haibing <yuehaibing@huawei.com>
    ipv6: mcast: Delay put pmc->idev in mld_del_delrec()

Christoph Paasch <cpaasch@openai.com>
    net/mlx5: Correctly set gso_size when LRO is used

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: QCA: Fix downloading wrong NVM for WCN6855 GF variant without board ID

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: Fix using HCI_ERROR_REMOTE_USER_TERM on timeout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SMP: If an unallowed command is received consider it a failure

Alessandro Gasbarroni <alex.gasbarroni@gmail.com>
    Bluetooth: hci_sync: fix connectable extended advertising when using static random address

Kuniyuki Iwashima <kuniyu@google.com>
    Bluetooth: Fix null-ptr-deref in l2cap_sock_resume_cb()

Oliver Neukum <oneukum@suse.com>
    usb: net: sierra: check for no status endpoint

Marius Zachmann <mail@mariuszachmann.de>
    hwmon: (corsair-cpro) Validate the size of the received input buffer

Paolo Abeni <pabeni@redhat.com>
    selftests: net: increase inter-packet timeout in udpgro.sh

Yu Kuai <yukuai3@huawei.com>
    nvme: fix misaccounting of nvme-mpath inflight I/O

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix use-after-free in cifs_oplock_break

Kuniyuki Iwashima <kuniyu@google.com>
    rpl: Fix use-after-free in rpl_do_srh_inline().

Xiang Mei <xmei5@asu.edu>
    net/sched: sch_qfq: Fix race condition on qfq_aggregate

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: emaclite: Fix missing pointer increment in aligned_read()

Zizhi Wo <wozizhi@huawei.com>
    cachefiles: Fix the incorrect return value in __cachefiles_write()

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject %p% format string in bprintf-like helpers

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

Chen Ni <nichen@iscas.ac.cn>
    iio: adc: stm32-adc: Fix race in installing chained IRQ handler

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Reorder mode_list[] entries

Fabio Estevam <festevam@denx.de>
    iio: adc: max1363: Fix MAX1363_4X_CHANS/MAX1363_8X_CHANS[]

Sean Nyekjaer <sean@geanix.com>
    iio: accel: fxls8962af: Fix use after free in fxls8962af_fifo_flush

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Don't disable channels that aren't enabled

Andrew Jeffery <andrew@codeconstruct.com.au>
    soc: aspeed: lpc-snoop: Cleanup resources in stack-order

Wang Zhaolong <wangzhaolong@huaweicloud.com>
    smb: client: fix use-after-free in crypt_message when using async crypto

Maulik Shah <maulik.shah@oss.qualcomm.com>
    pmdomain: governor: Consider CPU latency tolerance from pm_domain_cpu_gov

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

Yun Lu <luyun@kylinos.cn>
    af_packet: fix soft lockup issue caused by tpacket_snd()

Yun Lu <luyun@kylinos.cn>
    af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: freescale: imx8mm-verdin: Keep LDO5 always on

Maor Gottlieb <maorg@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Nathan Chancellor <nathan@kernel.org>
    phonet/pep: Move call to pn_skb_get_dst_sockaddr() earlier in pep_sock_accept()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/poll: fix POLLERR handling

Steven Rostedt <rostedt@goodmis.org>
    tracing: Add down_write(trace_event_sem) when adding trace event

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: do not bypass hid_hw_raw_request

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure __hid_request reserves the report ID as the first byte

Benjamin Tissoires <bentiss@kernel.org>
    HID: core: ensure the allocated report buffer can contain the reserved report ID

Thomas Fourier <fourier.thomas@gmail.com>
    pch_uart: Fix dma_sync_sg_for_device() nents value

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - set correct controller type for Acer NGR200

Alok Tiwari <alok.a.tiwari@oracle.com>
    thunderbolt: Fix bit masking in tb_dp_port_set_hops()

Clément Le Goffic <clement.legoffic@foss.st.com>
    i2c: stm32: fix the device used for the DMA map

Xinyu Liu <1171169449@qq.com>
    usb: gadget: configfs: Fix OOB read on empty string write

Ryan Mann (NDI) <rmann@ndigital.com>
    USB: serial: ftdi_sio: add support for NDI EMGUIDE GEMINI

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W640

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 (ECM) composition

Wayne Chang <waynec@nvidia.com>
    phy: tegra: xusb: Fix unbalanced regulator disable in UTMI PHY mode


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |   1 +
 drivers/base/power/domain_governor.c             |  18 +-
 drivers/bluetooth/btusb.c                        |  78 ++++----
 drivers/comedi/comedi_fops.c                     |  30 +++-
 drivers/comedi/drivers.c                         |  17 +-
 drivers/comedi/drivers/aio_iiro_16.c             |   3 +-
 drivers/comedi/drivers/das16m1.c                 |   3 +-
 drivers/comedi/drivers/das6402.c                 |   3 +-
 drivers/comedi/drivers/pcl812.c                  |   3 +-
 drivers/dma/nbpfaxi.c                            |  11 +-
 drivers/hid/hid-core.c                           |  21 ++-
 drivers/hid/hid-mcp2221.c                        |   2 +-
 drivers/hwmon/corsair-cpro.c                     |   5 +
 drivers/i2c/busses/i2c-stm32.c                   |   8 +-
 drivers/i2c/busses/i2c-stm32f7.c                 |   4 +-
 drivers/iio/accel/fxls8962af-core.c              |   2 +
 drivers/iio/adc/max1363.c                        |  43 +++--
 drivers/iio/adc/stm32-adc-core.c                 |   7 +-
 drivers/input/joystick/xpad.c                    |   2 +-
 drivers/memstick/core/memstick.c                 |   2 +-
 drivers/mmc/host/bcm2835.c                       |   3 +-
 drivers/mmc/host/sdhci-pci-core.c                |   3 +-
 drivers/mmc/host/sdhci_am654.c                   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c   |   1 +
 drivers/net/ethernet/xilinx/xilinx_emaclite.c    |   2 +-
 drivers/net/usb/sierra_net.c                     |   4 +
 drivers/nvme/host/core.c                         |   4 +
 drivers/nvmem/u-boot-env.c                       |   2 +-
 drivers/phy/tegra/xusb-tegra186.c                |  61 ++++---
 drivers/soc/aspeed/aspeed-lpc-snoop.c            |  13 +-
 drivers/thunderbolt/switch.c                     |   2 +-
 drivers/tty/serial/pch_uart.c                    |   2 +-
 drivers/usb/core/hub.c                           |  36 +++-
 drivers/usb/core/hub.h                           |   1 +
 drivers/usb/dwc3/dwc3-qcom.c                     |   7 +-
 drivers/usb/gadget/configfs.c                    |   2 +
 drivers/usb/musb/musb_core.c                     |  62 +++----
 drivers/usb/musb/musb_core.h                     |  11 ++
 drivers/usb/musb/musb_debugfs.c                  |   6 +-
 drivers/usb/musb/musb_gadget.c                   |  30 ++--
 drivers/usb/musb/musb_host.c                     |   6 +-
 drivers/usb/musb/musb_virthub.c                  |  18 +-
 drivers/usb/serial/ftdi_sio.c                    |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                |   3 +
 drivers/usb/serial/option.c                      |   5 +
 fs/cachefiles/io.c                               |   2 -
 fs/cachefiles/ondemand.c                         |   4 +-
 fs/isofs/inode.c                                 |   9 +-
 fs/namespace.c                                   |   5 +
 fs/smb/client/file.c                             |  10 +-
 fs/smb/client/smb2ops.c                          |   7 +-
 include/net/netfilter/nf_conntrack.h             |  15 +-
 io_uring/net.c                                   |  12 +-
 io_uring/poll.c                                  |   2 -
 kernel/bpf/helpers.c                             |  11 +-
 kernel/cgroup/legacy_freezer.c                   |   8 +-
 kernel/sched/loadavg.c                           |   2 +-
 kernel/sched/sched.h                             |   2 +-
 kernel/trace/trace_events.c                      |   5 +
 mm/vmalloc.c                                     |  22 ++-
 net/8021q/vlan.c                                 |  42 ++++-
 net/8021q/vlan.h                                 |   1 +
 net/bluetooth/hci_event.c                        |  36 ----
 net/bluetooth/hci_sync.c                         | 217 ++++++++++++++---------
 net/bluetooth/l2cap_core.c                       |  26 ++-
 net/bluetooth/l2cap_sock.c                       |   3 +
 net/bluetooth/smp.c                              |  21 ++-
 net/bluetooth/smp.h                              |   1 +
 net/bridge/br_switchdev.c                        |   3 +
 net/ipv6/mcast.c                                 |   2 +-
 net/ipv6/rpl_iptunnel.c                          |   8 +-
 net/netfilter/nf_conntrack_core.c                |  26 ++-
 net/packet/af_packet.c                           |  27 ++-
 net/phonet/pep.c                                 |   2 +-
 net/sched/sch_htb.c                              |   4 +-
 net/sched/sch_qfq.c                              |  30 +++-
 net/tls/tls_strp.c                               |   3 +-
 sound/soc/fsl/fsl_sai.c                          |  14 +-
 tools/testing/selftests/net/udpgro.sh            |   8 +-
 81 files changed, 744 insertions(+), 420 deletions(-)


