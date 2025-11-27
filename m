Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96A7273816;
	Thu, 27 Nov 2025 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254911; cv=none; b=rPBvG1ZdSTzI0Kki9RauVCq33Abz5/VsRj16Cm3T8/BvcsVUFdMy4E2iJXoGgYMhA5EjvXsvWWL3A0zQvjyCeoXBVYHAvHa5ENyW1cPOOminSfRv6uKJDV/rUX4R7uhJay7IRtismk8tp/qTs7pjFhCVlwpUPG1gDWsFc6SFfDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254911; c=relaxed/simple;
	bh=cH5iqkWu/pYiNkhQ3lQADlYUTCgPgULJrNAZNLuMjwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hj2xikGvMGYX9h7J41GO+dye6ASaXMeEd4dZPOVDke0PtTr7iSpXXPyUJVNQF0k67MlYqXHxH2pgqC0Tdq12BkEriKar0mnH6RfM155bqpuBa7b5hqVgEhNNARdqCI+x5qQ+zb/w1fokDBvEeQFa9ihW9WBszrXtbHX/DkqEoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7NPDkZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7NPDkZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1007C4CEF8;
	Thu, 27 Nov 2025 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254911;
	bh=cH5iqkWu/pYiNkhQ3lQADlYUTCgPgULJrNAZNLuMjwU=;
	h=From:To:Cc:Subject:Date:From;
	b=F7NPDkZgx3uzkQyi9V5DdSZqvfgSxqGXEAv9XdaV1NE3F1C6UUNwi7N9crowdh0+d
	 Nb9P5wtQh1FmWR7HnZo8CFa34cNT7j8+E+fCzQ5R+wDH8Gs1FiYKy7uGntJN1oNcje
	 fqOu2V0296DHxe2+sFWmZ3QsPQgGQ3vTM1PSKbUo=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.6 00/86] 6.6.118-rc1 review
Date: Thu, 27 Nov 2025 15:45:16 +0100
Message-ID: <20251127144027.800761504@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.118-rc1
X-KernelTest-Deadline: 2025-11-29T14:40+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.118 release.
There are 86 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.118-rc1

Eric Dumazet <edumazet@google.com>
    mptcp: fix a race in mptcp_pm_del_add_timer()

Vlastimil Babka <vbabka@suse.cz>
    mm/mempool: fix poisoning order>0 pages with HIGHMEM

Fabio M. De Francesco <fabio.maria.de.francesco@linux.intel.com>
    mm/mempool: replace kmap_atomic() with kmap_local_page()

Mario Limonciello (AMD) <superm1@kernel.org>
    HID: amd_sfh: Stop sensor before starting

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: endpoints: longer transfer

Miaoqian Lin <linmq006@gmail.com>
    pmdomain: imx: Fix reference count leak in imx_gpc_remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pmdomain: imx-gpc: Convert to platform remove callback returning void

Sudeep Holla <sudeep.holla@arm.com>
    pmdomain: arm: scmi: Fix genpd leak on provider registration failure

Song Liu <song@kernel.org>
    ftrace: Fix BPF fexit with livepatch

Sourabh Jain <sourabhjain@linux.ibm.com>
    crash: fix crashkernel resource shrink

Alexander Wetzel <Alexander@wetzel-home.de>
    wifi: cfg80211: Add missing lock in cfg80211_check_and_end_cac()

Martin Kaiser <martin@kaiser.cx>
    maple_tree: fix tracepoint string pointers

Long Li <longli@microsoft.com>
    uio_hv_generic: Set event for all channels on the device

Sebastian Ene <sebastianene@google.com>
    KVM: arm64: Check the untrusted offset in FF-A memory share

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix incomplete backport in cfids_invalidation_worker()

Zhang Chujun <zhangchujun@cmss.chinamobile.com>
    tracing/tools: Fix incorrcet short option in usage text for --threads

Nishanth Menon <nm@ti.com>
    net: ethernet: ti: netcp: Standardize knav_dma_open_channel to return NULL on error

