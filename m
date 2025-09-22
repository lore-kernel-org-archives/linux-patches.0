Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5643222590;
	Mon, 22 Sep 2025 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570096; cv=none; b=BMFUB7n8SVtxdkE0FqK8NOlkzDhJsfHnbTDYsu8xwoEHce+2SERIUUVJ2VTwGqRbIYjNc5HWPtw6qA6R98qpPJSQU4eoISROpoZhlMsRqdeNjI85DX1WbVcwSGpBjtcI54+Vh+6YF2pXmOIAuGECsmllhLBjmU9bYIL4DThM3X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570096; c=relaxed/simple;
	bh=nXuz/QVyrIlLRFO6hRa6JMB1iiLNs6PwTwVGsezziYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z5CBN7nL7a5TPVQBcEqQCWSzc8iK85IveIbBiU5d8S5EKgpg1rN7/LkrUX7rHj6Nzwhb5U8fH38cC8YRLpK1gs/HadvbumMJQ+fdLAyNP5dXoEEgy5w95lH0CBNg6JwXm84mZSSgWbA8C636lpBXwhZl7y0pfEUO3wxtt7SJDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dt2DYZti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dt2DYZti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BD8C4CEF0;
	Mon, 22 Sep 2025 19:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570096;
	bh=nXuz/QVyrIlLRFO6hRa6JMB1iiLNs6PwTwVGsezziYU=;
	h=From:To:Cc:Subject:Date:From;
	b=Dt2DYZtiwy4LIwq3j1ZnTV6/KfnLGsZQ7DNTkqCBfKhgJPoRFKg4UUiBbpDoqXh9H
	 KYMUjqC1clVWqeXTbTrFcpZyXmPR9m5HXQXaZlkJtefk2JB4RjKqdwGMUwQM0SDj9b
	 f1vilza2DMKPYq8skVckUJE7EODYJDKibrcy+7ZA=
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
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 000/149] 6.16.9-rc1 review
Date: Mon, 22 Sep 2025 21:28:20 +0200
Message-ID: <20250922192412.885919229@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.9-rc1
X-KernelTest-Deadline: 2025-09-24T19:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.9 release.
There are 149 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.9-rc1

SeongJae Park <sj@kernel.org>
    samples/damon/prcl: avoid starting DAMON before initialization

Chen-Yu Tsai <wens@csie.org>
    clk: sunxi-ng: mp: Fix dual-divider clock rate readback

SeongJae Park <sj@kernel.org>
    samples/damon/mtier: avoid starting DAMON before initialization

Honggyu Kim <honggyu.kim@sk.com>
    samples/damon: change enable parameters to enabled

SeongJae Park <sj@kernel.org>
    samples/damon/prcl: fix boot time enable crash

Alex Elder <elder@riscstar.com>
    dt-bindings: serial: 8250: move a constraint

Yixun Lan <dlan@gentoo.org>
    dt-bindings: serial: 8250: spacemit: set clocks property as required

Frank Li <Frank.Li@nxp.com>
    dt-bindings: serial: 8250: allow clock 'uartclk' and 'reg' for nxp,lpc1850-uart

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: nl: announce deny-join-id0 flag

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: asus-wmi: Re-add extra keys to ignore_key_wlan quirk

Antheas Kapenekakis <lkml@antheas.dev>
    platform/x86: asus-wmi: Fix ROG button mapping, tablet mode on ASUS ROG Z13

Yang Xiuwei <yangxiuwei@kylinos.cn>
    io_uring: fix incorrect io_kiocb reference in io_link_skb

Stefan Metzmacher <metze@samba.org>
    smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix file open check in __cifs_unlink()

Jens Axboe <axboe@kernel.dk>
    io_uring/msg_ring: kill alloc_cache for io_kiocb allocations

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Set merge to zero early in af_alg_sendmsg

Stefan Metzmacher <metze@samba.org>
    smb: client: let smbd_destroy() call disable_work_sync(&info->post_send_credits_work)

Stefan Metzmacher <metze@samba.org>
    smb: client: use disable[_delayed]_work_sync in smbdirect.c

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix filename matching of deferred files

