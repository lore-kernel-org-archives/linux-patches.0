Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21701C9DDF;
	Tue,  8 Oct 2024 13:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393016; cv=none; b=Ght1SBNyhNDVIZTOn21sE6mCSDFMu3Ri/sMRPx8VWyPn0CXFwwqd1/j7TSXfIFwqY8CdB3UB86ylZRf3si2dYrWib0OaIRhibySNi6JU7iKtg5mrj9cKCmtaAhev5bx+4Qya2hISCIJYBHIMUkOWxIkBOF8FMW+5fNrYBklIYsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393016; c=relaxed/simple;
	bh=L22Sqr3HYhTB2PiLWtVECLtrnRGBwfzKGlktHYh9S/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IkAQFBRyIck5MZrEpxznjnNeptuJoGdTcEywwIrkJy9jzNOdosy2r9SIzXXjKse//bhmhqcP6OHWHnznIe6JSoGopaTARFeHyGrn866khvhx9kHBSbd4GB6bj6VIY+WajE+onaK2hWybP2CRmvtbIDWGj9TSFpTHm9DCOxSwWLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy2kRbrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy2kRbrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23803C4CEC7;
	Tue,  8 Oct 2024 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393016;
	bh=L22Sqr3HYhTB2PiLWtVECLtrnRGBwfzKGlktHYh9S/E=;
	h=From:To:Cc:Subject:Date:From;
	b=fy2kRbrP+UXECX6/dXEh6hv39DeW9I+DAjSohY87KVcNRdN6l6lWmPNFDI0uco+Xq
	 tZmc1DgohyNKzjUIGeTUYuRSqR4r/Q5m+eJtgCGHIDoAekQa+2TDIrXgZ+yXfCHOor
	 Im4k566Z6BNE6zUZeFLdQZGcbiw+Mf5Q/sYTNZNc=
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
Subject: [PATCH 6.6 000/386] 6.6.55-rc1 review
Date: Tue,  8 Oct 2024 14:04:05 +0200
Message-ID: <20241008115629.309157387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.55-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.55-rc1
X-KernelTest-Deadline: 2024-10-10T11:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.55 release.
There are 386 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.55-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.55-rc1

Zhihao Cheng <chengzhihao1@huawei.com>
    Revert "ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path"

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Fix return value of nullb_device_power_store()

Alex Hung <alex.hung@amd.com>
    drm/amd/display: enable_hpo_dp_link_output: Check link_res->hpo_dp_link_enc before using it

Namhyung Kim <namhyung@kernel.org>
    perf report: Fix segfault when 'sym' sort key is not used

Gabe Teeger <Gabe.Teeger@amd.com>
    drm/amd/display: Revert Avoid overflow assignment

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: octeontx* - Select CRYPTO_AUTHENC

Haoran Zhang <wh1sper@zju.edu.cn>
    vhost/scsi: null-ptr-dereference in vhost_scsi_get_req()

David Howells <dhowells@redhat.com>
    rxrpc: Fix a race between socket set up and I/O thread creation

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: move the EST lock to struct stmmac_priv

Yu Kuai <yukuai3@huawei.com>
    null_blk: fix null-ptr-dereference while configuring 'power' and 'submit_queues'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    null_blk: Remove usage of the deprecated ida_simple_xx() API

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: think-lmi: Fix password opcode ordering for workstations

Chen Yu <yu.c.chen@intel.com>
    efi/unaccepted: touch soft lockup during memory accept

Mads Bligaard Nielsen <bli@bang-olufsen.dk>
    drm/bridge: adv7511: fix crash on irq during probe

Nicolin Chen <nicolinc@nvidia.com>
    iommufd: Fix protection fault in iommufd_test_syz_conv_iova

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix netdev_priv() dereference before check on non-DSA netdevice events

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: restore set elements when delete set fails

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix memleak in map from abort path

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path

Jonathan Gray <jsg@jsg.id.au>
    Revert "drm/amd/display: Skip Recompute DSC Params if no Stream on Link"

Val Packett <val@packett.cool>
    drm/rockchip: vop: enable VOP_FEATURE_INTERNAL_RGB on RK3066

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop the backref cache during relocation if we commit

David Sterba <dsterba@suse.com>
    btrfs: relocation: constify parameters where possible

David Sterba <dsterba@suse.com>
    btrfs: relocation: return bool from btrfs_should_ignore_reloc_root

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Fix possible crash when unregistering a battery hook

Armin Wolf <W_Armin@gmx.de>
    ACPI: battery: Simplify battery hook locking

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-sc8180x: Add GPLL9 support

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: add tally counter fields added with RTL8125

Colin Ian King <colin.i.king@gmail.com>
    r8169: Fix spelling mistake: "tx_underun" -> "tx_underrun"

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: pressure: bmp280: Fix waiting time for BMP3xx configuration

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: pressure: bmp280: Fix regmap for BMP280 device

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: pressure: bmp280: Use BME prefix for BME280 specifics

Vasileios Amoiridis <vassilisamir@gmail.com>
    iio: pressure: bmp280: Improve indentation and line wrapping

Angel Iglesias <ang.iglesiasg@gmail.com>
    iio: pressure: bmp280: Allow multiple chips id per family of devices

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    dt-bindings: clock: qcom: Add GPLL9 support on gcc-sc8180x

Manivannan Sadhasivam <mani@kernel.org>
    dt-bindings: clock: qcom: Add missing UFS QREF clocks

Udit Kumar <u-kumar1@ti.com>
    remoteproc: k3-r5: Delay notification of wakeup event

Beleswar Padhi <b-padhi@ti.com>
    remoteproc: k3-r5: Acquire mailbox handle during probe routine

Umang Jain <umang.jain@ideasonboard.com>
    media: imx335: Fix reset-gpio handling

Kieran Bingham <kieran.bingham@ideasonboard.com>
    media: i2c: imx335: Enable regulator supplies

Long Li <longli@microsoft.com>
    RDMA/mana_ib: use the correct page table index based on hardware page size

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Add support for page sizes other than 4KB on ARM64

Haiyang Zhang <haiyangz@microsoft.com>
    net: mana: Enable MANA driver on ARM64 with 4K page size

Johannes Weiner <hannes@cmpxchg.org>
    sched: psi: fix bogus pressure spikes from aggregation race

Andrii Nakryiko <andrii@kernel.org>
    lib/buildid: harden build ID parsing logic

Alexey Dobriyan <adobriyan@gmail.com>
    build-id: require program headers to be right after ELF header

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Allow backlight to go below `AMDGPU_DM_DEFAULT_MIN_BACKLIGHT`

Yosry Ahmed <yosryahmed@google.com>
    mm: z3fold: deprecate CONFIG_Z3FOLD

Oleg Nesterov <oleg@redhat.com>
    uprobes: fix kernel info leak via "[uprobes]" vma

Jens Axboe <axboe@kernel.dk>
    io_uring/net: harden multishot termination case for recv

Mark Rutland <mark.rutland@arm.com>
    arm64: errata: Expand speculative SSBS workaround once more

Mark Rutland <mark.rutland@arm.com>
    arm64: cputype: Add Neoverse-N3 definitions

Ard Biesheuvel <ardb@kernel.org>
    i2c: synquacer: Deal with optional PCLK correctly

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: synquacer: Remove a clk reference from struct synquacer_i2c

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: core: Lock address during client device instantiation

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: create debugfs entry per adapter

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Fix use after free on platform_device_register() errors

Hans de Goede <hdegoede@redhat.com>
    platform/x86: x86-android-tablets: Create a platform_device from module_init()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: qconf: fix buffer overflow in debug links

