Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3330054655;
	Wed, 14 Oct 2026 12:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982339; cv=none; b=mChm84vMNsHjTLMyF9oNLyT/2wyq7ZzZ3ILSHnFAIZwls5KI5TBMbW8OVIhmICJbqTXURpueXZPj5uzsEoD6JKO05RQT/WRJI0jaf7mLjcFXbv5B1IpMuvqto2DJ9on7rMKNVtzo3oxfo+HzyZJuetunPuU9ov/CEbys/l9HO9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982339; c=relaxed/simple;
	bh=yjUKO1gIkuzHBIAC/AMvZqOAuXMDwWBhMDLn7tklHYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HHhU4AZjgC6r9VKEzfBj8/tUYmeYQ75axGOKNi4oWYtdjU2B4LOSisT0CClBPLsYMPcAP8LuknNKiuoDHaOQzbJfgAzFpeW1OPdSd9SdGDlBNkdRtBNle7u56W09y9RyeM9vxZZ+AFiimxHQOIx4PHP5ca49ON55QiDI20MHYKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMsUurTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMsUurTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355E21F0089D;
	Wed, 14 Oct 2026 12:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791982246;
	bh=9CUVLH34UOKDN3Gdm4hpMxDppSwAVjiGHO+652Kfk0U=;
	h=From:To:Cc:Subject:Date;
	b=YMsUurTWoFd5GbPKYZ9h4cK0ZPCtxf8dRzNoTwPJiMCSQT1NHv34hOg7bYDQtukb8
	 JfN3GWM2yxl1oCcUmQckQ1j7Xu9jgpAOjM3Pmfn4/eUY9adh5Xl2xWQ9WT1anN86mc
	 esms+9z2NjXIxFwr/Lx4q1oSesVGyzjNnQNw+rzg=
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
Subject: [PATCH 7.2 000/284] 7.2.11-rc2 review
Date: Wed, 14 Oct 2026 14:50:49 +0200
Message-ID: <20261014123758.782265692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.11-rc2
X-KernelTest-Deadline: 2026-10-16T12:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.11 release.
There are 284 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 16 Oct 2026 12:37:26 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.11-rc2

Vicki Pfau <vi@endrift.com>
    HID: steam: Clean up locking

Vicki Pfau <vi@endrift.com>
    HID: steam: Refactor registration

Vicki Pfau <vi@endrift.com>
    HID: steam: Rearrange teardown sequence

Vicki Pfau <vi@endrift.com>
    HID: steam: Fully unregister controller when hidraw is opened

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: don't charge provided buffer rings to RLIMIT_MEMLOCK

Hengyu Liang <hengyul@cs.unc.edu>
    io_uring: do not charge the SQ/CQ rings to RLIMIT_MEMLOCK

Ali Ahmet Memis <ali@iusegentoo.com>
    io_uring/memmap: account the pages a compound region really uses

Adrian Betschart <adrian.betschart@cinemaone.ch>
    drm/amd/display: Don't replace a sink mode that shares the native totals

Kuba Piecuch <jpiecuch@google.com>
    sched_ext: Call ops.dequeue() when a task arrives on a remote local DSQ

Kuba Piecuch <jpiecuch@google.com>
    sched_ext: Generate qseq from a per-task counter

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Fix binner slot allocation failing on an idle GPU

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Disable the V3D interrupt across runtime suspend

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    vsock: Fix memory leak in vmci_transport_recv_dgram_cb()

Fernando Fernandez Mancera <fmancera@suse.de>
    net: openvswitch: validate transport header presence in set_ipv6_addr

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: fix PCIe delay estimation calculation

Willem de Bruijn <willemb@google.com>
    net/packet: call packet_parse_headers after virtio_net_hdr_to_skb

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_flower: Fix port range register leak in tmplt_create()

Li RongQing <lirongqing@baidu.com>
    net/mlx5e: Order ICOSQ cc update after CQ doorbell

Tianyi Gao <tianyi@cloudflare.com>
    veth: fix peer NETDEV_XDP_ACT_NDO_XMIT after GRO is toggled while down

Gyeyoung Baek <gye976@gmail.com>
    drm/imagination: Fix reference and vm_bo handling in remap()

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    bareudp: set the inner protocol to the protocol of the packet

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Re-write the BARs following any type of PCIe errors

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix driver init in kdump kernel

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add bnxt_clear_bars() helper

Zongmin Zhou <zhouzongmin@kylinos.cn>
    riscv: ptrace: Zero-initialize regset buffers before copyin

Leo Yu-Chi Liang <leo.liang@sifive.com>
    riscv: fix NR_CPUS range leaking 64-bit default onto 32-bit builds

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: sdw_utils: Switch CS35L56/57/62/63 to use OT25 DAI

Stefan Binding <sbinding@opensource.cirrus.com>
    ASoC: sdw_utils: Add codec info for CS35L62

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    pfcp: make sure the SEID is linear before reading it

Justin Chen <justin.chen@broadcom.com>
    net: bcmgenet: if UMAC was suspended in SW_RESET, restore it to SW_RESET

Or Har-Toov <ohartoov@nvidia.com>
    Revert "net/mlx5: E-Switch, preserve max tx speed on vport state modification"

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: reject change with no routing attribute

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    devlink: fix devlink_rel reference leak when notify work is pending

Quentin Freimanis <quentin@q-lab.dev>
    net: sparx5: start the TOD counters on non-PTP lan969x variants

