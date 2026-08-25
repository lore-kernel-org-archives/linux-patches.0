Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514902E06E4;
	Tue, 25 Aug 2026 13:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666395; cv=none; b=ew65UZPfrMFs5HvjN5o6XIeB9E+rjn4MaW5Sdb4DYppykDD6ZsIIwcpRCTJ9PMWJB7PyDN7zfyV2/tse6JxUP2YeJRKX4PqKglkoM1N9RDfxl1HscCT4hoiEBUmHIFDTzR7fsl3QPPf9jCPSBLrSx+NlSLIC5Km/+rK7Kbahqwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666395; c=relaxed/simple;
	bh=q4YjtbkIqm2V1BXBvPkslJ2cMQvLBuN8N0FBg7rpZo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=shouLeaFjl/Hig5avOOrG9WlSNhM0HU7pHbm79JbnRgq9vJ9viW8IND/ZWS7aWxJlJ1brrP0wcLaFriaDXuxNgAA9PReyZHG7IaD/0Sp+d0c3OxsWlmC6facLu3WKNC/WzC0GOd1cQ5ZNwGLZa5Sd6QBo/11jegoViNhV+tJXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dd8IJxwx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dd8IJxwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9B11F000E9;
	Tue, 25 Aug 2026 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666393;
	bh=pOVglK1VSFvIg7JAfiqnAKd2BPmG87CJkIISCCR2gPQ=;
	h=From:To:Cc:Subject:Date;
	b=Dd8IJxwxoK/uL1W7oao4LH/3IMgQf9B6e+cSRdUSkriEFkxKw6ZWxV/f6Wj0I2oQZ
	 CQX4y2ZvXTSfb9hwRgXluklxTbnTy/rah5ahYhaG/71su2RuLNaYsPbYwsZwYtgcqi
	 QJn+9wrOfdjbjKTw2bHPUH7TOvCovAl3ReKpER20=
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
Subject: [PATCH 5.10 00/57] 5.10.267-rc1 review
Date: Tue, 25 Aug 2026 15:26:22 +0200
Message-ID: <20260825132541.342390421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.267-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.267-rc1
X-KernelTest-Deadline: 2026-08-27T13:25+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.267 release.
There are 57 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.267-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.267-rc1

Michael Bommarito <michael.bommarito@gmail.com>
    HID: hyperv: validate initial device info bounds

Haoxiang Li <haoxiang_li2024@163.com>
    HID: sensor: custom: Fix use-after-free in enable_sensor

Jann Horn <jannh@google.com>
    HID: core: fix number/pointer type confusion on long items

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix timer drain order, wakeup handling and tx_gen ordering

Oliver Hartkopp <socketcan@hartkopp.net>
    can: use skb hash instead of private variable in headroom

Weiming Shi <bestswngs@gmail.com>
    bpf: reject negative CO-RE accessor indices in bpf_core_parse_spec()

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Free all memory if cp_init() fails

Joanne Koong <joannelkoong@gmail.com>
    iomap: adjust read range correctly for non-block-aligned positions

Xiang Mei (Microsoft) <xmei5@asu.edu>
    xfrm: fix sk_dst_cache double-free in xfrm_user_policy()

Sasha Levin <sashal@kernel.org>
    Revert "Input: ims-pcu - fix race condition in reset_device sysfs callback"

Baul Lee <baul.lee@xbow.com>
    HID: core: fix OOB read of field->usage in hid_set_field()

Lee Jones <lee@kernel.org>
    HID: magicmouse: Prevent out-of-bounds (OOB) read during DOUBLE_REPORT_ID

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix OOB read in decode_watchers() via missing bounds check

Junjie Cao <junjie.cao@intel.com>
    gpio: ml-ioh: use raw_spinlock_t for the register lock

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nvmet-tcp: Do not WARN on remotely-controlled oversized SGL allocations

Jiang HongHui <jiang_hh2019@163.com>
    nvmet-fc: fix invalid free in LS IOD error path

Luxiao Xu <rakukuip@gmail.com>
    ipv6: fix use-after-free in ip6_finish_output2()

Yong Wang <edragain@163.com>
    ipv4: reject undersized MTUs in ip_do_fragment()

Ibrahim Hashimov <security@auditcode.ai>
    xfs: bounds-check buffer log item's dirty bitmap

Linmao Li <lilinmao@kylinos.cn>
    nfc: nci: free destination parameters when closing a connection

Samuel Page <sam@bynar.io>
    nfc: nci: fix out-of-bounds write in nci_target_auto_activated()

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: st21nfca: validate ATR_REQ length against the received frame

Xu Rao <raoxu@uniontech.com>
    nfc: pn533: purge fragmented skbs during cleanup

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: llcp: reject PDUs shorter than the LLCP header

Muhammad Bilal <meatuni001@gmail.com>
    nfc: llcp: fix OOB read and u8 offset wrap in TLV parsers

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: llcp: bound the connect_sn TLV walk to the skb

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: microread: validate target discovery payload lengths

Bryam Vargas <hexlabsecurity@proton.me>
    nfc: fdp: bound the device-reported read length and fix an skb leak

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: digital: clamp SENSF_RES length to the destination buffer

David Matlack <dmatlack@google.com>
    KVM: arm64: Retry fault if vma_lookup() results become invalid

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Cancel existing workqueues

Pei Xiao <xiaopei01@kylinos.cn>
    mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition

Long Li <leo.lilong@huawei.com>
    xfs: fix ilock leak on error in xfs_dq_get_next_id

Zhiling Zou <zhilinz@nebusec.ai>
    inet: frags: publish queues before arming timer

Zihan Xi <zihanx@nebusec.ai>
    packet: synchronize pressure clearing with ring reconfiguration