Uwe Kleine-König <ukleinek@debian.org>
    cpufreq: intel_pstate: Make hwp_notify_lock a raw spinlock

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix system hang while resume with TBT monitor

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Add HDR workaround for specific eDP

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Add locking to drm_sched_entity_modify_sched

Jani Nikula <jani.nikula@intel.com>
    drm/i915/gem: fix bitwise and logical AND mixup

Al Viro <viro@zeniv.linux.org.uk>
    close_range(): fix the logics in descriptor table trimming

Eder Zulian <ezulian@redhat.com>
    rtla: Fix the help text in osnoise and timerlat top tools

Wei Li <liwei391@huawei.com>
    tracing/timerlat: Fix duplicated kthread creation due to CPU online/offline

Wei Li <liwei391@huawei.com>
    tracing/timerlat: Fix a race during cpuhp processing

Wei Li <liwei391@huawei.com>
    tracing/timerlat: Drop interface_lock in stop_kthread()

Wei Li <liwei391@huawei.com>
    tracing/hwlat: Fix a race during cpuhp processing

Patrick Donnelly <pdonnell@redhat.com>
    ceph: fix cap ref leak via netfs init_request

Jiawei Ye <jiawei.ye@foxmail.com>
    mac802154: Fix potential RCU dereference issue in mac802154_scan_worker

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE

Jiawen Wu <jiawenwu@trustnetic.com>
    net: pcs: xpcs: fix the wrong register that was written back

Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
    gpio: davinci: fix lazy disable

Miquel Sabaté Solà <mikisabate@gmail.com>
    cpufreq: Avoid a bad reference count on CPU node

Filipe Manana <fdmanana@suse.com>
    btrfs: wait for fixup workers before stopping cleaner kthread during umount

Filipe Manana <fdmanana@suse.com>
    btrfs: send: fix invalid clone operation for file that got its size decreased

Qu Wenruo <wqu@suse.com>
    btrfs: fix a NULL pointer dereference when failed to start a new trasacntion

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus ExpertBook B2502CVA to irq1_level_low_skip_override[]

Hans de Goede <hdegoede@redhat.com>
    ACPI: resource: Add Asus Vivobook X1704VAP to irq1_level_low_skip_override[]

Baokun Li <libaokun1@huawei.com>
    cachefiles: fix dentry leak in cachefiles_open_file()

Nuno Sa <nuno.sa@analog.com>
    Input: adp5589-keys - fix adp5589_gpio_get_value()

Nuno Sa <nuno.sa@analog.com>
    Input: adp5589-keys - fix NULL pointer dereference

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rtc: at91sam9: fix OF node leak in probe() error path

KhaiWenTan <khai.wen.tan@linux.intel.com>
    net: stmmac: Fix zero-division error when disabling tc cbs

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: fallback to realpath if symlink's pathname does not exist

Willem de Bruijn <willemb@google.com>
    gso: fix udp gso fraglist segmentation after pull from frag_list

Willem de Bruijn <willemb@google.com>
    vrf: revert "vrf: Remove unnecessary RCU-bh critical section"

Barnabás Czémán <barnabas.czeman@mainlining.org>
    iio: magnetometer: ak8975: Fix reading for ak099xx sensors

Steve French <stfrench@microsoft.com>
    smb3: fix incorrect mode displayed for read-only files

wangrong <wangrong@uniontech.com>
    smb: client: use actual path when queryfs

Ajit Pandey <quic_ajipan@quicinc.com>
    clk: qcom: clk-alpha-pll: Fix CAL_L_VAL override for LUCID EVO PLL

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-sc8180x: Fix the sdcc2 and sdcc4 clocks freq table

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Fix ordering of pm_runtime_enable

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: qcom: camss: Remove use_count guard in stop_streaming

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8250: Do not turn off PCIe GDSCs during gdsc_disable()

Zheng Wang <zyytlz.wz@163.com>
    media: venus: fix use after free bug in venus_remove due to race condition

Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
    clk: qcom: gcc-sm8150: De-register gcc_cpuss_ahb_clk_src

David Virag <virag.david003@gmail.com>
    clk: samsung: exynos7885: Update CLKS_NR_FSYS after bindings fix

Mike Tipton <quic_mdtipton@quicinc.com>
    clk: qcom: clk-rpmh: Fix overflow in BCM vote

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8450: Do not turn off PCIe GDSCs during gdsc_disable()

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: sun4i_csi: Implement link validate for sun4i_csi subdev

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks

Jan Kiszka <jan.kiszka@siemens.com>
    remoteproc: k3-r5: Fix error handling when power-up failed

Sebastian Reichel <sebastian.reichel@collabora.com>
    clk: rockchip: fix error for unknown clocks

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    media: ov5675: Fix power on/off delay timings

Chun-Yi Lee <joeyli.kernel@gmail.com>
    aoe: fix the potential use-after-free problem in more places

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Fix kernel stack size when KASAN is enabled

Long Li <longli@microsoft.com>
    RDMA/mana_ib: use the correct page size for mapping user-mode doorbell page

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    i3c: master: svc: Fix use after free vulnerability in svc_i3c_master Driver Due to Race Condition

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix NFSv4's PUTPUBFH operation

Li Lingfeng <lilingfeng3@huawei.com>
    nfsd: map the EBADMSG to nfserr_io to avoid warning

NeilBrown <neilb@suse.de>
    nfsd: fix delegation_blocked() to block correctly for at least 30 seconds

Matt Fleming <matt@readmodwrite.com>
    perf hist: Update hist symbol when updating maps

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Disable -Wno-cast-function-type-mismatch if present on clang

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix memory leak in exfat_load_bitmap()

Jisheng Zhang <jszhang@kernel.org>
    riscv: define ILLEGAL_POINTER_VALUE for 64bit

Easwar Hariharan <eahariha@linux.microsoft.com>
    arm64: Subscribe Microsoft Azure Cobalt 100 to erratum 3194386

Mark Rutland <mark.rutland@arm.com>
    arm64: fix selection of HAVE_DYNAMIC_FTRACE_WITH_ARGS

Lizhi Xu <lizhi.xu@windriver.com>
    ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate

Julian Sun <sunjunchao2870@gmail.com>
    ocfs2: fix null-ptr-deref when journal load failed.

Lizhi Xu <lizhi.xu@windriver.com>
    ocfs2: remove unreasonable unlock in ocfs2_read_blocks

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: cancel dqi_sync_work before freeing oinfo

Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
    ocfs2: reserve space for inline xattr before attaching reflink tree

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix uninit-value in ocfs2_get_block()

Heming Zhao <heming.zhao@suse.com>
    ocfs2: fix the la space leak when unmounting an ocfs2 volume

Danilo Krummrich <dakr@kernel.org>
    mm: krealloc: consider spare memory for __GFP_ZERO

Kemeng Shi <shikemeng@huaweicloud.com>
    jbd2: correctly compare tids with tid_geq function in jbd2_fc_begin_commit

Baokun Li <libaokun1@huawei.com>
    jbd2: stop waiting for space when jbd2_cleanup_journal_tail() returns error

Huang Ying <ying.huang@intel.com>
    resource: fix region_intersects() vs add_memory_driver_managed()

Ma Ke <make24@iscas.ac.cn>
    drm: omapdrm: Add missing check for alloc_ordered_workqueue

Andrew Jones <ajones@ventanamicro.com>
    of/irq: Support #msi-cells=<0> in of_msi_get_domain

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    of: address: Report error on resource bounds overflow