René Rebe <rene@exactco.de>
    ALSA: usb-audio: fix uac2 clock source at terminal parser

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: compress: fix UAF of f2fs_inode_info in f2fs_free_dic

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Fix __ptep_rdp() inline assembly

Zhiguo Niu <zhiguo.niu@unisoc.com>
    f2fs: compress: change the first parameter of page_array_{alloc,free} to sbi

Jakub Horký <jakub.git@horky.net>
    kconfig/nconf: Initialize the default locale at startup

Jakub Horký <jakub.git@horky.net>
    kconfig/mconf: Initialize the default locale at startup

Shahar Shitrit <shshitrit@nvidia.com>
    net: tls: Cancel RX async resync request on rcd_delta overflow

Po-Hsu Lin <po-hsu.lin@canonical.com>
    selftests: net: use BASH for bareudp testing

Borislav Petkov (AMD) <bp@alien8.de>
    x86/microcode/AMD: Limit Entrysign signature checking to known generations

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a regression triggered by scsi_host_busy()

Steve French <stfrench@microsoft.com>
    cifs: fix typo in enable_gcm_256 module parameter

Rafał Miłecki <rafal@milecki.pl>
    bcma: don't register devices disabled in OF

Michal Luczaj <mhal@rbox.co>
    vsock: Ignore signal/timeout on connect() if already established

Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
    cifs: fix memory leak in smb3_fs_context_parse_param error path

Thomas Weißschuh <linux@weissschuh.net>
    LoongArch: Use UAPI types in ptrace UAPI header

Pradyumn Rahar <pradyumn.rahar@oracle.com>
    net/mlx5: Clean up only new IRQ glue on request_irq() failure

Shay Drory <shayd@nvidia.com>
    devlink: rate: Unset parent pointer in devl_rate_nodes_destroy

Jared Kangas <jkangas@redhat.com>
    pinctrl: s32cc: initialize gpio_pin_config::list after kmalloc()

Jared Kangas <jkangas@redhat.com>
    pinctrl: s32cc: fix uninitialized memory in s32_pinctrl_desc

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()

Alejandro Colomar <alx@kernel.org>
    kernel.h: Move ARRAY_SIZE() to a separate header

Haotian Zhang <vulab@iscas.ac.cn>
    platform/x86/intel/speed_select_if: Convert PCIBIOS_* return codes to errnos

Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
    s390/ctcm: Fix double-kfree

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvme-multipath: fix lockdep WARN due to partition scan work

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove never-working support for setting nsh fields

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    net: dsa: hellcreek: fix missing error handling in LED registration

Prateek Agarwal <praagarwal@nvidia.com>
    drm/tegra: Add call to put_pid()

Zilin Guan <zilin@seu.edu.cn>
    mlxsw: spectrum: Fix memory leak in mlxsw_sp_flower_stats()

Haotian Zhang <vulab@iscas.ac.cn>
    pinctrl: cirrus: Fix fwnode leak in cs42l43_pin_probe()

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Prevent locally generated packets from direct output in tunnel mode

Jianbo Liu <jianbol@nvidia.com>
    xfrm: Determine inner GSO type from packet inner protocol

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Move sleep into each retry for retrieve_link_cap()

Mario Limonciello (AMD) <superm1@kernel.org>
    drm/amd/display: Increase DPCD read retries

Yifan Zha <Yifan.Zha@amd.com>
    drm/amdgpu: Skip emit de meta data on gfx11 with rs64 enabled

Ma Ke <make24@iscas.ac.cn>
    drm/tegra: dc: Fix reference leak in tegra_dc_couple()

Paolo Abeni <pabeni@redhat.com>
    mptcp: do not fallback when OoO is present

Paolo Abeni <pabeni@redhat.com>
    mptcp: decouple mptcp fastclose from tcp close

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded subflow-level drops

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix premature close in case of fallback

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix ack generation for fallback msk

