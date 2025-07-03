Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358DF2EF292;
	Thu,  3 Jul 2025 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555522; cv=none; b=lLgIRVLpQqiE+HxVb9mWw7GvNbEdMkZyYXd+ScHSmKTVJQ040rBAelkcyVMqbBB/oUZdFpygNB2hbF+ICVY7ALSWXha9IPEss3C62NhhyMTLasTjCFTUAjxwEMBIzZHg+TuuFnzKLmdEmqo98eh8oDe97bpHqhHZBa8+8Wk7BTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555522; c=relaxed/simple;
	bh=YegsqQCJyWOfx2aJY/ifr3VoxKJps6iamiDOW+xJyjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OlAG2HtsRwBzXY4cCqxbelmgoUgZVCB4fyyP7oX7kxzAR6ngksD4CVyNqvuAUicDEAdub8nb8UeVHz+8aOBUNRYwIiDB6FAz8rkqpOMGX9Z/znibmalaKET0gm8hzSZGGYxV8PenGDQiwiuvbaa2FR9opztE/07P9aPt8m3poFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pf0SEbWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pf0SEbWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54060C4CEE3;
	Thu,  3 Jul 2025 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555522;
	bh=YegsqQCJyWOfx2aJY/ifr3VoxKJps6iamiDOW+xJyjQ=;
	h=From:To:Cc:Subject:Date:From;
	b=pf0SEbWc6vqnlf6wWf3KJM/r6tSnZCnGhR4ExUeshpo9Cc5U9nNWIOESFB0VwrjHh
	 MmrLGom6geHrCUxNxqwc0do0We3sicH0Y1xnJIWx9GIh32rIQkCYB175RjCjqHzY20
	 +6Xa4LlP+OFJsdgFpchPD7rm0xXnA6UsJt6u/VGU=
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
Subject: [PATCH 6.6 000/139] 6.6.96-rc1 review
Date: Thu,  3 Jul 2025 16:41:03 +0200
Message-ID: <20250703143941.182414597@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.96-rc1
X-KernelTest-Deadline: 2025-07-05T14:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.96 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.96-rc1

Sibi Sankar <quic_sibis@quicinc.com>
    firmware: arm_scmi: Ensure that the message-id supports fastchannel

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add a common helper to check if a message is supported

Jens Axboe <axboe@kernel.dk>
    nvme: always punt polled uring_cmd end_io work to task_work

Khairul Anuar Romli <khairul.anuar.romli@altera.com>
    spi: spi-cadence-quadspi: Fix pm runtime unbalance

Brett A C Sheffield (Librecast) <bacs@librecast.net>
    Revert "ipv6: save dontfrag in cork"

Nathan Chancellor <nathan@kernel.org>
    x86/tools: Drop duplicate unlikely() definition in insn_decoder_test.c

Sergio González Collado <sergio.collado@gmail.com>
    Kunit to check the longest symbol length

Heiko Carstens <hca@linux.ibm.com>
    s390/entry: Fix last breaking event handling in case of stack corruption

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Rollback non processed entities on error

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    kbuild: rpm-pkg: simplify installkernel %post

Masahiro Yamada <masahiroy@kernel.org>
    scripts: clean up IA-64 code

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: remove unsafe_memcpy use in session setup

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: Use unsafe_memcpy() for ntlm_negotiate

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: switch job hw_fence to amdgpu_fence

Frank Min <Frank.Min@amd.com>
    drm/amdgpu: Add kicker device detection

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/gem: Allow EXEC_CAPTURE on recoverable contexts on DG1

John Olender <john.olender@gmail.com>
    drm/amdgpu: amdgpu_vram_mgr_new(): Clamp lpfn to total vram

Wentao Liang <vulab@iscas.ac.cn>
    drm/amd/display: Add null pointer check for get_first_active_display()

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Wait for Clk and Data Lanes to be ready

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Check return value when getting default PHY config

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix connecting to next bridge

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix phy de-init and flag it so