Stefan Metzmacher <metze@samba.org>
    smb: client: let recv_done verify data_offset, data_length and remaining_data_length

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of struct smbdirect_recv_io

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: introduce struct smbdirect_recv_io

Stefan Metzmacher <metze@samba.org>
    smb: client: make use of smbdirect_socket->recv_io.expected

Stefan Metzmacher <metze@samba.org>
    smb: smbdirect: introduce smbdirect_socket.recv_io.expected

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/guc: Set RCS/CCS yield policy

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe/guc: Enable extended CAT error reporting

Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
    drm/xe: Fix error handling if PXP fails to start

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: qcom: Fix false-positive address space check

Dan Carpenter <dan.carpenter@linaro.org>
    drm/xe: Fix a NULL vs IS_ERR() in xe_vm_add_compute_exec_queue()

Qi Xi <xiqi2@huawei.com>
    drm: bridge: cdns-mhdp8546: Fix missing mutex unlock on error path

Loic Poulain <loic.poulain@oss.qualcomm.com>
    drm: bridge: anx7625: Fix NULL pointer dereference with early IRQ

Michal Wajdeczko <michal.wajdeczko@intel.com>
    drm/xe/pf: Drop rounddown_pow_of_two fair LMEM limitation

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/tile: Release kobject for the failure path

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Fix incorrect retrival of acp_chip_info

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Fix alias device DTE setting

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: catpt: Expose correct bit depth to userspace

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Fix return value in sdca_regmap_mbq_size()

Colin Ian King <colin.i.king@gmail.com>
    ASoC: SOF: Intel: hda-stream: Fix incorrect variable used in error message

Dan Carpenter <dan.carpenter@linaro.org>
    ASoC: codec: sma1307: Fix memory corruption in sma1307_setting_loaded()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8974: Correct PLL rate rounding

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct typo in control name

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: wm8940: Correct PLL rate rounding

Praful Adiga <praful.adiga@gmail.com>
    ALSA: hda/realtek: Fix mute led for HP Laptop 15-dw4xx

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: avoid spurious errors on TCP disconnect

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: connect: catch IO errors on listen side

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: propagate shutdown to subflows when possible

Håkon Bugge <haakon.bugge@oracle.com>
    rds: ib: Increment i_fastreg_wrs before bailing out

Borislav Petkov (AMD) <bp@alien8.de>
    crypto: ccp - Always pass in an error pointer to __sev_platform_shutdown_locked()

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    gpiolib: acpi: initialize acpi_gpio_info struct

Hans de Goede <hansg@kernel.org>
    net: rfkill: gpio: Fix crash due to dereferencering uninitialized pointer

Jens Axboe <axboe@kernel.dk>
    io_uring: include dying ring in task_work "should cancel" state

Max Kellermann <max.kellermann@ionos.com>
    io_uring/io-wq: fix `max_workers` breakage and `nr_workers` underflow

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Only restore cached manual clock settings in restore if OD enabled

Ivan Lipski <ivan.lipski@amd.com>
    drm/amd/display: Allow RX6xxx & RX7700 to invoke amdgpu_irq_get/put

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: suspend KFD and KGD user queues for S0ix

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: add proper handling for S0ix

Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
    KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active

Tom Lendacky <thomas.lendacky@amd.com>
    x86/sev: Guard sev_evict_cache() with CONFIG_AMD_MEM_ENCRYPT

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-uhs2: Fix calling incorrect sdhci_set_clock() function

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci-pci-gli: GL9767: Fix initializing the UHS-II interface during a power-on

Ben Chuang <ben.chuang@genesyslogic.com.tw>
    mmc: sdhci: Move the code related to setting the clock from sdhci_set_ios_common() into sdhci_set_ios()

Thomas Fourier <fourier.thomas@gmail.com>
    mmc: mvsdio: Fix dma_unmap_sg() nents value

Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
    ASoC: qcom: q6apm-lpass-dais: Fix missing set_fmt DAI op for I2S

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ASoC: qcom: q6apm-lpass-dais: Fix NULL pointer dereference if source graph failed

Mohammad Rafi Shaik <mohammad.rafi.shaik@oss.qualcomm.com>
    ASoC: qcom: audioreach: Fix lpaif_type configuration for the I2S interface

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: SDCA: Add quirk for incorrect function types for 3 systems