Val Packett <val@packett.cool>
    drm/rockchip: vop: clear DMA stop bit on RK3066

Helge Deller <deller@gmx.de>
    parisc: Fix stack start for ADDR_NO_RANDOMIZE personality

Helge Deller <deller@kernel.org>
    parisc: Allow mmap(MAP_STACK) memory to automatically expand upwards

Helge Deller <deller@kernel.org>
    parisc: Fix 64-bit userspace syscall path

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: mark fc as ineligible using an handle in ext4_xattr_set()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: use handle to mark fc as ineligible in __track_dentry_update()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix fast commit inode enqueueing during a full journal commit

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in jbd2_journal_shrink_checkpoint_list()

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()

Baokun Li <libaokun1@huawei.com>
    ext4: update orig_path in ext4_find_extent()

Xiaxi Shen <shenxiaxi26@gmail.com>
    ext4: fix timer use-after-free on failed mount

Baokun Li <libaokun1@huawei.com>
    ext4: fix double brelse() the buffer of the extents path

Baokun Li <libaokun1@huawei.com>
    ext4: aovid use-after-free in ext4_ext_insert_extent()

Baokun Li <libaokun1@huawei.com>
    ext4: drop ppath from ext4_ext_replay_update_ex() to avoid double-free

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()

Zhihao Cheng <chengzhihao1@huawei.com>
    ext4: dax: fix overflowing extents beyond inode size when partially writing

Luis Henriques (SUSE) <luis.henriques@linux.dev>
    ext4: fix incorrect tid assumption in ext4_fc_mark_ineligible()

Baokun Li <libaokun1@huawei.com>
    ext4: propagate errors from ext4_find_extent() in ext4_insert_range()

Baokun Li <libaokun1@huawei.com>
    ext4: fix slab-use-after-free in ext4_split_extent_at()

yao.ly <yao.ly@linux.alibaba.com>
    ext4: correct encrypted dentry name hash when not casefolded

Edward Adam Davis <eadavis@qq.com>
    ext4: no need to continue when the number of entries is 1

Abhishek Tamboli <abhishektamboli9@gmail.com>
    ALSA: hda/realtek: Add a quirk for HP Pavilion 15z-ec200

Ai Chao <aichao@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Huawei MateBook 13 KLV-WX9

Hans P. Moller <hmoller@uc.cl>
    ALSA: line6: add hw monitor volume control to POD HD500X

Jan Lalinsky <lalinsky@c4.cz>
    ALSA: usb-audio: Add native DSD support for Luxman D-08u

Lianqin Hu <hulianqin@vivo.com>
    ALSA: usb-audio: Add delay quirk for VIVO USB-C HEADSET

Jaroslav Kysela <perex@perex.cz>
    ALSA: core: add isascii() check to card ID generator

Baojun Xu <baojun.xu@ti.com>
    ALSA: hda/tas2781: Add new quirk for Lenovo Y990 Laptop

Thomas Zimmermann <tzimmermann@suse.de>
    drm: Consistently use struct drm_mode_rect for FB_DAMAGE_CLIPS

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    drm/mediatek: ovl_adaptor: Add missing of_node_put()

Helge Deller <deller@gmx.de>
    parisc: Fix itlb miss handler for 64-bit programs

Luo Gengkun <luogengkun@huaweicloud.com>
    perf/core: Fix small negative period being ignored

Hans de Goede <hdegoede@redhat.com>
    power: supply: hwmon: Fix missing temp1_max_alarm attribute

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: bcm63xx: Fix missing pm_runtime_disable()

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: bcm63xx: Fix module autoloading

David Virag <virag.david003@gmail.com>
    dt-bindings: clock: exynos7885: Fix duplicated binding

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    memory: tegra186-emc: drop unused to_tegra186_emc()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    firmware: tegra: bpmp: Drop unused mbox_client_to_bpmp()

Mike Baynton <mike@mbaynton.com>
    ovl: fail if trusted xattrs are needed but caller lacks permission

Alice Ryhl <aliceryhl@google.com>
    rust: sync: require `T: Sync` for `LockedBy::access`

Kimriver Liu <kimriver.liu@siengine.com>
    i2c: designware: fix controller is holding SCL low while ENABLE bit is disabled

Jinjie Ruan <ruanjinjie@huawei.com>
    i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled

Alexander Shiyan <eagle.alexander923@gmail.com>
    media: i2c: ar0521: Use cansleep version of gpiod_set_value()

Robert Hancock <robert.hancock@calian.com>
    i2c: xiic: Wait for TX empty to avoid missed TX NAKs

Jinjie Ruan <ruanjinjie@huawei.com>
    i2c: qcom-geni: Use IRQF_NO_AUTOEN flag in request_irq()

Marek Vasut <marex@denx.de>
    i2c: stm32f7: Do not prepare/unprepare clock during runtime suspend/resume

Zach Wade <zachwade.k@gmail.com>
    platform/x86: ISST: Fix the KASAN report slab-out-of-bounds bug

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: hda: Conditionally use snooping for AMD HDMI"

Heiko Carstens <hca@linux.ibm.com>
    selftests: vDSO: fix vdso_config for s390

Jens Remus <jremus@linux.ibm.com>
    selftests: vDSO: fix ELF hash table entry size for s390x

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/vdso: Fix VDSO data access when running in a non-root time namespace

David Hildenbrand <david@redhat.com>
    selftests/mm: fix charge_reserved_hugetlb.sh test

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests: vDSO: fix vDSO symbols lookup for powerpc64

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests: vDSO: fix vdso_config for powerpc

Christophe Leroy <christophe.leroy@csgroup.eu>
    selftests: vDSO: fix vDSO name for powerpc

Namhyung Kim <namhyung@kernel.org>
    perf: Really fix event_function_call() locking

Ian Rogers <irogers@google.com>
    perf callchain: Fix stitch LBR memory leaks

Biju Das <biju.das.jz@bp.renesas.com>
    spi: rpc-if: Add missing MODULE_DEVICE_TABLE

Alexander F. Lent <lx@xanderlent.com>
    accel/ivpu: Add missing MODULE_FIRMWARE metadata

Yifei Liu <yifei.l.liu@oracle.com>
    selftests: breakpoints: use remaining time to check if suspend succeed

Ben Dooks <ben.dooks@codethink.co.uk>
    spi: s3c64xx: fix timeout counters in flush_fifo

Yun Lu <luyun@kylinos.cn>
    selftest: hid: add missing run-hid-tools-tests.sh

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-cadence: Fix missing spi_controller_is_target() check

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-cadence: Fix pm_runtime_set_suspended() with runtime pm enabled

Li Zetao <lizetao1@huawei.com>
    spi: spi-cadence: Use helper function devm_clk_get_enabled()

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled

Kuan-Wei Chiu <visitorckw@gmail.com>
    bpftool: Fix undefined behavior in qsort(NULL, 0, ...)

Christoph Hellwig <hch@lst.de>
    iomap: handle a post-direct I/O invalidate race in iomap_write_delalloc_release

Kuan-Wei Chiu <visitorckw@gmail.com>
    bpftool: Fix undefined behavior caused by shifting into the sign bit

Artem Sadovnikov <ancowi69@gmail.com>
    ext4: fix i_data_sem unlock order in ext4_ind_migrate()

Baokun Li <libaokun1@huawei.com>
    ext4: avoid use-after-free in ext4_ext_show_leaf()

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    ext4: ext4_search_dir should return a proper error

Juntong Deng <juntong.deng@outlook.com>
    bpf: Make the pointer returned by iter next method valid