Eric Dumazet <edumazet@kernel.org>
    net: always dissect GSO packets in __virtio_net_hdr_to_skb()

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of skb->len when computing thoff

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()

Han Gao <gaohan@iscas.ac.cn>
    spi: sg2044-nor: Honor SPI clock limits

Han Gao <gaohan@iscas.ac.cn>
    spi: sg2044-nor: Return transfer errors

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: allow sleepy powerdown GPIOs

Yingying Tang <yingying.tang@oss.qualcomm.com>
    Revert "wifi: ath12k: add panic handler"

Mallesh Koujalagi <mallesh.koujalagi@intel.com>
    drm/xe/sysctrl: Fix mailbox header handling

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt792x: pick the SAR table layout from the table itself

Junjie Cao <junjie.cao@intel.com>
    wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7925: don't put the band auto marker in TGID

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mt76: mt7915: disable rx napi when removing device

Tao Gong <gongtao0607@gmail.com>
    wifi: mt76: mt7996: fix struct mt7996_mcu_wed_rro_ba_delete_event layout

Aaron Ma <aaron.ma@canonical.com>
    wifi: mt76: mt7925: restore the legacy BSS after MLO teardown

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: use ALTX queue for packets to disassociated stations

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: account non-AQL frames per peer rather than per link

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: add PS buffering support for HW-managed TIM drivers

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: add ieee80211_txq_aql_pending()

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: add AQL support for multicast packets

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: take over connection monitoring

Pengpeng Hou <hppiscas@163.com>
    scsi: ufs: mediatek: Handle mPHY power-on failures

Jakub Kicinski <kuba@kernel.org>
    Revert "net: stmmac: propagate PTP addend and system time programming errors"

Aurelien Jarno <aurelien@aurel32.net>
    riscv: vector: Fix output operands in context save

Troy Mitchell <troy.mitchell@linux.dev>
    riscv: vector: Fix data pointer constraints in context save/restore

Leto Liu (刘涛) <Leto.Liu@airoha.com>
    net: airoha: Add retry mechanism to airoha_qdma_set_trtcm_param()

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: stmmac: Disable S-Tag processing on dwmac4

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: stmmac: Do not advertise S-VLAN stripping when it is disabled

Or Har-Toov <ohartoov@nvidia.com>
    net/mlx5: Lag, split aggregate speed into oper and max helpers

Jakub Kicinski <kuba@kernel.org>
    net: make dev_xdp_sb_prog_count() see programs attached through a link

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/xe: Do not emit Wa_16010904313 twice

Alan Previn <alan.previn.teres.alexis@intel.com>
    drm/xe/mmio: Fix xe_mmio_wait32() to honor delay/sleep maximums

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error return value in btrfs_listxattr()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix xattr replace when multiple xattrs are packed in the same item

Yang Xiuwei <yangxiuwei@kylinos.cn>
    btrfs: don't stash io_uring encoded data across -EAGAIN

Yang Xiuwei <yangxiuwei@kylinos.cn>
    btrfs: unlock inode and extent in caller when io_uring read extent fails

Yang Xiuwei <yangxiuwei@kylinos.cn>
    btrfs: free iov when btrfs_uring_read_extent() fails

Yang Xiuwei <yangxiuwei@kylinos.cn>
    btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    zloop: zero out only the unread tail of short reads

Haibo Chen <haibo.chen@nxp.com>
    spi: spi-nxp-fspi: exit stop mode before waiting for DLL lock

Fuad Tabba <fuad.tabba@linux.dev>
    arm64/boot: Don't set PMUv3p9 FGT2 bits without PMUv3

Sang-Hoon Choi <csh0052@gmail.com>
    nvmet: use the local P2P device on metadata allocation failure

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: return Invalid Field for invalid NSIDs feature 82h

Bryan Fraschetti <bryan.fraschetti@canonical.com>
    ice: Restore Ordered MMIO Writes for Tx Doorbells

Jakub Kicinski <kuba@kernel.org>
    bonding: fix the program leak when XDP is replaced

Mahantesh Salimath <mahantesh@nvidia.com>
    tee: optee: ffa: support shared memory offsets on large-page kernels

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: propagate PTP addend and system time programming errors

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: program a link again if the driver holds it

Sang-Hoon Choi <csh0052@gmail.com>
    cxgb4/ch_ktls: disable softirqs around tid_list erases

Shashank Mohan Jain <jain.sm@gmail.com>
    lib/dim: fix 32-bit overflow in dim_calc_stats() rates

Omar Ramadan <omar@blockcast.net>
    amt: send the relay's General Query directly from the receive path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: em_text: reject unterminated algo before autoload

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Use kvmalloc_objs() for the BO cache size list

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Free the BO cache size list on teardown

Myeonghun Pak <mhun512@gmail.com>
    drm/aspeed: Balance the display clock enable on teardown

Sang-Hoon Choi <csh0052@gmail.com>
    gpio: exar: initialize the ID before registering its cleanup

Oleg Keri <okerixx@gmail.com>
    drm/dp: don't mark the AUX backlight enabled when enabling failed

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Don't access cpuset_cgrp_subsys.root in is_in_v2_mode()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/bridge: Fix unlocked list access in drm_bridge_attach()

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/bridge: Fix unlocked list_del in drm_bridge_add()

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel_pcie: Add shared HW reset for clean start

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: fix TX descriptor bounds check

