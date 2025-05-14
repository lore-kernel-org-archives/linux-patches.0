Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AE615AF6;
	Wed, 14 May 2025 13:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227946; cv=none; b=dcpjrb2k5ka6Y9ugrI+OLJVInaf8NGBOlDYLsLK04CRsSuiuukICFjGOtoPWsRzD6eGl+ycHwmUNiVfZUzlhzaLz4Bkg/tlYczN1/1R6Hq5FEz4R+Lo7MD1qYxd6uunVNBGKEABuJQUYesraBbcp8U/45nE9kMFmiLxbLPDUWuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227946; c=relaxed/simple;
	bh=pn1kAeQIOzOfHZxf6BMUPi5Goy7hkVbEVyXlTFRcjpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=prE9lAaXm6aUvIXJsYZMeGv6VvhRfszadRSCmptaQSf/zBCoPlHralT097sUwXwC1NMQJe7Nequ73KFyiAWQljChR3mSOCYOlM3mbdjmbXKORB3xoN62NZILfztjba67cbeepB1tp0fiLSsZUfhfRwmkkip7lrBLSFkuTO7xPNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uS0ODj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uS0ODj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D5C4CEE9;
	Wed, 14 May 2025 13:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747227944;
	bh=pn1kAeQIOzOfHZxf6BMUPi5Goy7hkVbEVyXlTFRcjpo=;
	h=From:To:Cc:Subject:Date:From;
	b=0uS0ODj+mDnY07NYeWPBeUjAB5N/RG6YxQOfc14uVJ5XRgsKqKacoSPAWUR+3zeoT
	 7rFKN8bpK7CZYVeHXqXw8xRgDUE34rFgtHjp4qzRwRn8UUMLcRaLK6ul6bKiia9ylL
	 Ud8L8hhk7XipmobhhAyXUnunW6BcxqaZY46Hy9BY=
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
Subject: [PATCH 6.12 000/184] 6.12.29-rc2 review
Date: Wed, 14 May 2025 15:03:56 +0200
Message-ID: <20250514125624.330060065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.29-rc2
X-KernelTest-Deadline: 2025-05-16T12:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.29 release.
There are 184 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.29-rc2

Peter Zijlstra <peterz@infradead.org>
    x86/its: FineIBT-paranoid vs ITS

Eric Biggers <ebiggers@google.com>
    x86/its: Fix build errors when CONFIG_MODULES=n

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    selftest/x86/bugs: Add selftests for ITS

Peter Zijlstra <peterz@infradead.org>
    x86/its: Use dynamic thunks for indirect branches

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/ibt: Keep IBT disabled during alternative patching

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Align RETs in BHB clear sequence to avoid thunking

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add support for RSB stuffing mitigation

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add "vmexit" option to skip mitigation on some CPUs

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Enable Indirect Target Selection mitigation

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add support for ITS-safe return thunk

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Add support for ITS-safe indirect thunk

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/its: Enumerate Indirect Target Selection (ITS) bug

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    Documentation: x86/bugs/its: Add ITS documentation

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Remove the extra #ifdef around CALL_NOSPEC

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Add a conditional CS prefix to CALL_NOSPEC

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Simplify and make CALL_NOSPEC consistent

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bhi: Do not set BHI_DIS_S in 32-bit mode

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/bpf: Add IBHF call at end of classic BPF

Daniel Sneddon <daniel.sneddon@linux.intel.com>
    x86/bpf: Call branch history clearing sequence on exit

James Morse <james.morse@arm.com>
    arm64: proton-pack: Add new CPUs 'k' values for branch mitigation

James Morse <james.morse@arm.com>
    arm64: bpf: Only mitigate cBPF programs loaded by unprivileged users

James Morse <james.morse@arm.com>
    arm64: bpf: Add BHB mitigation to the epilogue for cBPF programs

James Morse <james.morse@arm.com>
    arm64: proton-pack: Expose whether the branchy loop k value

James Morse <james.morse@arm.com>
    arm64: proton-pack: Expose whether the platform is mitigated by firmware

James Morse <james.morse@arm.com>
    arm64: insn: Add support for encoding DSB

