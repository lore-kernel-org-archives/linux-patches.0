Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17194EB30;
	Thu, 16 May 2024 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715861705; cv=none; b=JUAD8Id3dseBoxfoocdinBXejSMoSBLyXGk9bcIc0HspT/xzQovWiwK+ZkS53oSGWe2N8uqZHumostK519b0Xc70F5SMC5dQAM+hHGW/za0qAmdyAq6caK4StXxJnHZ+Ttl2xyaXsqY1u6oAFoFV4A/ww7WvEyvbgez3WcKbvR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715861705; c=relaxed/simple;
	bh=XGttEFMVFZPC9MgaViQjZ3WYrwUySJMfOfCitLbrHnE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OrY9Ug2ag9/yqEVx4bRqsDDFTDb4bW22eVFrQW2E/DBblqoHSL2twgR0zdSygNQkG1xyA9qVj22++kkqNv8o3IbM/IUOqDpYemlDwZldlEzj8Cd25YmFHZv2ds04jcRl01SiI70djtKCJxHSl7FMyUmw0GhzFzJIhcXjpyu41kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oW2CO9OP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oW2CO9OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE24C113CC;
	Thu, 16 May 2024 12:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715861704;
	bh=XGttEFMVFZPC9MgaViQjZ3WYrwUySJMfOfCitLbrHnE=;
	h=From:To:Cc:Subject:Date:From;
	b=oW2CO9OPAYaSO73FGSdU+Udh9NWIB6DDgUNvZ9WN3fHWfLiSiF+cVzD5c1u9YWlGV
	 4rQ5X2NIkc4sPMvczCD+NnV6mPwkB69fuHITo/hz6VmLhBxGZhzZbjXDpAcBmqGqjX
	 0AnDati1iYgCTZU5QOPzMvJlck+zMfhprTDhrT9s=
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
Subject: [PATCH 6.8 000/339] 6.8.10-rc3 review
Date: Thu, 16 May 2024 14:14:57 +0200
Message-ID: <20240516121349.430565475@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc3.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.8.10-rc3
X-KernelTest-Deadline: 2024-05-18T12:14+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.8.10 release.
There are 339 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc3.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.8.10-rc3

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
    Bluetooth: qca: generalise device address check

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix NVM configuration parsing

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: add missing firmware sanity checks

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix wcn3991 device address check

Johan Hovold <johan+linaro@kernel.org>
    Bluetooth: qca: fix invalid device address check

Steven Rostedt (Google) <rostedt@goodmis.org>
    eventfs: Do not treat events directory different than other directories

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracefs: Still use mount point as default permissions for instances

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracefs: Reset permissions on remount if permissions are options

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

Sean Anderson <sean.anderson@linux.dev>
    nvme-pci: Add quirk for broken MSIs

Ryan Roberts <ryan.roberts@arm.com>
    fs/proc/task_mmu: fix uffd-wp confusion in pagemap_scan_pmd_entry()

Ryan Roberts <ryan.roberts@arm.com>
    fs/proc/task_mmu: fix loss of young/dirty bits during pagemap scan

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Enhance def_domain_type to handle untrusted device

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: reset ptes when close() for wr-protected ones

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: use memalloc_nofs_save() in page_cache_ra_order()

Michael Ellerman <mpe@ellerman.id.au>
    selftests/mm: fix powerpc ARCH check

Thomas Gleixner <tglx@linutronix.de>
    x86/apic: Don't access the APIC when disabling x2APIC

Thomas Weißschuh <linux@weissschuh.net>
    misc/pvpanic-pci: register attributes via pci_driver

Lakshmi Yadlapati <lakshmiy@us.ibm.com>
    hwmon: (pmbus/ucd9000) Increase delay from 250 to 500us

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    net: fix out-of-bounds access in ops_init

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/arm-smmu: Use the correct type in nvidia_smmu_context_fault()

Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
    arm64: dts: qcom: sa8155p-adp: fix SDHC2 CD pin configuration

Hersen Wu <hersenxs.wu@amd.com>
    drm/amd/display: Fix incorrect DSC instance for MST

George Shen <george.shen@amd.com>
    drm/amd/display: Handle Y carry-over in VCP X.Y calculation

Karthikeyan Ramasubramanian <kramasub@chromium.org>
    drm/i915/bios: Fix parsing backlight BDB data

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gt: Automate CCS Mode setting during engine resets

Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
    drm/i915/audio: Fix audio time stamp programming for DP

Lyude Paul <lyude@redhat.com>
    drm/nouveau/gsp: Use the sg allocator for level 2 of radix3

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix idle optimization checks for multi-display and dual eDP

Matt Coster <matt.coster@imgtec.com>
    drm/imagination: Ensure PVR_MIPS_PT_PAGE_COUNT is never zero

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: Fix invalid reads in fence signaled events

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Fix Legacy Display Unit

Zack Rusin <zack.rusin@broadcom.com>
    drm/ttm: Print the memory decryption status just once

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: don't allow mapping the MMIO HDP page with large pages

Dave Airlie <airlied@redhat.com>
    Revert "drm/nouveau/firmware: Fix SG_DEBUG error with nvkm_firmware_ctor()"

Lyude Paul <lyude@redhat.com>
    drm/nouveau/firmware: Fix SG_DEBUG error with nvkm_firmware_ctor()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add lunar lake point M DID

Frank Oltmanns <frank@oltmanns.dev>
    clk: sunxi-ng: a64: Set minimum and maximum rate for PLL-MIPI

Frank Oltmanns <frank@oltmanns.dev>
    clk: sunxi-ng: common: Support minimum and maximum rate

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Revert "clk: Use device_get_match_data()"

Viken Dadhaniya <quic_vdadhani@quicinc.com>
    slimbus: qcom-ngd-ctrl: Add timeout for wait operation

