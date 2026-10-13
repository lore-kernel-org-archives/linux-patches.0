Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6462E4F7CD5;
	Tue, 13 Oct 2026 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894755; cv=none; b=GkYvrRTa/HpvB99OFdHMIvAy8OJHcqDCOVhORog0jGd3DbOc5iD5+hepQbcjmd5BZeCZfnswIJei2JdyKO6UAX5eEMNYmbbDAvLr8dJjwL2etfzZ6sJa6syZykILbTFO6TZRe0qsWm7HMtMgH438U0Ydv5gf532EeZZt8jVkUG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894755; c=relaxed/simple;
	bh=cIAd52PBsaefJ3rYx/jv1b/qdkRXwvhkDpBHqlWiyCE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RyPgZnuI80hDnt/9FxbeWAHEmeayxNqeKrpMzoMo4JvxEDwWIbQ42KfcjkNdT5ABxuOsZoxCf4Wxu1bFWMvQEqCiB3TbSdf09CFERryNCwB1lLEAHlDFyowjoy3zhWYqbCxUSVfUYLe1ppS8ibgGnTZZBrIWUDp48DSzBlhF9Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QptRIZv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QptRIZv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA211F000FF;
	Tue, 13 Oct 2026 12:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894751;
	bh=zYIuU+wCg+6k36ipJWlT29ygVDXkCpGg8/A+oNjFxuc=;
	h=From:To:Cc:Subject:Date;
	b=QptRIZv8c4r83223gZQjvEi4Kr3F9+THWS3VOw6GHp20uFaUCcSxkhUWSfAa8+533
	 yah3NlTweJFQd2ZuFMp5lT/JqwMeLCwDfrFih7IBY44sY+fY0jgPEMQVmaYo274wKa
	 f9BVOmWHIVw1O7LsMrwWgkqbpyrZdwpf/f0okzkc=
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
Subject: [PATCH 6.12 000/497] 6.12.113-rc1 review
Date: Tue, 13 Oct 2026 13:32:47 +0200
Message-ID: <20261013112907.864180619@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.113-rc1
X-KernelTest-Deadline: 2026-10-15T11:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.113 release.
There are 497 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.113-rc1

Adrian Bente <adibente@gmail.com>
    netfilter: flowtable: fix offloaded ct timeout never being extended

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: fix erronous removal of offload bit

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: fix KCSAN warning on io_waitid->head

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: use io_waitid_remove_wq() consistently

Osama Abdelkader <osama.abdelkader@gmail.com>
    drm/panthor: validate userspace queue count against initialized firmware slot count

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Fix binner slot allocation failing on an idle GPU

Maxime Ripard <mripard@kernel.org>
    drm/vc4: Make v3d paths unavailable on any generation newer than vc4

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

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of hlen in bpf_flow_dissect()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix driver init in kdump kernel

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Add bnxt_clear_bars() helper

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    pfcp: make sure the SEID is linear before reading it

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: reject change with no routing attribute

Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
    devlink: fix devlink_rel reference leak when notify work is pending

Eric Dumazet <edumazet@kernel.org>
    flow_dissector: avoid u16 truncation of skb->len when computing thoff

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()

Chen Ridong <chenridong@huawei.com>
    cpuset: separate tmpmasks and cpuset allocation logic

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes

Alvin Šipraga <alvin.sipraga@analog.com>
    ASoC: adau1372: allow sleepy powerdown GPIOs

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

Filipe Manana <fdmanana@suse.com>
    btrfs: fix lost error return value in btrfs_listxattr()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix xattr replace when multiple xattrs are packed in the same item

Fuad Tabba <fuad.tabba@linux.dev>
    arm64/boot: Don't set PMUv3p9 FGT2 bits without PMUv3

Sang-Hoon Choi <csh0052@gmail.com>
    nvmet: use the local P2P device on metadata allocation failure

Mahantesh Salimath <mahantesh@nvidia.com>
    tee: optee: ffa: support shared memory offsets on large-page kernels

Rodrigo Zaiden <rodrigoffzz@gmail.com>
    tee: optee: fix kernel-doc warnings

Jens Wiklander <jens.wiklander@linaro.org>
    optee: sync secure world ABI headers

Sang-Hoon Choi <csh0052@gmail.com>
    cxgb4/ch_ktls: disable softirqs around tid_list erases

Omar Ramadan <omar@blockcast.net>
    amt: send the relay's General Query directly from the receive path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: em_text: reject unterminated algo before autoload

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Free the BO cache size list on teardown

Myeonghun Pak <mhun512@gmail.com>
    drm/aspeed: Balance the display clock enable on teardown

Sang-Hoon Choi <csh0052@gmail.com>
    gpio: exar: initialize the ID before registering its cleanup

Oleg Keri <okerixx@gmail.com>
    drm/dp: don't mark the AUX backlight enabled when enabling failed

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel_pcie: Add shared HW reset for clean start

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Add recovery mechanism

Ravindra <ravindra@intel.com>
    Bluetooth: btintel_pcie: fix TX descriptor bounds check

Vincent Jardin <vjardin@free.fr>
    arm64: dts: lx2160a: fix the iic5 spi3 pinmux offset and value

Vincent Jardin <vjardin@free.fr>
    arm64: dts: lx2160a: fix IIC1 pinmux submask rejected by pinctrl-single

Vincent Jardin <vjardin@free.fr>
    arm64: dts: lx2160a: fix incorrect pinmux

Christian Brauner <brauner@kernel.org>
    namespace: refuse an automount below a mount that is in no namespace

Christian Brauner <brauner@kernel.org>
    namei: don't reveal overmounted entries in refwalk

Christian Brauner <brauner@kernel.org>
    namespace: don't let a pseudo dentry become the root of a mount

Christian Brauner <brauner@kernel.org>
    dcache: don't put a mountpoint on a dentry that's being removed

Christian Brauner <brauner@kernel.org>
    namespace: check a submount for references right before unmounting it

Christian Brauner <brauner@kernel.org>
    fs: refuse fspick() on internal superblocks

Christian Brauner <brauner@kernel.org>
    namespace: don't copy an unmounted mount tree

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Fix direct scanout alpha on some DRM_FORMATs

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

Fan Wu <fanwu01@zju.edu.cn>
    drm/vc4: drain the hangcheck timer and works on V3D unbind

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

Maxim Skokov <skokovmaksimevg@gmail.com>
    Bluetooth: RFCOMM: free the skb when the DLC has no owner

Iaroslav Voitovych <yaroslav.voytovych@gmail.com>
    Bluetooth: MGMT: Fix status of pending commands flushed on power off

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: ISO: Serialize concurrent connect calls

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: ISO: Reject concurrent BIS listener setup

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sock: Serialize dead-device detachment

Runyu Xiao <runyu.xiao@seu.edu.cn>
    Bluetooth: btintel_pcie: use managed IRQ teardown

Karl Mehltretter <kmehltretter@gmail.com>
    riscv: fix load_unaligned_zeropad() fixup for RV32

Ziyi Guo <guoziyi114@gmail.com>
    riscv: entry: gate shadow call stack reload on sstatus.SPP, not tp

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: qedi: Initialize callback state before registration

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

Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
    regulator: ltc3676: don't read the write-only HRST and CLIRQ registers

Shao-Fu Chen <shf.chen@mediatek.com>
    optee: register TEE devices only once fully initialized

Denis V. Lunev <den@openvz.org>
    openvswitch: fix soft lockup in the netlink flow dump

Karl Bonde Torp <k.torp@samsung.com>
    nvme: fix swapped ZRASF zone state values for full and read only

Weiming Shi <bestswngs@gmail.com>
    net: team: free skb when broadcast has no txable port

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
    dm-crypt: reject the lmk IV mode with AEAD ciphers

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    memstick: rtsx_usb_ms: complete requests after eject instead of dropping them

Raj Ojha <rajojha047@gmail.com>
    memstick: core: wait for request completion before freeing card

성병찬 <tjdqudcks0424@naver.com>
    KEYS: Fix add_key() race with keyring restriction

Karl Mehltretter <kmehltretter@gmail.com>
    keys: finalize persistent keyring timeout after link attempt

Tristan Madani <tristan@talencesecurity.com>
    ice: fix metadata_dst refcount handling on representor teardown

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: fix TX LTB and filter unwind on open-fail

Mingming Cao <mmc@linux.ibm.com>
    ibmveth: h_free logical LAN on open-fail after register

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: xilinx: fix runtime PM leak on request error path

Vishal Badole <Vishal.Badole@amd.com>
    EDAC/amd64: Mask UMC chip select to the four implemented selects

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

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in chained work check

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: noise: reject response consumption after intermediate initiation

Ramses de Norre <ramses@well-founded.dev>
    wireguard: queueing: preserve tstamp_type when encapsulating packet

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

Wentao Liang <vulab@iscas.ac.cn>
    btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()

Michael Garland <minimelkav@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: irq: exclude the softirq stack switch from KCOV

