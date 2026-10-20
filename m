Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792483060;
	b=KVCVV5/OLqsWUnpTQGoDIb8/ez6ZfDwnSkxKjmq3NY6mc3wWFHFrGBoaCLnmoWcmtdwb
	 wmyPrTAfJWjuGbHHG+aEHVoDEVtNYROfZYSZfBQy9e1nlx/a397haF1RQdIX8jphLxeg5
	 kVlt/8kYMCF50oFx3hwawzQy1A0NPUb6lwqxK135GRtArleTPE27wXwLF4xqZ8aX6hXE7
	 oWhZ+S8pfjevSQ8F32byAfLdmBg0E2EFj3HshIue8MwF7JhecoWh1FIrr/6CSXTPyX0RO
	 87fT1l8GOJHpxqFq+rKiltOApEmO3pqbeZ4+gjJ9BbXoWW5PpvZ8dzy8Wpron5IO79g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792483060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=OAC11srzZ0+QhCIMHxfPtC1D0CpGPT28w6knKPl/RPA=;
	b=z4LqE31GO79sniO3kZL2132xKD+uNub+m51bq0In2XjWoe2A9KoiRbYetFYEwTBnxBu4
	 TLe0yKxBWmbZpwBtJiezP5sxBJn5U8WYw/1HV2eg1URvAIGOAjhB2cdq96kXPxjBH4cke
	 aI6HvxsuoIGJ/sae7xxK7nyBK9u0Peslo+KSctINzCcwCzRo9IwBtmgUA9DCTb3lBnXUa
	 Dhp0QP5/iWmbsZz9+Pami7Essf8xXokGzpLzOI76KKTSAhODDO2GPnEFqJrNn8Afke25b
	 Rw+U64LHgrnayLIZ7+mMIpCJjuZ0KZPoWRT/3eYmW+UkXVjURMmB5r482yt4KyKnYVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taNsqSMR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EDA606A31F;
	Tue, 20 Oct 2026 07:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taNsqSMR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0994E1F000C6;
	Tue, 20 Oct 2026 07:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792483058;
	bh=OAC11srzZ0+QhCIMHxfPtC1D0CpGPT28w6knKPl/RPA=;
	h=From:To:Cc:Subject:Date;
	b=taNsqSMR/Fvr9nJ7NR1y4xGAeVeflDMH1cHxbXegFJ/N5Ux8JtP8c+21qJpOvDXre
	 +gcvycvgG8QnLocrW1Dd3VqbznZEqEq0X2JGNNkXiP316QMUoFk7og1jMBnPRJzVQW
	 yVb228aV3xQFFQop9Hapaj4DG4mL9jIBmfb0Xuo4=
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
Subject: [PATCH 6.12 000/858] 6.12.114-rc2 review
Date: Tue, 20 Oct 2026 09:57:31 +0200
Message-ID: <20261020075246.861837975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.114-rc2
X-KernelTest-Deadline: 2026-10-22T07:53+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.114 release.
There are 858 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 22 Oct 2026 07:51:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.114-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.114-rc2

Jinu Kim <kimjw04271234@gmail.com>
    KVM: x86: Use active memslots for the per-vCPU MMIO cache

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: fix heap out-of-bounds write in krb5_authenticate()

Philipp Stanner <phasta@kernel.org>
    drm/panfrost: Fix scheduler workqueue bug

David Hildenbrand <david@redhat.com>
    s390/uv: Don't return 0 from make_hva_secure() if the operation was not successful

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: atk9k: Revert "wifi: ath9k: reject short WMI command responses"

Mattia Meleleo <mattia.meleleo@coralogix.com>
    bpf, sockmap: Account for receive queue in FIONREAD without a verdict program

Ben Cressey <ben@cressey.dev>
    dm-integrity: fix buffer overflow with keyed discard

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix comment in tracing_buffers_splice_read()

Karl Mehltretter <kmehltretter@gmail.com>
    tracing: Fix ring_buffer_read_page_size() kernel-doc

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix i3c_master_get_free_addr return check

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix npcm845 FIFO_EMPTY quirk

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix missed IBI after false SLVSTART on NPCM845

Ruoyu Wang <ruoyuw560@gmail.com>
    gpiolib: initialize return value in gpiochip_set_multiple()

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    gpiolib: Allow to use setters with return value for output-only gpios

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    soundwire: intel_auxdevice: Fix system suspend/resume handling

Shibo Zhu <3499129952@qq.com>
    PM: sleep: Unblock runtime PM when device prepare fails

Muchun Song <muchun.song@linux.dev>
    mm/hugetlb_vmemmap: fix incorrect vmemmap restore in rollback

Steffen Klassert <steffen.klassert@secunet.com>
    Revert "esp: do not unref managed frag pages in esp_ssg_unref()"

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix NULL pointer dereference

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: do not expose expectation DEAD flag

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix the flood of invalid error reports

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix memory leak with CCA cards used as accelerator

Eric Dumazet <edumazet@google.com>
    net: do not acquire dev->tx_global_lock in netdev_watchdog_up()

David Howells <dhowells@redhat.com>
    netfs: Fix folio state after ENOMEM whilst under writeback iteration

Yichong Chen <chenyichong@uniontech.com>
    netfs: release readahead folios on iterator preparation failure

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: use correct endian in ocfs2_dinode_has_extents

Tejun Heo <tj@kernel.org>
    sched/psi: Create the psimon kthread outside of cgroup_mutex

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: stop checking viability of op->max_freq in supports_op callback

Max Kellermann <max.kellermann@ionos.com>
    ceph: always call ceph_shift_unused_folios_left()

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: introduce ceph_submit_write() method

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix crash after fscrypt_encrypt_pagecache_blocks() error

Hristo Venev <hristo@venev.name>
    ceph: do not skip the first folio of the next object in writeback

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Preserve RUN bit when aborting DMA ring

Jon Hunter <jonathanh@nvidia.com>
    soc/tegra: pmc: Add kerneldoc for wake-up variables

Thierry Reding <treding@nvidia.com>
    soc/tegra: pmc: Document tegra_pmc.syscore field

Ming Qian <ming.qian@oss.nxp.com>
    media: verisilicon: Fix kernel panic due to __initconst misuse

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Set rt->rt_nhn just before returning from mpls_nh_build_multi().

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Fix wild-memory-access in __register_pernet_operations() when CONFIG_NET_NS=n.

Pankaj Gupta <pankaj.gupta@amd.com>
    KVM: SEV: Drop FOLL_WRITE for encrypted region registration

Wludzik, Jozef <jozef.wludzik@intel.com>
    accel/ivpu: Fix race condition when mapping dmabuf

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: qcom : Fix NULL pointer dereference in ufs_qcom_setup_clocks

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/kvm: Mask extra bits from program interrupt code

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: pv: fix race when making a page secure

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: move gmap_shadow_pgt_lookup() into kvm

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: use __kvm_faultin_pfn()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: move pv gmap functions into kvm

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: wrapper for KVM_BUG

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/kvm: Initialize uninitialized flags variable

Cyril Bur <cyrilbur@tenstorrent.com>
    riscv: uaccess: Only restore the CSR_STATUS SUM bit

Ming Lei <ming.lei@redhat.com>
    ublk: fix dead loop when canceling io command

Steven Rostedt <rostedt@goodmis.org>
    xfs: remove unused trace event xfs_dqreclaim_dirty

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix recursive locking during device registration

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix uncore_box ref/unref ordering

Shukai Ni <shukai.ni@kuleuven.be>
    dm-integrity: replace forgeable discard filler with a keyed sector marker

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate external xattr entries when reading metadata

Kaitao Cheng <chengkaitao@kylinos.cn>
    bpf: Clear rb node linkage when freeing bpf_rb_root

Hou Tao <houtao1@huawei.com>
    bpf: Remove migrate_{disable|enable} in bpf_obj_free_fields()

Dan Williams <djbw@kernel.org>
    cxl/region: Resolve region deletion races

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI

Sebastian Ene <sebastianene@google.com>
    firmware: arm_ffa: Fix Endpoint Memory Access Descriptor offset calculation

Sudeep Holla <sudeep.holla@arm.com>
    firmware: arm_ffa: Add support for IMPDEF value in the memory access descriptor

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free if write is called after disconnect

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Triple fault if restore host CR3 fails on nested #VMEXIT

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: platform: Use acpi_bus_get_primary_device()

Al Viro <viro@zeniv.linux.org.uk>
    functionfs: fix the open/removal races

Benjamin Leggett <benjamin@edera.io>
    drm/virtio: use the DMA API for resource backing on Xen

Vivek Kasireddy <vivek.kasireddy@intel.com>
    drm/virtio: Add a helper to map and note the dma addrs and lengths

Dongwon Kim <dongwon.kim@intel.com>
    drm/virtio: Use drm_gem_plane_helper_prepare_fb()

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: validate GUD_ROTATION_0 is present in supported rotations

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    printk: Don't WARN on kthread_run failure.

Eduard Zingerman <eddyz87@gmail.com>
    bpf: check_cond_jmp_op(): properly infer if register is null

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix dma mapping leak in stmmac_tso_xmit()

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: invalidate fscache for fallocate range operations

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: use rcu_assign_pointer() for __rcu list updates

Eduard Zingerman <eddyz87@gmail.com>
    bpf: backtrack_insn(): Handle ld_{abs,ind} subprog exit edge

Eduard Zingerman <eddyz87@gmail.com>
    bpf: backtracking shouldn't clear outer frame R1-R5 for callbacks

FAN YE <fy15309206903@gmail.com>
    btrfs: zstd: fix lost wakeup when waiting for a workspace

Kuniyuki Iwashima <kuniyu@google.com>
    net: Remove conflicting altnames for dying netns in __dev_change_net_namespace().

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    net: plumb extack in __dev_change_net_namespace()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    net: rename netns_local to netns_immutable

Gao Xiang <xiang@kernel.org>
    erofs: disable LZ4 rolling decompression for now

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark signal tracepoint siginfo arguments as scalar

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark syscall helpers as sleepable

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Refactor and fix init_config access

Eduard Zingerman <eddyz87@gmail.com>
    bpf: zero extend the result of an arena 32-bit cmpxchg

Eduard Zingerman <eddyz87@gmail.com>
    bpf: don't rewrite bpf_fastcall patterns entered by a jump

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Check ancestor frames for rbtree callbacks

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Reject legacy packet loads from callbacks

Eduard Zingerman <eddyz87@gmail.com>
    bpf: Don't infer non-NULL from a pointer with an unbounded offset

Ning Ding <dingning04@gmail.com>
    bpf: Keep refcount_acquire nullable for borrowed RCU kptrs

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark NULL kptr stores precise

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Preserve inner map identity in callback frames

Vincent Donnefort <vdonnefort@google.com>
    tracing: Fix subbuf resize races with trace_pipe_raw readers

Eduard Zingerman <eddyz87@gmail.com>
    bpf: mark a NULL call argument precise

Karl Mehltretter <kmehltretter@gmail.com>
    iommu/amd: Do not reallocate GA log buffers on resume

Alexander Graf <graf@amazon.com>
    virtio_ring: fix stale descriptor flags after a failed packed add

Jia Jia <physicalmtea@gmail.com>
    vduse: validate virtqueue alignment

Jia Jia <physicalmtea@gmail.com>
    vhost: invalidate vring access on IOTLB transitions

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    Bluetooth: hci_sysfs: Fix NULL pointer dereference in device_del()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Move representor vnic reporter to eswitch devlink port

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Prevent drain_pebs() reentry

Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
    drm/amdgpu: skip the VMID 0 flush for VRAM

Paulo Alcantara <pc@manguebit.org>
    smb: client: honor forceuid/forcegid when mapping SIDs to uid/gid

Paulo Alcantara <pc@manguebit.org>
    smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Validate HID report lengths

Arie Miller <renari@arimil.com>
    hwmon: (asus_rog_ryujin) Add per-device configuration

Guenter Roeck <linux@roeck-us.net>
    hwmon: (asus_rog_ryujin) Rely on subsystem locking

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix npcm845 invalid slvstart event

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Fix npcm845 FIFO empty issue

Brandon Brnich <b-brnich@ti.com>
    media: chips-media: wave5: Release m2m_ctx after Instance Removed from List

Pengpeng Hou <pengpeng@iscas.ac.cn>
    genirq/proc: Size interrupt directory names for 10-digit interrupt numbers

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    genirq: Consistently use '%u' format specifier for unsigned int variables

Thomas Gleixner <tglx@linutronix.de>
    genirq/proc: Switch to lock guards

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: mediatek: paris: use new GPIO line value setter callbacks

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: mediatek: paris: don't double-check the GPIO number

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: introduce gpio_chip setters that return values

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: rework the wrapper around gpio_chip::set_multiple()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: wrap gpio_chip::set()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: make value setters have return values

Candice Li <candice.li@amd.com>
    drm/amdgpu: Bound GPIO I2C table entry count from VBIOS

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: rework i2c init and fini

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/atombios: drop empty function

Dr. David Alan Gilbert <linux@treblig.org>
    drm/amdgpu: Remove unused amdgpu_i2c functions

Stepan Ionichev <sozdayvek@gmail.com>
    tty: serial: 8250: protect against NULL uart->port.dev in register

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: 8250: invert serial8250_register_8250_port() CIR condition

Herve Codina <herve.codina@bootlin.com>
    driver core: Avoid warning when removing a device while its supplier is unbinding

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core: Add device_link_test() for testing device link flags

Colin Ian King <colin.i.king@gmail.com>
    PM: sleep: Fix bit masking operation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: Use DPM_FLAG_SMART_SUSPEND conditionally

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Introduce pm_runtime_blocked()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: Block enabling of runtime PM during system suspend

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: Rearrange documentation related to __pm_runtime_disable()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Restrict power.set_active propagation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Synchronize runtime PM status of parents and children

Sicong Huang <congei42@163.com>
    virt: acrn: Fix irqfd use-after-free during eventfd shutdown

Dr. David Alan Gilbert <linux@treblig.org>
    virt: acrn: Remove unused list 'acrn_irqfd_clients'

Tao Cui <cuitao@kylinos.cn>
    RDMA/counter: Fix num_counters leak on bind_qp failure in alloc_and_bind()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix P2P-Device binding handling

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: simplify nested if checks

Yunxiang Li <Yunxiang.Li@amd.com>
    drm/amdgpu/ras: add ras_suspend callback and use it for cp_ecc_error_irq

Victor Skvortsov <victor.skvortsov@amd.com>
    drm/amdgpu: Update SRIOV Exchange Headers for RAS Telemetry Support

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: fix SMI event cross-process information leak

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix maximum allowed access checks

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    ksmbd: remove redundant DACL check in smb_check_perm_dacl

Val Packett <val@packett.cool>
    remoteproc: qcom_wcnss: Fix handling the lack of PD regulators in v3

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: propagate IPI init errors to prevent use-after-free

Gou Hao <gouhao@uniontech.com>
    powerpc/xive: add error return value to xive_smp_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: bus: Introduce acpi_bus_get_primary_device()

Muchun Song <muchun.song@linux.dev>
    mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier

Kiryl Shutsemau <kas@kernel.org>
    mm/hugetlb: refactor code around vmemmap_walk

Chris Mason <clm@meta.com>
    nfsd: convert nfsd_net boolean flags to unsigned long flags word

Ye Liu <ye.liu@linux.dev>
    mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in plane reset function

Evgenii Burenchev <evg28bur@yandex.ru>
    drm/amd/display: Fix dangling pointer in CRTC reset function

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Reject MEM_ALLOC BTF accesses past object bounds

Malaya Kumar Rout <malayarout91@gmail.com>
    time/namespace: Validate nanosecond field in proc_timens_set_offset()

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject writes through untrusted BTF pointers

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi-base: Fix handling of ultra performance key

Nicholas Dudar <main.kalliope@gmail.com>
    bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max

Qing Ming <a0yami@mailbox.org>
    usb: gadget: uac: validate rate list length before storing

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: fix resource leaks on probe failure

Maher Azzouzi <maherazz04@gmail.com>
    esp: do not unref managed frag pages in esp_ssg_unref()

Leon Romanovsky <leon@kernel.org>
    RDMA/rvt: Return NULL after port allocation failure

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix SCMI device destroy lifetimes

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/msm: Only fini scheduler after successful init

Philipp Stanner <phasta@kernel.org>
    drm/sched: Use struct for drm_sched_init() params

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Zero queue and stack outputs on lock failure

Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
    ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()

Leon Hwang <leon.hwang@linux.dev>
    bpf: Fix WARNING in bpf_tracing_link_release

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: core: Validate string descriptors

Bean Huo <beanhuo@micron.com>
    scsi: ufs: core: Convert string descriptor format macros to enum

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Don't fall back to a freed smmu after devm_krealloc()

Nicolin Chen <nicolinc@nvidia.com>
    iommu/tegra241-cmdqv: Fix VINTF0 leak on the init-failure path

Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
    clk: mediatek: pllfh: Fix IO remapping leak in register_pllfhs error path

Gary Guo <gary@garyguo.net>
    PCI: Fix UAF when probe runs concurrent to dyn ID removal

Gary Guo <gary@garyguo.net>
    PCI: Fix dyn_id add TOCTOU

