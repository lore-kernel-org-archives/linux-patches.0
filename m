Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C74143884;
	Thu, 13 Jun 2024 12:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280797; cv=none; b=LJ+E9Eg87WeoTyAruDzWeZ+LaO5T+iHZd4U/Y/sQKdH/qJgdVcpPW4EC/BvgjSxxPnhAJr7iLlAi3o4ARgixXK9M+dJJZ6+oTmaxaFR6McsZSc84/Jv0RRGlz/50GVSAE2vwmknKLW4diL9yVOLuPzdnFxfkUwIFbZAHB5dfZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280797; c=relaxed/simple;
	bh=X5K9Lk/VmXBmM0lHBoEopHkeGL2uX4MjZA2hirDusqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OCAJfRf9j87rbVqaesRV2z3dlQpwVjUWcD/ZEyOd3tLAnlLkyx7wSQ2ua9x0obUuNG2tlEUgWtgZQ4E9V7g3vihHdTpquuZMkIK3G5wkc8OyF/ij3UfSZqP4QTrnyXMMlnwjjXWkLmDaK/CMp9q+4FuljUt6emVMimaDsM67L14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOBcn6dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOBcn6dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE215C2BBFC;
	Thu, 13 Jun 2024 12:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280797;
	bh=X5K9Lk/VmXBmM0lHBoEopHkeGL2uX4MjZA2hirDusqU=;
	h=From:To:Cc:Subject:Date:From;
	b=xOBcn6drdxTiwZoY6uT2LNRK9qz2vH2SVNjNhli/giujZIH5ioMbBdCnvL/hg0jMT
	 RUvLHEcQoFiBc7e/Bbv9nkxwcKJHKDsXOZDpfHrYVQtS57YNwHwsSSkJl2ERnCxpqT
	 VMZkpTIanYeL031+KwJBanKgDHrp+JWAAqNsko74=
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
Subject: [PATCH 5.10 000/317] 5.10.219-rc1 review
Date: Thu, 13 Jun 2024 13:30:18 +0200
Message-ID: <20240613113247.525431100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.219-rc1
X-KernelTest-Deadline: 2024-06-15T11:32+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.219 release.
There are 317 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.219-rc1

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix CQ and QP cache affinity

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Use mutex instead of spinlock for ida allocation

Chao Yu <chao@kernel.org>
    f2fs: compress: fix compression chksum

Neil Armstrong <neil.armstrong@linaro.org>
    scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW major version > 5

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFS: Fix READ_PLUS when server doesn't support OP_READ_PLUS

Sergey Shtylyov <s.shtylyov@omp.ru>
    nfs: fix undefined behavior in nfs_block_bits()

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix crash in AP internal function modify_bitmap()

Baokun Li <libaokun1@huawei.com>
    ext4: fix mb_cache_entry's e_refcnt leak in ext4_xattr_block_cache_find()

Mike Gilbert <floppym@gentoo.org>
    sparc: move struct termio to asm/termios.h

Eric Dumazet <edumazet@google.com>
    net: fix __dst_negative_advice() race

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-specifiers rather than memset() for padding in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Merge identical case statements in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix console handling when editing and tab-completing commands

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Use format-strings rather than '\0' injection in kdb_read()

Daniel Thompson <daniel.thompson@linaro.org>
    kdb: Fix buffer overflow during tab-complete

Judith Mendez <jm@ti.com>
    watchdog: rti_wdt: Set min_hw_heartbeat_ms to accommodate a safety margin

Sam Ravnborg <sam@ravnborg.org>
    sparc64: Fix number of online CPUs

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Meteor Lake-S CPU support

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    net/9p: fix uninit-value in p9_client_rpc()

xu xin <xu.xin16@zte.com.cn>
    net/ipv6: Fix route deleting failure when metric equals 0

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: qat - Fix ADF_DEV_RESET_SYNC memory leak

Vitaly Chikunov <vt@altlinux.org>
    crypto: ecrdsa - Fix module auto-load on add_key

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Allow AArch32 PSTATE.M to be restored as System mode

Cai Xinchen <caixinchen1@huawei.com>
    fbdev: savage: Handle err return when savagefb_check_var failed

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Disable write protect detection on Toshiba WT10-A

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Fix Lenovo Yoga Tablet 2 Pro 1380 sdcard slot not working

Hans de Goede <hdegoede@redhat.com>
    mmc: sdhci-acpi: Sort DMI quirks alphabetically

Hans de Goede <hdegoede@redhat.com>
    mmc: core: Add mmc_gpiod_set_cd_config() function

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-core: hold videodev_lock until dev reg, finishes

Nathan Chancellor <nathan@kernel.org>
    media: mxl5xx: Move xpt structures off stack

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: mc: mark the media devnode as registered from the, start

Yang Xiwen <forbidden405@outlook.com>
    arm64: dts: hi3798cv200: fix the size of GICR

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix endianness issue in RX path

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192de: Fix low speed with WPA3-SAE

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix the TX power of RTL8192CU, RTL8723AU

Yu Kuai <yukuai3@huawei.com>
    md/raid5: fix deadlock that raid5d() wait for itself to clear MD_SB_CHANGE_PENDING

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: qcs404: fix bluetooth device address

Krzysztof Kozlowski <krzk@kernel.org>
    arm64: tegra: Correct Tegra132 I2C alias

Christoffer Sandberg <cs@tuxedo.de>
    ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_legacy: make legacy_exit() work again

Bob Zhou <bob.zhou@amd.com>
    drm/amdgpu: add error handle to avoid out-of-bounds