Qu Wenruo <wqu@suse.com>
    btrfs: tree-checker: fix the incorrect inode ref size check

Niklas Schnelle <schnelle@linux.ibm.com>
    iommu/s390: Make attach succeed when the device was surprise removed

Matthew Rosato <mjrosato@linux.ibm.com>
    iommu/s390: Fix memory corruption when using identity domain

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd/pgtbl: Fix possible race while increase page table level

Zhen Ni <zhen.ni@easystack.cn>
    iommu/amd: Fix ivrs_base memleak in early_amd_iommu_init()

Eugene Koira <eugkoira@amazon.com>
    iommu/vt-d: Fix __domain_mapping()'s usage of switch_to_super_page()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Fix VM migration failure with PTW enabled

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_pch_pic_regs_access()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_sw_status_access()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_regs_access()

Bibo Mao <maobibo@loongson.cn>
    LoongArch: KVM: Avoid copy_*_user() with lock hold in kvm_eiointc_ctrl_access()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Handle jump tables options for RUST

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Make LTO case independent in Makefile

Tao Cui <cuitao@kylinos.cn>
    LoongArch: Check the return value when creating kobj

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Align ACPI structures if ARCH_STRICT_ALIGN enabled

Guangshuo Li <202321181@mail.sdu.edu.cn>
    LoongArch: vDSO: Check kcalloc() result in init_vdso()

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix unreliable stack for live patching

Tiezhu Yang <yangtiezhu@loongson.cn>
    objtool/LoongArch: Mark special atomic instruction as INSN_BUG type

Tiezhu Yang <yangtiezhu@loongson.cn>
    objtool/LoongArch: Mark types based on break immediate code

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Update help info of ARCH_STRICT_ALIGN

Hugh Dickins <hughd@google.com>
    mm: folio_may_be_lru_cached() unless folio_test_large()

Hugh Dickins <hughd@google.com>
    mm: revert "mm: vmscan.c: fix OOM on swap stress test"

Hugh Dickins <hughd@google.com>
    mm/gup: local lru_add_drain() to avoid lru_add_drain_all()

Li Zhe <lizhe.67@bytedance.com>
    gup: optimize longterm pin_user_pages() for large folio

Hugh Dickins <hughd@google.com>
    mm: revert "mm/gup: clear the LRU flag of a page before adding to LRU batch"

Hugh Dickins <hughd@google.com>
    mm/gup: check ref_count instead of lru before migration

Mikulas Patocka <mpatocka@redhat.com>
    dm-stripe: fix a possible integer overflow

Mikulas Patocka <mpatocka@redhat.com>
    dm-raid: don't set io_min and io_opt for raid1

austinchang <austinchang@synology.com>
    btrfs: initialize inode::file_extent_tree after i_mode has been set

Andrea Righi <arighi@nvidia.com>
    Revert "sched_ext: Skip per-CPU tasks in scx_bpf_reenqueue_local()"

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: restrict no-battery detection to bq27000

H. Nikolaus Schaller <hns@goldelico.com>
    power: supply: bq27xxx: fix error return in case of no bq27000 hdq battery

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg

