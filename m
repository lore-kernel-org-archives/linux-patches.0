Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE32B17E8F5;
	Mon, 27 May 2024 19:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836432; cv=none; b=NU+LbfAonoliwu3QuFi/p/8KUwf31kG81nxjp2RCp+rqrSLYXBDz6MqyCF4VOJ35jdBWd+fRoCGnkGcothJ70R3+HgpiVvkLiMKx3QwUIpo+OQ4LbHqW/it4xnb6/Irn2kxtXFvaJFikxKzPpJRioCKMGKUrZ1I2JxCRRxHmkQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836432; c=relaxed/simple;
	bh=bGRQEaabPgeH6lGlis4zz81Sa5j1gzHgETp9JWPh4ig=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FMIu5avHp8Tw5DtyfNzViBrFS7NWO/785Q26L7PzSyBunpIhXFIsqkZMJBgGGyHgTL7Db6iAzRWF2CHpVbcW12R/podG/dfagXG3thiixI4rpZU5kAZai5vni1/k4q0iuZyf0m3x9bXoJBKl/sI/AyVwnaB+nEHggA6gPWJoK1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p5FHzSef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p5FHzSef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D83C2BBFC;
	Mon, 27 May 2024 19:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836431;
	bh=bGRQEaabPgeH6lGlis4zz81Sa5j1gzHgETp9JWPh4ig=;
	h=From:To:Cc:Subject:Date:From;
	b=p5FHzSef852p5E0xMDImvOevfyVF0BOnAZvAWO3HfGOykTOVb2MRavt1KwoSa+3/q
	 cMhkNf7S2ekPR9gnkitH7r4kAV2wL4enlUeZu4gRGQM+55G/O8/c0Loa7fSxQ4Yi7J
	 ZwMY5MAb3qcsk+kBG0DWwgwmdsDn+aPg9yyLvl9Y=
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
Subject: [PATCH 6.9 000/427] 6.9.3-rc1 review
Date: Mon, 27 May 2024 20:50:47 +0200
Message-ID: <20240527185601.713589927@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.3-rc1
X-KernelTest-Deadline: 2024-05-29T18:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.3 release.
There are 427 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 May 2024 18:53:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.3-rc1

Shuah Khan <skhan@linuxfoundation.org>
    Revert "selftests/sgx: Include KHDR_INCLUDES in Makefile"

Shuah Khan <skhan@linuxfoundation.org>
    Revert "selftests: Compile kselftest headers with -D_GNU_SOURCE"

Tom Parkin <tparkin@katalix.com>
    l2tp: fix ICMP error handling for UDP-encap sockets

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix to control VLAN strip

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: match VLAN CTAG and STAG features

Jiawen Wu <jiawenwu@trustnetic.com>
    net: wangxun: fix to change Rx features

Cheng Yu <serein.chengyu@huawei.com>
    sched/core: Fix incorrect initialization of the 'burst' parameter in cpu_max_write()

Vitalii Bursov <vitaly@bursov.com>
    sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level

Eric Dumazet <edumazet@google.com>
    af_packet: do not call packet_read_pending() from tpacket_destruct_skb()

Eric Dumazet <edumazet@google.com>
    netrom: fix possible dead-lock in nr_rt_ioctl()

Michal Schmidt <mschmidt@redhat.com>
    idpf: don't skip over ethtool tcp-data-split setting

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net/lib: no need to record ns name if it already exist

Chris Lew <quic_clew@quicinc.com>
    net: qrtr: ns: Fix module refcnt

Andrii Nakryiko <andrii@kernel.org>
    libbpf: fix feature detectors when using token_fd

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: fix vlan use-after-free

Nikolay Aleksandrov <razor@blackwall.org>
    selftests: net: bridge: increase IGMP/MLD exclude timeout membership interval

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: xmit: make sure we have at least eth header len bytes

Wang Yao <wangyao@lemote.com>
    modules: Drop the .export_symbol section from the final modules

Beau Belgrave <beaub@linux.microsoft.com>
    tracing/user_events: Fix non-spaced field matching

Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
    samples/landlock: Fix incorrect free in populate_ruleset_net

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/cma: Fix kmemleak in rdma_core observed during blktests nvme/rdma use siw

Leon Romanovsky <leon@kernel.org>
    RDMA/IPoIB: Fix format truncation compilation errors

Edward Liaw <edliaw@google.com>
    selftests/kcmp: remove unused open mode

SeongJae Park <sj@kernel.org>
    selftests/damon/_damon_sysfs: check errors from nr_schemes file reads

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix gss_free_in_token_pages()

Michal Schmidt <mschmidt@redhat.com>
    bnxt_re: avoid shift undefined behavior in bnxt_qplib_alloc_init_hwq

Sergey Shtylyov <s.shtylyov@omp.ru>
    of: module: add buffer overflow check in of_modalias()

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: apss-ipq-pll: fix PLL rate for IPQ5018

Nathan Chancellor <nathan@kernel.org>
    clk: qcom: Fix SM_GPUCC_8650 dependencies

Nathan Chancellor <nathan@kernel.org>
    clk: qcom: Fix SC_CAMCC_8280XP dependencies

Zhang Yi <yi.zhang@huawei.com>
    ext4: remove the redundant folio_wait_stable()

Dan Carpenter <dan.carpenter@linaro.org>
    ext4: fix potential unnitialized variable

Vishal Verma <vishal.l.verma@intel.com>
    dax/bus.c: use the right locking mode (read vs write) in size_show

Vishal Verma <vishal.l.verma@intel.com>
    dax/bus.c: don't use down_write_killable for non-user processes

Vishal Verma <vishal.l.verma@intel.com>
    dax/bus.c: fix locking for unregister_dax_dev / unregister_dax_mapping paths

Vishal Verma <vishal.l.verma@intel.com>
    dax/bus.c: replace WARN_ON_ONCE() with lockdep asserts

NeilBrown <neilb@suse.de>
    nfsd: don't create nfsv4recoverydir in nfsdfs when not used.

Aleksandr Aprelkov <aaprelkov@usergate.com>
    sunrpc: removed redundant procp check

Vasant Hegde <vasant.hegde@amd.com>
    iommu/amd: Enable Guest Translation after reading IOMMU feature register

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Decouple igfx_off from graphic identity mapping

David Hildenbrand <david@redhat.com>
    drivers/virt/acrn: fix PFNMAP PTE checks in acrn_vm_ram_map()

Christoph Hellwig <hch@lst.de>
    virt: acrn: stop using follow_pfn

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: boundary check before installing cq callbacks

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Use struct mana_ib_queue for CQs

Konstantin Taranov <kotaranov@microsoft.com>
    RDMA/mana_ib: Introduce helpers to create and destroy mana queues

Jan Kara <jack@suse.cz>
    ext4: avoid excessive credit estimate in ext4_tmpfile()

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Add VEX versions of VPDPBUSD, VPDPBUSDS, VPDPWSSD and VPDPWSSDS

Adrian Hunter <adrian.hunter@intel.com>
    x86/insn: Fix PUSH instruction in x86 instruction decoder opcode map

Marc Gonzalez <mgonzalez@freebox.fr>
    clk: qcom: mmcc-msm8998: fix venus clock issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8650: fix DisplayPort clocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8550: fix DisplayPort clocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm6350: fix DisplayPort clocks

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: dispcc-sm8450: fix DisplayPort clocks

Jinjiang Tu <tujinjiang@huawei.com>
    mm/ksm: fix ksm exec support for prctl

Duoming Zhou <duoming@zju.edu.cn>
    lib/test_hmm.c: handle src_pfns and dst_pfns allocation failure

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    clk: renesas: r9a07g043: Add clock and reset entry for PLIC

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: r8a779a0: Fix CANFD parent clock

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mlx5: Use __iowrite64_copy() for write combining stores

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix incorrect rxe_put in error path

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Allow good work requests to be executed

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix seg fault in rxe_comp_queue_pkt