Omar Sandoval <osandov@fb.com>
    sched/eevdf: Fix se->slice being set to U64_MAX and resulting crash

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: speed up fallbacks in rmqueue_bulk()

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: don't steal single pages from biggest buddy

Hao Qin <hao.qin@mediatek.com>
    Bluetooth: btmtk: Remove the resetting step before downloading the fw

Hao Qin <hao.qin@mediatek.com>
    Bluetooth: btmtk: Remove resetting mt7921 before downloading the fw

Jens Axboe <axboe@kernel.dk>
    io_uring: always arm linked timeouts prior to issue

Miguel Ojeda <ojeda@kernel.org>
    rust: clean Rust 1.88.0's `clippy::uninlined_format_args` lint

Miguel Ojeda <ojeda@kernel.org>
    rust: allow Rust 1.87.0's `clippy::ptr_eq` lint

Christian Lamparter <chunkeey@gmail.com>
    Revert "um: work around sched_yield not yielding in time-travel mode"

Al Viro <viro@zeniv.linux.org.uk>
    do_umount(): add missing barrier before refcount checks in sync case

Gabriel Krisman Bertazi <krisman@suse.de>
    io_uring/sqpoll: Increase task_work submission batch size

Tejas Upadhyay <tejas.upadhyay@intel.com>
    drm/xe/tests/mocs: Hold XE_FORCEWAKE_ALL for LNCF regs

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe/tests/mocs: Update xe_force_wake_get() return handling

Clément Léger <cleger@rivosinc.com>
    riscv: misaligned: enable IRQs while handling misaligned accesses

Clément Léger <cleger@rivosinc.com>
    riscv: misaligned: factorize trap handling

Daniel Wagner <wagi@kernel.org>
    nvme: unblock ctrl state transition for firmware update

Kevin Baker <kevinb@ventureresearch.com>
    drm/panel: simple: Update timings for AUO G101EVN010

Lizhi Xu <lizhi.xu@windriver.com>
    loop: Add sanity check for read/write_iter

Christoph Hellwig <hch@lst.de>
    loop: factor out a loop_assign_backing_file helper

Christoph Hellwig <hch@lst.de>
    loop: refactor queue limits updates

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    loop: Fix ABBA locking race

John Garry <john.g.garry@oracle.com>
    loop: Simplify discard granularity calc

John Garry <john.g.garry@oracle.com>
    loop: Use bdev limit helpers for configuring discard

Nylon Chen <nylon.chen@sifive.com>
    riscv: misaligned: Add handling for ZCB instructions

Thorsten Blum <thorsten.blum@linux.dev>
    MIPS: Fix MAX_REG_OFFSET

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: dln2: Use aligned_s64 for timestamp

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    types: Complement the aligned types with signed 64-bit one

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: temp: maxim-thermocouple: Fix potential lack of DMA safe buffer.

Lothar Rubusch <l.rubusch@gmail.com>
    iio: accel: adxl367: fix setting odr for activity time update

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix erroneous generic_read ioctl return

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix erroneous wait_srq ioctl return

Dave Penkler <dpenkler@gmail.com>
    usb: usbtmc: Fix erroneous get_stb ioctl error returns

Oliver Neukum <oneukum@suse.com>
    USB: usbtmc: use interruptible sleep in usbtmc_read

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: displayport: Fix NULL pointer access

RD Babiera <rdbabiera@google.com>
    usb: typec: tcpm: delay SNK_TRY_WAIT_DEBOUNCE to SRC_TRYWAIT transition

Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
    usb: misc: onboard_usb_dev: fix support for Cypress HX3 hubs

Jim Lin <jilin@nvidia.com>
    usb: host: tegra: Prevent host controller crash when OTG port is used

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: Use get_status callback to set remote wakeup capability

Wayne Chang <waynec@nvidia.com>
    usb: gadget: tegra-xudc: ACK ST_RC after clearing CTRL_RUN

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: gadget: f_ecm: Add get_status callback

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix L1 resume issue for RTL_REVISION_NEW_LPM version

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with resuming from L1

Prashanth K <prashanth.k@oss.qualcomm.com>
    usb: dwc3: gadget: Make gadget_wakeup asynchronous

Jan Kara <jack@suse.cz>
    ocfs2: stop quota recovery before disabling quotas