Gary Guo <gary@garyguo.net>
    PCI: Make pci_match_one_device() match on ID instead of device

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Fix dereg_skb leak and double free in write_tpt_entry()

Adrián Larumbe <adrian.larumbe@collabora.com>
    drm/panthor: Add vm_bind region with kbo range overlap check

Jani Nikula <jani.nikula@intel.com>
    overflow: add range_overflows() and range_end_overflows()

Jani Nikula <jani.nikula@intel.com>
    drm/i915: document range_overflows() and range_end_overflows() macros

Jani Nikula <jani.nikula@intel.com>
    drm/i915: rename range_overflows_end() to range_end_overflows()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: cancel reset and rc work on device unregister

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm: don't tear down KMS twice when KMS init fails

Yonghong Song <yonghong.song@linux.dev>
    bpf: Reject >8 byte return values on return-reading trampoline paths

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed

Will Deacon <will@kernel.org>
    arm64: ptrace: Keep 'orig_x0' in-sync with x0 on syscall entry

Zhao Li <enderaoelyther@gmail.com>
    wifi: nl80211: clean up color-change beacon data on errors

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: check link is beaconing for color change

Jason Huang <jason.huang2@infineon.com>
    wifi: brcmfmac: fix P2P action frame handling without device vif

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: stop PMSR before P2P and NAN teardown

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: do fallible allocations before the console can be registered

Karl Mehltretter <kmehltretter@gmail.com>
    serial: core: clear freed pointers on uart_register_driver() failure

Karl Mehltretter <kmehltretter@gmail.com>
    tty: skip cdev_del() when no cdev is registered

Haoxiang Li <haoxiang_li2024@163.com>
    HID: logitech-hidpp: Fix FF device cleanup on init failure

Vicki Pfau <vi@endrift.com>
    HID: steam: Reject short reads

Zheng Qixing <zhengqixing@huawei.com>
    blk-cgroup: fix race between policy activation and blkg destruction

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check import_ubuf() return value

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: validate inline xattrs during inode block validation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: hwmon: Remove hwmon class device along with its parent

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: o2hb: quiesce negotiate handlers and timeout work

Yufan Chen <ericterminal@gmail.com>
    ocfs2/heartbeat: fix slot mapping rollback leaks on error paths

Jiri Olsa <jolsa@kernel.org>
    bpf: Clear buf on error in __bpf_get_task_stack

Jiri Olsa <jolsa@kernel.org>
    bpf: Remove trace_in argument from __bpf_get_stack

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor callchain_finalize function from __bpf_get_stack

Jiri Olsa <jolsa@kernel.org>
    bpf: Factor callchain_store function from __bpf_get_stack

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Resize MST HDCP per-connector arrays to 32

Ray Wu <ray.wu@amd.com>
    drm/amd/display: disable replay when crc source is enabled

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails

Bart Van Assche <bvanassche@acm.org>
    scsi: sd: Move the sd_config_discard() function definition

Filipe Manana <fdmanana@suse.com>
    btrfs: defrag: fix deadlock between defrag and delalloc space reservation

Qu Wenruo <wqu@suse.com>
    btrfs: always wait for ordered extents to avoid OE races

Sun YangKai <sunyangkai@fnnas.com>
    btrfs: check if root is readonly when setting posix acl

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: don't clobber the extent buffer when zeroing it out

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: use proto_lock for l2cap_data to fix l2cap_disconn_ind

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix race of kfree vs kref_get_unless_zero

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix mmap_lock leak in irq_work path

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Flush context cache with correct SID when tearing down aliases

Chuck Lever <chuck.lever@oracle.com>
    NFS: Return a delegation the client fails to record

Kuniyuki Iwashima <kuniyu@google.com>
    amt: Don't support cross-netns setup.

John Johansen <john.johansen@canonical.com>
    apparmor: fix unconfined user namespace restriction forced stack

Ning Ding <dingning04@gmail.com>
    bpf: Compare iterator types during state pruning

Daniel Borkmann <daniel@iogearbox.net>
    bpf, s390: Clear fetch destination on faulting arena atomic

Marek Szyprowski <m.szyprowski@samsung.com>
    clocksource/drivers/samsung_pwm: Switch to raw_spinlock_t type

Maurizio Lombardi <mlombard@redhat.com>
    nvmet: fix max_qid race between configfs and controller allocation

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate orphan slot during inode read

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: validate DIO orphan slot during inode read

Usama Arif <usama.arif@linux.dev>
    blk-iolatency: clear delay state when freeing policy data

Usama Arif <usama.arif@linux.dev>
    blk-iocost: clear delay state when freeing policy data

Yu Kuai <yukuai@fygo.io>
    blk-cgroup: delay freeing policy data after rcu grace period

John Johansen <john.johansen@canonical.com>
    apparmor: fix deadlock in complain-mode change_hat

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Check pointer type for all atomic RMW paths

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: fix slab-out-of-bounds read in ksmbd_alloc_user()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: serialize oplock close with pending break ownership

Ilan Dudnik <ilan.dudnik@safebreach.com>
    ksmbd: defer publishing granted locks to prevent UAF/double-free race

Gao Xiang <xiang@kernel.org>
    erofs: fix interlaced ztailpacking pclusters

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: safely discard unregistered deferred locks

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: detach blocked lock requests before freeing

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: scope session state changes to bound connections

Jeuk Kim <jeuk20.kim@gmail.com>
    NFSv4/flexfiles: fix NULL dereference for NFSv4.0 data servers

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf, xdp: move offload check into dev_xdp_install()

Petr Oros <poros@redhat.com>
    dpll: fix NULL deref in dpll_device_ops() during teardown race

Anton Protopopov <a.s.protopopov@gmail.com>
    virtio_net: Fix resize of the RX ring

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mtpav: shut down output timer before card teardown

Eric Dumazet <edumazet@google.com>
    ip6mr: do not clone dst in ip6mr_cache_report()

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: arp/nd proxy: fix reading neigh ha

Nikolay Aleksandrov <razor@blackwall.org>
    vxlan: fix reading neigh ha

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    NFSv4.1: zero referring call lists before decoding

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: account classifier filter allocations to memcg

Michael Kelley <mhkelley58@gmail.com>
    Drivers: hv: vmbus: Skip VMBus module cleanup for non-nested root partition

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: access chan->conn safely in get/setsockopt

Breno Leitao <leitao@debian.org>
    Bluetooth: L2CAP: convert to getsockopt_iter

Breno Leitao <leitao@debian.org>
    net: add getsockopt_iter callback to proto_ops

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: do not leak an hci_conn when a second LE connect is rejected

Stanislav Fomichev <sdf.kernel@gmail.com>
    xsk: honor XDP_TX_METADATA in zero-copy path

Anshumali Gaur <agaur@marvell.com>
    octeontx2-vf: fix workqueue and netdev race in probe/remove

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_ife: Only operate on Ethernet frames

Eric Dumazet <edumazet@google.com>
    net/sched: add qstats_cpu_drop_inc() helper

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: add three drop_reason

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: skip double clone set expressions on element insert

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prepare for multiple elements in nft_trans_elem structure

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: add nft_trans_commit_list_add_elem helper

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_trans_elem_alloc helper

Usama Arif <usama.arif@linux.dev>
    mm/huge_memory: transfer the pmd dirty bit to the folio on zap

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory corruption by not reinjecting CK machine checks

Qihang <q.h.hack.winter@gmail.com>
    KVM: arm64: vgic-v3: take an LPI reference in vgic_v3_save_pending_tables

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: BPF: Refactor jump offset calculation in tail call

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid potential deadloop in f2fs_fsync_node_pages()

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: force complete the KIQ ring fences on reset

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: force complete the MES ring fences on reset

Priya Hosur <Priya.Hosur@amd.com>
    drm/amdkfd: Add TLB flush after MES queue eviction/suspension

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix error path at svm_migrate_copy_to_ram

James Zhu <James.Zhu@amd.com>
    drm/amdkfd: return migration pages from copy function - again

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram

James Zhu <James.Zhu@amd.com>
    Revert "drm/amdkfd: return migration pages from copy function"

James Zhu <James.Zhu@amd.com>
    drm/amdkfd: return migration pages from copy function

Emily Deng <Emily.Deng@amd.com>
    drm/amdkfd: Fix partial migrate issue

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    ksmbd: fix tree connection use-after-free in smb2_tree_connect()

Kairui Song <kasong@tencent.com>
    mm/mglru: fix and remove redundant unevictable folio handling

Kairui Song <kasong@tencent.com>
    mm/mglru: use the common routine for dirty/writeback reactivation

Wei Xu <weixugc@google.com>
    mm/mglru: reset page lru tier bits when activating

Jeff Layton <jlayton@kernel.org>
    lockd, nfsd: RCU-protect nlmsvc_ops dispatch

Jeff Layton <jlayton@kernel.org>
    nfsd: restore rq_status_counter to even on all nfsd_dispatch() exit paths

Jeff Layton <jlayton@kernel.org>
    nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix UAF in check_new_map() on session freed during unlock

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: cap delegated inode count in ceph_parse_deleg_inos()

Frank Sorenson <sorenson@redhat.com>
    cifs: call pagecache_isize_extended() in cifs_setsize() when extending

Bryam Vargas <hexlabsecurity@proton.me>
    smb: client: reject a tree connect response whose byte count is too small

Jan Kara <jack@suse.cz>
    ext2: Fix lost inode updates for IS_SYNC inodes

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject short RFC 4121 MIC tokens in gss_krb5_verify_mic_v2

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Clear sc_cm_id when ADDR_CHANGE replacement fails

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: wake sq waiters when the transport closes

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Add Write chunk WRs to the RPC's Send WR chain

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject Read lists that exceed the page budget

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: dvm: pair transport op-mode enter/leave

Jens Axboe <axboe@kernel.dk>
    io_uring: defer eventfd signaling when queued from a wakeup handler

Wei Fang <wei.fang@nxp.com>
    net: tap: fix wrong transport_header when sending VLAN-tagged frame

Akihiko Odaki <akihiko.odaki@daynix.com>
    tap: Keep hdr_len in tap_get_user()

Leon Romanovsky <leon@kernel.org>
    ntb: Store original DMA address for future release

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_transport: Use ntb_get_dma_dev() for DMA buffers

Koichiro Den <den@valinux.co.jp>
    NTB: core: Add .get_dma_dev() callback to ntb_dev_ops

Eric Dumazet <edumazet@google.com>
    tipc: avoid busy looping in tipc_exit_net()

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Wrap user-invoked calls to fb_set_var() in helper

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: ISO: zero the sockaddr before returning it in getname

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: Add bounds check for CRAT subtype length

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length

Luxiao Xu <rakukuip@gmail.com>
    bpf: Check sk_state before sk_protocol in bpf_tcp_*_syncookie

Qu Wenruo <wqu@suse.com>
    btrfs: initialize inode mapping flags for cached inodes

Alex Deucher <alexander.deucher@amd.com>
    drm/amd/display: check if dml21_add_phantom_plane() is successful

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix double free of wq, engine, and group structs

Michael Bommarito <michael.bommarito@gmail.com>
    idpf: bound interrupt-vector register fill to the allocated array

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_acl/le_sync() callbacks

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

Terry Bowman <terry.bowman@amd.com>
    cxl: Fix CXL_HEADERLOG_SIZE to match RAS Capability size

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    soc: xilinx: Fix race condition in event registration

Yihang Li <liyihang9@huawei.com>
    scsi: hisi_sas: Add slave_destroy interface for v3 hw

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix call trace due to missing release()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Skip absent memory controllers

Orange Kao <orange@aiven.io>
    EDAC/igen6: Add polling support

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Initialize edac_op_state according to the configuration data

David Carlier <devnexen@gmail.com>
    netfilter: flowtable: avoid num_encaps underflow on bridge VLAN untag

Weiming Shi <bestswngs@gmail.com>
    btrfs: lzo: reject compressed segment that overflows the compressed input

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: oss: Serialize readq reset state with q->lock

James Clark <james.clark@linaro.org>
    coresight: ete: Always save state on power down

Ivan Abramov <i.abramov@mt-integration.ru>
    ieee802154: Avoid calling WARN_ON() on -ENOMEM in cfg802154_switch_netns()

Rosen Penev <rosenp@gmail.com>
    net: emac: Fix NULL pointer dereference in emac_probe

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: use platform_get_irq

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: use devm_platform_ioremap_resource

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: pcm: Add snd_sof_pcm specific wrappers for dev_dbg() and dev_err()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: pcm: Move period/buffer configuration print after platform open

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Relocate and rework functionality for PCM stream freeing

Hongjie Fang <hongjiefang@asrmicro.com>
    scsi: core: pair EH runtime PM get and put

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    sctp: validate cookie AUTH state before use

Julian Anastasov <ja@ssi.bg>
    ipvs: revalidate ihl to prevent out-of-bounds access

Aleksandr Nogikh <nogikh@google.com>
    firewire: ohci: fix NULL pointer dereference in ar_context_release

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
    gpio: pca953x: fix pca953x_irq_bus_sync_unlock regmap lock

Karthikeyan KS <karthiproffesional@gmail.com>
    soc: aspeed: lpc-snoop: Fix usercopy overflow in snoop_file_read

Yun Zhou <yun.zhou@windriver.com>
    xfs: handle NULL b_addr in xfs_buf_free

David Lee <david.lee@trailofbits.com>
    btrfs: lzo: reject inline extents without valid headers

Chengfeng Ye <nicoyip.dev@gmail.com>
    bpf: Fix netns reference imbalance in conntrack kfuncs

Linfeng Sun  <linfeng.sun.dev@gamil.com>
    vhost_iotlb: bound map allocation in add_range

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix type confusion in notification logic

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Disable EOP for TPA on all chips to prevent data corruption

Eric Dumazet <edumazet@google.com>
    netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()

Alexandra Winter <wintera@linux.ibm.com>
    s390/ism: Fix UAF of sba and ieq during ism_dev_exit()

Hongyan Xu <getshell@seu.edu.cn>
    watchdog: at91sam9_wdt: prevent timer rearm during teardown

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tls: rx: restore msg_iter before TLS 1.3 optimistic retry

Sabrina Dubroca <sd@queasysnail.net>
    selftests: tls: add rekey tests

Steven Rostedt <rostedt@goodmis.org>
    eventfs: Use children field for rcu head and add memory barriers

Zhiling Zou <zhilinz@nebusec.ai>
    mm/page_table_check: skip special zero mappings

Dongjiang Zhu <zhudongjiang@fnnas.com>
    btrfs: skip global block reserve accounting for rescue mounts

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: reclaim invalid Tx descriptors in ZC batch path

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: provide sufficient space in pool->tx_descs

Jason Xing <kernelxing@tencent.com>
    xsk: drain continuation descs after overflow in xsk_build_skb()

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    net/sched: cls_u32: validate offshift to prevent shift-out-of-bounds

David Howells <dhowells@redhat.com>
    netfs: Fix folio_queue ENOMEM in writeback by adding a mempool

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: lock sk in iso_connect_ind

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: hold sk properly in iso_conn_ready

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hold conn in hci_connect_pa_sync() callback

Hariprasad Kelam <hkelam@marvell.com>
    octeontx2-af: Block VFs from clobbering special CGX PKIND state

Peiyang He <peiyang_he@smail.nju.edu.cn>
    iommu/iommufd: Fix IOPF group ownership UAF

Hidayath Khan <hidayath@linux.ibm.com>
    dibs: fix use-after-free of dmb_node in loopback attach/detach/unregister

David Howells <dhowells@redhat.com>
    afs: Fix UAF when sending a message

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Close speculative mem read possibility

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Rework domain processing within zcrypt device driver

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Move inline function rng_type6cprb_msgx from header to code

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap/zcrypt: New xflag parameter

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Introduce ap message buffer pool

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap/zcrypt: Rework AP message buffer allocation

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Move response_type struct into ap_msg struct

George Zhang <george.zhang@amd.com>
    drm/amd/display: Fix divide-by-zero in calculate_mcache_setting on zero viewport

Wei Zhang <wei.zhang@oss.qualcomm.com>
    wifi: ath11k: cancel SSR work items during PCI shutdown

Di Shen <di.shen@unisoc.com>
    OPP: Fix race between OPP addition and lookup

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: oss: Fix UAF at handling events with embedded SysEx data

Geliang Tang <geliang@kernel.org>
    nvmet-tcp: check return value of nvmet_tcp_set_queue_sock

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix error-path detection with md_cloned_bio()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix bio accounting for split md cloned bios

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1,raid10: fix deadlock in read error recovery path

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md: replace wait loop with wait_event() in md_handle_request()

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath12k: fix memory leak in ath12k_wifi7_dp_rx_h_verify_tkip_mic()

Zhang Cen <rollkingzzc@gmail.com>
    ocfs2: validate fast symlink target during inode read

David Windsor <dwindsor@gmail.com>
    bpf: Reject sleepable BPF_LSM_CGROUP programs at load time

Larysa Zaremba <larysa.zaremba@intel.com>
    ixgbe: do not configure xps for XDP queues

Dan Williams <djbw@kernel.org>
    cxl/region: Block region delete during region creation

Joe Damato <joe@dama.to>
    bnxt: fix head underflow on XDP head-grow

Eric Dumazet <edumazet@google.com>
    net: watchdog: fix refcount tracking races