Tudor Ambarus <tudor.ambarus@linaro.org>
    clk: samsung: gs101: propagate PERIC1 USI SPI clock rate

Tudor Ambarus <tudor.ambarus@linaro.org>
    clk: samsung: gs101: propagate PERIC0 USI SPI clock rate

Gabor Juhos <j4g8y7@gmail.com>
    clk: qcom: clk-alpha-pll: remove invalid Stromer register offset

Catalin Popescu <catalin.popescu@leica-geosystems.com>
    clk: rs9: fix wrong default value for clock amplitude

Alexandre Mergnat <amergnat@baylibre.com>
    clk: mediatek: mt8365-mm: fix DPI0 parent

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Modify the print level of CQE error

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Use complete parentheses in macros

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix GMV table pagesize

wenglianfa <wenglianfa@huawei.com>
    RDMA/hns: Fix mismatch exception rollback

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix UAF for cq async event

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix deadlock on SRQ async events.

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Add max_ah and cq moderation capacities in query_device()

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: Fix return value in hns_roce_map_mr_sg

Yi Liu <yi.l.liu@intel.com>
    iommu: Undo pasid attachment only for the devices that have succeeded

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    clk: mediatek: pllfh: Don't log error for missing fhctl node

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Adding remote atomic access flag to updatable flags

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Change check for cacheable mkeys

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Uncacheable mkey has neither rb_key or cache_ent

Jaewon Kim <jaewon02.kim@samsung.com>
    clk: samsung: exynosautov9: fix wrong pll clock id value

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: core: simplify charge_behaviour formatting

Pratyush Yadav <p.yadav@ti.com>
    media: cadence: csi2rx: configure DPHY before starting source stream

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/edid: Parse topology block for all DispID structure v1.x

Atish Patra <atishp@rivosinc.com>
    RISC-V: Fix the typo in Scountovf CSR name

Detlev Casanova <detlev.casanova@collabora.com>
    drm/rockchip: vop2: Do not divide height twice for YUV

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add quirk for Logitech Rally Bar

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/mipi-dsi: use correct return type for the DSC functions

Stefan Binding <sbinding@opensource.cirrus.com>
    ALSA: hda: cs35l41: Remove Speaker ID for Lenovo Legion slim 7 16ARHA7

Marek Vasut <marex@denx.de>
    drm/panel: simple: Add missing Innolux G121X1-L03 format, flags, connector

Hsin-Te Yuan <yuanhsinte@chromium.org>
    drm/bridge: anx7625: Update audio status while detecting

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/panel: novatek-nt35950: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: dpc3433: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: tc358775: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611uxc: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt9611: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: lt8912b: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: icn6211: Don't log an error when DSI host can't be found

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    drm/bridge: anx7625: Don't log an error when DSI host can't be found

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

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l2-subdev: Fix stream handling for crop API

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    media: i2c: et8ek8: Don't strip remove function when driver is builtin

Fabio Estevam <festevam@denx.de>
    media: dt-bindings: ovti,ov2680: Fix the power supply names

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Request IRQ earlier

Douglas Anderson <dianders@chromium.org>
    drm/msm/dp: Account for the timeout in wait_hpd_asserted() callback

Douglas Anderson <dianders@chromium.org>
    drm/msm/dp: Avoid a long timeout for AUX transfer if nothing connected

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dp: allow voltage swing / pre emphasis of 3

Armin Wolf <W_Armin@gmx.de>
    platform/x86: xiaomi-wmi: Fix race condition when reporting key events

Aleksandr Mishin <amishin@t-argos.ru>
    drm: bridge: cdns-mhdp8546: Fix possible null pointer dereference

Ricardo Ribalda <ribalda@chromium.org>
    media: radio-shark2: Avoid led_names truncations

Arnd Bergmann <arnd@arndb.de>
    media: rcar-vin: work around -Wenum-compare-conditional warning

Changhuang Liang <changhuang.liang@starfivetech.com>
    staging: media: starfive: Remove links when unregistering devices

Aleksandr Burakov <a.burakov@rosalinux.ru>
    media: ngene: Add dvb_ca_en50221_init return value check

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Test result of avs_get_module_entry()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix potential integer overflow

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix ASRC module initialization

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix debug-slot offset calculation

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: Intel: avs: Restore stream decoupling on prepare

Tianchen Ding <dtcccc@linux.alibaba.com>
    selftests: cgroup: skip test_cgcore_lesser_ns_open when cgroup2 mounted without nsdelegate

Arnd Bergmann <arnd@arndb.de>
    fbdev: sisfb: hide unused variables

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Implement firmware boot state check

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Disable interrupts when firmware boot failed

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: lnl: Correct rom_status_reg

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: mtl: Correct rom_status_reg

Arnd Bergmann <arnd@arndb.de>
    powerpc/fsl-soc: hide unused const variable

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: hda-dai: fix channel map configuration for aggregated dailink

Douglas Anderson <dianders@chromium.org>
    drm/mediatek: Init `ddp_comp` with devm_kcalloc()

Justin Green <greenjustin@chromium.org>
    drm/mediatek: Add 0 size check to mtk_drm_gem_obj

Christian Hewitt <christianshewitt@gmail.com>
    drm/meson: vclk: fix calculation of 59.94 fractional rates

Aleksandr Mishin <amishin@t-argos.ru>
    ASoC: kirkwood: Fix potential NULL dereference

Arnd Bergmann <arnd@arndb.de>
    fbdev: shmobile: fix snprintf truncation

Heiko Stuebner <heiko.stuebner@cherry.de>
    drm/panel: ltk050h3146w: drop duplicate commands from LTK050H3148W init

Heiko Stuebner <heiko.stuebner@cherry.de>
    drm/panel: ltk050h3146w: add MIPI_DSI_MODE_VIDEO to LTK050H3148W flags

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: Assign dummy when codec not specified for a DAI link

Arnd Bergmann <arnd@arndb.de>
    drm/imagination: avoid -Woverflow warning

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    mtd: rawnand: hynix: fixed typo

Aapo Vienamo <aapo.vienamo@linux.intel.com>
    mtd: core: Report error if first mtd_otp_size() call fails in mtd_otp_nvmem_add()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: ssm4567: Do not ignore route checks

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Disable route checks for Skylake boards

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Remove redundant condition in dcn35_calc_blocks_to_gate()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Fix potential index out of bounds in color transformation function

Douglas Anderson <dianders@chromium.org>
    drm/panel: atna33xc20: Fix unbalanced regulator in the case HPD doesn't assert

Marek Vasut <marex@denx.de>
    drm/lcdif: Do not disable clocks on already suspended hardware

Geert Uytterhoeven <geert+renesas@glider.be>
    dev_printk: Add and use dev_no_printk()

Geert Uytterhoeven <geert+renesas@glider.be>
    printk: Let no_printk() use _printk()

Tony Lindgren <tony@atomide.com>
    drm/omapdrm: Fix console with deferred ops

Tony Lindgren <tony@atomide.com>
    drm/omapdrm: Fix console by implementing fb_dirty

Lyude Paul <lyude@redhat.com>
    drm/nouveau/dp: Fix incorrect return code in r535_dp_aux_xfer()

Vignesh Raman <vignesh.raman@collabora.com>
    drm/ci: update device type for volteer devices

Jagan Teki <jagan@amarulasolutions.com>
    drm/bridge: Fix improper bridge init order with pre_enable_prev_first

Zhengqiao Xia <xiazhengqiao@huaqin.corp-partner.google.com>
    drm/panel-edp: Add prepare_to_enable to 200ms for MNC207QS1-1

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1

Gustavo A. R. Silva <gustavoars@kernel.org>
    Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Remove HCI_AMP support

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Make iso_get_sock_listen generic

Dan Carpenter <dan.carpenter@linaro.org>
    Bluetooth: qca: Fix error code in qca_read_fw_build_info()

Sebastian Urban <surban@surban.net>
    Bluetooth: compute LE flow credits based on recvbuf space

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: micrel: Fix receiving the timestamp in the frame for lan8841

