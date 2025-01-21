Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EC01F5421;
	Tue, 21 Jan 2025 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482076; cv=none; b=KQiJQtXpT0JVxKpX53DnbVZVzWqYVgxQwS59jd7uw5pDjp2YE8+RHF/MSvF12BruDTl469lfy7iqDSjEiShTsdJ8Xs7+irhVV9u6nSLQ6ELMPcViwUF/tZwQFOM9/EAwJBjsMLMs/ul3oEDy7Fn9LSdJVBdqjMYWVbR+Jrb0jng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482076; c=relaxed/simple;
	bh=i3XiBzXqYPyay//IXM9fBOksdcSXoSBwETeZ/Hf1nlw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HqJ1qqkwifHsDND0uvixTx1QUSZSYHqGAmVytqizrO2srtR42OCCAOjRc4IcmucK+L5l/vtbm8PzA+EQF8s8YyCLGEFX671ovM1qqzXdtRoAHZwCXVYFEUQupOAqlrm+1raqlOSdOi9pzgCS05/id28bMhruLLRTZI78hokxclQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLjABGpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLjABGpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43670C4CEDF;
	Tue, 21 Jan 2025 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482075;
	bh=i3XiBzXqYPyay//IXM9fBOksdcSXoSBwETeZ/Hf1nlw=;
	h=From:To:Cc:Subject:Date:From;
	b=qLjABGptLb0WIPh+kTK8EVHw595dP3JlKZhj9NOrjtaeUWlXTVzWwkjupL5qncJE3
	 R0/aEd9w3i9ZEHKwgnR/He8pfFAC8v2ztfYdAljrmawg+JCUPoAhLS8ttld5ViTTkh
	 lu8uaVwCQUsVE85PoJIC0Z+xJaZecOYKFUmcKf9Y=
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
Subject: [PATCH 6.6 00/72] 6.6.74-rc1 review
Date: Tue, 21 Jan 2025 18:51:26 +0100
Message-ID: <20250121174523.429119852@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.74-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.74-rc1
X-KernelTest-Deadline: 2025-01-23T17:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.74 release.
There are 72 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.74-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.74-rc1

Wang Liang <wangliang74@huawei.com>
    net: fix data-races around sk->sk_forward_alloc

Juergen Gross <jgross@suse.com>
    x86/xen: fix SLS mitigation in xen_hypercall_iret()

Youzhong Yang <youzhong@gmail.com>
    nfsd: add list_head nf_gc to struct nfsd_file

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/amdgpu: rework resume handling for display (v2)"

Amir Goldstein <amir73il@gmail.com>
    fs: relax assertions on failure to encode file handles

Amir Goldstein <amir73il@gmail.com>
    ovl: support encoding fid from inode with no alias

Amir Goldstein <amir73il@gmail.com>
    ovl: pass realinode to ovl_encode_real_fh() instead of realdentry

Mohammed Anees <pvmohammedanees2003@gmail.com>
    ocfs2: fix deadlock in ocfs2_get_system_file_inode

Yu Kuai <yukuai3@huawei.com>
    block: fix uaf for flush rq while iterating tags

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix out-of-bounds access in 'dcn21_link_encoder_create'

Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
    iio: imu: inv_icm42600: fix spi burst write not supported

Terry Tritton <terry.tritton@linaro.org>
    Revert "PCI: Use preserve_config in place of pci_flags"

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always sync the GFX pipe on ctx switch

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/fb: Relax clear color alignment to 64 bytes

Koichiro Den <koichiro.den@canonical.com>
    hrtimers: Handle CPU state correctly on hotplug

Tomas Krcka <krckatom@amazon.de>
    irqchip/gic-v3-its: Don't enable interrupts in its_irq_set_vcpu_affinity()

Yogesh Lal <quic_ylal@quicinc.com>
    irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    irqchip: Plug a OF node reference leak in platform_irqchip_probe()

Xiaolei Wang <xiaolei.wang@windriver.com>
    pmdomain: imx8mp-blk-ctrl: add missing loop break condition

Sean Anderson <sean.anderson@linux.dev>
    gpio: xilinx: Convert gpio_lock to raw spinlock

Rik van Riel <riel@surriel.com>
    fs/proc: fix softlockup in __read_vmcore (part 2)

Marco Nelissen <marco.nelissen@gmail.com>
    filemap: avoid truncating 64-bit offset to 32 bits

Dave Airlie <airlied@redhat.com>
    nouveau/fence: handle cross device fences properly