Cen Zhang <zzzccc427@gmail.com>
    ALSA: seq: avoid stale FIFO cells during resize

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Clean up fifo locking with guard

Kuniyuki Iwashima <kuniyu@google.com>
    sockmap: Fix use-after-free in udp_bpf_recvmsg()

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Initialize dpi variable to zero

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Free SRQ toggle page after firmware teardown

Leon Romanovsky <leon@kernel.org>
    RDMA/bnxt_re: Remove unusable nq variable

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Fix budget handling of notification queue

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Free CQ toggle page after firmware teardown

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Add a max slot check for SQ

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid repeated requests to allocate WC pages

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Replace waitqueue and flag with completion

Eric Dumazet <edumazet@google.com>
    net: serialize netif_running() check in enqueue_to_backlog()

Baoli.Zhang <baoli.zhang@linux.intel.com>
    soundwire: fix bug in sdw_add_element_group_count found by syzkaller

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid1: fix writes_pending and barrier reference leaks on write failures

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    md/raid10: fix writes_pending leak on write request failures

Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
    bpf: Guard conntrack opts error writes

Eric Dumazet <edumazet@google.com>
    tipc: fix UAF in cleanup_bearer() due to premature dst_cache_destroy()

Xin Long <lucien.xin@gmail.com>
    sctp: add INIT verification after cookie unpacking

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    hwmon: (pmbus/core) honor vrm_version in pmbus_data2reg_vid()

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panthor: Always use the IRQ-safe variant when acquiring the fence lock

Xin Long <lucien.xin@gmail.com>
    sctp: fix addr_wq_timer race in sctp_free_addr_wq()

Michael Bommarito <michael.bommarito@gmail.com>
    xen/pvcalls: bound backend response req_id before indexing rsp[]

David Howells <dhowells@redhat.com>
    afs: Fix reinitialisation of the inode, in particular ->lock_work

Morduan Zang <zhangdandan@uniontech.com>
    iomap: guard io_size EOF trim against concurrent truncate underflow

David Howells <dhowells@redhat.com>
    netfs: Fix netfs_create_write_req() to handle async cache object creation

David Howells <dhowells@redhat.com>
    netfs: Drop the was_async arg from netfs_read_subreq_terminated()

David Howells <dhowells@redhat.com>
    netfs: Abstract out a rolling folio buffer implementation

David Howells <dhowells@redhat.com>
    netfs: Add a tracepoint to log the lifespan of folio_queue structs

David Howells <dhowells@redhat.com>
    netfs: Use a folio_queue allocation and free functions

David Howells <dhowells@redhat.com>
    netfs: Clean up some whitespace in trace header

Feng Liu <feliu@nvidia.com>
    net/mlx5e: Fix publication race for priv->channel_stats[]

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: 6lowpan: avoid untracked enable work

Yuho Choi <dbgh9129@gmail.com>
    net/liquidio: drop cached VF pci_dev LUT

Eric Dumazet <edumazet@google.com>
    ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Handle race between interrupt affinity change and LPI disabling

Ian Bridges <icb@fastmail.org>
    ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: validate i_refcount_loc when refcount flag is set

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add extra consistency checks for chain allocator dinodes

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add suballoc slot check in ocfs2_validate_inode_block()

Julian Sun <sunjunchao2870@gmail.com>
    ocfs2: correct l_next_free_rec in online check

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: fix buffer overflow in FEC calculation

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: rename probe error labels

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix use-after-free on disconnect

Binbin Zhou <zhoubinbin@loongson.cn>
    mmc: vub300: Use devm_mmc_alloc_host() helper

Bryam Vargas <hexlabsecurity@proton.me>
    ata: libata-core: Add NOLPM quirk for PNY CS900 1TB SSD

Niklas Cassel <cassel@kernel.org>
    ata: libata-core: Disable LPM on Silicon Motion MD619{H,G}XCLDE3TC

Zhao Li <enderaoelyther@gmail.com>
    wifi: ieee80211: validate MLE common info length

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate extension-frame layout before RX

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix buffer over-read in cca_cipher2protkey

Amir Goldstein <amir73il@gmail.com>
    ovl: check access to copy_file_range source with src mounter creds

Yongqiang Sun <Yongqiang.Sun@amd.com>
    drm/amdkfd: clamp v9 CRIU control stack checkpoint copy to BO size

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: Handle TC_ACT_REDIRECT from qdisc filter chains

Honglei Huang <honghuan@amd.com>
    drm/amd/display: use kvzalloc to allocate struct dc

George Guo <guodongtai@kylinos.cn>
    LoongArch: Fix address space mismatch in kexec command line lookup

Petr Wozniak <petr.wozniak@gmail.com>
    xfrm: fix stale skb->prev after async crypto steals a GSO segment

Tejun Heo <tj@kernel.org>
    sched_ext: Don't warn on core-sched forced idle in put_prev_task_scx()

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Prevent user-triggered null deref on QP create

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: cfg80211: Fix an error handling path in cfg80211_wext_siwscan()

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: mac80211: defer link RX stats percpu free to RCU

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: cfg80211: add link_station_info structure to support MLO statistics

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: mac80211: refactor populating mesh related fields in sinfo

Cen Zhang <zzzccc427@gmail.com>
    wifi: cfg80211: use wiphy work for socket owner autodisconnect

Mostafa Saleh <smostafa@google.com>
    firmware: arm_ffa: Fix out-of-bound writes in ffa_setup_and_transmit()

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Fix UAF in sock clone early bailouts

Fushuai Wang <wangfushuai@baidu.com>
    bpf: Use rcu_read_lock_dont_migrate in bpf_sk_storage.c

Menglong Dong <menglong8.dong@gmail.com>
    rcu: add rcu_read_lock_dont_migrate()

Hou Tao <houtao1@huawei.com>
    bpf: Disable migration when cloning sock storage

Hou Tao <houtao1@huawei.com>
    bpf: Disable migration when destroying sock storage

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: extend conn_hash lookup critical sections

Arvind Yadav <arvind.yadav@intel.com>
    drm/xe/guc: Keep scheduler timeline name alive

Ruoyu Wang <ruoyuw560@gmail.com>
    bnxt_en: Handle partially initialized auxiliary devices

Pavan Chebbi <pavan.chebbi@broadcom.com>
    fwctl/bnxt_en: Refactor aux bus functions to be more generic

Weiming Shi <bestswngs@gmail.com>
    tipc: serialize udp bearer replicast list updates

Frank Sorenson <sorenson@redhat.com>
    cifs: fix cifsFileInfo leak on kmalloc failure in deferred close drain paths

Frank Sorenson <sorenson@redhat.com>
    cifs: prevent readdir from changing file size due to stale directory metadata

Nicholas Dudar <main.kalliope@gmail.com>
    LoongArch: BPF: Zero-extend signed ALU32 div/mod results

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix max_vport related crash on allocation error during init

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on CRIU restore queue type and mqd size

Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
    drm/i915/gt: Fix NULL deref on sched_engine alloc failure

Jani Nikula <jani.nikula@intel.com>
    drm/i915/mst: limit DP MST ESI service loop

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Release VFCT ACPI table reference

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Add wrapper for freeing vbios memory

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Use dbg level for VBIOS check messages

Linmao Li <lilinmao@kylinos.cn>
    drm/vc4: Shut down BO cache timer before teardown

Valery Borovsky <vebohr@gmail.com>
    media: stm32-dcmipp: Return queued buffers on start_streaming() failure

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: dcmipp: replace s_stream with enable/disable_streams

Alain Volmat <alain.volmat@foss.st.com>
    media: stm32: dcmipp: use v4l2_subdev_is_streaming

Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
    drm/amdgpu: Fix kernel panic during driver load failure

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Put vmcs12 pages if nested VM-Enter fails due to invalid guest state

Carlos López <clopez@suse.de>
    KVM: x86: Unconditionally recompute CR8 intercept on PPR update

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move update_cr8_intercept() to lapic.c

Sean Christopherson <seanjc@google.com>
    KVM: x86: Rename APIC base setters to better capture their relationship

Sean Christopherson <seanjc@google.com>
    KVM: x86: Move kvm_set_apic_base() implementation to lapic.c (from x86.c)

Sean Christopherson <seanjc@google.com>
    KVM: x86: Drop superfluous kvm_lapic_set_base() call when setting APIC state

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent path traversal bypass by restricting caseless retry

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: validate NTLMv2 response before updating session key

Ralph Boehme <slow@samba.org>
    smb/client: fix chown/chgrp with SMB3 POSIX Extensions

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Treat memslot binding offset+size as unsigned values

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Add lock protection to lm90_alert

David Howells <dhowells@redhat.com>
    netfs: Fix zeropoint update where i_size > remote_i_size

Felix Gu <ustc.gu@gmail.com>
    drm/msm/adreno: Fix a reference leak in a6xx_gpu_init()

Jia Zhu <zhujia.zj@bytedance.com>
    erofs: fix metabuf leak in inode xattr initialization

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb

Sarika Sharma <sarika.sharma@oss.qualcomm.com>
    wifi: mac80211: fix missing RX bitrate update for mesh forwarding path

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: allocate hook ops while under mutex

Florian Westphal <fw@strlen.de>
    netfilter: x_tables: allow initial table replace without emitting audit log message

Florian Westphal <fw@strlen.de>
    netfilter: ebtables: move to two-stage removal scheme

Florian Westphal <fw@strlen.de>
    netfilter: bridge: eb_tables: close module init race

David Howells <dhowells@redhat.com>
    netfs: Fix missing locking around retry adding new subreqs

David Howells <dhowells@redhat.com>
    netfs: Fix leak of request in netfs_write_begin() error handling

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Stop work before releasing hwmon device

Qing Ming <a0yami@mailbox.org>
    cgroup/rstat: validate cpu before css_rstat_cpu() access

Eric Dumazet <edumazet@google.com>
    tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Remove sk->sk_prot->orphan_count.

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_tables: fix dst corruption in same register operation

Jakub Kicinski <kuba@kernel.org>
    ethtool: rss: fix indir_table and hkey leak on get_rxfh failure

Jakub Kicinski <kuba@kernel.org>
    ethtool: module: call ethnl_ops_complete() on module flash errors

Chuck Lever <chuck.lever@oracle.com>
    net/handshake: hand off the pinned file reference to accept_doit

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix amdgpu_hmm_range_get_pages

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Add missing bits in airoha_qdma_cleanup_tx_queue()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Do not read uninitialized fragment address in airoha_dev_xmit()

Yinjie Yao <yinjie.yao@amd.com>
    drm/amdgpu/vcn: set no_user_fence for VCN v4.0 enc ring

Jiajia Liu <liujiajia@kylinos.cn>
    wifi: mt76: add wcid publish check in mt76_sta_add

Konstantin Khorenko <khorenko@virtuozzo.com>
    gcov: use atomic counter updates to fix concurrent access crashes

Mikhail Lobanov <m.lobanov@rosa.ru>
    f2fs: read COW data with the original inode during atomic write

Hongling Zeng <zenghongling@kylinos.cn>
    fbdev: omap2: fix use-after-free in omapfb_mmap

Hongling Zeng <zenghongling@kylinos.cn>
    fbdev: omap2: fix inconsistent lock returns in omapfb_mmap

Anna Maniscalco <anna.maniscalco2000@gmail.com>
    drm/msm: always recover the gpu

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by incorrect nat_entry flag usage

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Fix out-of-bounds read in dp_get_eq_aux_rd_interval()

Jens Axboe <axboe@kernel.dk>
    io_uring/napi: cap busy_poll_to 10 msec

Olivier Langlois <olivier@trillion01.com>
    io_uring/napi: clean up __io_napi_do_busy_loop

Olivier Langlois <olivier@trillion01.com>
    io_uring/napi: Use lock guards

Olivier Langlois <olivier@trillion01.com>
    io_uring/napi: improve __io_napi_add

Olivier Langlois <olivier@trillion01.com>
    io_uring/napi: protect concurrent io_napi_entry timeout accesses

Erni Sri Satya Vennela <ernis@linux.microsoft.com>
    net: mana: Guard mana_remove against double invocation

Morduan Zang <zhangdandan@uniontech.com>
    net: phonet: do not BUG_ON() in pn_socket_autobind() on failed bind

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    drm/amd/display: Wrap DCN32 phantom-plane allocation in DC_RUN_WITH_PREEMPTION_ENABLED

Qu Wenruo <wqu@suse.com>
    btrfs: only release the dirty pages io tree after successful writes

Zhenzhong Duan <zhenzhong.duan@intel.com>
    iommu/vt-d: Avoid NULL pointer dereference or refcount corruption

Hyunwoo Kim <imv4bel@gmail.com>
    KVM: arm64: Take the SRCU lock for page table walks in fault injection and AT emulation

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: fix leak if split 6 GHz scanning fails

Xin Long <lucien.xin@gmail.com>
    sctp: validate embedded INIT chunk and address list lengths in cookie

Salman Alghamdi <me@cipherat.com>
    staging: rtl8723bs: rtw_mlme: add bounds checks before ie_length subtraction

Danilo Krummrich <dakr@kernel.org>
    vdpa: use generic driver_override infrastructure

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/pgtable-frag: Fix bad page state in pte_frag_destroy

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    powerpc/64s: Fix unmap race with PMD migration entries

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: Fix memory leak destroying device

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt7925: fix potential deadlock in mt7925_roc_abort_sync

Eric Dumazet <edumazet@google.com>
    net: pull headers in qdisc_pkt_len_segs_init()

Damien Riégel <damien.riegel@silabs.com>
    greybus: raw: fix use-after-free on cdev close

Jianan Huang <huangjianan@xiaomi.com>
    f2fs: avoid reading already updated pages during GC

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix data loss caused by incorrect use of nat_entry flag

Michal Schmidt <mschmidt@redhat.com>
    ice: fix double-free of tx_buf skb

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nat: use kfree_rcu to release ops

Edward Adam Davis <eadavis@qq.com>
    sched/psi: fix race between file release and pressure write

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: fix BQL imbalance in TX path

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Fix potential out-of-bounds access in __ceph_x_decrypt()

Weiming Shi <bestswngs@gmail.com>
    tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR

D. Wythe <alibuda@linux.alibaba.com>
    Revert "net/smc: Introduce TCP ULP support"

Li Zhijian <lizhijian@fujitsu.com>
    RDMA/rxe: Fix iova-to-va conversion for MR page sizes != PAGE_SIZE

Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
    RDMA/rxe: Move some code to rxe_loc.h in preparation for ODP

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: use list_del_rcu for netlink hooks

Stephen Smalley <stephen.smalley.work@gmail.com>
    selinux: allow multiple opens of /sys/fs/selinux/policy

Yicong Yang <yangyicong@hisilicon.com>
    coresight: tmc-etr: Fix race condition between sysfs and perf mode

Mike Snitzer <snitzer@hammerspace.com>
    NFS/localio: prevent direct reclaim recursion into NFS via nfs_writepages

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix dc_link NULL handling in HPD init

Johan Hovold <johan@kernel.org>
    spi: ch341: fix devres lifetime

Yang Yingliang <yangyingliang@huawei.com>
    spi: ch341: switch to use devm_spi_alloc_host()

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx4: Fix mis-use of RCU in mlx4_srq_event()

Suren Baghdasaryan <surenb@google.com>
    refcount: provide ops for cases when object's memory can be reused

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix fsck inconsistency caused by FGGC of node block

Osama Abdelkader <osama.abdelkader@gmail.com>
    riscv: kvm: fix vector context allocation leak

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: control built-in cs manually

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: remove unused param from mchp_coreqspi_write_op()

Conor Dooley <conor.dooley@microchip.com>
    spi: microchip-core-qspi: set min_speed_hz during probe

Miquel Raynal <miquel.raynal@bootlin.com>
    spi: microchip-core-qspi: Support per spi-mem operation frequency switches

Eric Biggers <ebiggers@kernel.org>
    dm-verity-fec: fix reading parity bytes split across blocks (take 3)

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Avoid clearing VMCB_LBR in vmcb12

Sam Edwards <cfsworks@gmail.com>
    ceph: fix num_ops off-by-one when crypto allocation fails

Matthew Wilcox (Oracle) <willy@infradead.org>
    ceph: Remove uses of page from ceph_process_folio_batch()

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: introduce ceph_process_folio_batch() method

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: extend ceph_writeback_ctl for ceph_writepages_start() refactoring

Matthew Wilcox (Oracle) <willy@infradead.org>
    ceph: Remove call to PagePrivate2()

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always use NextRIP as vmcb02's NextRIP after first L2 VMRUN

Sean Christopherson <seanjc@google.com>
    KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"

Corey Minyard <corey@minyard.net>
    ipmi:ssif: Clean up kthread on errors

Yosry Ahmed <yosry@kernel.org>
    KVM: SVM: Add missing save/restore handling of LBR MSRs

Deepanshu Kartikey <kartikey406@gmail.com>
    gfs2: fix memory leaks in gfs2_fill_super error path

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use priv->vidi_dev for ctx lookup in vidi_connection_ioctl()

Jie Zhang <jzhang918@gmail.com>
    net: stmmac: fix oops when split header is enabled

Boris Burkov <boris@bur.io>
    btrfs: fix EEXIST abort due to non-consecutive gaps in chunk allocation