Jan Kara <jack@suse.cz>
    ocfs2: implement handshaking with ocfs2 recovery thread

Jan Kara <jack@suse.cz>
    ocfs2: switch osb->disable_recovery to enum

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix the issue with discontiguous allocation in the global_bitmap

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode: Consolidate the loader enablement checking

Dmitry Antipov <dmantipov@yandex.ru>
    module: ensure that kobject_put() is safe for module type kobjects

Tom Lendacky <thomas.lendacky@amd.com>
    memblock: Accept allocated memory before use in memblock_double_array()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    clocksource/i8253: Use raw_spinlock_irqsave() in clockevent_i8253_disable()

Yeoreum Yun <yeoreum.yun@arm.com>
    arm64: cpufeature: Move arm64_use_ng_mappings to the .data section to prevent wrong idmap generation

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Increase state dump msg timeout

Jason Andryuk <jason.andryuk@amd.com>
    xenbus: Use kref to track req lifetime

John Ernberg <john.ernberg@actia.se>
    xen: swiotlb: Use swiotlb bouncing if kmalloc allocation demands it

Paul Aurich <paul@darkrain42.org>
    smb: client: Avoid race in open_cached_dir with lease breaks

Alexey Charkov <alchark@gmail.com>
    usb: uhci-platform: Make the clock really optional

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp7: use memcfg register to post the write for HDP flush

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp6: use memcfg register to post the write for HDP flush

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp5: use memcfg register to post the write for HDP flush

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp5.2: use memcfg register to post the write for HDP flush

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/hdp4: use memcfg register to post the write for HDP flush

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Copy AUX read reply data whenever length > 0

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Fix wrong handling for AUX_DEFER case

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Remove incorrect checking in dmub aux handler

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Fix the checking condition in dmub aux handling

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: more liberal vmin/vmax update for freesync

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix invalid context error in dml helper

Ruijing Dong <ruijing.dong@amd.com>
    drm/amdgpu/vcn: using separate VCN1_AON_SOC offset

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Add page queue multiplier

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Add job to pending list if the reset was skipped

Silvano Seva <s.seva@4sigma.it>
    iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_tagged_fifo

Silvano Seva <s.seva@4sigma.it>
    iio: imu: st_lsm6dsx: fix possible lockup in st_lsm6dsx_read_fifo

David Lechner <dlechner@baylibre.com>
    iio: imu: inv_mpu6050: align buffer for timestamp

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    iio: adis16201: Correct inclinometer channel resolution

Simon Xue <xxm@rock-chips.com>
    iio: adc: rockchip: Fix clock initialization sequence

Angelo Dureghello <adureghello@baylibre.com>
    iio: adc: ad7606: fix serial register access

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure deferred completions are flushed for multishot

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Shift DMUB AUX reply command if necessary

Mikhail Lobanov <m.lobanov@rosa.ru>
    KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception

Nysal Jan K.A. <nysal@linux.ibm.com>
    selftests/mm: fix a build failure on powerpc

Feng Tang <feng.tang@linux.alibaba.com>
    selftests/mm: compaction_test: support platform with huge mount of memory

Peter Xu <peterx@redhat.com>
    mm/userfaultfd: fix uninitialized output field for -EAGAIN race

Gavin Guo <gavinguo@igalia.com>
    mm/huge_memory: fix dereferencing invalid pmd migration entry

Kees Cook <kees@kernel.org>
    mm: vmalloc: support more granular vrealloc() sizing

Petr Vaněk <arkamar@atlas.cz>
    mm: fix folio_pte_batch() on XEN PV

Dave Hansen <dave.hansen@linux.intel.com>
    x86/mm: Eliminate window where TLB flushes may be inadvertently skipped

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: axis-fifo: Correct handling of tx_fifo_depth for size validation

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: axis-fifo: Remove hardware resets for user errors

Dave Stevenson <dave.stevenson@raspberrypi.com>
    staging: bcm2835-camera: Initialise dev in v4l2_dev

Gabriel Shahrouzi <gshahrouzi@gmail.com>
    staging: iio: adc: ad7816: Correct conditional logic for store mode