Naomi Chu <naomi.chu@mediatek.com>
    scsi: ufs: core: Hold a clock reference across the probe

Christian Brauner <brauner@kernel.org>
    fs: don't let a migrating task hide its reference from do_umount()

Christian Brauner <brauner@kernel.org>
    mount: refuse MOVE_MOUNT_SET_GROUP on an unbindable mount

Peng Fan <peng.fan@nxp.com>
    iommu/dma: skip swiotlb bounce for DMA_ATTR_MMIO in iommu_dma_map_phys

Vincent Jardin <vjardin@free.fr>
    arm64: dts: lx2160a: fix the iic5 spi3 pinmux offset and value

Vincent Jardin <vjardin@free.fr>
    arm64: dts: lx2160a: fix IIC1 pinmux submask rejected by pinctrl-single

Vincent Jardin <vjardin@free.fr>
    arm64: dts: lx2160a: fix incorrect pinmux

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gpucc-kaanapali: Mark the GPU CX GDSC as votable

Taniya Das <taniya.das@oss.qualcomm.com>
    clk: qcom: gpucc-glymur: Mark the GPU CX GDSC as votable

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-kaanapali: Fix always-enabling PCIE_RSCC clocks

Luca Weiss <luca.weiss@fairphone.com>
    clk: qcom: gcc-eliza: Fix always-enabling PCIE_RSCC clocks

Darrick J. Wong <djwong@kernel.org>
    xfs: fix exchange-range-to-eof file size exchange

Norbert Szetei <norbert@doyensec.com>
    xfs: stop exchanging reflink flags when exchanging mappings

Christian Brauner <brauner@kernel.org>
    namespace: keep the lock on a mount that a propagated copy is moved beneath

Christian Brauner <brauner@kernel.org>
    namespace: handle mount locking for automounts correctly

Christian Brauner <brauner@kernel.org>
    namespace: never expire a locked mount

Christian Brauner <brauner@kernel.org>
    nullfs: don't update the access time

Christian Brauner <brauner@kernel.org>
    namespace: refuse an automount below a mount that is in no namespace

Christian Brauner <brauner@kernel.org>
    fcntl: refuse F_SET_RW_HINT on an immutable inode

Christian Brauner <brauner@kernel.org>
    namei: don't reveal overmounted entries in refwalk

Christian Brauner <brauner@kernel.org>
    namespace: unhash a dentry before detaching the mounts on it

Christian Brauner <brauner@kernel.org>
    namespace: don't let a pseudo dentry become the root of a mount

Christian Brauner <brauner@kernel.org>
    unshare: don't drop active namespace references that were never taken

Christian Brauner <brauner@kernel.org>
    dcache: don't put a mountpoint on a dentry that's being removed

Christian Brauner <brauner@kernel.org>
    namespace: check the mounts before reading their parents in pivot_root()

Christian Brauner <brauner@kernel.org>
    namespace: remove the fsnotify marks of a mount namespace in process context

Christian Brauner <brauner@kernel.org>
    namespace: don't reconfigure internal superblocks via remount and umount

Christian Brauner <brauner@kernel.org>
    namespace: look at the topmost mount for a mount namespace file

Christian Brauner <brauner@kernel.org>
    namespace: keep covered mounts covered in OPEN_TREE_NAMESPACE

Christian Brauner <brauner@kernel.org>
    namespace: check a recursive bind mount for mount namespace loops

Christian Brauner <brauner@kernel.org>
    namespace: check a submount for references right before unmounting it

Christian Brauner <brauner@kernel.org>
    namespace: queue a mount only once for mount notifications

Christian Brauner <brauner@kernel.org>
    namespace: check the target before walking it in do_mount_setattr()

Christian Brauner <brauner@kernel.org>
    fs: refuse fspick() on internal superblocks

Christian Brauner <brauner@kernel.org>
    namespace: don't copy an unmounted mount tree

Christian Brauner <brauner@kernel.org>
    namespace: don't inherit MNT_UMOUNT in clone_mnt()

Christian Brauner <brauner@kernel.org>
    statmount: read the parent of an unmounted mount under mount_lock

Christian Brauner <brauner@kernel.org>
    namespace: reset the old parent's ->overmount in mnt_change_mountpoint()

Christian Brauner <brauner@kernel.org>
    fs: don't silently unmount busy mounts

Christian Brauner <brauner@kernel.org>
    mount: keep a copied mount unbindable

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: disable self-refresh on tearing flips

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/userq: return the memdup_user() error for the user MQD

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/userq: only accept doorbell BOs as queue doorbell

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amdgpu: copy debugfs register data outside the GRBM/SRBM locks

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: make Mac FB workaround generic

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: serialize vblank counter reads against GPU reset

Haojie Li <lihaojie@kylinos.cn>
    drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info

Saleel Kudchadker <Saleel.Kudchadker@amd.com>
    drm/amdkfd: align SDMA doorbell base for shader doorbell writes

Felix Gu <ustc.gu@gmail.com>
    drm/bridge: th1520-dw-hdmi: Fix remove() callback

Felix Gu <ustc.gu@gmail.com>
    drm/bridge: th1520-dw-hdmi: Fix error check on dw_hdmi_probe() return value

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Fix stale pinned_link entry when fb-pin performs the final unpin

Thomas Hellström <thomas.hellstrom@linux.intel.com>
    drm/xe: Fix shrinker accounting double-subtraction on nested external pins

