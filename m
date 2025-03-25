Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24B027F4FF;
	Tue, 25 Mar 2025 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905507; cv=none; b=cuZEa7f3PBHp+99p4cLrl93ywZGWmzgxt5f3KMkHg/Bbh7sqG3YbzkPIzZpggyibCH0Cu+d+0xbnhkVhldIPIyS29WPxm6j+cJwVNswLTGFgmJvKxdETTaG2J2P5upfv/w5rUUWHxZRtSnpy3/PIJw+DW+WxzjgQEzPOBP5ALgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905507; c=relaxed/simple;
	bh=p79afl4V/qZfU/11IFid/YErsRgQNp4NOa8nY7WlvIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=imUGWF0uGaULVDweZcTg1ExZF5v+aLtKhwy1iZanfGwOGwBDfzw88Uc4fyKP9/7XzjjXqxbFIyyZ+mgyaNWC84/yJiyqmKsrVPo5cSR3qJ8d/p/w76e3YwR74sTUfXOxuptOH0DOM66ZkMrfxuXAvjE8d8Gb1YbK2xxfSH6MRb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbObo8Ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbObo8Ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB845C4CEED;
	Tue, 25 Mar 2025 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905507;
	bh=p79afl4V/qZfU/11IFid/YErsRgQNp4NOa8nY7WlvIQ=;
	h=From:To:Cc:Subject:Date:From;
	b=EbObo8AhWTOvU3uIia5sQzUn1k/Boc0QFPFYvY+Ou8OlgRZ+Z5zxZeIdJc22MXinX
	 r+gk4pk/eXGGEGRvb2NJOCzj7iG1seu41Z3/nicCTZHn8bLaoLn0ok/rHgrbKls+XA
	 aW/MPEvRsETvDfoynyipwMnX0lwPGztetYNNulJs=
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
Subject: [PATCH 6.1 000/198] 6.1.132-rc1 review
Date: Tue, 25 Mar 2025 08:19:22 -0400
Message-ID: <20250325122156.633329074@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.132-rc1
X-KernelTest-Deadline: 2025-03-27T12:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.132 release.
There are 198 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.132-rc1

Acs, Jakub <acsjakub@amazon.de>
    block, bfq: fix re-introduced UAF in bic_set_bfqq()

Zi Yan <ziy@nvidia.com>
    mm/migrate: fix shmem xarray update during migration

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: mvm: ensure offloading TID queue exists

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Change new sparse cluster processing

Vitaly Prosyak <vitaly.prosyak@amd.com>
    drm/amdgpu: fix use-after-free bug

Justin Klaassen <justin@tidylabs.net>
    arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S

Yunfei Dong <yunfei.dong@mediatek.com>
    media: mediatek: vcodec: Fix VP8 stateless decoder smatch warning

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    drm/mediatek: Fix coverity issue with unintentional integer overflow

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_counter: Use u64_stats_t for statistic.

Arthur Mongodin <amongodin@randorisec.fr>
    mptcp: Fix data stream corruption in the address announcement

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Use HW lock mgr for PSR1 when only one eDP

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix incorrect validation for num_aces field of smb_acl

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix JPEG video caps max size for navi1x and raven

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    drm/radeon: fix uninitialized size issue in radeon_vce_cs_parse()

Saranya R <quic_sarar@quicinc.com>
    soc: qcom: pdr: Fix the potential deadlock

Sven Eckelmann <sven@narfation.org>
    batman-adv: Ignore own maximum aggregation size during RX

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    xsk: fix an integer overflow in xp_create_and_assign_umem()

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: Avoid physical address 0x0 when doing random allocation

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: shmobile: smp: Enforce shmobile_smp_* alignment

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: drain obj stock on cpu hotplug teardown

Ye Bin <yebin10@huawei.com>
    proc: fix UAF in proc_get_inode()

Gu Bowen <gubowen5@huawei.com>
    mmc: atmel-mci: Add missing clk_disable_unprepare()

Kamal Dasu <kamal.dasu@broadcom.com>
    mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops

Dragan Simic <dsimic@manjaro.org>
    arm64: dts: rockchip: Add missing PCIe supplies to RockPro64 board dtsi

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    arm64: dts: freescale: imx8mm-verdin-dahlia: add Microphone Jack to sound card

Christian Eggers <ceggers@arri.de>
    regulator: check that dummy regulator has been probed before using it

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Don't run jobs that have errors flagged in its fence

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: disable transceiver during system PM