Jim Cromie <jim.cromie@gmail.com>
    dyndbg: fix old BUG_ON in >control parser

Joao Paulo Goncalves <joao.goncalves@toradex.com>
    ASoC: ti: davinci-mcasp: Fix race condition during probe

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix DSPK 16-bit playback

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize UMAC_CMD access

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix MAKE_PC_FROM_RA second argument

Paolo Abeni <pabeni@redhat.com>
    tipc: fix UAF in error path

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: change usleep_range to udelay in PHY mdic access

Alexander Potapenko <glider@google.com>
    kmsan: compiler_types: declare __no_sanitize_or_inline

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Reset chip on probe() and resume()

Hans de Goede <hdegoede@redhat.com>
    iio: accel: mxc4005: Interrupt handling fixes

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: pressure: Fixes SPI support for BMP3xx devices

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: pressure: Fixes BME280 SPI driver data

Ramona Gradinariu <ramona.bolboaca13@gmail.com>
    iio:imu: adis16475: Fix sync mode setting

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    dt-bindings: iio: health: maxim,max30102: fix compatible check

Sven Schnelle <svens@linux.ibm.com>
    workqueue: Fix selection of wake_cpu in kick_pool()

Gregory Detal <gregory.detal@gmail.com>
    mptcp: only allow set existing scheduler for net.mptcp.scheduler

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_nxt is properly initialized on connect

Dan Carpenter <dan.carpenter@linaro.org>
    mm/slab: make __free(kfree) accept error pointers

Liam R. Howlett <Liam.Howlett@oracle.com>
    maple_tree: fix mas_empty_area_rev() null pointer dereference

Josef Bacik <josef@toxicpanda.com>
    btrfs: make sure that WRITTEN is set on all metadata blocks

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: do not check qgroup inherit if qgroup is disabled

Qu Wenruo <wqu@suse.com>
    btrfs: set correct ram_bytes when splitting ordered extent

Dominique Martinet <dominique.martinet@atmark-techno.com>
    btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()

Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
    mm/slub: avoid zeroing outside-object freepointer for single free

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    firewire: ohci: fulfill timestamp for some local asynchronous transaction

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix conflicting PCI SSID 17aa:386f for Lenovo Legion models

Aman Dhoot <amandhoot12@gmail.com>
    ALSA: hda/realtek: Fix mute led of HP Laptop 15-da3001TU

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Check for port partner validity before consuming it

Amit Sunil Dhamne <amitsd@google.com>
    usb: typec: tcpm: unregister existing source caps before re-registration

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: clear pd_event queue in PORT_RESET

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: core: Prevent phy suspend during init

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: xhci-plat: Don't include xhci.h

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: f_fs: Fix a race condition when processing setup packets.

Wesley Cheng <quic_wcheng@quicinc.com>
    usb: gadget: f_fs: Fix race between aio_cancel() and AIO request complete

Ivan Avdeev <me@provod.works>
    usb: gadget: uvc: use correct buffer size when parsing configfs lists

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

Linus Torvalds <torvalds@linux-foundation.org>
    Reapply "drm/qxl: simplify qxl_fence_wait"

Thanassis Avgerinos <thanassis.avgerinos@gmail.com>
    firewire: nosy: ensure user_length is taken into account when fetching packet contents

Christian König <christian.koenig@amd.com>
    drm/amdgpu: once more fix the call oder in amdgpu_ttm_move() v2

Michel Dänzer <mdaenzer@redhat.com>
    drm/amdgpu: Fix comparison in amdgpu_res_cpu_visible

Gabe Teeger <gabe.teeger@amd.com>
    drm/amd/display: Atom Integrated System Info v2_2 for DCN35

Kent Gibson <warthog618@gmail.com>
    gpiolib: cdev: fix uninitialised kfifo

Zhongqiu Han <quic_zhonhan@quicinc.com>
    gpiolib: cdev: Fix use after free in lineinfo_changed_notify

Mario Limonciello <mario.limonciello@amd.com>
    dm/amd/pm: Fix problems with reboot/shutdown for some SMU 13.0.4/13.0.11 users

Douglas Anderson <dianders@chromium.org>
    drm/connector: Add \n to message about demoting connector force-probes

Jerome Brunet <jbrunet@baylibre.com>
    drm/meson: dw-hdmi: add bandgap setting for g12

Jerome Brunet <jbrunet@baylibre.com>
    drm/meson: dw-hdmi: power up phy on device init

Steffen Bätz <steffen@innosonix.de>
    net: dsa: mv88e6xxx: add phylink_get_caps for the mv88e6320/21 family

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

Eric Dumazet <edumazet@google.com>
    ipv6: fib6_rules: avoid possible NULL dereference in fib6_rule_action()

Daniel Golle <daniel@makrotopia.org>
    dt-bindings: net: mediatek: remove wrongly added clocks and SerDes

David Howells <dhowells@redhat.com>
    rxrpc: Only transmit one ACK per jumbo packet received

David Howells <dhowells@redhat.com>
    rxrpc: Fix congestion control algorithm

David Howells <dhowells@redhat.com>
    rxrpc: Fix the names of the fields in the ACK trailer struct

Ido Schimmel <idosch@nvidia.com>
    selftests: test_bridge_neigh_suppress.sh: Fix failures due to duplicate MAC

Shigeru Yoshida <syoshida@redhat.com>
    ipv6: Fix potential uninit-value access in __ip6_make_skb()

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix corrupted ethernet header on multicast-to-unicast

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    nfc: nci: Fix kcov check in nci_rx_work()

Donald Hunter <donald.hunter@gmail.com>
    netlink: specs: Add missing bridge linkinfo attrs

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
    Bluetooth: HCI: Fix potential null-ptr-deref

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8183-pico6: Fix bluetooth node

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

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC: add a missing rpc_stat for TCP TLS