Aradhya Bhatia <a-bhatia1@ti.com>
    drm/bridge: cdns-dsi: Fix the clock variable for mode_valid()

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: Fix race in GWS queue scheduling

Stephan Gerhold <stephan.gerhold@linaro.org>
    drm/msm/gpu: Fix crash when throttling GPU immediately during boot

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Unregister device before cleaning up on disconnect

Qiu-ji Chen <chenqiuji666@gmail.com>
    drm/tegra: Fix a possible null pointer dereference

Thierry Reding <treding@nvidia.com>
    drm/tegra: Assign plane type before registration

Maíra Canal <mcanal@igalia.com>
    drm/etnaviv: Protect the scheduler's pending list with its lock

Thomas Zimmermann <tzimmermann@suse.de>
    drm/cirrus-qemu: Fix pitch programming

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Fix comment on modeset lock

Chen Yu <yu.c.chen@intel.com>
    scsi: megaraid_sas: Fix invalid node index

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix kobject reference count leak

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on sysfs attribute creation failure

Qasim Ijaz <qasdev00@gmail.com>
    HID: wacom: fix memory leak on kobject creation failure

Iusico Maxim <iusico.maxim@libero.it>
    HID: lenovo: Restrict F7/9/11 mode to compact keyboards only

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix the creation of page_pool

Mark Harmstone <maharmstone@fb.com>
    btrfs: update superblock's device bytes_used when dropping chunk

Filipe Manana <fdmanana@suse.com>
    btrfs: fix a race between renames and directory logging

Heinz Mauelshagen <heinzm@redhat.com>
    dm-raid: fix variable in journal device check

Frédéric Danis <frederic.danis@collabora.com>
    Bluetooth: L2CAP: Fix L2CAP MTU negotiation

Fabio Estevam <festevam@gmail.com>
    serial: imx: Restore original RXTL for console to fix data loss

Yao Zi <ziyao@disroot.org>
    dt-bindings: serial: 8250: Make clocks and clock-frequency exclusive

Nathan Chancellor <nathan@kernel.org>
    staging: rtl8723bs: Avoid memset() in aes_cipher() and aes_decipher()

Avadhut Naik <avadhut.naik@amd.com>
    EDAC/amd64: Fix size calculation for Non-Power-of-Two DIMMs

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix potential deadlock when reconnecting channels

Jayesh Choudhary <j-choudhary@ti.com>
    drm/bridge: ti-sn65dsi86: Add HPD for DisplayPort connector type

Wolfram Sang <wsa+renesas@sang-engineering.com>
    drm/bridge: ti-sn65dsi86: make use of debugfs_init callback

Arnd Bergmann <arnd@arndb.de>
    drm/i915: fix build error some more

Jakub Kicinski <kuba@kernel.org>
    net: selftests: fix TCP packet checksum

Salvatore Bonaccorso <carnil@debian.org>
    ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X507UAR

Kuniyuki Iwashima <kuniyu@google.com>
    atm: Release atm_dev_mutex after removing procfs in atm_dev_deregister().

Simon Horman <horms@kernel.org>
    net: enetc: Correct endianness handling in _enetc_rd_reg64

Adin Scannell <amscanne@meta.com>
    libbpf: Fix possible use-after-free for externs

Tiwei Bie <tiwei.btw@antgroup.com>
    um: ubd: Add missing error check in start_io_thread()

Stefano Garzarella <sgarzare@redhat.com>
    vsock/uapi: fix linux/vm_sockets.h userspace compilation errors

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't set -ECONNRESET for consumed OOB skb.

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: fix beacon interval calculation overflow

Yuan Chen <chenyuan@kylinos.cn>
    libbpf: Fix null pointer dereference in btf_dump__free on allocation failure

Al Viro <viro@zeniv.linux.org.uk>
    attach_recursive_mnt(): do not lock the covering tree when sliding something under it

Youngjun Lee <yjjuny.lee@samsung.com>
    ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()

