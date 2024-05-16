Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8F314373A;
	Thu, 16 May 2024 09:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715850822; cv=none; b=f3JUFouPNy0RYci1zuCrhyyT30cmE8l39i9d2F0r5RWlanUzpGvt3FXM2A8+D8pGO/RvPox2JF8Kes4LHY7Z5fBonrGhjyaYFWMa2uhXcspUUxRW9vg0tQJpNEsQCGrTXpJ0n5T25cGizF9Y02VEA6vzxF48e09+vfc1ubsohbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715850822; c=relaxed/simple;
	bh=AwufYy0FU1v6z1fJK63qyqXWG6vBsC+ZvRgrCUCfPWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ArbymPnjsQC795nI6aFd6M5C4Ue8DeaVfWExQdoJ2U18bmQnlF6HON/OAu9dN0uSklKNnTq+P/V+bn5fxXew5O0GbMCwBAUJ9XSshjQPv8BQAk36dTsQ/1ZQq0bF5toDlFZ8Nav1KTQI8FbbkvAH3ucUZk7x+Y8yd+hAnM6U8Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brY405pc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brY405pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1049C113CC;
	Thu, 16 May 2024 09:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715850821;
	bh=AwufYy0FU1v6z1fJK63qyqXWG6vBsC+ZvRgrCUCfPWA=;
	h=From:To:Cc:Subject:Date:From;
	b=brY405pcNKGV9H78aY4srbiYbw7bBRduhq4KYKVicFDUbCJab4t999cX01MXrECZ0
	 V7fLIZpcbeWK7MngWuJaMfLuDEb/ohLtKRSlgI4KHbBEWlmBNc6by1qzkN+96a2us1
	 THtkJRo6YdvZE7fgkVoxU/vR1a4XgSmj43y1U0MM=
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
Subject: [PATCH 6.1 000/244] 6.1.91-rc3 review
Date: Thu, 16 May 2024 11:13:37 +0200
Message-ID: <20240516091232.619851361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.91-rc3
X-KernelTest-Deadline: 2024-05-18T09:12+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.91 release.
There are 244 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 May 2024 09:11:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.91-rc3

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize UMAC_CMD access

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Clear RGMII_LINK upon link down

Li Nan <linan122@huawei.com>
    md: fix kmemleak of rdev->serial

Oscar Salvador <osalvador@suse.de>
    mm,swapops: update check in is_pfn_swap_entry for hwpoison entries

Miaohe Lin <linmiaohe@huawei.com>
    mm/hugetlb: fix DEBUG_LOCKS_WARN_ON(1) when dissolve_free_hugetlb_folio()

Qu Wenruo <wqu@suse.com>
    btrfs: do not wait for short bulk allocation

Silvio Gissi <sifonsec@amazon.com>
    keys: Fix overwrite of key expiration on instantiation

Nikhil Rao <nikhil.rao@intel.com>
    dmaengine: idxd: add a write() method for applications to submit work

Arjan van de Ven <arjan@linux.intel.com>
    dmaengine: idxd: add a new security check to deal with a hardware erratum

Arjan van de Ven <arjan@linux.intel.com>
    VFIO: Add the SPR_DSA and SPR_IAX devices to the denylist

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix firmware check error path

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix info leak when fetching fw build id

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix info leak when fetching board id

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix NVM configuration parsing

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: add missing firmware sanity checks

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: do not grant v2 lease if parent lease key and epoch are not set

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: avoid to send duplicate lease break notifications

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: off ipv6only for both ipv4/ipv6 binding

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: fix setting spi bus clock rate

Johan Hovold <johan+linaro@kernel.org>
    regulator: core: fix debugfs creation regression

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: use memalloc_nofs_save() in page_cache_ra_order()

Lakshmi Yadlapati <lakshmiy@us.ibm.com>
    hwmon: (pmbus/ucd9000) Increase delay from 250 to 500us

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    net: fix out-of-bounds access in ops_init

George Shen <george.shen@amd.com>
    drm/amd/display: Handle Y carry-over in VCP X.Y calculation

Karthikeyan Ramasubramanian <kramasub@chromium.org>
    drm/i915/bios: Fix parsing backlight BDB data

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix invalid reads in fence signaled events

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: don't allow mapping the MMIO HDP page with large pages

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add lunar lake point M DID