Nathan Chancellor <nathan@kernel.org>
    nilfs2: fix CFI failure when accessing /sys/fs/nilfs2/features/*

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: fix slot write race condition

Stefan Metzmacher <metze@samba.org>
    ksmbd: smbdirect: verify remaining_data_length respects max_fragmented_recv_size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: smbdirect: validate data_offset and data_length field of smb_direct_data_transfer

Duoming Zhou <duoming@zju.edu.cn>
    octeontx2-pf: Fix use-after-free bugs in otx2_sync_tstamp()

Duoming Zhou <duoming@zju.edu.cn>
    cnic: Fix use-after-free bugs in cnic_delete_task

Alexey Nepomnyashih <sdl@nppct.ru>
    net: liquidio: fix overflow in octeon_init_instr_queue()

Eric Dumazet <edumazet@google.com>
    net: clear sk->sk_ino in sk_set_socket(sk, NULL)

Tariq Toukan <tariqt@nvidia.com>
    Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"

Jakub Kicinski <kuba@kernel.org>
    tls: make sure to abort the stream if headers are bogus

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Clear tcp_sk(sk)->fastopen_rsk in tcp_disconnect().

Sathesh B Edara <sedara@marvell.com>
    octeon_ep: fix VF MAC address lifecycle handling

Hangbin Liu <liuhangbin@gmail.com>
    bonding: don't set oif to bond dev when getting NS target destination

Lama Kayal <lkayal@nvidia.com>
    net/mlx5e: Add a miss level for ipsec crypto offload

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: Harden uplink netdev access against device unbind

Remy D. Farley <one-d-wide@protonmail.com>
    doc/netlink: Fix typos in operation attributes

Kohei Enju <enjuk@amazon.com>
    igc: don't fail igc_probe() on LED setup error

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: destroy aci.lock later within ixgbe_remove path

Jedrzej Jagielski <jedrzej.jagielski@intel.com>
    ixgbe: initialize aci.lock before it's used

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    i40e: remove redundant memory barrier when cleaning Tx descs

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix Rx page leak on multi-buffer frames

Yeounsu Moon <yyyynoom@gmail.com>
    net: natsemi: fix `rx_dropped` double accounting on `netif_rx()` failure

Geliang Tang <geliang@kernel.org>
    selftests: mptcp: sockopt: fix error messages

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: tfo: record 'deny join id0' info

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: userspace pm: validate deny-join-id0 flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: set remote_deny_join_id0 on SYN recv

Hangbin Liu <liuhangbin@gmail.com>
    bonding: set random address only when slaves already exist

Ilya Maximets <i.maximets@ovn.org>
    net: dst_metadata: fix IP_DF bit not extracted from tunnel headers

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qed: Don't collect too many protection override GRC elements

Kamal Heib <kheib@redhat.com>
    octeon_ep: Validate the VF ID

David Howells <dhowells@redhat.com>
    rxrpc: Fix untrusted unsigned subtract

David Howells <dhowells@redhat.com>
    rxrpc: Fix unhandled errors in rxgk_verify_packet_integrity()

Ivan Vecera <ivecera@redhat.com>
    dpll: fix clock quality level reporting

Anderson Nascimento <anderson@allelesecurity.com>
    net/tcp: Fix a NULL pointer dereference when using TCP-AO with TCP_REPAIR

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix buffer pool seeding for control traffic

Li Tian <litian@redhat.com>
    net/mlx5: Not returning mlx5_link_info table when speed is unknown

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix FD copy size in os_rcv_fd_msg()

Miaoqian Lin <linmq006@gmail.com>
    um: virtio_uml: Fix use-after-free after put_device in probe

Stefan Metzmacher <metze@samba.org>
    smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES

Geert Uytterhoeven <geert+renesas@glider.be>
    pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch

Liao Yuanhong <liaoyuanhong@vivo.com>
    wifi: mac80211: fix incorrect type for ret

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: increase scan_ies_len for S1G

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: do not add non-sta wcid entries to the poll list

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-motu: drop EPOLLOUT from poll return values as write is not supported

Christoph Hellwig <hch@lst.de>
    nvme: fix PI insert on write

Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>
    wifi: wilc1000: avoid buffer overflow in WID string configuration

Ian Rogers <irogers@google.com>
    perf maps: Ensure kmap is set up for all inserts

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix incorrect ASSERT in btrfs_zoned_reserve_data_reloc_bg()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix invalid extref key setup when replaying dentry

Chen Ridong <chenridong@huawei.com>
    cgroup: split cgroup_destroy_wq into 3 workqueues


-------------

Diffstat:

 Documentation/devicetree/bindings/serial/8250.yaml |  77 ++++++---
 Documentation/netlink/specs/conntrack.yaml         |   9 +-
 Documentation/netlink/specs/mptcp_pm.yaml          |   4 +-
 Makefile                                           |   4 +-
 arch/loongarch/Kconfig                             |  12 +-
 arch/loongarch/Makefile                            |  15 +-
 arch/loongarch/include/asm/acenv.h                 |   7 +-
 arch/loongarch/include/asm/kvm_mmu.h               |  20 ++-
 arch/loongarch/kernel/env.c                        |   2 +
 arch/loongarch/kernel/stacktrace.c                 |   3 +-
 arch/loongarch/kernel/vdso.c                       |   3 +
 arch/loongarch/kvm/intc/eiointc.c                  |  87 ++++++----
 arch/loongarch/kvm/intc/pch_pic.c                  |  21 ++-
 arch/loongarch/kvm/mmu.c                           |   8 +-
 arch/s390/include/asm/pci_insn.h                   |  10 +-
 arch/um/drivers/virtio_uml.c                       |   6 +-
 arch/um/os-Linux/file.c                            |   2 +-
 arch/x86/include/asm/sev.h                         |  38 ++---
 arch/x86/kvm/svm/svm.c                             |   3 +-
 crypto/af_alg.c                                    |  10 +-
 drivers/block/zram/zram_drv.c                      |   8 +-
 drivers/clk/sunxi-ng/ccu_mp.c                      |   2 +-
 drivers/crypto/ccp/sev-dev.c                       |   2 +-
 drivers/dpll/dpll_netlink.c                        |   4 +-
 drivers/gpio/gpiolib-acpi-core.c                   |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |  12 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  24 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  36 ++++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  39 ++++-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   2 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |   6 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   6 +-
 drivers/gpu/drm/xe/abi/guc_actions_abi.h           |   5 +
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h              |  40 +++++
 drivers/gpu/drm/xe/xe_exec_queue.c                 |  22 ++-
 drivers/gpu/drm/xe/xe_exec_queue_types.h           |   8 +-
 drivers/gpu/drm/xe/xe_execlist.c                   |  25 ++-
 drivers/gpu/drm/xe/xe_execlist_types.h             |   2 +-
 drivers/gpu/drm/xe/xe_gt.c                         |   3 +-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c         |   1 -
 drivers/gpu/drm/xe/xe_guc.c                        |  62 ++++++-
 drivers/gpu/drm/xe/xe_guc.h                        |   1 +
 drivers/gpu/drm/xe/xe_guc_exec_queue_types.h       |   4 +-
 drivers/gpu/drm/xe/xe_guc_submit.c                 | 141 +++++++++++++---
 drivers/gpu/drm/xe/xe_guc_submit.h                 |   2 +
 drivers/gpu/drm/xe/xe_tile_sysfs.c                 |  12 +-
 drivers/gpu/drm/xe/xe_uc.c                         |   4 +
 drivers/gpu/drm/xe/xe_vm.c                         |   4 +-
 drivers/iommu/amd/amd_iommu_types.h                |   1 +
 drivers/iommu/amd/init.c                           |   9 +-
 drivers/iommu/amd/io_pgtable.c                     |  25 ++-
 drivers/iommu/intel/iommu.c                        |   7 +-
 drivers/iommu/s390-iommu.c                         |  29 +++-
 drivers/md/dm-raid.c                               |   6 +-
 drivers/md/dm-stripe.c                             |  10 +-
 drivers/mmc/host/mvsdio.c                          |   2 +-
 drivers/mmc/host/sdhci-pci-gli.c                   |  68 +++++++-
 drivers/mmc/host/sdhci-uhs2.c                      |   3 +-
 drivers/mmc/host/sdhci.c                           |  34 ++--
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/ethernet/broadcom/cnic.c               |   3 +-
 .../net/ethernet/cavium/liquidio/request_manager.c |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   3 -
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  80 ++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   1 -
 drivers/net/ethernet/intel/igc/igc.h               |   1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  22 +--
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  16 ++
 .../ethernet/marvell/octeon_ep/octep_pfvf_mbox.c   |   3 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   1 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  27 ++-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   6 +-
 drivers/net/ethernet/natsemi/ns83820.c             |  13 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   7 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   2 +-
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |  39 +++--
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.h |   5 +-
 drivers/nvme/host/core.c                           |  18 +-
 drivers/pcmcia/omap_cf.c                           |   8 +-
 drivers/platform/x86/asus-nb-wmi.c                 |  25 ++-
 drivers/platform/x86/asus-wmi.h                    |   3 +-
 drivers/power/supply/bq27xxx_battery.c             |   4 +-
 fs/btrfs/delayed-inode.c                           |   3 -
 fs/btrfs/inode.c                                   |  11 +-
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/zoned.c                                   |   2 +-
 fs/nilfs2/sysfs.c                                  |   4 +-
 fs/nilfs2/sysfs.h                                  |   8 +-
 fs/smb/client/cifsproto.h                          |   4 +-
 fs/smb/client/inode.c                              |  23 ++-
 fs/smb/client/misc.c                               |  36 ++--
 fs/smb/client/smbdirect.c                          | 132 +++++++++------
 fs/smb/client/smbdirect.h                          |  23 ---
 fs/smb/common/smbdirect/smbdirect_socket.h         |  29 ++++
 fs/smb/server/transport_rdma.c                     | 185 ++++++++++++++-------
 include/crypto/if_alg.h                            |  10 +-
 include/linux/io_uring_types.h                     |   3 -
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/swap.h                               |  10 ++
 include/net/dst_metadata.h                         |  11 +-
 include/net/sock.h                                 |   5 +-
 include/sound/sdca.h                               |   1 +
 include/uapi/linux/mptcp.h                         |   2 +
 include/uapi/linux/mptcp_pm.h                      |   4 +-
 io_uring/io-wq.c                                   |   6 +-
 io_uring/io_uring.c                                |  10 +-
 io_uring/io_uring.h                                |   4 +-
 io_uring/msg_ring.c                                |  24 +--
 io_uring/notif.c                                   |   2 +-
 io_uring/poll.c                                    |   2 +-
 io_uring/timeout.c                                 |   2 +-
 io_uring/uring_cmd.c                               |   2 +-
 kernel/cgroup/cgroup.c                             |  43 ++++-
 kernel/sched/ext.c                                 |   6 +-
 mm/gup.c                                           |  52 ++++--
 mm/mlock.c                                         |   6 +-
 mm/swap.c                                          |  50 +++---
 mm/vmscan.c                                        |   2 +-
 net/ipv4/tcp.c                                     |   5 +
 net/ipv4/tcp_ao.c                                  |   4 +-
 net/mac80211/driver-ops.h                          |   2 +-
 net/mac80211/main.c                                |   7 +-
 net/mptcp/options.c                                |   6 +-
 net/mptcp/pm_netlink.c                             |   7 +
 net/mptcp/protocol.c                               |  16 ++
 net/mptcp/subflow.c                                |   4 +
 net/rds/ib_frmr.c                                  |  20 ++-
 net/rfkill/rfkill-gpio.c                           |   4 +-
 net/rxrpc/rxgk.c                                   |  18 +-
 net/rxrpc/rxgk_app.c                               |  29 +++-
 net/rxrpc/rxgk_common.h                            |  14 +-
 net/tls/tls.h                                      |   1 +
 net/tls/tls_strp.c                                 |  14 +-
 net/tls/tls_sw.c                                   |   3 +-
 samples/damon/mtier.c                              |  25 +--
 samples/damon/prcl.c                               |  31 +++-
 samples/damon/wsse.c                               |  22 +--
 sound/firewire/motu/motu-hwdep.c                   |   2 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/acp/acp-i2s.c                        |  11 +-
 sound/soc/codecs/sma1307.c                         |   7 +-
 sound/soc/codecs/wm8940.c                          |   9 +-
 sound/soc/codecs/wm8974.c                          |   8 +-
 sound/soc/intel/catpt/pcm.c                        |  23 ++-
 sound/soc/qcom/qdsp6/audioreach.c                  |   1 +
 sound/soc/qcom/qdsp6/q6apm-lpass-dais.c            |   7 +-
 sound/soc/sdca/sdca_device.c                       |  20 +++
 sound/soc/sdca/sdca_functions.c                    |  13 +-
 sound/soc/sdca/sdca_regmap.c                       |   2 +-
 sound/soc/sof/intel/hda-stream.c                   |   2 +-
 sound/usb/qcom/qc_audio_offload.c                  |  92 +++++-----
 tools/arch/loongarch/include/asm/inst.h            |  12 ++
 tools/objtool/arch/loongarch/decode.c              |  33 +++-
 tools/perf/util/maps.c                             |   9 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  11 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |  16 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   7 +
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  14 +-
 169 files changed, 1797 insertions(+), 824 deletions(-)