Krzysztof Furman <krisfur@proton.me>
    Input: xpad - add support for Corsair Novablade Pro

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

Michael S. Tsirkin <mst@redhat.com>
    ipv4: validate checksum_start before completing checksum

Eric Biggers <ebiggers@kernel.org>
    crypto: drbg - Fix ineffective sanity check

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix reusing m3 memory

Jiajia Liu <liujiajia@kylinos.cn>
    Bluetooth: hci_event: fix simultaneous discovery stuck in FINDING

Liew Rui Yan <aethernet65535@gmail.com>
    mm/damon/core: fix unconditionally skip last region

SeongJae Park <sj@kernel.org>
    mm/damon/core: do non-safe region walk on kdamond_apply_schemes()

Chao Yu <chao@kernel.org>
    f2fs: fix to reset all pinned status during fggc

Chao Yu <chao@kernel.org>
    f2fs: fix to shrink gc_lock coverage in f2fs_gc_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to reclaim space in f2fs_allocate_pinning_section()

Remy D. Farley <one-d-wide@protonmail.com>
    doc/netlink: netlink-raw: Add max check

Jakub Kicinski <kuba@kernel.org>
    tools: ynl: add scope qualifier for definitions

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: support limits using definitions

Jakub Kicinski <kuba@kernel.org>
    tools: ynl-gen: use names of constants in generated limits

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: light: rohm-bu27034: Fix error return

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: light: rohm-bu27034: Fix infinite delay on error

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: bu27034: simplify using guard(mutex)

Pengpeng Hou <hppiscas@163.com>
    iio: cdc: ad7150: fix OF matching and publish module aliases

Michael Hennerich <michael.hennerich@analog.com>
    iio: buffer-dmaengine: fix sg entry iteration when building dma_vecs

Paulo Alcantara <pc@manguebit.org>
    smb: client: only require read lease for size-extending preallocate

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32-adc: fix possible division by zero in processed channel

Vladyslav Ivashchenko <cactucatu4eckuu@gmail.com>
    iio: adc: axp288: Add TS bias override for Haier HV103H

Cong Nguyen <congnt264@gmail.com>
    iio: adc: max1363: sign-extend bipolar differential channel reads

Pengpeng Hou <pengpeng@iscas.ac.cn>
    iio: adc: aspeed: propagate reset deassert errors

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    iio: adc: aspeed: Simplify with dev_err_probe

Fan Wu <fanwu01@zju.edu.cn>
    iio: adc: ad_sigma_delta: fix use-after-free on unbind

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: accel: kionix-kx022a: Prevent memory leak and fix state

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: accel: kx022a: Use cleanup.h helpers

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: set info->band for 802.3 encap offload frames

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: mac80211: Add sta pointer sanity check in ieee80211_8023_xmit()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Use the active VMCB's MSR bitmap when checking if MSR is intercepted

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: remove double CQ cleanup in mana_create_rxq error path

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: Skip WQ object destruction for uninitialized RXQ

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: check xdp_rxq registration before unreg in mana_destroy_rxq()

Jerome Tollet <jtollet@cisco.com>
    net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry

Jerome Tollet <jtollet@cisco.com>
    net/mlx5e: Prevent stale XSK buffer release on refill retry

Matthew Wilcox (Oracle) <willy@infradead.org>
    fs: Free any excess xarray nodes in clear_inode()

Zhiling Zou <zhilinz@nebusec.ai>
    wifi: mac80211: count only matching reservations in reserved switch

Johan Hovold <johan@kernel.org>
    tty: port: fix tty_port_tty_vhangup() race

Eric Dumazet <edumazet@kernel.org>
    bnxt_en: fix DMA mapping length for padded small packets

Eric Dumazet <edumazet@kernel.org>
    ipv4: free inet_opt and ireq_opt after an RCU grace period

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT

Guixin Liu <kanie@linux.alibaba.com>
    nvme-multipath: set BLK_FEAT_ZONED only after the zone info is known

Han Xu <han.xu@nxp.com>
    mtd: spinand: Enable QE on all dies

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: shut down RX BA session timer on teardown

Nuno Sá <nuno.sa@analog.com>
    mtd: spinand: fix NULL pointer dereference with no ECC engine

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Mark DCE 6.4 as not APU

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    i2c: xiic: preserve PEC byte length in SMBus block read setup

Manikanta Guntupalli <manikanta.guntupalli@amd.com>
    i2c: xiic: Relocate xiic_i2c_runtime_suspend and xiic_i2c_runtime_resume to facilitate atomic mode

Aaron Kling <webgeek1234@gmail.com>
    ALSA: hda/tegra: Re-enable SDO workaround for Tegra194

Ian Rogers <irogers@google.com>
    perf: Replace perf_event_header__init_id with full header init

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing modem controls after DLCI open in convergence layer type 2

Johan Hovold <johan@kernel.org>
    tty: tty_port: restore TTY_IO_ERROR on activation failure

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: tty_port: use guard()s

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: introduce tty_port_tty guard()

Pannarat Wiriyaarritham <pannarat.wiriyaarritham@danielcorp.dev>
    usb: typec: ucsi: acpi: Assume UCSI 1.2 on Acer Nitro ANV15-41

Arthur Heymans <arthur@aheymans.xyz>
    drm/amd/display: Preserve eDP mode on initial ASSR failure

Runyu Xiao <runyu.xiao@seu.edu.cn>
    USB: dwc2: shut down wakeup timer before freeing HCD state

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-spear: disable controller wakeup on removal

Chen Ni <nichen@iscas.ac.cn>
    usb: ohci-spear: Remove unnecessary NULL check before clk_disable_unprepare()

Francisco Beltrán Millalén <fbeltranmillalen@gmail.com>
    drm/amdgpu: reset VI ASIC on MacBookPro14,3

Andre Eikmeyer <dev@deq.rocks>
    drm/amdgpu: reset VI ASIC on MacBookPro15,1

Eric Biggers <ebiggers@kernel.org>
    fsverity: add dependency on 64K or smaller pages

Mostafa Saleh <smostafa@google.com>
    KVM: arm64: Use stage-1 leaf size for VM_PFNMAP

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Add Cortex-A725 erratum 3821522 workaround

Beata Michalska <beata.michalska@arm.com>
    arm64: errata: Factor out broken AMU const counter cap

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: Serialize SMP remote OOB data access

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize SCO and ISO scheduling with teardown

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Forbid non-streaming SVE payload on SME-only systems

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Consistently read FPSIMD context

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Mandate SVE payload for streaming-mode state

Mark Rutland <mark.rutland@arm.com>
    arm64/fpsimd: signal: Clear PSTATE.SM when restoring FPSIMD frame only

Zhengchuan Liang <zcliangcn@gmail.com>
    perf: Require kernel access for text poke events

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/core: Check kernel access when kernel callchains are requested

Luo Gengkun <luogengkun@huaweicloud.com>
    perf: Remove unnecessary parameter of security check

Johan Hovold <johan@kernel.org>
    tty: fix saved termios reset race

Jiazi Liu <jiazi.liu1984@gmail.com>
    usb: dwc3: gadget: fix IRQ storm on invalid event buffer count

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/display: Fix fast updates on DCE 8.1

Andrey Albershteyn <aalbersh@kernel.org>
    fs,fsverity: remove check for fsverity being enabled in setattr_prepare()

Christoph Hellwig <hch@lst.de>
    fs,fsverity: reject size changes on fsverity files in setattr_prepare

Josef Bacik <josef@toxicpanda.com>
    xen/netfront: drop RX packets with a short Ethernet header

Gilberto Conde <gilbertorconde@gmail.com>
    net: usb: qmi_wwan: add Quectel EG120K-EA

David Howells <dhowells@redhat.com>
    cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB1

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-its: Fix MOVALL handling of source redistributor

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: ignore sysfs configs for shmem forced collapse

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: shmem: change shmem_huge_global_enabled() to return huge order bitmap

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: factor out the order calculation into a new helper

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: shmem: remove __shmem_huge_global_enabled()

Paulo Alcantara <pc@manguebit.org>
    netfs: clear post-EOF pagecache when extending a file via write

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    pfcp: fix socket lifetime on netdevice registration failure

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    net: phy: aquantia: fix system interface type not updated in forced mode

Paolo Abeni <pabeni@redhat.com>
    mptcp: prevent race between disconnect() and rtx

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix false bitflips on reads of erased pages

Yi Yang <yiyang13@huawei.com>
    vc_screen: reload vc pointer before if (ret) in vcs_write() to avoid UAF

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty/vt: use guard()s

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    console: introduce console_lock guard()s

Asad Kamal <asad.kamal@amd.com>
    drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Use svc_xprt_put to free listener on create failure

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save

Aditya Dutt <duttaditya18@gmail.com>
    jfs: fix array-index-out-of-bounds read in add_missing_indices

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_output()

Fan Wu <fanwu01@zju.edu.cn>
    iio: trigger: cancel reenable_work before freeing trigger