Jan Kara <jack@suse.cz>
    ext4: don't set SB_RDONLY after filesystem errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add refcnt to ksmbd_conn struct

Gergo Koteles <soyer@irl.hu>
    platform/x86: lenovo-ymc: Ignore the 0x0 state

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx10: use rlc safe mode for soft recovery

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx11: use rlc safe mode for soft recovery

Haren Myneni <haren@linux.ibm.com>
    powerpc/pseries: Use correct data types from pseries_hp_errorlog struct

Geert Uytterhoeven <geert+renesas@glider.be>
    of/irq: Refer to actual buffer size in of_irq_parse_one()

Tim Huang <tim.huang@amd.com>
    drm/amd/pm: ensure the fw_info is not null before using it

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gfx9: use rlc safe mode for soft recovery

Victor Skvortsov <victor.skvortsov@amd.com>
    drm/amdgpu: Block MMR_READ IOCTL in reset

Geert Uytterhoeven <geert+renesas@glider.be>
    drm/radeon/r100: Handle unknown family in r100_cp_init_microcode()

Finn Thain <fthain@linux-m68k.org>
    scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers

Peter Zijlstra <peterz@infradead.org>
    perf: Fix event_function_call() locking

Tim Huang <tim.huang@amd.com>
    drm/amdgpu: fix unchecked return value warning for amdgpu_gfx

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Update PRLO handling in direct attached topology

Kees Cook <kees@kernel.org>
    scsi: aacraid: Rearrange order of struct aac_srb_unit

Andrii Nakryiko <andrii@kernel.org>
    perf,x86: avoid missing caller address in stack traces captured in uprobe

Matthew Brost <matthew.brost@intel.com>
    drm/printer: Allow NULL data in devcoredump printer

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Initialize get_bytes_per_element's default to 1

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Avoid overflow assignment in link_dp_cts

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix index out of bounds in DCN30 color transformation

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix index out of bounds in degamma hardware format translation

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix index out of bounds in DCN30 degamma hardware format translation

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check link_res->hpo_dp_link_enc before using it

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check stream before comparing them

Yannick Fertre <yannick.fertre@foss.st.com>
    drm/stm: ltdc: reset plane transparency after plane disable

Ckath <ckath@yandex.ru>
    platform/x86: touchscreen_dmi: add nanote-next quirk

Vishnu Sankar <vishnuocv@gmail.com>
    HID: multitouch: Add support for Thinkpad X12 Gen 2 Kbd Portfolio

Jesse Zhang <jesse.zhang@amd.com>
    drm/amdkfd: Fix resource leak in criu restore queue

Peng Liu <liupeng01@kylinos.cn>
    drm/amdgpu: enable gfxoff quirk on HP 705G4

Peng Liu <liupeng01@kylinos.cn>
    drm/amdgpu: add raven1 gfxoff quirk

Zhao Mengmeng <zhaomengmeng@kylinos.cn>
    jfs: Fix uninit-value access of new_ea in ea_buffer

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs

Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
    scsi: smartpqi: correct stream detection

Edward Adam Davis <eadavis@qq.com>
    jfs: check if leafidx greater than num leaves per dmap tree

Edward Adam Davis <eadavis@qq.com>
    jfs: Fix uaf in dbFreeBits

Remington Brasga <rbrasga@uci.edu>
    jfs: UBSAN: shift-out-of-bounds in dbFindBits

Tim Huang <tim.huang@amd.com>
    drm/amd/display: fix double free issue during amdgpu module unload

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for 'afb' in amdgpu_dm_plane_handle_cursor_update (v2)

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Check null pointers before using dc->clk_mgr

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Handle null 'stream_status' in 'planes_changed_for_existing_stream'

Hans de Goede <hdegoede@redhat.com>
    HID: Ignore battery for all ELAN I2C-HID devices

Damien Le Moal <dlemoal@kernel.org>
    ata: sata_sil: Rename sil_blacklist to sil_quirks

Damien Le Moal <dlemoal@kernel.org>
    ata: pata_serverworks: Do not use the term blacklist

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add null check for top_pipe_to_program in commit_planes_for_stream

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: amdkfd_free_gtt_mem clear the correct pointer

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit

Katya Orlova <e.orlova@ispras.ru>
    drm/stm: Avoid use-after-free issues with crtc and plane

Michal Koutný <mkoutny@suse.com>
    cgroup: Disallow mounting v1 hierarchies without controller implementation

Sanjay K Kumar <sanjay.k.kumar@intel.com>
    iommu/vt-d: Fix potential lockup if qi_submit_sync called with 0 count

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Always reserve a domain ID for identity setup

Andrew Davis <afd@ti.com>
    power: reset: brcmstb: Do not go into infinite loop if reset fails

Paul E. McKenney <paulmck@kernel.org>
    rcuscale: Provide clear error when async specified without primitives

Kaixin Wang <kxwang23@m.fudan.edu.cn>
    fbdev: pxafb: Fix possible use after free in pxafb_task()

Thomas Weißschuh <linux@weissschuh.net>
    fbdev: efifb: Register sysfs groups through driver core

Denis Pauk <pauk.denis@gmail.com>
    hwmon: (nct6775) add G15CF to ASUS WMI monitoring list

Kees Cook <kees@kernel.org>
    x86/syscall: Avoid memcpy() for ia32 syscall_get_arguments()

Thomas Weißschuh <linux@weissschuh.net>
    selftests/nolibc: avoid passing NULL to printf("%s")

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: powerpc: limit stack-protector workaround to GCC

Takashi Iwai <tiwai@suse.de>
    ALSA: hdsp: Break infinite MIDI input flush loop

Takashi Iwai <tiwai@suse.de>
    ALSA: asihpi: Fix potential OOB array access

Tao Liu <ltao@redhat.com>
    x86/kexec: Add EFI config table identity mapping for kexec kernel

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    x86/pkeys: Restore altstack access in sigreturn()

Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
    x86/pkeys: Add PKRU as a parameter in signal handling functions

Ahmed S. Darwish <darwi@linutronix.de>
    tools/x86/kcpuid: Protect against faulty "max subleaf" values

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: codecs: wsa883x: Handle reading version failure

Joshua Pius <joshuapius@chromium.org>
    ALSA: usb-audio: Add logitech Audio profile quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Replace complex quirk lines with macros

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Define macros for quirk table entries

Karol Kosik <k.kosik@outlook.com>
    ALSA: usb-audio: Support multiple control interfaces

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Handle allocation failures gracefully

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add input value sanity checks for standard types

Jinjie Ruan <ruanjinjie@huawei.com>
    nfp: Use IRQF_NO_AUTOEN flag in request_irq()

Gustavo A. R. Silva <gustavoars@kernel.org>
    wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_cmd_802_11_scan_ext()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: hold dev->mt76.mutex while disabling tx worker

Benjamin Lin <benjamin-jw.lin@mediatek.com>
    wifi: mt76: mt7915: add dummy HW offload of IEEE 802.11 fragmentation

Stefan Mätje <stefan.maetje@esd.eu>
    can: netlink: avoid call to do_set_data_bittiming callback with stale can_priv::ctrlmode

James Clark <james.clark@linaro.org>
    drivers/perf: arm_spe: Use perf_allow_kernel() for permissions

Adrian Ratiu <adrian.ratiu@collabora.com>
    proc: add config & param to block forcing mem writes

Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
    ACPICA: iasl: handle empty connection_node

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix RCU list iterations

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: avoid NULL pointer dereference

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: use correct key iteration