Miguel Ojeda <ojeda@kernel.org>
    rust: clean Rust 1.88.0's warning about `clippy::disallowed_macros` configuration

Miguel Ojeda <ojeda@kernel.org>
    objtool/rust: add one more `noreturn` Rust function for Rust 1.87.0

Miguel Ojeda <ojeda@kernel.org>
    rust: clean Rust 1.88.0's `unnecessary_transmutes` lint

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on TUXEDO InfinityBook Pro 14 v5

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics - enable SMBus for HP Elitebook 850 G1

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on Dell Precision M3800

Aditya Garg <gargaditya08@live.com>
    Input: synaptics - enable InterTouch on Dynabook Portege X30L-G

Manuel Fombuena <fombuena@outlook.com>
    Input: synaptics - enable InterTouch on Dynabook Portege X30-D

Vicki Pfau <vi@endrift.com>
    Input: xpad - fix two controller table values

Lode Willems <me@lodewillems.com>
    Input: xpad - add support for 8BitDo Ultimate 2 Wireless Controller

Vicki Pfau <vi@endrift.com>
    Input: xpad - fix Share button on Xbox One controllers

Gary Bisson <bisson.gary@gmail.com>
    Input: mtk-pmic-keys - fix possible null pointer dereference

Mikael Gonella-Bolduc <mgonellabolduc@dimonoff.com>
    Input: cyttsp5 - fix power control issue on wakeup

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    Input: cyttsp5 - ensure minimum reset pulse width

Jakub Kicinski <kuba@kernel.org>
    virtio-net: fix total qstat values

Jakub Kicinski <kuba@kernel.org>
    net: export a helper for adding up queue stats

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Do not allow mailbox to toggle to ready outside fbnic_mbx_poll_tx_ready

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Pull fbnic_fw_xmit_cap_msg use out of interrupt context

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Improve responsiveness of fbnic_mbx_poll_tx_ready

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Actually flush_tx instead of stalling out

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Gate AXI read/write enabling on FW mailbox

Alexander Duyck <alexanderduyck@fb.com>
    fbnic: Fix initialization of mailbox descriptor rings

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not set learning and unicast/multicast on up

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix learning on VLAN unaware bridges

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix toggling vlan_filtering

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not program vlans when vlan filtering is off

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: do not allow to configure VLAN 0

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: always rejoin default untagged VLAN on bridge leave

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix flushing old pvid VLAN on pvid change

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: fix clearing PVID of a port

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: keep CPU port always tagged again

Jonas Gorski <jonas.gorski@gmail.com>
    net: dsa: b53: allow leaky reserved multicast

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Scrub packet on bpf_redirect_peer

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: fix region locking in hash types

Julian Anastasov <ja@ssi.bg>
    ipvs: fix uninit-value for saddr in do_output_route4

Gao Xiang <xiang@kernel.org>
    erofs: ensure the extra temporary copy is valid for shortened bvecs

Przemek Kitszel <przemyslaw.kitszel@intel.com>
    ice: use DSN instead of PCI BDF for ice_adapter index

Sergey Temerkhanov <sergey.temerkhanov@intel.com>
    ice: Initial support for E825C hardware in ice_adapter

Michael-CY Lee <michael-cy.lee@mediatek.com>
    wifi: mac80211: fix the type of status_code for negotiated TID to Link Mapping

Oliver Hartkopp <socketcan@hartkopp.net>
    can: gw: fix RCU/BH usage in cgw_create_job()

Kelsey Maes <kelsey@vpprocess.com>
    can: mcp251xfd: fix TDC setting for low data bit rates

Antonios Salios <antonios@mwa.re>
    can: m_can: m_can_class_allocate_dev(): initialize spin lock on device probe

Frank Wunderlich <frank-w@public-files.de>
    net: ethernet: mtk_eth_soc: do not reset PSE when setting FE

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mtk_eth_soc: reset all TX queues on DMA free

Guillaume Nault <gnault@redhat.com>
    gre: Fix again IPv6 link-local address generation.

Jakub Kicinski <kuba@kernel.org>
    virtio-net: free xsk_buffs on error in virtnet_xsk_pool_enable()

Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    virtio_net: xsk: bind/unbind xsk for tx