Salah Triki <salah.triki@gmail.com>
    iio: proximity: vcnl3020: fix ISR bitmask check in IRQ handler

Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>
    iio: proximity: sx9324: Correct proximity channel resolution

Cong Nguyen <congnt264@gmail.com>
    iio: proximity: pulsedlight: fix iio_device left registered on PM setup failure

Salah Triki <salah.triki@gmail.com>
    iio: proximity: isl29501: Fix return type of isl29501_register_write

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    iio: proximity: aw96103: validate firmware data length

Hui Su <sh_def@163.com>
    iio: pressure: bmp280: fix out-of-bounds access in sampling frequency lookup

Fan Wu <fanwu01@zju.edu.cn>
    iio: light: gp2ap020a00f: drain irq_work after free_irq

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16480: fix unprotected debugfs reads

Arka Mondal <arkamondalofficial@gmail.com>
    iio: imu: adis16400: fix unprotected debugfs reads

Marco Chen <marcochen.dev@gmail.com>
    iio: health: max30102: fix NULL dereference in interrupt handler

Arka Mondal <arkamondalofficial@gmail.com>
    iio: gyro: adis16136: fix unprotected debugfs reads

Salah Triki <salah.triki@gmail.com>
    iio: frequency: admv1013: fix wrong channel field used in admv1013_read_raw()

Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
    iio: buffer: Ensure bounce buffer used for unaligned case is zeroed.

Jinseob Kim <kimjinseob88@gmail.com>
    iio: buffer: serialize buffer teardown with mode claims

Runyu Xiao <runyu.xiao@seu.edu.cn>
    iio: admv1013: initialize callback mutex before registering notifier

Fan Wu <fanwu01@zju.edu.cn>
    iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind

Felix Gu <ustc.gu@gmail.com>
    iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls

Felix Gu <ustc.gu@gmail.com>
    iio: adc: sun4i-gpadc-iio: clean up on thermal zone registration failure

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    iio: adc: stm32-adc: fix check on internal channel availability

Slavin Liu <bolin.liu@seu.edu.cn>
    iio: adc: pac1934: check ACPI label duplication

Salah Triki <salah.triki@gmail.com>
    iio: accel: sca3000: fix frequency divider condition check

Jiale Yao <yaojiale02@163.com>
    iio: accel: kxcjk-1013: reject duplicate event disable

Frank Sorenson <sorenson@redhat.com>
    smb: client: split cifsFileInfo bitfields to avoid shared-byte RMW races

Paulo Alcantara <pc@manguebit.org>
    smb: client: discard post-EOF pagecache when extending a file via copy range

Paulo Alcantara <pc@manguebit.org>
    smb: client: discard post-EOF pagecache when extending a file via zero range

Daehyeon Ko <4ncienth@gmail.com>
    thunderbolt: Reject oversized XDomain properties responses

Kurt Lieber <kurt@lieber.org>
    thunderbolt: Disable CL states for the Anker Prime TB5 dock

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Fix KASAN reported use-after-free when request is canceled

Ian Lin <ian.lin@jetone.com.tw>
    USB: serial: option: add Compal EXC-T1 support

Sebastian Sjoholm <sebastian.sjoholm@gmail.com>
    USB: serial: option: add Quectel RG660QB

Ian Lin <jisayme@gmail.com>
    USB: serial: option: add Compal EXM-G1x support

Carlo Szelinsky <github@szelinsky.de>
    USB: serial: option: add Quectel EG060W

Zhao Dongdong <zhaodongdong@kylinos.cn>
    USB: serial: option: add support for SIMCom SIM8260C

Johan Hovold <johan@kernel.org>
    USB: serial: fix ioctl hangup race

Johan Hovold <johan@kernel.org>
    USB: serial: fix driver deregistration order

Johan Hovold <johan@kernel.org>
    USB: serial: fix dynamic id driver deregistration race

Johan Hovold <johan@kernel.org>
    USB: serial: ssu100: fix baud rate overflow

Johan Hovold <johan@kernel.org>
    USB: serial: quatech2: fix baud rate overflow

Jérémy Carrat <jeremy.carrat@icloud.com>
    USB: serial: cp210x: add Corsair AX1500i Power Supply

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: mac80211: handle empty FILS association request payload

Zihan Xi <zihanx@nebusec.ai>
    wifi: mac80211: fix mesh fast xmit path deletion UAF

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: release mesh path quota on failed additions

Ruide Cao <caoruide123@gmail.com>
    wifi: mac80211: reject invalid 320 MHz CSA bandwidth

Yuqi Xu <xuyuqiabc@gmail.com>
    wifi: mac80211: minstrel_ht: validate fixed rate index

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: keep fallback association elements alive

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: account proxy paths against the mesh path limit

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: drain PS delivery work during station teardown

Zhiling Zou <zhilinz@nebusec.ai>
    wifi: mac80211: keep paired old chanctx alive

Guangshuo Li <lgs201920130244@gmail.com>
    wifi: iwlegacy: 3945: free EEPROM data on remove

Tianchu Chen <flynnnchen@tencent.com>
    wifi: cw1200: fix TX padding OOB read leaking heap data to device

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Bail from shadow walks if the root is invalid or a dummy

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Force MSR bitmap refresh if runtime eVMCS controls are modified

Nuno Sá <nuno.sa@analog.com>
    mtd: spinand: fix zero oobavail when no ECC engine is used

Mehmet Fide <mehmet.fide@screeningeagle.com>
    mtd: rawnand: vf610_nfc: fix reads on chips with more than 64 bytes of OOB

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ

Pei Xiao <xiaopei01@kylinos.cn>
    mtd: block2mtd: Fix divide error when erase_size is zero

Weiming Shi <bestswngs@gmail.com>
    nvmet-auth: fix out-of-bounds write in nvmet_auth_challenge()

Bean Huo <beanhuo@micron.com>
    nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for Micron 4100AT

Daehyeon Ko <4ncienth@gmail.com>
    nvme-multipath: fix underflow in ANA log bounds checks

Jiangshan Yi <yijiangshan@kylinos.cn>
    tpm: fix off-by-four bounds check in tpm2_get_random()

Willem de Bruijn <willemb@google.com>
    net: extend IPv6 exthdr detection of tunneled packets

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    HID: multitouch: stop the release timer from being rearmed on remove

Zhiling Zou <zhilinz@nebusec.ai>
    ipvs: bound LBLCR and LBLC cache growth

Jens Axboe <axboe@kernel.dk>
    io_uring: fix task_work add use-after-free with SQPOLL

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: reject oversized TX packets in send_frame()

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: fix plen overflow in btintel_pcie_recv_frame()

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel: fix buffer over-read in btintel_hw_error()

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize fragmented ISO packet queueing

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_core: Serialize ACL scheduling with channel deletion

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_core: Fix inquiry cache timestamps on 64-bit systems

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_conn: Lock parent access during enhanced SCO setup

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix inquiry cache use-after-free

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: Fix initial port reference race

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    i2c: xiic: don't clobber msg->len to signal block-read completion

Dinh Nguyen <dinguyen@kernel.org>
    EDAC/altera: Fix memory leak on dci allocation failure

Xiang Mei <xmei5@asu.edu>
    ALSA: ua101: reject mismatched capture/playback packet sizes

Kyle Zeng <kylebot@openai.com>
    ALSA: seq: Serialize compat port-info ioctls

Zimeng Li <me@lizi.moe>
    ASoC: qcom: lpass-cpu: use DAI table index for playback constraints

Jiangshan Yi <yijiangshan@kylinos.cn>
    ASoC: codecs: rt1017-sdca-sdw: fix uninitialized stream_config->type

Jiangshan Yi <yijiangshan@kylinos.cn>
    ASoC: codecs: max98363: fix uninitialized stream_config->type

Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>
    serial: sc16is7xx: refill TX FIFO below trigger using fresh TXLVL

Paul Mbewe <paultyson.mbewe@ziehl-abegg.de>
    serial: sc16is7xx: fix TX gap caused by kfifo circular buffer wrap-around

Wentao Liang <vulab@iscas.ac.cn>
    serial: vt8500: Fix clock reference leak in vt8500_serial_probe()

Simon Gassner <simon.gassner@noxsystems.com>
    serial: tegra: don't clear the Tx FIFO on an Rx-only reset

Wentao Liang <vulab@iscas.ac.cn>
    serial: ma35d1: Fix clock reference leak in ma35d1serial_probe()

Johan Hovold <johan@kernel.org>
    serial: fix TIOCMIWAIT race

Fan Wu <fanwu01@zju.edu.cn>
    serial: 8250_bcm7271: fix use-after-free in brcmuart_remove()

Fan Wu <fanwu01@zju.edu.cn>
    tty: serial: max3100: shut down timer before freeing port

Johan Hovold <johan@kernel.org>
    tty: abort break signalling on hangup

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    tty: serial: qcom_geni_serial: Keep console RX functional after deep idle

Joshua Rogers <linux@joshua.hu>
    tty: vcc: hold port lock when clearing tty pointer in vcc_cleanup