Jason Xing <kernelxing@tencent.com>
    tcp: avoid reusing FIN_WAIT2 when trying to find port in connect() process

Breno Leitao <leitao@debian.org>
    netpoll: Ensure clean state on setup failures

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: simd - Do not call crypto_alloc_tfm during registration

Simon Horman <horms@kernel.org>
    net: atlantic: Avoid warning about potential string truncation

Ido Schimmel <idosch@nvidia.com>
    ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw89: correct base HT rate mask for firmware

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).

Simon Horman <horms@kernel.org>
    bnxt_en: Extend maximum length of version string by 1 byte

Simon Horman <horms@kernel.org>
    net: mvpp2: Increase size of queue_name buffer

Simon Horman <horms@kernel.org>
    tipc: guard against string buffer overrun

Pei Xiao <xiaopei01@kylinos.cn>
    ACPICA: check null return of ACPI_ALLOCATE_ZEROED() in acpi_db_convert_to_package()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Do not release locks during operation region accesses

Zong-Zhe Yang <kevin_yang@realtek.com>
    wifi: rtw88: select WANT_DEV_COREDUMP

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath11k: fix array out-of-bound access in SoC stats

Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
    wifi: ath12k: fix array out-of-bound access in SoC stats

Konstantin Ovsepian <ovs@ovs.to>
    blk_iocost: fix more out of bound shifts

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: CPPC: Add support for setting EPP register in FFH

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add force_vendor quirk for Panasonic Toughbook CF-18

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btrtl: Set msft ext address filter quirk for RTL8852B

Hilda Wu <hildawu@realtek.com>
    Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0489:0xe122

Dmitry Antipov <dmantipov@yandex.ru>
    net: sched: consistently use rcu_replace_pointer() in taprio_change()

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: disable tx worker during tx BA session enable/disable

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: avoid failing the system during pm_suspend

Armin Wolf <W_Armin@gmx.de>
    ACPICA: Fix memory leak if acpi_ps_get_next_field() fails

Armin Wolf <W_Armin@gmx.de>
    ACPICA: Fix memory leak if acpi_ps_get_next_namepath() fails

Seiji Nishikawa <snishika@redhat.com>
    ACPI: PAD: fix crash in exit_round_robin()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    net: hisilicon: hns_mdio: fix OF node leak in probe()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    net: hisilicon: hip04: fix OF node leak in probe()

Jeongjun Park <aha310510@gmail.com>
    net/xen-netback: prevent UAF in xenvif_flush_hash()

Issam Hamdi <ih@simonwunderlich.de>
    wifi: cfg80211: Set correct chandef when starting CAC

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: drop wrong STA selection in TX

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlwifi: mvm: Fix a race in scan abort flow

Aleksandr Mishin <amishin@t-argos.ru>
    ice: Adjust over allocation of memory in ice_sched_add_root_node() and ice_sched_add_node()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: octeontx2 - Fix authenc setkey

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: octeontx - Fix authenc setkey

Fangrui Song <maskray@google.com>
    crypto: x86/sha256 - Add parentheses around macros' single arguments

Toke Høiland-Jørgensen <toke@redhat.com>
    wifi: ath9k_htc: Use __skb_set_length() for resetting urb before resubmit

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: avoid to add interface to list twice when SER

Dmitry Kandybka <d.kandybka@gmail.com>
    wifi: ath9k: fix possible integer overflow in ath9k_get_et_stats()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix conflicting quirk for System76 Pangolin

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ALSA: gus: Fix some error handling paths related to get_bpos() usage

Pali Rohár <pali@kernel.org>
    cifs: Do not convert delimiter when parsing NFS-style symlinks

Pali Rohár <pali@kernel.org>
    cifs: Fix buffer overflow when parsing NFS reparse points

Hui Wang <hui.wang@canonical.com>
    ASoC: imx-card: Set card.owner to avoid a warning calltrace if SND=m

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/generic: Unconditionally prefer preferred_dacs pairs

Pali Rohár <pali@kernel.org>
    cifs: Remove intermediate object of failed create reparse call

Oder Chiou <oder_chiou@realtek.com>
    ALSA: hda/realtek: Fix the push button function for the ALC257

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ALSA: mixer_oss: Remove some incorrect kfree_const() usages

Andrei Simion <andrei.simion@microchip.com>
    ASoC: atmel: mchp-pdmc: Skip ALSA restoration if substream runtime is uninitialized

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix not validating setsockopt user input

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix not validating setsockopt user input

Benjamin Gaignard <benjamin.gaignard@collabora.com>
    media: usbtv: Remove useless locks in usbtv_video_free()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sock: Fix not validating setsockopt user input

Christoph Hellwig <hch@lst.de>
    loop: don't set QUEUE_FLAG_NOMERGES

Robert Hancock <robert.hancock@calian.com>
    i2c: xiic: Try re-initialization on bus busy timeout

Marc Ferland <marc.ferland@sonatest.com>
    i2c: xiic: improve error message when transfer fails to start

Xin Long <lucien.xin@gmail.com>
    sctp: set sk_state back to CLOSED if autobind fails in sctp_listen_start

Ravikanth Tuniki <ravikanth.tuniki@amd.com>
    dt-bindings: net: xlnx,axi-ethernet: Add missing reg minItems

Darrick J. Wong <djwong@kernel.org>
    iomap: constrain the file range passed to iomap_file_unshare

Eric Dumazet <edumazet@google.com>
    ppp: do not assume bh is held in ppp_channel_bridge_input()

Eric Dumazet <edumazet@google.com>
    net: test for not too small csum_start in virtio_net_hdr_to_skb()

Anton Danilov <littlesmilingcloud@gmail.com>
    ipv4: ip_gre: Fix drops of small packets in ipgre_xmit

Shenwei Wang <shenwei.wang@nxp.com>
    net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check

Eric Dumazet <edumazet@google.com>
    net: add more sanity checks to qdisc_pkt_len_init()

Eric Dumazet <edumazet@google.com>
    net: avoid potential underflow in qdisc_pkt_len_init() with UFO

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Reload PTP registers after link-state change

Csókás, Bence <csokas.bence@prolan.hu>
    net: fec: Restart PPS after link state change

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: ethernet: lantiq_etop: fix memory disclosure

Daniel Borkmann <daniel@iogearbox.net>
    net: Fix gso_features_check to check for both dev->gso_{ipv4_,}max_size

Daniel Borkmann <daniel@iogearbox.net>
    net: Add netif_get_gro_max_size helper for GRO

Jinjie Ruan <ruanjinjie@huawei.com>
    Bluetooth: btmrvl: Use IRQF_NO_AUTOEN flag in request_irq()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix uaf in l2cap_connect

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix possible crash on mgmt_index_removed

Eric Dumazet <edumazet@google.com>
    netfilter: nf_tables: prevent nf_skb_duplicated corruption

Phil Sutter <phil@nwl.cc>
    selftests: netfilter: Fix nft_audit.sh for newer nft binaries

Jinjie Ruan <ruanjinjie@huawei.com>
    net: wwan: qcom_bam_dmux: Fix missing pm_runtime_disable()

Jinjie Ruan <ruanjinjie@huawei.com>
    net: ieee802154: mcr20a: Use IRQF_NO_AUTOEN flag in request_irq()

Phil Sutter <phil@nwl.cc>
    netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Fix crash caused by calling __xfrm_state_delete() twice

Elena Salomatkina <esalomatkina@ispras.ru>
    net/mlx5e: Fix NULL deref in mlx5e_tir_builder_alloc()