Li Nan <linan122@huawei.com>
    blk-iocost: do not WARN if iocg was already offlined

Vanillan Wang <vanillanwang@163.com>
    net:usb:qmi_wwan: support Rolling modules

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: silence UBSAN warning (v3)

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Add Granite Rapids-D to HPM CPU list

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmf: Decrease error message to debug

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dp: Don't probe eDP ports twice harder

Krzysztof Kozlowski <krzk@kernel.org>
    gpio: lpc32xx: fix module autoloading

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: drop inodes immediately on non-.L too

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: remove erroneous nlink init from legacy stat2inode

Stephen Boyd <sboyd@kernel.org>
    clk: Don't hold prepare_lock when calling kref_put()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: crystalcove: Use -ENOTSUPP consistently

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: wcove: Use -ENOTSUPP consistently

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/crypto/chacha-p10: Fix failure on non Power10

Jeff Layton <jlayton@kernel.org>
    9p: explicitly deny setlease attempts

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: fix the cache always being enabled on files with qid flags

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: translate O_TRUNC into OTRUNC

Joakim Sindholt <opensource@zhasha.com>
    fs/9p: only translate RWX permissions for plain 9P2000

Krzysztof Kozlowski <krzk@kernel.org>
    iommu: mtk: fix module autoloading

Steve French <stfrench@microsoft.com>
    smb3: fix broken reconnect when password changing on the server by allowing password rotation

Ashutosh Dixit <ashutosh.dixit@intel.com>
    drm/xe: Label RING_CONTEXT_CONTROL as masked

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/xe_migrate: Cast to output precision before multiplying operands

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't free ring buffers that couldn't be re-encrypted

Rick Edgecombe <rick.p.edgecombe@intel.com>
    uio_hv_generic: Don't free decrypted memory

Rick Edgecombe <rick.p.edgecombe@intel.com>
    hv_netvsc: Don't free decrypted memory

Rick Edgecombe <rick.p.edgecombe@intel.com>
    Drivers: hv: vmbus: Track decrypted status in vmbus_gpadl

Rick Edgecombe <rick.p.edgecombe@intel.com>
    Drivers: hv: vmbus: Leak pages if set_memory_encrypted() fails

John Stultz <jstultz@google.com>
    selftests: timers: Fix valid-adjtimex signed left-shift undefined behavior

Zhigang Luo <Zhigang.Luo@amd.com>
    amd/amdkfd: sync all devices to wait all processes being evicted

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Fix VCN allocation in CPX partition

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: fix the high voltage issue after unload

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Skip on writeback when it's not applicable

Tao Zhou <tao.zhou1@amd.com>
    drm/amdgpu: implement IRQ_STATE_ENABLE for SDMA v4.4.2

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: add smu 14.0.1 discovery support

Li Ma <li.ma@amd.com>
    drm/amd/display: add DCN 351 version for microcode load

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Refine IB schedule error logging

Eric Dumazet <edumazet@google.com>
    nfc: llcp: fix nfc_llcp_setsockopt() unsafe copies

Eric Dumazet <edumazet@google.com>
    net: add copy_safe_from_sockptr() helper

Justin Ernst <justin.ernst@hpe.com>
    tools/power/turbostat: Fix uncore frequency file string

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: scall: Save thread_info.syscall unconditionally on entry

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Do not setup DMA for virtual devices

Bernhard Rosenkränzer <bero@baylibre.com>
    platform/x86: acer-wmi: Add support for Acer PH18-71

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix missed error message after VPU rename

Wachowski, Karol <karol.wachowski@intel.com>
    accel/ivpu: Improve clarity of MMU error messages

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Remove d3hot_after_power_off WA

Rik van Riel <riel@surriel.com>
    blk-iocost: avoid out of bounds shift

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Handle the NCQ error returned by D2H frame

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: Fix SELinux error when systemd-modules loads the target module

Kees Cook <keescook@chromium.org>
    nouveau/gsp: Avoid addressing beyond end of rpc->entries

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

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix warning upon failed /dev/cpu_dma_latency read

Patryk Wlazlyn <patryk.wlazlyn@linux.intel.com>
    tools/power turbostat: Print ucode revision only if valid

Len Brown <len.brown@intel.com>
    tools/power turbostat: Expand probe_intel_uncore_frequency()

Chen Yu <yu.c.chen@intel.com>
    tools/power turbostat: Do not print negative LPI residency

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

Jeff Layton <jlayton@kernel.org>
    vboxsf: explicitly deny setlease attempts

Phil Elwell <phil@raspberrypi.com>
    net: bcmgenet: Reset RBUF on first open

Zhang Yi <zhangyi@everest-semi.com>
    ASoC: codecs: ES8326: modify clock table

Zhang Yi <zhangyi@everest-semi.com>
    ASoC: codecs: ES8326: Solve error interruption issue

Li Nan <linan122@huawei.com>
    block: fix overflow in blk_ioctl_discard()

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Zero-initialize message buffers

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix MCQ mode dev command timeout

Yihang Li <liyihang9@huawei.com>
    scsi: libsas: Align SMP request allocation to ARCH_DMA_MINALIGN

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: WLUN suspend dev/link state error recovery

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    OSS: dmasound/paula: Mark driver struct with __refdata to prevent section mismatch

André Apitzsch <git@apitzsch.eu>
    regulator: tps65132: Add of_match table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda-dsp: Skip IMR boot on ACE platforms in case of S3 suspend

Borislav Petkov (AMD) <bp@alien8.de>
    kbuild: Disable KCSAN for autogenerated *.mod.c intermediaries

Mark Rutland <mark.rutland@arm.com>
    selftests/ftrace: Fix event filter target_func selection