Joshua Rogers <linux@joshua.hu>
    tty: vcc: zero-initialize control packet in vcc_send_ctl()

Johan Hovold <johan@kernel.org>
    tty: amiserial: fix broken TIOCMIWAIT

Mingyu Wang <25181214217@stu.xidian.edu.cn>
    tty: vt: fix memory leak in vc_allocate()

Jie Deng <dengjie03@kylinos.cn>
    usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe

Fan Wu <fanwu01@zju.edu.cn>
    usb: cdns3: fix use-after-free in cdns3_gadget_exit()

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Current CAM OOB index fixup

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: typec: ucsi: Get the connector fwnode based on reg value

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: ucsi: glink: fix use-after-free of ucsi on remove

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: typec: tipd: fix uninitialized typec_partner_desc in tps6598x_connect()

Marian Rotariu <marian.c.rotariu@gmail.com>
    usb: typec: tipd: don't send GAID when probe fails in APP mode

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: recover after failure to start the frs ams

Hui Peng <benquike@gmail.com>
    usb: core: clear both ep_in and ep_out for non-ep0 control endpoints

Myeonghun Pak <mhun512@gmail.com>
    usb: chipidea: tegra: disable runtime PM on resume failure

Yuchao Zhang <ndaugoing@gmail.com>
    usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: dummy-hcd: Fix wait for outstanding request completions

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: aspeed-vhub: cancel wake work on device removal

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    usb: dwc3: am62: Fix runtime PM usage count leak on probe error path

Linkai Gong <gonglinkai@kylinos.cn>
    usb: typec: anx7411 - stop the IRQ before destroying the workqueue

Liu Chao <liuc63@xiaopeng.com>
    usb: gadget: f_uac1_legacy: validate bRequest index in generic_{set,get}_cmd

Takashi Iwai <tiwai@suse.de>
    usb: gadget: midi2: Fix the jack descriptor array sizes

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-st: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-s3c2410: disable controller wakeup on removal

Myeonghun Pak <mhun512@gmail.com>
    usb: ohci-da8xx: disable controller wakeup on cleanup

Orgad Shaneh <orgads@gmail.com>
    usb: octeon-hcd: fix the FIFO-flush timeout computation

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    usb: hub: use shorter 120ms post resume hold for SS root hubs

Syed Labeeq Sajid Bukhari <syedlabeeq@gmail.com>
    usb: storage: sierra_ms: reject short SWoC info transfers

Johan Hovold <johan@kernel.org>
    USB: serial: fix port tear down use-after-free

Yuchao Zhang <ndaugoing@gmail.com>
    USB: cdc-acm: skip URB restart in port_shutdown if disconnected

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix racy TIOCMIWAIT implementation

Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
    soc: qcom: geni-se: Correct QUP Core ICC vote constants

Yuxiao Wang <yuxiao.wang@certik.com>
    nitro_enclaves: fix use-after-free on SLOT_ALLOC failure

Raphaël Larocque <rlarocque@disroot.org>
    Input: synaptics - limit T440p InterTouch quirk to LEN0036

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: synaptics - add LEN205b entry to smbus_pnp_ids for ThinkPad T490

David Heidelberg <david@ixit.cz>
    Input: s6sy761 - fix resume ordering and restore sensing

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    Input: i8042 - add nomux quirk for Fujitsu LIFEBOOK U7410

Martino Papero <martino.papero@lcb.to.it>
    Input: atkbd - skip deactivate for Lenovo IdeaPad Slim 3 15IWC11

Wentao Liang <vulab@iscas.ac.cn>
    kgdboc: Fix tty driver reference leak in configure_kgdboc()

Tomer Pomeranc <tomerpo@gmail.com>
    binder: fix leaked fd fixups on TF_UPDATE_TXN supersede

Tomer Pomeranc <tomerpo@gmail.com>
    binder: fix is_failure flag for superseded transaction cleanup

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix ACP MFD device leak on init failure

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix IP instance memory leak on kobject add failure

Wentao Liang <vulab@iscas.ac.cn>
    drm/mediatek: Fix pdev reference leak in mtk_drm_bind()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/mediatek: Fix ovl adaptor platform device leak

Haojie Li <lihaojie@kylinos.cn>
    drm/mediatek: Add missing IS_ERR check for ovl_adaptor platform device

Imre Kaloz <kaloz@kernel.org>
    drm/radeon: Read the VRAM VBIOS signature with readb()

Willian Oliveira <williandossantosdeoliveira287@gmail.com>
    drm/amdgpu/gfx6: fix firmware leak on teardown

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Fix updating clock limits on AC/DC

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC

Jiangshan Yi <yijiangshan@kylinos.cn>
    drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend

Nikola Prica <nikola.prica@amd.com>
    PCI: Accept AtomicOps already enabled by the hypervisor

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1712: Fix the error handling via auto-cleanup at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Define auto-cleanup for snd_card_free()

Luo Gengkun <luogengkun2@huawei.com>
    perf: Fix race between perf_event_exit_task() and perf_pending_task()

Hongjian Dai <daihongjian@kylinsec.com.cn>
    i2c: at91: release DMA channels when probe defers

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: mvneta: clear XDP pfmemalloc flag between frames

Alexander Lobakin <aleksander.lobakin@intel.com>
    xdp, xsk: constify read-only arguments of some static inline helpers

Eric Dumazet <edumazet@kernel.org>
    ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()

Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
    net/mlx5e: Fix AF_XDP TX timestamp teardown NULL dereference

Quentin Freimanis <quentin@q-lab.dev>
    net: sparx5: make ports inherit the switch base mac address type

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    net: microchip: vcap: stop scanning after deleting key field

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: generalize pending status bit

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: rework offload nf_conn timeout extension logic

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: remove skb argument from nf_ct_refresh

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: bpf: reject invalid NAT manipulation types

Julian Anastasov <ja@ssi.bg>
    ipvs: filter some flags received in the backup server

Julian Anastasov <ja@ssi.bg>
    ipvs: do not create invisible templates

Julian Anastasov <ja@ssi.bg>
    ipvs: fix missing counter decrement in lblc

Jeff Jo <jeffjo@openai.com>
    tcp: refresh TS.Recent for accepted old ACKs

Sandeep Haemoon <sandeeph@loljews.com>
    net: ethernet: mtk_eth_soc: allocate dummy netdev sooner

Jamal Hadi Salim <jhs@mojatatu.com>
    net: cap skb->queue_mapping when the tx queue is picked

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: fix NULL dereference in set_coalesce before first open

Niklas Cassel <cassel@kernel.org>
    virtio_blk: set the zone write granularity

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_codel: match the no-drop threshold to the packet size

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_codel: match the no-drop threshold to the packet size

Eric Dumazet <edumazet@google.com>
    net: restrict SO_RESERVE_MEM to TCP sockets and cap max value

Kuniyuki Iwashima <kuniyu@google.com>
    net-memcg: Introduce mem_cgroup_sk_enabled().

Kuniyuki Iwashima <kuniyu@google.com>
    net-memcg: Introduce mem_cgroup_from_sk().

Kuniyuki Iwashima <kuniyu@google.com>
    net: Clean up __sk_mem_raise_allocated().

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.

Kuniyuki Iwashima <kuniyu@google.com>
    memcg: convert memcg->socket_pressure to u64

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tipc: prevent GCM nonce reuse on peer key changes

Baha Mesleh <baha.mesleh@nokia.com>
    octeontx2-af: mcs: Fix SC resource cleanup loop

Anirudh Virdi <avirdi@redhat.com>
    net/mlx5: Fix slab-out-of-bounds when handling team device events

Rongwei Liu <rongweil@nvidia.com>
    net/mlx5: LAG, Refactor lag logic

Florian Fainelli <florian.fainelli@broadcom.com>
    net: systemport: Fix RUNT MIB counter register offset calculation

Florian Fainelli <florian.fainelli@broadcom.com>
    net: systemport: Fix buffer overflow in bcm_sysport_get_stats()

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_sync: don't drain cmd_sync backlog on unregister

Florian Westphal <fw@strlen.de>
    netfilter: ipset: do not update comments from kernel-side adds

Qishuai Liu <lqs@lqs.me>
    ipv6: fix prefix route expiry in modify_prefix_route()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_api: reclaim an empty proto on the error path

Binbin Deng <18983559317@163.com>
    net/mctp: publish the mctp_dev only after it is initialised

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel: validate DDC record lengths

Sang-Hoon Choi <csh0052@gmail.com>
    Bluetooth: hci_core: free the HCI ID if naming fails

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt274: Fix format setting for 44100 rate

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: rt286: Revert delay value for jack setup

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: prevent AP VLAN tx from other interfaces

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: mac80211: Add 802.3 multicast encapsulation offload support

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: mac80211: Add multicast to unicast support for 802.3 path

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: preserve hidden-group beacon IE ownership

Manush Prajwal <manushprajwal555@gmail.com>
    rtc: mpfs: fix unchecked devm_clk_get() error pointer in probe()