Mohamed Khalfella <mkhalfella@purestorage.com>
    net/mlx5: Added cond_resched() to crdump collection

Gerd Bayer <gbayer@linux.ibm.com>
    net/mlx5: Fix error path in multi-packet WQE transmit

Aakash Menon <aakash.r.menon@gmail.com>
    net: sparx5: Fix invalid timestamps

Jinjie Ruan <ruanjinjie@huawei.com>
    ieee802154: Fix build error

Xiubo Li <xiubli@redhat.com>
    ceph: remove the incorrect Fw reference check when dirtying pages

Stefan Wahren <wahrenst@gmx.net>
    mailbox: bcm2835: Fix timeout during suspend mode

Liao Chen <liaochen4@huawei.com>
    mailbox: rockchip: fix a typo in module autoloading

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu: Fix get each xcp macro

Daniel Wagner <dwagner@suse.de>
    scsi: pm8001: Do not overwrite PCI queue mapping

Rafael Rocha <rrochavi@fnal.gov>
    scsi: st: Fix input/output error on empty drive reset

Peter Zijlstra <peterz@infradead.org>
    jump_label: Fix static_key_slow_dec() yet again

Thomas Gleixner <tglx@linutronix.de>
    jump_label: Simplify and clarify static_key_fast_inc_cpus_locked()

Thomas Gleixner <tglx@linutronix.de>
    static_call: Replace pointless WARN_ON() in static_call_module_notify()