Haibo Chen <haibo.chen@nxp.com>
    can: flexcan: only change CAN state when link up in system PM

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Fix page entries in the AFL list

Andreas Kemnade <andreas@kemnade.info>
    i2c: omap: fix IRQ storms

Guillaume Nault <gnault@redhat.com>
    Revert "gre: Fix IPv6 link-local address generation."

Lin Ma <linma@zju.edu.cn>
    net/neighbor: add missing policy for NDTPA_QUEUE_LENBYTES

Justin Iurman <justin.iurman@uliege.be>
    net: lwtunnel: fix recursion loops

Dan Carpenter <dan.carpenter@linaro.org>
    net: atm: fix use after free in lec_send()

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: Fix error code in chan_alloc_skb_cb()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix wrong value of max_sge_rd

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix unmatched condition in error path of alloc_user_qp_db()

Junxian Huang <huangjunxian6@hisilicon.com>
    RDMA/hns: Fix soft lockup during bt pages loop

Saravanan Vajravel <saravanan.vajravel@broadcom.com>
    RDMA/bnxt_re: Avoid clearing VLAN_ID mask in modify qp path

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: Don't mark timer regs unconfigured

Arnd Bergmann <arnd@arndb.de>
    ARM: OMAP1: select CONFIG_GENERIC_IRQ_CHIP

Kashyap Desai <kashyap.desai@broadcom.com>
    RDMA/bnxt_re: Add missing paranthesis in map_qp_id_to_tbl_indx

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2711: PL011 UARTs are actually r1p5

Peng Fan <peng.fan@nxp.com>
    soc: imx8m: Unregister cpufreq and soc dev in cleanup path

Marek Vasut <marex@denx.de>
    soc: imx8m: Use devm_* to simplify probe failure handling

Marek Vasut <marex@denx.de>
    soc: imx8m: Remove global soc_uid

Cosmin Ratiu <cratiu@nvidia.com>
    xfrm_output: Force software GSO only in tunnel mode

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: freescale: tqma8mpql: Fix vqmmc-supply

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    firmware: imx-scu: fix OF node leak in .probe()

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential UAF in cifs_dump_full_key()

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: Fix a C2HTermReq error message

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: disable Fn key handling on the Omoton KB066

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: Fix match_session bug preventing session reuse

Steve French <stfrench@microsoft.com>
    smb3: add support for IAKerb

Zhenhua Huang <quic_zhenhuah@quicinc.com>
    arm64: mm: Populate vmemmap at the page level if not section aligned

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: sis630: Fix an error handling path in sis630_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali15x3: Fix an error handling path in ali15x3_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali1535: Fix an error handling path in ali1535_probe()

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing closetimeo mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing actimeo mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing acdirmax mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing acregmax mount option

Tamir Duberstein <tamird@gmail.com>
    scripts: generate_rust_analyzer: add missing macros deps

Martin Rodriguez Reboredo <yakoyoku@gmail.com>
    scripts: generate_rust_analyzer: provide `cfg`s for `core` and `alloc`

Vinay Varma <varmavinaym@gmail.com>
    scripts: `make rust-analyzer` for out-of-tree modules

Asahi Lina <lina@asahilina.net>
    scripts: generate_rust_analyzer: Handle sub-modules with no Makefile

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()

Ivan Abramov <i.abramov@mt-integration.ru>
    drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: ops: Consistently treat platform_max as control value

George Stark <gnstark@salutedevices.com>
    leds: mlxreg: Use devm_mutex_init() for mutex initialization

Xueming Feng <kuro@kuroa.me>
    tcp: fix forever orphan socket caused by tcp_abort

Eric Dumazet <edumazet@google.com>
    tcp: fix races in tcp_abort()

Andrii Nakryiko <andrii@kernel.org>
    lib/buildid: Handle memfd_secret() files in build_id_parse()

Matthew Maurer <mmaurer@google.com>
    rust: Disallow BTF generation with Rust + LTO

Haoxiang Li <haoxiang_li2024@163.com>
    qlcnic: fix memory leak issues in qlcnic_sriov_common.c

Thomas Mizrahi <thomasmizra@gmail.com>
    ASoC: amd: yc: Support mic on another Lenovo ThinkPad E16 Gen 2 model