Fan Wu <fanwu01@zju.edu.cn>
    drm/xe/i2c: cancel the client work on remove

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate pitch coming from userspace

Wentao Liang <vulab@iscas.ac.cn>
    drm/vc4: Fix firmware reference leak in vc4_drm_bind()

Fan Wu <fanwu01@zju.edu.cn>
    drm/vc4: drain the hangcheck timer and works on V3D unbind

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: validate userspace queue count against initialized firmware slot count

Gyeyoung Baek <gye976@gmail.com>
    drm/imagination: Size page table preallocation by device address

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gt: Unmask interrupts only when ACTIVE is true

Krzysztof Karas <krzysztof.karas@intel.com>
    drm/i915/gem: Prevent overstepping exec array boundary

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: don't keep a connector without a CRTC as connector_state

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN

Palla Raghunath <raghunathpalla.0209@gmail.com>
    Bluetooth: RFCOMM: Fix NULL tty_dev dereference in rfcomm_dev_shutdown

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Bluetooth: RFCOMM: connect the session socket without rfcomm_mutex

Maxim Skokov <skokovmaksimevg@gmail.com>
    Bluetooth: RFCOMM: free the skb when the DLC has no owner

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: SCO: serialise sco_conn lifetime against sco_recv_scodata()

Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
    Bluetooth: MGMT: Fix status of pending commands flushed on power off

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: ISO: Serialize concurrent connect calls

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: ISO: Reject concurrent BIS listener setup

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix command skb lifetime during scan setup

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sock: Serialize dead-device detachment

Runyu Xiao <runyu.xiao@seu.edu.cn>
    Bluetooth: btintel_pcie: use managed IRQ teardown

Chen Pei <cp0613@linux.alibaba.com>
    riscv: ptrace: reject CFI regset access when extensions are absent

Wei-Jie Hung <imbigking12@gmail.com>
    riscv: patch: fix handling of bpf-jit execmem addresses

Shao Mingyin <shao.mingyin@zte.com.cn>
    riscv: lib: Fix ZBB strnlen wrap-around regression on huge counts

Zongmin Zhou <zhouzongmin@kylinos.cn>
    riscv: hwprobe: use _BITULL() rather than BIT() in MIPS vendor uapi header

Ziyi Guo <guoziyi114@gmail.com>
    riscv: futex: untag the user pointer before the atomic access

Karl Mehltretter <kmehltretter@gmail.com>
    riscv: fix load_unaligned_zeropad() fixup for RV32

Zongmin Zhou <zhouzongmin@kylinos.cn>
    riscv: errata: select RISCV_ALTERNATIVE_EARLY for THEAD GHOSTWRITE

Ziyi Guo <guoziyi114@gmail.com>
    riscv: entry: gate shadow call stack reload on sstatus.SPP, not tp

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: qedi: Initialize callback state before registration

Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
    scsi: ch: Do not keep references to data transfer element devices

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: propagate subdomain add errors

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: fix clock leak on domain probe failure

Shawn Lin <shawn.lin@rock-chips.com>
    pmdomain: rockchip: don't ignore clock lookup errors on attach

Ming Qian <ming.qian@oss.nxp.com>
    pmdomain: imx8m-blk-ctrl: Serialize power on/off across sibling domains

Ridham Khurana <khurana.ridham222@gmail.com>
    regulator: tps6594-regulator: Fix n_linear_ranges for TPS65224 BUCK2-4

Alexey Charkov <alchark@flipper.net>
    regulator: of: fill in supply names in of_regulator_bulk_get_all()

Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
    regulator: ltc3676: don't read the write-only HRST and CLIRQ registers

Alexey Charkov <alchark@flipper.net>
    power: sequencing: pcie-m2: Fix leaking array from of_regulator_bulk_get_all()

Shao-Fu Chen <shf.chen@mediatek.com>
    optee: register TEE devices only once fully initialized

Denis V. Lunev <den@openvz.org>
    openvswitch: fix soft lockup in the netlink flow dump

Karl Bonde Torp <k.torp@samsung.com>
    nvme: fix swapped ZRASF zone state values for full and read only

Weiming Shi <bestswngs@gmail.com>
    net: team: free skb when broadcast has no txable port

Weiming Shi <bestswngs@gmail.com>
    net: team: stop reusing skb after queue override

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Free outstanding DMA buffers on dmaengine stop

Fredrik Nyberg <fredrik.nyberg@volvocars.com>
    net: usb: ax88179_178a: fix rx frame length for non-last packets

Daniel Machon <daniel.machon@microchip.com>
    net: sparx5: free the matchall entry on destroy

Josef Bacik <josef@toxicpanda.com>
    net: skbuff: don't leave stale bytes in skb_copy_and_csum_bits()

Sebastien Royen <sebastien.royen@armadeus.com>
    net: dsa: microchip: fix KSZ8765 fiber detection

Zixuan Chai <petalzu987@gmail.com>
    net: bridge: avoid recursive multicast port cleanup

Chengfeng Ye <nicoyip.dev@gmail.com>
    net/smc: protect clcsock lifetime in smc_getname

Quchaosheng <quchaosheng000406@163.com>
    net/packet: guard the ll header push in packet_rcv_spkt()

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: sdhci-sprd: disable runtime PM on remove