Eric Dumazet <edumazet@google.com>
    mptcp: fix race condition in mptcp_schedule_work()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Don't panic if no valid cache info for PCI

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: pinctrl: toshiba,visconti: Fix number of items in groups

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Malta: Fix !EVA SOC-it PCI MMIO

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    scsi: target: tcm_loop: Fix segfault in tcm_loop_tpg_address_show()

Bart Van Assche <bvanassche@acm.org>
    scsi: sg: Do not sleep in atomic context

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: Ensure ->ioerr_work is cancelled in nvme_fc_delete_ctrl()

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: move tagset removal to nvme_fc_delete_ctrl()

Nam Cao <namcao@linutronix.de>
    nouveau/firmware: Add missing kfree() of nvkm_falcon_fw::boot

Seungjin Bae <eeodqql09@gmail.com>
    Input: pegasus-notetaker - fix potential out-of-bounds access

Dan Carpenter <dan.carpenter@linaro.org>
    Input: imx_sc_key - fix memory corruption on unload

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - add support for ACPI ID GDIX1003

Tzung-Bi Shih <tzungbi@kernel.org>
    Input: cros_ec_keyb - fix an invalid memory access

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    Revert "drm/tegra: dsi: Clear enable register if powered by bootloader"

Oleksij Rempel <o.rempel@pengutronix.de>
    net: dsa: microchip: lan937x: Fix RGMII delay tuning

Andrey Vatoropin <a.vatoropin@crpt.ru>
    be2net: pass wrb_params in case of OS2BMC

Yihang Li <liyihang9@h-partners.com>
    ata: libata-scsi: Add missing scsi_device_put() in ata_scsi_dev_rescan()

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: introduce close_cached_dir_locked()

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Prevent a TLB shutdown on initial uniquification

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: Fix system suspend for a security locked drive

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Fix proto fallback detection with BPF

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: Disallow MPTCP subflows from sockmap

Yongpeng Yang <yangyongpeng@xiaomi.com>
    exfat: check return value of sb_min_blocksize in exfat_read_boot_sector

Mike Yuan <me@yhndnzj.com>
    shmem: fix tmpfs reconfiguration (remount) when noswap is set

Dan Carpenter <dan.carpenter@linaro.org>
    mtdchar: fix integer overflow in read/write ioctls

Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
    mtd: rawnand: cadence: fix DMA device NULL pointer dereference

Zhang Heng <zhangheng@kylinos.cn>
    HID: quirks: work around VID/PID conflict for 0x4c4a/0x4155

Yipeng Zou <zouyipeng@huawei.com>
    timers: Fix NULL function pointer race in timer_shutdown_sync()


-------------