Varada Pavani <v.pavani@samsung.com>
    clk: samsung: update PLL locktime for PLL142XX used on FSD platform

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix slab-use-after-free on hdcp_work

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Assign normalized_pix_clk when color depth = 14

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Restore correct backlight brightness after a GPU reset

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix locking when skipping CSN before topology probing

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/atomic: Filter out redundant DPMS calls

Florent Revest <revest@chromium.org>
    x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes

Johan Hovold <johan@kernel.org>
    USB: serial: option: match on interface class for Telit FN990B

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: fix Telit Cinterion FE990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE990B compositions

Boon Khai Ng <boon.khai.ng@intel.com>
    USB: serial: ftdi_sio: add support for Altera USB Blaster 3

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for more devices

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for several devices

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add required quirks for missing old boardnames

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for NHxxRZQ

Darrick J. Wong <djwong@kernel.org>
    xfs: remove conditional building of rt geometry validator functions

Andrey Albershteyn <aalbersh@redhat.com>
    xfs: reset XFS_ATTR_INCOMPLETE filter on node removal

Zhang Tianci <zhangtianci.1997@bytedance.com>
    xfs: update dir3 leaf block metadata after swap

Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
    xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Long Li <leo.lilong@huawei.com>
    xfs: fix perag leak when growfs fails

Long Li <leo.lilong@huawei.com>
    xfs: add lock protection when remove perag from radix tree

Dave Chinner <dchinner@redhat.com>
    xfs: initialise di_crc in xfs_log_dinode

Darrick J. Wong <djwong@kernel.org>
    xfs: force all buffers to be written during btree bulk load

Darrick J. Wong <djwong@kernel.org>
    xfs: recompute growfsrtfree transaction reservation while growing rt volume

Darrick J. Wong <djwong@kernel.org>
    xfs: remove unused fields from struct xbtree_ifakeroot

Darrick J. Wong <djwong@kernel.org>
    xfs: don't allow overly small or large realtime volumes

Darrick J. Wong <djwong@kernel.org>
    xfs: fix 32-bit truncation in xfs_compute_rextslog

Darrick J. Wong <djwong@kernel.org>
    xfs: make rextslog computation consistent with mkfs

Darrick J. Wong <djwong@kernel.org>
    xfs: don't leak recovered attri intent items

Christoph Hellwig <hch@lst.de>
    xfs: consider minlen sized extents in xfs_rtallocate_extent_block

Darrick J. Wong <djwong@kernel.org>
    xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t

Darrick J. Wong <djwong@kernel.org>
    xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h

Darrick J. Wong <djwong@kernel.org>
    xfs: reserve less log space when recovering log intent items

Dave Chinner <dchinner@redhat.com>
    xfs: use deferred frees for btree block freeing

Dave Chinner <dchinner@redhat.com>
    xfs: fix bounds check in xfs_defer_agfl_block()

Dave Chinner <dchinner@redhat.com>
    xfs: validate block number being freed before adding to xefi

Darrick J. Wong <djwong@kernel.org>
    xfs: pass per-ag references to xfs_free_extent

Darrick J. Wong <djwong@kernel.org>
    xfs: pass the xfs_bmbt_irec directly through the log intent code

Darrick J. Wong <djwong@kernel.org>
    xfs: fix confusing xfs_extent_item variable names

Darrick J. Wong <djwong@kernel.org>
    xfs: pass xfs_extent_free_item directly through the log intent code

Darrick J. Wong <djwong@kernel.org>
    xfs: pass refcount intent directly through the log intent code

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix corner case forgetting to vunmap

Jens Axboe <axboe@kernel.dk>
    io_uring: don't attempt to mmap larger than what the user asks for

Jens Axboe <axboe@kernel.dk>
    io_uring: get rid of remap_pfn_range() for mapping rings/sqes

Jens Axboe <axboe@kernel.dk>
    mm: add nommu variant of vm_insert_pages()

Jens Axboe <axboe@kernel.dk>
    io_uring: add ring freeing helper

Jens Axboe <axboe@kernel.dk>
    io_uring: return error pointer from io_mem_alloc()

Ming Lei <ming.lei@redhat.com>
    block: fix 'kmem_cache of name 'bio-108' already exists'

Thomas Zimmermann <tzimmermann@suse.de>
    drm/nouveau: Do not override forced connector status

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: safety check before fallback

Arnd Bergmann <arnd@arndb.de>
    x86/irq: Define trace events conditionally

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Use better start period for frequency mode

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't truncate cached, mutated symlink

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Set the SDOUT polarity correctly

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Fix power control mask