Stefano Garzarella <sgarzare@redhat.com>
    vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]

Stefano Garzarella <sgarzare@redhat.com>
    vsock: reset socket state when de-assigning the transport

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: cancel close work in the destructor

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: discard packets if the transport changes

Stefano Garzarella <sgarzare@redhat.com>
    vsock/bpf: return early if transport is not assigned

Heiner Kallweit <hkallweit1@gmail.com>
    net: ethernet: xgbe: re-add aneg to supported features in PHY quirks

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: avoid spurious errors on disconnect

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix spurious wake-up on under memory pressure

Paolo Abeni <pabeni@redhat.com>
    mptcp: be sure to send ack when mptcp-level window re-opens

Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
    i2c: atr: Fix client detach

Kairui Song <kasong@tencent.com>
    zram: fix potential UAF of zram table

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda/realtek: Add support for Ayaneo System using CS35L41 HDA

Juergen Gross <jgross@suse.com>
    x86/asm: Make serialize() always_inline

Luis Chamberlain <mcgrof@kernel.org>
    nvmet: propagate npwg topology

Hongguang Gao <hongguang.gao@broadcom.com>
    RDMA/bnxt_re: Fix to export port num to ib_query_qp

Oleg Nesterov <oleg@redhat.com>
    poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()

Marco Nelissen <marco.nelissen@gmail.com>
    iomap: avoid avoid truncating 64-bit offset to 32 bits

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: acpi_dev_irq_override(): Check DMI match last

Jakub Kicinski <kuba@kernel.org>
    selftests: tc-testing: reduce rshift value

Manivannan Sadhasivam <mani@kernel.org>
    scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers

Max Kellermann <max.kellermann@ionos.com>
    cachefiles: Parse the "secctx" immediately

David Howells <dhowells@redhat.com>
    kheaders: Ignore silly-rename files

Zhang Kunbo <zhangkunbo@huawei.com>
    fs: fix missing declaration of init_files

Leo Stone <leocstone@gmail.com>
    hfs: Sanity check the root record

Lizhi Xu <lizhi.xu@windriver.com>
    mac802154: check local interfaces before deleting sdata list

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix double free of TCP_Server_Info::hostname

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: fix NACK handling when being a target

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mux: demux-pinctrl: check initial mux selection, too

Pratyush Yadav <pratyush@kernel.org>
    Revert "mtd: spi-nor: core: replace dummy buswidth from addr to data"

David Lechner <dlechner@baylibre.com>
    hwmon: (tmp513) Fix division of negative numbers

MD Danish Anwar <danishanwar@ti.com>
    soc: ti: pruss: Fix pruss APIs

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Ensure job pointer is set to NULL after job completion

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Add new keep_resv BO param

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Always start IPsec sequence number from 1

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Rely on reqid in IPsec tunnel mode

Leon Romanovsky <leon@kernel.org>
    net/mlx5e: Fix inversion dependency warning while enabling IPsec tunnel

Mark Zhang <markzhang@nvidia.com>
    net/mlx5: Clear port select structure when fail to create

Patrisious Haddad <phaddad@nvidia.com>
    net/mlx5: Fix RDMA TX steering prio

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    net: fec: handle page_pool_dev_alloc_pages error

Sean Anderson <sean.anderson@linux.dev>
    net: xilinx: axienet: Fix IRQ coalescing packet count overflow

Dan Carpenter <dan.carpenter@linaro.org>
    nfp: bpf: prevent integer overflow in nfp_bpf_event_output()

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Destroy device along with udp socket's netns dismantle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    gtp: Use for_each_netdev_rcu() in gtp_genl_dump_pdp().

Eric Dumazet <edumazet@google.com>
    gtp: use exit_batch_rtnl() method

Eric Dumazet <edumazet@google.com>
    net: add exit_batch_rtnl() method

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    pktgen: Avoid out-of-bounds access in get_imix_entries

Ilya Maximets <i.maximets@ovn.org>
    openvswitch: fix lockup on tx to unregistering netdev with carrier

Michal Luczaj <mhal@rbox.co>
    bpf: Fix bpf_sk_select_reuseport() memory leak