Xiaolei Wang <xiaolei.wang@windriver.com>
    net: stmmac: move the EST lock to struct stmmac_priv

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: fix full TCP keep-alive support

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: SO_KEEPALIVE: fix getsockopt support

Wei Fang <wei.fang@nxp.com>
    net: fec: remove .ndo_poll_controller to avoid deadlocks

Chen Ni <nichen@iscas.ac.cn>
    dpll: fix return value check for kmemdup

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix reference count leak issue of net_device

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix reference count leak issues of ax25_dev

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Use kernel universal linked list to implement ax25_dev_list

Eric Dumazet <edumazet@google.com>
    inet: fix inet_fill_ifaddr() flags truncation

Puranjay Mohan <puranjay@kernel.org>
    riscv, bpf: make some atomic operations fully ordered

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Emit a barrier for BPF_FETCH instructions

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Discard command completions in internal error

Akiva Goldberger <agoldberger@nvidia.com>
    net/mlx5: Add a timeout to acquire the command queue semaphore

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Reload only IB representors upon lag disable/enable

Shay Drory <shayd@nvidia.com>
    net/mlx5: Fix peer devlink set for SF representor devlink port

Shay Drory <shayd@nvidia.com>
    net/mlx5e: Fix netif state handling

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

Dan Nowlin <dan.nowlin@intel.com>
    ice: Fix package download algorithm

Daniel Golle <daniel@makrotopia.org>
    net: ethernet: mediatek: use ADMAv1 instead of ADMAv2.0 on MT7981 and MT7986

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mediatek: split tx and rx fields in mtk_soc_data struct

Jakub Kicinski <kuba@kernel.org>
    selftests: net: move amt to socat for better compatibility

Jakub Kicinski <kuba@kernel.org>
    selftests: net: add missing config for amt.sh

Jakub Kicinski <kuba@kernel.org>
    eth: sungem: remove .ndo_poll_controller to avoid deadlocks

gaoxingwang <gaoxingwang1@huawei.com>
    net: ipv6: fix wrong start position when receive hop-by-hop fragment

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: fix DPLL functions

Benjamin Marzinski <bmarzins@redhat.com>
    dm-delay: fix max_delay calculations

Joel Colledge <joel.colledge@linbit.com>
    dm-delay: fix hung task introduced by kthread mode

Benjamin Marzinski <bmarzins@redhat.com>
    dm-delay: fix workqueue delay_timer race

Edward Liaw <edliaw@google.com>
    selftests/sgx: Include KHDR_INCLUDES in Makefile

Edward Liaw <edliaw@google.com>
    selftests: Compile kselftest headers with -D_GNU_SOURCE

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: Move ARCH_HAS_CPU_CACHE_ALIASING

Finn Thain <fthain@linux-m68k.org>
    m68k: mac: Fix reboot hang on Mac IIci

Michael Schmitz <schmitzmic@gmail.com>
    m68k: Fix spinlock race in kernel thread creation

Eric Dumazet <edumazet@google.com>
    net: usb: sr9700: stop lying about skb->truesize

Eric Dumazet <edumazet@google.com>
    usb: aqc111: stop lying about skb->truesize

Josef Bacik <josef@toxicpanda.com>
    btrfs: set start on clone before calling copy_extent_buffer_full

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Handle "no sensors" in PM operations

Dan Carpenter <dan.carpenter@linaro.org>
    wifi: mwl8k: initialize cmd->addr[] properly

Robert Richter <rrichter@amd.com>
    x86/numa: Fix SRAT lookup of CFMWS ranges with numa_fill_memblks()

Jim Liu <jim.t90615@gmail.com>
    gpio: nuvoton: Fix sgpio irq handle error

Himanshu Madhani <himanshu.madhani@oracle.com>
    scsi: qla2xxx: Fix debugfs output for fw_resource_count

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: qedf: Ensure the copied buf is NUL terminated

Bui Quang Minh <minhquangbui99@gmail.com>
    scsi: bfa: Ensure the copied buf is NUL terminated

Chen Ni <nichen@iscas.ac.cn>
    HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors

Michal Schmidt <mschmidt@redhat.com>
    selftests/bpf: Fix pointer arithmetic in test_xdp_do_redirect

Scott Mayhew <smayhew@redhat.com>
    kunit: bail out early in __kunit_test_suites_init() if there are no suites to test

Wander Lairson Costa <wander@redhat.com>
    kunit: unregister the device on error

Mickaël Salaün <mic@digikod.net>
    kunit: Fix kthread reference

Valentin Obst <kernel@valentinobst.de>
    selftests: default to host arch for LLVM builds

John Hubbard <jhubbard@nvidia.com>
    selftests/resctrl: fix clang build failure: use LOCAL_HDRS

John Hubbard <jhubbard@nvidia.com>
    selftests/binderfs: use the Makefile's rules, not Make's implicit rules

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    selftests: power_supply: Make it POSIX-compliant

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    selftests: ktap_helpers: Make it POSIX-compliant

Chih-Kang Chang <gary.chang@realtek.com>
    wifi: rtw89: wow: refine WoWLAN flows of HCI interrupts and low power mode

Kees Cook <keescook@chromium.org>
    wifi: nl80211: Avoid address calculations via out of bounds array indexing

Jiri Olsa <jolsa@kernel.org>
    libbpf: Fix error message in attach_kprobe_multi

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: connac: use muar idx 0xe for non-mt799x as well

Howard Hsu <howard-yh.hsu@mediatek.com>
    wifi: mt76: mt7996: fix potential memory leakage when reading chip temperature

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: fix uninitialized variable in mt7996_irq_tasklet()

Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
    wifi: mt76: mt7925: ensure 4-byte alignment for suspend & wow command

Chad Monroe <chad@monroe.io>
    wifi: mt76: mt7996: fix size of txpower MCU command

Muhammad Usama Anjum <usama.anjum@collabora.com>
    wifi: mt76: connac: check for null before dereferencing

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7603: fix tx queue of loopback packets

Guenter Roeck <linux@roeck-us.net>
    Revert "sh: Handle calling csum_partial with misaligned data"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: kprobes: Merge arch_copy_kprobe() into arch_prepare_kprobe()

Stanislav Fomichev <sdf@google.com>
    bpf: Add BPF_PROG_TYPE_CGROUP_SKB attach type enforcement in BPF_LINK_CREATE

George Stark <gnstark@salutedevices.com>
    pwm: meson: Use mul_u64_u64_div_u64() for frequency calculating

George Stark <gnstark@salutedevices.com>
    pwm: meson: Add check for error from clk_round_rate()

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: ar5523: enable proper endpoint verification

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Run cgroup1_hierarchy test in own mount namespace

Alexei Starovoitov <ast@kernel.org>
    bpf: Fix verifier assumptions about socket->sk

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    wifi: carl9170: add a proper sanity check for endpoints

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-macii: Fix "BUG: sleeping function called from invalid context"

Eric Dumazet <edumazet@google.com>
    net: give more chances to rcu in netdev_wait_allrefs_any()

Hao Chen <chenhao418@huawei.com>
    drivers/perf: hisi: hns3: Actually use devm_add_action_or_reset()

Junhao He <hejunhao3@huawei.com>
    drivers/perf: hisi: hns3: Fix out-of-bound access when valid event group

Junhao He <hejunhao3@huawei.com>
    drivers/perf: hisi_pcie: Fix out-of-bound access when valid event group

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sti: Simplify probe function using devm functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/debugfs: Pass cooling device state to thermal_debug_cdev_add()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/debugfs: Create records for cdev states as they get used

Eric Dumazet <edumazet@google.com>
    tcp: avoid premature drops in tcp_add_backlog()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: mv88e6xxx: Avoid EEPROM timeout without EEPROM on 88E6250-family switches

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    net: dsa: mv88e6xxx: Add support for model-specific pre- and post-reset handlers

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    wifi: ath10k: populate board data for WCN3990