Zheyu Ma <zheyuma97@gmail.com>
    media: lgdt3306a: Add a check against null-pointer-def

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on i_xattr_nid in sanity_check_inode()

Ziyang Xuan <william.xuanziyang@huawei.com>
    netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: restrict tunnel object to NFPROTO_NETDEV

Linus Torvalds <torvalds@linux-foundation.org>
    x86/mm: Remove broken vsyscall emulation code from the page fault code

Daniel Borkmann <daniel@iogearbox.net>
    vxlan: Fix regression when dropping packets due to invalid src addresses

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free of timer for log writer thread

Marc Dionne <marc.dionne@auristor.com>
    afs: Don't cross .backup mountpoint from backup volume

Ming Lei <ming.lei@redhat.com>
    io_uring: fail NOP if non-zero op flags is passed in

Jorge Ramirez-Ortiz <jorge@foundries.io>
    mmc: core: Do not force a retune before RPMB switch

Carlos Llamas <cmllamas@google.com>
    binder: fix max_thread type inconsistency

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix loop termination condition in gss_free_in_token_pages()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: add adap_nb_transmit_canceled() callback

Dongli Zhang <dongli.zhang@oracle.com>
    genirq/cpuhotplug, x86/vector: Prevent vector leak during CPU offline

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Set lower bound of start tick time

Guenter Roeck <linux@roeck-us.net>
    hwmon: (shtc1) Fix property misspelling

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/uaccess: Use asm goto for get_user when compiler supports it

Yue Haibing <yuehaibing@huawei.com>
    ipvlan: Dont Use skb->sk in ipvlan_process_v{4,6}_outbound

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: stm32: Don't warn about spurious interrupts

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix comparison to constant symbols, 'm', 'n'

Florian Westphal <fw@strlen.de>
    netfilter: tproxy: bail out if IP has been disabled on the device

Xiaolei Wang <xiaolei.wang@windriver.com>
    net:fec: Add fec_enet_deinit()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Allow delete from sockmap/sockhash only if update is allowed

Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
    net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM

Roded Zats <rzats@paloaltonetworks.com>
    enic: Validate length of nl attributes in enic_set_vf_port

Friedrich Vock <friedrich.vock@gmx.de>
    bpf: Fix potential integer overflow in resolve_btfids

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    dma-buf/sw-sync: don't enable IRQ from sync_print_obj()

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix ns enable/disable possible hang

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Don't mark message DMA mapped when no transfer in it is

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: restore vlan q-in-q match support

Eric Dumazet <edumazet@google.com>
    netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    nfc: nci: Fix kcov check in nci_rx_work()

Dae R. Jeong <threeearcat@gmail.com>
    tls: fix missing memory barrier in tls_init

Wei Fang <wei.fang@nxp.com>
    net: fec: avoid lock evasion when reading pps_enable

Matthew Bystrin <dev.mbstr@gmail.com>
    riscv: stacktrace: fixed walk_stackframe()

Guo Ren <guoren@linux.alibaba.com>
    riscv: stacktrace: Make walk_stackframe cross pt_regs frame

Kefeng Wang <wangkefeng.wang@huawei.com>
    riscv: Cleanup stacktrace

Jiri Pirko <jiri@nvidia.com>
    virtio: delete vq in vp_find_vqs_msix() when request_irq() fails

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    arm64: asm-bug: Add .align 2 to the end of __BUG_ENTRY

Aaron Conole <aconole@redhat.com>
    openvswitch: Set the skbuff pkt_type for proper pmtud support.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix shift-out-of-bounds in dctcp_update_alpha().

Sagi Grimberg <sagi@grimberg.me>
    params: lift param_set_uint_minmax to common code

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix memleak in seg6_hmac_init_algo

Dan Aloni <dan.aloni@vastdata.com>
    rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL

Dan Aloni <dan.aloni@vastdata.com>
    sunrpc: fix NFSACL RPC retry on soft mount

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2552: Add TX path for capturing AUDIO-OUT data

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix uninit-value in nci_rx_work

Masahiro Yamada <masahiroy@kernel.org>
    x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: bd71828: Don't overwrite runtime voltages

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid confusing "transmit timed out" message

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid recursive cec_claim_log_addrs

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-adap.c: drop activate_cnt, use state info instead

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: use call_op and check for !unregistered

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: correctly pass on reply results

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: abort if the current transmit was canceled

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: call enable_adap on s_log_addrs

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: fix a deadlock situation

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: core headers: fix kernel-doc warnings

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-api: add locking in cec_release()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-adap: always cancel work in cec_transmit_msg_fh

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for __switch_mm

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp

Dongliang Mu <mudongliangabcd@gmail.com>
    media: flexcop-usb: fix sanity check of bNumEndpoints

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: clean up endpoint sanity checks

Azeem Shaikh <azeemshaikh38@gmail.com>
    scsi: qla2xxx: Replace all non-returning strlcpy() with strscpy()

Dan Carpenter <dan.carpenter@linaro.org>
    media: stk1160: fix bounds checking in stk1160_copy_video()

Michael Walle <mwalle@kernel.org>
    drm/bridge: tc358775: fix support for jeida-18 and jeida-24

Johannes Berg <johannes.berg@intel.com>
    um: vector: fix bpfflash parameter evaluation

Roberto Sassu <roberto.sassu@huawei.com>
    um: Add winch to winch_handlers before registering winch IRQ

Duoming Zhou <duoming@zju.edu.cn>
    um: Fix return value in ubd_init()

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Always flush the slave INTF on the CTL

