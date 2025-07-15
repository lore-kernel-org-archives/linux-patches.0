Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06501275103;
	Tue, 15 Jul 2025 16:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752597417; cv=none; b=ffdwBJNGNM1K7XapSVnBtK+lXVetMCZ+CQrqM7t9wivyu7FNrxiqXv9lfErfZBaKmu3nrNq/DLzHHeUAxUiXQjN/J8shzLUvHkdlqfLp/lqnqsDCJe9BRLjrrhEL8PskKP/qZ0k4lA65gpEoxyYOQJSb15agDRzhfrGvTIXLXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752597417; c=relaxed/simple;
	bh=eNzekVtqx3kX6q2dEdfEsrA2xMpV5qJh/TE/bnyegsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gQjpLg9Cmex2CJKUxyecp8kSfODoOh8TweOUgHvnm+hMAyTZplfVrvxoiFYdj4BMTZJuwFNmEslZhfS/r9f2kvt8pU/nYhFGSEQ65o7c1DG4kDAGNE8Iv/vax+3/I5mBqnMlwzN9/dnCXAas+bnsuOX9iajmuVNTUU0Y1QdKdKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkaQePG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkaQePG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8DC4CEF1;
	Tue, 15 Jul 2025 16:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752597416;
	bh=eNzekVtqx3kX6q2dEdfEsrA2xMpV5qJh/TE/bnyegsY=;
	h=From:To:Cc:Subject:Date:From;
	b=EkaQePG2VeN0qhhN8OtwdHogx4l8OZOFQFbIjyYK6U0u7HPBAhRoecUqjM3IS7a9m
	 VNGKxnjPk/dbI9pTR0AZhOl6I2efmNxbRAszoOIMctaDiXdshx++h16CbbAmw4Oy/D
	 NdGYaND31nePWFTJi8Vw+xJ4Z4dfobsxCqQskinE=
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
Subject: [PATCH 5.15 00/78] 5.15.189-rc2 review
Date: Tue, 15 Jul 2025 18:36:53 +0200
Message-ID: <20250715163547.992191430@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.189-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.189-rc2
X-KernelTest-Deadline: 2025-07-17T16:35+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.189 release.
There are 78 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 17 Jul 2025 16:35:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.189-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.189-rc2

Michael Jeanson <mjeanson@efficios.com>
    rseq: Fix segfault on registration when rseq_cs is non-zero

Jack Wang <jinpu.wang@ionos.com>
    x86: Fix X86_FEATURE_VERW_CLEAR definition

Jann Horn <jannh@google.com>
    x86/mm: Disable hugetlb page table sharing on 32-bit

Dongli Zhang <dongli.zhang@oracle.com>
    vhost-scsi: protect vq->log_used with vq->mutex

Hans de Goede <hdegoede@redhat.com>
    Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras

Zhang Heng <zhangheng@kylinos.cn>
    HID: Add IGNORE quirk for SMARTLINKTECHNOLOGY

Nicolas Pitre <npitre@baylibre.com>
    vt: add missing notification when switching back to text mode

Akira Inoue <niyarium@gmail.com>
    HID: lenovo: Add support for ThinkPad X1 Tablet Thin Keyboard Gen2

Xiaowei Li <xiaowei.li@simcom.com>
    net: usb: qmi_wwan: add SIMCom 8230C composition

Tiwei Bie <tiwei.btw@antgroup.com>
    um: vector: Reduce stack usage in vector_eth_configure()

Thomas Fourier <fourier.thomas@gmail.com>
    atm: idt77252: Add missing `dma_map_error()`

Somnath Kotur <somnath.kotur@broadcom.com>
    bnxt_en: Set DMA unmap len correctly for XDP_REDIRECT

Shravya KN <shravya.k-n@broadcom.com>
    bnxt_en: Fix DCB ETS validation

Alok Tiwari <alok.a.tiwari@oracle.com>
    net: ll_temac: Fix missing tx_pending check in ethtools_set_ringparam()

Sean Nyekjaer <sean@geanix.com>
    can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: microchip: limit 100M workaround to link-down events on LAN88xx

Kito Xu <veritas501@foxmail.com>
    net: appletalk: Fix device refcount leak in atrtr_create()

Eric Dumazet <edumazet@google.com>
    netfilter: flowtable: account for Ethernet header in nf_flow_pppoe_proto()

Al Viro <viro@zeniv.linux.org.uk>
    ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()

Stefan Metzmacher <metze@samba.org>
    smb: server: make use of rdma_destroy_qp()

Zheng Qixing <zhengqixing@huawei.com>
    nbd: fix uaf in nbd_genl_connect() error path

Nigel Croxon <ncroxon@redhat.com>
    raid10: cleanup memleak at raid10_make_request