Diffstat:

 .../bindings/pinctrl/toshiba,visconti-pinctrl.yaml |  26 +++---
 Makefile                                           |   4 +-
 arch/arm64/kvm/hyp/nvhe/ffa.c                      |   9 +-
 arch/loongarch/include/uapi/asm/ptrace.h           |  40 ++++----
 arch/loongarch/pci/pci.c                           |   8 +-
 arch/mips/mm/tlb-r4k.c                             | 102 +++++++++++++--------
 arch/mips/mti-malta/malta-init.c                   |  20 ++--
 arch/s390/include/asm/pgtable.h                    |  12 +--
 arch/s390/mm/pgtable.c                             |   4 +-
 arch/x86/kernel/cpu/microcode/amd.c                |  20 +++-
 drivers/ata/libata-scsi.c                          |  11 ++-
 drivers/bcma/main.c                                |   6 ++
 drivers/firmware/arm_scmi/scmi_pm_domain.c         |  13 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c             |   4 +-
 .../display/dc/link/protocols/link_dp_capability.c |  11 ++-
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c           |   2 +
 drivers/gpu/drm/tegra/dc.c                         |   1 +
 drivers/gpu/drm/tegra/dsi.c                        |   9 --
 drivers/gpu/drm/tegra/uapi.c                       |   7 +-
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |   2 +
 drivers/hid/hid-ids.h                              |   4 +-
 drivers/hid/hid-quirks.c                           |  13 ++-
 drivers/input/keyboard/cros_ec_keyb.c              |   6 ++
 drivers/input/keyboard/imx_sc_key.c                |   2 +-
 drivers/input/tablet/pegasus_notetaker.c           |   9 ++
 drivers/input/touchscreen/goodix.c                 |   1 +
 drivers/mtd/mtdchar.c                              |   6 +-
 drivers/mtd/nand/raw/cadence-nand-controller.c     |   3 +-
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |  14 ++-
 drivers/net/dsa/microchip/lan937x_main.c           |   1 +
 drivers/net/ethernet/emulex/benet/be_main.c        |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   6 +-
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   6 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   5 +-
 drivers/net/ethernet/ti/netcp_core.c               |  10 +-
 drivers/nvme/host/fc.c                             |  15 +--
 drivers/nvme/host/multipath.c                      |   2 +-
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c           |  21 ++++-
 drivers/pinctrl/nxp/pinctrl-s32cc.c                |   3 +-
 .../x86/intel/speed_select_if/isst_if_mmio.c       |   4 +-
 drivers/pmdomain/imx/gpc.c                         |  22 +++--
 drivers/s390/net/ctcm_mpc.c                        |   1 -
 drivers/scsi/hosts.c                               |   5 +-
 drivers/scsi/sg.c                                  |  10 +-
 drivers/soc/ti/knav_dma.c                          |  14 +--
 drivers/target/loopback/tcm_loop.c                 |   3 +
 drivers/uio/uio_hv_generic.c                       |  21 ++++-
 fs/exfat/super.c                                   |   5 +-
 fs/f2fs/compress.c                                 |  74 +++++++--------
 fs/f2fs/f2fs.h                                     |   2 +
 fs/smb/client/cached_dir.c                         |  43 ++++++++-
 fs/smb/client/cifsfs.c                             |   2 +-
 fs/smb/client/fs_context.c                         |   4 +
 include/linux/array_size.h                         |  13 +++
 include/linux/ata.h                                |   1 +
 include/linux/kernel.h                             |   7 +-
 include/linux/string.h                             |   1 +
 include/net/tls.h                                  |   6 ++
 include/net/xfrm.h                                 |   3 +-
 kernel/bpf/trampoline.c                            |   4 -
 kernel/kexec_core.c                                |   2 +-
 kernel/time/timer.c                                |   7 +-
 kernel/trace/ftrace.c                              |  20 ++--
 lib/maple_tree.c                                   |  32 ++++---
 mm/mempool.c                                       |  32 +++++--
 mm/shmem.c                                         |  15 ++-
 net/devlink/rate.c                                 |   4 +-
 net/ipv4/esp4_offload.c                            |   6 +-
 net/ipv6/esp6_offload.c                            |   6 +-
 net/mptcp/options.c                                |  54 ++++++++++-
 net/mptcp/pm_netlink.c                             |  20 ++--
 net/mptcp/protocol.c                               |  48 +++++++---
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |   8 ++
 net/openvswitch/actions.c                          |  68 +-------------
 net/openvswitch/flow_netlink.c                     |  64 ++-----------
 net/openvswitch/flow_netlink.h                     |   2 -
 net/tls/tls_device.c                               |   4 +-
 net/vmw_vsock/af_vsock.c                           |  40 ++++++--
 net/wireless/reg.c                                 |   5 +
 net/xfrm/xfrm_output.c                             |   6 +-
 scripts/kconfig/mconf.c                            |   3 +
 scripts/kconfig/nconf.c                            |   3 +
 sound/usb/mixer.c                                  |   2 +-
 tools/testing/selftests/net/bareudp.sh             |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   8 +-
 tools/tracing/latency/latency-collector.c          |   2 +-
 88 files changed, 714 insertions(+), 444 deletions(-)