Cong Wang <xiyou.wangcong@gmail.com>
    sch_htb: make htb_deactivate() idempotent

Heiko Carstens <hca@linux.ibm.com>
    s390/entry: Fix last breaking event handling in case of stack corruption

Wang Zhaolong <wangzhaolong1@huawei.com>
    ksmbd: fix memory leak in parse_lease_state()

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix unsafe attribute parsing in output_userspace()

Sean Heelan <seanheelan@gmail.com>
    ksmbd: Fix UAF in __close_file_table_ids

Norbert Szetei <norbert@doyensec.com>
    ksmbd: prevent out-of-bounds stream writes by validating *pos

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent rename with empty string

Marc Kleine-Budde <mkl@pengutronix.de>
    can: rockchip_canfd: rkcanfd_remove(): fix order of unregistration calls

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_remove(): fix order of unregistration calls

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix duplicate pci_dev_put() in disable_slot() when PF has child VFs

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Align huge faults to order

Veerendranath Jakkam <quic_vjakkam@quicinc.com>
    wifi: cfg80211: fix out-of-bounds access during multi-link element defragmentation

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: Fix missing check for zpci_create_device() error return

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcan: m_can_class_unregister(): fix order of unregistration calls

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix timeout checks on polling path

Wojciech Dubowik <Wojciech.Dubowik@mt.com>
    arm64: dts: imx8mm-verdin: Link reg_usdhc2_vqmmc to usdhc2

Qu Wenruo <wqu@suse.com>
    Revert "btrfs: canonicalize the device path before adding it"

Max Kellermann <max.kellermann@ionos.com>
    fs/erofs/fileio: call erofs_onlinefolio_split() after bio_add_folio()

Dan Carpenter <dan.carpenter@linaro.org>
    dm: add missing unlock on in dm_keyslot_evict()


-------------