Hector Martin <marcan@marcan.st>
    ASoC: tas2770: Fix volume scale

Daniel Wagner <wagi@kernel.org>
    nvme: only allow entering LIVE from CONNECTING state

Yu-Chun Lin <eleanor15x@gmail.com>
    sctp: Fix undefined behavior in left shift operation

Ruozhu Li <david.li@jaguarmicro.com>
    nvmet-rdma: recheck queue state is LIVE in state lock in recv done

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: add basic support for the C2HTermReq PDU

Christopher Lentocha <christopherericlentocha@gmail.com>
    nvme-pci: quirk Acer FA100 for non-uniqueue identifiers

Stephan Gerhold <stephan.gerhold@linaro.org>
    net: wwan: mhi_wwan_mbim: Silence sequence number glitch errors

Terry Cheong <htcheong@chromium.org>
    ASoC: SOF: Intel: hda: add softdep pre to snd-hda-codec-hdmi module

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ASoC: arizona/madera: use fsleep() in up/down DAPM event delays.

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: adjust convert rate limitation

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't indicate warning on rsnd_kctrl_accept_runtime()

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on Positivo ARN50

Jan Beulich <jbeulich@suse.com>
    Xen/swiotlb: mark xen_swiotlb_fixup() __init

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/cpufreq_cooling: Remove structure member documentation

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: Fix CHPID "configure" attribute caching

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Support for V9 DYTC platform profiles

Sybil Isabel Dorsett <sybdorsett@proton.me>
    platform/x86: thinkpad_acpi: Fix invalid fan speed on ThinkPad X120e

Jann Horn <jannh@google.com>
    sched: Clarify wake_up_q()'s write to task->wake_q.next

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: fix up the F6 key on the Omoton KB066 keyboard

Ievgen Vovk <YevgenVovk@ukr.net>
    HID: hid-apple: Apple Magic Keyboard a3203 USB-C support

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: ignore non-functional sensor in HP 5MP Camera

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Send clock sync message immediately after reset

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix the length of MNG_SYNC_FW_CLOCK in doorbell

Brahmajit Das <brahmajit.xyz@gmail.com>
    vboxsf: fix building with GCC 15

Eric W. Biederman <ebiederm@xmission.com>
    alpha/elf: Fix misc/setarch test of util-linux by removing 32bit support

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix noisy when tree connecting to DFS interlink targets

Gannon Kolding <gannon.kolding@gmail.com>
    ACPI: resource: IRQ override for Eluktronics MECH-17

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix kernel oops when debug level > 2

Rik van Riel <riel@surriel.com>
    scsi: core: Use GFP_NOIO to avoid circular locking dependency

Chengen Du <chengen.du@canonical.com>
    iscsi_ibft: Fix UBSAN shift-out-of-bounds warning in ibft_attr_show_nic()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    powercap: call put_device() on an error path in powercap_register_control_type()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hrtimers: Mark is_migration_base() with __always_inline

Daniel Wagner <wagi@kernel.org>
    nvme-fc: go straight to connecting state when initializing

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5: Bridge, fix the crash caused by LAG state check

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove misbehaving actions length check

Guillaume Nault <gnault@redhat.com>
    gre: Fix IPv6 link-local address generation.

Alexey Kashavkin <akashavkin@gmail.com>
    netfilter: nft_exthdr: fix offset with ipv4_find_option()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: Prevent creation of classes with TC_H_ROOT

Dan Carpenter <dan.carpenter@linaro.org>
    ipvs: prevent integer overflow in do_ip_vs_get_ctl()

Kohei Enju <enjuk@amazon.com>
    netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix incorrect MAC address setting to receive NS messages

Amit Cohen <amcohen@nvidia.com>
    net: switchdev: Convert blocking notification chain to a raw one

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: do not update checksum in bnxt_xdp_build_skb()

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: handle errors in mlx5_chains_create_table()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't release fb_mmio resource in vmbus_free_mmio()

Michael Kelley <mhklinux@outlook.com>
    drm/hyperv: Fix address space leak when Hyper-V DRM device is removed

Breno Leitao <leitao@debian.org>
    netpoll: hold rcu read lock in __netpoll_send_skb()

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp i2c: Copy headers if cloned

Joseph Huang <Joseph.Huang@garmin.com>
    net: dsa: mv88e6xxx: Verify after ATU Load ops

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Revert "Bluetooth: hci_core: Fix sleeping function called from invalid context"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix enabling passive scanning

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: cfg80211: cancel wiphy_work before freeing wiphy