Wang Jinchao <wangjinchao600@gmail.com>
    md/raid1: Fix stack memory use after return in raid1_reshape

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: zd1211rw: Fix potential NULL pointer dereference in zd_mac_tx_to_dev()

Kurt Borja <kuurtb@gmail.com>
    platform/x86: think-lmi: Fix sysfs group cleanup

Christian König <christian.koenig@amd.com>
    dma-buf: fix timeout handling in dma_resv_wait_timeout v2

Christian König <christian.koenig@amd.com>
    dma-buf: use new iterator in dma_resv_wait_timeout

Christian König <christian.koenig@amd.com>
    dma-buf: add dma_resv_for_each_fence_unlocked v8

Kuen-Han Tsai <khtsai@google.com>
    usb: dwc3: Abort suspend on soft disconnect failure

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with CV Bad Descriptor test

Lee Jones <lee@kernel.org>
    usb: cdnsp: Replace snprintf() with the safer scnprintf() variant

Pawel Laszczak <pawell@cadence.com>
    usb:cdnsp: remove TRB_FLUSH_ENDPOINT command

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - support Acer NGR 200 Controller

Hongyu Xie <xiehongyu1@kylinos.cn>
    xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS

Raju Rangoju <Raju.Rangoju@amd.com>
    usb: xhci: quirk for data loss in ISOC transfers

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    xhci: Allow RPM on the USB controller (1022:43f7) by default

Bui Quang Minh <minhquangbui99@gmail.com>
    virtio-net: ensure the received length does not exceed allocated size

Jakub Kicinski <kuba@kernel.org>
    netlink: make sure we allow at least one dump skb

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix rmem check in netlink_broadcast_deliver().

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: mediatek: Ensure to disable clocks in error path

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback for MPV device

Filipe Manana <fdmanana@suse.com>
    btrfs: use btrfs_record_snapshot_destroy() during rmdir

Filipe Manana <fdmanana@suse.com>
    btrfs: propagate last_unlink_trans earlier when doing a rmdir

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: battery: negate current when discharging"

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_serial: Fix race condition in TTY wakeup

Simona Vetter <simona.vetter@ffwll.ch>
    drm/gem: Fix race in drm_gem_handle_create_tail()

Matthew Brost <matthew.brost@intel.com>
    drm/sched: Increment job count before swapping tail spsc queue

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: qcom: msm: mark certain pins as invalid for interrupts

Guillaume Nault <gnault@redhat.com>
    gre: Fix IPv6 multicast route creation.

JP Kobryn <inwardvessel@gmail.com>
    x86/mce: Make sure CMCI banks are cleared during shutdown on Intel

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce: Don't remove sysfs if thresholding sysfs init fails

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/mce/amd: Fix threshold limit reset

Juergen Gross <jgross@suse.com>
    xen: replace xen_remap() with memremap()

Edward Adam Davis <eadavis@qq.com>
    jfs: fix null ptr deref in dtInsertEntry

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: Fix skb refcnt race after locking changes

Maksim Kiselev <bigunclemax@gmail.com>
    aoe: avoid potential deadlock at set_capacity

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    thermal/int340x_thermal: handle data_vault when the value is ZERO_SIZE_PTR

Andrii Nakryiko <andrii@kernel.org>
    bpf: fix precision backtracking instruction iteration

David Howells <dhowells@redhat.com>
    rxrpc: Fix oops due to non-existence of prealloc backlog struct

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ice: safer stats processing

Oleg Nesterov <oleg@redhat.com>
    fs/proc: do_task_stat: use __for_each_thread()

Victor Nogueira <victor@mojatatu.com>
    net/sched: Abort __tc_modify_qdisc if parent class does not exist

Yue Haibing <yuehaibing@huawei.com>
    atm: clip: Fix NULL pointer dereference in vcc_sendmsg()

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix infinite recursive call of clip_push().

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix memory leak of struct clip_vcc.

Kuniyuki Iwashima <kuniyu@google.com>
    atm: clip: Fix potential null-ptr-deref in to_atmarpd().

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: smsc: Fix link failure in forced mode with Auto-MDIX

Oleksij Rempel <linux@rempel-privat.de>
    net: phy: smsc: Fix Auto-MDIX configuration when disabled by strap

Michal Luczaj <mhal@rbox.co>
    vsock: Fix IOCTL_VM_SOCKETS_GET_LOCAL_CID to check also `transport_local`

Michal Luczaj <mhal@rbox.co>
    vsock: Fix transport_* TOCTOU

Michal Luczaj <mhal@rbox.co>
    vsock: Fix transport_{g2h,h2g} TOCTOU

Kuniyuki Iwashima <kuniyu@google.com>
    tipc: Fix use-after-free in tipc_conn_close().

Kuniyuki Iwashima <kuniyu@google.com>
    netlink: Fix wraparounds of sk->sk_rmem_alloc.