Eric Dumazet <edumazet@google.com>
    atm: clip: prevent NULL deref in clip_push()

Imre Deak <imre.deak@intel.com>
    drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS

Yu Kuai <yukuai3@huawei.com>
    lib/group_cpus: fix NULL pointer dereference from group_cpus_evenly()

Fedor Pchelkin <pchelkin@ispras.ru>
    s390/pkey: Prevent overflow in size calculation for memdup_user()

Oliver Schramm <oliver.schramm97@gmail.com>
    ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: robotfuzz-osif: disable zero-length read messages

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: tiny-usb: disable zero-length read messages

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Don't leave consecutive consumed OOB skbs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Don't call skb_get() for OOB skb.

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Define locking order for U_RECVQ_LOCK_EMBRYO in unix_collect_skb().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Define locking order for U_LOCK_SECOND in unix_state_double_lock().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Define locking order for unix_table_double_lock().

Rong Zhang <i@rong.moe>
    platform/x86: ideapad-laptop: use usleep_range() for EC polling

Gergo Koteles <soyer@irl.hu>
    platform/x86: ideapad-laptop: move ACPI helpers from header to source file

Gergo Koteles <soyer@irl.hu>
    platform/x86: ideapad-laptop: move ymc_trigger_ec from lenovo-ymc

Gergo Koteles <soyer@irl.hu>
    platform/x86: ideapad-laptop: introduce a generic notification chain

Thomas Zimmermann <tzimmermann@suse.de>
    dummycon: Trigger redraw when switching consoles with deferred takeover

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: vt: make consw::con_switch() return a bool

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: vt: sanitize arguments of consw::con_clear()

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: vt: make init parameter of consw::con_init() a bool

Janne Grunau <j@jannau.net>
    PCI: apple: Set only available ports up

Zhang Zekun <zhangzekun11@huawei.com>
    PCI: apple: Use helper function for_each_child_of_node_scoped()

Long Li <longli@microsoft.com>
    uio_hv_generic: Align ring size to system page

Saurabh Sengar <ssengar@linux.microsoft.com>
    uio_hv_generic: Query the ringbuffer size for device

Saurabh Sengar <ssengar@linux.microsoft.com>
    Drivers: hv: vmbus: Add utility function for querying ring size

Chao Yu <chao@kernel.org>
    f2fs: don't over-report free space or inodes in statvfs

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9335: Fix missing free of regulator supplies

Peng Fan <peng.fan@nxp.com>
    ASoC: codec: wcd9335: Convert to GPIO descriptors

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wcd9335: Handle nicer probe deferral and simplify with dev_err_probe()

Vasiliy Kovalev <kovalev@altlinux.org>
    jfs: validate AG parameters in dbMount() to prevent crashes

Dave Kleikamp <dave.kleikamp@oracle.com>
    fs/jfs: consolidate sanity checking in dbMount

Qu Wenruo <wqu@suse.com>
    btrfs: handle csum tree error with rescue=ibadroots correctly

Kees Cook <kees@kernel.org>
    ovl: Check for NULL d_inode() in ovl_dentry_upper()

Ziqi Chen <quic_ziqichen@quicinc.com>
    scsi: ufs: core: Don't perform UFS clkscaling during host async scan

Dmitry Kandybka <d.kandybka@gmail.com>
    ceph: fix possible integer overflow in ceph_zero_objects()

Mario Limonciello <mario.limonciello@amd.com>
    ALSA: usb-audio: Add a quirk for Lenovo Thinkpad Thunderbolt 3 dock

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ALSA: hda: Add new pci id for AMD GPU display HD audio controller

Cezary Rojewski <cezary.rojewski@intel.com>
    ALSA: hda: Ignore unsol events for cards being shut down

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: typec: mux: do not return on EOPNOTSUPP in {mux, switch}_set

Jos Wang <joswang@lenovo.com>
    usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode

Robert Hodaszi <robert.hodaszi@digi.com>
    usb: cdc-wdm: avoid setting WDM_READ for ZLP-s

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: Add checks for snprintf() calls in usb_alloc_dev()