Sudheer Kumar Doredla <s-doredla@ti.com>
    net: ethernet: ti: cpsw_ale: Fix cpsw_ale_get_field()


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/x86/include/asm/special_insns.h               |  2 +-
 arch/x86/xen/xen-asm.S                             |  2 +-
 block/blk-sysfs.c                                  |  6 +--
 block/genhd.c                                      |  9 ++--
 drivers/acpi/resource.c                            |  6 +--
 drivers/block/zram/zram_drv.c                      |  1 +
 drivers/gpio/gpio-xilinx.c                         | 32 +++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         | 45 +-------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c             |  4 +-
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |  2 +-
 drivers/gpu/drm/i915/display/intel_fb.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c            |  6 ++-
 drivers/gpu/drm/v3d/v3d_irq.c                      |  4 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.h                 |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |  7 +---
 drivers/gpu/drm/vmwgfx/vmwgfx_gem.c                |  1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  7 +---
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_buffer.c         |  5 +--
 drivers/hwmon/tmp513.c                             |  7 ++--
 drivers/i2c/busses/i2c-rcar.c                      | 20 ++++++---
 drivers/i2c/i2c-atr.c                              |  2 +-
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |  4 +-
 drivers/iio/imu/inv_icm42600/inv_icm42600.h        |  1 +
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c   | 11 +++++
 drivers/iio/imu/inv_icm42600/inv_icm42600_spi.c    |  3 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  1 +
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |  4 ++
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  1 +
 drivers/infiniband/hw/bnxt_re/qplib_fp.h           |  1 +
 drivers/irqchip/irq-gic-v3-its.c                   |  2 +-
 drivers/irqchip/irq-gic-v3.c                       |  2 +-
 drivers/irqchip/irqchip.c                          |  4 +-
 drivers/mtd/spi-nor/core.c                         |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        | 19 +--------
 drivers/net/ethernet/freescale/fec_main.c          | 19 ++++++---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 22 +++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         | 12 +++---
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    | 11 +++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 +
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |  4 +-
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |  3 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 | 14 +++----
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  6 +++
 drivers/net/gtp.c                                  | 42 +++++++++++--------
 drivers/nvme/target/io-cmd-bdev.c                  |  2 +-
 drivers/pci/controller/pci-host-common.c           |  4 ++
 drivers/pci/probe.c                                | 20 +++++----
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c             |  2 +-
 drivers/ufs/core/ufshcd.c                          |  9 ++--
 fs/cachefiles/daemon.c                             | 14 +++----
 fs/cachefiles/internal.h                           |  3 +-
 fs/cachefiles/security.c                           |  6 +--
 fs/file.c                                          |  1 +
 fs/hfs/super.c                                     |  4 +-
 fs/iomap/buffered-io.c                             |  2 +-
 fs/nfsd/filecache.c                                | 18 ++++----
 fs/nfsd/filecache.h                                |  1 +
 fs/notify/fdinfo.c                                 |  4 +-
 fs/ocfs2/extent_map.c                              |  8 +++-
 fs/overlayfs/copy_up.c                             | 16 +++----
 fs/overlayfs/export.c                              | 49 ++++++++++++----------
 fs/overlayfs/namei.c                               |  4 +-
 fs/overlayfs/overlayfs.h                           |  2 +-
 fs/proc/vmcore.c                                   |  2 +
 fs/smb/client/connect.c                            |  3 +-
 include/linux/hrtimer.h                            |  1 +
 include/linux/poll.h                               | 10 ++++-
 include/linux/pruss_driver.h                       | 12 +++---
 include/net/net_namespace.h                        |  3 ++
 kernel/cpu.c                                       |  2 +-
 kernel/gen_kheaders.sh                             |  1 +
 kernel/time/hrtimer.c                              | 11 ++++-
 mm/filemap.c                                       |  2 +-
 net/core/filter.c                                  | 30 +++++++------
 net/core/net_namespace.c                           | 31 +++++++++++++-
 net/core/pktgen.c                                  |  6 +--
 net/dccp/ipv6.c                                    |  2 +-
 net/ipv6/tcp_ipv6.c                                |  4 +-
 net/mac802154/iface.c                              |  4 ++
 net/mptcp/options.c                                |  6 ++-
 net/mptcp/protocol.h                               |  9 +++-
 net/openvswitch/actions.c                          |  4 +-
 net/vmw_vsock/af_vsock.c                           | 18 ++++++++
 net/vmw_vsock/virtio_transport_common.c            | 38 ++++++++++++-----
 net/vmw_vsock/vsock_bpf.c                          |  9 ++++
 sound/pci/hda/patch_realtek.c                      |  1 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  | 43 ++++++++++++++-----
 .../tc-testing/tc-tests/filters/flow.json          |  4 +-
 90 files changed, 479 insertions(+), 315 deletions(-)