Aamir Ahmed <elb12345@hotmail.co.uk>
    rtc: ac100: Fix clock provider use-after-free on probe failure

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    rtc: Switch back to struct platform_driver::remove()

Liu Dalin <liudalin@kylinsec.com.cn>
    rtc: dev: zero-initialize struct rtc_wkalrm to prevent information leak

Georgios Karantzas <gck.kara@gmail.com>
    wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: ath9k: reject short WMI command responses

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: reset ar->num_stations on hardware start

Sheetal <sheetal@nvidia.com>
    ASoC: tegra: Fix ASRC Stream6 input threshold control

Aamir Ahmed <elb12345@hotmail.co.uk>
    wifi: wfx: validate MIB read length before copying to caller

HyeongJun An <sammiee5311@gmail.com>
    ASoC: wm8903: Move the DRC QR threshold to the register that holds it

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't create "//" paths for fragments targeting the root

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: don't leak fragment references when changeset init fails

Karl Mehltretter <kmehltretter@gmail.com>
    random: fix vgetrandom_opaque_params kernel-doc

Julian Sun <sunjunchao@bytedance.com>
    nvmet: preserve device path on allocation failure

Karl Mehltretter <kmehltretter@gmail.com>
    mtd: core: call _get_device() with the master MTD

Matti Vaittinen <mazziesaccount@gmail.com>
    iio: accel: kionix-kx022a: Fix array boundary check

SJ Park <sj@kernel.org>
    mm/damon/core: don't skip damos_adjust_quota() while esz is not zero

Nathan Chancellor <nathan@kernel.org>
    random: vDSO: avoid call to memset() when zeroing reserved parameter

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    perf/core: Fix WARN in perf_sigtrap()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/secretmem: properly account locked pages

Xiang Mei <xmei5@asu.edu>
    ALSA: line6: reject oversized playback packets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: caiaq: unregister the input device when probe fails

Wentao Liang <vulab@iscas.ac.cn>
    wifi: wlcore: Fix runtime PM leak in wlcore_remove()

Zizhi Wo <wozizhi@huawei.com>
    vt: skip screen update for DEC alignment test on backgroup consoles

Maoyi Xie <maoyixie.tju@gmail.com>
    rds_tcp: close NULL deref window in rds_tcp_set_callbacks

Jiangshan Yi <yijiangshan@kylinos.cn>
    smb: client: clear setuid/setgid bit on write with cifsacl/modefromsid/posix extensions

Zhichen Wang <wangzhichen@manus.ai>
    virt: vmgenid: set driver_data before registering notification handlers

Surendran Kanagaraj <surenkj@amazon.com>
    tpm: Disable TPM on null key name mismatch

Jun Yang <junvyyang@tencent.com>
    sctp: check RCV_SHUTDOWN after the sendmsg connect wait

Runyu Xiao <runyu.xiao@seu.edu.cn>
    rtc: spear: initialize IRQ state before requesting alarm IRQ

Aamir Ahmed <elb12345@hotmail.co.uk>
    rtc: ac100: Assign .num before accessing .hws

Ilkka Lappeteläinen <ilkka.lappetelainen@gmail.com>
    net/packet: prevent TX_RING byte count overflow

Aohan Mei <henrymei@tencent.com>
    netfilter: nft_flow_offload: drop flowtable reference on init error path

Alireza Asgari <alireza@asgari.net>
    net: fix checksum offsets in skb_splice_from_iter()

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: only treat a positive changeset id as registered

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of/overlay: put property on deadprops only after changeset add succeeds

Wentao Liang <vulab@iscas.ac.cn>
    of/irq: Fix remaining refcount leaks in of_irq_init()

Leon Hwang <leon.hwang@linux.dev>
    kprobes: Skip disarmed probes when checking optkprobe overlap

Benjamin Tissoires <bentiss@kernel.org>
    HID: bpf: cast size to ssize_t when checking hid_bpf_hw_request

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    audit: fix exe mark UAF in kill_rules()

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Skip default parms when resumed in neightbl_dump_info().

Darrick J. Wong <djwong@kernel.org>
    xfs: fix cursor and pointer handling when recovering iunlink buckets

Zihan Xi <zihanx@nebusec.ai>
    smb: client: close completed creates on compound wait errors

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: ISO: release unused CIS holds after channel attach

SeungJu Cheon <suunj1331@gmail.com>
    Bluetooth: ISO: Fix data-race on iso_pi(sk) in socket and HCI event paths

Zihan Xi <zihanx@nebusec.ai>
    smb: client: close handle after create-context parsing failure

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: pass cifs_open_info_data to SMB2_open()

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/client: use stack-allocated smb2_file_all_info in smb3_query_mf_symlink()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4/Intel: Add support for library restore firmware functionality

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-priv: Add kernel doc for fw_context_save of sof_ipc4_fw_data

Tibor Harcsa <silurust@gmail.com>
    Bluetooth: btusb: Add IMC Networks QCA9377 to quirks table

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: sdw_utils: Set snd_soc_dai_link_ch_map.codec_ch_mask for capture

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, xdp: move offload check into dev_xdp_install()

Jiakai Xu <jiakaipeanut@gmail.com>
    RISC-V: KVM: Fix null pointer dereference in kvm_riscv_aia_imsic_has_attr()

Darrick J. Wong <djwong@kernel.org>
    xfs: don't let memory failures leak blocks and kill repairs

Namjae Jeon <linkinjeon@kernel.org>
    smb: client: use finish_no_open() for non-regular inodes

Mike Rapoport (Microsoft) <rppt@kernel.org>
    selftests/mm: hugetlb-mremap: add setup of HugeTLB pages

Marc Zyngier <maz@kernel.org>
    KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction

Marc Zyngier <maz@kernel.org>
    KVM: arm64: nv: Fix life cycle of the nested_mmus array

Fan Wu <fanwu01@zju.edu.cn>
    smb: client: fix cifsFileInfo reference leak in deferred close

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()


-------------