Chance Yang <chance.yang@kneron.us>
    usb: common: usb-conn-gpio: use a unique name for usb connector device

Jakub Lewalski <jakub.lewalski@nokia.com>
    tty: serial: uartlite: register uart driver in init

Chen Yufeng <chenyufeng@iie.ac.cn>
    usb: potential integer overflow in usbg_make_tpg()

Chenyuan Yang <chenyuan0y@gmail.com>
    misc: tps6594-pfsm: Add NULL pointer check in tps6594_pfsm_probe()

Purva Yeshi <purvayeshi550@gmail.com>
    iio: adc: ad_sigma_delta: Fix use of uninitialized status_pos

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc2: also exit clock_gating when stopping udc while suspended

James Clark <james.clark@linaro.org>
    coresight: Only check bottom two claim bits

Benjamin Berg <benjamin.berg@intel.com>
    um: use proper care when taking mmap lock during segfault

Sami Tolvanen <samitolvanen@google.com>
    um: Add cmpxchg8b_emu and checksum functions to asm-prototypes.h

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: pressure: zpa2326: Use aligned_s64 for the timestamp

Lin.Cao <lincao12@amd.com>
    drm/scheduler: signal scheduled fence when kill job

Linggang Zeng <linggang.zeng@easystack.cn>
    bcache: fix NULL pointer in cache_set_flush()

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: fix a kfd_process ref leak

Yu Kuai <yukuai3@huawei.com>
    md/md-bitmap: fix dm-raid max_write_behind setting

Hector Martin <marcan@marcan.st>
    PCI: apple: Fix missing OF node reference in apple_pcie_setup_port

Wenbin Yao <quic_wenbyao@quicinc.com>
    PCI: dwc: Make link training more robust by setting PORT_LOGIC_LINK_WIDTH to one lane

Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
    dmaengine: xilinx_dma: Set dma_device directions

Yi Sun <yi.sun@intel.com>
    dmaengine: idxd: Check availability of workqueue allocated by idxd wq driver before using

Lukas Wunner <lukas@wunner.de>
    Revert "iommu/amd: Prevent binding other PCI drivers to IOMMU PCI devices"

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: module: place cleanup_module() in .exit.text section

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: provide zero as a unique ID to the Mac client

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: allow a filename to contain special characters on SMB3.1.1 posix extension

Alexis Czezar Torreno <alexisczezar.torreno@analog.com>
    hwmon: (pmbus/max34440) Fix support for max34451

Scott Mayhew <smayhew@redhat.com>
    NFSv4: xattr handlers should check for absent nfs filehandles

Robert Richter <rrichter@amd.com>
    cxl/region: Add a dev_err() on missing target list entries

Guang Yuan Wu <gwu@ddn.com>
    fuse: fix race between concurrent setattrs from multiple nodes

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    leds: multicolor: Fix intensity setting while SW blinking

Nikhil Jha <njha@janestreet.com>
    sunrpc: don't immediately retransmit on seqno miss

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mfd: max14577: Fix wakeup source leaks on device unbind

Peng Fan <peng.fan@nxp.com>
    mailbox: Not protect module_put with spin_lock_irqsave

Olga Kornievskaia <okorniev@redhat.com>
    NFSv4.2: fix listxattr to return selinux security label

Han Young <hanyang.tony@bytedance.com>
    NFSv4: Always set NLINK even if the server doesn't support it

Pali Rohár <pali@kernel.org>
    cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in non-UNICODE mode

Pali Rohár <pali@kernel.org>
    cifs: Fix cifs_query_path_info() for Windows NT servers

Pali Rohár <pali@kernel.org>
    cifs: Correctly set SMB1 SessionKey field in Session Setup Request


-------------