Fenglin Wu <quic_fenglinw@quicinc.com>
    Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Fix ITAPDLY for HS400 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add ITAPDLYSEL in sdhci_j721e_4bit_set_clock

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add OTAP/ITAP delay enable

Vignesh Raghavendra <vigneshr@ti.com>
    mmc: sdhci_am654: Drop lookup for deprecated ti,otap-del-sel

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Write ITAPDLY for DDR52 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add tuning algorithm for delay chain

Karel Balej <balejk@matfyz.cz>
    Input: ioc3kbd - add device table

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    Input: ioc3kbd - convert to platform remove callback returning void

Arnd Bergmann <arnd@arndb.de>
    Input: ims-pcu - fix printf string overflow

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of nvme dump block

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of len fields in nvme reipl block

Ian Rogers <irogers@google.com>
    perf stat: Don't display metric header for non-leader uncore events

Ian Rogers <irogers@google.com>
    libsubcmd: Fix parse-options memory leak

Wolfram Sang <wsa+renesas@sang-engineering.com>
    serial: sh-sci: protect invalidating RXDMA on shutdown

Chao Yu <chao@kernel.org>
    f2fs: compress: don't allow unaligned truncation on released compress inode

Chao Yu <chao@kernel.org>
    f2fs: fix to release node block count in error path of f2fs_new_node_page()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock

Ian Rogers <irogers@google.com>
    perf report: Avoid SEGV in report__setup_sample_type()

Ian Rogers <irogers@google.com>
    perf ui browser: Avoid SEGV on title

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_LOCATE_DSM with PCI Firmware r3.3

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_DPC_ENABLE_DSM with PCI Firmware r3.3

Randy Dunlap <rdunlap@infradead.org>
    extcon: max8997: select IRQ_DOMAIN instead of depending on it

Ian Rogers <irogers@google.com>
    perf ui browser: Don't save pointer to stack memory

Ian Rogers <irogers@google.com>
    perf ui: Update use of pthread mutex

yaowenbin <yaowenbin1@huawei.com>
    perf top: Fix TUI exit screen refresh race condition

He Zhe <zhe.he@windriver.com>
    perf bench internals inject-build-id: Fix trap divide when collecting just one DSO

Huai-Yuan Liu <qq810974084@gmail.com>
    ppdev: Add an error check in register_device

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ppdev: Remove usage of the deprecated ida_simple_xx() API

Dan Carpenter <dan.carpenter@linaro.org>
    stm class: Fix a double free in stm_register_device()

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Clear uac pointer when freed.

Miklos Szeredi <mszeredi@redhat.com>
    ovl: remove upper umask handling from ovl_create_upper()

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix unassigned instruction op (discovered by MemorySanitizer)

Michal Simek <michal.simek@amd.com>
    microblaze: Remove early printk call from cpuinfo-static.c

Michal Simek <michal.simek@amd.com>
    microblaze: Remove gcc flag for non existing early_printk.c file

Marco Pagani <marpagan@redhat.com>
    fpga: region: add owner module and take its refcount

Russ Weight <russell.h.weight@intel.com>
    fpga: region: Use standard dev_release for class driver

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    docs: driver-api: fpga: avoid using UTF-8 chars

Russ Weight <russell.h.weight@intel.com>
    fpga: region: Rename dev to parent for parent device

Tom Rix <trix@redhat.com>
    fpga: region: change FPGA indirect article to an

Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>
    iio: pressure: dps310: support negative temperature values

Chao Yu <chao@kernel.org>
    f2fs: fix to check pinfile flag in f2fs_move_file_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to relocate check condition in f2fs_fallocate()

Jinyoung CHOI <j-young.choi@samsung.com>
    f2fs: fix typos in comments

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: do not allow partial truncation on pinned file

Chao Yu <chao@kernel.org>
    f2fs: fix to force keeping write barrier for strict fsync mode

Chao Yu <chao@kernel.org>
    f2fs: add cp_error check in f2fs_write_compressed_pages

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: introduce FI_COMPRESS_RELEASED instead of using IMMUTABLE bit

Chao Yu <chao@kernel.org>
    f2fs: compress: remove unneeded preallocation

Chao Yu <chao@kernel.org>
    f2fs: compress: clean up parameter of __f2fs_cluster_blocks()

Daeho Jeong <daehojeong@google.com>
    f2fs: add compress_mode mount option

Chao Yu <chao@kernel.org>
    f2fs: compress: support chksum

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: add proper sched.h include for sched_set_fifo()

Arnd Bergmann <arnd@arndb.de>
    greybus: arche-ctrl: move device table to its right location

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Fix bitwise types

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Update uart_driver_registered on driver removal

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Lock port->lock when calling uart_handle_cts_change()

Arnd Bergmann <arnd@arndb.de>
    firmware: dmi-id: add a release callback function

Chen Ni <nichen@iscas.ac.cn>
    dmaengine: idma64: Add check for dma_set_max_seg_size

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix invalid PDI offset

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Get rid of duplicate --group option item

Martin Liška <mliska@suse.cz>
    perf annotate: Add --demangle and --demangle-kernel

Chao Yu <chao@kernel.org>
    f2fs: fix to wait on page writeback in __clone_blkaddrs()

Rui Miguel Silva <rmfrfs@gmail.com>
    greybus: lights: check return of get_channel_from_mode

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Add missing libgen.h header needed for using basename()

Ian Rogers <irogers@google.com>
    perf record: Delete session after stopping sideband thread

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evlist: Use the right prefix for 'struct evlist' sideband thread methods

Vitalii Bursov <vitaly@bursov.com>
    sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level

Eric Dumazet <edumazet@google.com>
    af_packet: do not call packet_read_pending() from tpacket_destruct_skb()