Portia Stephens <portia.stephens@canonical.com>
    cpufreq: brcmstb-avs-cpufreq: ISO C90 forbids mixed declarations

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: mcq: Fix ufshcd_mcq_sqe_search()

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix a fd leak in error paths in open_netns

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal/debugfs: Avoid excessive updates of trip point statistics

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: do_xmote fixes

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: finish_xmote cleanup

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix potential glock use-after-free on unmount

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Remove ill-placed consistency check

Su Hui <suhui@nfschina.com>
    wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()

Binbin Zhou <zhoubinbin@loongson.cn>
    dt-bindings: thermal: loongson,ls2k-thermal: Fix incorrect compatible definition

Binbin Zhou <zhoubinbin@loongson.cn>
    dt-bindings: thermal: loongson,ls2k-thermal: Add Loongson-2K0500 compatible

Aleksandr Mishin <amishin@t-argos.ru>
    thermal/drivers/tsens: Fix null pointer dereference

Hsin-Te Yuan <yuanhsinte@chromium.org>
    thermal/drivers/mediatek/lvts_thermal: Add coeff for mt8192

Karthikeyan Kathirvel <quic_kathirve@quicinc.com>
    wifi: ath12k: fix out-of-bound access of qmi_invoke_handler()

Ard Biesheuvel <ardb@kernel.org>
    x86/purgatory: Switch to the position-independent small code model

Yuri Karpov <YKarpov@ispras.ru>
    scsi: hpsa: Fix allocation size for Scsi_Host private data

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix the failure of adding phy with zero-address to port

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: init vif works only once

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: don't always disable EMLSR due to BT coex

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: iwlwifi: mvm: calculate EMLSR mode after connection

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: introduce esr_disable_reason

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: transmit deauth only if link is available

Aleksandr Mishin <amishin@t-argos.ru>
    cppc_cpufreq: Fix possible null pointer dereference

Stafford Horne <shorne@gmail.com>
    openrisc: traps: Don't send signals to kernel mode threads

Stafford Horne <shorne@gmail.com>
    openrisc: Use do_kernel_power_off()

Gabriel Krisman Bertazi <krisman@suse.de>
    udp: Avoid call to compute_score on multiple sites

Juergen Gross <jgross@suse.com>
    x86/pat: Fix W^X violation false-positives when running as Xen PV guest

Juergen Gross <jgross@suse.com>
    x86/pat: Restructure _lookup_address_cpa()

Juergen Gross <jgross@suse.com>
    x86/pat: Introduce lookup_address_in_pgd_attr()

Viresh Kumar <viresh.kumar@linaro.org>
    cpufreq: exit() callback is optional

Hechao Li <hli@netflix.com>
    tcp: increase the default TCP scaling ratio

Geliang Tang <tanggeliang@kylinos.cn>
    selftests/bpf: Fix umount cgroup2 error in test_sockmap

Ard Biesheuvel <ardb@kernel.org>
    x86/boot/64: Clear most of CR4 in startup_64(), except PAE, MCE and LA57

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: Remove unnecessary irqflags alternative.h include

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix "ignore unlock failures after withdraw"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't forget to complete delayed withdraw

Arnd Bergmann <arnd@arndb.de>
    ACPI: disable -Wstringop-truncation

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/loongson-pch-msi: Fix off-by-one on allocation error path

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/alpine-msi: Fix off-by-one in allocation error path

Uros Bizjak <ubizjak@gmail.com>
    locking/atomic/x86: Correct the definition of __arch_try_cmpxchg128()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/skx_common: Allow decoding of SGX addresses

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    ACPI: LPSS: Advertise number of chip selects via property

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling UIC_COMMAND_COMPL

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after disabling interrupts

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Perform read back after writing UTP_TASK_REQ_LIST_BASE_H

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing CGC enable

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing unipro mode

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing REG_UFS_SYS1CLK_1US

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: qcom: Perform read back after writing reset bit

Arnd Bergmann <arnd@arndb.de>
    x86/microcode/AMD: Avoid -Wformat warning with clang-15

Andrii Nakryiko <andrii@kernel.org>
    bpf: prevent r10 register from being marked as precise

Anton Protopopov <aspsk@isovalent.com>
    bpf: Pack struct bpf_fib_lookup

Sahil Siddiq <icegambit91@gmail.com>
    bpftool: Mount bpffs on provided dir instead of parent dir

Arnd Bergmann <arnd@arndb.de>
    wifi: carl9170: re-fix fortified-memset warning

Alexander Aring <aahringo@redhat.com>
    dlm: fix user space lock decision to copy lvb

Alexander Lobakin <aleksander.lobakin@intel.com>
    bitops: add missing prototype check

Arnd Bergmann <arnd@arndb.de>
    mlx5: stop warning for 64KB pages

Arnd Bergmann <arnd@arndb.de>
    mlx5: avoid truncating error message

Arnd Bergmann <arnd@arndb.de>
    qed: avoid truncating work queue length

Arnd Bergmann <arnd@arndb.de>
    enetc: avoid truncating error message

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Indicate support for IRQ ResourceSource thru _OSC

Armin Wolf <W_Armin@gmx.de>
    ACPI: Fix Generic Initiator Affinity _OSC bit

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Indicate support for the Generic Event Device thru _OSC

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Indicate support for more than 16 p-states thru _OSC

Armin Wolf <W_Armin@gmx.de>
    ACPI: bus: Indicate support for _TFP thru _OSC

Shrikanth Hegde <sshegde@linux.ibm.com>
    sched/fair: Add EAS checks before updating root_domain::overutilized

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix check in iwl_mvm_sta_fw_id_mask

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: reconfigure TLC during HW restart

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: select STA mask only for active links

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: set wider BW OFDMA ignore correctly

Benjamin Berg <benjamin.berg@intel.com>
    wifi: iwlwifi: mvm: fix active link counting during recovery

Ayala Beker <ayala.beker@intel.com>
    wifi: mac80211: don't select link ID if not provided in scan request

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: allocate STA links only for active links

Ilan Peer <ilan.peer@intel.com>
    wifi: iwlwifi: mvm: Do not warn on invalid link on scan complete

Benjamin Berg <benjamin.berg@intel.com>
    wifi: cfg80211: ignore non-TX BSSs in per-STA profile

Johannes Berg <johannes.berg@intel.com>
    wifi: ieee80211: fix ieee80211_mle_basic_sta_prof_size_ok()

Paul Menzel <pmenzel@molgen.mpg.de>
    x86/fred: Fix typo in Kconfig description

Guixiong Wei <weiguixiong@bytedance.com>
    x86/boot: Ignore relocations in .notes sections in walk_relocs() too

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7915: workaround too long expansion sparse warnings

Aloka Dixit <quic_alokad@quicinc.com>
    wifi: ath12k: use correct flag field for 320 MHz channels

Quentin Monnet <qmo@kernel.org>
    libbpf: Prevent null-pointer dereference when prog to load has no BTF

Yonghong Song <yonghong.song@linux.dev>
    bpftool: Fix missing pids during link show

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath11k: don't force enable power save on non-running vdevs

Duoming Zhou <duoming@zju.edu.cn>
    wifi: brcmfmac: pcie: handle randbuf allocation failure

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath10k: poll service ready message before failing

Yu Kuai <yukuai3@huawei.com>
    block: support to account io_ticks precisely

INAGAKI Hiroshi <musashino.open@gmail.com>
    block: fix and simplify blkdevparts= cmdline parsing

Christoph Hellwig <hch@lst.de>
    block: refine the EOF check in blkdev_iomap_begin

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - specify firmware files for 402xx

Yu Kuai <yukuai3@huawei.com>
    md: fix resync softlockup when bitmap size is less than array size

Kees Cook <keescook@chromium.org>
    kunit/fortify: Fix replaced failure path to unbreak __alloc_size

Kees Cook <keescook@chromium.org>
    lkdtm: Disable CFI checking for perms functions

Bjorn Andersson <quic_bjorande@quicinc.com>
    soc: qcom: pmic_glink: Make client-lock non-sleeping

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/net: fix sendzc lazy wake polling

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390: vmlinux.lds.S: Drop .hash and .gnu.hash for !CONFIG_PIE_BUILD