Guillaume Gonnet <ggonnet.linux@gmail.com>
    bpf: Fix tcx/netkit detach permissions when prog fd isn't given

Dave Airlie <airlied@redhat.com>
    nouveau/gsp: drop WARN_ON in ACPI probes

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: RX, Fix XDP multi-buf frag counting for striding RQ

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: RX, Fix XDP multi-buf frag counting for legacy RQ

Miaoqian Lin <linmq006@gmail.com>
    rxrpc, afs: Fix missing error pointer check after rxrpc_kernel_lookup_peer()

David Howells <dhowells@redhat.com>
    rxrpc: kdoc: Update function descriptions and add link from rxrpc.rst

Chen Ni <nichen@iscas.ac.cn>
    ASoC: amd: acp-mach-common: Add missing error check for clock acquisition

Vladimir Riabchun <ferr.lambarginio@gmail.com>
    scsi: qla2xxx: Completely fix fcport double free

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Fix race in DMA ring dequeue

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue

Kohei Enju <kohei@enjuk.jp>
    ice: ptp: don't WARN when controlling PF is unavailable

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix NULL pointer dereference in dcn401_init_hw()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: don't send a 6E related command when not supported

Prathamesh Shete <pshete@nvidia.com>
    soc/tegra: pmc: Fix unsafe generic_handle_irq() call

Thierry Reding <treding@nvidia.com>
    syscore: Pass context data to callbacks

Kai Huang <kai.huang@intel.com>
    KVM: Export hardware virtualization enabling/disabling functions

Ming Qian <ming.qian@oss.nxp.com>
    media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: v4l2-mem2mem: Add a kref to the v4l2_m2m_dev structure

Heinz Mauelshagen <heinzm@redhat.com>
    md raid: fix hang when stopping arrays with metadata through dm-raid

Filipe Manana <fdmanana@suse.com>
    btrfs: don't BUG() on unexpected delayed ref type in run_one_delayed_ref()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove 'reserved' argument from btrfs_pin_extent()

Qu Wenruo <wqu@suse.com>
    btrfs: do not ASSERT() when the fs flips RO inside btrfs_repair_io_failure()

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Skip vcn poison irq release on VF

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    drm: renesas: rz-du: mipi_dsi: fix kernel panic when rebooting for some panels

Daniil Dulov <d.dulov@aladdin.ru>
    ring-buffer: Fix possible dereference of uninitialized pointer

Jackson Lee <jackson.lee@chipsnmedia.com>
    media: chips-media: wave5: Fix Null reference while testing fluster

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    team: avoid NETDEV_CHANGEMTU event when unregistering slave

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: validate sequence number of TX release report

Cédric Bellegarde <cedric.bellegarde@adishatz.org>
    ASoC: qcom: q6asm: drop DSP responses for closed data streams

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6asm: handle the responses after closing

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Adjust PHY FSM transition to TX_EN-to-PLL_ON for TMDS on DCN35

Nicholas Carlini <nicholas@carlini.com>
    ksmbd: fix signededness bug in smb_direct_prepare_negotiation()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: fix 22000 series SMEM parsing

Szymon Wilczek <swilczek.lx@gmail.com>
    ntfs3: fix circular locking dependency in run_unpack_ex

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Accumulated refactoring changes

Filipe Manana <fdmanana@suse.com>
    btrfs: fix zero size inode with non-zero size after log replay

David Sterba <dsterba@suse.com>
    btrfs: tree-log: don't use token set/get accessors in fill_inode_item()

Joel Fernandes <joelagnelf@nvidia.com>
    srcu: Use irq_work to start GP in tiny SRCU

Thomas Gleixner <tglx@linutronix.de>
    irqwork: Move data struct to a types header

Suren Baghdasaryan <surenb@google.com>
    types: move struct rcuwait into types.h

Eric Dumazet <edumazet@google.com>
    ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()

Justin Iurman <justin.iurman@gmail.com>
    net: ioam6: fix OOB and missing lock

Long Li <leo.lilong@huawei.com>
    xfs: close crash window in attr dabtree inactivation

Long Li <leo.lilong@huawei.com>
    xfs: factor out xfs_attr3_node_entry_remove

Long Li <leo.lilong@huawei.com>
    xfs: remove bp->b_error check in xfs_attr3_root_inactive

Lee Jones <lee@kernel.org>
    HID: core: Mitigate potential OOB by removing bogus memset()

Li Chen <chenl311@chinatelecom.cn>
    HID: rate-limit hid_warn to prevent log flooding

Tatsuya S <tatsuya.s2862@gmail.com>
    HID: core: Add reserved item tag for main items

Sabrina Dubroca <sd@queasysnail.net>
    mpls: add seqcount to protect the platform_label{,s} pair

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Protect net->mpls.platform_label with a per-netns mutex.

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Convert mpls_dump_routes() to RCU.

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Add mpls_route_input().

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Pass net to mpls_dev_get().

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Add mpls_dev_rcu().

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Unify return paths in mpls_dev_notify().

Kuniyuki Iwashima <kuniyu@google.com>
    mpls: Hold dev refcnt for mpls_nh.

Pengpeng Hou <pengpeng@iscas.ac.cn>
    bnxt_en: set backing store type from query type

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Update firmware interface spec to 1.10.3.85

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: hci_cmd_sync_queue_once() return -EEXIST if exists

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect pruning due to atomic fetch precision tracking

Peilin Ye <yepeilin@google.com>
    bpf: Factor out check_load_mem() and check_store_reg()

Peilin Ye <yepeilin@google.com>
    bpf: Factor out check_atomic_rmw()

Peilin Ye <yepeilin@google.com>
    bpf: Factor out atomic_ptr_type_ok()

Oleh Konko <security@1seal.org>
    Bluetooth: hci_event: move wake reason storage into validated event handlers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rxrpc: proc: size address buffers for %pISpc output

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock

Ge Yang <yangge1116@126.com>
    KVM: SEV: Use long-term pin when registering encrypted memory regions

Shardul Bankar <shardul.b@mpiricsoftware.com>
    wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Add ->exit_rtnl() hook to struct pernet_operations.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Add ops_undo_single for module load/unload.

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Factorise setup_net() and cleanup_net().

Kory Maincent (TI.com) <kory.maincent@bootlin.com>
    drm/tilcdc: Fix removal actions in case of failed probe

Benjamin Marzinski <bmarzins@redhat.com>
    dm: limit swapping tables for devices with zone write plugs

Janosch Frank <frankja@linux.ibm.com>
    s390/mm: Add missing secure storage access fixups for donated memory

Luca Leonardo Scorcia <l.scorcia@gmail.com>
    drm/mediatek: dsi: Store driver data before invoking mipi_dsi_host_register

Ihor Solodrai <ihor.solodrai@linux.dev>
    bpf: Fix exception exit lock checking for subprogs

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Fix use of completion ctx after free

Jiayuan Chen <jiayuan.chen@shopee.com>
    serial: core: fix infinite loop in handle_tx() for PORT_UNKNOWN

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    serial: rename local uart_port_lock() -> uart_port_ref_lock()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: clone set on flush only

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting

Davidlohr Bueso <dave@stgolabs.net>
    cxl/mbox: validate payload size before accessing contents in cxl_payload_from_user_allowed()

Jens Axboe <axboe@kernel.dk>
    io_uring/rw: free potentially allocated iovec on cache put failure

Martin Kaiser <martin@kaiser.cx>
    riscv: trace: fix snapshot deadlock with sbi ecall

Edward Adam Davis <eadavis@qq.com>
    ALSA: usb-audio: Prevent excessive number of frames

Gustavo A. R. Silva <gustavoars@kernel.org>
    virtio_net: Fix misalignment bug in struct virtnet_info

Gustavo A. R. Silva <gustavoars@kernel.org>
    stddef: Introduce TRAILING_OVERLAP() helper macro

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix error handling in the init_task on load

Caleb Sander Mateos <csander@purestorage.com>
    block: zero non-PI portion of auto integrity buffer

Jie Zhang <jie.zhang@oss.qualcomm.com>
    drm/msm: Recover HW before retire hung submit

Cong Nguyen <congnt264@gmail.com>
    staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark bpf_refcount field as unique

Haotian Zhang <vulab@iscas.ac.cn>
    PCI: endpoint: Add missing NULL check for alloc_workqueue()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: Drop the MHI auto_queue feature for IPCR DL channels

Jeffrey Hugo <quic_jhugo@quicinc.com>
    accel/qaic: Add config structs for supported cards

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't WARN for connections on invalid channels

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: log link information in ieee80211_determine_chan_mode

Benjamin Berg <benjamin.berg@intel.com>
    wifi: mac80211: fix typo in HE MCS check

Johan Hovold <johan@kernel.org>
    staging: most: remove broken i2c driver

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/fpu: Fix false-positive kmsan report in fpu_vstl()

Tony Battersby <tonyb@cybernetics.com>
    scsi: qla2xxx: Clear cmds after chip reset

Akash Goel <akash.goel@arm.com>
    drm/panthor: Prevent potential UAF in group creation

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Fix page fault in ivpu_bo_unbind_all_bos_from_context()

Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
    accel/ivpu: Rework bind/unbind of imported buffers

Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
    accel/ivpu: Allow to import single buffer into multiple contexts

Sarika Sharma <sarika.sharma@oss.qualcomm.com>
    wifi: ath12k: Fix MSDU buffer types handling in RX error path

Xiaoqi Zhuang <xiaoqi.zhuang@oss.qualcomm.com>
    coresight: ETR: Fix ETR buffer use-after-free issue

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight-tmc: change tmc_drvdata spinlock's type to raw_spinlock_t

Li Nan <linan122@huawei.com>
    md: init bioset in mddev_init

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: wed: use proper wed reference in mt76 wed driver callabacks

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: fix double free of qgroup record after failure to add delayed ref head

Antoine Tenart <atenart@kernel.org>
    net: vxlan: prevent NULL deref in vxlan_xmit_one

Gustavo Luiz Duarte <gustavold@gmail.com>
    netconsole: Acquire su_mutex before navigating configs hierarchy

Icenowy Zheng <uwu@icenowy.me>
    clk: thead: th1520-ap: set all AXI clocks to CLK_IS_CRITICAL

Nitin Rawat <nitin.rawat@oss.qualcomm.com>
    scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)

Nitin Rawat <quic_nitirawa@quicinc.com>
    scsi: ufs: qcom : Refactor phy_power_on/off calls

Akiva Goldberger <agoldberger@nvidia.com>
    mlx5: Fix default values in create CQ

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5e: Prepare for using different CQ doorbells

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Store the global doorbell in mlx5_priv

Cosmin Ratiu <cratiu@nvidia.com>
    net/mlx5: Fix typo of MLX5_EQ_DOORBEL_OFFSET

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, fix bad parameter in CQ creation

Yishai Hadas <yishaih@nvidia.com>
    RDMA/mlx5: Remove the redundant MLX5_IB_STAGE_UAR stage

Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
    drm/xe/guc: Add devm release action to safely tear down CT

Yifan Zhang <yifan1.zhang@amd.com>
    amd/amdkfd: enhance kfd process check in switch partition

Fernando Fernandez Mancera <fmancera@suse.de>
    sysfs: check visibility before changing group attribute ownership

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Do not share the name pointer between components

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Use topology information for endpoint numbers

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - request reserved interrupt for virtual function

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/hpre - enable all clusters clock gating

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    scsi: ufs: core: Fix data race in CPU latency PM QoS request handling

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: pas: Shutdown lite ADSP DTB on X1E

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: qcom: pas: Conclude the rename from adsp

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    remoteproc: qcom_q6v5_pas: Simplify with dev_err_probe()

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: qcom: pas: Make remoteproc name human friendly

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    remoteproc: Switch back to struct platform_driver::remove()

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Don't allow evicting of BOs in same VM in array of VM binds

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    RISC-V: KVM: Write hgatp register with valid mode bits

Niklas Schnelle <schnelle@linux.ibm.com>
    iommu/s390: Make attach succeed when the device was surprise removed

Matthew Rosato <mjrosato@linux.ibm.com>
    iommu/s390: set appropriate IOTA region type

Matthew Rosato <mjrosato@linux.ibm.com>
    iommu/s390: handle IOAT registration based on domain

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done verify data_offset, data_length and remaining_data_length

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm/vmalloc, mm/kasan: respect gfp mask in kasan_populate_vmalloc()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix list corruption after hardware restart

Duoming Zhou <duoming@zju.edu.cn>
    ptp: ocp: fix use-after-free bugs causing by ptp_ocp_watchdog

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: HWS, Fix memory leak in hws_action_get_shared_stc_nic error flow

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Refactor pool implementation

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Make pool single resource

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, Remove unused element array

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, update flow - remove the use of dual RTCs

Vlad Dogaru <vdogaru@nvidia.com>
    net/mlx5: HWS, handle returned error value in pool alloc

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, simplify allocations as we support only FDB

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: HWS, denote how refcounts are protected

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aegis - Add missing error checks

Eric Biggers <ebiggers@kernel.org>
    crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - improve assembly function prototypes

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - optimize length block preparation using SSE4.1

Eric Biggers <ebiggers@google.com>
    crypto: x86/aegis128 - eliminate some indirect calls

David Hildenbrand <david@redhat.com>
    mm/mremap: fix WARN with uffd that has remap events disabled

William Liu <will@willsroot.io>
    net/sched: Fix backlog accounting in qdisc_dequeue_internal

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: iwlwifi: Fix error code in iwl_op_mode_dvm_start()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: return ERR_PTR from opmode start()

Gabriele Monaco <gmonaco@redhat.com>
    rv: Use strings in da monitors tracepoints

Gabriele Monaco <gmonaco@redhat.com>
    rv: Remove trailing whitespace from tracepoint string

Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
    wifi: ath12k: Pass ab pointer directly to ath12k_dp_tx_get_encap_type()

Heiko Stuebner <heiko@sntech.de>
    drm/rockchip: vop2: fail cleanly if missing a primary plane for a video-port

Andy Yan <andy.yan@rock-chips.com>
    drm/rockchip: vop2: Register the primary plane and overlay plane separately

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    drm/rockchip: vop2: Consistently use dev_err_probe()

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmf: Use device managed allocations

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Switch to platform_get_resource() and devm_ioremap_resource()

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix in_atomic() handling in do_secure_storage_access()

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Get rid of fault type switch statements

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Simplify get_fault_type()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/mm/fault: Handle guest-related program interrupts in KVM

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/kvm: Remove kvm_arch_fault_in_page()

Claudio Imbrenda <imbrenda@linux.ibm.com>
    s390/entry: Remove __GMAP_ASCE and use _PIF_GUEST_FAULT again

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: pci: configure manual DAC mode via PCI config API only

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: save the SR_SUM status over switches

Samuel Holland <samuel.holland@sifive.com>
    riscv: Add support for per-thread envcfg CSR values

Samuel Holland <samuel.holland@sifive.com>
    riscv: Enable cbo.zero only when all harts support Zicboz

Pu Lehui <pulehui@huawei.com>
    mm: fix uprobe pte be overwritten when expanding vma

Sidhanta Sahu <sidhanta.sahu@oss.qualcomm.com>
    wifi: ath12k: Fix memory leak due to multiple rx_stats allocation

Sriram R <quic_srirrama@quicinc.com>
    wifi: ath12k: prepare vif data structure for MLO handling

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath12k: ath12k_mac_op_sta_state(): clean up update_wk cancellation

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath12k: convert struct ath12k_sta::update_wk to use struct wiphy_work

Zhi Wang <zhiw@nvidia.com>
    drm/nouveau: fix a use-after-free in r535_gsp_rpc_push()

Brian Norris <briannorris@google.com>
    PCI/pwrctrl: Cancel outstanding rescan work when unregistering

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI/pwrctl: Create pwrctl device only if at least one power supply is present

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI/pwrctl: Use of_platform_device_create() to create pwrctl devices

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: holding cscfg_csdev_lock while removing cscfg from csdev

Michael S. Tsirkin <mst@redhat.com>
    virtio: break and reset virtio devices on device_shutdown()

Roger Quadros <rogerq@kernel.org>
    dmaengine: ti: k3-udma-glue: Drop skip_fdq argument from k3_udma_glue_reset_rx_chn

Roger Quadros <rogerq@kernel.org>
    net: ethernet: ti: am65-cpsw: streamline RX queue creation and cleanup

Philippe Simons <simons.philippe@gmail.com>
    clk: sunxi-ng: h616: Reparent GPU clock during frequency changes

Andre Przywara <andre.przywara@arm.com>
    clk: sunxi-ng: h616: Reparent CPU clock during frequency changes

Alexander Gordeev <agordeev@linux.ibm.com>
    kasan: avoid sleepable page allocation from atomic context

Ming Lei <ming.lei@redhat.com>
    ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd

Yunhui Cui <cuiyunhui@bytedance.com>
    perf/dwc_pcie: fix duplicate pci_dev devices

Bjorn Helgaas <bhelgaas@google.com>
    perf/dwc_pcie: Qualify RAS DES VSEC Capability by Vendor, Revision

P Praneesh <quic_ppranees@quicinc.com>
    wifi: ath12k: Avoid memory leak while enabling statistics

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: Avoid explicit type cast in monitor status parse handler

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: fix incorrect TID updation in DP monitor status path

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath12k: fix struct hal_rx_phyrx_rssi_legacy_info