Yibo Tan <lhfff@tju.edu.cn>
    mmc: mtk-sd: Cancel request timeout work on remove

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: cavium-thunderx: destroy slot platform devices on remove

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: cavium-octeon: destroy slot platform devices on remove

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix reading free memory in do_resume

Ma Xinmeng <1564938642@qq.com>
    dm-snap: reject the transient exception store for snapshot-merge

Ben Cressey <ben@cressey.dev>
    dm-integrity: fix buffer overflow in inline mode with large tag size

Ben Cressey <ben@cressey.dev>
    dm-crypt: reject the lmk IV mode with AEAD ciphers

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    mm: don't schedule deferred kernel page table freeing while booting

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    memstick: rtsx_usb_ms: complete requests after eject instead of dropping them

Raj Ojha <rajojha047@gmail.com>
    memstick: core: wait for request completion before freeing card

성병찬 <tjdqudcks0424@naver.com>
    KEYS: Fix add_key() race with keyring restriction

Karl Mehltretter <kmehltretter@gmail.com>
    keys: finalize persistent keyring timeout after link attempt

Daehyeon Ko <4ncienth@gmail.com>
    ip6_gre: remove obsolete ERSPAN PMTU update

Natasha Klaus <natalie.klaus@runtimeverification.com>
    io_uring/net: populate CONNECT filter fields for 24-byte sockaddr_in6

Eugene Gvozdetsky <gvozdet@gmail.com>
    io_uring/register: don't exempt disabled rings from task restrictions

Tristan Madani <tristan@talencesecurity.com>
    ice: fix metadata_dst refcount handling on representor teardown

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ice: fix use-after-free in dynamic port cleanup

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: fix TX LTB and filter unwind on open-fail

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: h_free logical LAN on open-fail after register

Joshua Washington <joshwash@google.com>
    gve: fix XSK buffer leak on error descriptor

Joshua Washington <joshwash@google.com>
    gve: fix XSK buffer leak when rings are stopped

Joshua Washington <joshwash@google.com>
    gve: fix napi_disable deadlock when attempting to disable XSK pools

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    iavf: send MAC change request synchronously

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: xilinx: fix runtime PM leak on request error path

Fan Wu <fanwu01@zju.edu.cn>
    gpio: mpsse: fix race when arming the IRQ poll worker

Eric Biggers <ebiggers@kernel.org>
    fsverity: RCU-delay the freeing of struct fsverity_info

Vishal Badole <Vishal.Badole@amd.com>
    EDAC/amd64: Mask UMC chip select to the four implemented selects

Tony Nguyen <anthony.l.nguyen@intel.com>
    e1000e: add system to disable K1 list

Carlos Llamas <cmllamas@google.com>
    selftests/mm: cleanup -Wformat issues in hugetlb-mmap

Hui Peng <benquike@gmail.com>
    sctp: copy zeroed stats to user in sctp_getsockopt_pr_streamstatus() when !streamoute

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts

Christian Göttsche <cgzones@googlemail.com>
    selinux: fix data race on AVC latest_notif

Johannes Berg <johannes.berg@intel.com>
    Revert "wifi: libertas: reject short monitor TX frames"

Chengfeng Ye <nicoyip.dev@gmail.com>
    tipc: hold a reference to nodes found by link name

Yuqi Xu <xuyuqiabc@gmail.com>
    tipc: destroy topsrv workqueues before closing connections

Daehyeon Ko <4ncienth@gmail.com>
    tcp: reject net_iov in zerocopy receive mapping hints

Marek Szyprowski <m.szyprowski@samsung.com>
    swiotlb: fix default_swiotlb_limit() for non-growable default pool

Sabrina Dubroca <sd@queasysnail.net>
    strparser: make sure __strp_recv isn't running before tearing down the parser

Georgiy Osokin <g.osokin@auroraos.dev>
    tee: shm: reject zero-sized allocations in tee_dyn_shm_alloc_helper()

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: don't leak the skb when xennet_fill_frags() fails

Borislav Petkov (AMD) <bp@alien8.de>
    x86/CPU/AMD: Fix AMD TLBI Erratum #1718

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in chained work check

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: reject response consumption after intermediate initiation

Ramses de Norre <ramses@well-founded.dev>
    wireguard: queueing: preserve tstamp_type when encapsulating packet

Lu Huang <huanglu@kylinos.cn>
    wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init()

Cristian Papa <pcristian292@gmail.com>
    wifi: mt76: mt7603: initialize global station WCID

Michele Dionisio <michele.dionisio@gmail.com>
    wifi: brcmfmac: fix P2P device removal race in brcmf_detach()

Daehyeon Ko <4ncienth@gmail.com>
    vsock/virtio: account only unread bytes in read_skb()

Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
    usb: f81604: fix struct f81604_int_data size mismatch

Palla Raghunath <raghunathpalla.0209@gmail.com>
    dm ioctl: don't let data_start run past the buffer

Daehyeon Ko <4ncienth@gmail.com>
    cipso: adjust cached option offsets when removing CIPSO

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Handle cpu hotplug race in guarantee_active_cpus()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: fix unique skb identifier regression under RPS

zjamg <ndaugoing@gmail.com>
    can: dev: init_can_skb(): restore skb header initialization

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()

Hengyu Liang <hengyul@cs.unc.edu>
    ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands

Michael Garland <minimelkav@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: irq: exclude the softirq stack switch from KCOV