Thomas Gleixner <tglx@linutronix.de>
    static_call: Handle module init failure correctly in static_call_del_module()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   10 +
 Documentation/arch/arm64/silicon-errata.rst        |    6 +
 .../devicetree/bindings/net/xlnx,axi-ethernet.yaml |    3 +-
 Makefile                                           |    4 +-
 arch/arm/crypto/aes-ce-glue.c                      |    2 +-
 arch/arm/crypto/aes-neonbs-glue.c                  |    2 +-
 arch/arm64/Kconfig                                 |    7 +-
 arch/arm64/include/asm/cputype.h                   |    2 +
 arch/arm64/kernel/cpu_errata.c                     |    3 +
 arch/loongarch/configs/loongson3_defconfig         |    1 -
 arch/parisc/include/asm/mman.h                     |   14 +
 arch/parisc/kernel/entry.S                         |    6 +-
 arch/parisc/kernel/syscall.S                       |   14 +-
 arch/powerpc/configs/ppc64_defconfig               |    1 -
 arch/powerpc/include/asm/vdso_datapage.h           |   15 +
 arch/powerpc/kernel/asm-offsets.c                  |    2 +
 arch/powerpc/kernel/vdso/cacheflush.S              |    2 +-
 arch/powerpc/kernel/vdso/datapage.S                |    4 +-
 arch/powerpc/platforms/pseries/dlpar.c             |   17 -
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   16 +-
 arch/powerpc/platforms/pseries/pmem.c              |    2 +-
 arch/riscv/Kconfig                                 |    8 +-
 arch/riscv/include/asm/thread_info.h               |    7 +-
 arch/x86/crypto/sha256-avx2-asm.S                  |   16 +-
 arch/x86/events/core.c                             |   63 +
 arch/x86/include/asm/fpu/signal.h                  |    2 +-
 arch/x86/include/asm/syscall.h                     |    7 +-
 arch/x86/kernel/apic/io_apic.c                     |   46 +-
 arch/x86/kernel/fpu/signal.c                       |    6 +-
 arch/x86/kernel/machine_kexec_64.c                 |   27 +
 arch/x86/kernel/signal.c                           |    3 +-
 arch/x86/kernel/signal_64.c                        |    6 +-
 block/blk-iocost.c                                 |    8 +-
 crypto/simd.c                                      |   76 +-
 drivers/accel/ivpu/ivpu_fw.c                       |    4 +
 drivers/acpi/acpi_pad.c                            |    6 +-
 drivers/acpi/acpica/dbconvert.c                    |    2 +
 drivers/acpi/acpica/exprep.c                       |    3 +
 drivers/acpi/acpica/psargs.c                       |   47 +
 drivers/acpi/battery.c                             |   28 +-
 drivers/acpi/cppc_acpi.c                           |   10 +-
 drivers/acpi/ec.c                                  |   55 +-
 drivers/acpi/resource.c                            |   14 +
 drivers/acpi/video_detect.c                        |    8 +
 drivers/ata/pata_serverworks.c                     |   16 +-
 drivers/ata/sata_sil.c                             |   12 +-
 drivers/block/aoe/aoecmd.c                         |   13 +-
 drivers/block/loop.c                               |   15 +-
 drivers/block/null_blk/main.c                      |   45 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    3 +-
 drivers/bluetooth/btrtl.c                          |    1 +
 drivers/bluetooth/btusb.c                          |    2 +
 drivers/clk/qcom/clk-alpha-pll.c                   |    2 +-
 drivers/clk/qcom/clk-rpmh.c                        |    2 +
 drivers/clk/qcom/dispcc-sm8250.c                   |    3 +
 drivers/clk/qcom/gcc-sc8180x.c                     |   88 +-
 drivers/clk/qcom/gcc-sm8250.c                      |    6 +-
 drivers/clk/qcom/gcc-sm8450.c                      |    4 +-
 drivers/clk/rockchip/clk.c                         |    3 +-
 drivers/clk/samsung/clk-exynos7885.c               |    2 +-
 drivers/cpufreq/intel_pstate.c                     |   20 +-
 drivers/crypto/marvell/Kconfig                     |    2 +
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   |  265 +--
 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c |  256 +--
 drivers/firmware/efi/unaccepted_memory.c           |    4 +
 drivers/firmware/tegra/bpmp.c                      |    6 -
 drivers/gpio/gpio-davinci.c                        |    8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |    4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   18 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c            |   45 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h            |    2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |    2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |    2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |    6 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |    4 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager.c       |    2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |    2 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |    5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   19 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |    4 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |    3 -
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_plane.c    |    3 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |    6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    6 +-
 drivers/gpu/drm/amd/display/dc/dc_types.h          |    1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |    2 +
 .../gpu/drm/amd/display/dc/dcn30/dcn30_cm_common.c |    4 +
 .../dc/dml/dcn20/display_rq_dlg_calc_20v2.c        |    2 +-
 .../display/dc/dml/dcn21/display_rq_dlg_calc_21.c  |    2 +-
 .../amd/display/dc/link/hwss/link_hwss_hpo_dp.c    |   12 +
 drivers/gpu/drm/amd/display/dc/link/link_factory.c |    2 +-
 .../drm/amd/pm/powerplay/hwmgr/processpptables.c   |    2 +
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   22 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |    2 +-
 drivers/gpu/drm/drm_print.c                        |   13 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |    2 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |    4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |    1 +
 drivers/gpu/drm/msm/msm_gpu.c                      |    1 -
 drivers/gpu/drm/omapdrm/omap_drv.c                 |    5 +
 drivers/gpu/drm/radeon/r100.c                      |   70 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |    4 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h        |    1 +
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c        |    2 +
 drivers/gpu/drm/scheduler/sched_entity.c           |    2 +
 drivers/gpu/drm/stm/drv.c                          |    3 +-
 drivers/gpu/drm/stm/ltdc.c                         |   76 +-
 drivers/hid/hid-ids.h                              |   17 +-
 drivers/hid/hid-input.c                            |   37 +-
 drivers/hid/hid-multitouch.c                       |    6 +
 drivers/hwmon/nct6775-platform.c                   |    1 +
 drivers/i2c/busses/i2c-designware-common.c         |   14 +
 drivers/i2c/busses/i2c-designware-core.h           |    1 +
 drivers/i2c/busses/i2c-designware-master.c         |   38 +
 drivers/i2c/busses/i2c-qcom-geni.c                 |    4 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |    6 +-
 drivers/i2c/busses/i2c-synquacer.c                 |   12 +-
 drivers/i2c/busses/i2c-xiic.c                      |   69 +-
 drivers/i2c/i2c-core-base.c                        |   39 +
 drivers/i3c/master/svc-i3c-master.c                |    1 +
 drivers/iio/magnetometer/ak8975.c                  |   32 +-
 drivers/iio/pressure/bmp280-core.c                 |  185 +-
 drivers/iio/pressure/bmp280-regmap.c               |   47 +-
 drivers/iio/pressure/bmp280-spi.c                  |    4 +-
 drivers/iio/pressure/bmp280.h                      |   49 +-
 drivers/infiniband/hw/mana/main.c                  |    8 +-
 drivers/input/keyboard/adp5589-keys.c              |   22 +-
 drivers/iommu/intel/dmar.c                         |   16 +-
 drivers/iommu/intel/iommu.c                        |    6 +-
 drivers/iommu/iommufd/selftest.c                   |   27 +-
 drivers/mailbox/bcm2835-mailbox.c                  |    3 +-
 drivers/mailbox/rockchip-mailbox.c                 |    2 +-
 drivers/media/i2c/ar0521.c                         |    5 +-
 drivers/media/i2c/imx335.c                         |   43 +-
 drivers/media/i2c/ov5675.c                         |   12 +-
 drivers/media/platform/qcom/camss/camss-video.c    |    6 -
 drivers/media/platform/qcom/camss/camss.c          |    5 +-
 drivers/media/platform/qcom/venus/core.c           |    1 +
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c |    5 +
 drivers/media/usb/usbtv/usbtv-video.c              |    7 -
 drivers/memory/tegra/tegra186-emc.c                |    5 -
 drivers/net/can/dev/netlink.c                      |  102 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    2 +-
 drivers/net/ethernet/freescale/fec.h               |    9 +
 drivers/net/ethernet/freescale/fec_main.c          |   11 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   50 +
 drivers/net/ethernet/hisilicon/hip04_eth.c         |    1 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    1 +
 drivers/net/ethernet/hisilicon/hns_mdio.c          |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |   19 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |    6 +-
 drivers/net/ethernet/lantiq_etop.c                 |    4 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |    3 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |    1 -
 .../net/ethernet/mellanox/mlx5/core/lib/pci_vsc.c  |   10 +
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |    6 +-
 drivers/net/ethernet/microsoft/Kconfig             |    3 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   10 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   14 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |    8 +-
 drivers/net/ethernet/microsoft/mana/shm_channel.c  |   13 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    5 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   31 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   19 +-
 drivers/net/ieee802154/Kconfig                     |    1 +
 drivers/net/ieee802154/mcr20a.c                    |    5 +-
 drivers/net/pcs/pcs-xpcs-wx.c                      |    2 +-
 drivers/net/ppp/ppp_generic.c                      |    4 +-
 drivers/net/vrf.c                                  |    2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    2 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   13 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   42 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   12 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    7 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   10 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |    1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |    4 +-
 drivers/net/wireless/realtek/rtw89/util.h          |   18 +
 drivers/net/wwan/qcom_bam_dmux.c                   |   11 +-
 drivers/net/xen-netback/hash.c                     |    5 +-
 drivers/of/address.c                               |    5 +
 drivers/of/irq.c                                   |   38 +-
 drivers/perf/arm_spe_pmu.c                         |    9 +-
 .../x86/intel/speed_select_if/isst_if_common.c     |    4 +-
 drivers/platform/x86/lenovo-ymc.c                  |    2 +
 drivers/platform/x86/think-lmi.c                   |   16 +-
 drivers/platform/x86/touchscreen_dmi.c             |   26 +
 drivers/platform/x86/x86-android-tablets/core.c    |   57 +-
 drivers/power/reset/brcmstb-reboot.c               |    3 -
 drivers/power/supply/power_supply_hwmon.c          |    3 +-
 drivers/remoteproc/ti_k3_r5_remoteproc.c           |   86 +-
 drivers/rtc/rtc-at91sam9.c                         |    1 +
 drivers/scsi/NCR5380.c                             |    4 +
 drivers/scsi/aacraid/aacraid.h                     |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   27 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   22 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    6 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |    2 +-
 drivers/scsi/st.c                                  |    5 +-
 drivers/spi/spi-bcm63xx.c                          |    9 +-
 drivers/spi/spi-cadence.c                          |   31 +-
 drivers/spi/spi-imx.c                              |    2 +-
 drivers/spi/spi-rpc-if.c                           |    7 +
 drivers/spi/spi-s3c64xx.c                          |    4 +-
 drivers/vhost/scsi.c                               |   25 +-
 drivers/video/fbdev/efifb.c                        |   11 +-
 drivers/video/fbdev/pxafb.c                        |    1 +
 fs/btrfs/backref.c                                 |   12 +-
 fs/btrfs/disk-io.c                                 |   11 +
 fs/btrfs/relocation.c                              |  150 +-
 fs/btrfs/relocation.h                              |    9 +-
 fs/btrfs/send.c                                    |   23 +-
 fs/cachefiles/namei.c                              |    7 +-
 fs/ceph/addr.c                                     |    6 +-
 fs/dax.c                                           |    6 +-
 fs/exec.c                                          |    3 +-
 fs/exfat/balloc.c                                  |   10 +-
 fs/ext4/dir.c                                      |   14 +-
 fs/ext4/extents.c                                  |   55 +-
 fs/ext4/fast_commit.c                              |   49 +-
 fs/ext4/file.c                                     |    8 +-
 fs/ext4/inode.c                                    |   11 +-
 fs/ext4/migrate.c                                  |    2 +-
 fs/ext4/move_extent.c                              |    1 -
 fs/ext4/namei.c                                    |   14 +-
 fs/ext4/super.c                                    |   11 +-
 fs/ext4/xattr.c                                    |    3 +-
 fs/file.c                                          |   93 +-
 fs/iomap/buffered-io.c                             |   16 +-
 fs/jbd2/checkpoint.c                               |   21 +-
 fs/jbd2/journal.c                                  |    4 +-
 fs/jfs/jfs_discard.c                               |   11 +-
 fs/jfs/jfs_dmap.c                                  |    7 +-
 fs/jfs/xattr.c                                     |    2 +
 fs/nfsd/nfs4state.c                                |    5 +-
 fs/nfsd/nfs4xdr.c                                  |   10 +-
 fs/nfsd/vfs.c                                      |    1 +
 fs/ocfs2/aops.c                                    |    5 +-
 fs/ocfs2/buffer_head_io.c                          |    4 +-
 fs/ocfs2/journal.c                                 |    7 +-
 fs/ocfs2/localalloc.c                              |   19 +
 fs/ocfs2/quota_local.c                             |    8 +-
 fs/ocfs2/refcounttree.c                            |   26 +-
 fs/ocfs2/xattr.c                                   |   11 +-
 fs/overlayfs/params.c                              |   38 +-
 fs/proc/base.c                                     |   61 +-
 fs/smb/client/cifsfs.c                             |   13 +-
 fs/smb/client/cifsglob.h                           |    2 +-
 fs/smb/client/inode.c                              |   19 +-
 fs/smb/client/reparse.c                            |   16 +-
 fs/smb/client/smb1ops.c                            |    2 +-
 fs/smb/client/smb2inode.c                          |   24 +-
 fs/smb/client/smb2ops.c                            |   19 +-
 fs/smb/server/connection.c                         |    4 +-
 fs/smb/server/connection.h                         |    1 +
 fs/smb/server/oplock.c                             |   55 +-
 fs/smb/server/vfs_cache.c                          |    3 +
 include/crypto/internal/simd.h                     |   12 +-
 include/drm/drm_print.h                            |   54 +-
 include/dt-bindings/clock/exynos7885.h             |    2 +-
 include/dt-bindings/clock/qcom,gcc-sc8180x.h       |    3 +
 include/linux/cpufreq.h                            |    6 +-
 include/linux/fdtable.h                            |    8 +-
 include/linux/i2c.h                                |    5 +
 include/linux/netdevice.h                          |   18 +
 include/linux/perf_event.h                         |    8 +-
 include/linux/stmmac.h                             |    1 -
 include/linux/uprobes.h                            |    2 +
 include/linux/virtio_net.h                         |    4 +-
 include/net/mana/gdma.h                            |   10 +-
 include/net/mana/mana.h                            |    3 +-
 include/uapi/linux/cec.h                           |    6 +-
 include/uapi/linux/netfilter/nf_tables.h           |    2 +-
 io_uring/net.c                                     |    4 +-
 kernel/bpf/verifier.c                              |   26 +-
 kernel/cgroup/cgroup-v1.c                          |   12 +-
 kernel/events/core.c                               |   33 +-
 kernel/events/uprobes.c                            |    4 +-
 kernel/fork.c                                      |   32 +-
 kernel/jump_label.c                                |   52 +-
 kernel/rcu/rcuscale.c                              |    4 +-
 kernel/resource.c                                  |   58 +-
 kernel/sched/psi.c                                 |   26 +-
 kernel/static_call_inline.c                        |   13 +-
 kernel/trace/trace_hwlat.c                         |    2 +
 kernel/trace/trace_osnoise.c                       |   22 +-
 lib/buildid.c                                      |   88 +-
 mm/Kconfig                                         |   25 +-
 mm/slab_common.c                                   |    7 +
 net/bluetooth/hci_core.c                           |    2 +
 net/bluetooth/hci_event.c                          |   15 +-
 net/bluetooth/hci_sock.c                           |   21 +-
 net/bluetooth/iso.c                                |   36 +-
 net/bluetooth/l2cap_core.c                         |    8 -
 net/bluetooth/l2cap_sock.c                         |   52 +-
 net/bluetooth/mgmt.c                               |   23 +-
 net/core/dev.c                                     |   14 +-
 net/core/gro.c                                     |    9 +-
 net/core/netpoll.c                                 |   15 +-
 net/dsa/slave.c                                    |    7 +-
 net/ipv4/devinet.c                                 |    6 +-
 net/ipv4/fib_frontend.c                            |    2 +-
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/netfilter/nf_dup_ipv4.c                   |    7 +-
 net/ipv4/tcp_ipv4.c                                |    3 +
 net/ipv4/udp_offload.c                             |   22 +-
 net/ipv6/netfilter/nf_dup_ipv6.c                   |    7 +-
 net/mac80211/chan.c                                |    4 +-
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/scan.c                                |    2 +-
 net/mac80211/util.c                                |    4 +-
 net/mac802154/scan.c                               |    4 +-
 net/netfilter/nf_tables_api.c                      |   57 +-
 net/netfilter/nft_set_bitmap.c                     |    4 +-
 net/netfilter/nft_set_hash.c                       |    8 +-
 net/netfilter/nft_set_pipapo.c                     |    5 +-
 net/netfilter/nft_set_rbtree.c                     |    4 +-
 net/rxrpc/ar-internal.h                            |    2 +-
 net/rxrpc/io_thread.c                              |   10 +-
 net/rxrpc/local_object.c                           |    2 +-
 net/sched/sch_taprio.c                             |    4 +-
 net/sctp/socket.c                                  |    4 +-
 net/tipc/bearer.c                                  |    8 +-
 net/wireless/nl80211.c                             |   15 +-
 rust/kernel/sync/locked_by.rs                      |   18 +-
 scripts/kconfig/qconf.cc                           |    2 +-
 security/Kconfig                                   |   32 +
 security/tomoyo/domain.c                           |    9 +-
 sound/core/init.c                                  |   14 +-
 sound/core/oss/mixer_oss.c                         |    4 +-
 sound/isa/gus/gus_pcm.c                            |    4 +-
 sound/pci/asihpi/hpimsgx.c                         |    2 +-
 sound/pci/hda/hda_controller.h                     |    2 +-
 sound/pci/hda/hda_generic.c                        |    4 +-
 sound/pci/hda/hda_intel.c                          |   10 +-
 sound/pci/hda/patch_conexant.c                     |   24 +-
 sound/pci/hda/patch_realtek.c                      |    4 +
 sound/pci/rme9652/hdsp.c                           |    6 +-
 sound/pci/rme9652/hdspm.c                          |    6 +-
 sound/soc/atmel/mchp-pdmc.c                        |    3 +
 sound/soc/codecs/wsa883x.c                         |   16 +-
 sound/soc/fsl/imx-card.c                           |    1 +
 sound/usb/card.c                                   |    8 +
 sound/usb/clock.c                                  |   62 +-
 sound/usb/format.c                                 |    6 +-
 sound/usb/helper.c                                 |   34 +
 sound/usb/helper.h                                 |   10 +-
 sound/usb/line6/podhd.c                            |    2 +-
 sound/usb/mixer.c                                  |   37 +-
 sound/usb/mixer.h                                  |    1 +
 sound/usb/mixer_quirks.c                           |   17 +-
 sound/usb/mixer_scarlett.c                         |    4 +-
 sound/usb/power.c                                  |    3 +-
 sound/usb/power.h                                  |    1 +
 sound/usb/quirks-table.h                           | 2283 ++++++--------------
 sound/usb/quirks.c                                 |    4 +
 sound/usb/stream.c                                 |   21 +-
 sound/usb/usbaudio.h                               |   12 +
 tools/arch/x86/kcpuid/kcpuid.c                     |   12 +-
 tools/bpf/bpftool/net.c                            |   11 +-
 tools/include/nolibc/arch-powerpc.h                |    2 +-
 tools/perf/util/hist.c                             |    7 +-
 tools/perf/util/machine.c                          |   17 +-
 tools/perf/util/setup.py                           |    2 +
 tools/perf/util/thread.c                           |    4 +
 tools/perf/util/thread.h                           |    1 +
 .../breakpoints/step_after_suspend_test.c          |    5 +-
 tools/testing/selftests/hid/Makefile               |    2 +
 .../selftests/mm/charge_reserved_hugetlb.sh        |    2 +-
 tools/testing/selftests/mm/write_to_hugetlbfs.c    |   23 +-
 tools/testing/selftests/netfilter/nft_audit.sh     |   57 +-
 tools/testing/selftests/nolibc/nolibc-test.c       |    4 +-
 tools/testing/selftests/vDSO/parse_vdso.c          |   17 +-
 tools/testing/selftests/vDSO/vdso_config.h         |   10 +-
 .../testing/selftests/vDSO/vdso_test_correctness.c |    6 +
 tools/tracing/rtla/src/osnoise_top.c               |    2 +-
 tools/tracing/rtla/src/timerlat_top.c              |    4 +-
 398 files changed, 4268 insertions(+), 3904 deletions(-)