Viken Dadhaniya <quic_vdadhani@quicinc.com>
    slimbus: qcom-ngd-ctrl: Add timeout for wait operation

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix old BUG_ON in >control parser

Joao Paulo Goncalves <joao.goncalves@toradex.com>
    ASoC: ti: davinci-mcasp: Fix race condition during probe

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix DSPK 16-bit playback

Paolo Abeni <pabeni@redhat.com>
    tipc: fix UAF in error path

Alexander Potapenko <glider@google.com>
    kmsan: compiler_types: declare __no_sanitize_or_inline

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Interrupt handling fixes

Ramona Gradinariu <ramona.bolboaca13@gmail.com>
    iio:imu: adis16475: Fix sync mode setting

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    dt-bindings: iio: health: maxim,max30102: fix compatible check

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_nxt is properly initialized on connect

Dan Carpenter <dan.carpenter@linaro.org>
    mm/slab: make __free(kfree) accept error pointers

Dominique Martinet <dominique.martinet@atmark-techno.com>
    btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()

Aman Dhoot <amandhoot12@gmail.com>
    ALSA: hda/realtek: Fix mute led of HP Laptop 15-da3001TU

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Check for port partner validity before consuming it

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: unregister existing source caps before re-registration

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Prevent phy suspend during init

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: xhci-plat: Don't include xhci.h

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: f_fs: Fix a race condition when processing setup packets.

Peter Korsgaard <peter@korsgaard.com>
    usb: gadget: composite: fix OS descriptors w_value logic

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix access violation during port device removal

Guenter Roeck <linux@roeck-us.net>
    usb: ohci: Prevent missed ohci interrupts

Alan Stern <stern@rowland.harvard.edu>
    usb: Fix regression caused by invalid ep0 maxpacket in virtual SuperSpeed device

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Fix connector check on init

Christian A. Ehrhardt <lk@c--e.de>
    usb: typec: ucsi: Check for notifications after init

Benno Lossin <benno.lossin@proton.me>
    rust: macros: fix soundness issue in `module!` macro

Thomas Bertschinger <tahbertschinger@gmail.com>
    rust: module: place generated init_module() function in .init.text

Andrea Righi <andrea.righi@canonical.com>
    btf, scripts: rust: drop is_rust_module.sh

Andrea Righi <andrea.righi@canonical.com>
    rust: fix regexp in scripts/is_rust_module.sh

Asahi Lina <lina@asahilina.net>
    rust: error: Rename to_kernel_errno() -> to_errno()

Linus Torvalds <torvalds@linux-foundation.org>
    Reapply "drm/qxl: simplify qxl_fence_wait"

Thanassis Avgerinos <thanassis.avgerinos@gmail.com>
    firewire: nosy: ensure user_length is taken into account when fetching packet contents

Dmitry Antipov <dmantipov@yandex.ru>
    btrfs: fix kvcalloc() arguments order in btrfs_ioctl_send()

Christian König <christian.koenig@amd.com>
    drm/amdgpu: once more fix the call oder in amdgpu_ttm_move() v2

Leah Rumancik <leah.rumancik@gmail.com>
    MAINTAINERS: add leah to 6.1 MAINTAINERS file

Gabe Teeger <gabe.teeger@amd.com>
    drm/amd/display: Atom Integrated System Info v2_2 for DCN35

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: fix uninitialised kfifo

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: relocate debounce_period_us from struct gpio_desc

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: cdev: Add missing header(s)

Mario Limonciello <mario.limonciello@amd.com>
    dm/amd/pm: Fix problems with reboot/shutdown for some SMU 13.0.4/13.0.11 users

Douglas Anderson <dianders@chromium.org>
    drm/connector: Add \n to message about demoting connector force-probes

Jerome Brunet <jbrunet@baylibre.com>
    drm/meson: dw-hdmi: add bandgap setting for g12

Jerome Brunet <jbrunet@baylibre.com>
    drm/meson: dw-hdmi: power up phy on device init

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix kernel crash when devlink reload during initialization

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix port vlan filter not disabled issue

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: use appropriate barrier function after setting a bit value

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: release PTP resources if pf initialization failed

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: change type of numa_node_mask as nodemask_t

Jian Shen <shenjian15@huawei.com>
    net: hns3: direct return when receive a unknown mailbox message

Peiyang Wang <wangpeiyang1@huawei.com>
    net: hns3: using user configure after hardware reset