Diffstat:

 .clippy.toml                                       |   2 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu |   1 +
 Documentation/admin-guide/hw-vuln/index.rst        |   1 +
 .../hw-vuln/indirect-target-selection.rst          | 168 ++++++++++++++++
 Documentation/admin-guide/kernel-parameters.txt    |  18 ++
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi   |  25 ++-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/include/asm/insn.h                      |   1 +
 arch/arm64/include/asm/spectre.h                   |   3 +
 arch/arm64/kernel/cpufeature.c                     |   9 +-
 arch/arm64/kernel/proton-pack.c                    |  13 +-
 arch/arm64/lib/insn.c                              |  76 +++++---
 arch/arm64/net/bpf_jit_comp.c                      |  57 +++++-
 arch/mips/include/asm/ptrace.h                     |   3 +-
 arch/riscv/kernel/traps.c                          |  64 ++++---
 arch/riscv/kernel/traps_misaligned.c               |  17 ++
 arch/s390/kernel/entry.S                           |   3 +-
 arch/s390/pci/pci_clp.c                            |   2 +
 arch/um/include/linux/time-internal.h              |   2 -
 arch/um/kernel/skas/syscall.c                      |  11 --
 arch/x86/Kconfig                                   |  12 ++
 arch/x86/entry/entry_64.S                          |  20 +-
 arch/x86/include/asm/alternative.h                 |  32 ++++
 arch/x86/include/asm/cpufeatures.h                 |   3 +
 arch/x86/include/asm/microcode.h                   |   2 +
 arch/x86/include/asm/msr-index.h                   |   8 +
 arch/x86/include/asm/nospec-branch.h               |  38 ++--
 arch/x86/kernel/alternative.c                      | 208 +++++++++++++++++++-
 arch/x86/kernel/cpu/bugs.c                         | 176 ++++++++++++++++-
 arch/x86/kernel/cpu/common.c                       |  72 +++++--
 arch/x86/kernel/cpu/microcode/amd.c                |   6 +-
 arch/x86/kernel/cpu/microcode/core.c               |  60 +++---
 arch/x86/kernel/cpu/microcode/intel.c              |   2 +-
 arch/x86/kernel/cpu/microcode/internal.h           |   1 -
 arch/x86/kernel/ftrace.c                           |   2 +-
 arch/x86/kernel/head32.c                           |   4 -
 arch/x86/kernel/module.c                           |   6 +
 arch/x86/kernel/static_call.c                      |   4 +-
 arch/x86/kernel/vmlinux.lds.S                      |  10 +
 arch/x86/kvm/smm.c                                 |   1 +
 arch/x86/kvm/svm/svm.c                             |   4 +
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/lib/retpoline.S                           |  39 ++++
 arch/x86/mm/tlb.c                                  |  23 ++-
 arch/x86/net/bpf_jit_comp.c                        |  58 +++++-
 drivers/accel/ivpu/ivpu_hw.c                       |   2 +-
 drivers/base/cpu.c                                 |   3 +
 drivers/block/loop.c                               | 104 ++++++----
 drivers/bluetooth/btmtk.c                          |  12 +-
 drivers/clocksource/i8253.c                        |   4 +-
 drivers/firmware/arm_scmi/driver.c                 |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |   1 -
 drivers/gpu/drm/amd/amdgpu/hdp_v4_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v5_2.c              |  12 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v6_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/hdp_v7_0.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c            |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  36 ++--
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  28 ++-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |  14 +-
 drivers/gpu/drm/panel/panel-simple.c               |  25 +--
 drivers/gpu/drm/v3d/v3d_sched.c                    |  28 ++-
 drivers/gpu/drm/xe/tests/xe_mocs.c                 |  21 +-
 drivers/gpu/drm/xe/xe_gt_pagefault.c               |  11 +-
 drivers/iio/accel/adis16201.c                      |   4 +-
 drivers/iio/accel/adxl355_core.c                   |   2 +-
 drivers/iio/accel/adxl367.c                        |  10 +-
 drivers/iio/adc/ad7606_spi.c                       |   2 +-
 drivers/iio/adc/dln2-adc.c                         |   2 +-
 drivers/iio/adc/rockchip_saradc.c                  |  17 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c         |   2 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |   6 +
 drivers/iio/temperature/maxim_thermocouple.c       |   2 +-
 drivers/input/joystick/xpad.c                      |  40 ++--
 drivers/input/keyboard/mtk-pmic-keys.c             |   4 +-
 drivers/input/mouse/synaptics.c                    |   5 +
 drivers/input/touchscreen/cyttsp5.c                |   7 +-
 drivers/md/dm-table.c                              |   3 +-
 drivers/net/can/m_can/m_can.c                      |   3 +-
 drivers/net/can/rockchip/rockchip_canfd-core.c     |   2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  42 +++-
 drivers/net/dsa/b53/b53_common.c                   | 213 +++++++++++++++------
 drivers/net/dsa/b53/b53_priv.h                     |   3 +
 drivers/net/dsa/bcm_sf2.c                          |   1 +
 drivers/net/ethernet/intel/ice/ice_adapter.c       |  39 ++--
 drivers/net/ethernet/intel/ice/ice_adapter.h       |   6 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  19 +-
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h        |   2 +
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c         | 180 +++++++++--------
 drivers/net/ethernet/meta/fbnic/fbnic_mac.c        |   6 -
 drivers/net/virtio_net.c                           |  61 ++++++
 drivers/nvme/host/core.c                           |   3 +-
 drivers/pci/hotplug/s390_pci_hpc.c                 |   1 -
 drivers/staging/axis-fifo/axis-fifo.c              |  14 +-
 drivers/staging/iio/adc/ad7816.c                   |   2 +-
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |   1 +
 drivers/usb/cdns3/cdnsp-gadget.c                   |  31 +++
 drivers/usb/cdns3/cdnsp-gadget.h                   |   6 +
 drivers/usb/cdns3/cdnsp-pci.c                      |  12 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |   3 +-
 drivers/usb/cdns3/core.h                           |   3 +
 drivers/usb/class/usbtmc.c                         |  59 +++---
 drivers/usb/dwc3/core.h                            |   4 +
 drivers/usb/dwc3/gadget.c                          |  60 +++---
 drivers/usb/gadget/composite.c                     |  12 +-
 drivers/usb/gadget/function/f_ecm.c                |   7 +
 drivers/usb/gadget/udc/tegra-xudc.c                |   4 +
 drivers/usb/host/uhci-platform.c                   |   2 +-
 drivers/usb/host/xhci-tegra.c                      |   3 +
 drivers/usb/misc/onboard_usb_dev.c                 |  10 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   2 +-
 drivers/usb/typec/ucsi/displayport.c               |   2 +
 drivers/vfio/pci/vfio_pci_core.c                   |  12 +-
 drivers/xen/swiotlb-xen.c                          |   1 +
 drivers/xen/xenbus/xenbus.h                        |   2 +
 drivers/xen/xenbus/xenbus_comms.c                  |   9 +-
 drivers/xen/xenbus/xenbus_dev_frontend.c           |   2 +-
 drivers/xen/xenbus/xenbus_xs.c                     |  18 +-
 fs/btrfs/volumes.c                                 |  91 +--------
 fs/erofs/fileio.c                                  |   4 +-
 fs/erofs/zdata.c                                   |  29 ++-
 fs/namespace.c                                     |   3 +-
 fs/ocfs2/journal.c                                 |  80 +++++---
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/ocfs2.h                                   |  17 +-
 fs/ocfs2/quota_local.c                             |   9 +-
 fs/ocfs2/suballoc.c                                |  38 +++-
 fs/ocfs2/suballoc.h                                |   1 +
 fs/ocfs2/super.c                                   |   3 +
 fs/smb/client/cached_dir.c                         |  10 +-
 fs/smb/server/oplock.c                             |   7 +-
 fs/smb/server/smb2pdu.c                            |   5 +
 fs/smb/server/vfs.c                                |   7 +
 fs/smb/server/vfs_cache.c                          |  33 +++-
 fs/userfaultfd.c                                   |  28 ++-
 include/linux/cpu.h                                |   2 +
 include/linux/execmem.h                            |   3 +
 include/linux/ieee80211.h                          |   2 +-
 include/linux/module.h                             |   5 +
 include/linux/types.h                              |   3 +-
 include/linux/vmalloc.h                            |   1 +
 include/net/netdev_queues.h                        |   6 +
 include/uapi/linux/types.h                         |   1 +
 init/Kconfig                                       |   3 +
 io_uring/io_uring.c                                |  58 +++---
 io_uring/sqpoll.c                                  |   2 +-
 kernel/params.c                                    |   4 +-
 kernel/sched/fair.c                                |   4 +-
 mm/huge_memory.c                                   |  11 +-
 mm/internal.h                                      |  27 ++-
 mm/memblock.c                                      |   9 +-
 mm/page_alloc.c                                    | 159 +++++++++------
 mm/vmalloc.c                                       |  31 ++-
 net/can/gw.c                                       | 151 +++++++++------
 net/core/filter.c                                  |   1 +
 net/core/netdev-genl.c                             |  69 +++++--
 net/ipv6/addrconf.c                                |  15 +-
 net/mac80211/mlme.c                                |  12 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  27 +--
 net/openvswitch/actions.c                          |   3 +-
 net/sched/sch_htb.c                                |  15 +-
 net/wireless/scan.c                                |   2 +-
 rust/bindings/lib.rs                               |   1 +
 rust/kernel/alloc/kvec.rs                          |   3 +
 rust/kernel/list.rs                                |   3 +
 rust/kernel/str.rs                                 |  46 ++---
 rust/macros/module.rs                              |  19 +-
 rust/macros/pinned_drop.rs                         |   3 +-
 rust/uapi/lib.rs                                   |   1 +
 tools/objtool/check.c                              |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mm/compaction_test.c       |  19 +-
 tools/testing/selftests/mm/pkey-powerpc.h          |  12 +-
 tools/testing/selftests/x86/bugs/Makefile          |   3 +
 tools/testing/selftests/x86/bugs/common.py         | 164 ++++++++++++++++
 .../selftests/x86/bugs/its_indirect_alignment.py   | 150 +++++++++++++++
 .../testing/selftests/x86/bugs/its_permutations.py | 109 +++++++++++
 .../selftests/x86/bugs/its_ret_alignment.py        | 139 ++++++++++++++
 tools/testing/selftests/x86/bugs/its_sysfs.py      |  65 +++++++
 188 files changed, 3233 insertions(+), 1099 deletions(-)