Kees Cook <keescook@chromium.org>
    kunit/fortify: Fix mismatched kvalloc()/vfree() usage

Marek Vasut <marex@denx.de>
    hwrng: stm32 - repair clock handling

Marek Vasut <marex@denx.de>
    hwrng: stm32 - put IP into RPM suspend on failure

Marek Vasut <marex@denx.de>
    hwrng: stm32 - use logical OR in conditional

Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
    crypto: qat - validate slices count returned by FW

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix missing mutex_destroy() at module removal

Chun-Kuang Hu <chunkuang.hu@kernel.org>
    soc: mediatek: cmdq: Fix typo of CMDQ_JUMP_RELATIVE

Mukesh Ojha <quic_mojha@quicinc.com>
    firmware: qcom: scm: Fix __scm and waitq completion variable initialization

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pmic_glink: notify clients about the current state

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    soc: qcom: pmic_glink: don't traverse clients list without a lock

Adam Guerin <adam.guerin@intel.com>
    crypto: qat - improve error logging to be consistent across features

Adam Guerin <adam.guerin@intel.com>
    crypto: qat - improve error message in adf_get_arbiter_mapping()

Chen Ni <nichen@iscas.ac.cn>
    crypto: octeontx2 - add missing check for dma_map_single

David Hildenbrand <david@redhat.com>
    s390/mm: Re-enable the shared zeropage for !PV and !skeys KVM guests

David Hildenbrand <david@redhat.com>
    mm/userfaultfd: Do not place zeropages when zeropages are disallowed

Gabriel Krisman Bertazi <krisman@suse.de>
    io-wq: write next_work before dropping acct_lock

Chuck Lever <chuck.lever@oracle.com>
    shmem: Fix shmem_rename2()

Chuck Lever <chuck.lever@oracle.com>
    libfs: Add simple_offset_rename() API

Chuck Lever <chuck.lever@oracle.com>
    libfs: Fix simple_offset_rename_exchange()

Ilya Denisyev <dev@elkcl.ru>
    jffs2: prevent xattr node from overflowing the eraseblock

Maxime Ripard <mripard@kernel.org>
    ARM: configs: sunxi: Enable DRM_DW_HDMI

Nikita Kiryushin <kiryushin@ancud.ru>
    rcu: Fix buffer overflow in print_cpu_stall_info()

Nikita Kiryushin <kiryushin@ancud.ru>
    rcu-tasks: Fix show_rcu_tasks_trace_gp_kthread buffer overflow

Jens Axboe <axboe@kernel.dk>
    io_uring: use the right type for work_llist empty check

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: fix tracepoint subchannel type field

Eric Biggers <ebiggers@google.com>
    crypto: x86/sha512-avx2 - add missing vzeroupper

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

Guenter Roeck <linux@roeck-us.net>
    mm/slub, kunit: Use inverted data to corrupt kmem cache

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    firmware: qcom: qcm: fix unused qcom_scm_qseecom_allowlist

Aleksandr Mishin <amishin@t-argos.ru>
    crypto: bcm - Fix pointer arithmetic

Eric Sandeen <sandeen@redhat.com>
    openpromfs: finish conversion to the new mount API

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: Add missing dependencies of FIPS_SIGNATURE_SELFTEST

Eric Biggers <ebiggers@google.com>
    KEYS: asymmetric: Add missing dependency on CRYPTO_SIG

Takashi Iwai <tiwai@suse.de>
    ALSA: Fix deadlocks with kctl removals at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Set lower bound of start tick time

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix NULL module pointer assignment at card init

Andy Chi <andy.chi@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs don't work for ProBook 440/460 G11.

Nandor Kracser <bonifaido@gmail.com>
    ksmbd: ignore trailing slashes in share paths

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: avoid to send duplicate oplock break notifications

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Break dir enumeration if directory contents error

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix case when index is reused during tree transformation

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Taking DOS names into account during link counting

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Remove max link count info display during driver init

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential hang in nilfs_detach_log_writer()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix unexpected freezing of nilfs_segctor_sync()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free of timer for log writer thread

Nuno Sa <nuno.sa@analog.com>
    dt-bindings: adc: axi-adc: add clocks property

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: fix false alarm on invalid block address

Thorsten Blum <thorsten.blum@toblux.com>
    net: smc91x: Fix m68k kernel compilation for ColdFire CPU

Herve Codina <herve.codina@bootlin.com>
    net: lan966x: remove debugfs directory in probe() error path

Romain Gantois <romain.gantois@bootlin.com>
    net: ti: icssg_prueth: Fix NULL pointer dereference in prueth_probe()

Brennan Xavier McManus <bxmcmanus@gmail.com>
    tools/nolibc/stdlib: fix memory error in realloc()

Shuah Khan <skhan@linuxfoundation.org>
    tools/latency-collector: Fix -Wformat-security compile warns

Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
    net: mana: Fix the extra HZ in mana_hwc_send_request

Petr Pavlu <petr.pavlu@suse.com>
    ring-buffer: Fix a race between readers and resize checks

Ken Milmore <ken.milmore@gmail.com>
    r8169: Fix possible ring buffer corruption on fragmented Tx packets.

Heiner Kallweit <hkallweit1@gmail.com>
    Revert "r8169: don't try to disable interrupts if NAPI is, scheduled already"

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: ensure that normal task_work is also run timely

Ming Lei <ming.lei@redhat.com>
    io_uring: fail NOP if non-zero op flags is passed in

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: try trimming too long modalias strings

Pin-yen Lin <treapking@chromium.org>
    serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup

Doug Berger <opendmb@gmail.com>
    serial: 8250_bcm7271: use default_mux_rate if possible

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler

Dan Carpenter <dan.carpenter@linaro.org>
    speakup: Fix sizeof() vs ARRAY_SIZE() bug

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix missing receive state reset after mode switch

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix possible out-of-bounds in gsm0_receive()

Will Deacon <will@kernel.org>
    Reapply "arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD"

Ard Biesheuvel <ardb@kernel.org>
    arm64/fpsimd: Avoid erroneous elide of user state reload

Will Deacon <will@kernel.org>
    Revert "arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD"

Zheng Yejian <zhengyejian1@huawei.com>
    ftrace: Fix possible use-after-free issue in ftrace_location()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix checkbashisms errors

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    selftests/ftrace: Fix BTFARG testcase to check fprobe is enabled correctly

Daniel J Blueman <daniel@quora.org>
    x86/tsc: Trust initial offset in architectural TSC-adjust MSRs


-------------