Wen Gu <guwen@linux.alibaba.com>
    net/smc: fix neighbour and rtable leak in smc_ib_find_route()

Eric Dumazet <edumazet@google.com>
    ipv6: prevent NULL dereference in ip6_output()

Eric Dumazet <edumazet@google.com>
    ipv6: annotate data-races around cnf.disable_ipv6

Lukasz Majewski <lukma@denx.de>
    hsr: Simplify code for announcing HSR nodes timer setup

Eric Dumazet <edumazet@google.com>
    net-sysfs: convert dev->operstate reads to lockless ones

Thomas Gleixner <tglx@linutronix.de>
    timers: Rename del_timer() to timer_delete()

Thomas Gleixner <tglx@linutronix.de>
    timers: Get rid of del_singleshot_timer_sync()

Eric Dumazet <edumazet@google.com>
    ipv6: fib6_rules: avoid possible NULL dereference in fib6_rule_action()

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix corrupted ethernet header on multicast-to-unicast

Eric Dumazet <edumazet@google.com>
    phonet: fix rtm_phonet_notify() skb allocation

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (corsair-cpro) Protect ccp->wait_input_report with a spinlock

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (corsair-cpro) Use complete_all() instead of complete() in ccp_raw_event()

Aleksa Savic <savicaleksa83@gmail.com>
    hwmon: (corsair-cpro) Use a separate buffer for sending commands

Roded Zats <rzats@paloaltonetworks.com>
    rtnetlink: Correct nested IFLA_VF_VLAN_LIST attribute validation

Marek Vasut <marex@denx.de>
    net: ks8851: Queue RX packets in IRQ handler instead of disabling BHs

Duoming Zhou <duoming@zju.edu.cn>
    Bluetooth: l2cap: fix null-ptr-deref in l2cap_chan_timeout

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: msft: fix slab-use-after-free in msft_do_close()

Duoming Zhou <duoming@zju.edu.cn>
    Bluetooth: Fix use-after-free bugs caused by sco_sock_timeout

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Use refcount_inc_not_zero() in tcp_twsk_unique().

Eric Dumazet <edumazet@google.com>
    tcp: defer shutdown(SEND_SHUTDOWN) for TCP_SYN_RECV sockets

Boy.Wu <boy.wu@mediatek.com>
    ARM: 9381/1: kasan: clear stale stack poison

Paul Davey <paul.davey@alliedtelesis.co.nz>
    xfrm: Preserve vlan tags for transport mode software GRO

Al Viro <viro@zeniv.linux.org.uk>
    qibfs: fix dentry leak

Namhyung Kim <namhyung@kernel.org>
    perf unwind-libdw: Handle JIT-generated DSOs properly

Namhyung Kim <namhyung@kernel.org>
    perf unwind-libunwind: Fix base address for .eh_frame

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: Merge spi_controller.{slave,target}_abort()

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust: avoid creating temporary files

Vanillan Wang <vanillanwang@163.com>
    net:usb:qmi_wwan: support Rolling modules

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dp: Don't probe eDP ports twice harder

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: drop inodes immediately on non-.L too

Stephen Boyd <sboyd@kernel.org>
    clk: Don't hold prepare_lock when calling kref_put()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: crystalcove: Use -ENOTSUPP consistently

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: wcove: Use -ENOTSUPP consistently

Jeff Layton <jlayton@kernel.org>
    9p: explicitly deny setlease attempts

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: translate O_TRUNC into OTRUNC

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: only translate RWX permissions for plain 9P2000

Krzysztof Kozlowski <krzk@kernel.org>
    iommu: mtk: fix module autoloading

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't free ring buffers that couldn't be re-encrypted

Rick Edgecombe <rick.p.edgecombe@intel.com>
    uio_hv_generic: Don't free decrypted memory

Rick Edgecombe <rick.p.edgecombe@intel.com>
    Drivers: hv: vmbus: Track decrypted status in vmbus_gpadl

John Stultz <jstultz@google.com>
    selftests: timers: Fix valid-adjtimex signed left-shift undefined behavior

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Refine IB schedule error logging

Justin Ernst <justin.ernst@hpe.com>
    tools/power/turbostat: Fix uncore frequency file string

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: scall: Save thread_info.syscall unconditionally on entry

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Do not setup DMA for virtual devices