Eric Dumazet <edumazet@google.com>
    netrom: fix possible dead-lock in nr_rt_ioctl()

Chris Lew <quic_clew@quicinc.com>
    net: qrtr: ns: Fix module refcnt

Qinglang Miao <miaoqinglang@huawei.com>
    net: qrtr: fix null-ptr-deref in qrtr_ns_remove

Leon Romanovsky <leon@kernel.org>
    RDMA/IPoIB: Fix format truncation compilation errors

Edward Liaw <edliaw@google.com>
    selftests/kcmp: remove unused open mode

Gautam Menghani <gautammenghani201@gmail.com>
    selftests/kcmp: Make the test output consistent and clear

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix gss_free_in_token_pages()

Dan Carpenter <dan.carpenter@linaro.org>
    ext4: fix potential unnitialized variable

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: remove unused parameter from ext4_mb_new_blocks_simple()

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: try all groups in ext4_mb_new_blocks_simple

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: fix unit mismatch in ext4_mb_new_blocks_simple

Kemeng Shi <shikemeng@huaweicloud.com>
    ext4: simplify calculation of blkoff in ext4_mb_new_blocks_simple

Aleksandr Aprelkov <aaprelkov@usergate.com>
    sunrpc: removed redundant procp check

Jan Kara <jack@suse.cz>
    ext4: avoid excessive credit estimate in ext4_tmpfile()

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map

Marc Gonzalez <mgonzalez@freebox.fr>
    clk: qcom: mmcc-msm8998: fix venus clock issue

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Modify the print level of CQE error

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Use complete parentheses in macros

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: Fix return value in hns_roce_map_mr_sg

Wenpeng Liang <liangwenpeng@huawei.com>
    RDMA/hns: Fix incorrect symbol types

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Create QP with selected QPN for bank load balance

Xi Wang <wangxi11@huawei.com>
    RDMA/hns: Refactor the hns_roce_buf allocation flow

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/mipi-dsi: use correct return type for the DSC functions

Marek Vasut <marex@denx.de>
    drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: tc358775: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611: Don't log an error when DSI host can't be found

Steven Rostedt <rostedt@goodmis.org>
    ASoC: tracing: Export SND_SOC_DAPM_DIR_OUT to its value

Aleksandr Mishin <amishin@t-argos.ru>
    drm: vc4: Fix possible null pointer dereference

Huai-Yuan Liu <qq810974084@gmail.com>
    drm/arm/malidp: fix a possible null pointer dereference

Zhipeng Lu <alexious@zju.edu.cn>
    media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries

Randy Dunlap <rdunlap@infradead.org>
    fbdev: sh7760fb: allow modular build

Aleksandr Mishin <amishin@t-argos.ru>
    drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference

Ricardo Ribalda <ribalda@chromium.org>
    media: radio-shark2: Avoid led_names truncations

Aleksandr Burakov <a.burakov@rosalinux.ru>
    media: ngene: Add dvb_ca_en50221_init return value check

Arnd Bergmann <arnd@arndb.de>
    fbdev: sisfb: hide unused variables

Arnd Bergmann <arnd@arndb.de>
    powerpc/fsl-soc: hide unused const variable

Justin Green <greenjustin@chromium.org>
    drm/mediatek: Add 0 size check to mtk_drm_gem_obj

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: vclk: fix calculation of 59.94 fractional rates

Arnd Bergmann <arnd@arndb.de>
    fbdev: shmobile: fix snprintf truncation

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    mtd: rawnand: hynix: fixed typo

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Disable route checks for Skylake boards

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: soc-acpi: add helper to identify parent driver.

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix potential index out of bounds in color transformation function

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Discard command completions in internal error

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix invalid unregister error path

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix incorrect unregister order

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: add missing seg6_local_exit

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix overwriting ct original tuple for ICMPv6

Eric Dumazet <edumazet@google.com>
    net: usb: smsc95xx: stop lying about skb->truesize

Breno Leitao <leitao@debian.org>
    af_unix: Fix data races in unix_release_sock/unix_stream_sendmsg

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: cortina: Locking fixes

Jakub Kicinski <kuba@kernel.org>
    eth: sungem: remove .ndo_poll_controller to avoid deadlocks

gaoxingwang <gaoxingwang1@huawei.com>
    net: ipv6: fix wrong start position when receive hop-by-hop fragment

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix reboot hang on Mac IIci

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Fix spinlock race in kernel thread creation

Eric Dumazet <edumazet@google.com>
    net: usb: sr9700: stop lying about skb->truesize

Eric Dumazet <edumazet@google.com>
    usb: aqc111: stop lying about skb->truesize

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwl8k: initialize cmd->addr[] properly

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: qedf: Ensure the copied buf is NUL terminated

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: bfa: Ensure the copied buf is NUL terminated

Chen Ni <nichen@iscas.ac.cn>
    HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors

John Hubbard <jhubbard@nvidia.com>
    selftests/binderfs: use the Makefile's rules, not Make's implicit rules

Guenter Roeck <linux@roeck-us.net>
    Revert "sh: Handle calling csum_partial with misaligned data"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: ar5523: enable proper endpoint verification

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: carl9170: add a proper sanity check for endpoints

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"

Eric Dumazet <edumazet@google.com>
    net: give more chances to rcu in netdev_wait_allrefs_any()

Eric Dumazet <edumazet@google.com>
    tcp: avoid premature drops in tcp_add_backlog()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: populate board data for WCN3990

Su Hui <suhui@nfschina.com>
    wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()