Diffstat:

 Documentation/devicetree/bindings/serial/8250.yaml |   2 +-
 Makefile                                           |   4 +-
 arch/s390/kernel/entry.S                           |   2 +-
 arch/um/drivers/ubd_user.c                         |   2 +-
 arch/um/include/asm/asm-prototypes.h               |   5 +
 arch/um/kernel/trap.c                              | 129 +++++++++--
 arch/x86/tools/insn_decoder_test.c                 |   5 +-
 arch/x86/um/asm/checksum.h                         |   3 +
 drivers/cxl/core/region.c                          |   7 +
 drivers/dma/idxd/cdev.c                            |   4 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   2 +
 drivers/edac/amd64_edac.c                          |  57 +++--
 drivers/firmware/arm_scmi/driver.c                 |  44 ++++
 drivers/firmware/arm_scmi/protocols.h              |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |  30 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  16 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |  17 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.h          |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   1 +
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |   2 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   3 +
 drivers/gpu/drm/ast/ast_mode.c                     |   6 +-
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |  32 ++-
 drivers/gpu/drm/bridge/ti-sn65dsi86.c              | 109 ++++++----
 drivers/gpu/drm/display/drm_dp_helper.c            |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   5 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/i915/i915_pmu.c                    |   2 +-
 drivers/gpu/drm/msm/msm_gpu_devfreq.c              |   1 +
 drivers/gpu/drm/scheduler/sched_entity.c           |   1 +
 drivers/gpu/drm/tegra/dc.c                         |  17 +-
 drivers/gpu/drm/tegra/hub.c                        |   4 +-
 drivers/gpu/drm/tegra/hub.h                        |   3 +-
 drivers/gpu/drm/tiny/cirrus.c                      |   1 -
 drivers/gpu/drm/udl/udl_drv.c                      |   2 +-
 drivers/hid/hid-lenovo.c                           |  11 +-
 drivers/hid/wacom_sys.c                            |   6 +-
 drivers/hv/channel_mgmt.c                          |  15 +-
 drivers/hv/hyperv_vmbus.h                          |   5 +
 drivers/hwmon/pmbus/max34440.c                     |  48 ++++-
 drivers/hwtracing/coresight/coresight-core.c       |   3 +-
 drivers/hwtracing/coresight/coresight-priv.h       |   1 +
 drivers/i2c/busses/i2c-robotfuzz-osif.c            |   6 +
 drivers/i2c/busses/i2c-tiny-usb.c                  |   6 +
 drivers/iio/adc/ad_sigma_delta.c                   |   4 +
 drivers/iio/pressure/zpa2326.c                     |   2 +-
 drivers/iommu/amd/init.c                           |   3 -
 drivers/leds/led-class-multicolor.c                |   3 +-
 drivers/mailbox/mailbox.c                          |   2 +-
 drivers/md/bcache/super.c                          |   7 +-
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/md-bitmap.c                             |   2 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  41 ++--
 drivers/mfd/max14577.c                             |   1 +
 drivers/misc/tps6594-pfsm.c                        |   3 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   2 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   2 +-
 drivers/nvme/host/ioctl.c                          |  16 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   5 +-
 drivers/pci/controller/pcie-apple.c                |   7 +-
 drivers/platform/x86/Kconfig                       |   1 +
 drivers/platform/x86/ideapad-laptop.c              | 237 +++++++++++++++++++++
 drivers/platform/x86/ideapad-laptop.h              | 142 +-----------
 drivers/platform/x86/lenovo-ymc.c                  |  60 +-----
 drivers/s390/crypto/pkey_api.c                     |   2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   6 +-
 drivers/spi/spi-cadence-quadspi.c                  |  11 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |  44 ++--
 drivers/tty/serial/imx.c                           |  17 +-
 drivers/tty/serial/uartlite.c                      |  25 ++-
 drivers/tty/vt/vt.c                                |  12 +-
 drivers/ufs/core/ufshcd.c                          |   3 +
 drivers/uio/uio_hv_generic.c                       |  10 +-
 drivers/usb/class/cdc-wdm.c                        |  23 +-
 drivers/usb/common/usb-conn-gpio.c                 |  25 ++-
 drivers/usb/core/usb.c                             |  14 +-
 drivers/usb/dwc2/gadget.c                          |   6 +
 drivers/usb/gadget/function/f_tcm.c                |   4 +-
 drivers/usb/typec/altmodes/displayport.c           |   4 +
 drivers/usb/typec/mux.c                            |   4 +-
 drivers/video/console/dummycon.c                   |  24 ++-
 drivers/video/console/mdacon.c                     |  21 +-
 drivers/video/console/newport_con.c                |  12 +-
 drivers/video/console/sticon.c                     |  14 +-
 drivers/video/console/vgacon.c                     |  12 +-
 drivers/video/fbdev/core/fbcon.c                   |  40 ++--
 fs/btrfs/disk-io.c                                 |   3 +-
 fs/btrfs/inode.c                                   |  83 ++++++--
 fs/btrfs/volumes.c                                 |   6 +
 fs/ceph/file.c                                     |   2 +-
 fs/f2fs/super.c                                    |  30 +--
 fs/fuse/dir.c                                      |  11 +
 fs/jfs/jfs_dmap.c                                  |  41 ++--
 fs/namespace.c                                     |   8 +-
 fs/nfs/inode.c                                     |   2 +
 fs/nfs/nfs4proc.c                                  |  17 +-
 fs/overlayfs/util.c                                |   4 +-
 fs/smb/client/cifsglob.h                           |   2 +
 fs/smb/client/cifspdu.h                            |   6 +-
 fs/smb/client/cifssmb.c                            |   1 +
 fs/smb/client/connect.c                            |  58 +++--
 fs/smb/client/misc.c                               |   8 +
 fs/smb/client/sess.c                               |  21 +-
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/smb2pdu.c                            |  81 ++++---
 fs/smb/server/smb2pdu.h                            |   3 +
 include/linux/console.h                            |  13 +-
 include/linux/hyperv.h                             |   2 +
 include/linux/ipv6.h                               |   1 -
 include/uapi/linux/vm_sockets.h                    |   4 +
 lib/Kconfig.debug                                  |   9 +
 lib/Makefile                                       |   2 +
 lib/group_cpus.c                                   |   9 +-
 lib/longest_symbol_kunit.c                         |  82 +++++++
 mm/damon/sysfs-schemes.c                           |   1 +
 net/atm/clip.c                                     |  11 +-
 net/atm/resources.c                                |   3 +-
 net/bluetooth/l2cap_core.c                         |   9 +-
 net/core/selftests.c                               |   5 +-
 net/ipv6/ip6_output.c                              |   9 +-
 net/mac80211/util.c                                |   2 +-
 net/sunrpc/clnt.c                                  |   9 +-
 net/unix/af_unix.c                                 | 107 +++++++---
 net/unix/garbage.c                                 |  24 +--
 rust/macros/module.rs                              |   1 +
 scripts/checkstack.pl                              |   3 -
 scripts/gdb/linux/tasks.py                         |  15 +-
 scripts/head-object-list.txt                       |   1 -
 scripts/kconfig/mconf.c                            |   2 +-
 scripts/kconfig/nconf.c                            |   2 +-
 scripts/package/kernel.spec                        |  28 +--
 scripts/package/mkdebian                           |   2 +-
 scripts/recordmcount.c                             |   1 -
 scripts/recordmcount.pl                            |   7 -
 scripts/xz_wrap.sh                                 |   1 -
 sound/pci/hda/hda_bind.c                           |   2 +-
 sound/pci/hda/hda_intel.c                          |   3 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/wcd9335.c                         |  62 ++----
 sound/usb/quirks.c                                 |   2 +
 sound/usb/stream.c                                 |   2 +
 tools/lib/bpf/btf_dump.c                           |   3 +
 tools/lib/bpf/libbpf.c                             |  10 +-
 .../selftests/bpf/progs/test_global_map_resize.c   |  16 ++
 150 files changed, 1558 insertions(+), 833 deletions(-)