Rik van Riel <riel@surriel.com>
    blk-iocost: avoid out of bounds shift

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix SELinux error when systemd-modules loads the target module

Wei Yang <richard.weiyang@gmail.com>
    memblock tests: fix undefined reference to `BIT'

Wei Yang <richard.weiyang@gmail.com>
    memblock tests: fix undefined reference to `panic'

Wei Yang <richard.weiyang@gmail.com>
    memblock tests: fix undefined reference to `early_pfn_to_nid'

Boris Burkov <boris@bur.io>
    btrfs: always clear PERTRANS metadata during commit

Boris Burkov <boris@bur.io>
    btrfs: make btrfs_clear_delalloc_extent() free delalloc reserve

Peng Liu <liupeng17@lenovo.com>
    tools/power turbostat: Fix Bzy_MHz documentation typo

Wyes Karny <wyes.karny@amd.com>
    tools/power turbostat: Increase the limit for fd opened

Doug Smythies <dsmythies@telus.net>
    tools/power turbostat: Fix added raw MSR output

Adam Goldman <adamg@pobox.com>
    firewire: ohci: mask bus reset interrupts between ISR and bottom half

Chen Ni <nichen@iscas.ac.cn>
    ata: sata_gemini: Check clk_enable() result

Phil Elwell <phil@raspberrypi.com>
    net: bcmgenet: Reset RBUF on first open

Li Nan <linan122@huawei.com>
    block: fix overflow in blk_ioctl_discard()

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Zero-initialize message buffers

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: WLUN suspend dev/link state error recovery

Borislav Petkov (AMD) <bp@alien8.de>
    kbuild: Disable KCSAN for autogenerated *.mod.c intermediaries

Andrei Matei <andreimatei1@gmail.com>
    bpf: Check bloom filter map value size

Anand Jain <anand.jain@oracle.com>
    btrfs: return accurate error code on open failure in open_fs_devices()

Saurav Kashyap <skashyap@marvell.com>
    scsi: bnx2fc: Remove spin_lock_bh while releasing resources after upload

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Avoid memcpy field-spanning write WARNING

linke li <lilinke99@qq.com>
    net: mark racy access on sk->sk_rcvbuf

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix rdev_dump_mpp() arguments order

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: mac80211: fix ieee80211_bss_*_flags kernel-doc

Andrew Price <anprice@redhat.com>
    gfs2: Fix invalid metadata access in punch_hole

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Release hbalock before calling lpfc_worker_wake_up()

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port()

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Update lpfc_ramp_down_queue_handler() logic

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Move NPIV's transport unregistration to after resource clean up

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: LPAR panics during boot up with a frozen PE

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: make max polling consistent for longer H_CALLs

Russell Currey <ruscur@russell.cc>
    powerpc/pseries: Move PLPKS constants to header file

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: replace kmalloc with kzalloc in PLPKS driver

Jernej Skrabec <jernej.skrabec@gmail.com>
    clk: sunxi-ng: h6: Reparent CPUX during PLL CPUX rate change

Richard Gobert <richardbgobert@gmail.com>
    net: gro: add flush check in udp_gro_receive_segment

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/panel: ili9341: Use predefined error codes

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/panel: ili9341: Respect deferred probe

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix kernel panic after setting hsuid

Guillaume Nault <gnault@redhat.com>
    vxlan: Pull inner IP header in vxlan_rcv().

Xin Long <lucien.xin@gmail.com>
    tipc: fix a possible memleak in tipc_buf_append

Felix Fietkau <nbd@nbd.name>
    net: core: reject skb_copy(_expand) for fraglist GSO skbs

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix multicast-to-unicast with fraglist GSO

Mans Rullgard <mans@mansr.com>
    spi: fix null pointer dereference within spi_sync

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    cxgb4: Properly lock TX queue for the selftest.

Bui Quang Minh <minhquangbui99@gmail.com>
    s390/cio: Ensure the copied buf is NUL terminated

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: intel-sdw-acpi: fix usage of device_get_named_child_node()

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: cards: select SND_DYNAMIC_MINORS

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-tdm-interface: manage formatters in trigger

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-card: make links nonatomic

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: use threaded irq to check periods

Jerome Brunet <jbrunet@baylibre.com>
    ASoC: meson: axg-fifo: use FIELD helpers

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_actions()

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flow_spec

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flower

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: sanitize 'rc' in qede_add_tc_flower_fltr()

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Add CFI for RA register to asm macro vdso_func

David Bauer <mail@david-bauer.net>
    net l2tp: drop flow hash on forward

Kuniyuki Iwashima <kuniyu@amazon.com>
    nsh: Restore skb->{protocol,data,mac_header} for outer header in nsh_gso_segment().

Bui Quang Minh <minhquangbui99@gmail.com>
    octeontx2-af: avoid off-by-one read from userspace

Bui Quang Minh <minhquangbui99@gmail.com>
    bna: ensure the copied buf is NUL terminated

Toke Høiland-Jørgensen <toke@redhat.com>
    xdp: use flags field to disambiguate broadcast redirect

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix clearing storage keys for huge pages

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix storage key clearing for guest huge pages

Xu Kuohai <xukuohai@huawei.com>
    bpf, arm64: Fix incorrect runtime stats

Devyn Liu <liudingyuan@huawei.com>
    spi: hisi-kunpeng: Delete the dump interface of data registers in debugfs

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: fix version format string

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: use common AXI macros

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: move msg state to new struct

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: use devm_spi_alloc_host()

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: simplify driver data allocation

Li Zetao <lizetao1@huawei.com>
    spi: spi-axi-spi-engine: Use helper function devm_clk_get_enabled()

Yang Yingliang <yangyingliang@huawei.com>
    spi: spi-axi-spi-engine: switch to use modern name

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: axi-spi-engine: Convert to platform remove callback returning void

Yang Yingliang <yangyingliang@huawei.com>
    spi: introduce new helpers with using modern naming

Anton Protopopov <aspsk@isovalent.com>
    bpf: Fix a verifier verbose message

Yi Zhang <yi.zhang@redhat.com>
    nvme: fix warn output about shared namespaces without CONFIG_NVME_MULTIPATH

Jason Xing <kernelxing@tencent.com>
    bpf, skmsg: Fix NULL pointer dereference in sk_psock_skb_ingress_enqueue

Andrii Nakryiko <andrii@kernel.org>
    bpf, kconfig: Fix DEBUG_INFO_BTF_MODULES Kconfig definition

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: change devm_regulator_get_enable_optional() stub to return Ok

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: change stubbed devm_regulator_get_enable to return Ok

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    regulator: mt6360: De-capitalize devicetree regulator subnodes

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    power: supply: mt6360_charger: Fix of_match for usb-otg-vbus regulator

Arnd Bergmann <arnd@arndb.de>
    power: rt9455: hide unused rt9455_boost_voltage_values

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Fix selecting gpio pinctrl state

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Make use of struct pinfunction and PINCTRL_PINFUNCTION()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: Introduce struct pinfunction and PINCTRL_PINFUNCTION() macro

Kuniyuki Iwashima <kuniyu@amazon.com>
    nfs: Handle error of rpc_proc_register() in nfs_net_init().

Josef Bacik <josef@toxicpanda.com>
    nfs: make the rpc_stat per net namespace

Josef Bacik <josef@toxicpanda.com>
    nfs: expose /proc/net/sunrpc/nfs in net namespaces

Josef Bacik <josef@toxicpanda.com>
    sunrpc: add a struct rpc_stats arg to rpc_create_args

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: Fix PIN_CONFIG_INPUT_SCHMITT_ENABLE readback

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: core: delete incorrect free in pinctrl_enable()

Jan Dakinevich <jan.dakinevich@salutedevices.com>
    pinctrl/meson: fix typo in PDM's pin name

Billy Tsai <billy_tsai@aspeedtech.com>
    pinctrl: pinctrl-aspeed-g6: Fix register offset for pinconf of GPIOR-T

Steve French <stfrench@microsoft.com>
    smb3: missing lock when picking channel

Shyam Prasad N <sprasad@microsoft.com>
    cifs: use the least loaded channel for sending requests

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: specify output names separately for each emission type from rustc

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: refactor host*_flags

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix missing hugetlb_lock for resv uncharge

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb_cgroup: convert hugetlb_cgroup_uncharge_page() to folios

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb: convert free_huge_page to folios

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb_cgroup: convert hugetlb_cgroup_from_page() to folios

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb_cgroup: convert __set_hugetlb_cgroup() to folios

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb: add folio_hstate()

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb: add hugetlb_folio_subpool() helpers

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm: add private field of first tail to struct page and struct folio

Sidhartha Kumar <sidhartha.kumar@oracle.com>
    mm/hugetlb: add folio support to hugetlb specific flag macros

Tim Jiang <quic_tjiang@quicinc.com>
    Bluetooth: qca: add support for QCA2066

Daniel Okazaki <dtokazaki@google.com>
    eeprom: at24: fix memory corruption race condition

Heiner Kallweit <hkallweit1@gmail.com>
    eeprom: at24: Probe for DDR3 thermal sensor in the SPD case

Alexander Stein <alexander.stein@ew.tq-group.com>
    eeprom: at24: Use dev_err_probe for nvmem register failure

Wedson Almeida Filho <walmeida@microsoft.com>
    rust: kernel: require `Send` for `Module` implementations

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't free NULL coalescing rule

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"

Bumyong Lee <bumyong.lee@samsung.com>
    dmaengine: pl330: issue_pending waits until WFP state


-------------

Diffstat:

 .../bindings/iio/health/maxim,max30102.yaml        |   2 +-
 MAINTAINERS                                        |   1 +
 Makefile                                           |   4 +-
 arch/arm/kernel/sleep.S                            |   4 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  12 +-
 arch/arm64/net/bpf_jit_comp.c                      |   6 +-
 arch/mips/include/asm/ptrace.h                     |   2 +-
 arch/mips/kernel/asm-offsets.c                     |   1 +
 arch/mips/kernel/ptrace.c                          |  15 +-
 arch/mips/kernel/scall32-o32.S                     |  23 +-
 arch/mips/kernel/scall64-n32.S                     |   3 +-
 arch/mips/kernel/scall64-n64.S                     |   3 +-
 arch/mips/kernel/scall64-o32.S                     |  33 +--
 arch/powerpc/platforms/pseries/iommu.c             |   8 +
 arch/powerpc/platforms/pseries/plpks.c             |  62 ++---
 arch/powerpc/platforms/pseries/plpks.h             |  35 ++-
 arch/s390/include/asm/dwarf.h                      |   1 +
 arch/s390/kernel/vdso64/vdso_user_wrapper.S        |   2 +
 arch/s390/mm/gmap.c                                |   2 +-
 arch/s390/mm/hugetlbpage.c                         |   2 +-
 block/blk-iocost.c                                 |   7 +-
 block/ioctl.c                                      |   5 +-
 drivers/ata/sata_gemini.c                          |   5 +-
 drivers/bluetooth/btqca.c                          | 162 +++++++++++-
 drivers/bluetooth/btqca.h                          |   6 +-
 drivers/bluetooth/hci_qca.c                        |  11 +
 drivers/char/tpm/tpm-dev-common.c                  |   4 +-
 drivers/clk/clk.c                                  |  12 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |  19 +-
 drivers/dma/idxd/cdev.c                            |  77 ++++++
 drivers/dma/idxd/idxd.h                            |   3 +
 drivers/dma/idxd/init.c                            |   4 +
 drivers/dma/idxd/registers.h                       |   3 -
 drivers/dma/idxd/sysfs.c                           |  27 +-
 drivers/firewire/nosy.c                            |   6 +-
 drivers/firewire/ohci.c                            |   6 +-
 drivers/gpio/gpio-crystalcove.c                    |   2 +-
 drivers/gpio/gpio-wcove.c                          |   2 +-
 drivers/gpio/gpiolib-cdev.c                        | 183 ++++++++++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  52 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   7 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   1 +
 .../display/dc/dcn31/dcn31_hpo_dp_link_encoder.c   |   6 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c   |   2 +-
 drivers/gpu/drm/drm_connector.c                    |   2 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |  19 +-
 drivers/gpu/drm/i915/display/intel_vbt_defs.h      |   5 -
 drivers/gpu/drm/meson/meson_dw_hdmi.c              |  70 +++---
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  13 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c       |   8 +-
 drivers/gpu/drm/qxl/qxl_release.c                  |  50 +---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |   2 +-
 drivers/gpu/host1x/bus.c                           |   8 -
 drivers/hv/channel.c                               |  29 ++-
 drivers/hwmon/corsair-cpro.c                       |  43 +++-
 drivers/hwmon/pmbus/ucd9000.c                      |   6 +-
 drivers/iio/accel/mxc4005.c                        |  24 +-
 drivers/iio/imu/adis16475.c                        |   4 +-
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/iommu/mtk_iommu.c                          |   1 +
 drivers/iommu/mtk_iommu_v1.c                       |   1 +
 drivers/md/md.c                                    |   1 +
 drivers/misc/eeprom/at24.c                         |  46 +++-
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  32 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   8 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  25 +-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c    |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  52 ++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  20 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   2 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   4 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  16 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  14 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  19 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  34 +--
 drivers/pinctrl/core.c                             |   8 +-
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |  74 +++---
 drivers/pinctrl/intel/pinctrl-intel.c              |   6 +-
 drivers/pinctrl/intel/pinctrl-intel.h              |  17 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |  40 +--
 drivers/pinctrl/meson/pinctrl-meson-a1.c           |   6 +-
 drivers/power/supply/mt6360_charger.c              |   2 +-
 drivers/power/supply/rt9455_charger.c              |   2 +
 drivers/regulator/core.c                           |  27 +-
 drivers/regulator/mt6360-regulator.c               |  32 ++-
 drivers/s390/cio/cio_inject.c                      |   2 +-
 drivers/s390/net/qeth_core_main.c                  |  69 +++---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   2 -
 drivers/scsi/lpfc/lpfc.h                           |   1 -
 drivers/scsi/lpfc/lpfc_els.c                       |  20 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   5 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  14 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   8 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   2 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   6 +-
 drivers/spi/spi-axi-spi-engine.c                   | 275 +++++++++++----------
 drivers/spi/spi-hisi-kunpeng.c                     |   2 -
 drivers/spi/spi-microchip-core-qspi.c              |   1 +
 drivers/spi/spi.c                                  |  12 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |   4 +-
 drivers/staging/wlan-ng/prism2usb.c                |   6 +-
 drivers/target/target_core_configfs.c              |  12 +
 drivers/ufs/core/ufshcd.c                          |   5 +-
 drivers/uio/uio_hv_generic.c                       |  12 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/port.c                            |   8 +-
 drivers/usb/dwc3/core.c                            |  90 +++----
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/gadget.c                          |   2 +
 drivers/usb/dwc3/host.c                            |  27 ++
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/function/f_fs.c                 |   2 +-
 drivers/usb/host/ohci-hcd.c                        |   8 +
 drivers/usb/host/xhci-plat.h                       |   4 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  35 ++-
 drivers/usb/typec/ucsi/ucsi.c                      |  12 +-
 drivers/vfio/pci/vfio_pci.c                        |   2 +
 fs/9p/vfs_file.c                                   |   2 +
 fs/9p/vfs_inode.c                                  |   5 +-
 fs/9p/vfs_super.c                                  |   1 +
 fs/btrfs/extent_io.c                               |  19 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/send.c                                    |   4 +-
 fs/btrfs/transaction.c                             |   2 +-
 fs/btrfs/volumes.c                                 |  18 +-
 fs/gfs2/bmap.c                                     |   5 +-
 fs/hugetlbfs/inode.c                               |   8 +-
 fs/nfs/client.c                                    |   5 +-
 fs/nfs/inode.c                                     |  13 +-
 fs/nfs/internal.h                                  |   2 -
 fs/nfs/netns.h                                     |   2 +
 fs/smb/client/transport.c                          |  37 ++-
 fs/smb/server/oplock.c                             |  35 ++-
 fs/smb/server/transport_tcp.c                      |   4 +
 include/linux/compiler_types.h                     |  11 +
 include/linux/dma-fence.h                          |   7 -
 include/linux/gfp_types.h                          |   2 +
 include/linux/hugetlb.h                            |  53 +++-
 include/linux/hugetlb_cgroup.h                     |  69 +++---
 include/linux/hyperv.h                             |   1 +
 include/linux/mm_types.h                           |  14 ++
 include/linux/pci_ids.h                            |   2 +
 include/linux/pinctrl/pinctrl.h                    |  20 ++
 include/linux/regulator/consumer.h                 |   4 +-
 include/linux/skbuff.h                             |  15 ++
 include/linux/skmsg.h                              |   2 +
 include/linux/slab.h                               |   2 +-
 include/linux/spi/spi.h                            |  51 +++-
 include/linux/sunrpc/clnt.h                        |   1 +
 include/linux/swapops.h                            | 105 ++++----
 include/linux/timer.h                              |  15 +-
 include/net/xfrm.h                                 |   3 +
 include/uapi/scsi/scsi_bsg_mpi3mr.h                |   2 +-
 kernel/bpf/bloom_filter.c                          |  13 +
 kernel/bpf/verifier.c                              |   3 +-
 kernel/time/timer.c                                |   8 +-
 lib/Kconfig.debug                                  |   5 +-
 lib/dynamic_debug.c                                |   6 +-
 mm/hugetlb.c                                       |  55 +++--
 mm/hugetlb_cgroup.c                                |  34 +--
 mm/migrate.c                                       |   2 +-
 mm/readahead.c                                     |   4 +
 net/bluetooth/hci_core.c                           |   3 +-
 net/bluetooth/l2cap_core.c                         |   3 +
 net/bluetooth/msft.c                               |   2 +-
 net/bluetooth/msft.h                               |   4 +-
 net/bluetooth/sco.c                                |   4 +
 net/bridge/br_forward.c                            |   9 +-
 net/bridge/br_netlink.c                            |   3 +-
 net/core/filter.c                                  |  42 +++-
 net/core/link_watch.c                              |   4 +-
 net/core/net-sysfs.c                               |   4 +-
 net/core/net_namespace.c                           |  13 +-
 net/core/rtnetlink.c                               |   6 +-
 net/core/skbuff.c                                  |  27 +-
 net/core/skmsg.c                                   |   5 +-
 net/core/sock.c                                    |   4 +-
 net/hsr/hsr_device.c                               |  31 ++-
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv4/tcp_ipv4.c                                |   8 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/udp_offload.c                             |  12 +-
 net/ipv4/xfrm4_input.c                             |   6 +-
 net/ipv6/addrconf.c                                |  11 +-
 net/ipv6/fib6_rules.c                              |   6 +-
 net/ipv6/ip6_input.c                               |   4 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/xfrm6_input.c                             |   6 +-
 net/l2tp/l2tp_eth.c                                |   3 +
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mptcp/protocol.c                               |   3 +
 net/nsh/nsh.c                                      |  14 +-
 net/phonet/pn_netlink.c                            |   2 +-
 net/smc/smc_ib.c                                   |  19 +-
 net/sunrpc/clnt.c                                  |   5 +-
 net/sunrpc/xprt.c                                  |   2 +-
 net/tipc/msg.c                                     |   8 +-
 net/wireless/nl80211.c                             |   2 +
 net/wireless/trace.h                               |   2 +-
 net/xfrm/xfrm_input.c                              |   8 +
 rust/Makefile                                      |  11 +-
 rust/kernel/error.rs                               |   2 +-
 rust/kernel/lib.rs                                 |   2 +-
 rust/macros/module.rs                              | 185 ++++++++------
 scripts/Makefile.build                             |  17 +-
 scripts/Makefile.host                              |  27 +-
 scripts/Makefile.modfinal                          |   4 +-
 scripts/is_rust_module.sh                          |  16 --
 security/keys/key.c                                |   3 +-
 sound/hda/intel-sdw-acpi.c                         |   2 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/meson/Kconfig                            |   1 +
 sound/soc/meson/axg-card.c                         |   1 +
 sound/soc/meson/axg-fifo.c                         |  56 +++--
 sound/soc/meson/axg-fifo.h                         |  12 +-
 sound/soc/meson/axg-frddr.c                        |   5 +-
 sound/soc/meson/axg-tdm-interface.c                |  34 +--
 sound/soc/meson/axg-toddr.c                        |  22 +-
 sound/soc/tegra/tegra186_dspk.c                    |   7 +-
 sound/soc/ti/davinci-mcasp.c                       |  12 +-
 sound/usb/line6/driver.c                           |   6 +-
 tools/include/linux/kernel.h                       |   1 +
 tools/include/linux/mm.h                           |   5 +
 tools/include/linux/panic.h                        |  19 ++
 tools/perf/util/unwind-libdw.c                     |  21 +-
 tools/perf/util/unwind-libunwind-local.c           |   2 +-
 tools/power/x86/turbostat/turbostat.8              |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  30 ++-
 .../selftests/bpf/prog_tests/bloom_filter_map.c    |   6 +
 tools/testing/selftests/timers/valid-adjtimex.c    |  73 +++---
 247 files changed, 2515 insertions(+), 1401 deletions(-)