Atish Patra <atishp@rivosinc.com>
    RISC-V: KVM: Teardown riscv specific bits after kvm_exit

Chao Yu <chao@kernel.org>
    f2fs: quota: fix to avoid warning in dquot_writeback_dquots()

Murad Masimov <m.masimov@mt-integration.ru>
    ax25: Remove broken autobind

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Grab intel_display from the encoder to avoid potential oopsies

Jani Nikula <jani.nikula@intel.com>
    drm/i915/crt: convert to struct intel_display

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gmbus: convert to struct intel_display

Jani Nikula <jani.nikula@intel.com>
    drm/i915/display: convert I915_STATE_WARN() to struct intel_display

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vga: Convert VGA code to intel_display

Jani Nikula <jani.nikula@intel.com>
    drm/i915/display: pass display to intel_crtc_for_pipe()

Benjamin Berg <benjamin.berg@intel.com>
    um: work around sched_yield not yielding in time-travel mode

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix compound alignment with encryption

Paulo Alcantara <pc@manguebit.com>
    smb: client: get rid of bounds check in SMB2_ioctl_init()

Paulo Alcantara <pc@manguebit.com>
    smb: client: improve compound padding in encryption

Christian Brauner <brauner@kernel.org>
    namespace: handle mount locking for automounts correctly

Christian Brauner <brauner@kernel.org>
    fcntl: refuse F_SET_RW_HINT on an immutable inode

Christian Brauner <brauner@kernel.org>
    namespace: check the target before walking it in do_mount_setattr()

Christian Brauner <brauner@kernel.org>
    namespace: unhash a dentry before detaching the mounts on it

Wentao Liang <vulab@iscas.ac.cn>
    drm/vc4: Fix firmware reference leak in vc4_drm_bind()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/vc4: Use video aperture helpers

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Add debug log for MCQ command timeout

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()

Ahmed Abdelhaleem Ahmed <ahmedhal@gmail.com>
    scsi: ch: Do not keep references to data transfer element devices

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ

Wei-Jie Hung <imbigking12@gmail.com>
    riscv: patch: fix handling of bpf-jit execmem addresses

Vivian Wang <wangruikang@iscas.ac.cn>
    riscv: patch: Avoid early phys_to_page()

Suraj Gupta <suraj.gupta2@amd.com>
    net: xilinx: axienet: Free outstanding DMA buffers on dmaengine stop

Ben Cressey <ben@cressey.dev>
    dm-integrity: fix buffer overflow in inline mode with large tag size

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: rename internal_hash

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: use internal variable for digestsize

Christian Brauner <brauner@kernel.org>
    namespace: check the mounts before reading their parents in pivot_root()

Christian Brauner <brauner@kernel.org>
    namespace: don't inherit MNT_UMOUNT in clone_mnt()

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate pitch coming from userspace

Maaz Mombasawala <maaz.mombasawala@broadcom.com>
    drm/vmwgfx: Stop using dev_private to store driver data.

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Bluetooth: RFCOMM: connect the session socket without rfcomm_mutex

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix command skb lifetime during scan setup

Tejun Heo <tj@kernel.org>
    sched_ext: Fix CPU hotplug hang when a dying CPU's tasks sit in the BPF scheduler

Weiming Shi <bestswngs@gmail.com>
    net: team: stop reusing skb after queue override

Weiming Shi <bestswngs@gmail.com>
    net: team: fix NULL pointer dereference in team_xmit during mode change

Marc Harvey <marcharvey@google.com>
    net: team: Rename port_disabled team mode op to port_tx_disabled

Marc Harvey <marcharvey@google.com>
    net: team: Remove unused team_mode_op, port_enabled

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: connac: tolerate inactive BSS deactivation

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP

Hengyu Liang <hengyul@cs.unc.edu>
    ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Create a device link between APU display and XHCI devices

Dave Chinner <dchinner@redhat.com>
    xfs: fix unmount hang with unflushable inodes stuck in the AIL

Dave Chinner <dchinner@redhat.com>
    xfs: factor out stale buffer item completion

Dave Chinner <dchinner@redhat.com>
    xfs: rearrange code in xfs_buf_item.c

Dave Chinner <dchinner@redhat.com>
    xfs: avoid dquot buffer pin deadlock

Dave Chinner <dchinner@redhat.com>
    xfs: catch stale AGF/AGF metadata

Dave Chinner <dchinner@redhat.com>
    xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock

Daehyeon Ko <4ncienth@gmail.com>
    ip6_gre: remove obsolete ERSPAN PMTU update

Darrick J. Wong <djwong@kernel.org>
    xfs: fix exchange-range-to-eof file size exchange

Norbert Szetei <norbert@doyensec.com>
    xfs: stop exchanging reflink flags when exchanging mappings

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ice: fix use-after-free in dynamic port cleanup

Zhen Ni <zhen.ni@easystack.cn>
    iommu/amd: Fix ivrs_base memleak in early_amd_iommu_init()

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Disable AMD IOMMU if CMPXCHG16B feature is not supported

Ethan Tidmore <ethantidmore06@gmail.com>
    usb: gadget: f_hid: Add missing error code

Johan Hovold <johan@kernel.org>
    spi: mpc52xx: clean up interrupt handling


-------------