Ard Biesheuvel <ardb@kernel.org>
    x86/purgatory: Switch to the position-independent small code model

Yuri Karpov <YKarpov@ispras.ru>
    scsi: hpsa: Fix allocation size for Scsi_Host private data

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix the failure of adding phy with zero-address to port

Gabriel Krisman Bertazi <krisman@suse.de>
    udp: Avoid call to compute_score on multiple sites

Lorenz Bauer <lmb@isovalent.com>
    net: remove duplicate reuseport_lookup functions

Lorenz Bauer <lmb@isovalent.com>
    net: export inet_lookup_reuseport and inet6_lookup_reuseport

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: exit() callback is optional

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Rearrange locking in cpufreq_remove_dev()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Split cpufreq_offline()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Reorganize checks in cpufreq_offline()

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix umount cgroup2 error in test_sockmap

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix "ignore unlock failures after withdraw"

Arnd Bergmann <arnd@arndb.de>
    ACPI: disable -Wstringop-truncation

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/loongson-pch-msi: Fix off-by-one on allocation error path

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/alpine-msi: Fix off-by-one in allocation error path

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling interrupts

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing CGC enable

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing unipro mode

Abel Vesa <abel.vesa@linaro.org>
    scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: ufs-qcom: Fix the Qcom register name for offset 0xD0

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US

Ziqi Chen <ziqichen@codeaurora.org>
    scsi: ufs-qcom: Fix ufs RST_n spec violation

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing reset bit

Arnd Bergmann <arnd@arndb.de>
    qed: avoid truncating work queue length

Guixiong Wei <weiguixiong@bytedance.com>
    x86/boot: Ignore relocations in .notes sections in walk_relocs() too

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: poll service ready message before failing

Yu Kuai <yukuai3@huawei.com>
    md: fix resync softlockup when bitmap size is less than array size

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix missing mutex_destroy() at module removal

Chun-Kuang Hu <chunkuang.hu@kernel.org>
    soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE

Ilya Denisyev <dev@elkcl.ru>
    jffs2: prevent xattr node from overflowing the eraseblock

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix tracepoint subchannel type field

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha256-avx2 - add missing vzeroupper

Eric Biggers <ebiggers@google.com>
    crypto: x86/nh-avx2 - add missing vzeroupper

Arnd Bergmann <arnd@arndb.de>
    crypto: ccp - drop platform ifdef checks

Al Viro <viro@zeniv.linux.org.uk>
    parisc: add missing export of __cmpxchg_u8()

Arnd Bergmann <arnd@arndb.de>
    nilfs2: fix out-of-range warning

Brian Kubisiak <brian@kubisiak.com>
    ecryptfs: Fix buffer size for tag 66 packet

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    firmware: raspberrypi: Use correct device for DMA mappings

Aleksandr Mishin <amishin@t-argos.ru>
    crypto: bcm - Fix pointer arithmetic

Eric Sandeen <sandeen@redhat.com>
    openpromfs: finish conversion to the new mount API

Nilay Shroff <nilay@linux.ibm.com>
    nvme: find numa distance only if controller has valid numa id

Lancelot SIX <lancelot.six@amd.com>
    drm/amdkfd: Flush the process wq before creating a kfd_process

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: da7219-aad: fix usage of device_get_named_child_node()

Jack Yu <jack.yu@realtek.com>
    ASoC: rt715: add vendor clear control register

Krzysztof Kozlowski <krzk@kernel.org>
    regulator: vqmmc-ipq4019: fix module autoloading

Derek Fang <derek.fang@realtek.com>
    ASoC: dt-bindings: rt5645: add cbj sleeve gpio property

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5645: Fix the electric noise due to the CBJ contacts floating

Joshua Ashton <joshua@froggi.es>
    drm/amd/display: Set color_mgmt_changed to true on unsuspend

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FN920C04 compositions

Igor Artemiev <Igor.A.Artemiev@mcst.ru>
    wifi: cfg80211: fix the order of arguments for trace events of the tx_rx_evt class

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix NULL module pointer assignment at card init

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential hang in nilfs_detach_log_writer()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix unexpected freezing of nilfs_segctor_sync()

Thorsten Blum <thorsten.blum@toblux.com>
    net: smc91x: Fix m68k kernel compilation for ColdFire CPU

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Fix a race between readers and resize checks

Ken Milmore <ken.milmore@gmail.com>
    r8169: Fix possible ring buffer corruption on fragmented Tx packets.

Dan Carpenter <dan.carpenter@linaro.org>
    speakup: Fix sizeof() vs ARRAY_SIZE() bug

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix possible out-of-bounds in gsm0_receive()

Daniel J Blueman <daniel@quora.org>
    x86/tsc: Trust initial offset in architectural TSC-adjust MSRs


-------------