Andrei Matei <andreimatei1@gmail.com>
    bpf: Check bloom filter map value size

Jonathan Kim <Jonathan.Kim@amd.com>
    drm/amdkfd: range check cp bad op exception interrupts

Mukul Joshi <mukul.joshi@amd.com>
    drm/amdkfd: Check cgroup when returning DMABuf info

Anand Jain <anand.jain@oracle.com>
    btrfs: return accurate error code on open failure in open_fs_devices()

Saurav Kashyap <skashyap@marvell.com>
    scsi: bnx2fc: Remove spin_lock_bh while releasing resources after upload

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Avoid memcpy field-spanning write WARNING

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe: Fix END redefinition

linke li <lilinke99@qq.com>
    net: mark racy access on sk->sk_rcvbuf

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: mvm: guard against invalid STA ID on removal

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: read txq->read_ptr under lock

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix prep_connection error path

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix rdev_dump_mpp() arguments order

Jeff Johnson <quic_jjohnson@quicinc.com>
    wifi: mac80211: fix ieee80211_bss_*_flags kernel-doc

Eric Van Hensbergen <ericvh@kernel.org>
    fs/9p: fix uninitialized values during inode evict

Andrew Price <anprice@redhat.com>
    gfs2: Fix invalid metadata access in punch_hole

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Use a dedicated lock for ras_fwlog state

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Release hbalock before calling lpfc_worker_wake_up()

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Replace hbalock with ndlp lock in lpfc_nvme_unregister_port()

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Update lpfc_ramp_down_queue_handler() logic

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Remove IRQF_ONESHOT flag from threaded IRQ handling

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Move NPIV's transport unregistration to after resource clean up

Rohit Ner <rohitner@google.com>
    scsi: ufs: core: Fix MCQ MAC configuration

Conor Dooley <conor.dooley@microchip.com>
    firmware: microchip: don't unconditionally print validation success

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix timing of synchronizing bitmap and inode

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()

Will Deacon <will@kernel.org>
    swiotlb: initialise restricted pool list_head when SWIOTLB_DYNAMIC=y

Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
    EDAC/versal: Do not log total error counts

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: LPAR panics during boot up with a frozen PE

Nayna Jain <nayna@linux.ibm.com>
    powerpc/pseries: make max polling consistent for longer H_CALLs

Jernej Skrabec <jernej.skrabec@gmail.com>
    clk: sunxi-ng: h6: Reparent CPUX during PLL CPUX rate change

Adam Skladowski <a39.skl@gmail.com>
    clk: qcom: smd-rpm: Restore msm8976 num_clk

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/xe/display: Fix ADL-N detection

Richard Gobert <richardbgobert@gmail.com>
    net: gro: add flush check in udp_gro_receive_segment

Richard Gobert <richardbgobert@gmail.com>
    net: gro: fix udp bad offset in socket lookup by adding {inner_}network_offset to napi_gro_cb

Shigeru Yoshida <syoshida@redhat.com>
    ipv4: Fix uninit-value access in __ip_make_skb()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/panel: ili9341: Use predefined error codes

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/panel: ili9341: Respect deferred probe

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    drm/panel: ili9341: Correct use of device property APIs

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix kernel panic after setting hsuid

Guillaume Nault <gnault@redhat.com>
    vxlan: Pull inner IP header in vxlan_rcv().

Xin Long <lucien.xin@gmail.com>
    tipc: fix a possible memleak in tipc_buf_append

Jeffrey Altman <jaltman@auristor.com>
    rxrpc: Clients must accept conn from any address

Felix Fietkau <nbd@nbd.name>
    net: core: reject skb_copy(_expand) for fraglist GSO skbs

Felix Fietkau <nbd@nbd.name>
    net: bridge: fix multicast-to-unicast with fraglist GSO

Mans Rullgard <mans@mansr.com>
    spi: fix null pointer dereference within spi_sync

Shashank Sharma <shashank.sharma@amd.com>
    drm/amdgpu: fix doorbell regression

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

Guillaume Nault <gnault@redhat.com>
    vxlan: Add missing VNI filter counter update in arp_reduce().

Guillaume Nault <gnault@redhat.com>
    vxlan: Fix racy device stats updates.

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_actions()

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flow_spec

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: use return from qede_parse_flow_attr() for flower

Asbjørn Sloth Tønnesen <ast@fiberby.net>
    net: qede: sanitize 'rc' in qede_add_tc_flower_fltr()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix E-MU dock initialization

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: move the whole GPIO event handling to the workqueue

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: factor out snd_emu1010_load_dock_firmware()

Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
    ALSA: emu10k1: fix E-MU card dock presence monitoring

David Howells <dhowells@redhat.com>
    Fix a potential infinite loop in extract_user_to_sg()

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Add CFI for RA register to asm macro vdso_func

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/debugfs: Prevent use-after-free from occurring after cdev removal

David Bauer <mail@david-bauer.net>
    net l2tp: drop flow hash on forward

Kuniyuki Iwashima <kuniyu@amazon.com>
    nsh: Restore skb->{protocol,data,mac_header} for outer header in nsh_gso_segment().

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/debugfs: Fix two locking issues with thermal zone debug

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/debugfs: Free all thermal zone debug memory on zone removal

Bui Quang Minh <minhquangbui99@gmail.com>
    octeontx2-af: avoid off-by-one read from userspace

Bui Quang Minh <minhquangbui99@gmail.com>
    bna: ensure the copied buf is NUL terminated

Bui Quang Minh <minhquangbui99@gmail.com>
    ice: ensure the copied buf is NUL terminated

Chen Yu <yu.c.chen@intel.com>
    efi/unaccepted: touch soft lockup during memory accept

Toke Høiland-Jørgensen <toke@redhat.com>
    xdp: use flags field to disambiguate broadcast redirect