Jun Yang <juny24602@gmail.com>
    sched: address a potential NULL pointer dereference in the GRED scheduler.

Nicklas Bo Jensen <njensen@akamai.com>
    netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix memory leak in aRFS after reset

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Fix incorrect regmap max_registers value

Michael Kelley <mhklinux@outlook.com>
    fbdev: hyperv_fb: iounmap() the correct memory when removing a device

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix shift-out-of-bounds in ntfs_fill_super

Felix Moessbauer <felix.moessbauer@siemens.com>
    hrtimer: Use and report correct timerslack values for realtime tasks

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Prevent boot crash when the boot CPU is nohz_full

David Woodhouse <dwmw@amazon.co.uk>
    clockevents/drivers/i8253: Fix stop sequence for timer 0


-------------

Diffstat:

 Documentation/timers/no_hz.rst                     |   7 +-
 Makefile                                           |  15 +-
 arch/alpha/include/asm/elf.h                       |   6 +-
 arch/alpha/include/asm/pgtable.h                   |   2 +-
 arch/alpha/include/asm/processor.h                 |   8 +-
 arch/alpha/kernel/osf_sys.c                        |  11 +-
 arch/arm/boot/dts/bcm2711.dtsi                     |  11 +-
 arch/arm/mach-omap1/Kconfig                        |   1 +
 arch/arm/mach-shmobile/headsmp.S                   |   1 +
 .../boot/dts/freescale/imx8mm-verdin-dahlia.dtsi   |   6 +-
 .../arm64/boot/dts/freescale/imx8mp-tqma8mpql.dtsi |  16 +-
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi |   2 +
 arch/arm64/mm/mmu.c                                |   5 +-
 arch/x86/events/intel/core.c                       |  85 ++++++++++
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  11 --
 arch/x86/kernel/irq.c                              |   2 +
 block/bfq-cgroup.c                                 |   2 +-
 block/bio.c                                        |   2 +-
 drivers/acpi/resource.c                            |   6 +
 drivers/clk/samsung/clk-pll.c                      |   7 +-
 drivers/clocksource/i8253.c                        |  36 +++--
 drivers/firmware/efi/libstub/randomalloc.c         |   4 +
 drivers/firmware/imx/imx-scu.c                     |   1 +
 drivers/firmware/iscsi_ibft.c                      |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c             |  20 ++-
 drivers/gpu/drm/amd/amdgpu/nv.c                    |   2 +-
 drivers/gpu/drm/amd/amdgpu/soc15.c                 |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 ++
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   1 +
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   7 +-
 .../gpu/drm/amd/display/dc/dce/dmub_hw_lock_mgr.c  |  12 ++
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  40 +++--
 drivers/gpu/drm/drm_atomic_uapi.c                  |   4 +
 drivers/gpu/drm/drm_connector.c                    |   4 +
 drivers/gpu/drm/gma500/mid_bios.c                  |   5 +
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c            |   2 +
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   9 +-
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |  13 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 -
 drivers/gpu/drm/radeon/radeon_vce.c                |   2 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   9 +-
 drivers/hid/hid-apple.c                            |  13 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |  15 +-
 drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h        |   2 +
 drivers/hv/vmbus_drv.c                             |  13 ++
 drivers/i2c/busses/i2c-ali1535.c                   |  12 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |  12 +-
 drivers/i2c/busses/i2c-omap.c                      |  26 +--
 drivers/i2c/busses/i2c-sis630.c                    |  12 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   2 -
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h         |   3 +-
 drivers/infiniband/hw/hns/hns_roce_hem.c           |  16 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  10 +-
 drivers/input/serio/i8042-acpipnpio.h              | 111 +++++++------
 drivers/leds/leds-mlxreg.c                         |  16 +-
 .../mediatek/vcodec/vdec/vdec_vp8_req_if.c         |  10 +-
 drivers/mmc/host/atmel-mci.c                       |   4 +-
 drivers/mmc/host/sdhci-brcmstb.c                   |  10 ++
 drivers/net/bonding/bond_options.c                 |  55 ++++++-
 drivers/net/can/flexcan/flexcan-core.c             |  18 ++-
 drivers/net/can/rcar/rcar_canfd.c                  |  28 ++--
 drivers/net/dsa/mv88e6xxx/chip.c                   |  59 +++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   3 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   5 +
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   8 +-
 drivers/net/mctp/mctp-i2c.c                        |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  28 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   3 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   2 +-
 drivers/nvme/host/core.c                           |   2 -
 drivers/nvme/host/fc.c                             |   3 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/host/tcp.c                            |  43 +++++
 drivers/nvme/target/rdma.c                         |  33 ++--
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |   2 +-
 drivers/platform/x86/thinkpad_acpi.c               |  50 ++++--
 drivers/powercap/powercap_sys.c                    |   3 +-
 drivers/regulator/core.c                           |  12 +-
 drivers/s390/cio/chp.c                             |   3 +-
 drivers/scsi/qla1280.c                             |   2 +-
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/soc/imx/soc-imx8m.c                        | 151 ++++++++----------
 drivers/soc/qcom/pdr_interface.c                   |   8 +-
 drivers/thermal/cpufreq_cooling.c                  |   2 -
 drivers/usb/serial/ftdi_sio.c                      |  14 ++
 drivers/usb/serial/ftdi_sio_ids.h                  |  13 ++
 drivers/usb/serial/option.c                        |  48 ++++--
 drivers/video/fbdev/hyperv_fb.c                    |   2 +-
 drivers/xen/swiotlb-xen.c                          |   2 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/namei.c                                         |  24 ++-
 fs/ntfs3/attrib.c                                  | 176 ++++++++++++++-------
 fs/ntfs3/file.c                                    | 151 ++++--------------
 fs/ntfs3/frecord.c                                 |   2 +-
 fs/ntfs3/index.c                                   |   4 +-
 fs/ntfs3/inode.c                                   |  12 +-
 fs/ntfs3/ntfs_fs.h                                 |   9 +-
 fs/ntfs3/super.c                                   |  68 +++++---
 fs/proc/base.c                                     |   9 +-
 fs/proc/generic.c                                  |  10 +-
 fs/proc/inode.c                                    |   6 +-
 fs/proc/internal.h                                 |  14 ++
 fs/select.c                                        |  11 +-
 fs/smb/client/asn1.c                               |   2 +
 fs/smb/client/cifs_spnego.c                        |   4 +-
 fs/smb/client/cifsglob.h                           |   4 +
 fs/smb/client/connect.c                            |  16 +-
 fs/smb/client/fs_context.c                         |  14 +-
 fs/smb/client/ioctl.c                              |   6 +-
 fs/smb/client/sess.c                               |   3 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/server/smbacl.c                             |   5 +-
 fs/vboxsf/super.c                                  |   3 +-
 fs/xfs/libxfs/xfs_ag.c                             |  45 ++++--
 fs/xfs/libxfs/xfs_ag.h                             |   3 +
 fs/xfs/libxfs/xfs_alloc.c                          |  70 ++++----
 fs/xfs/libxfs/xfs_alloc.h                          |  20 ++-
 fs/xfs/libxfs/xfs_attr.c                           |   6 +-
 fs/xfs/libxfs/xfs_bmap.c                           | 121 +++++++-------
 fs/xfs/libxfs/xfs_bmap.h                           |   5 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                     |   8 +-
 fs/xfs/libxfs/xfs_btree_staging.c                  |   4 +-
 fs/xfs/libxfs/xfs_btree_staging.h                  |   6 -
 fs/xfs/libxfs/xfs_da_btree.c                       |   7 +
 fs/xfs/libxfs/xfs_format.h                         |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  24 ++-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   6 +-
 fs/xfs/libxfs/xfs_log_recover.h                    |  22 +++
 fs/xfs/libxfs/xfs_refcount.c                       | 116 +++++++-------
 fs/xfs/libxfs/xfs_refcount.h                       |   4 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                 |   9 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                       |   2 +
 fs/xfs/libxfs/xfs_rtbitmap.h                       |  83 ++++++++++
 fs/xfs/libxfs/xfs_sb.c                             |  20 ++-
 fs/xfs/libxfs/xfs_sb.h                             |   2 +
 fs/xfs/libxfs/xfs_types.h                          |  13 ++
 fs/xfs/scrub/repair.c                              |   3 +-
 fs/xfs/scrub/rtbitmap.c                            |   3 +-
 fs/xfs/xfs_attr_item.c                             |  16 +-
 fs/xfs/xfs_bmap_item.c                             |  85 ++++------
 fs/xfs/xfs_buf.c                                   |  44 +++++-
 fs/xfs/xfs_buf.h                                   |   1 +
 fs/xfs/xfs_extfree_item.c                          | 108 +++++++------
 fs/xfs/xfs_fsmap.c                                 |   2 +-
 fs/xfs/xfs_fsops.c                                 |   5 +-
 fs/xfs/xfs_inode_item.c                            |   3 +
 fs/xfs/xfs_refcount_item.c                         |  68 ++++----
 fs/xfs/xfs_reflink.c                               |   7 +-
 fs/xfs/xfs_rmap_item.c                             |   6 +-
 fs/xfs/xfs_rtalloc.c                               |  14 +-
 fs/xfs/xfs_rtalloc.h                               |  73 ---------
 fs/xfs/xfs_trace.h                                 |  15 +-
 include/linux/fs.h                                 |   2 +
 include/linux/i8253.h                              |   1 -
 include/linux/io_uring_types.h                     |   5 +
 include/linux/nvme-tcp.h                           |   2 +
 include/linux/proc_fs.h                            |   7 +-
 include/net/bluetooth/hci_core.h                   | 108 +++++--------
 include/sound/soc.h                                |   5 +-
 include/uapi/linux/io_uring.h                      |   1 +
 init/Kconfig                                       |   2 +-
 io_uring/io_uring.c                                | 163 ++++++++++++++++---
 io_uring/io_uring.h                                |   2 +
 kernel/sched/core.c                                |  13 +-
 kernel/sys.c                                       |   2 +
 kernel/time/hrtimer.c                              |  40 ++---
 lib/buildid.c                                      |   5 +
 mm/memcontrol.c                                    |   9 ++
 mm/migrate.c                                       |  16 +-
 mm/nommu.c                                         |   7 +
 net/atm/lec.c                                      |   3 +-
 net/batman-adv/bat_iv_ogm.c                        |   3 +-
 net/batman-adv/bat_v_ogm.c                         |   3 +-
 net/bluetooth/6lowpan.c                            |   7 +-
 net/bluetooth/hci_core.c                           |  10 +-
 net/bluetooth/hci_event.c                          |  37 +++--
 net/bluetooth/iso.c                                |   6 -
 net/bluetooth/l2cap_core.c                         |  12 +-
 net/bluetooth/rfcomm/core.c                        |   6 -
 net/bluetooth/sco.c                                |  12 +-
 net/core/lwtunnel.c                                |  65 ++++++--
 net/core/neighbour.c                               |   1 +
 net/core/netpoll.c                                 |   9 +-
 net/ipv4/tcp.c                                     |  19 ++-
 net/ipv6/route.c                                   |   5 +-
 net/mptcp/options.c                                |   6 +-
 net/mptcp/protocol.h                               |   2 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   8 +-
 net/netfilter/nf_conncount.c                       |   6 +-
 net/netfilter/nft_counter.c                        |  90 +++++------
 net/netfilter/nft_ct.c                             |   6 +-
 net/netfilter/nft_exthdr.c                         |  10 +-
 net/openvswitch/flow_netlink.c                     |  15 +-
 net/sched/sch_api.c                                |   6 +
 net/sched/sch_gred.c                               |   3 +-
 net/sctp/stream.c                                  |   2 +-
 net/switchdev/switchdev.c                          |  25 ++-
 net/wireless/core.c                                |   7 +
 net/xdp/xsk_buff_pool.c                            |   2 +-
 net/xfrm/xfrm_output.c                             |   2 +-
 rust/Makefile                                      |   7 +-
 scripts/generate_rust_analyzer.py                  |  64 ++++++--
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/arizona.c                         |  14 +-
 sound/soc/codecs/madera.c                          |  10 +-
 sound/soc/codecs/tas2764.c                         |  10 +-
 sound/soc/codecs/tas2764.h                         |   8 +-
 sound/soc/codecs/tas2770.c                         |   2 +-
 sound/soc/codecs/wm0010.c                          |  13 +-
 sound/soc/codecs/wm5110.c                          |   8 +-
 sound/soc/sh/rcar/core.c                           |  14 --
 sound/soc/sh/rcar/rsnd.h                           |   1 -
 sound/soc/sh/rcar/src.c                            | 116 +++++++++++---
 sound/soc/soc-ops.c                                |  15 +-
 sound/soc/sof/intel/hda-codec.c                    |   1 +
 227 files changed, 2513 insertions(+), 1511 deletions(-)