Diffstat:

 Documentation/devicetree/bindings/sound/rt5645.txt |   6 +
 Documentation/driver-api/fpga/fpga-bridge.rst      |  10 +-
 Documentation/driver-api/fpga/fpga-mgr.rst         |  12 +-
 Documentation/driver-api/fpga/fpga-programming.rst |   8 +-
 Documentation/driver-api/fpga/fpga-region.rst      |  35 ++-
 Documentation/filesystems/f2fs.rst                 |  36 +++
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   2 +-
 arch/arm64/boot/dts/nvidia/tegra132-norrin.dts     |   4 +-
 arch/arm64/boot/dts/nvidia/tegra132.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi           |   2 +-
 arch/arm64/include/asm/asm-bug.h                   |   1 +
 arch/arm64/kvm/guest.c                             |   1 +
 arch/m68k/kernel/entry.S                           |   4 +-
 arch/m68k/mac/misc.c                               |  36 +--
 arch/microblaze/kernel/Makefile                    |   1 -
 arch/microblaze/kernel/cpu/cpuinfo-static.c        |   2 +-
 arch/parisc/kernel/parisc_ksyms.c                  |   1 +
 arch/powerpc/include/asm/hvcall.h                  |   2 +-
 arch/powerpc/include/asm/uaccess.h                 |  55 ++++
 arch/powerpc/platforms/pseries/lpar.c              |   6 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |   6 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/riscv/include/asm/stacktrace.h                |  17 ++
 arch/riscv/kernel/entry.S                          |   3 +-
 arch/riscv/kernel/perf_callchain.c                 |  10 +-
 arch/riscv/kernel/stacktrace.c                     |  36 ++-
 arch/s390/kernel/ipl.c                             |  10 +-
 arch/sh/kernel/kprobes.c                           |   7 +-
 arch/sh/lib/checksum.S                             |  67 ++---
 arch/sparc/include/asm/smp_64.h                    |   2 -
 arch/sparc/include/uapi/asm/termbits.h             |  10 -
 arch/sparc/include/uapi/asm/termios.h              |   9 +
 arch/sparc/kernel/prom_64.c                        |   4 +-
 arch/sparc/kernel/setup_64.c                       |   1 -
 arch/sparc/kernel/smp_64.c                         |  14 -
 arch/um/drivers/line.c                             |  14 +-
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/drivers/vector_kern.c                      |   2 +-
 arch/um/include/asm/mmu.h                          |   2 -
 arch/um/include/shared/skas/mm_id.h                |   2 +
 arch/x86/Kconfig.debug                             |   5 +-
 arch/x86/crypto/nh-avx2-x86_64.S                   |   1 +
 arch/x86/crypto/sha256-avx2-asm.S                  |   1 +
 arch/x86/entry/vsyscall/vsyscall_64.c              |  28 +-
 arch/x86/include/asm/processor.h                   |   1 -
 arch/x86/kernel/apic/vector.c                      |   9 +-
 arch/x86/kernel/tsc_sync.c                         |   6 +-
 arch/x86/lib/x86-opcode-map.txt                    |   2 +-
 arch/x86/mm/fault.c                                |  27 +-
 arch/x86/purgatory/Makefile                        |   3 +-
 arch/x86/tools/relocs.c                            |   9 +
 crypto/ecrdsa.c                                    |   1 +
 drivers/accessibility/speakup/main.c               |   2 +-
 drivers/acpi/acpica/Makefile                       |   1 +
 drivers/acpi/resource.c                            |  12 +
 drivers/android/binder.c                           |   4 +-
 drivers/ata/pata_legacy.c                          |   8 +-
 drivers/block/null_blk/main.c                      |   3 +
 drivers/char/ppdev.c                               |  21 +-
 drivers/clk/qcom/mmcc-msm8998.c                    |   8 +
 drivers/cpufreq/cpufreq.c                          |  85 +++---
 drivers/crypto/bcm/spu2.c                          |   2 +-
 drivers/crypto/ccp/sp-platform.c                   |  14 +-
 drivers/crypto/qat/qat_common/adf_aer.c            |  19 +-
 drivers/dma-buf/sync_debug.c                       |   4 +-
 drivers/dma/idma64.c                               |   4 +-
 drivers/extcon/Kconfig                             |   3 +-
 drivers/firmware/dmi-id.c                          |   7 +-
 drivers/firmware/raspberrypi.c                     |   7 +-
 drivers/fpga/dfl-fme-region.c                      |  17 +-
 drivers/fpga/dfl.c                                 |  12 +-
 drivers/fpga/fpga-region.c                         | 145 +++++-----
 drivers/fpga/of-fpga-region.c                      |  10 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |   8 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   5 +
 drivers/gpu/drm/arm/malidp_mw.c                    |   5 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   3 +
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   6 +-
 drivers/gpu/drm/bridge/tc358775.c                  |  27 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   3 +
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |   3 -
 drivers/gpu/drm/panel/panel-simple.c               |   3 +
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   2 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   5 +
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwtracing/intel_th/pci.c                   |   5 +
 drivers/hwtracing/stm/core.c                       |  11 +-
 drivers/iio/pressure/dps310.c                      |  11 +-
 drivers/infiniband/hw/hns/hns_roce_alloc.c         | 128 +++++----
 drivers/infiniband/hw/hns/hns_roce_cmd.c           |  10 +-
 drivers/infiniband/hw/hns/hns_roce_cmd.h           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_common.h        |  14 +-
 drivers/infiniband/hw/hns/hns_roce_db.c            |   8 +-
 drivers/infiniband/hw/hns/hns_roce_device.h        | 115 ++++----
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  12 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c         |   8 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  35 +--
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  65 ++---
 drivers/infiniband/hw/hns/hns_roce_qp.c            | 129 +++++++--
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   8 +-
 drivers/input/misc/ims-pcu.c                       |   4 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   7 +-
 drivers/input/serio/ioc3kbd.c                      |  13 +-
 drivers/irqchip/irq-alpine-msi.c                   |   2 +-
 drivers/irqchip/irq-loongson-pch-msi.c             |   2 +-
 drivers/macintosh/via-macii.c                      |  11 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/md/raid5.c                                 |  15 +-
 drivers/media/cec/core/cec-adap.c                  | 291 +++++++++++++--------
 drivers/media/cec/core/cec-api.c                   |  31 +--
 drivers/media/cec/core/cec-core.c                  |   7 +-
 drivers/media/cec/core/cec-pin-priv.h              |  11 +
 drivers/media/cec/core/cec-pin.c                   |  23 +-
 drivers/media/cec/core/cec-priv.h                  |  10 +
 drivers/media/dvb-frontends/lgdt3306a.c            |   5 +
 drivers/media/dvb-frontends/mxl5xx.c               |  22 +-
 drivers/media/mc/mc-devnode.c                      |   5 +-
 drivers/media/pci/ngene/ngene-core.c               |   4 +-
 drivers/media/radio/radio-shark2.c                 |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |  12 +-
 drivers/media/usb/stk1160/stk1160-video.c          |  20 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   3 +
 drivers/mmc/core/host.c                            |   3 +-
 drivers/mmc/core/slot-gpio.c                       |  20 ++
 drivers/mmc/host/sdhci-acpi.c                      |  48 +++-
 drivers/mmc/host/sdhci_am654.c                     | 205 ++++++++++-----
 drivers/mtd/nand/raw/nand_hynix.c                  |   2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |  12 +
 drivers/net/ethernet/cortina/gemini.c              |  12 +-
 drivers/net/ethernet/freescale/fec_main.c          |  10 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   3 +-
 drivers/net/ethernet/smsc/smc91x.h                 |   4 +-
 drivers/net/ethernet/sun/sungem.c                  |  14 -
 drivers/net/ipvlan/ipvlan_core.c                   |   4 +-
 drivers/net/usb/aqc111.c                           |   8 +-
 drivers/net/usb/qmi_wwan.c                         |   3 +
 drivers/net/usb/smsc95xx.c                         |  26 +-
 drivers/net/usb/sr9700.c                           |  10 +-
 drivers/net/vxlan/vxlan_core.c                     |   4 -
 drivers/net/wireless/ath/ar5523/ar5523.c           |  14 +
 drivers/net/wireless/ath/ath10k/core.c             |   3 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  26 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  32 +++
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |  21 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |  79 ++----
 drivers/nvme/host/multipath.c                      |   3 +-
 drivers/nvme/target/configfs.c                     |   8 +
 drivers/pci/pcie/edr.c                             |  28 +-
 drivers/regulator/bd71828-regulator.c              |  58 +---
 drivers/regulator/vqmmc-ipq4019-regulator.c        |   1 +
 drivers/s390/cio/trace.h                           |   2 +-
 drivers/s390/crypto/ap_bus.c                       |   2 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   4 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |   3 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   2 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   8 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |  20 +-
 drivers/scsi/ufs/cdns-pltfrm.c                     |   2 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  31 ++-
 drivers/scsi/ufs/ufs-qcom.h                        |  21 +-
 drivers/scsi/ufs/ufshcd.c                          |   4 +-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   5 +-
 drivers/soundwire/cadence_master.c                 |   2 +-
 drivers/spi/spi-stm32.c                            |   2 +-
 drivers/spi/spi.c                                  |   4 +
 drivers/staging/greybus/arche-apb-ctrl.c           |   1 +
 drivers/staging/greybus/arche-platform.c           |   9 +-
 drivers/staging/greybus/light.c                    |   8 +-
 drivers/staging/media/atomisp/pci/sh_css.c         |   1 +
 drivers/tty/n_gsm.c                                |   8 +-
 drivers/tty/serial/max3100.c                       |  22 +-
 drivers/tty/serial/sc16is7xx.c                     |   2 +-
 drivers/tty/serial/sh-sci.c                        |   5 +
 drivers/usb/gadget/function/u_audio.c              |   2 +
 drivers/video/fbdev/Kconfig                        |   4 +-
 drivers/video/fbdev/savage/savagefb_driver.c       |   5 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   2 +-
 drivers/video/fbdev/sis/init301.c                  |   3 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/rti_wdt.c                         |  34 ++-
 fs/afs/mntpt.c                                     |   5 +
 fs/ecryptfs/keystore.c                             |   4 +-
 fs/ext4/mballoc.c                                  | 134 +++++-----
 fs/ext4/namei.c                                    |   2 +-
 fs/ext4/xattr.c                                    |   4 +-
 fs/f2fs/checkpoint.c                               |   4 +-
 fs/f2fs/compress.c                                 |  91 +++----
 fs/f2fs/data.c                                     |  10 +-
 fs/f2fs/extent_cache.c                             |   4 +-
 fs/f2fs/f2fs.h                                     |  52 +++-
 fs/f2fs/file.c                                     |  86 ++++--
 fs/f2fs/inode.c                                    |   9 +
 fs/f2fs/namei.c                                    |   2 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |   4 +-
 fs/f2fs/super.c                                    |  32 +++
 fs/gfs2/glock.c                                    |   4 +-
 fs/gfs2/util.c                                     |   1 -
 fs/jffs2/xattr.c                                   |   3 +
 fs/nfs/internal.h                                  |   4 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/segment.c                                |  63 ++++-
 fs/openpromfs/inode.c                              |   8 +-
 fs/overlayfs/dir.c                                 |   3 -
 include/drm/drm_mipi_dsi.h                         |   6 +-
 include/linux/f2fs_fs.h                            |   3 +-
 include/linux/fpga/fpga-region.h                   |  43 ++-
 include/linux/mmc/slot-gpio.h                      |   1 +
 include/linux/moduleparam.h                        |   2 +
 include/media/cec.h                                |  26 +-
 include/media/v4l2-h264.h                          |   6 +-
 include/media/v4l2-jpeg.h                          |   2 +
 include/net/dst_ops.h                              |   2 +-
 include/net/inet6_hashtables.h                     |  16 ++
 include/net/inet_hashtables.h                      |  18 +-
 include/net/netfilter/nf_tables.h                  |   2 +
 include/net/sock.h                                 |  13 +-
 include/sound/soc-acpi.h                           |   6 +
 include/trace/events/asoc.h                        |   2 +
 include/uapi/linux/cec.h                           |   3 +-
 include/uapi/linux/v4l2-subdev.h                   |  12 +-
 include/uapi/linux/videodev2.h                     |  15 +-
 io_uring/io_uring.c                                |   2 +
 kernel/bpf/verifier.c                              |  10 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/debug/kdb/kdb_io.c                          |  99 ++++---
 kernel/irq/cpuhotplug.c                            |  16 +-
 kernel/params.c                                    |  18 ++
 kernel/sched/topology.c                            |   2 +-
 kernel/trace/ring_buffer.c                         |   9 +
 net/9p/client.c                                    |   2 +
 net/core/dev.c                                     |   3 +-
 net/ipv4/inet_hashtables.c                         |  29 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +
 net/ipv4/route.c                                   |  22 +-
 net/ipv4/tcp_dctcp.c                               |  13 +-
 net/ipv4/tcp_ipv4.c                                |  13 +-
 net/ipv4/udp.c                                     |  55 ++--
 net/ipv6/inet6_hashtables.c                        |  27 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/ipv6/route.c                                   |  34 +--
 net/ipv6/seg6.c                                    |   5 +-
 net/ipv6/seg6_hmac.c                               |  42 ++-
 net/ipv6/udp.c                                     |  61 +++--
 net/netfilter/nf_tables_api.c                      |  22 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +
 net/netfilter/nft_payload.c                        |  23 +-
 net/netfilter/nft_tunnel.c                         |   1 +
 net/netrom/nr_route.c                              |  19 +-
 net/nfc/nci/core.c                                 |  17 +-
 net/openvswitch/actions.c                          |   6 +
 net/openvswitch/flow.c                             |   3 +-
 net/packet/af_packet.c                             |   3 +-
 net/qrtr/af_qrtr.c                                 |  16 +-
 net/qrtr/ns.c                                      |  34 ++-
 net/qrtr/qrtr.h                                    |   2 +-
 net/sunrpc/auth_gss/svcauth_gss.c                  |  12 +-
 net/sunrpc/clnt.c                                  |   1 +
 net/sunrpc/svc.c                                   |   2 -
 net/sunrpc/xprtrdma/verbs.c                        |   6 +-
 net/sunrpc/xprtsock.c                              |  18 --
 net/tls/tls_main.c                                 |  10 +-
 net/unix/af_unix.c                                 |   2 +-
 net/wireless/trace.h                               |   4 +-
 net/xfrm/xfrm_policy.c                             |  11 +-
 scripts/kconfig/symbol.c                           |   6 +-
 sound/core/init.c                                  |   2 +-
 sound/core/timer.c                                 |  10 +
 sound/soc/codecs/da7219-aad.c                      |   6 +-
 sound/soc/codecs/rt5645.c                          |  25 ++
 sound/soc/codecs/rt715-sdw.c                       |   1 +
 sound/soc/codecs/tas2552.c                         |  15 +-
 sound/soc/intel/boards/bxt_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/bxt_rt298.c                 |   1 +
 sound/soc/intel/boards/glk_rt5682_max98357a.c      |   2 +
 sound/soc/intel/boards/kbl_da7219_max98357a.c      |   1 +
 sound/soc/intel/boards/kbl_da7219_max98927.c       |   4 +
 sound/soc/intel/boards/kbl_rt5660.c                |   1 +
 sound/soc/intel/boards/kbl_rt5663_max98927.c       |   2 +
 .../soc/intel/boards/kbl_rt5663_rt5514_max98927.c  |   1 +
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   2 +
 sound/soc/intel/boards/skl_nau88l25_max98357a.c    |   1 +
 sound/soc/intel/boards/skl_rt286.c                 |   1 +
 tools/arch/x86/lib/x86-opcode-map.txt              |   2 +-
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/lib/subcmd/parse-options.c                   |   8 +-
 tools/perf/Documentation/perf-annotate.txt         |   7 +
 tools/perf/bench/inject-buildid.c                  |   2 +-
 tools/perf/builtin-annotate.c                      |   6 +-
 tools/perf/builtin-record.c                        |   8 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-top.c                           |   4 +-
 tools/perf/ui/browser.c                            |  26 +-
 tools/perf/ui/browser.h                            |   2 +-
 tools/perf/ui/browsers/annotate.c                  |   2 +-
 tools/perf/ui/setup.c                              |   5 +-
 tools/perf/ui/tui/helpline.c                       |   5 +-
 tools/perf/ui/tui/progress.c                       |   8 +-
 tools/perf/ui/tui/setup.c                          |  12 +-
 tools/perf/ui/tui/util.c                           |  18 +-
 tools/perf/ui/ui.h                                 |   4 +-
 tools/perf/util/bpf-event.c                        |   2 +-
 tools/perf/util/evlist.h                           |  11 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   2 +
 tools/perf/util/intel-pt.c                         |   2 +
 tools/perf/util/probe-event.c                      |   1 +
 tools/perf/util/sideband_evlist.c                  |   8 +-
 tools/perf/util/stat-display.c                     |   3 +
 tools/testing/selftests/bpf/test_sockmap.c         |   2 +-
 .../selftests/filesystems/binderfs/Makefile        |   2 -
 tools/testing/selftests/kcmp/kcmp_test.c           |   8 +-
 328 files changed, 2834 insertions(+), 1844 deletions(-)