Diffstat:

 .../devicetree/bindings/iio/adc/adi,axi-adc.yaml   |   5 +
 .../devicetree/bindings/media/i2c/ovti,ov2680.yaml |  18 +-
 .../bindings/thermal/loongson,ls2k-thermal.yaml    |  24 ++-
 Makefile                                           |   4 +-
 arch/arm/configs/sunxi_defconfig                   |   1 +
 arch/arm64/include/asm/irqflags.h                  |   1 -
 arch/arm64/kernel/fpsimd.c                         |  44 ++--
 arch/m68k/Kconfig                                  |   2 +-
 arch/m68k/kernel/entry.S                           |   4 +-
 arch/m68k/mac/misc.c                               |  36 ++--
 arch/openrisc/kernel/process.c                     |   8 +-
 arch/openrisc/kernel/traps.c                       |  42 ++--
 arch/parisc/kernel/parisc_ksyms.c                  |   1 +
 arch/powerpc/sysdev/fsl_msi.c                      |   2 +
 arch/riscv/include/asm/csr.h                       |   2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  20 +-
 arch/s390/include/asm/gmap.h                       |   2 +-
 arch/s390/include/asm/mmu.h                        |   5 +
 arch/s390/include/asm/mmu_context.h                |   1 +
 arch/s390/include/asm/pgtable.h                    |  16 +-
 arch/s390/kernel/vmlinux.lds.S                     |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/s390/mm/gmap.c                                | 165 ++++++++++----
 arch/s390/net/bpf_jit_comp.c                       |   8 +-
 arch/sh/kernel/kprobes.c                           |   7 +-
 arch/sh/lib/checksum.S                             |  67 ++----
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/boot/compressed/head_64.S                 |   5 +
 arch/x86/crypto/nh-avx2-x86_64.S                   |   1 +
 arch/x86/crypto/sha256-avx2-asm.S                  |   1 +
 arch/x86/crypto/sha512-avx2-asm.S                  |   1 +
 arch/x86/include/asm/cmpxchg_64.h                  |   2 +-
 arch/x86/include/asm/pgtable_types.h               |   2 +
 arch/x86/include/asm/sparsemem.h                   |   2 -
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/tsc_sync.c                         |   6 +-
 arch/x86/lib/x86-opcode-map.txt                    |  10 +-
 arch/x86/mm/numa.c                                 |   4 +-
 arch/x86/mm/pat/set_memory.c                       |  68 ++++--
 arch/x86/purgatory/Makefile                        |   3 +-
 arch/x86/tools/relocs.c                            |   9 +
 block/blk-core.c                                   |   9 +-
 block/blk-merge.c                                  |   2 +
 block/blk-mq.c                                     |   4 +
 block/blk.h                                        |   1 +
 block/fops.c                                       |   2 +-
 block/genhd.c                                      |   2 +-
 block/partitions/cmdline.c                         |  49 ++---
 crypto/asymmetric_keys/Kconfig                     |   3 +
 drivers/accessibility/speakup/main.c               |   2 +-
 drivers/acpi/acpi_lpss.c                           |   1 +
 drivers/acpi/acpica/Makefile                       |   1 +
 drivers/acpi/bus.c                                 |   5 +
 drivers/acpi/numa/srat.c                           |   5 +
 drivers/block/null_blk/main.c                      |   2 +
 drivers/bluetooth/btmrvl_main.c                    |   9 -
 drivers/bluetooth/btqca.c                          |   4 +-
 drivers/bluetooth/btrsi.c                          |   1 -
 drivers/bluetooth/btsdio.c                         |   8 -
 drivers/bluetooth/btusb.c                          |   5 -
 drivers/bluetooth/hci_bcm4377.c                    |   1 -
 drivers/bluetooth/hci_ldisc.c                      |   6 -
 drivers/bluetooth/hci_serdev.c                     |   5 -
 drivers/bluetooth/hci_uart.h                       |   1 -
 drivers/bluetooth/hci_vhci.c                       |  10 +-
 drivers/bluetooth/virtio_bt.c                      |   2 -
 drivers/char/hw_random/stm32-rng.c                 |  18 +-
 drivers/clk/clk-renesas-pcie.c                     |  10 +-
 drivers/clk/mediatek/clk-mt8365-mm.c               |   2 +-
 drivers/clk/mediatek/clk-pllfh.c                   |   2 +-
 drivers/clk/qcom/Kconfig                           |   2 +
 drivers/clk/qcom/apss-ipq-pll.c                    |   3 +-
 drivers/clk/qcom/clk-alpha-pll.c                   |   1 -
 drivers/clk/qcom/dispcc-sm6350.c                   |  11 +-
 drivers/clk/qcom/dispcc-sm8450.c                   |  20 +-
 drivers/clk/qcom/dispcc-sm8550.c                   |  20 +-
 drivers/clk/qcom/dispcc-sm8650.c                   |  20 +-
 drivers/clk/qcom/mmcc-msm8998.c                    |   8 +
 drivers/clk/renesas/r8a779a0-cpg-mssr.c            |   2 +-
 drivers/clk/renesas/r9a07g043-cpg.c                |   9 +
 drivers/clk/samsung/clk-exynosautov9.c             |   8 +-
 drivers/clk/samsung/clk-gs101.c                    | 225 ++++++++++---------
 drivers/clk/samsung/clk.h                          |  11 +-
 drivers/cpufreq/brcmstb-avs-cpufreq.c              |   5 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  14 +-
 drivers/cpufreq/cpufreq.c                          |  11 +-
 drivers/crypto/bcm/spu2.c                          |   2 +-
 drivers/crypto/ccp/sp-platform.c                   |  14 +-
 .../crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c |   2 +-
 .../crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c   |   2 +-
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c        |   2 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c  |   1 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c       |   2 +-
 .../crypto/intel/qat/qat_common/adf_telemetry.c    |  21 ++
 .../crypto/intel/qat/qat_common/adf_telemetry.h    |   1 +
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |   4 +
 drivers/dax/bus.c                                  |  66 ++----
 drivers/dpll/dpll_core.c                           |   2 +-
 drivers/edac/skx_common.c                          |   2 +-
 drivers/firmware/qcom/qcom_scm.c                   |  12 +-
 drivers/firmware/raspberrypi.c                     |   7 +-
 drivers/gpio/gpio-npcm-sgpio.c                     |  10 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   5 +
 .../drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c    |   3 +-
 drivers/gpu/drm/arm/malidp_mw.c                    |   5 +-
 drivers/gpu/drm/bridge/analogix/anx7625.c          |  15 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   3 +
 drivers/gpu/drm/bridge/chipone-icn6211.c           |   6 +-
 drivers/gpu/drm/bridge/lontium-lt8912b.c           |   6 +-
 drivers/gpu/drm/bridge/lontium-lt9611.c            |   6 +-
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c         |   6 +-
 drivers/gpu/drm/bridge/tc358775.c                  |   6 +-
 drivers/gpu/drm/bridge/ti-dlpc3433.c               |  17 +-
 drivers/gpu/drm/ci/test.yml                        |   6 +-
 drivers/gpu/drm/drm_bridge.c                       |  10 +-
 drivers/gpu/drm/drm_edid.c                         |   2 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |   6 +-
 drivers/gpu/drm/imagination/pvr_vm_mips.c          |   4 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   8 +-
 drivers/gpu/drm/mediatek/mtk_drm_gem.c             |   3 +
 drivers/gpu/drm/meson/meson_vclk.c                 |   6 +-
 drivers/gpu/drm/msm/dp/dp_aux.c                    |  25 ++-
 drivers/gpu/drm/msm/dp/dp_aux.h                    |   1 +
 drivers/gpu/drm/msm/dp/dp_catalog.c                |   7 +-
 drivers/gpu/drm/msm/dp/dp_catalog.h                |   3 +-
 drivers/gpu/drm/msm/dp/dp_ctrl.c                   |   6 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   4 +
 drivers/gpu/drm/msm/dp/dp_link.c                   |  22 +-
 drivers/gpu/drm/msm/dp/dp_link.h                   |  14 +-
 drivers/gpu/drm/mxsfb/lcdif_drv.c                  |   6 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c    |   2 +-
 drivers/gpu/drm/omapdrm/Kconfig                    |   2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |  40 +++-
 drivers/gpu/drm/panel/panel-edp.c                  |   9 +-
 drivers/gpu/drm/panel/panel-leadtek-ltk050h3146w.c |   5 +-
 drivers/gpu/drm/panel/panel-novatek-nt35950.c      |   6 +-
 drivers/gpu/drm/panel/panel-samsung-atna33xc20.c   |  22 +-
 drivers/gpu/drm/panel/panel-simple.c               |   3 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  22 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   2 +
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c      |  10 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c            |   5 +
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   3 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c            |  24 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h        |   3 +
 drivers/infiniband/hw/hns/hns_roce_hem.c           |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hem.h           |  12 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   9 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c          |   8 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |  15 +-
 drivers/infiniband/hw/hns/hns_roce_srq.c           |   6 +-
 drivers/infiniband/hw/mana/cq.c                    |  54 ++---
 drivers/infiniband/hw/mana/main.c                  |  43 ++++
 drivers/infiniband/hw/mana/mana_ib.h               |  14 +-
 drivers/infiniband/hw/mana/qp.c                    |  26 +--
 drivers/infiniband/hw/mlx5/mem.c                   |   8 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   3 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  35 ++-
 drivers/infiniband/sw/rxe/rxe_comp.c               |   6 +-
 drivers/infiniband/sw/rxe/rxe_net.c                |  12 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c          |   8 +-
 drivers/input/input.c                              | 104 +++++++--
 drivers/iommu/amd/init.c                           |   4 +-
 drivers/iommu/intel/iommu.c                        |  19 +-
 drivers/iommu/iommu.c                              |  21 +-
 drivers/irqchip/irq-alpine-msi.c                   |   2 +-
 drivers/irqchip/irq-loongson-pch-msi.c             |   2 +-
 drivers/macintosh/via-macii.c                      |  11 +-
 drivers/md/dm-delay.c                              |  14 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/media/i2c/et8ek8/et8ek8_driver.c           |   4 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |  10 +-
 drivers/media/pci/ngene/ngene-core.c               |   4 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       |  26 +--
 drivers/media/platform/renesas/rcar-vin/rcar-vin.h |   2 +-
 drivers/media/radio/radio-shark2.c                 |   2 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  31 +++
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/media/v4l2-core/v4l2-subdev.c              |   2 +
 drivers/misc/lkdtm/Makefile                        |   2 +-
 drivers/misc/lkdtm/perms.c                         |   2 +-
 drivers/mtd/mtdcore.c                              |   6 +-
 drivers/mtd/nand/raw/nand_hynix.c                  |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  50 ++++-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   6 +
 drivers/net/dsa/mv88e6xxx/global1.c                |  89 ++++++++
 drivers/net/dsa/mv88e6xxx/global1.h                |   2 +
 drivers/net/ethernet/cortina/gemini.c              |  12 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   2 +-
 drivers/net/ethernet/freescale/fec_main.c          |  26 ---
 drivers/net/ethernet/intel/ice/ice_ddp.c           |  10 +-
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c     |   3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        | 240 ++++++++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  29 +--
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  46 +++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  10 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  28 ++-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  14 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |  19 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   6 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   9 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   9 +-
 drivers/net/ethernet/smsc/smc91x.h                 |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  18 +-
 drivers/net/ethernet/sun/sungem.c                  |  14 --
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |  14 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |  56 ++++-
 drivers/net/ethernet/wangxun/libwx/wx_lib.h        |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |  22 ++
 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c   |  18 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c |  18 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |  31 +++
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   1 +
 drivers/net/phy/micrel.c                           |   3 +-
 drivers/net/usb/aqc111.c                           |   8 +-
 drivers/net/usb/smsc95xx.c                         |  15 +-
 drivers/net/usb/sr9700.c                           |  10 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  14 ++
 drivers/net/wireless/ath/ath10k/core.c             |   3 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   2 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   3 +
 drivers/net/wireless/ath/ath10k/wmi.c              |  26 ++-
 drivers/net/wireless/ath/ath11k/mac.c              |   9 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |   3 +
 drivers/net/wireless/ath/ath12k/wmi.c              |   2 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   3 +-
 drivers/net/wireless/ath/carl9170/usb.c            |  32 +++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  42 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  43 +++-
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  | 159 ++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |  19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  36 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   7 +-
 drivers/net/wireless/marvell/mwl8k.c               |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |  46 ++--
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   1 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   3 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  12 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   1 +
 drivers/net/wireless/realtek/rtw89/ps.c            |   3 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |  12 +-
 drivers/of/module.c                                |   7 +-
 drivers/perf/hisilicon/hisi_pcie_pmu.c             |  14 +-
 drivers/perf/hisilicon/hns3_pmu.c                  |  16 +-
 drivers/perf/riscv_pmu_sbi.c                       |   2 +-
 drivers/platform/x86/xiaomi-wmi.c                  |  18 ++
 drivers/power/supply/power_supply_sysfs.c          |  20 +-
 drivers/ptp/ptp_ocp.c                              |   6 +-
 drivers/pwm/pwm-meson.c                            |  15 +-
 drivers/pwm/pwm-sti.c                              |  39 +---
 drivers/s390/cio/trace.h                           |   2 +-
 drivers/scsi/bfa/bfad_debugfs.c                    |   4 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |   3 +-
 drivers/scsi/qedf/qedf_debugfs.c                   |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   2 +-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   5 +-
 drivers/soc/qcom/pmic_glink.c                      |  26 ++-
 drivers/staging/media/atomisp/pci/sh_css.c         |   1 +
 drivers/staging/media/starfive/camss/stf-camss.c   |   6 +
 drivers/thermal/mediatek/lvts_thermal.c            |   4 +
 drivers/thermal/qcom/tsens.c                       |   2 +-
 drivers/thermal/thermal_core.c                     |  12 +-
 drivers/thermal/thermal_debugfs.c                  |  27 ++-
 drivers/thermal/thermal_debugfs.h                  |   4 +-
 drivers/tty/n_gsm.c                                | 140 ++++++++----
 drivers/tty/serial/8250/8250_bcm7271.c             |  99 +++++----
 drivers/tty/serial/8250/8250_mtk.c                 |   8 +-
 drivers/tty/serial/sc16is7xx.c                     |  23 +-
 drivers/ufs/core/ufs-mcq.c                         |   3 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/ufs/host/cdns-pltfrm.c                     |   2 +-
 drivers/ufs/host/ufs-qcom.c                        |   7 +-
 drivers/ufs/host/ufs-qcom.h                        |  12 +-
 drivers/video/fbdev/Kconfig                        |   4 +-
 drivers/video/fbdev/core/Kconfig                   |   6 +
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |   2 +-
 drivers/video/fbdev/sis/init301.c                  |   3 +-
 drivers/virt/acrn/mm.c                             |  61 ++++--
 fs/btrfs/extent_io.c                               |  10 +-
 fs/dlm/ast.c                                       |  14 ++
 fs/dlm/dlm_internal.h                              |   1 +
 fs/dlm/user.c                                      |  15 +-
 fs/ecryptfs/keystore.c                             |   4 +-
 fs/exec.c                                          |  11 +
 fs/ext4/inode.c                                    |   3 -
 fs/ext4/mballoc.c                                  |   1 +
 fs/ext4/namei.c                                    |   2 +-
 fs/f2fs/checkpoint.c                               |   9 +-
 fs/gfs2/glock.c                                    |  91 +++++---
 fs/gfs2/glock.h                                    |   1 +
 fs/gfs2/glops.c                                    |   3 +
 fs/gfs2/incore.h                                   |   1 +
 fs/gfs2/lock_dlm.c                                 |  32 ++-
 fs/gfs2/ops_fstype.c                               |   1 +
 fs/gfs2/super.c                                    |   3 -
 fs/gfs2/util.c                                     |   1 -
 fs/jffs2/xattr.c                                   |   3 +
 fs/libfs.c                                         |  55 ++++-
 fs/nfsd/nfsctl.c                                   |   4 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/segment.c                                |  63 ++++--
 fs/ntfs3/dir.c                                     |   1 +
 fs/ntfs3/index.c                                   |   6 +
 fs/ntfs3/inode.c                                   |   7 +-
 fs/ntfs3/record.c                                  |  11 +-
 fs/ntfs3/super.c                                   |   2 -
 fs/openpromfs/inode.c                              |   8 +-
 fs/smb/server/mgmt/share_config.c                  |   6 +-
 fs/smb/server/oplock.c                             |  21 +-
 include/drm/drm_displayid.h                        |   1 -
 include/drm/drm_mipi_dsi.h                         |   6 +-
 include/linux/acpi.h                               |   6 +-
 include/linux/bitops.h                             |   1 +
 include/linux/dev_printk.h                         |  25 +--
 include/linux/fb.h                                 |   4 +
 include/linux/fortify-string.h                     |   3 +-
 include/linux/fs.h                                 |   2 +
 include/linux/ieee80211.h                          |   2 +-
 include/linux/ksm.h                                |  13 ++
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/numa.h                               |   7 +-
 include/linux/printk.h                             |   2 +-
 include/linux/stmmac.h                             |   1 -
 include/net/ax25.h                                 |   3 +-
 include/net/bluetooth/bluetooth.h                  |   2 +-
 include/net/bluetooth/hci.h                        | 122 +----------
 include/net/bluetooth/hci_core.h                   |  47 +---
 include/net/bluetooth/l2cap.h                      |  11 +-
 include/net/tcp.h                                  |   5 +-
 include/trace/events/asoc.h                        |   2 +
 include/uapi/linux/bpf.h                           |   2 +-
 include/uapi/linux/virtio_bt.h                     |   1 -
 io_uring/io-wq.c                                   |  13 +-
 io_uring/io_uring.h                                |   2 +-
 io_uring/net.c                                     |   1 +
 io_uring/nop.c                                     |   2 +
 io_uring/sqpoll.c                                  |   6 +-
 kernel/bpf/syscall.c                               |   5 +
 kernel/bpf/verifier.c                              |  29 ++-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/rcu/tasks.h                                 |   2 +-
 kernel/rcu/tree_stall.h                            |   3 +-
 kernel/sched/core.c                                |   2 +-
 kernel/sched/fair.c                                |  53 +++--
 kernel/sched/topology.c                            |   2 +-
 kernel/trace/ftrace.c                              |  39 ++--
 kernel/trace/ring_buffer.c                         |   9 +
 kernel/trace/trace_events_user.c                   |  76 ++++++-
 lib/fortify_kunit.c                                |  22 +-
 lib/kunit/device.c                                 |   2 +-
 lib/kunit/test.c                                   |   3 +
 lib/kunit/try-catch.c                              |   9 +-
 lib/slub_kunit.c                                   |   2 +-
 lib/test_hmm.c                                     |   8 +-
 mm/shmem.c                                         |   3 +-
 mm/userfaultfd.c                                   |  35 +++
 net/ax25/ax25_dev.c                                |  48 ++---
 net/bluetooth/hci_conn.c                           |   3 +-
 net/bluetooth/hci_core.c                           | 141 ++----------
 net/bluetooth/hci_event.c                          | 150 +------------
 net/bluetooth/hci_sock.c                           |   5 +-
 net/bluetooth/hci_sync.c                           | 207 ++++--------------
 net/bluetooth/iso.c                                |  75 ++++---
 net/bluetooth/l2cap_core.c                         |  77 ++++---
 net/bluetooth/l2cap_sock.c                         |  91 ++++++--
 net/bluetooth/mgmt.c                               |  84 +++-----
 net/bridge/br_device.c                             |   6 +
 net/bridge/br_mst.c                                |  16 +-
 net/core/dev.c                                     |   3 +-
 net/ipv4/devinet.c                                 |  13 +-
 net/ipv4/tcp_ipv4.c                                |  13 +-
 net/ipv4/udp.c                                     |  21 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/ipv6/seg6.c                                    |   5 +-
 net/ipv6/udp.c                                     |  20 +-
 net/l2tp/l2tp_core.c                               |  44 +++-
 net/mac80211/cfg.c                                 |  12 +-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   4 +-
 net/mac80211/mlme.c                                |  53 +++--
 net/mac80211/scan.c                                |  16 +-
 net/mptcp/protocol.h                               |   3 +
 net/mptcp/sockopt.c                                |  60 +++++-
 net/netrom/nr_route.c                              |  19 +-
 net/openvswitch/flow.c                             |   3 +-
 net/packet/af_packet.c                             |   3 +-
 net/qrtr/ns.c                                      |  27 +++
 net/sunrpc/auth_gss/svcauth_gss.c                  |  10 +-
 net/sunrpc/svc.c                                   |   2 -
 net/unix/af_unix.c                                 |   2 +-
 net/wireless/nl80211.c                             |  14 +-
 net/wireless/scan.c                                |  47 +++-
 samples/landlock/sandboxer.c                       |   5 +-
 scripts/module.lds.S                               |   1 +
 sound/core/init.c                                  |  11 +-
 sound/core/timer.c                                 |   8 +
 sound/pci/hda/cs35l41_hda_property.c               |   4 +-
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/intel/avs/boards/ssm4567.c               |   1 -
 sound/soc/intel/avs/cldma.c                        |   2 +-
 sound/soc/intel/avs/icl.c                          |   5 +-
 sound/soc/intel/avs/path.c                         |   1 +
 sound/soc/intel/avs/pcm.c                          |   4 +
 sound/soc/intel/avs/probes.c                       |  14 +-
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
 sound/soc/kirkwood/kirkwood-dma.c                  |   3 +
 sound/soc/mediatek/common/mtk-soundcard-driver.c   |   6 +-
 sound/soc/sof/intel/hda-dai.c                      |  31 ++-
 sound/soc/sof/intel/lnl.c                          |   3 +-
 sound/soc/sof/intel/lnl.h                          |  15 ++
 sound/soc/sof/intel/mtl.c                          |  46 +++-
 sound/soc/sof/intel/mtl.h                          |   4 +-
 tools/arch/x86/lib/x86-opcode-map.txt              |  10 +-
 tools/bpf/bpftool/common.c                         |  96 +++++++--
 tools/bpf/bpftool/iter.c                           |   2 +-
 tools/bpf/bpftool/main.h                           |   3 +-
 tools/bpf/bpftool/prog.c                           |   5 +-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |   4 +-
 tools/bpf/bpftool/struct_ops.c                     |   2 +-
 tools/include/nolibc/stdlib.h                      |   2 +-
 tools/include/uapi/linux/bpf.h                     |   2 +-
 tools/lib/bpf/bpf.c                                |   2 +-
 tools/lib/bpf/features.c                           |   2 +-
 tools/lib/bpf/libbpf.c                             |   9 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       |   3 +
 tools/testing/selftests/bpf/network_helpers.c      |   2 +
 .../selftests/bpf/prog_tests/cgroup1_hierarchy.c   |   7 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |   4 +-
 .../bpf/progs/bench_local_storage_create.c         |   5 +-
 tools/testing/selftests/bpf/progs/local_storage.c  |  20 +-
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |   8 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   2 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   8 +-
 tools/testing/selftests/cgroup/cgroup_util.h       |   2 +-
 tools/testing/selftests/cgroup/test_core.c         |   7 +-
 tools/testing/selftests/cgroup/test_cpu.c          |   2 +-
 tools/testing/selftests/cgroup/test_cpuset.c       |   2 +-
 tools/testing/selftests/cgroup/test_freezer.c      |   2 +-
 .../testing/selftests/cgroup/test_hugetlb_memcg.c  |   2 +-
 tools/testing/selftests/cgroup/test_kill.c         |   2 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   |   2 +-
 tools/testing/selftests/cgroup/test_zswap.c        |   2 +-
 tools/testing/selftests/damon/_damon_sysfs.py      |   2 +
 .../selftests/filesystems/binderfs/Makefile        |   2 -
 .../ftrace/test.d/dynevent/add_remove_btfarg.tc    |   2 +-
 .../ftrace/test.d/dynevent/fprobe_entry_arg.tc     |   2 +-
 .../ftrace/test.d/kprobe/kretprobe_entry_arg.tc    |   2 +-
 tools/testing/selftests/kcmp/kcmp_test.c           |   2 +-
 tools/testing/selftests/kselftest/ktap_helpers.sh  |   4 +-
 tools/testing/selftests/lib.mk                     |  12 +-
 tools/testing/selftests/net/amt.sh                 |  12 +-
 tools/testing/selftests/net/config                 |   1 +
 .../selftests/net/forwarding/bridge_igmp.sh        |   6 +-
 .../testing/selftests/net/forwarding/bridge_mld.sh |   6 +-
 tools/testing/selftests/net/lib.sh                 |   6 +-
 .../power_supply/test_power_supply_properties.sh   |   2 +-
 tools/testing/selftests/resctrl/Makefile           |   4 +-
 tools/tracing/latency/latency-collector.c          |   8 +-
 489 files changed, 4172 insertions(+), 2830 deletions(-)