Puranjay Mohan <puranjay@kernel.org>
    arm32, bpf: Reimplement sign-extension mov instruction

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix clearing storage keys for huge pages

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm: Fix storage key clearing for guest huge pages

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: codecs: wsa881x: set clk_stop_mode1 flag

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Set name of control as in topology

Xu Kuohai <xukuohai@huawei.com>
    riscv, bpf: Fix incorrect runtime stats

Xu Kuohai <xukuohai@huawei.com>
    bpf, arm64: Fix incorrect runtime stats

Devyn Liu <liudingyuan@huawei.com>
    spi: hisi-kunpeng: Delete the dump interface of data registers in debugfs

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: fix version format string

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: use common AXI macros

Anton Protopopov <aspsk@isovalent.com>
    bpf: Fix a verifier verbose message

Yi Zhang <yi.zhang@redhat.com>
    nvme: fix warn output about shared namespaces without CONFIG_NVME_MULTIPATH

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: add default firmware library path for LNL

Richard Fitzgerald <rf@opensource.cirrus.com>
    regmap: Add regmap_read_bypassed()

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

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix nfsd4_encode_fattr4() crasher

Dai Ngo <dai.ngo@oracle.com>
    NFSD: add support for CB_GETATTR callback

Josef Bacik <josef@toxicpanda.com>
    nfsd: make all of the nfsd stats per-network namespace

Josef Bacik <josef@toxicpanda.com>
    nfsd: expose /proc/net/sunrpc/nfsd in net namespaces

Josef Bacik <josef@toxicpanda.com>
    nfsd: rename NFSD_NET_* to NFSD_STATS_*

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix refcount leak in pinctrl_dt_to_map()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    power: supply: mt6360_charger: Fix of_match for usb-otg-vbus regulator

Arnd Bergmann <arnd@arndb.de>
    power: rt9455: hide unused rt9455_boost_voltage_values

Hans de Goede <hdegoede@redhat.com>
    pinctrl: baytrail: Fix selecting gpio pinctrl state

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

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: don't free NULL coalescing rule

Benno Lossin <benno.lossin@proton.me>
    rust: macros: fix soundness issue in `module!` macro

Thomas Bertschinger <tahbertschinger@gmail.com>
    rust: module: place generated init_module() function in .init.text


-------------