Diffstat:

 Documentation/RCU/whatisRCU.rst                    |   10 +
 Documentation/admin-guide/device-mapper/dm-ima.rst |    7 +-
 .../admin-guide/device-mapper/dm-integrity.rst     |   13 +
 Documentation/core-api/refcount-vs-atomic.rst      |   37 +-
 Documentation/networking/af_xdp.rst                |   54 +-
 .../networking/net_cachelines/net_device.rst       |    2 +-
 Documentation/networking/rxrpc.rst                 |   11 +
 Documentation/networking/switchdev.rst             |    2 +-
 Makefile                                           |   31 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |   12 +-
 arch/arm/mach-exynos/suspend.c                     |   48 +-
 arch/arm/mach-pxa/generic.h                        |    6 +-
 arch/arm/mach-pxa/irq.c                            |   10 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |   10 +-
 arch/arm/mach-pxa/mfp-pxa3xx.c                     |   10 +-
 arch/arm/mach-pxa/pxa25x.c                         |    4 +-
 arch/arm/mach-pxa/pxa27x.c                         |    4 +-
 arch/arm/mach-pxa/pxa3xx.c                         |    4 +-
 arch/arm/mach-pxa/smemc.c                          |   12 +-
 arch/arm/mach-s3c/irq-pm-s3c64xx.c                 |   12 +-
 arch/arm/mach-s5pv210/pm.c                         |   10 +-
 arch/arm/mach-versatile/integrator_ap.c            |   12 +-
 arch/arm/mm/cache-b15-rac.c                        |   12 +-
 arch/arm64/kernel/ptrace.c                         |   50 +
 arch/arm64/kvm/at.c                                |    3 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   12 +-
 arch/arm64/kvm/vgic/vgic.c                         |    9 +-
 arch/loongarch/kernel/machine_kexec.c              |    5 +-
 arch/loongarch/kernel/smp.c                        |   12 +-
 arch/loongarch/net/bpf_jit.c                       |   20 +-
 arch/mips/alchemy/common/dbdma.c                   |   12 +-
 arch/mips/alchemy/common/irq.c                     |   24 +-
 arch/mips/alchemy/common/usb.c                     |   12 +-
 arch/mips/pci/pci-alchemy.c                        |   16 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   15 +
 arch/powerpc/include/asm/xive.h                    |    4 +-
 arch/powerpc/mm/book3s64/pgtable.c                 |   13 +-
 arch/powerpc/mm/pgtable-frag.c                     |    1 +
 arch/powerpc/platforms/cell/spu_base.c             |   10 +-
 arch/powerpc/platforms/powermac/pic.c              |   12 +-
 arch/powerpc/platforms/powernv/smp.c               |    8 +-
 arch/powerpc/platforms/pseries/smp.c               |    8 +-
 arch/powerpc/sysdev/fsl_lbc.c                      |   12 +-
 arch/powerpc/sysdev/fsl_pci.c                      |   12 +-
 arch/powerpc/sysdev/ipic.c                         |   12 +-
 arch/powerpc/sysdev/mpic.c                         |   14 +-
 arch/powerpc/sysdev/mpic_timer.c                   |   10 +-
 arch/powerpc/sysdev/xive/common.c                  |   10 +-
 arch/riscv/include/asm/processor.h                 |    2 +
 arch/riscv/include/asm/switch_to.h                 |    8 +
 arch/riscv/kernel/Makefile                         |   15 +-
 arch/riscv/kernel/asm-offsets.c                    |    5 +
 arch/riscv/kernel/cpufeature.c                     |    9 +-
 arch/riscv/kernel/entry.S                          |    9 +
 arch/riscv/kernel/patch.c                          |   21 +-
 arch/riscv/kernel/suspend.c                        |    4 +-
 arch/riscv/kvm/main.c                              |    4 +-
 arch/riscv/kvm/vcpu_vector.c                       |    5 +-
 arch/riscv/kvm/vmid.c                              |    2 +-
 arch/s390/include/asm/fpu-insn.h                   |    3 +
 arch/s390/include/asm/gmap.h                       |    3 +-
 arch/s390/include/asm/kvm_host.h                   |    3 +
 arch/s390/include/asm/nmi.h                        |    3 +
 arch/s390/include/asm/pci.h                        |    2 +
 arch/s390/include/asm/pci_insn.h                   |   10 +-
 arch/s390/include/asm/processor.h                  |    5 +-
 arch/s390/include/asm/ptrace.h                     |    2 +
 arch/s390/include/asm/uv.h                         |    6 +-
 arch/s390/kernel/asm-offsets.c                     |    2 -
 arch/s390/kernel/entry.S                           |   44 +-
 arch/s390/kernel/nmi.c                             |    5 +-
 arch/s390/kernel/traps.c                           |   24 +-
 arch/s390/kernel/uv.c                              |  383 +++----
 arch/s390/kvm/Makefile                             |    2 +-
 arch/s390/kvm/gaccess.c                            |   42 +-
 arch/s390/kvm/gmap.c                               |  121 +++
 arch/s390/kvm/gmap.h                               |   19 +
 arch/s390/kvm/intercept.c                          |    7 +-
 arch/s390/kvm/interrupt.c                          |   24 +-
 arch/s390/kvm/kvm-s390.c                           |  222 +++-
 arch/s390/kvm/kvm-s390.h                           |   14 +-
 arch/s390/kvm/pci.c                                |   17 +-
 arch/s390/kvm/pv.c                                 |   21 +
 arch/s390/kvm/vsie.c                               |   15 +-
 arch/s390/mm/fault.c                               |  189 +---
 arch/s390/mm/gmap.c                                |   45 +-
 arch/s390/net/bpf_jit_comp.c                       |   11 +
 arch/s390/pci/pci.c                                |   35 +-
 arch/s390/pci/pci_sysfs.c                          |   11 +-
 arch/sh/mm/pmb.c                                   |   10 +-
 arch/um/include/linux/time-internal.h              |    2 +
 arch/um/kernel/skas/syscall.c                      |   11 +
 arch/x86/crypto/Kconfig                            |    4 +-
 arch/x86/crypto/aegis128-aesni-asm.S               |  110 +-
 arch/x86/crypto/aegis128-aesni-glue.c              |  156 +--
 arch/x86/events/amd/ibs.c                          |   12 +-
 arch/x86/events/intel/core.c                       |   32 +-
 arch/x86/events/intel/ds.c                         |    8 +-
 arch/x86/events/intel/uncore.c                     |   46 +-
 arch/x86/events/perf_event.h                       |    3 +
 arch/x86/hyperv/hv_init.c                          |   12 +-
 arch/x86/kernel/amd_gart_64.c                      |   10 +-
 arch/x86/kernel/apic/apic.c                        |   12 +-
 arch/x86/kernel/apic/io_apic.c                     |   17 +-
 arch/x86/kernel/cpu/aperfmperf.c                   |   20 +-
 arch/x86/kernel/cpu/intel_epb.c                    |   16 +-
 arch/x86/kernel/cpu/mce/core.c                     |   14 +-
 arch/x86/kernel/cpu/microcode/core.c               |   15 +-
 arch/x86/kernel/cpu/mtrr/legacy.c                  |   12 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |   19 +-
 arch/x86/kernel/cpu/umwait.c                       |   10 +-
 arch/x86/kernel/i8237.c                            |   10 +-
 arch/x86/kernel/i8259.c                            |   14 +-
 arch/x86/kernel/kvm.c                              |   12 +-
 arch/x86/kvm/cpuid.c                               |    2 +-
 arch/x86/kvm/cpuid.h                               |   16 +-
 arch/x86/kvm/lapic.c                               |   61 +-
 arch/x86/kvm/lapic.h                               |    4 +-
 arch/x86/kvm/mmu.h                                 |    2 +-
 arch/x86/kvm/mmu/mmu.c                             |    4 +-
 arch/x86/kvm/regs.c                                |    6 +-
 arch/x86/kvm/svm/nested.c                          |   64 +-
 arch/x86/kvm/svm/sev.c                             |   42 +-
 arch/x86/kvm/svm/svm.c                             |   70 +-
 arch/x86/kvm/svm/svm.h                             |    4 +-
 arch/x86/kvm/vmx/nested.c                          |   11 +-
 arch/x86/kvm/vmx/vmx.c                             |   16 +-
 arch/x86/kvm/x86.c                                 |   60 +-
 arch/x86/kvm/x86.h                                 |    5 +-
 block/bfq-cgroup.c                                 |    9 +-
 block/bio-integrity.c                              |    6 +-
 block/blk-cgroup.c                                 |    5 +-
 block/blk-cgroup.h                                 |    2 +
 block/blk-iocost.c                                 |   21 +-
 block/blk-iolatency.c                              |   19 +-
 block/blk-throttle.c                               |   15 +-
 drivers/accel/ivpu/ivpu_drv.c                      |    2 +-
 drivers/accel/ivpu/ivpu_gem.c                      |  111 +-
 drivers/accel/ivpu/ivpu_gem.h                      |    3 +-
 drivers/accel/ivpu/ivpu_job.c                      |    2 +-
 drivers/accel/qaic/mhi_controller.c                |   24 -
 drivers/accel/qaic/qaic.h                          |   13 +-
 drivers/accel/qaic/qaic_drv.c                      |   76 +-
 drivers/accel/qaic/qaic_timesync.c                 |    2 +-
 drivers/acpi/acpi_platform.c                       |   16 +-
 drivers/acpi/bus.c                                 |   54 +-
 drivers/acpi/device_pm.c                           |    4 +-
 drivers/acpi/pci_link.c                            |   10 +-
 drivers/acpi/sleep.c                               |   12 +-
 drivers/ata/libata-core.c                          |    7 +
 drivers/ata/libata-scsi.c                          |   10 +-
 drivers/base/core.c                                |   74 +-
 drivers/base/firmware_loader/main.c                |   12 +-
 drivers/base/power/main.c                          |   67 +-
 drivers/base/power/runtime.c                       |   61 +-
 drivers/base/syscore.c                             |   82 +-
 drivers/block/ublk_drv.c                           |   37 +-
 drivers/bus/mhi/host/pci_generic.c                 |   20 +-
 drivers/bus/mvebu-mbus.c                           |   16 +-
 drivers/char/ipmi/ipmi_ssif.c                      |   20 +
 drivers/clk/at91/pmc.c                             |   12 +-
 drivers/clk/imx/clk-vf610.c                        |   12 +-
 drivers/clk/ingenic/jz4725b-cgu.c                  |    2 +-
 drivers/clk/ingenic/jz4740-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4755-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4760-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4770-cgu.c                   |    2 +-
 drivers/clk/ingenic/jz4780-cgu.c                   |    2 +-
 drivers/clk/ingenic/pm.c                           |   14 +-
 drivers/clk/ingenic/pm.h                           |    2 +-
 drivers/clk/ingenic/tcu.c                          |   12 +-
 drivers/clk/ingenic/x1000-cgu.c                    |    2 +-
 drivers/clk/ingenic/x1830-cgu.c                    |    2 +-
 drivers/clk/mediatek/clk-pllfh.c                   |   98 +-
 drivers/clk/mvebu/common.c                         |   12 +-
 drivers/clk/rockchip/clk-rk3288.c                  |   12 +-
 drivers/clk/samsung/clk-s5pv210-audss.c            |   12 +-
 drivers/clk/samsung/clk.c                          |   12 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h616.c             |   64 +-
 drivers/clk/tegra/clk-tegra210.c                   |   12 +-
 drivers/clk/thead/clk-th1520-ap.c                  |   30 +-
 drivers/clocksource/samsung_pwm_timer.c            |   22 +-
 drivers/clocksource/timer-armada-370-xp.c          |   12 +-
 drivers/cpuidle/cpuidle-psci.c                     |   12 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   36 +-
 drivers/crypto/hisilicon/qm.c                      |   38 +-
 drivers/cxl/core/core.h                            |    2 +
 drivers/cxl/core/mbox.c                            |   11 +-
 drivers/cxl/core/port.c                            |    7 +-
 drivers/cxl/core/ras.c                             |   10 +-
 drivers/cxl/core/region.c                          |   81 +-
 drivers/cxl/core/trace.h                           |   12 +-
 drivers/cxl/cxl.h                                  |   22 +-
 drivers/dma/idxd/init.c                            |   36 +-
 drivers/dma/ti/k3-udma-glue.c                      |   15 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   14 +-
 drivers/dpll/dpll_core.c                           |   12 +-
 drivers/dpll/dpll_netlink.c                        |   68 +-
 drivers/edac/igen6_edac.c                          |  148 ++-
 drivers/firewire/ohci.c                            |    4 +-
 drivers/firmware/arm_ffa/driver.c                  |   56 +-
 drivers/firmware/arm_scmi/bus.c                    |   36 +-
 drivers/gpio/gpio-latch.c                          |    2 +-
 drivers/gpio/gpio-mxc.c                            |   12 +-
 drivers/gpio/gpio-pca953x.c                        |   18 +-
 drivers/gpio/gpio-pxa.c                            |   12 +-
 drivers/gpio/gpio-sa1100.c                         |   12 +-
 drivers/gpio/gpiolib.c                             |  136 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c       |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |   63 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   52 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   23 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.h            |    3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c            |   16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.c            |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_i2c.h            |    3 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   32 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.h            |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   25 +-
 drivers/gpu/drm/amd/amdgpu/amdgv_sriovmsg.h        |  131 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   13 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |    2 -
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.h              |    3 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |    4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |    1 +
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   17 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   13 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   20 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.h  |    2 +
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  199 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |    5 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    4 +
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   24 +-
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |    6 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |    3 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |   25 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |    8 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   10 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h |    8 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |    3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |   12 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c   |    7 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |    6 +-
 drivers/gpu/drm/amd/display/dc/dc_dp_types.h       |    2 +-
 .../drm/amd/display/dc/dml2/dml21/dml21_utils.c    |   15 +-
 .../dml21/src/dml2_core/dml2_core_dcn4_calcs.c     |   31 +-
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   52 +
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.h    |    4 +
 .../gpu/drm/amd/display/dc/hwss/dcn35/dcn35_init.c |    2 +-
 .../drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c  |   13 +-
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |    8 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   12 +
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   10 +
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_0_ppt.c   |   45 +
 drivers/gpu/drm/etnaviv/etnaviv_sched.c            |   20 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h            |    1 +
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |   14 +-
 drivers/gpu/drm/gud/gud_drv.c                      |    2 +
 drivers/gpu/drm/i915/display/g4x_dp.c              |   15 +-
 drivers/gpu/drm/i915/display/i9xx_wm.c             |   15 +-
 drivers/gpu/drm/i915/display/intel_atomic_plane.c  |    4 +-
 drivers/gpu/drm/i915/display/intel_bios.c          |    6 +-
 drivers/gpu/drm/i915/display/intel_cdclk.c         |    6 +-
 drivers/gpu/drm/i915/display/intel_crt.c           |  216 ++--
 drivers/gpu/drm/i915/display/intel_crt.h           |   10 +-
 drivers/gpu/drm/i915/display/intel_crtc.c          |   15 +-
 drivers/gpu/drm/i915/display/intel_crtc.h          |    3 +-
 drivers/gpu/drm/i915/display/intel_cx0_phy.c       |   76 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   48 +-
 drivers/gpu/drm/i915/display/intel_display.h       |   17 +-
 .../gpu/drm/i915/display/intel_display_driver.c    |   18 +-
 drivers/gpu/drm/i915/display/intel_display_irq.c   |   20 +-
 drivers/gpu/drm/i915/display/intel_display_power.c |   71 +-
 .../drm/i915/display/intel_display_power_well.c    |    6 +-
 drivers/gpu/drm/i915/display/intel_display_trace.h |   15 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |    8 +-
 drivers/gpu/drm/i915/display/intel_dpll.c          |   12 +-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c      |   90 +-
 drivers/gpu/drm/i915/display/intel_dsb.c           |    2 +-
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c       |    5 +-
 drivers/gpu/drm/i915/display/intel_dvo.c           |    8 +-
 drivers/gpu/drm/i915/display/intel_fbc.c           |    7 +-
 drivers/gpu/drm/i915/display/intel_fdi.c           |   52 +-
 drivers/gpu/drm/i915/display/intel_fifo_underrun.c |   15 +-
 drivers/gpu/drm/i915/display/intel_gmbus.c         |  290 ++---
 drivers/gpu/drm/i915/display/intel_gmbus.h         |   15 +-
 drivers/gpu/drm/i915/display/intel_gmbus_regs.h    |   16 +-
 drivers/gpu/drm/i915/display/intel_hdmi.c          |    8 +-
 drivers/gpu/drm/i915/display/intel_hotplug_irq.c   |    6 +-
 drivers/gpu/drm/i915/display/intel_link_bw.c       |    3 +-
 drivers/gpu/drm/i915/display/intel_lvds.c          |    2 +-
 drivers/gpu/drm/i915/display/intel_modeset_setup.c |   12 +-
 .../gpu/drm/i915/display/intel_modeset_verify.c    |   89 +-
 drivers/gpu/drm/i915/display/intel_pch_display.c   |   56 +-
 drivers/gpu/drm/i915/display/intel_pps.c           |   26 +-
 drivers/gpu/drm/i915/display/intel_sdvo.c          |    9 +-
 drivers/gpu/drm/i915/display/intel_snps_phy.c      |   11 +-
 drivers/gpu/drm/i915/display/intel_sprite_uapi.c   |    3 +-
 drivers/gpu/drm/i915/display/intel_vga.c           |   45 +-
 drivers/gpu/drm/i915/display/intel_vga.h           |   14 +-
 drivers/gpu/drm/i915/display/skl_watermark.c       |    7 +-
 drivers/gpu/drm/i915/display/vlv_dsi_pll.c         |    7 +-
 .../gpu/drm/i915/gt/intel_execlists_submission.c   |   19 +-
 drivers/gpu/drm/i915/gt/intel_rc6.c                |    2 +-
 drivers/gpu/drm/i915/i915_suspend.c                |    5 +-
 drivers/gpu/drm/i915/i915_utils.h                  |   24 -
 drivers/gpu/drm/imagination/pvr_queue.c            |   18 +-
 drivers/gpu/drm/lima/lima_sched.c                  |   16 +-
 drivers/gpu/drm/mediatek/mtk_dsi.c                 |   11 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    5 +-
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |   24 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   11 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   30 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |   24 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |    1 +
 drivers/gpu/drm/nouveau/nouveau_sched.c            |   16 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c     |   29 +-
 drivers/gpu/drm/panfrost/panfrost_job.c            |   20 +-
 drivers/gpu/drm/panthor/panthor_mmu.c              |   25 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |   77 +-
 drivers/gpu/drm/renesas/rz-du/rzg2l_mipi_dsi.c     |    8 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  182 ++--
 drivers/gpu/drm/scheduler/sched_main.c             |   50 +-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |    2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   53 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.h                |    2 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   65 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |    2 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |    9 +-
 drivers/gpu/drm/virtio/virtgpu_drv.h               |   25 +
 drivers/gpu/drm/virtio/virtgpu_object.c            |    2 +-
 drivers/gpu/drm/virtio/virtgpu_plane.c             |    4 +
 drivers/gpu/drm/virtio/virtgpu_prime.c             |   42 +
 drivers/gpu/drm/virtio/virtgpu_vq.c                |    4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    2 -
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   30 +-
 drivers/gpu/drm/xe/xe_execlist.c                   |   15 +-
 drivers/gpu/drm/xe/xe_gpu_scheduler.c              |   17 +-
 drivers/gpu/drm/xe/xe_guc.c                        |    8 +-
 drivers/gpu/drm/xe/xe_guc_ct.c                     |   41 +-
 drivers/gpu/drm/xe/xe_guc_ct.h                     |    1 +
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h       |    5 +
 drivers/gpu/drm/xe/xe_guc_submit.c                 |    4 +-
 drivers/gpu/drm/xe/xe_vm.c                         |   31 +-
 drivers/gpu/drm/xe/xe_vm_types.h                   |    3 +
 drivers/hid/hid-core.c                             |   12 +-
 drivers/hid/hid-logitech-hidpp.c                   |   23 +-
 drivers/hid/hid-steam.c                            |   33 +-
 drivers/hv/vmbus_drv.c                             |   29 +-
 drivers/hwmon/asus_rog_ryujin.c                    |  137 +--
 drivers/hwmon/lm90.c                               |   26 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   82 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   90 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |    2 +
 drivers/hwtracing/coresight/coresight-tmc-core.c   |    6 +-
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |   48 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c    |   60 +-
 drivers/hwtracing/coresight/coresight-tmc.h        |    2 +-
 drivers/i3c/master.c                               |   39 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |    1 +
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   27 +-
 drivers/i3c/master/mipi-i3c-hci/hci.h              |    1 +
 drivers/i3c/master/svc-i3c-master.c                |  108 +-
 drivers/infiniband/core/counters.c                 |    9 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   61 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.h           |    1 +
 drivers/infiniband/hw/bnxt_re/qplib_sp.h           |    1 +
 drivers/infiniband/hw/cxgb4/mem.c                  |   46 +-
 drivers/infiniband/hw/efa/efa_com.c                |   28 +-
 drivers/infiniband/hw/irdma/hw.c                   |    7 +-
 drivers/infiniband/hw/irdma/main.h                 |    3 +-
 drivers/infiniband/hw/irdma/utils.c                |   12 +-
 drivers/infiniband/hw/irdma/verbs.c                |   22 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   15 +-
 drivers/infiniband/hw/mlx5/main.c                  |   17 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    1 -
 drivers/infiniband/sw/rdmavt/vt.c                  |    4 +-
 drivers/infiniband/sw/rxe/rxe.h                    |   37 -
 drivers/infiniband/sw/rxe/rxe_loc.h                |    1 +
 drivers/infiniband/sw/rxe/rxe_mr.c                 |  287 +++--
 drivers/infiniband/sw/rxe/rxe_verbs.h              |   47 +-
 drivers/iommu/amd/init.c                           |   45 +-
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c     |   60 +-
 drivers/iommu/intel/iommu.c                        |   20 +-
 drivers/iommu/intel/iommu.h                        |    2 +-
 drivers/iommu/intel/pasid.c                        |    9 +-
 drivers/iommu/io-pgfault.c                         |   24 +-
 drivers/iommu/iommufd/fault.c                      |    2 +
 drivers/iommu/s390-iommu.c                         |   63 +-
 drivers/irqchip/exynos-combiner.c                  |   14 +-
 drivers/irqchip/irq-armada-370-xp.c                |   12 +-
 drivers/irqchip/irq-bcm7038-l1.c                   |   12 +-
 drivers/irqchip/irq-gic-v3-its.c                   |   12 +-
 drivers/irqchip/irq-i8259.c                        |   12 +-
 drivers/irqchip/irq-imx-gpcv2.c                    |   16 +-
 drivers/irqchip/irq-loongson-eiointc.c             |   12 +-
 drivers/irqchip/irq-loongson-htpic.c               |   10 +-
 drivers/irqchip/irq-loongson-htvec.c               |   12 +-
 drivers/irqchip/irq-loongson-pch-lpc.c             |   12 +-
 drivers/irqchip/irq-loongson-pch-pic.c             |   12 +-
 drivers/irqchip/irq-mchp-eic.c                     |   12 +-
 drivers/irqchip/irq-mst-intc.c                     |   12 +-
 drivers/irqchip/irq-mtk-cirq.c                     |   12 +-
 drivers/irqchip/irq-renesas-rzg2l.c                |   12 +-
 drivers/irqchip/irq-sa11x0.c                       |   12 +-
 drivers/irqchip/irq-sifive-plic.c                  |   12 +-
 drivers/irqchip/irq-sun6i-r.c                      |   18 +-
 drivers/irqchip/irq-tegra.c                        |   12 +-
 drivers/irqchip/irq-vic.c                          |   12 +-
 drivers/leds/leds-aw200xx.c                        |    2 +-
 drivers/leds/trigger/ledtrig-cpu.c                 |   14 +-
 drivers/macintosh/via-pmu.c                        |   12 +-
 drivers/md/dm-integrity.c                          |  156 ++-
 drivers/md/dm-table.c                              |   41 +-
 drivers/md/dm-verity-fec.c                         |  102 +-
 drivers/md/dm-zone.c                               |   34 +-
 drivers/md/dm.c                                    |    6 +
 drivers/md/dm.h                                    |    5 +
 drivers/md/md.c                                    |  111 +-
 drivers/md/md.h                                    |    5 +
 drivers/md/raid1.c                                 |   32 +-
 drivers/md/raid10.c                                |   51 +-
 .../platform/chips-media/wave5/wave5-helper.c      |   30 +-
 .../platform/chips-media/wave5/wave5-helper.h      |    1 +
 .../platform/chips-media/wave5/wave5-vpu-dec.c     |    5 +
 .../platform/chips-media/wave5/wave5-vpu-enc.c     |    5 +
 .../media/platform/chips-media/wave5/wave5-vpu.c   |   99 +-
 .../platform/chips-media/wave5/wave5-vpuapi.h      |    6 +
 .../st/stm32/stm32-dcmipp/dcmipp-bytecap.c         |   51 +-
 .../st/stm32/stm32-dcmipp/dcmipp-byteproc.c        |  100 +-
 .../st/stm32/stm32-dcmipp/dcmipp-parallel.c        |  108 +-
 drivers/media/platform/verisilicon/hantro.h        |    2 +
 drivers/media/platform/verisilicon/hantro_drv.c    |   42 +-
 drivers/media/platform/verisilicon/imx8m_vpu_hw.c  |    8 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   23 +
 drivers/mfd/intel-lpss.c                           |    2 +-
 drivers/mmc/host/vub300.c                          |   39 +-
 drivers/net/amt.c                                  |    5 +-
 drivers/net/bonding/bond_main.c                    |    2 +-
 drivers/net/ethernet/adi/adin1110.c                |    2 +-
 drivers/net/ethernet/airoha/airoha_eth.c           |   32 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   76 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   20 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |    8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |  173 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |  345 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h      |   25 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   27 -
 .../net/ethernet/cavium/liquidio/octeon_device.h   |    3 -
 .../net/ethernet/cavium/liquidio/octeon_mailbox.c  |   33 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |    4 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.h         |    1 -
 drivers/net/ethernet/ibm/emac/core.c               |   18 +-
 .../net/ethernet/intel/ice/devlink/devlink_port.c  |    2 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |    9 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |    8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    6 +-
 drivers/net/ethernet/intel/idpf/idpf_dev.c         |    2 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   15 +-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c      |    2 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   12 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h    |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   12 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   79 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   22 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   29 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   20 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   13 +
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   10 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |    5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   37 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   54 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   23 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    8 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   36 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    1 +
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   16 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   11 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   29 +-
 .../mlx5/core/steering/hws/mlx5hws_action.c        |  135 ++-
 .../mlx5/core/steering/hws/mlx5hws_action.h        |    6 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_cmd.c  |    2 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_cmd.h  |    2 +-
 .../mlx5/core/steering/hws/mlx5hws_context.c       |   30 +-
 .../mlx5/core/steering/hws/mlx5hws_context.h       |    4 +-
 .../mlx5/core/steering/hws/mlx5hws_debug.c         |   56 +-
 .../mlx5/core/steering/hws/mlx5hws_definer.h       |    2 +-
 .../mlx5/core/steering/hws/mlx5hws_internal.h      |    1 -
 .../mlx5/core/steering/hws/mlx5hws_matcher.c       |  237 ++---
 .../mlx5/core/steering/hws/mlx5hws_matcher.h       |    8 +-
 .../mlx5/core/steering/hws/mlx5hws_pat_arg.h       |    2 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_pool.c |  513 +++------
 .../mellanox/mlx5/core/steering/hws/mlx5hws_pool.h |   77 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_rule.c |   75 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_rule.h |    3 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_send.c |   16 +-
 .../mlx5/core/steering/hws/mlx5hws_table.c         |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/wc.c       |    4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |    2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |    7 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   91 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  253 +++--
 drivers/net/ethernet/ti/cpsw_new.c                 |    2 +-
 drivers/net/ethernet/ti/icssg/icssg_common.c       |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |    7 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   53 +-
 drivers/net/loopback.c                             |    2 +-
 drivers/net/net_failover.c                         |    2 +-
 drivers/net/netconsole.c                           |    2 +
 drivers/net/tap.c                                  |   33 +-
 drivers/net/team/team_core.c                       |   95 +-
 drivers/net/team/team_mode_loadbalance.c           |    4 +-
 drivers/net/virtio_net.c                           |   26 +-
 drivers/net/vrf.c                                  |    2 +-
 drivers/net/vxlan/vxlan_core.c                     |   36 +-
 drivers/net/wireguard/device.c                     |    8 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    8 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    7 +
 drivers/net/wireless/ath/ath12k/core.h             |    2 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  217 ++--
 drivers/net/wireless/ath/ath12k/dp_rx.c            |   62 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |    5 +-
 drivers/net/wireless/ath/ath12k/hal_rx.c           |   10 +-
 drivers/net/wireless/ath/ath12k/hal_rx.h           |   12 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   25 +-
 drivers/net/wireless/ath/ath12k/mhi.c              |    4 -
 drivers/net/wireless/ath/ath12k/wmi.c              |   19 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   16 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |    1 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    4 +
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   47 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   24 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    3 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   10 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   59 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   10 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    9 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   23 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    4 +
 drivers/net/wireless/mediatek/mt76/wed.c           |   10 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   41 +-
 drivers/ntb/ntb_transport.c                        |   18 +-
 drivers/nvme/target/admin-cmd.c                    |    8 +-
 drivers/nvme/target/core.c                         |   41 +-
 drivers/nvme/target/fabrics-cmd.c                  |    2 +-
 drivers/nvme/target/nvmet.h                        |    6 +
 drivers/nvme/target/tcp.c                          |    6 +-
 drivers/opp/core.c                                 |    5 +-
 drivers/pci/bus.c                                  |   23 +-
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |    5 +
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |    5 +
 drivers/pci/of.c                                   |   27 +
 drivers/pci/pci-driver.c                           |  198 ++--
 drivers/pci/pci.h                                  |   46 +-
 drivers/pci/pwrctl/core.c                          |    2 +
 drivers/pci/search.c                               |    8 +-
 drivers/perf/dwc_pcie_pmu.c                        |   81 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c           |    6 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   14 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |   33 +-
 drivers/platform/x86/amd/pmf/Kconfig               |    1 +
 drivers/platform/x86/amd/pmf/acpi.c                |   48 +-
 drivers/platform/x86/amd/pmf/core.c                |    5 +-
 drivers/platform/x86/amd/pmf/pmf.h                 |    7 +-
 drivers/platform/x86/amd/pmf/tee-if.c              |   64 +-
 drivers/platform/x86/asus-wmi.c                    |    6 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |    2 +-
 drivers/pmdomain/imx/imx93-blk-ctrl.c              |   60 +-
 drivers/power/reset/sc27xx-poweroff.c              |   10 +-
 drivers/ptp/ptp_ocp.c                              |    3 +-
 drivers/pwm/pwm-samsung.c                          |   22 +-
 drivers/remoteproc/Kconfig                         |   11 +-
 drivers/remoteproc/da8xx_remoteproc.c              |    2 +-
 drivers/remoteproc/imx_dsp_rproc.c                 |    2 +-
 drivers/remoteproc/imx_rproc.c                     |    2 +-
 drivers/remoteproc/keystone_remoteproc.c           |    2 +-
 drivers/remoteproc/meson_mx_ao_arc.c               |    2 +-
 drivers/remoteproc/mtk_scp.c                       |    2 +-
 drivers/remoteproc/pru_rproc.c                     |    2 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |    2 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 |    2 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |  639 ++++++-----
 drivers/remoteproc/qcom_q6v5_wcss.c                |    2 +-
 drivers/remoteproc/qcom_wcnss.c                    |   25 +-
 drivers/remoteproc/rcar_rproc.c                    |    2 +-
 drivers/remoteproc/remoteproc_virtio.c             |    2 +-
 drivers/remoteproc/st_remoteproc.c                 |    2 +-
 drivers/remoteproc/stm32_rproc.c                   |    2 +-
 drivers/remoteproc/ti_k3_dsp_remoteproc.c          |    2 +-
 drivers/remoteproc/wkup_m3_rproc.c                 |    2 +-
 drivers/s390/crypto/ap_bus.c                       |   74 ++
 drivers/s390/crypto/ap_bus.h                       |   30 +-
 drivers/s390/crypto/pkey_cca.c                     |   11 +-
 drivers/s390/crypto/zcrypt_api.c                   |  122 ++-
 drivers/s390/crypto/zcrypt_api.h                   |   11 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |   80 +-
 drivers/s390/crypto/zcrypt_ccamisc.h               |    6 +-
 drivers/s390/crypto/zcrypt_ep11misc.c              |   10 +-
 drivers/s390/crypto/zcrypt_msgtype50.c             |   36 +-
 drivers/s390/crypto/zcrypt_msgtype6.c              |  210 ++--
 drivers/s390/crypto/zcrypt_msgtype6.h              |   51 +-
 drivers/s390/net/ism_drv.c                         |   20 +-
 drivers/scsi/ch.c                                  |   30 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   12 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |    2 -
 drivers/scsi/qla2xxx/qla_os.c                      |   20 +-
 drivers/scsi/qla2xxx/qla_target.c                  |    5 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    1 +
 drivers/scsi/scsi_error.c                          |    6 +-
 drivers/scsi/sd.c                                  |  141 +--
 drivers/sh/clk/core.c                              |   10 +-
 drivers/sh/intc/core.c                             |   12 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   31 +-
 drivers/soc/bcm/brcmstb/biuctrl.c                  |   12 +-
 drivers/soc/tegra/pmc.c                            |  124 ++-
 drivers/soc/xilinx/zynqmp_power.c                  |   43 +-
 drivers/soundwire/generic_bandwidth_allocation.c   |   35 +-
 drivers/soundwire/intel_auxdevice.c                |   36 +-
 drivers/spi/spi-ch341.c                            |    7 +-
 drivers/spi/spi-microchip-core-qspi.c              |  100 +-
 drivers/spi/spi-mpc52xx.c                          |   26 +-
 drivers/staging/greybus/raw.c                      |   90 +-
 drivers/staging/most/Kconfig                       |    2 -
 drivers/staging/most/Makefile                      |    1 -
 drivers/staging/most/i2c/Kconfig                   |   13 -
 drivers/staging/most/i2c/Makefile                  |    4 -
 drivers/staging/most/i2c/i2c.c                     |  374 -------
 drivers/staging/rtl8723bs/core/rtw_mlme.c          |   14 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |   22 +-
 drivers/thermal/intel/intel_hfi.c                  |   12 +-
 drivers/thermal/thermal_hwmon.c                    |   89 +-
 drivers/tty/serial/8250/8250_core.c                |  253 ++---
 drivers/tty/serial/serial_core.c                   |  117 +-
 drivers/tty/tty_io.c                               |    2 +-
 drivers/ufs/core/ufs-mcq.c                         |   35 +-
 drivers/ufs/core/ufs-sysfs.c                       |    2 +
 drivers/ufs/core/ufshcd-priv.h                     |   14 +-
 drivers/ufs/core/ufshcd.c                          |   82 +-
 drivers/ufs/host/ufs-qcom.c                        |   71 +-
 drivers/usb/gadget/function/f_fs.c                 |   55 +-
 drivers/usb/gadget/function/f_hid.c                |    4 +-
 drivers/usb/gadget/function/f_uac1.c               |   13 +-
 drivers/usb/gadget/function/f_uac2.c               |   13 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |    2 +
 drivers/vdpa/mlx5/core/mr.c                        |    5 +-
 drivers/vdpa/mlx5/core/resources.c                 |   11 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    6 +-
 drivers/vdpa/vdpa.c                                |   48 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   10 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |   11 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |    4 +-
 drivers/vhost/iotlb.c                              |   47 +-
 drivers/vhost/net.c                                |    2 +
 drivers/vhost/vdpa.c                               |    9 +-
 drivers/vhost/vhost.c                              |   65 +-
 drivers/vhost/vhost.h                              |    1 +
 drivers/vhost/vsock.c                              |    2 +
 drivers/video/fbdev/core/fb_chrdev.c               |    6 +-
 drivers/video/fbdev/core/fbcon.c                   |    2 -
 drivers/video/fbdev/core/fbmem.c                   |   13 +
 drivers/video/fbdev/core/fbsysfs.c                 |    4 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c     |   11 +-
 drivers/video/fbdev/ps3fb.c                        |    5 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |    5 +-
 drivers/virt/acrn/irqfd.c                          |   75 +-
 drivers/virtio/virtio.c                            |   29 +
 drivers/virtio/virtio_ring.c                       |   19 +-
 drivers/watchdog/at91sam9_wdt.c                    |    4 +-
 drivers/xen/pvcalls-front.c                        |   88 +-
 drivers/xen/xen-acpi-processor.c                   |   12 +-
 fs/9p/vfs_addr.c                                   |    2 +-
 fs/afs/addr_list.c                                 |    8 +-
 fs/afs/file.c                                      |    6 +-
 fs/afs/fsclient.c                                  |    2 +-
 fs/afs/inode.c                                     |    1 +
 fs/afs/internal.h                                  |    4 +-
 fs/afs/rxrpc.c                                     |    4 +-
 fs/afs/super.c                                     |    2 +-
 fs/afs/yfsclient.c                                 |    2 +-
 fs/btrfs/acl.c                                     |    4 +
 fs/btrfs/bio.c                                     |    8 +-
 fs/btrfs/block-rsv.c                               |   19 +-
 fs/btrfs/defrag.c                                  |   50 +-
 fs/btrfs/delayed-ref.c                             |   35 +-
 fs/btrfs/disk-io.c                                 |   25 +-
 fs/btrfs/extent-tree.c                             |   35 +-
 fs/btrfs/extent-tree.h                             |    3 +-
 fs/btrfs/extent_io.c                               |   58 +-
 fs/btrfs/file.c                                    |  103 +-
 fs/btrfs/fs.h                                      |    9 +
 fs/btrfs/inode.c                                   |    3 +-
 fs/btrfs/lzo.c                                     |   13 +-
 fs/btrfs/qgroup.c                                  |   18 +-
 fs/btrfs/transaction.c                             |    9 +-
 fs/btrfs/tree-log.c                                |  142 +--
 fs/btrfs/volumes.c                                 |  241 +++--
 fs/btrfs/zstd.c                                    |   11 +-
 fs/ceph/addr.c                                     | 1115 +++++++++++++-------
 fs/ceph/mds_client.c                               |   65 +-
 fs/ceph/mds_client.h                               |    1 +
 fs/ceph/super.h                                    |    9 +
 fs/erofs/decompressor.c                            |   61 +-
 fs/erofs/internal.h                                |    6 +-
 fs/erofs/xattr.c                                   |    6 +-
 fs/erofs/zdata.c                                   |   18 +-
 fs/erofs/zmap.c                                    |    8 +-
 fs/ext2/inode.c                                    |    3 +-
 fs/ext2/xattr.c                                    |    4 +-
 fs/ext4/ext4.h                                     |    3 +-
 fs/ext4/inode.c                                    |   35 +-
 fs/ext4/xattr.c                                    |    2 +-
 fs/f2fs/checkpoint.c                               |   15 +-
 fs/f2fs/data.c                                     |   27 +-
 fs/f2fs/f2fs.h                                     |    3 +-
 fs/f2fs/gc.c                                       |    5 +-
 fs/f2fs/node.c                                     |   50 +-
 fs/f2fs/super.c                                    |   65 +-
 fs/fcntl.c                                         |    3 +
 fs/gfs2/ops_fstype.c                               |    2 +-
 fs/gfs2/super.c                                    |    4 +-
 fs/iomap/buffered-io.c                             |    8 +-
 fs/lockd/svc.c                                     |    4 +-
 fs/lockd/svc4proc.c                                |    4 +-
 fs/lockd/svcproc.c                                 |    4 +-
 fs/lockd/svcsubs.c                                 |   45 +-
 fs/namespace.c                                     |   40 +-
 fs/netfs/Makefile                                  |    1 +
 fs/netfs/buffered_read.c                           |  129 +--
 fs/netfs/direct_read.c                             |   16 +-
 fs/netfs/direct_write.c                            |   10 +-
 fs/netfs/internal.h                                |   11 +-
 fs/netfs/main.c                                    |    7 +
 fs/netfs/misc.c                                    |  110 +-
 fs/netfs/objects.c                                 |   35 +-
 fs/netfs/read_collect.c                            |   61 +-
 fs/netfs/read_pgpriv2.c                            |   32 +-
 fs/netfs/read_retry.c                              |    4 +-
 fs/netfs/rolling_buffer.c                          |  230 ++++
 fs/netfs/write_collect.c                           |   25 +-
 fs/netfs/write_issue.c                             |   32 +-
 fs/nfs/callback_xdr.c                              |    6 +-
 fs/nfs/delegation.c                                |   18 +-
 fs/nfs/flexfilelayout/flexfilelayout.c             |    3 +-
 fs/nfs/fscache.c                                   |    2 +-
 fs/nfs/fscache.h                                   |    2 +-
 fs/nfs/localio.c                                   |   15 +
 fs/nfs/nfs4session.c                               |   16 +-
 fs/nfsd/filecache.c                                |   75 +-
 fs/nfsd/lockd.c                                    |    6 +-
 fs/nfsd/netns.h                                    |   22 +-
 fs/nfsd/nfs4proc.c                                 |    2 +-
 fs/nfsd/nfs4recover.c                              |   12 +-
 fs/nfsd/nfs4state.c                                |   41 +-
 fs/nfsd/nfsctl.c                                   |    4 +-
 fs/nfsd/nfssvc.c                                   |   45 +-
 fs/ntfs3/bitmap.c                                  |   62 +-
 fs/ntfs3/frecord.c                                 |    1 -
 fs/ntfs3/fsntfs.c                                  |    2 +-
 fs/ntfs3/run.c                                     |   19 +-
 fs/ocfs2/cluster/heartbeat.c                       |  139 ++-
 fs/ocfs2/cluster/tcp.c                             |  105 +-
 fs/ocfs2/cluster/tcp.h                             |    1 +
 fs/ocfs2/inode.c                                   |  133 +++
 fs/ocfs2/xattr.c                                   |  215 ++++
 fs/ocfs2/xattr.h                                   |    2 +
 fs/overlayfs/file.c                                |   17 +-
 fs/smb/client/cifsacl.c                            |   28 +-
 fs/smb/client/cifsfs.c                             |    1 +
 fs/smb/client/cifsglob.h                           |    5 +-
 fs/smb/client/connect.c                            |    5 +
 fs/smb/client/file.c                               |   72 +-
 fs/smb/client/inode.c                              |   22 +-
 fs/smb/client/misc.c                               |   72 +-
 fs/smb/client/readdir.c                            |   17 +-
 fs/smb/client/smb2ops.c                            |   46 +-
 fs/smb/client/smb2pdu.c                            |    9 -
 fs/smb/client/smbdirect.c                          |   20 +-
 fs/smb/client/transport.c                          |   40 +-
 fs/smb/server/auth.c                               |   14 +-
 fs/smb/server/connection.c                         |   37 +-
 fs/smb/server/connection.h                         |    7 +-
 fs/smb/server/mgmt/tree_connect.c                  |   26 +-
 fs/smb/server/mgmt/user_config.c                   |   11 +
 fs/smb/server/mgmt/user_session.c                  |    8 +-
 fs/smb/server/oplock.c                             |   81 +-
 fs/smb/server/oplock.h                             |    1 +
 fs/smb/server/smb2pdu.c                            |  117 +-
 fs/smb/server/smbacl.c                             |   88 +-
 fs/smb/server/smbacl.h                             |    2 +-
 fs/smb/server/transport_rdma.c                     |    4 +-
 fs/smb/server/vfs.c                                |    2 +
 fs/smb/server/vfs_cache.c                          |    8 +-
 fs/sysfs/group.c                                   |   26 +-
 fs/tracefs/event_inode.c                           |   24 +
 fs/tracefs/internal.h                              |    4 +-
 fs/xfs/libxfs/xfs_alloc.c                          |   41 +-
 fs/xfs/libxfs/xfs_da_btree.c                       |   53 +-
 fs/xfs/libxfs/xfs_da_btree.h                       |    2 +
 fs/xfs/libxfs/xfs_exchmaps.c                       |  103 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |   31 +-
 fs/xfs/libxfs/xfs_log_format.h                     |    4 +-
 fs/xfs/xfs_attr_inactive.c                         |  104 +-
 fs/xfs/xfs_bmap_util.c                             |   15 +-
 fs/xfs/xfs_buf.c                                   |   65 +-
 fs/xfs/xfs_buf.h                                   |    1 -
 fs/xfs/xfs_buf_item.c                              |  297 ++++--
 fs/xfs/xfs_buf_item.h                              |    3 +-
 fs/xfs/xfs_dquot.c                                 |    4 +-
 fs/xfs/xfs_exchrange.c                             |   51 +-
 fs/xfs/xfs_icache.c                                |    8 +
 fs/xfs/xfs_inode.c                                 |    2 +-
 fs/xfs/xfs_qm.c                                    |   87 +-
 fs/xfs/xfs_trace.h                                 |    2 -
 include/acpi/acpi_bus.h                            |    6 +
 include/clocksource/samsung_pwm.h                  |    2 +-
 include/drm/gpu_scheduler.h                        |   36 +-
 include/linux/arm_ffa.h                            |   24 +-
 include/linux/bpf.h                                |   10 +-
 include/linux/bpf_mprog.h                          |   10 +
 include/linux/bpf_verifier.h                       |    2 +
 include/linux/cgroup.h                             |    1 +
 include/linux/device.h                             |   14 +
 include/linux/dma/k3-udma-glue.h                   |    3 +-
 include/linux/fb.h                                 |    2 +
 include/linux/folio_queue.h                        |   12 +-
 include/linux/gpio.h                               |    4 +-
 include/linux/gpio/consumer.h                      |   22 +-
 include/linux/gpio/driver.h                        |   10 +
 include/linux/gpu_buddy.h                          |    9 -
 include/linux/hid.h                                |    4 +
 include/linux/hugetlb.h                            |    6 +
 include/linux/i3c/master.h                         |    3 +
 include/linux/ieee80211.h                          |   12 +-
 include/linux/if_team.h                            |    3 +-
 include/linux/io_uring_types.h                     |    8 +
 include/linux/iommu.h                              |    5 +
 include/linux/irq_work.h                           |    9 +-
 include/linux/irq_work_types.h                     |   14 +
 include/linux/kasan.h                              |    6 +-
 include/linux/kvm_host.h                           |    8 +
 include/linux/lockd/bind.h                         |   12 +-
 include/linux/mlx5/cq.h                            |    2 +-
 include/linux/mlx5/driver.h                        |    3 +-
 include/linux/mm_inline.h                          |   15 +-
 include/linux/mmzone.h                             |    2 +
 include/linux/mount.h                              |    3 +-
 include/linux/net.h                                |   23 +
 include/linux/netdevice.h                          |   13 +-
 include/linux/netfilter.h                          |    2 +
 include/linux/netfilter/x_tables.h                 |    1 +
 include/linux/netfs.h                              |   22 +-
 include/linux/ntb.h                                |   24 +
 include/linux/overflow.h                           |   70 ++
 include/linux/page-flags.h                         |    2 +-
 include/linux/pci.h                                |    1 +
 include/linux/pm.h                                 |    2 +
 include/linux/pm_runtime.h                         |   21 +-
 include/linux/psi.h                                |    4 +-
 include/linux/rcupdate.h                           |   14 +
 include/linux/rcuwait.h                            |   13 +-
 include/linux/refcount.h                           |  106 ++
 include/linux/ring_buffer.h                        |    5 +-
 include/linux/rolling_buffer.h                     |   61 ++
 include/linux/skmsg.h                              |   14 -
 include/linux/slab.h                               |    9 +
 include/linux/soc/mediatek/mtk_wed.h               |    1 +
 include/linux/srcutiny.h                           |    4 +
 include/linux/stddef.h                             |   20 +
 include/linux/sunrpc/svc_rdma.h                    |   14 +-
 include/linux/syscore_ops.h                        |   17 +-
 include/linux/types.h                              |   12 +
 include/linux/vdpa.h                               |    4 -
 include/media/v4l2-mem2mem.h                       |   21 +
 include/net/act_api.h                              |    2 +-
 include/net/ax25.h                                 |    1 -
 include/net/bluetooth/hci_core.h                   |    2 +
 include/net/bluetooth/rfcomm.h                     |    1 +
 include/net/cfg80211.h                             |  103 +-
 include/net/dropreason-core.h                      |   21 +
 include/net/ip_vs.h                                |    2 +-
 include/net/net_namespace.h                        |    2 +
 include/net/netfilter/nf_conntrack_expect.h        |   16 +-
 include/net/netfilter/nf_tables.h                  |   32 +-
 include/net/netns/mpls.h                           |    2 +
 include/net/pkt_cls.h                              |   14 +-
 include/net/sch_generic.h                          |   28 +-
 include/net/sctp/auth.h                            |    3 +
 include/net/tcp.h                                  |   15 +-
 include/net/xdp_sock.h                             |    1 +
 include/net/xdp_sock_drv.h                         |    6 +-
 include/net/xsk_buff_pool.h                        |    9 +-
 include/scsi/scsi_host.h                           |    7 +-
 include/trace/events/netfs.h                       |  173 +--
 include/trace/events/rv.h                          |   84 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |    1 +
 include/ufs/ufshcd.h                               |    7 +-
 io_uring/eventfd.c                                 |    6 +-
 io_uring/eventfd.h                                 |    2 +-
 io_uring/futex.c                                   |    4 +-
 io_uring/io_uring.c                                |    2 +-
 io_uring/napi.c                                    |   72 +-
 io_uring/napi.h                                    |    6 +-
 io_uring/poll.c                                    |   23 +-
 io_uring/rw.c                                      |   16 +-
 io_uring/waitid.c                                  |    2 +-
 kernel/bpf/bpf_struct_ops.c                        |   12 +
 kernel/bpf/btf.c                                   |   30 +-
 kernel/bpf/helpers.c                               |   15 +-
 kernel/bpf/mmap_unlock_work.h                      |   51 +-
 kernel/bpf/queue_stack_maps.c                      |    8 +-
 kernel/bpf/stackmap.c                              |  153 ++-
 kernel/bpf/syscall.c                               |   11 +-
 kernel/bpf/task_iter.c                             |   14 +-
 kernel/bpf/trampoline.c                            |    7 +
 kernel/bpf/verifier.c                              |  481 ++++++---
 kernel/cgroup/cgroup.c                             |   47 +-
 kernel/cgroup/rstat.c                              |   19 +-
 kernel/cpu_pm.c                                    |   12 +-
 kernel/irq/debugfs.c                               |    2 +-
 kernel/irq/generic-chip.c                          |   14 +-
 kernel/irq/pm.c                                    |   11 +-
 kernel/irq/proc.c                                  |   72 +-
 kernel/printk/nbcon.c                              |    2 +-
 kernel/printk/printk.c                             |   13 +-
 kernel/rcu/srcutiny.c                              |   19 +-
 kernel/sched/ext.c                                 |   40 +-
 kernel/sched/psi.c                                 |   69 +-
 kernel/sched/syscalls.c                            |   17 +
 kernel/time/namespace.c                            |    5 +
 kernel/time/sched_clock.c                          |   22 +-
 kernel/time/timekeeping.c                          |   22 +-
 kernel/trace/ring_buffer.c                         |  139 ++-
 kernel/trace/ring_buffer_benchmark.c               |    6 +-
 kernel/trace/trace.c                               |  110 +-
 kernel/trace/trace_probe.c                         |    2 +-
 lib/kunit_iov_iter.c                               |    4 +-
 mm/huge_memory.c                                   |    3 +
 mm/hugetlb.c                                       |    9 +-
 mm/hugetlb_vmemmap.c                               |  232 ++--
 mm/kasan/shadow.c                                  |  111 +-
 mm/memcontrol.c                                    |    2 +-
 mm/mm_init.c                                       |    2 +
 mm/mremap.c                                        |   68 +-
 mm/page_owner.c                                    |   10 +-
 mm/page_table_check.c                              |   20 +-
 mm/vma.c                                           |   39 +-
 mm/vma.h                                           |   14 +-
 mm/vmalloc.c                                       |    8 +-
 mm/vmscan.c                                        |   47 +-
 net/ax25/af_ax25.c                                 |   30 +-
 net/ax25/ax25_route.c                              |   74 --
 net/batman-adv/soft-interface.c                    |    2 +-
 net/bluetooth/6lowpan.c                            |   27 +-
 net/bluetooth/hci_conn.c                           |    2 +
 net/bluetooth/hci_core.c                           |    4 +
 net/bluetooth/hci_event.c                          |   93 +-
 net/bluetooth/hci_sync.c                           |  145 ++-
 net/bluetooth/hci_sysfs.c                          |   17 +-
 net/bluetooth/iso.c                                |   46 +-
 net/bluetooth/l2cap_core.c                         |   23 +-
 net/bluetooth/l2cap_sock.c                         |  116 +-
 net/bluetooth/rfcomm/core.c                        |  134 ++-
 net/bridge/br_arp_nd_proxy.c                       |   24 +-
 net/bridge/br_device.c                             |    2 +-
 net/bridge/netfilter/ebtable_broute.c              |    2 +-
 net/bridge/netfilter/ebtable_filter.c              |    2 +-
 net/bridge/netfilter/ebtable_nat.c                 |    2 +-
 net/bridge/netfilter/ebtables.c                    |   71 +-
 net/ceph/auth_x.c                                  |    5 +
 net/core/bpf_sk_storage.c                          |   17 +-
 net/core/dev.c                                     |  190 +++-
 net/core/filter.c                                  |    4 +-
 net/core/net_namespace.c                           |  175 +--
 net/core/rtnetlink.c                               |    2 +-
 net/core/sock.c                                    |    3 +
 net/ethtool/module.c                               |    3 +-
 net/ethtool/rss.c                                  |    4 +-
 net/handshake/handshake-test.c                     |    8 +
 net/handshake/netlink.c                            |    6 +-
 net/handshake/request.c                            |   18 +
 net/hsr/hsr_device.c                               |    2 +-
 net/ieee802154/6lowpan/core.c                      |    2 +-
 net/ieee802154/core.c                              |   14 +-
 net/ife/ife.c                                      |   14 +-
 net/ipv4/igmp.c                                    |   14 +-
 net/ipv4/ip_tunnel.c                               |    2 +-
 net/ipv4/ipmr.c                                    |    2 +-
 net/ipv4/netfilter/arp_tables.c                    |   35 +-
 net/ipv4/netfilter/ip_tables.c                     |   41 +-
 net/ipv4/netfilter/iptable_nat.c                   |    4 +-
 net/ipv4/tcp.c                                     |    5 +-
 net/ipv4/tcp_bpf.c                                 |   17 +-
 net/ipv4/tcp_input.c                               |   15 +-
 net/ipv4/tcp_ipv4.c                                |    3 +-
 net/ipv4/udp_bpf.c                                 |    9 +
 net/ipv6/ioam6.c                                   |   33 +-
 net/ipv6/ip6_gre.c                                 |    9 +-
 net/ipv6/ip6_tunnel.c                              |    2 +-
 net/ipv6/ip6_vti.c                                 |    2 +-
 net/ipv6/ip6mr.c                                   |    5 +-
 net/ipv6/mcast.c                                   |   20 +-
 net/ipv6/netfilter/ip6_tables.c                    |   38 +-
 net/ipv6/netfilter/ip6table_nat.c                  |    4 +-
 net/ipv6/sit.c                                     |    2 +-
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/mac80211/debug.h                               |   10 +-
 net/mac80211/mlme.c                                |   35 +-
 net/mac80211/rx.c                                  |   50 +-
 net/mac80211/sta_info.c                            |   79 +-
 net/mac80211/util.c                                |    3 +
 net/mpls/af_mpls.c                                 |  232 ++--
 net/mpls/internal.h                                |   16 +-
 net/mpls/mpls_iptunnel.c                           |    2 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   11 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |    3 +-
 net/netfilter/nf_conntrack_bpf.c                   |  111 +-
 net/netfilter/nf_conntrack_core.c                  |   33 +-
 net/netfilter/nf_conntrack_expect.c                |  148 ++-
 net/netfilter/nf_conntrack_h323_main.c             |    4 +-
 net/netfilter/nf_conntrack_helper.c                |   10 +-
 net/netfilter/nf_conntrack_netlink.c               |   24 +-
 net/netfilter/nf_conntrack_sip.c                   |   13 +-
 net/netfilter/nf_flow_table_ip.c                   |    3 +
 net/netfilter/nf_nat_core.c                        |   10 +-
 net/netfilter/nf_tables_api.c                      |  317 ++++--
 net/netfilter/nft_bitwise.c                        |   15 +-
 net/netfilter/nft_byteorder.c                      |   13 +-
 net/netfilter/nft_ct.c                             |    3 +-
 net/netfilter/nft_dynset.c                         |   25 +-
 net/netfilter/nft_flow_offload.c                   |    3 +-
 net/netfilter/nft_set_pipapo.c                     |   11 +-
 net/netfilter/x_tables.c                           |   77 +-
 net/openvswitch/vport-internal_dev.c               |    2 +-
 net/phonet/socket.c                                |   10 +-
 net/qrtr/mhi.c                                     |   69 +-
 net/rxrpc/af_rxrpc.c                               |   25 +-
 net/rxrpc/key.c                                    |    2 +
 net/rxrpc/peer_object.c                            |   22 +-
 net/rxrpc/proc.c                                   |   32 +-
 net/rxrpc/recvmsg.c                                |   12 +-
 net/rxrpc/sendmsg.c                                |    7 +-
 net/rxrpc/server_key.c                             |    2 +
 net/sched/act_api.c                                |    2 +-
 net/sched/act_bpf.c                                |    2 +-
 net/sched/act_ife.c                                |   40 +-
 net/sched/act_mpls.c                               |    2 +-
 net/sched/act_police.c                             |    2 +-
 net/sched/act_skbedit.c                            |    2 +-
 net/sched/cls_api.c                                |    6 +-
 net/sched/cls_basic.c                              |    6 +-
 net/sched/cls_bpf.c                                |    6 +-
 net/sched/cls_cgroup.c                             |    2 +-
 net/sched/cls_flow.c                               |    2 +-
 net/sched/cls_flower.c                             |    4 +-
 net/sched/cls_fw.c                                 |    4 +-
 net/sched/cls_matchall.c                           |    4 +-
 net/sched/cls_route.c                              |    4 +-
 net/sched/cls_u32.c                                |   18 +-
 net/sched/sch_cake.c                               |    4 +-
 net/sched/sch_codel.c                              |   12 +-
 net/sched/sch_drr.c                                |    2 +-
 net/sched/sch_ets.c                                |    2 +-
 net/sched/sch_fq.c                                 |   26 +-
 net/sched/sch_fq_codel.c                           |   16 +-
 net/sched/sch_fq_pie.c                             |   14 +-
 net/sched/sch_generic.c                            |   45 +-
 net/sched/sch_gred.c                               |    2 +-
 net/sched/sch_hfsc.c                               |    2 +-
 net/sched/sch_hhf.c                                |   12 +-
 net/sched/sch_htb.c                                |    2 +-
 net/sched/sch_multiq.c                             |    2 +-
 net/sched/sch_pie.c                                |   12 +-
 net/sched/sch_prio.c                               |    2 +-
 net/sched/sch_qfq.c                                |    2 +-
 net/sched/sch_sfb.c                                |    2 +-
 net/sched/sch_sfq.c                                |    2 +-
 net/sctp/auth.c                                    |   76 ++
 net/sctp/bind_addr.c                               |   11 +-
 net/sctp/protocol.c                                |    3 +-
 net/sctp/sm_make_chunk.c                           |   20 +-
 net/sctp/sm_statefuns.c                            |   36 +-
 net/smc/af_smc.c                                   |   90 +-
 net/smc/smc_loopback.c                             |   45 +-
 net/sunrpc/auth_gss/gss_krb5_unseal.c              |    3 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   17 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |  100 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |   16 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   30 +-
 net/tipc/core.c                                    |    4 +-
 net/tipc/udp_media.c                               |   75 +-
 net/tls/tls_sw.c                                   |    2 +
 net/wireless/core.c                                |   20 +-
 net/wireless/core.h                                |    2 +-
 net/wireless/nl80211.c                             |   16 +-
 net/wireless/scan.c                                |   15 +-
 net/wireless/sme.c                                 |    6 +-
 net/xdp/xsk.c                                      |  253 ++++-
 net/xdp/xsk_buff_pool.c                            |   14 +-
 net/xdp/xsk_queue.h                                |   65 +-
 net/xfrm/xfrm_device.c                             |    8 +
 security/apparmor/domain.c                         |  105 +-
 security/apparmor/include/policy.h                 |    3 +
 security/apparmor/policy.c                         |   22 +-
 security/selinux/selinuxfs.c                       |   27 +-
 sound/core/seq/oss/seq_oss_event.c                 |    6 +-
 sound/core/seq/oss/seq_oss_event.h                 |    3 +-
 sound/core/seq/oss/seq_oss_ioctl.c                 |    5 +-
 sound/core/seq/oss/seq_oss_midi.c                  |    6 +-
 sound/core/seq/oss/seq_oss_midi.h                  |    2 +-
 sound/core/seq/oss/seq_oss_readq.c                 |   85 +-
 sound/core/seq/oss/seq_oss_rw.c                    |    5 +-
 sound/core/seq/seq_clientmgr.c                     |    3 +-
 sound/core/seq/seq_fifo.c                          |   67 +-
 sound/core/seq/seq_fifo.h                          |    1 +
 sound/drivers/mtpav.c                              |    6 +-
 sound/soc/amd/acp/acp-mach-common.c                |   18 +-
 sound/soc/intel/avs/avs.h                          |    2 +-
 sound/soc/intel/avs/path.c                         |   11 +-
 sound/soc/intel/avs/pcm.c                          |   23 +-
 sound/soc/intel/avs/probes.c                       |    2 +-
 sound/soc/intel/avs/topology.c                     |   47 +-
 sound/soc/intel/avs/topology.h                     |    4 +-
 sound/soc/qcom/qdsp6/q6asm.c                       |    5 +
 sound/soc/sof/ipc3-pcm.c                           |   13 +-
 sound/soc/sof/ipc3-topology.c                      |   20 +-
 sound/soc/sof/ipc4-pcm.c                           |   41 +-
 sound/soc/sof/ipc4-topology.c                      |   18 +-
 sound/soc/sof/pcm.c                                |  169 ++-
 sound/soc/sof/sof-audio.c                          |   49 -
 sound/soc/sof/sof-audio.h                          |   17 +-
 sound/usb/pcm.c                                    |    2 +-
 .../testing/selftests/bpf/progs/exceptions_fail.c  |    9 +-
 .../bpf/progs/verifier_subprog_precision.c         |   12 +-
 tools/testing/selftests/net/forwarding/README      |    2 +-
 tools/testing/selftests/net/tls.c                  |  515 +++++++++
 tools/testing/vma/vma.c                            |    4 +-
 virt/kvm/guest_memfd.c                             |    8 +-
 virt/kvm/kvm_main.c                                |   36 +-
 virt/kvm/kvm_mm.h                                  |    7 +-
 1175 files changed, 21427 insertions(+), 13010 deletions(-)