Mohamed Yassine Jebabli <med.jebabli@gmail.com>
    ALSA: hda/tas2781: Accept V1 calibration data without CRC

Harin Lee <me@harin.net>
    ALSA: ctxfi: Fix memory leakage when clearing DAO input mappers

Krzysztof Furman <krisfur@proton.me>
    Input: xpad - add support for Corsair Novablade Pro

Bihaan Sen <stevewholikesthings@gmail.com>
    Input: xpad - add support for 8BitDo Pro 2 Wired Controller for Xbox

Haotian Zhang <vulab@iscas.ac.cn>
    Input: ati_remote2 - fix type confusion in device attribute handlers

Daehyeon Ko <4ncienth@gmail.com>
    ipv6: do not warn on route notification size race

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: do not warn on route notification size race

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop route notification sizing when nexthop group shrinks

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop exception dump when nexthop group shrinks

Daehyeon Ko <4ncienth@gmail.com>
    ipv4: stop PMTU walk when nexthop group shrinks

Alice Ryhl <aliceryhl@google.com>
    rust_binder: reschedule node refcount update on thread exit

Michael S. Tsirkin <mst@redhat.com>
    ipv4: validate checksum_start before completing checksum

Ido Schimmel <idosch@nvidia.com>
    ipv6: udp: Create exceptions before socket matching

Ido Schimmel <idosch@nvidia.com>
    ipv4: udp: Create exceptions before socket matching

Ido Schimmel <idosch@nvidia.com>
    ipv6: Fix redirect exception creation for UDP/RAW sockets

Jerome Tollet <jtollet@cisco.com>
    net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry

Jerome Tollet <jtollet@cisco.com>
    net/mlx5e: Prevent stale XSK buffer release on refill retry

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs: Free any excess xarray nodes in clear_inode()

Eric Dumazet <edumazet@kernel.org>
    bnxt_en: fix DMA mapping length for padded small packets


-------------