Diffstat:

 .../bindings/iio/health/maxim,max30102.yaml        |   2 +-
 .../devicetree/bindings/net/mediatek,net.yaml      |  22 +--
 Documentation/netlink/specs/rt_link.yaml           |   6 +
 Makefile                                           |   4 +-
 arch/arm/kernel/sleep.S                            |   4 +
 arch/arm/net/bpf_jit_32.c                          |  56 +++++--
 .../dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts    |   3 +-
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts           |  30 ++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |   8 +-
 arch/arm64/net/bpf_jit_comp.c                      |   6 +-
 arch/mips/include/asm/ptrace.h                     |   2 +-
 arch/mips/kernel/asm-offsets.c                     |   1 +
 arch/mips/kernel/ptrace.c                          |  15 +-
 arch/mips/kernel/scall32-o32.S                     |  23 +--
 arch/mips/kernel/scall64-n32.S                     |   3 +-
 arch/mips/kernel/scall64-n64.S                     |   3 +-
 arch/mips/kernel/scall64-o32.S                     |  33 ++--
 arch/powerpc/crypto/chacha-p10-glue.c              |   8 +-
 arch/powerpc/include/asm/plpks.h                   |   5 +-
 arch/powerpc/platforms/pseries/iommu.c             |   8 +
 arch/powerpc/platforms/pseries/plpks.c             |  10 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   6 +-
 arch/s390/include/asm/dwarf.h                      |   1 +
 arch/s390/kernel/vdso64/vdso_user_wrapper.S        |   2 +
 arch/s390/mm/gmap.c                                |   2 +-
 arch/s390/mm/hugetlbpage.c                         |   2 +-
 arch/x86/kernel/apic/apic.c                        |  16 +-
 arch/xtensa/include/asm/processor.h                |   8 +-
 arch/xtensa/include/asm/ptrace.h                   |   2 +-
 arch/xtensa/kernel/process.c                       |   5 +-
 arch/xtensa/kernel/stacktrace.c                    |   3 +-
 block/blk-iocost.c                                 |  14 +-
 block/ioctl.c                                      |   5 +-
 drivers/accel/ivpu/ivpu_drv.c                      |  20 +--
 drivers/accel/ivpu/ivpu_drv.h                      |   3 +-
 drivers/accel/ivpu/ivpu_hw_37xx.c                  |   4 +-
 drivers/accel/ivpu/ivpu_mmu.c                      |   8 +-
 drivers/accel/ivpu/ivpu_pm.c                       |   9 +-
 drivers/ata/sata_gemini.c                          |   5 +-
 drivers/base/regmap/regmap.c                       |  37 +++++
 drivers/bluetooth/btqca.c                          | 140 ++++++++++++++--
 drivers/bluetooth/btqca.h                          |   3 +-
 drivers/bluetooth/hci_qca.c                        |   2 -
 drivers/clk/clk.c                                  |  12 +-
 drivers/clk/qcom/clk-smd-rpm.c                     |   1 +
 drivers/clk/samsung/clk-exynos-clkout.c            |  13 +-
 drivers/clk/sunxi-ng/ccu-sun50i-a64.c              |   2 +
 drivers/clk/sunxi-ng/ccu-sun50i-h6.c               |  19 ++-
 drivers/clk/sunxi-ng/ccu_common.c                  |  19 +++
 drivers/clk/sunxi-ng/ccu_common.h                  |   3 +
 drivers/dma/idxd/cdev.c                            |  77 +++++++++
 drivers/dma/idxd/idxd.h                            |   3 +
 drivers/dma/idxd/init.c                            |   4 +
 drivers/dma/idxd/registers.h                       |   3 -
 drivers/dma/idxd/sysfs.c                           |  27 ++-
 drivers/edac/versal_edac.c                         |   4 +-
 drivers/firewire/nosy.c                            |   6 +-
 drivers/firewire/ohci.c                            |  14 +-
 drivers/firmware/efi/unaccepted_memory.c           |   4 +
 drivers/firmware/microchip/mpfs-auto-update.c      |   2 +
 drivers/gpio/gpio-crystalcove.c                    |   2 +-
 drivers/gpio/gpio-lpc32xx.c                        |   1 +
 drivers/gpio/gpio-wcove.c                          |   2 +-
 drivers/gpio/gpiolib-cdev.c                        |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  26 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  56 ++++---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c         |  15 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c           |  16 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  17 +-
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v10.c   |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v11.c   |   3 +-
 drivers/gpu/drm/amd/amdkfd/kfd_int_process_v9.c    |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  15 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  48 ++++--
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   1 +
 .../display/dc/dcn31/dcn31_hpo_dp_link_encoder.c   |   6 +
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |  33 +++-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  27 ++-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   1 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |   8 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c   |   2 +-
 drivers/gpu/drm/drm_connector.c                    |   2 +-
 drivers/gpu/drm/i915/display/intel_audio.c         | 113 +------------
 drivers/gpu/drm/i915/display/intel_bios.c          |  19 +--
 drivers/gpu/drm/i915/display/intel_vbt_defs.h      |   5 -
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c        |   6 +-
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.h        |   2 +-
 drivers/gpu/drm/i915/gt/intel_workarounds.c        |   4 +-
 drivers/gpu/drm/imagination/pvr_fw_mips.h          |   5 +-
 drivers/gpu/drm/meson/meson_dw_hdmi.c              |  70 ++++----
 drivers/gpu/drm/nouveau/include/nvkm/subdev/gsp.h  |   4 +-
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  13 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |  81 +++++----
 drivers/gpu/drm/panel/Kconfig                      |   2 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c       |  13 +-
 drivers/gpu/drm/qxl/qxl_release.c                  |  50 +-----
 drivers/gpu/drm/radeon/pptable.h                   |  10 +-
 drivers/gpu/drm/ttm/ttm_tt.c                       |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_bo.c                 |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |   2 +-
 drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h  |   3 +-
 drivers/gpu/drm/xe/regs/xe_engine_regs.h           |   2 +-
 drivers/gpu/drm/xe/xe_lrc.c                        |  25 ++-
 drivers/gpu/drm/xe/xe_migrate.c                    |   8 +-
 drivers/gpu/host1x/bus.c                           |   8 -
 drivers/hv/channel.c                               |  29 +++-
 drivers/hv/connection.c                            |  29 +++-
 drivers/hwmon/corsair-cpro.c                       |  43 +++--
 drivers/hwmon/pmbus/ucd9000.c                      |   6 +-
 drivers/iio/accel/mxc4005.c                        |  92 +++++++++-
 drivers/iio/imu/adis16475.c                        |   4 +-
 drivers/iio/pressure/bmp280-core.c                 |   1 +
 drivers/iio/pressure/bmp280-spi.c                  |  13 +-
 drivers/iio/pressure/bmp280.h                      |   1 +
 drivers/infiniband/hw/qib/qib_fs.c                 |   1 +
 drivers/iommu/amd/iommu.c                          |   4 +
 drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c       |   4 +-
 drivers/iommu/mtk_iommu.c                          |   1 +
 drivers/iommu/mtk_iommu_v1.c                       |   1 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/misc/pvpanic/pvpanic-pci.c                 |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  20 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  32 +++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   8 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   6 +-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c    |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   6 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  52 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  20 +--
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   2 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |   8 +-
 drivers/net/ethernet/intel/ice/ice_debugfs.c       |   8 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   4 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  16 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  14 +-
 drivers/net/hyperv/netvsc.c                        |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan/vxlan_core.c                     |  49 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |   7 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |   2 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/nvme.h                           |   5 +
 drivers/nvme/host/pci.c                            |  14 +-
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c         |  34 ++--
 drivers/pinctrl/core.c                             |   8 +-
 drivers/pinctrl/devicetree.c                       |  10 +-
 drivers/pinctrl/intel/pinctrl-baytrail.c           |  74 +++++----
 drivers/pinctrl/intel/pinctrl-intel.h              |   4 +
 drivers/pinctrl/mediatek/pinctrl-paris.c           |  40 ++---
 drivers/pinctrl/meson/pinctrl-meson-a1.c           |   6 +-
 drivers/platform/x86/acer-wmi.c                    |   9 +
 drivers/platform/x86/amd/pmf/acpi.c                |   2 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |   1 +
 drivers/power/supply/mt6360_charger.c              |   2 +-
 drivers/power/supply/rt9455_charger.c              |   2 +
 drivers/regulator/core.c                           |  27 +--
 drivers/regulator/mt6360-regulator.c               |  32 ++--
 drivers/regulator/tps65132-regulator.c             |   7 +
 drivers/s390/cio/cio_inject.c                      |   2 +-
 drivers/s390/net/qeth_core_main.c                  |  69 ++++----
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |   2 -
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  10 +-
 drivers/scsi/libsas/sas_expander.c                 |   2 +-
 drivers/scsi/lpfc/lpfc.h                           |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   4 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  20 +--
 drivers/scsi/lpfc/lpfc_debugfs.c                   |  12 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  20 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   5 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   5 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   4 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  13 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  34 ++--
 drivers/scsi/lpfc/lpfc_vport.c                     |   8 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c                   |   2 +-
 drivers/slimbus/qcom-ngd-ctrl.c                    |   6 +-
 drivers/spi/spi-axi-spi-engine.c                   |  19 +--
 drivers/spi/spi-hisi-kunpeng.c                     |   2 -
 drivers/spi/spi-microchip-core-qspi.c              |   1 +
 drivers/spi/spi.c                                  |   1 +
 drivers/target/target_core_configfs.c              |  12 ++
 drivers/thermal/thermal_debugfs.c                  |  59 +++++--
 drivers/ufs/core/ufs-mcq.c                         |   2 +-
 drivers/ufs/core/ufshcd.c                          |   9 +-
 drivers/uio/uio_hv_generic.c                       |  12 +-
 drivers/usb/core/hub.c                             |   5 +-
 drivers/usb/core/port.c                            |   8 +-
 drivers/usb/dwc3/core.c                            |  90 +++++-----
 drivers/usb/dwc3/core.h                            |   1 +
 drivers/usb/dwc3/gadget.c                          |   2 +
 drivers/usb/dwc3/host.c                            |  27 +++
 drivers/usb/gadget/composite.c                     |   6 +-
 drivers/usb/gadget/function/f_fs.c                 |   9 +-
 drivers/usb/gadget/function/uvc_configfs.c         |   4 +-
 drivers/usb/host/ohci-hcd.c                        |   8 +
 drivers/usb/host/xhci-plat.h                       |   4 +-
 drivers/usb/host/xhci-rzv2m.c                      |   1 +
 drivers/usb/typec/tcpm/tcpm.c                      |  36 +++-
 drivers/usb/typec/ucsi/ucsi.c                      |  12 +-
 drivers/vfio/pci/vfio_pci.c                        |   2 +
 fs/9p/fid.h                                        |   3 -
 fs/9p/vfs_file.c                                   |   2 +
 fs/9p/vfs_inode.c                                  |  23 ++-
 fs/9p/vfs_super.c                                  |   1 +
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/ordered-data.c                            |   1 +
 fs/btrfs/qgroup.c                                  |   2 +
 fs/btrfs/transaction.c                             |   2 +-
 fs/btrfs/tree-checker.c                            |  30 ++--
 fs/btrfs/tree-checker.h                            |   1 +
 fs/btrfs/volumes.c                                 |  18 +-
 fs/exfat/file.c                                    |   9 +-
 fs/gfs2/bmap.c                                     |   5 +-
 fs/nfs/client.c                                    |   5 +-
 fs/nfs/inode.c                                     |  13 +-
 fs/nfs/internal.h                                  |   2 -
 fs/nfs/netns.h                                     |   2 +
 fs/nfsd/cache.h                                    |   2 -
 fs/nfsd/netns.h                                    |  21 ++-
 fs/nfsd/nfs4callback.c                             |  97 ++++++++++-
 fs/nfsd/nfs4proc.c                                 |   6 +-
 fs/nfsd/nfs4state.c                                |   3 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/nfsd/nfscache.c                                 |  40 +----
 fs/nfsd/nfsctl.c                                   |  14 +-
 fs/nfsd/nfsfh.c                                    |   3 +-
 fs/nfsd/state.h                                    |  14 ++
 fs/nfsd/stats.c                                    |  43 ++---
 fs/nfsd/stats.h                                    |  62 +++----
 fs/nfsd/vfs.c                                      |   6 +-
 fs/nfsd/xdr4cb.h                                   |  18 ++
 fs/proc/task_mmu.c                                 |  24 +--
 fs/smb/client/cifsglob.h                           |   1 +
 fs/smb/client/connect.c                            |   8 +
 fs/smb/client/fs_context.c                         |  21 +++
 fs/smb/client/fs_context.h                         |   2 +
 fs/smb/client/misc.c                               |   1 +
 fs/smb/client/smb2pdu.c                            |  11 ++
 fs/smb/server/oplock.c                             |  35 ++--
 fs/smb/server/transport_tcp.c                      |   4 +
 fs/tracefs/event_inode.c                           |  45 +++--
 fs/tracefs/inode.c                                 |  92 +++++++++-
 fs/tracefs/internal.h                              |   7 +-
 fs/userfaultfd.c                                   |   4 +
 fs/vboxsf/file.c                                   |   1 +
 include/linux/compiler_types.h                     |  11 ++
 include/linux/dma-fence.h                          |   7 -
 include/linux/gfp_types.h                          |   2 +
 include/linux/hyperv.h                             |   1 +
 include/linux/pci_ids.h                            |   2 +
 include/linux/regmap.h                             |   8 +
 include/linux/regulator/consumer.h                 |   4 +-
 include/linux/skbuff.h                             |  15 ++
 include/linux/skmsg.h                              |   2 +
 include/linux/slab.h                               |   4 +-
 include/linux/sockptr.h                            |  25 +++
 include/linux/sunrpc/clnt.h                        |   1 +
 include/net/gro.h                                  |   9 +
 include/net/xfrm.h                                 |   3 +
 include/sound/emu10k1.h                            |   3 +-
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/linux/kfd_ioctl.h                     |  17 +-
 include/uapi/scsi/scsi_bsg_mpi3mr.h                |   2 +-
 kernel/bpf/bloom_filter.c                          |  13 ++
 kernel/bpf/verifier.c                              |   3 +-
 kernel/dma/swiotlb.c                               |   1 +
 kernel/workqueue.c                                 |   8 +-
 lib/Kconfig.debug                                  |   5 +-
 lib/dynamic_debug.c                                |   6 +-
 lib/maple_tree.c                                   |  16 +-
 lib/scatterlist.c                                  |   2 +-
 mm/readahead.c                                     |   4 +
 mm/slub.c                                          |  52 +++---
 net/8021q/vlan_core.c                              |   2 +
 net/bluetooth/hci_core.c                           |   3 +-
 net/bluetooth/hci_event.c                          |   2 +
 net/bluetooth/l2cap_core.c                         |   3 +
 net/bluetooth/msft.c                               |   2 +-
 net/bluetooth/msft.h                               |   4 +-
 net/bluetooth/sco.c                                |   4 +
 net/bridge/br_forward.c                            |   9 +-
 net/bridge/br_netlink.c                            |   3 +-
 net/core/filter.c                                  |  42 +++--
 net/core/gro.c                                     |   1 +
 net/core/link_watch.c                              |   4 +-
 net/core/net-sysfs.c                               |   4 +-
 net/core/net_namespace.c                           |  13 +-
 net/core/rtnetlink.c                               |   6 +-
 net/core/skbuff.c                                  |  27 ++-
 net/core/skmsg.c                                   |   5 +-
 net/core/sock.c                                    |   4 +-
 net/hsr/hsr_device.c                               |  31 ++--
 net/ipv4/af_inet.c                                 |   1 +
 net/ipv4/ip_output.c                               |   2 +-
 net/ipv4/raw.c                                     |   3 +
 net/ipv4/tcp.c                                     |   4 +-
 net/ipv4/tcp_input.c                               |   2 +
 net/ipv4/tcp_ipv4.c                                |   8 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/udp.c                                     |   3 +-
 net/ipv4/udp_offload.c                             |  15 +-
 net/ipv4/xfrm4_input.c                             |   6 +-
 net/ipv6/addrconf.c                                |  11 +-
 net/ipv6/fib6_rules.c                              |   6 +-
 net/ipv6/ip6_input.c                               |   4 +-
 net/ipv6/ip6_offload.c                             |   1 +
 net/ipv6/ip6_output.c                              |   4 +-
 net/ipv6/udp.c                                     |   3 +-
 net/ipv6/udp_offload.c                             |   3 +-
 net/ipv6/xfrm6_input.c                             |   6 +-
 net/l2tp/l2tp_eth.c                                |   3 +
 net/mac80211/ieee80211_i.h                         |   4 +-
 net/mac80211/mlme.c                                |   5 +-
 net/mptcp/ctrl.c                                   |  39 ++++-
 net/mptcp/protocol.c                               |   3 +
 net/nfc/llcp_sock.c                                |  12 +-
 net/nfc/nci/core.c                                 |   1 +
 net/nsh/nsh.c                                      |  14 +-
 net/phonet/pn_netlink.c                            |   2 +-
 net/rxrpc/ar-internal.h                            |   2 +-
 net/rxrpc/call_object.c                            |   7 +-
 net/rxrpc/conn_event.c                             |  16 +-
 net/rxrpc/conn_object.c                            |   9 +-
 net/rxrpc/input.c                                  |  71 +++++---
 net/rxrpc/output.c                                 |  14 +-
 net/rxrpc/protocol.h                               |   6 +-
 net/smc/smc_ib.c                                   |  19 ++-
 net/sunrpc/clnt.c                                  |   5 +-
 net/sunrpc/xprtsock.c                              |   1 +
 net/tipc/msg.c                                     |   8 +-
 net/wireless/nl80211.c                             |   2 +
 net/wireless/trace.h                               |   2 +-
 net/xfrm/xfrm_input.c                              |   8 +
 rust/macros/module.rs                              | 185 +++++++++++++--------
 scripts/Makefile.modfinal                          |   2 +-
 security/keys/key.c                                |   3 +-
 sound/hda/intel-sdw-acpi.c                         |   2 +
 sound/oss/dmasound/dmasound_paula.c                |   8 +-
 sound/pci/emu10k1/emu10k1.c                        |   3 +-
 sound/pci/emu10k1/emu10k1_main.c                   | 139 +++++++++-------
 sound/pci/hda/patch_realtek.c                      |  25 ++-
 sound/soc/codecs/es8326.c                          |  30 ++--
 sound/soc/codecs/es8326.h                          |   2 +-
 sound/soc/codecs/wsa881x.c                         |   1 +
 sound/soc/intel/avs/topology.c                     |   2 +
 sound/soc/meson/Kconfig                            |   1 +
 sound/soc/meson/axg-card.c                         |   1 +
 sound/soc/meson/axg-fifo.c                         |  56 ++++---
 sound/soc/meson/axg-fifo.h                         |  12 +-
 sound/soc/meson/axg-frddr.c                        |   5 +-
 sound/soc/meson/axg-tdm-interface.c                |  34 ++--
 sound/soc/meson/axg-toddr.c                        |  22 ++-
 sound/soc/sof/intel/hda-dsp.c                      |  20 ++-
 sound/soc/sof/intel/pci-lnl.c                      |   3 +
 sound/soc/tegra/tegra186_dspk.c                    |   7 +-
 sound/soc/ti/davinci-mcasp.c                       |  12 +-
 sound/usb/line6/driver.c                           |   6 +-
 tools/include/linux/kernel.h                       |   1 +
 tools/include/linux/mm.h                           |   5 +
 tools/include/linux/panic.h                        |  19 +++
 tools/power/x86/turbostat/turbostat.8              |   2 +-
 tools/power/x86/turbostat/turbostat.c              | 163 +++++++++++++-----
 .../selftests/bpf/prog_tests/bloom_filter_map.c    |   6 +
 .../ftrace/test.d/filter/event-filter-function.tc  |   2 +-
 tools/testing/selftests/mm/Makefile                |   6 +-
 .../selftests/net/test_bridge_neigh_suppress.sh    |  14 +-
 tools/testing/selftests/timers/valid-adjtimex.c    |  73 ++++----
 377 files changed, 3373 insertions(+), 1845 deletions(-)