Al Viro <viro@zeniv.linux.org.uk>
    fix proc_sys_compare() handling of in-lookup dentries

Peter Zijlstra <peterz@infradead.org>
    perf: Revert to requiring CAP_SYS_ADMIN for uprobes

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode

Kaustabh Chakraborty <kauschluss@disroot.org>
    drm/exynos: exynos7_drm_decon: add vblank check in IRQ handling


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/um/drivers/vector_kern.c                      |  42 +--
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/include/asm/cpufeatures.h                 |   2 +-
 arch/x86/include/asm/xen/page.h                    |   3 -
 arch/x86/kernel/cpu/mce/amd.c                      |  15 +-
 arch/x86/kernel/cpu/mce/core.c                     |   8 +-
 arch/x86/kernel/cpu/mce/intel.c                    |   1 +
 drivers/acpi/battery.c                             |  19 +-
 drivers/atm/idt77252.c                             |   5 +
 drivers/block/aoe/aoeblk.c                         |   5 +-
 drivers/block/nbd.c                                |   6 +-
 drivers/dma-buf/dma-resv.c                         | 171 ++++++----
 drivers/gpu/drm/drm_gem.c                          |  10 +-
 drivers/gpu/drm/exynos/exynos7_drm_decon.c         |   4 +
 drivers/hid/hid-ids.h                              |   6 +
 drivers/hid/hid-lenovo.c                           |   8 +
 drivers/hid/hid-multitouch.c                       |   8 +-
 drivers/hid/hid-quirks.c                           |   3 +
 drivers/infiniband/hw/mlx5/main.c                  |  33 ++
 drivers/input/joystick/xpad.c                      |   2 +
 drivers/input/keyboard/atkbd.c                     |   3 +-
 drivers/md/raid1.c                                 |   1 +
 drivers/md/raid10.c                                |  10 +-
 drivers/net/can/m_can/m_can.c                      |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  29 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +-
 drivers/net/phy/microchip.c                        |   2 +-
 drivers/net/phy/smsc.c                             |  28 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |  44 ++-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   6 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |  20 ++
 drivers/platform/x86/think-lmi.c                   |  35 +-
 drivers/pwm/pwm-mediatek.c                         |  15 +-
 .../intel/int340x_thermal/int3400_thermal.c        |   9 +-
 drivers/tty/hvc/hvc_xen.c                          |   2 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/usb/cdns3/cdnsp-debug.h                    | 358 ++++++++++-----------
 drivers/usb/cdns3/cdnsp-ep0.c                      |  18 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |   6 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |  11 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |  27 +-
 drivers/usb/dwc3/core.c                            |   9 +-
 drivers/usb/dwc3/gadget.c                          |  22 +-
 drivers/usb/gadget/function/u_serial.c             |   6 +-
 drivers/usb/host/xhci-mem.c                        |   4 +
 drivers/usb/host/xhci-pci.c                        |  30 +-
 drivers/usb/host/xhci-plat.c                       |   3 +-
 drivers/usb/host/xhci.h                            |   1 +
 drivers/vhost/scsi.c                               |   7 +-
 drivers/xen/grant-table.c                          |   6 +-
 drivers/xen/xenbus/xenbus_probe.c                  |   3 +-
 fs/btrfs/inode.c                                   |  36 +--
 fs/jfs/jfs_dtree.c                                 |   2 +
 fs/ksmbd/transport_rdma.c                          |   5 +-
 fs/ksmbd/vfs.c                                     |   1 +
 fs/proc/array.c                                    |   6 +-
 fs/proc/inode.c                                    |   2 +-
 fs/proc/proc_sysctl.c                              |  18 +-
 include/drm/drm_file.h                             |   3 +
 include/drm/spsc_queue.h                           |   4 +-
 include/linux/dma-resv.h                           |  95 ++++++
 include/net/netfilter/nf_flow_table.h              |   2 +-
 include/xen/arm/page.h                             |   3 -
 kernel/bpf/verifier.c                              |  21 +-
 kernel/events/core.c                               |   2 +-
 kernel/rseq.c                                      |  60 +++-
 net/appletalk/ddp.c                                |   1 +
 net/atm/clip.c                                     |  64 +++-
 net/core/skmsg.c                                   |  12 +-
 net/ipv6/addrconf.c                                |   9 +-
 net/netlink/af_netlink.c                           |  90 +++---
 net/rxrpc/call_accept.c                            |   3 +
 net/sched/sch_api.c                                |  23 +-
 net/tipc/topsrv.c                                  |   2 +
 net/vmw_vsock/af_vsock.c                           |  57 +++-
 sound/soc/fsl/fsl_asrc.c                           |   3 +-
 80 files changed, 1030 insertions(+), 576 deletions(-)