Diffstat:

 Documentation/arch/arm64/silicon-errata.rst        |   2 +
 Documentation/filesystems/netfs_library.rst        |  26 ++
 Documentation/netlink/genetlink-c.yaml             |  14 +-
 Documentation/netlink/genetlink-legacy.yaml        |  14 +-
 Documentation/netlink/genetlink.yaml               |  14 +-
 Documentation/netlink/netlink-raw.yaml             |  20 +-
 Documentation/networking/strparser.rst             |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |  30 ++
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |  19 +-
 arch/arm64/include/asm/el2_setup.h                 |   5 +-
 arch/arm64/include/asm/kvm_host.h                  |   2 +-
 arch/arm64/include/asm/kvm_nested.h                |   3 +-
 arch/arm64/kernel/Makefile                         |   3 +
 arch/arm64/kernel/cpu_errata.c                     |  24 +-
 arch/arm64/kernel/cpufeature.c                     |   2 +-
 arch/arm64/kernel/signal.c                         |  85 +++---
 arch/arm64/kernel/topology.c                       |  11 +-
 arch/arm64/kernel/vdso/Makefile                    |   2 +-
 arch/arm64/kvm/arm.c                               |  10 +-
 arch/arm64/kvm/emulate-nested.c                    |   4 -
 arch/arm64/kvm/mmu.c                               |  46 +--
 arch/arm64/kvm/nested.c                            |  95 +++---
 arch/arm64/kvm/vgic/vgic-its.c                     |  22 +-
 arch/arm64/tools/cpucaps                           |   2 +-
 arch/loongarch/vdso/Makefile                       |   1 +
 arch/powerpc/kernel/vdso/Makefile                  |   1 +
 arch/powerpc/perf/imc-pmu.c                        |  23 +-
 arch/riscv/include/asm/scs.h                       |  17 +-
 arch/riscv/kernel/entry.S                          |   2 +-
 arch/riscv/kvm/aia_imsic.c                         |   5 +-
 arch/riscv/mm/extable.c                            |   4 +-
 arch/s390/kernel/vdso64/Makefile                   |   1 +
 arch/x86/entry/vdso/Makefile                       |   1 +
 arch/x86/events/intel/bts.c                        |   2 +-
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/events/intel/p4.c                         |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |   6 +
 arch/x86/kvm/svm/svm.c                             |  12 +-
 arch/x86/kvm/vmx/nested.c                          |   6 +
 crypto/drbg.c                                      |  11 +-
 drivers/android/binder.c                           |   3 +-
 drivers/block/virtio_blk.c                         |   1 +
 drivers/bluetooth/btintel.c                        |  29 +-
 drivers/bluetooth/btintel_pcie.c                   | 138 ++++++---
 drivers/bluetooth/btintel_pcie.h                   |   2 +
 drivers/bluetooth/btusb.c                          |   2 +
 drivers/char/tpm/tpm2-cmd.c                        |   2 +-
 drivers/char/tpm/tpm2-sessions.c                   |   1 +
 drivers/edac/altera_edac.c                         |   4 +-
 drivers/edac/amd64_edac.c                          |   4 +-
 drivers/gpio/gpio-exar.c                           |   2 +-
 drivers/gpio/gpio-xilinx.c                         |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c            |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  77 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |  17 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   5 +
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |   9 +
 drivers/gpu/drm/amd/amdgpu/vi.c                    |  21 ++
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  32 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   7 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   9 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |  20 +-
 drivers/gpu/drm/amd/display/dc/dc.h                |   1 +
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |   1 -
 .../dc/link/protocols/link_edp_panel_control.c     |   4 +-
 .../amd/display/dc/resource/dce80/dce80_resource.c |   1 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  39 +--
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c    |  10 +-
 .../gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c  |  11 +-
 drivers/gpu/drm/aspeed/aspeed_gfx_drv.c            |   5 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   4 +-
 drivers/gpu/drm/drm_fb_helper.c                    |   6 +-
 drivers/gpu/drm/gud/gud_pipe.c                     |   1 +
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/i915/gt/intel_rps.c                |   3 +-
 drivers/gpu/drm/imagination/pvr_mmu.c              |  25 +-
 drivers/gpu/drm/imagination/pvr_vm.c               |   8 +-
 drivers/gpu/drm/mediatek/mtk_drm_drv.c             |  17 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |   3 +
 drivers/gpu/drm/radeon/radeon_bios.c               |   6 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |  29 +-
 drivers/gpu/drm/vc4/vc4_crtc.c                     |   4 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   8 +-
 drivers/gpu/drm/vc4/vc4_drv.h                      |   2 +-
 drivers/gpu/drm/vc4/vc4_gem.c                      |  32 ++-
 drivers/gpu/drm/vc4/vc4_irq.c                      |  16 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_perfmon.c                  |  20 +-
 drivers/gpu/drm/vc4/vc4_render_cl.c                |   2 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |  60 ++--
 drivers/gpu/drm/vc4/vc4_validate.c                 |  10 +-
 drivers/gpu/drm/vc4/vc4_validate_shaders.c         |   2 +-
 drivers/hid/bpf/hid_bpf_dispatch.c                 |   2 +-
 drivers/hid/hid-multitouch.c                       |   2 +-
 drivers/i2c/busses/i2c-at91-master.c               |   8 +-
 drivers/i2c/busses/i2c-xiic.c                      |  98 ++++---
 drivers/iio/accel/kionix-kx022a.c                  |  77 ++---
 drivers/iio/accel/kxcjk-1013.c                     |   2 +-
 drivers/iio/accel/sca3000.c                        |   2 +-
 drivers/iio/adc/ad_sigma_delta.c                   |  27 +-
 drivers/iio/adc/aspeed_adc.c                       |  13 +-
 drivers/iio/adc/axp288_adc.c                       |   8 +
 drivers/iio/adc/max1363.c                          |   8 +
 drivers/iio/adc/pac1934.c                          |   4 +
 drivers/iio/adc/stm32-adc.c                        |  47 +--
 drivers/iio/adc/sun4i-gpadc-iio.c                  |  10 +-
 drivers/iio/adc/xilinx-xadc-core.c                 |   9 +-
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |  16 +-
 drivers/iio/cdc/ad7150.c                           |   8 +-
 drivers/iio/frequency/admv1013.c                   |   9 +-
 drivers/iio/gyro/adis16136.c                       |   2 +-
 drivers/iio/health/max30102.c                      |  12 +-
 drivers/iio/imu/adis16400.c                        |   2 +-
 drivers/iio/imu/adis16480.c                        |   4 +-
 drivers/iio/industrialio-buffer.c                  |   7 +-
 drivers/iio/industrialio-trigger.c                 |   2 +
 drivers/iio/light/gp2ap020a00f.c                   |   2 +
 drivers/iio/light/rohm-bu27034.c                   | 133 ++++-----
 drivers/iio/pressure/bmp280-core.c                 |   2 +-
 drivers/iio/proximity/aw96103.c                    |  30 +-
 drivers/iio/proximity/isl29501.c                   |   2 +-
 drivers/iio/proximity/pulsedlight-lidar-lite-v2.c  |   4 +-
 drivers/iio/proximity/sx9324.c                     |   2 +-
 drivers/iio/proximity/vcnl3020.c                   |  24 +-
 drivers/input/joystick/xpad.c                      |   3 +
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/misc/ati_remote2.c                   |  12 +-
 drivers/input/mouse/synaptics.c                    |   7 +-
 drivers/input/serio/i8042-acpipnpio.h              |   9 +
 drivers/input/touchscreen/s6sy761.c                |  14 +-
 drivers/md/dm-crypt.c                              |   7 +-
 drivers/md/dm-ioctl.c                              |  14 +-
 drivers/md/dm-snap.c                               |  14 +
 drivers/memstick/core/memstick.c                   |   8 +-
 drivers/memstick/host/rtsx_usb_ms.c                |  31 +-
 drivers/mmc/host/cavium-octeon.c                   |   5 +-
 drivers/mmc/host/cavium-thunderx.c                 |   5 +-
 drivers/mmc/host/mtk-sd.c                          |   1 +
 drivers/mmc/host/sdhci-sprd.c                      |   4 +
 drivers/mtd/devices/block2mtd.c                    |   2 +-
 drivers/mtd/mtdcore.c                              |   2 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   6 +-
 drivers/mtd/nand/raw/vf610_nfc.c                   |  85 +++++-
 drivers/mtd/nand/spi/core.c                        |  37 ++-
 drivers/net/amt.c                                  |  48 +---
 drivers/net/can/usb/f81604.c                       |   2 +-
 drivers/net/dsa/microchip/ksz_common.h             |   2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  84 ++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   5 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  22 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   4 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  38 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  13 +-
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 191 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |  24 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |  16 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |  10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   9 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   1 +
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |   1 +
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |   1 +
 .../ethernet/microchip/sparx5/sparx5_tc_matchall.c |   1 +
 drivers/net/ethernet/microchip/vcap/vcap_api.c     |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  10 +-
 drivers/net/pfcp.c                                 |  10 +
 drivers/net/phy/aquantia/aquantia_main.c           |   5 +-
 drivers/net/team/team_mode_broadcast.c             |   2 +
 drivers/net/usb/ax88179_178a.c                     |   6 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/veth.c                                 |   1 +
 drivers/net/wireguard/noise.c                      |   7 +-
 drivers/net/wireguard/queueing.h                   |   2 +
 drivers/net/wireless/ath/ath11k/mac.c              |   1 +
 drivers/net/wireless/ath/ath12k/qmi.c              |   9 +-
 drivers/net/wireless/ath/ath12k/qmi.h              |   3 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  21 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |  16 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  27 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   1 +
 drivers/net/wireless/marvell/libertas/tx.c         |   7 -
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  12 +
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.c   | 134 ++++++---
 .../net/wireless/mediatek/mt76/mt792x_acpi_sar.h   |   2 +
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   3 +
 drivers/net/wireless/silabs/wfx/hif_tx.c           |   4 +-
 drivers/net/wireless/st/cw1200/bh.c                |   8 +-
 drivers/net/wireless/st/cw1200/txrx.c              |  14 +
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/xen-netfront.c                         |  16 +-
 drivers/nvme/host/multipath.c                      |  10 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/target/configfs.c                     |   9 +-
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |   2 +-
 drivers/of/irq.c                                   |   2 +
 drivers/of/overlay.c                               |  17 +-
 drivers/pci/pci.c                                  |  15 +-
 drivers/perf/arm_spe_pmu.c                         |   4 +-
 drivers/pmdomain/imx/imx8m-blk-ctrl.c              |  15 +
 drivers/pmdomain/rockchip/pm-domains.c             |  20 +-
 drivers/ptp/ptp_ocp.c                              |   2 +-
 drivers/regulator/ltc3676.c                        |  15 +-
 drivers/regulator/tps6594-regulator.c              |   6 +-
 drivers/rtc/dev.c                                  |   2 +-
 drivers/rtc/rtc-88pm80x.c                          |   2 +-
 drivers/rtc/rtc-88pm860x.c                         |   2 +-
 drivers/rtc/rtc-ab8500.c                           |   2 +-
 drivers/rtc/rtc-ac100.c                            |  39 +--
 drivers/rtc/rtc-asm9260.c                          |   2 +-
 drivers/rtc/rtc-at91rm9200.c                       |   2 +-
 drivers/rtc/rtc-at91sam9.c                         |   2 +-
 drivers/rtc/rtc-brcmstb-waketimer.c                |   2 +-
 drivers/rtc/rtc-cadence.c                          |   2 +-
 drivers/rtc/rtc-cmos.c                             |   2 +-
 drivers/rtc/rtc-cros-ec.c                          |   2 +-
 drivers/rtc/rtc-ds1685.c                           |   2 +-
 drivers/rtc/rtc-ftrtc010.c                         |   2 +-
 drivers/rtc/rtc-hid-sensor-time.c                  |   2 +-
 drivers/rtc/rtc-imxdi.c                            |   2 +-
 drivers/rtc/rtc-loongson.c                         |   2 +-
 drivers/rtc/rtc-lpc24xx.c                          |   2 +-
 drivers/rtc/rtc-max77686.c                         |   2 +-
 drivers/rtc/rtc-mc13xxx.c                          |   2 +-
 drivers/rtc/rtc-mpc5121.c                          |   2 +-
 drivers/rtc/rtc-mpfs.c                             |   8 +-
 drivers/rtc/rtc-mt7622.c                           |   2 +-
 drivers/rtc/rtc-mv.c                               |   2 +-
 drivers/rtc/rtc-mxc_v2.c                           |   2 +-
 drivers/rtc/rtc-omap.c                             |   2 +-
 drivers/rtc/rtc-palmas.c                           |   2 +-
 drivers/rtc/rtc-pcf50633.c                         |   2 +-
 drivers/rtc/rtc-pic32.c                            |   2 +-
 drivers/rtc/rtc-pm8xxx.c                           |   2 +-
 drivers/rtc/rtc-pxa.c                              |   2 +-
 drivers/rtc/rtc-rc5t583.c                          |   2 +-
 drivers/rtc/rtc-rtd119x.c                          |   2 +-
 drivers/rtc/rtc-rzn1.c                             |   2 +-
 drivers/rtc/rtc-s3c.c                              |   2 +-
 drivers/rtc/rtc-sa1100.c                           |   2 +-
 drivers/rtc/rtc-sh.c                               |   2 +-
 drivers/rtc/rtc-spear.c                            |  13 +-
 drivers/rtc/rtc-stm32.c                            |   2 +-
 drivers/rtc/rtc-stmp3xxx.c                         |   2 +-
 drivers/rtc/rtc-sunplus.c                          |   2 +-
 drivers/rtc/rtc-tegra.c                            |   2 +-
 drivers/rtc/rtc-tps6586x.c                         |   2 +-
 drivers/rtc/rtc-twl.c                              |   2 +-
 drivers/rtc/rtc-vt8500.c                           |   2 +-
 drivers/rtc/rtc-wm8350.c                           |   2 +-
 drivers/rtc/rtc-xgene.c                            |   2 +-
 drivers/rtc/rtc-zynqmp.c                           |   2 +-
 drivers/scsi/qedi/qedi_main.c                      |   3 +-
 drivers/staging/greybus/uart.c                     |   3 +-
 drivers/tee/optee/ffa_abi.c                        |  38 ++-
 drivers/tee/optee/optee_ffa.h                      |  29 +-
 drivers/tee/optee/optee_msg.h                      | 132 ++++++---
 drivers/tee/optee/optee_private.h                  | 120 ++++----
 drivers/tee/optee/optee_smc.h                      |  37 ++-
 drivers/tee/optee/smc_abi.c                        |  17 +-
 drivers/tee/tee_shm.c                              |   4 +
 drivers/thunderbolt/ctl.c                          |  63 ++--
 drivers/thunderbolt/quirks.c                       |   3 +
 drivers/thunderbolt/xdomain.c                      |   4 +
 drivers/tty/amiserial.c                            |   9 +-
 drivers/tty/n_gsm.c                                |  47 +--
 drivers/tty/serial/8250/8250_bcm7271.c             |   2 +-
 drivers/tty/serial/kgdboc.c                        |   9 +
 drivers/tty/serial/ma35d1_serial.c                 |   6 +-
 drivers/tty/serial/max3100.c                       |  13 +-
 drivers/tty/serial/qcom_geni_serial.c              |   5 +-
 drivers/tty/serial/sc16is7xx.c                     |  53 +++-
 drivers/tty/serial/serial-tegra.c                  |  18 +-
 drivers/tty/serial/serial_core.c                   |   4 +-
 drivers/tty/serial/vt8500_serial.c                 |   1 +
 drivers/tty/tty_io.c                               |  54 ++--
 drivers/tty/tty_port.c                             | 205 ++++++-------
 drivers/tty/vcc.c                                  |   5 +-
 drivers/tty/vt/vc_screen.c                         |  50 ++--
 drivers/tty/vt/vt.c                                |   5 +-
 drivers/usb/cdns3/cdns3-gadget.c                   |   4 +
 drivers/usb/cdns3/cdns3-pci-wrap.c                 |   5 +
 drivers/usb/chipidea/ci_hdrc_tegra.c               |   4 +-
 drivers/usb/class/cdc-acm.c                        |  41 +--
 drivers/usb/class/cdc-acm.h                        |   1 -
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/core/message.c                         |   8 +-
 drivers/usb/dwc2/hcd.c                             |   3 +-
 drivers/usb/dwc3/core.h                            |  19 ++
 drivers/usb/dwc3/dwc3-am62.c                       |   1 +
 drivers/usb/dwc3/ep0.c                             |   9 +
 drivers/usb/dwc3/gadget.c                          | 108 ++++++-
 drivers/usb/gadget/function/f_fs.c                 |  15 +-
 drivers/usb/gadget/function/f_midi2.c              |   4 +-
 drivers/usb/gadget/function/f_uac1_legacy.c        |   6 +
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |   4 +
 drivers/usb/gadget/udc/aspeed-vhub/dev.c           |   2 +-
 drivers/usb/gadget/udc/aspeed-vhub/hub.c           |   5 +-
 drivers/usb/gadget/udc/aspeed-vhub/vhub.h          |   1 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |   4 +
 drivers/usb/host/octeon-hcd.c                      |   2 +-
 drivers/usb/host/ohci-da8xx.c                      |   2 +
 drivers/usb/host/ohci-s3c2410.c                    |   1 +
 drivers/usb/host/ohci-spear.c                      |   4 +-
 drivers/usb/host/ohci-st.c                         |   1 +
 drivers/usb/serial/bus.c                           |   6 +-
 drivers/usb/serial/cp210x.c                        |   1 +
 drivers/usb/serial/generic.c                       |  10 +-
 drivers/usb/serial/option.c                        |  14 +
 drivers/usb/serial/quatech2.c                      |  19 +-
 drivers/usb/serial/ssu100.c                        |  18 +-
 drivers/usb/serial/usb-serial.c                    | 127 ++++++--
 drivers/usb/serial/xr_serial.c                     |  10 +-
 drivers/usb/storage/sierra_ms.c                    |   7 +
 drivers/usb/typec/anx7411.c                        |   5 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 drivers/usb/typec/tipd/core.c                      |   8 +-
 drivers/usb/typec/ucsi/displayport.c               |   9 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  17 +-
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |  33 +++
 drivers/usb/typec/ucsi/ucsi_glink.c                |  15 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c          |   1 +
 drivers/virt/vmgenid.c                             |   6 +-
 fs/attr.c                                          |  12 +-
 fs/btrfs/scrub.c                                   |   4 +-
 fs/btrfs/xattr.c                                   |  15 +-
 fs/dcache.c                                        |   4 +-
 fs/ext4/inode.c                                    |   4 -
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/file.c                                     |   4 -
 fs/f2fs/gc.c                                       |  36 ++-
 fs/f2fs/segment.c                                  |  13 +-
 fs/fsopen.c                                        |   3 +
 fs/inode.c                                         |  23 +-
 fs/jfs/jfs_dtree.c                                 |  18 +-
 fs/namei.c                                         |  29 ++
 fs/namespace.c                                     |  87 ++++--
 fs/netfs/buffered_write.c                          |   9 +
 fs/netfs/direct_write.c                            |   9 +
 fs/netfs/internal.h                                |   2 +
 fs/netfs/misc.c                                    |  99 +++++++
 fs/smb/client/cifsfs.c                             |   7 +-
 fs/smb/client/cifsglob.h                           |  10 +-
 fs/smb/client/cifssmb.c                            |   2 +-
 fs/smb/client/dir.c                                |  39 ++-
 fs/smb/client/file.c                               |  17 +-
 fs/smb/client/inode.c                              |  30 +-
 fs/smb/client/link.c                               |  15 +-
 fs/smb/client/smb1ops.c                            |  21 +-
 fs/smb/client/smb2file.c                           |  19 +-
 fs/smb/client/smb2misc.c                           |   9 +-
 fs/smb/client/smb2ops.c                            |  38 ++-
 fs/smb/client/smb2pdu.c                            |  38 +--
 fs/smb/client/smb2proto.h                          |   2 +-
 fs/smb/client/trace.h                              |  16 +-
 fs/smb/client/transport.c                          |  69 +++--
 fs/verity/Kconfig                                  |   3 +
 fs/verity/open.c                                   |   8 -
 fs/xfs/scrub/newbt.c                               |   8 +-
 fs/xfs/xfs_log_recover.c                           |  13 +-
 include/linux/console.h                            |   2 +
 include/linux/fsverity.h                           |  25 --
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/memcontrol.h                         |  50 +++-
 include/linux/netfilter_netdev.h                   |   2 +-
 include/linux/netfs.h                              |   2 +
 include/linux/nvme.h                               |   4 +-
 include/linux/pagemap.h                            |  16 +-
 include/linux/perf_event.h                         |  17 +-
 include/linux/rtnetlink.h                          |   7 +-
 include/linux/sched/user.h                         |   3 +-
 include/linux/security.h                           |   5 +-
 include/linux/skbuff.h                             |   2 +-
 include/linux/soc/qcom/geni-se.h                   |  15 +-
 include/linux/tty.h                                |   1 +
 include/linux/tty_driver.h                         |   6 +
 include/linux/tty_port.h                           |  30 +-
 include/linux/usb/serial.h                         |   1 +
 include/net/amt.h                                  |   4 -
 include/net/bluetooth/hci_core.h                   |   5 +-
 include/net/ip.h                                   |   7 +
 include/net/mac80211.h                             |   4 +
 include/net/netfilter/nf_conntrack.h               |  18 +-
 include/net/netfilter/nf_flow_table.h              |   2 +-
 include/net/proto_memory.h                         |   2 +-
 include/net/sch_generic.h                          |   9 +
 include/net/sock.h                                 |  22 ++
 include/net/strparser.h                            |  10 +-
 include/net/tcp.h                                  |   2 +-
 include/net/xdp.h                                  |  34 ++-
 include/net/xdp_sock_drv.h                         |  11 +-
 include/net/xsk_buff_pool.h                        |   2 +-
 include/sound/core.h                               |   9 +
 include/sound/sof/ipc4/header.h                    |   2 +
 include/uapi/linux/random.h                        |   2 +-
 init/Kconfig                                       |   5 +
 io_uring/io_uring.c                                |   7 +-
 io_uring/waitid.c                                  |  19 +-
 kernel/audit_tree.c                                |  36 ++-
 kernel/cgroup/cpuset.c                             | 134 +++++----
 kernel/dma/swiotlb.c                               |   6 +-
 kernel/events/core.c                               | 318 +++++++++------------
 kernel/events/ring_buffer.c                        |   7 +-
 kernel/kprobes.c                                   |   8 +-
 kernel/trace/trace_event_perf.c                    |   4 +-
 kernel/workqueue.c                                 |   2 +-
 mm/damon/core.c                                    |  48 ++--
 mm/memcontrol.c                                    |  27 +-
 mm/secretmem.c                                     | 117 +++++++-
 mm/shmem.c                                         |  70 ++---
 mm/vmpressure.c                                    |   2 +-
 net/bluetooth/hci_conn.c                           |  18 +-
 net/bluetooth/hci_core.c                           |  55 +++-
 net/bluetooth/hci_debugfs.c                        |   2 +-
 net/bluetooth/hci_event.c                          |   7 +
 net/bluetooth/hci_sock.c                           |   2 +
 net/bluetooth/hci_sync.c                           |  19 +-
 net/bluetooth/iso.c                                | 153 +++++++---
 net/bluetooth/mgmt.c                               |   2 +-
 net/bluetooth/rfcomm/sock.c                        |   5 +-
 net/bluetooth/rfcomm/tty.c                         |   9 +-
 net/bluetooth/smp.c                                |   2 +
 net/bridge/br_multicast.c                          |  23 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |  10 +-
 net/core/dev.c                                     | 137 +++++----
 net/core/flow_dissector.c                          |  11 +-
 net/core/neighbour.c                               |  12 +-
 net/core/netdev-genl-gen.c                         |   4 +-
 net/core/skbuff.c                                  |  14 +-
 net/core/sock.c                                    |  15 +-
 net/devlink/core.c                                 |  10 +-
 net/ipv4/af_inet.c                                 |   2 +-
 net/ipv4/cipso_ipv4.c                              |   8 +
 net/ipv4/fib_semantics.c                           |   3 +
 net/ipv4/fib_trie.c                                |   2 -
 net/ipv4/inet_connection_sock.c                    |   2 +-
 net/ipv4/ip_output.c                               |  10 +-
 net/ipv4/route.c                                   |   5 +
 net/ipv4/tcp.c                                     |   2 +
 net/ipv4/tcp_input.c                               |   6 +
 net/ipv4/tcp_ipv4.c                                |   2 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/addrconf.c                                |   2 +-
 net/ipv6/ip6_output.c                              |  29 +-
 net/ipv6/route.c                                   |   2 -
 net/ipv6/seg6_iptunnel.c                           |   2 +-
 net/mac80211/agg-rx.c                              |   2 +-
 net/mac80211/chan.c                                |  45 ++-
 net/mac80211/fils_aead.c                           |   8 +
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/mesh_pathtbl.c                        |  30 +-
 net/mac80211/mlme.c                                |   4 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  30 +-
 net/mac80211/spectmgmt.c                           |   4 +-
 net/mac80211/sta_info.c                            |   6 +-
 net/mac80211/tx.c                                  | 128 +++++++--
 net/mctp/device.c                                  |   6 +-
 net/mptcp/protocol.c                               |  10 +-
 net/mptcp/subflow.c                                |  11 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   3 +
 net/netfilter/ipvs/ip_vs_lblc.c                    |   4 +
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   3 +
 net/netfilter/ipvs/ip_vs_sync.c                    |  33 ++-
 net/netfilter/nf_conntrack_amanda.c                |   2 +-
 net/netfilter/nf_conntrack_broadcast.c             |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  13 +-
 net/netfilter/nf_conntrack_h323_main.c             |   4 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_flow_table_core.c                 | 123 +++++++-
 net/netfilter/nf_flow_table_offload.c              |  14 +-
 net/netfilter/nf_nat_bpf.c                         |   3 +
 net/netfilter/nf_nat_core.c                        |   5 +-
 net/netfilter/nfnetlink_queue.c                    |   7 +
 net/netfilter/nft_ct.c                             |   2 +-
 net/netfilter/nft_flow_offload.c                   |   7 +-
 net/netfilter/xt_CHECKSUM.c                        |   6 +-
 net/openvswitch/actions.c                          |   7 +-
 net/openvswitch/datapath.c                         |   8 +
 net/packet/af_packet.c                             |  31 +-
 net/rds/tcp.c                                      |   9 +-
 net/sched/act_ct.c                                 |   2 +-
 net/sched/act_skbedit.c                            |   5 +-
 net/sched/cls_api.c                                |  15 +-
 net/sched/cls_route.c                              |   6 +
 net/sched/em_text.c                                |   3 +
 net/sched/sch_codel.c                              |   2 +-
 net/sched/sch_fq_codel.c                           |   4 +-
 net/sctp/socket.c                                  |   8 +-
 net/smc/af_smc.c                                   |   7 +-
 net/strparser/strparser.c                          |   6 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   8 +-
 net/tipc/crypto.c                                  |  20 +-
 net/tipc/node.c                                    |  10 +-
 net/tipc/topsrv.c                                  |  80 +++++-
 net/vmw_vsock/af_vsock.c                           |   2 +
 net/vmw_vsock/virtio_transport_common.c            |   4 +-
 net/wireless/scan.c                                |  22 +-
 net/xfrm/xfrm_output.c                             |  16 +-
 security/keys/key.c                                |   6 +-
 security/keys/persistent.c                         |  55 ++--
 security/security.c                                |   5 +-
 security/selinux/avc.c                             |   5 +-
 security/selinux/hooks.c                           |  11 +-
 sound/core/seq/seq_compat.c                        |   4 +-
 sound/pci/hda/hda_tegra.c                          |   3 +-
 sound/pci/ice1712/ice1712.c                        |   2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/adau1372.c                        |  18 +-
 sound/soc/codecs/max98363.c                        |   2 +-
 sound/soc/codecs/rt1017-sdca-sdw.c                 |  27 +-
 sound/soc/codecs/rt274.c                           |   4 +-
 sound/soc/codecs/rt286.c                           |   2 +-
 sound/soc/codecs/wm8903.c                          |   2 +-
 sound/soc/qcom/lpass-cpu.c                         |   4 +-
 sound/soc/samsung/i2s.c                            |   8 +
 sound/soc/sdw_utils/soc_sdw_utils.c                |  20 +-
 sound/soc/sof/intel/hda-loader.c                   |   7 +-
 sound/soc/sof/ipc4-loader.c                        |   6 +
 sound/soc/sof/ipc4-priv.h                          |   3 +
 sound/soc/sof/ipc4.c                               |  14 +-
 sound/soc/tegra/tegra186_asrc.c                    |   2 +-
 sound/usb/caiaq/device.c                           |   3 +
 sound/usb/line6/playback.c                         |   7 +
 sound/usb/misc/ua101.c                             |   9 +
 sound/usb/quirks.c                                 |   4 +-
 tools/net/ynl/ynl-gen-c.py                         |  70 ++++-
 tools/testing/selftests/mm/hugepage-mremap.c       |   5 +
 tools/testing/selftests/mm/memfd_secret.c          |  30 +-
 544 files changed, 5630 insertions(+), 2793 deletions(-)