Zijie Huang <milkory@outlook.com>
    net/sched: reject overly deep qdisc hierarchies

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in TX_RING send path

Qihang Tang <q.h.hack.winter@gmail.com>
    packet: use consistent hard_header_len in non-ring send paths

Aditya Chillara <aditya.chillara@oss.qualcomm.com>
    perf/core: Fix group leader use-after-free after sibling detach

Yeoreum Yun <yeoreum.yun@arm.com>
    perf: Fix dangling cgroup pointer in cpuctx

Peter Zijlstra <peterz@infradead.org>
    perf: Fix cgroup state vs ERROR

Fan Wu <fanwu01@zju.edu.cn>
    serial: amba-pl011: synchronize DMA teardown

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_netdev: Preserve RX queue depth on allocation failure

Zihan Xi <zihanx@nebusec.ai>
    ipv4: Fix fib_nlmsg_size() for RTA_VIA nexthops

Amit Cohen <amcohen@nvidia.com>
    net: ipv4: Publish fib_nlmsg_size()

Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
    misc: fastrpc: Remove buffer from list prior to unmap operation

Abel Vesa <abel.vesa@linaro.org>
    misc: fastrpc: Rework fastrpc_req_munmap

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    misc: fastrpc: separate fastrpc device from channel context

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in WMM_param_handler()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: fix huge_zero_pfn race

Baul Lee <baul.lee@xbow.com>
    net/x25: fix use-after-free of the socket by its timers

Hongling Zeng <zenghongling@kylinos.cn>
    xfs: validate attr entry pointer before field access

Guanghui Yang <3497809730@qq.com>
    ext4: clear error before retrying inode xattr space fallback

Matthias Goergens <matthias.goergens@gmail.com>
    ext4: stop retrying saturated xattr cache entries

Ian Bridges <icb@fastmail.org>
    ocfs2: fix missing metadata reservation for large xattrs

Griffin Kroah-Hartman <griffin@kroah.com>
    rndis_host: add overflow check in rndis_rx_fixup()

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: RFCOMM: take rfcomm_mutex for the deferred setup accept


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/arm64/kvm/mmu.c                           |  42 ++--
 drivers/gpio/gpio-ml-ioh.c                     |  36 +--
 drivers/hid/hid-core.c                         |  11 +-
 drivers/hid/hid-hyperv.c                       |  27 ++-
 drivers/hid/hid-magicmouse.c                   |  16 ++
 drivers/hid/hid-sensor-custom.c                |  21 +-
 drivers/input/misc/ims-pcu.c                   |   2 -
 drivers/misc/fastrpc.c                         | 110 ++++++---
 drivers/mmc/host/atmel-mci.c                   |   2 +
 drivers/net/can/dev/dev.c                      |   2 -
 drivers/net/can/slcan.c                        |   1 -
 drivers/net/ntb_netdev.c                       |  15 +-
 drivers/net/usb/rndis_host.c                   |   6 +-
 drivers/nfc/fdp/i2c.c                          |  27 +++
 drivers/nfc/microread/microread.c              |  31 ++-
 drivers/nfc/pn533/pn533.c                      |   1 +
 drivers/nfc/st21nfca/dep.c                     |   3 +
 drivers/nvme/target/fc.c                       |   2 +-
 drivers/nvme/target/tcp.c                      |   5 +-
 drivers/s390/cio/vfio_ccw_cp.c                 |  22 +-
 drivers/s390/cio/vfio_ccw_drv.c                |   7 +
 drivers/s390/cio/vfio_ccw_ops.c                |   8 +
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |   3 +
 drivers/tty/serial/amba-pl011.c                |   8 +-
 fs/ext4/xattr.c                                |   7 +-
 fs/iomap/buffered-io.c                         |  19 +-
 fs/ocfs2/xattr.c                               |  18 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                  |  14 ++
 fs/xfs/xfs_buf_item_recover.c                  |  53 ++--
 fs/xfs/xfs_dquot.c                             |   3 +-
 include/linux/can/core.h                       |   1 +
 include/linux/can/dev.h                        |   1 -
 include/linux/can/skb.h                        |   2 -
 include/linux/netdevice.h                      |   6 +-
 include/net/sch_generic.h                      |   1 +
 kernel/events/core.c                           | 104 ++++----
 mm/huge_memory.c                               |  52 ++--
 net/bluetooth/rfcomm/core.c                    |  24 +-
 net/can/af_can.c                               |  14 +-
 net/can/bcm.c                                  |   2 -
 net/can/isotp.c                                | 320 ++++++++++++++++++-------
 net/can/j1939/socket.c                         |   1 -
 net/can/j1939/transport.c                      |   2 -
 net/can/raw.c                                  |   7 +-
 net/ceph/osd_client.c                          |   5 +-
 net/ipv4/fib_lookup.h                          |   1 +
 net/ipv4/fib_semantics.c                       |  69 ++++--
 net/ipv4/inet_fragment.c                       |   6 +-
 net/ipv4/ip_output.c                           |   4 +
 net/ipv6/ip6_output.c                          |   2 +
 net/nfc/digital_technology.c                   |   2 +
 net/nfc/llcp_commands.c                        |  18 +-
 net/nfc/llcp_core.c                            |  15 +-
 net/nfc/nci/ntf.c                              |   6 +
 net/nfc/nci/rsp.c                              |   1 +
 net/packet/af_packet.c                         |  65 +++--
 net/sched/sch_api.c                            |   9 +
 net/x25/af_x25.c                               |   4 +-
 net/x25/x25_timer.c                            |  25 +-
 net/xfrm/xfrm_state.c                          |   4 +-
 tools/lib/bpf/libbpf.c                         |   2 +
 62 files changed, 909 insertions(+), 392 deletions(-)