Diffstat:

 Documentation/networking/strparser.rst             |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |  19 +-
 arch/arm64/include/asm/el2_setup.h                 |   5 +-
 arch/arm64/kernel/Makefile                         |   3 +
 arch/riscv/Kconfig                                 |   5 +-
 arch/riscv/Kconfig.errata                          |   1 +
 arch/riscv/include/asm/futex.h                     |   2 +
 arch/riscv/include/asm/scs.h                       |  17 +-
 arch/riscv/include/asm/vector.h                    |   8 +-
 arch/riscv/include/uapi/asm/vendor/mips.h          |   4 +-
 arch/riscv/kernel/entry.S                          |   2 +-
 arch/riscv/kernel/patch.c                          |   2 +-
 arch/riscv/kernel/ptrace.c                         |   8 +
 arch/riscv/lib/strnlen.S                           |  20 +-
 arch/riscv/mm/extable.c                            |   4 +-
 arch/um/drivers/vector_transports.c                |   1 +
 arch/x86/include/asm/cpufeatures.h                 |   3 +
 arch/x86/include/asm/tlb.h                         |   6 +
 arch/x86/kernel/cpu/amd.c                          |   4 +
 drivers/android/binder/node.rs                     |  20 +-
 drivers/android/binder/node/wrapper.rs             |  34 ++-
 drivers/ata/libata-scsi.c                          |  13 +-
 drivers/block/zloop.c                              |  31 ++-
 drivers/bluetooth/btintel_pcie.c                   |  17 +-
 drivers/clk/qcom/gcc-eliza.c                       |   6 +-
 drivers/clk/qcom/gcc-kaanapali.c                   |   6 +-
 drivers/clk/qcom/gpucc-glymur.c                    |   2 +-
 drivers/clk/qcom/gpucc-kaanapali.c                 |   2 +-
 drivers/edac/amd64_edac.c                          |   4 +-
 drivers/gpio/gpio-exar.c                           |   2 +-
 drivers/gpio/gpio-mpsse.c                          |  24 +-
 drivers/gpio/gpio-xilinx.c                         |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  77 ++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c          |  13 +-
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c         |   9 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  32 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   7 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  26 ++-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |  20 +-
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c            |   5 +-
 drivers/gpu/drm/bridge/th1520-dw-hdmi.c            |   8 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   4 +-
 drivers/gpu/drm/drm_bridge.c                       |   8 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   6 +-
 drivers/gpu/drm/gud/gud_pipe.c                     |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/i915/gt/intel_rps.c                |   3 +-
 drivers/gpu/drm/imagination/pvr_mmu.c              |  25 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   8 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |   3 +
 drivers/gpu/drm/vc4/vc4_bo.c                       |   5 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   5 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |   2 +-
 drivers/gpu/drm/vc4/vc4_gem.c                      |   8 +-
 drivers/gpu/drm/vc4/vc4_irq.c                      |  24 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |  65 +++---
 drivers/gpu/drm/vc4/vc4_validate.c                 |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_cursor_plane.c       |  26 ++-
 drivers/gpu/drm/xe/display/xe_fb_pin.c             |   6 +-
 drivers/gpu/drm/xe/xe_bo.c                         | 139 ++++++++---
 drivers/gpu/drm/xe/xe_bo.h                         |   2 +
 drivers/gpu/drm/xe/xe_i2c.c                        |   5 +-
 drivers/gpu/drm/xe/xe_lrc.c                        |  38 +--
 drivers/gpu/drm/xe/xe_mmio.c                       |   5 +-
 drivers/gpu/drm/xe/xe_sysctrl_mailbox.c            |  16 +-
 drivers/hid/hid-steam.c                            | 252 ++++++++++----------
 drivers/input/joystick/xpad.c                      |   4 +
 drivers/input/misc/ati_remote2.c                   |  12 +-
 drivers/iommu/dma-iommu.c                          |   4 +-
 drivers/md/dm-crypt.c                              |   7 +-
 drivers/md/dm-integrity.c                          |   4 +-
 drivers/md/dm-ioctl.c                              |  14 +-
 drivers/md/dm-snap.c                               |  14 ++
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/memstick/host/rtsx_usb_ms.c                |  31 +--
 drivers/mmc/host/cavium-octeon.c                   |   5 +-
 drivers/mmc/host/cavium-thunderx.c                 |   5 +-
 drivers/mmc/host/mtk-sd.c                          |   1 +
 drivers/mmc/host/sdhci-sprd.c                      |   4 +
 drivers/net/amt.c                                  |  48 ++--
 drivers/net/bareudp.c                              |   3 +-
 drivers/net/bonding/bond_main.c                    |   8 +-
 drivers/net/can/dev/skb.c                          |   4 +
 drivers/net/can/usb/f81604.c                       |   2 +-
 drivers/net/can/vxcan.c                            |   3 +
 drivers/net/dsa/microchip/ksz_common.h             |   2 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |  32 ++-
 drivers/net/ethernet/airoha/airoha_eth.h           |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 199 ++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 -
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  11 +
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   4 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   8 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  13 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  22 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   7 +
 drivers/net/ethernet/intel/iavf/iavf.h             |  11 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  85 +++++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  99 +++++++-
 drivers/net/ethernet/intel/ice/devlink/port.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  13 +-
 .../ethernet/mellanox/mlx5/core/esw/adj_vport.c    |  20 --
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  79 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  24 --
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |  10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   9 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |  28 ++-
 .../ethernet/microchip/sparx5/sparx5_tc_matchall.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  15 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   7 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  53 ++++-
 drivers/net/pfcp.c                                 |   7 +
 drivers/net/team/team_core.c                       |  16 +-
 drivers/net/team/team_mode_broadcast.c             |   2 +
 drivers/net/tun.c                                  |  23 +-
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/veth.c                                 |   1 +
 drivers/net/virtio_net.c                           |   2 +
 drivers/net/wireguard/noise.c                      |   7 +-
 drivers/net/wireguard/queueing.h                   |   2 +
 drivers/net/wireless/ath/ath12k/core.c             |  33 +--
 drivers/net/wireless/ath/ath12k/core.h             |   3 -
 drivers/net/wireless/ath/ath12k/hif.h              |   9 -
 drivers/net/wireless/ath/ath12k/pci.c              |   8 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  27 ++-
 drivers/net/wireless/marvell/libertas/tx.c         |   7 -
 drivers/net/wireless/mediatek/mt76/mt76.h          |  10 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  12 +
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.c   | 134 +++++++----
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.h   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   3 +
 drivers/net/wireless/mediatek/mt76/tx.c            |  89 +++++++-
 drivers/net/xen-netfront.c                         |   4 +-
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/pr.c                           |   4 +
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  15 ++
 drivers/pmdomain/rockchip/pm-domains.c             |  20 +-
 drivers/power/sequencing/pwrseq-pcie-m2.c          |   2 +
 drivers/ptp/ptp_ocp.c                              |   2 +-
 drivers/regulator/ltc3676.c                        |  15 +-
 drivers/regulator/of_regulator.c                   |  24 +-
 drivers/regulator/tps6594-regulator.c              |   6 +-
 drivers/scsi/ch.c                                  |  29 +--
 drivers/scsi/qedi/qedi_main.c                      |   3 +-
 drivers/spi/spi-nxp-fspi.c                         |  22 +-
 drivers/spi/spi-sg2044-nor.c                       |  60 ++++-
 drivers/tee/optee/ffa_abi.c                        |  38 ++-
 drivers/tee/optee/optee_msg.h                      |   4 +-
 drivers/tee/optee/smc_abi.c                        |  17 +-
 drivers/tee/tee_shm.c                              |   4 +
 drivers/ufs/core/ufs-mcq.c                         |  30 +--
 drivers/ufs/core/ufshcd.c                          |  53 +++--
 drivers/ufs/host/ufs-mediatek.c                    |  18 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/ioctl.c                                   |  31 +--
 fs/btrfs/scrub.c                                   |   4 +-
 fs/btrfs/xattr.c                                   |  15 +-
 fs/dcache.c                                        |   4 +-
 fs/fcntl.c                                         |   3 +
 fs/fs_context.c                                    |   4 +
 fs/inode.c                                         |  23 +-
 fs/mount.h                                         |   6 +-
 fs/namei.c                                         |  29 +++
 fs/namespace.c                                     | 254 ++++++++++++++++-----
 fs/nullfs.c                                        |   4 +-
 fs/pnode.c                                         | 108 +++++++--
 fs/verity/fsverity_private.h                       |  15 +-
 fs/verity/open.c                                   |  13 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       | 103 ++-------
 fs/xfs/libxfs/xfs_log_format.h                     |   4 +-
 fs/xfs/xfs_bmap_util.c                             |  15 +-
 fs/xfs/xfs_exchrange.c                             |  51 +++--
 include/linux/can/core.h                           |   3 +-
 include/linux/can/skb.h                            |   4 +-
 include/linux/io_uring_types.h                     |   2 +
 include/linux/mount.h                              |   2 +-
 include/linux/nsproxy.h                            |   1 +
 include/linux/nvme.h                               |   4 +-
 include/linux/sched/ext.h                          |   1 +
 include/linux/virtio_net.h                         |  64 +++---
 include/net/amt.h                                  |   4 -
 include/net/bluetooth/rfcomm.h                     |   1 +
 include/net/can.h                                  |   2 +
 include/net/cfg80211.h                             |   1 +
 include/net/ip.h                                   |   7 +
 include/net/mac80211.h                             |  14 +-
 include/net/strparser.h                            |  10 +-
 io_uring/io_uring.c                                |  13 +-
 io_uring/kbuf.c                                    |   6 +-
 io_uring/memmap.c                                  |  47 +++-
 io_uring/memmap.h                                  |   2 +-
 io_uring/net.c                                     |   4 +-
 io_uring/register.c                                |  21 +-
 io_uring/zcrx.c                                    |   2 +-
 kernel/cgroup/cpuset.c                             |  40 +++-
 kernel/dma/swiotlb.c                               |   6 +-
 kernel/fork.c                                      |   3 +-
 kernel/nsproxy.c                                   |   2 +-
 kernel/sched/ext/ext.c                             |  25 +-
 kernel/sched/ext/internal.h                        |   5 +
 kernel/sched/sched.h                               |   1 -
 kernel/workqueue.c                                 |   2 +-
 lib/dim/dim.c                                      |  10 +-
 mm/mremap.c                                        |  70 ++++--
 mm/pgtable-generic.c                               |  20 +-
 mm/vma.c                                           |  21 +-
 mm/vma.h                                           |   7 +-
 net/bluetooth/hci_core.c                           |   4 +
 net/bluetooth/hci_sock.c                           |   2 +
 net/bluetooth/hci_sync.c                           |  10 +-
 net/bluetooth/iso.c                                |  52 ++++-
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/rfcomm/core.c                        | 134 +++++++----
 net/bluetooth/rfcomm/sock.c                        |   5 +-
 net/bluetooth/rfcomm/tty.c                         |   2 +-
 net/bluetooth/sco.c                                |  87 +++++--
 net/bridge/br_multicast.c                          |  23 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  10 +-
 net/can/af_can.c                                   |  47 +++-
 net/can/gw.c                                       |   3 +
 net/can/isotp.c                                    |  16 +-
 net/can/raw.c                                      |  10 +-
 net/core/dev.c                                     |  11 +-
 net/core/flow_dissector.c                          |  11 +-
 net/core/skbuff.c                                  |   6 +-
 net/devlink/core.c                                 |  10 +-
 net/ipv4/cipso_ipv4.c                              |   8 +
 net/ipv4/fib_semantics.c                           |   3 +
 net/ipv4/fib_trie.c                                |   2 -
 net/ipv4/ip_output.c                               |  10 +-
 net/ipv4/route.c                                   |   5 +
 net/ipv4/tcp.c                                     |   2 +
 net/ipv4/udp.c                                     |  11 +
 net/ipv6/ip6_gre.c                                 |   7 -
 net/ipv6/route.c                                   |   4 +-
 net/ipv6/udp.c                                     |  13 ++
 net/mac80211/debugfs.c                             |  13 +-
 net/mac80211/ieee80211_i.h                         |   2 +
 net/mac80211/main.c                                |   1 +
 net/mac80211/sta_info.c                            |  17 +-
 net/mac80211/sta_info.h                            |   3 +-
 net/mac80211/status.c                              |   5 +-
 net/mac80211/tx.c                                  |  70 ++++--
 net/netfilter/nfnetlink_queue.c                    |   7 +
 net/netfilter/xt_CHECKSUM.c                        |   6 +-
 net/openvswitch/actions.c                          |   7 +-
 net/openvswitch/datapath.c                         |   8 +
 net/packet/af_packet.c                             |  28 ++-
 net/sched/cls_route.c                              |   6 +
 net/sched/em_text.c                                |   3 +
 net/sctp/socket.c                                  |   6 +-
 net/smc/af_smc.c                                   |   7 +-
 net/strparser/strparser.c                          |   6 +-
 net/tipc/node.c                                    |  10 +-
 net/tipc/topsrv.c                                  |  80 +++++--
 net/vmw_vsock/af_vsock.c                           |   2 +
 net/vmw_vsock/virtio_transport_common.c            |   4 +-
 net/xfrm/xfrm_output.c                             |  16 +-
 security/keys/key.c                                |   6 +-
 security/keys/persistent.c                         |  55 +++--
 security/selinux/avc.c                             |   5 +-
 security/selinux/hooks.c                           |   9 +-
 sound/hda/codecs/side-codecs/tas2781_hda.c         |  18 +-
 sound/pci/ctxfi/ctdaio.c                           |   6 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/adau1372.c                        |  18 +-
 sound/soc/samsung/i2s.c                            |   8 +
 sound/soc/sdw_utils/soc_sdw_utils.c                |  35 ++-
 tools/testing/selftests/mm/hugetlb-mmap.c          |   4 +-
 tools/testing/vma/tests/vma.c                      |   4 +-
 285 files changed, 3420 insertions(+), 1618 deletions(-)


