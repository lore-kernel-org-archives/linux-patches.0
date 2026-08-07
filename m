Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15E91A681E;
	Fri,  7 Aug 2026 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115855; cv=none; b=BTMpJIAPWKkKljYmRcefwApXI4x5MXaLgEgSk2/LFkOhF5og8zFJf6g700TM0J7SBf7VsdS/HOnQVvT9RgGs77KFC2dh2+v4eHq8O7+xuAOszi2LhEuLGk+TwIv25SxAd23KMiEcg+ZLpsYQcIKXQLiln2mmruxCRx4u6y2QASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115855; c=relaxed/simple;
	bh=rAqzJsDiA2FOjLY7AtfnNXTQJMOnW8Gu7AoCBhTrC+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ToeCdQZrdBU1Um1YTj9SvMa5eQ29Dw3hiUqcYzKD1PtpO46Kd3VbmU9fEaqp3rNGpsGju7ffR8KPJ6DEya1o7Lymg/jzwhVls4lAN2RdFg4ovXASelV2lSibj3LylreD5h14PLjRNamRwSE6KAzaOiU4UDoUqNhSwRQAnN5fruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXEimPmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXEimPmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC68D1F000E9;
	Fri,  7 Aug 2026 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115852;
	bh=zpWG9earke2dkWnAoWr7EfZO643GKslw6/YDXdeeLKU=;
	h=From:To:Cc:Subject:Date;
	b=qXEimPmKb+OrnW1+62MwPclcsaIUwb3wotrNAagFBgVAhJZt7KqLfM+HpbCEc3EBH
	 RXJf1l7RALYsOLARQWoMgo2zv/ElLlEsWBNeXlPZtsDay47rn8o7STCZE9Az05h4BJ
	 4ye7Glnc95TXnZnb1ML26qqECQzHZMhpMchABKrw=
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
Subject: [PATCH 6.6 000/261] 6.6.151-rc1 review
Date: Fri,  7 Aug 2026 16:35:57 +0200
Message-ID: <20260807143415.358597922@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.151-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.151-rc1
X-KernelTest-Deadline: 2026-08-09T14:34+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.151 release.
There are 261 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.151-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.151-rc1

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Do not assign to struct drm_fb_helper.info

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: codecs: hdmi: disable keep-alive before audio format change

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: check streams[] bounds before overflow

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: require monotonically increasing seq_num_v

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Move to using intel_display in intel_hdcp

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: migrate away from kdev_to_i915() in bind/unbind

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/fbc: Extract intel_fbc_has_fences()

Zhiling Zou <roxy520tt@gmail.com>
    sctp: close UDP tunnel sockets during netns teardown

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: userspace: fix use-after-free in get_local_id

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: use addr entry for get_local_id

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: add mptcp_userspace_pm_lookup_addr helper

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: avoid code duplication to lookup endp

WenTao Liang <vulab@iscas.ac.cn>
    ceph: fix refcount leak in ceph_readdir()

Xiubo Li <xiubli@redhat.com>
    ceph: print cluster fsid and client global_id in all debug logs

Xiubo Li <xiubli@redhat.com>
    libceph: add doutc and *_client debug macros support

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: fix timer drain order, wakeup handling and tx_gen ordering

Oliver Hartkopp <socketcan@hartkopp.net>
    can: use skb hash instead of private variable in headroom

Zhiling Zou <roxy520tt@gmail.com>
    sctp: avoid auth_enable sysctl UAF during netns teardown

Thomas Weißschuh <linux@weissschuh.net>
    sysctl: treewide: constify ctl_table_header::ctl_table_arg

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: drain bus_reset work on device removal

LiangCheng Wang <zaq14760@gmail.com>
    wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix 43752 SDIO FWVID incorrectly labelled as Cypress (CYW)

Daniel Hodges <git@danielhodges.dev>
    wifi: ath6kl: fix use-after-free in aggr_reset_state()

Mirela Rabulea <mirela.rabulea@nxp.com>
    media: v4l2-fwnode: Fix subdev owner overwritten in v4l2_async_register_subdev_sensor()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: async: Set owner for async sub-devices

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: clone set on flush only

David Howells <dhowells@redhat.com>
    rxrpc: Fix irq-disabled in local_bh_enable()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Fix maximum frame length in lines

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx219: Rename VTS to FRM_LENGTH

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Calculate crop rectangle dynamically

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Group functions by purpose

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Drop IMX219_VTS_* macros

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Don't store the current mode in the imx219 structure

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Access height from active format in imx219_set_ctrl

Jani Nikula <jani.nikula@intel.com>
    drm/i915/vrr: require valid min/max vfreq for VRR

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Remove offset into framebuffer memory

Thomas Zimmermann <tzimmermann@suse.de>
    drm/fb-helper: Allocate and release fb_info in single place

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Fix race condition and ordering in port unregistration

Sergey Senozhatsky <senozhatsky@chromium.org>
    usb: typec: ucsi: split connector lock classes

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    usb: typec: ucsi: Only enable supported notifications

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Biju Das <biju.das.jz@bp.renesas.com>
    drm: renesas: rzg2l_mipi_dsi: Increase reset deassertion delay

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    drm: renesas: Move RZ/G2L MIPI DSI driver to rz-du

Guangshuo Li <lgs201920130244@gmail.com>
    usb: musb: omap2430: Do not put borrowed of_node in probe

Johan Hovold <johan@kernel.org>
    usb: musb: omap2430: clean up probe error handling

Frank Scheiner <frank.scheiner@web.de>
    Revert "ia64: Make acpi_cpufreq_cpu_exit return void"

Junjie Cao <junjie.cao@intel.com>
    gpio: pch: use raw_spinlock_t for the register lock

Tze Yee Ng <tze.yee.ng@altera.com>
    firmware: stratix10-svc: fix memory leaks and list corruption bugs

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm/hugetlb: fix swap entry corruption when clearing uffd-wp at fork()

Wei Yang <albinwyang@tencent.com>
    iommu/sva: move x86 disable check before allocation

Niklas Cassel <cassel@kernel.org>
    ata: ahci: Make ahci_ignore_port() handle empty mask_port_map

Damien Le Moal <dlemoal@kernel.org>
    ata: libahci_platform: Do not set mask_port_map when not needed

HyeongJun An <sammiee5311@gmail.com>
    HID: logitech-dj: Fix maxfield check in DJ short report validation

Jun Guo <jun.guo@cixtech.com>
    spi: spi-cadence: enable SPI_CONTROLLER_MUST_TX

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate external BO copy bounds for both stride paths

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: use check_add_overflow for shader size+offset bound

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: bound DMA command body size against suffix pointer

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: validate DRAW_PRIMITIVES header size before division

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: drop dma_buf reference on foreign-fd prime import

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: reject DX_BIND_QUERY without a DX context

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: fix guest_memory_dirty bitfield clobbered as size

William Palacek <William.Palacek@amd.com>
    drm/amdkfd: hold event_mutex while checkpointing CRIU events

David Francis <David.Francis@amd.com>
    drm/amdkfd: Handle invalid event type in CRIU event restore

Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
    drm/amdkfd: fix QID bit leak in pqm_create_queue()

Gang Ba <Gang.Ba@amd.com>
    drm/amdkfd: Fix missing authorization check in KFD_IOC_DBG_TRAP_DISABLE

Harkirat Gill <harkirat.gill@amd.com>
    drm/amdgpu: cap GTT size to physical RAM on APUs

Candice Li <candice.li@amd.com>
    drm/amdgpu: restore UMD profile pstate after runtime resume

Myeonghun Pak <mhun512@gmail.com>
    drm/mediatek: ovl_adaptor: balance component registrations

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Zero the tile state data array before each BIN job

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/vc4: Supply the overflow slot size in BPOS, not the whole bin BO size

Alexander Kaplan <alexander.kaplan@sms-medipool.de>
    drm/dp: Read the PCON max FRL bandwidth only for HDMI DFPs

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: mark error-active controller status valid

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: handle bus error interrupts

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: unmap BAR0 using base address

Avi Weiss <thnkslprpt@gmail.com>
    can: ctucanfd: use self-test mode for PRESUME_ACK

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ctucanfd: add missing MODULE_DEVICE_TABLE()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: peak_usb: validate uCAN receive record lengths

Maoyi Xie <maoyixie.tju@gmail.com>
    can: peak_usb: peak_usb_start(): fix double free of transfer buffer on URB submit error

James Gao <jamesgao5@outlook.com>
    can: peak_usb: add bounds check for USB channel index

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: softing: fw_parse(): validate firmware record spans

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: kvaser_usb_leaf: kvaser_usb_leaf_wait_cmd(): validate received command extents

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    can: j1939: use netdevice_tracker for j1939_{priv,session,ecu} tracking

Oleksij Rempel <o.rempel@pengutronix.de>
    can: j1939: transport: j1939_session_fresh_new(): initialize receive buffer

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure

Guangshuo Li <lgs201920130244@gmail.com>
    can: etas_es58x: es58x_read_bulk_callback(): fix RX buffer leak on URB resubmit failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ems_usb: validate CPC message lengths

Lucas Martins Alves <lucas.alves@lumal21.com.br>
    can: c_can: c_can_chip_config(): keep controller in init mode until bittiming is configured

Liem <liem16213@gmail.com>
    i2c: imx: Cancel hrtimer before clearing slave pointer

Liem <liem16213@gmail.com>
    i2c: imx: Fix slave registration race and error handling

H. Nikolaus Schaller <hns@goldelico.com>
    i2c: jz4780: Cache host clock rate at probe to prevent CCF prepare_lock deadlock

Dawei Feng <dawei.feng@seu.edu.cn>
    ice: fix memory leak in ice_lbtest_prepare_rings()

Aaron Ma <aaron.ma@canonical.com>
    ice: wait for reset completion in ice_resume()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during ct

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix skb leak on flow key update failure during recirculation

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix potential UAF on meter attach failure

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: keep SERDES scrambler and 8b/10b enabled for USB

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: use read-modify-write for SERDES scrambler bypass

Nava kishore Manne <nava.kishore.manne@amd.com>
    phy: zynqmp: fix L0_TM_DISABLE_SCRAMBLE_ENCODER mask

Holger Dengler <dengler@linux.ibm.com>
    s390/zcrypt: Validate length for CCA ECC private key requests

Holger Dengler <dengler@linux.ibm.com>
    s390/zcrypt: Validate length for CCA AES cipher key requests

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Fix undersized format-check buffer

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix potential NULL pointer dereference

Aswin Karuvally <aswin@linux.ibm.com>
    s390/qeth: Check CAP_NET_ADMIN for private ioctls

Xu Rao <raoxu@uniontech.com>
    power: supply: bq25890: fix the -10 C NTC lookup entry

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()

bui duc phuc <phucduc.bui@gmail.com>
    gpio: pca953x: fix cache_only and IRQ state on restore_context() failure

Myeonghun Pak <mhun512@gmail.com>
    i2c: amd-mp2: Unregister callback on adapter add failure

Vincent Jardin <vjardin@free.fr>
    hwmon: (pmbus/core) notify on the hwmon device, not the i2c client

Hongyan Xu <getshell@seu.edu.cn>
    hwmon: (npcm750-pwm-fan): stop fan timer on device detach

Asim Viladi Oglu Manizada <manizada@pm.me>
    sctp: prevent peer transport count overflow

Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
    sctp: reject stale cookies with mismatched verification tags

Ibrahim Hashimov <security@auditcode.ai>
    scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/clone3: fix wild pointer access of getline due to missing init

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/mm: fix potential wild pointer access of getline due to missing init

Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>
    spi: qcom-qspi: Correct max DMA length to avoid 64K boundary failure

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/filters: Fix false positive match in regex_match_full()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Check return value of __register_event() in trace_module_add_events()

Ming Lei <tom.leiming@gmail.com>
    ublk: reset kernel-owned dev_info fields in ublk_ctrl_add_dev()

Eric Dumazet <edumazet@google.com>
    vxlan: use pskb_network_may_pull() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: use neigh_ha_snapshot() in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: unclone skb head before modifying eth header in route_shortcircuit()

Eric Dumazet <edumazet@google.com>
    vxlan: re-fetch eth header after route_shortcircuit()

Michael Bommarito <michael.bommarito@gmail.com>
    um: vector: fix use-after-free in vector_mmsg_rx()

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()

Zhiling Zou <zhilinz@nebusec.ai>
    net: ipv6: clear suppressed fib6 rule result

Zhiling Zou <zhilinz@nebusec.ai>
    net: bridge: stop fast-leave after deleting a port group

Link Lin <linkl@google.com>
    mm/page_reporting: use system_freezable_wq to fix UAF during suspend

Christian Brauner <brauner@kernel.org>
    binfmt_misc: reject a flag character as the field delimiter

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames

Zihan Xi <zihanx@nebusec.ai>
    tipc: avoid use-after-free in poll trace queue dumps

David Lee <david.lee@trailofbits.com>
    netfilter: ipset: do not update comments from kernel-side hash adds

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/smc: fix socket use-after-free during link group termination

Zhiling Zou <roxy520tt@gmail.com>
    ipvs: do not propagate one-packet flag to synced conns

Matt Vollrath <tactii@gmail.com>
    igbvf: Fix leak in TX DMA error cleanup

Dawei Feng <dawei.feng@seu.edu.cn>
    e1000: fix memory leak in e1000_probe()

Md Sadre Alam <md.alam@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Fix command element mask field for BAM v1.6.0+

Sonali Pradhan <sonalipradhan@google.com>
    ALSA: usb-audio: Clamp frame size in implicit-feedback mode

Sonali Pradhan <sonalipradhan@google.com>
    ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()

Baul Lee <baul.lee@xbow.com>
    ALSA: usb-audio: fix use-after-free in ump_to_endpoint()

Matt Vollrath <tactii@gmail.com>
    ata: libata-eh: Increase STANDBY IMMEDIATE timeout

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix broken entries in the volume lookup table

Haidar Lee <haidar.lee@adlinktech.com>
    ASoC: tas2562: fix DVC coefficient write order

Baul Lee <baul.lee@xbow.com>
    ALSA: ump: fix double free of out_cvts on rawmidi error

Norbert Szetei <norbert@doyensec.com>
    ALSA: pcm: wake linked drain waiters on unlink

Xu Rao <raoxu@uniontech.com>
    ALSA: lx6464es: fix period byte count for 16-bit streams

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Fix UAF at error handling during probe

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    bpf: lwt: Fix dst reference leak on reroute failure

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: validate numbered report payloads

Sangho Lee <kudo3228@gmail.com>
    Bluetooth: HIDP: reject frames without a transaction header

Zihan Xi <xizh2024@lzu.edu.cn>
    Bluetooth: mgmt: fix UAF in pair command cancellation

Zihan Xi <zihanx@nebusec.ai>
    Bluetooth: mgmt: fix pending command UAF in EIR updates

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Bluetooth: btmtk: Fix short read errors in btmtk_usb_uhw_reg_read()

Luxiao Xu <rakukuip@gmail.com>
    audit: fix potential use-after-free in audit_del_rule()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    audit: fix potential integer overflow in audit_log_n_string()

Charles Vosburgh <trilobyte777@gmail.com>
    sctp: validate Adaptation Indication parameter length

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Validate AIBV and AISB before pinning guest pages

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix NULL dereference on AIBV allocation failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Reject adapter interrupt forwarding if already enabled

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Update x2APIC MSR intercepts if AVIC is inhibited while L2 is active

Raushan Patel <raushan.jhon@gmail.com>
    tracing/probes: Reject $arg0 in meta argument expansion

Gregory Price <gourry@gourry.net>
    mm/vmstat: fold stranded per-cpu node stats when a node comes online

Xiangfeng Cai <caixiangfeng@bytedance.com>
    mm/hugetlb: fix list corruption in allocate_file_region_entries()

Zi Yan <ziy@nvidia.com>
    mm/percpu-km: fix bitmap overflow and accounting in pcpu_create_chunk()

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: bm1880: add missing select GENERIC_PINCONF

Michael Bommarito <michael.bommarito@gmail.com>
    erofs: cap LZMA stream pool size

Karl Mehltretter <kmehltretter@gmail.com>
    pinctrl: devicetree: don't free uninitialized dev_name on error path

Benjamin Boortz <bennib@mailbox.org>
    pinctrl: microchip-sgpio: add missing select REGMAP_MMIO

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    rhashtable: clear stale iter->p on table restart

Pengfei Zhang <zhangfeionline@gmail.com>
    ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in __close_file_table_ids()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return success for deferred final close

Denis V. Lunev <den@openvz.org>
    qede: sync udp_tunnel ports outside qede_lock in the recovery path

Suman Ghosh <sumang@marvell.com>
    octeontx2-pf: Set correct sequence for carrier off and tx queue stop

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mt7530: error out on failed reads in MT7531 PHY polling

Muhammad Bilal <meatuni001@gmail.com>
    accel/qaic: use sizeof(*trans_hdr) for transaction length check

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Reset dropped_count in mmio_reset_data()

Minhong He <heminhong@kylinos.cn>
    can: isotp: check register_netdevice_notifier() error in module init

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: check descriptor ring allocation failures

Chenguang Zhao <zhaochenguang@kylinos.cn>
    net: sxgbe: free TX rings on RX allocation failure

Leon Romanovsky <leon@kernel.org>
    scsi: target: Clear cmd_cnt when initial counter enrollment fails

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix memory leak during adapter release by destroying gid_pn_req

Guangshuo Li <lgs201920130244@gmail.com>
    scsi: ufs: core: Cancel RTC work in active-active suspend

TanZheng <tanzheng@kylinos.cn>
    scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE

Christian Marangi <ansuelsmth@gmail.com>
    net: phylink: put link_gpio if phylink_create fails

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: fix hci_conn_del() use in hci_le_create_conn_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_conn: hold conn reference in abort_conn_sync()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: make hci_cmd_sync_run_once return -EEXIST if exists

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btintel: Validate length before parsing diagnostics TLV

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix timeout vs sync_timeout typo in check_bcast_qos

Jiale Yao <yaojiale02@163.com>
    Bluetooth: L2CAP: fix UAF in l2cap_le_connect_rsp

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: clear iso_data always when detaching conn from hcon

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value from pmbus_update_byte_data()

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate individual TWT params before driver setup

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-akebono CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix treeboot-currituck CPU node lookup check

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/boot: Fix simpleboot CPU node lookup check

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix PWM auto temp state array and bounds check

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix divide-by-zero TOCTOU crash in fan speed read

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Use cached PWM frequency value

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix swapped PWM3 and PWM4 auto mode masks

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix temperature alarm logic in hwmon_temp_read()

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix cache updated before hardware write on I2C error

Luiz Angelo Daros de Luca <luizluca@gmail.com>
    hwmon: (adt7470) Fix fans stuck in manual mode on I2C errors

Chenguang Zhao <zhaochenguang@kylinos.cn>
    forcedeth: fix UAF of txrx_stats in nv_remove

David Corvaglia <david@corvaglia.dev>
    net: bridge: mrp: fix Option TLV length in MRP_Test frames

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Prevent access to unsupported weight registers

Eric Dumazet <edumazet@google.com>
    net: do not send ICMP/NDISC Redirects when peer allocation fails

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nzxt-smart2) DMA-align output buffer

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm90) Only report alarms if driver is ready

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6775-core) Fix number of temperature registers for NCT6116

Srikanth Boyapally <srikanth.boyapally@amd.com>
    spi: spi-cadence: Move TX FIFO full busy-wait into FIFO

Jun Guo <jun.guo@cixtech.com>
    spi: spi-cadence: supports transmission with bits_per_word of 16 and 32

Dawei Feng <dawei.feng@seu.edu.cn>
    smb: client: fix buffer leaks in SMB1 read and write

Xingui Yang <yangxingui@huawei.com>
    scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi_tcp: Bound SCSI Response data segment to the connection buffer

HyeongJun An <sammiee5311@gmail.com>
    scsi: libiscsi: Fix stale-data leak into the SCSI sense buffer

Mario Limonciello <mario.limonciello@amd.com>
    pinctrl-amd: Don't clear S4 wake bits at probe

Xiang Mei <xmei5@asu.edu>
    rds: tcp: hold the RCU lock across ipv6_chk_addr() in rds_tcp_laddr_check()

Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
    rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: nft_payload: fix mask build for partial field offload

Julian Anastasov <ja@ssi.bg>
    ipvs: do not mangle ICMP replies for non-first fragments

Julian Anastasov <ja@ssi.bg>
    ipvs: fix places with wrong packet offsets

Julian Anastasov <ja@ssi.bg>
    ipvs: fix the checksum validations

Kent Overstreet <kent.overstreet@gmail.com>
    sched: Add task_struct->faults_disabled_mapping

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: xt_hashlimit: validate hashtable supports XT_HASHLIMIT_RATE_MATCH

Michael Bommarito <michael.bommarito@gmail.com>
    assoc_array: trim the final shortcut word using the current chunk end

Michael Bommarito <michael.bommarito@gmail.com>
    keys: make keyring key-chunk byte order agree with keyring_diff_objects()

Michael Bommarito <michael.bommarito@gmail.com>
    keys: fix out-of-bounds read in keyring_get_key_chunk()

Ruoyu Wang <ruoyuw560@gmail.com>
    drm/mediatek: Check CRTC state before freeing

Xiang Mei <xmei5@asu.edu>
    netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix runtime PM leak on probe allocation failure

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    phy: zynqmp: fix clock error handling in xpsgtr_phy_init()

Mike Looijmans <mike.looijmans@topic.nl>
    phy-zynqmp: Postpone getting clock rate until actually needed

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix deadlock between metadata writeback and transaction commit

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98090: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Uday Khare <udaykhare77@gmail.com>
    ASoC: max98095: fix missing IS_ERR() before PTR_ERR() on mclk lookup

Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
    ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()

Damien Le Moal <dlemoal@kernel.org>
    ahci: Introduce ahci_ignore_port() helper

Josua Mayer <josua@solid-run.com>
    ata: libahci_platform: support non-consecutive port numbers

Rosen Penev <rosenp@gmail.com>
    ata: sata_mv: accept 1 or 2 resources in platform probe

Yuho Choi <dbgh9129@gmail.com>
    dmaengine: idxd: fix fdev setup failure cleanup in idxd_cdev_open()

Hongling Zeng <zenghongling@kylinos.cn>
    dmaengine: sun6i-dma: Fix reclaim descriptors while terminating DMA

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    pinctrl: qcom: sc8280xp: Add missing wakeup entries for GPIO143/151

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Harshal Dev <harshal.dev@oss.qualcomm.com>
    soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE

Benjamin Tissoires <bentiss@kernel.org>
    HID: logitech-dj: fix wrong detection of bad DJ_SHORT output report

Lee Jones <lee@kernel.org>
    HID: logitech-dj: Prevent REPORT_ID_DJ_SHORT related user initiated OOB write

Lee Jones <lee@kernel.org>
    HID: logitech-dj: Standardise hid_report_enum variable nomenclature

Eddie Phillips <eddiephillips@google.com>
    gve: fix Rx queue stall on alloc failure

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: mpls: initialize rtm_tos in mpls_getroute()

Lorenzo Bianconi <lorenzo@kernel.org>
    netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_expect: restore helper propagation via expectation


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/powerpc/boot/simpleboot.c                     |   2 +-
 arch/powerpc/boot/treeboot-akebono.c               |   2 +-
 arch/powerpc/boot/treeboot-currituck.c             |   2 +-
 arch/powerpc/platforms/ps3/mm.c                    |   1 +
 arch/s390/kvm/pci.c                                |  28 +-
 arch/um/drivers/vector_kern.c                      |   3 +
 arch/x86/kvm/svm/avic.c                            |   8 -
 drivers/accel/qaic/qaic_control.c                  |   2 +-
 drivers/ata/ahci.h                                 |  17 +-
 drivers/ata/ahci_brcm.c                            |   3 +
 drivers/ata/ahci_ceva.c                            |  24 +-
 drivers/ata/libahci.c                              |   1 +
 drivers/ata/libahci_platform.c                     |  38 +-
 drivers/ata/libata-eh.c                            |   8 +
 drivers/ata/sata_mv.c                              |   2 +-
 drivers/block/ublk_drv.c                           |   9 +
 drivers/bluetooth/btintel.c                        |   3 +
 drivers/bluetooth/btmtk.c                          |  50 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c                |   4 +-
 drivers/cpufreq/powernow-k8.c                      |   1 +
 drivers/dma/idxd/cdev.c                            |   4 +-
 drivers/dma/sun6i-dma.c                            |  11 +-
 drivers/firmware/stratix10-svc.c                   |  10 +-
 drivers/gpio/gpio-pca953x.c                        |  15 +-
 drivers/gpio/gpio-pch.c                            |  28 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  15 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  12 +
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |  23 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   2 +-
 drivers/gpu/drm/armada/armada_fbdev.c              |  12 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |  12 +
 drivers/gpu/drm/drm_fb_helper.c                    |  41 +-
 drivers/gpu/drm/drm_fbdev_dma.c                    |  12 +-
 drivers/gpu/drm/drm_fbdev_generic.c                |  12 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c          |   9 +-
 drivers/gpu/drm/gma500/fbdev.c                     |  13 +-
 drivers/gpu/drm/i915/display/intel_display_core.h  |   3 +
 .../gpu/drm/i915/display/intel_display_device.c    |   3 +
 drivers/gpu/drm/i915/display/intel_display_types.h |  40 ++
 drivers/gpu/drm/i915/display/intel_fbc.c           |   9 +-
 drivers/gpu/drm/i915/display/intel_fbdev.c         |   9 +-
 drivers/gpu/drm/i915/display/intel_hdcp.c          | 266 ++++----
 drivers/gpu/drm/i915/display/intel_vrr.c           |  10 +-
 drivers/gpu/drm/mediatek/mtk_disp_ovl_adaptor.c    |   7 +-
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c            |   6 +-
 drivers/gpu/drm/msm/msm_fbdev.c                    |   9 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c               |   9 +-
 drivers/gpu/drm/radeon/radeon_fbdev.c              |  13 +-
 drivers/gpu/drm/renesas/Kconfig                    |   1 +
 drivers/gpu/drm/renesas/Makefile                   |   1 +
 drivers/gpu/drm/renesas/rcar-du/Kconfig            |   8 -
 drivers/gpu/drm/renesas/rcar-du/Makefile           |   2 -
 drivers/gpu/drm/renesas/rz-du/Kconfig              |   8 +
 drivers/gpu/drm/renesas/rz-du/Makefile             |   3 +
 .../renesas/{rcar-du => rz-du}/rzg2l_mipi_dsi.c    |   2 +-
 .../{rcar-du => rz-du}/rzg2l_mipi_dsi_regs.h       |   0
 drivers/gpu/drm/tegra/fbdev.c                      |  18 +-
 drivers/gpu/drm/vc4/vc4_irq.c                      |   2 +-
 drivers/gpu/drm/vc4/vc4_validate.c                 |  29 +-
 drivers/gpu/drm/vmwgfx/ttm_object.c                |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_blit.c               |  39 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |  20 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c           |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c             |  13 +-
 drivers/hid/hid-logitech-dj.c                      |  28 +-
 drivers/hwmon/adt7470.c                            | 131 ++--
 drivers/hwmon/lm90.c                               |   4 +-
 drivers/hwmon/nct6775-core.c                       |  20 +-
 drivers/hwmon/npcm750-pwm-fan.c                    |  11 +
 drivers/hwmon/nzxt-smart2.c                        |   2 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   7 +-
 drivers/i2c/busses/i2c-amd-mp2-plat.c              |   4 +-
 drivers/i2c/busses/i2c-imx.c                       |   9 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/iommu/iommu-sva.c                          |   6 +-
 drivers/media/i2c/imx219.c                         | 670 ++++++++++---------
 drivers/media/v4l2-core/v4l2-async.c               |   8 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   6 +-
 drivers/net/can/c_can/c_can_main.c                 |   8 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |  14 +-
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |   3 +-
 drivers/net/can/dev/skb.c                          |   2 -
 drivers/net/can/softing/softing_fw.c               |  46 +-
 drivers/net/can/usb/ems_usb.c                      |  43 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   1 -
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  13 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  40 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  20 +-
 drivers/net/dsa/mt7530.c                           |  58 +-
 drivers/net/ethernet/google/gve/gve.h              |   3 +
 drivers/net/ethernet/google/gve/gve_main.c         |   3 +
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  33 +
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  10 +
 drivers/net/ethernet/intel/igbvf/netdev.c          |   2 -
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   2 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  44 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  14 +-
 drivers/net/phy/phylink.c                          |  29 +-
 drivers/net/vrf.c                                  |   2 +-
 drivers/net/vxlan/vxlan_core.c                     |  15 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  16 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  46 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 drivers/phy/xilinx/phy-zynqmp.c                    | 130 ++--
 drivers/pinctrl/Kconfig                            |   2 +
 drivers/pinctrl/devicetree.c                       |   4 +
 drivers/pinctrl/pinctrl-amd.c                      |   3 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |  21 +-
 drivers/power/supply/bq25890_charger.c             |   2 +-
 drivers/s390/block/dasd_eckd.c                     |  11 +-
 drivers/s390/block/dasd_ioctl.c                    |   2 +-
 drivers/s390/crypto/zcrypt_api.c                   |   2 +-
 drivers/s390/crypto/zcrypt_ccamisc.c               |   6 +
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/scsi/zfcp_aux.c                       |   1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  10 +-
 drivers/scsi/libiscsi.c                            |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   8 +-
 drivers/scsi/libsas/sas_init.c                     |  37 +-
 drivers/scsi/scsi_debug.c                          |   8 +-
 drivers/soc/qcom/ice.c                             |  17 +-
 drivers/spi/spi-cadence.c                          | 129 +++-
 drivers/spi/spi-qcom-qspi.c                        |   3 +-
 drivers/target/target_core_iblock.c                |   6 +-
 drivers/target/target_core_transport.c             |  12 +-
 drivers/thunderbolt/xdomain.c                      |  40 +-
 drivers/ufs/core/ufshcd.c                          |   6 +-
 drivers/usb/gadget/function/f_tcm.c                | 192 +++++-
 drivers/usb/gadget/function/tcm.h                  |  13 +
 drivers/usb/musb/omap2430.c                        |  25 +-
 drivers/usb/typec/ucsi/ucsi.c                      | 113 ++--
 drivers/usb/typec/ucsi/ucsi.h                      |   1 +
 fs/binfmt_misc.c                                   |   4 +
 fs/btrfs/zoned.c                                   |   6 +-
 fs/ceph/acl.c                                      |   6 +-
 fs/ceph/addr.c                                     | 279 ++++----
 fs/ceph/caps.c                                     | 708 ++++++++++++---------
 fs/ceph/crypto.c                                   |  39 +-
 fs/ceph/debugfs.c                                  |   6 +-
 fs/ceph/dir.c                                      | 225 ++++---
 fs/ceph/export.c                                   |  39 +-
 fs/ceph/file.c                                     | 245 ++++---
 fs/ceph/inode.c                                    | 485 +++++++-------
 fs/ceph/ioctl.c                                    |  13 +-
 fs/ceph/locks.c                                    |  57 +-
 fs/ceph/mds_client.c                               | 554 +++++++++-------
 fs/ceph/mdsmap.c                                   |  24 +-
 fs/ceph/metric.c                                   |   5 +-
 fs/ceph/quota.c                                    |  29 +-
 fs/ceph/snap.c                                     | 174 ++---
 fs/ceph/super.c                                    |  70 +-
 fs/ceph/super.h                                    |   6 +
 fs/ceph/xattr.c                                    |  96 +--
 fs/erofs/Kconfig                                   |  14 +
 fs/erofs/decompressor_lzma.c                       |   3 +-
 fs/smb/client/cifssmb.c                            |  12 +-
 fs/smb/server/vfs_cache.c                          |   6 +-
 include/drm/drm_fb_helper.h                        |  12 -
 include/linux/can/core.h                           |   1 +
 include/linux/can/skb.h                            |   2 -
 include/linux/ceph/ceph_debug.h                    |  38 ++
 include/linux/dma/qcom_bam_dma.h                   |  21 +-
 include/linux/libata.h                             |   2 +-
 include/linux/mmc/sdio_ids.h                       |   2 +-
 include/linux/netfilter/nf_conntrack_sip.h         |   2 +-
 include/linux/sched.h                              |   1 +
 include/linux/sysctl.h                             |   2 +-
 include/linux/thunderbolt.h                        |   3 +
 include/media/v4l2-async.h                         |   8 +-
 include/net/ip_vs.h                                |  45 +-
 include/net/neighbour.h                            |   8 +-
 include/net/netfilter/nf_conntrack_expect.h        |   5 +-
 include/net/netfilter/nf_tables.h                  |   2 +
 include/scsi/libsas.h                              |   1 -
 init/init_task.c                                   |   1 +
 ipc/ipc_sysctl.c                                   |   2 +-
 ipc/mq_sysctl.c                                    |   2 +-
 kernel/audit.c                                     |  11 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_events_filter.c                 |   3 +
 kernel/trace/trace_mmiotrace.c                     |   1 +
 kernel/trace/trace_probe.c                         |   6 +-
 kernel/ucount.c                                    |   2 +-
 lib/assoc_array.c                                  |   3 +-
 lib/rhashtable.c                                   |   1 +
 mm/huge_memory.c                                   |  16 +-
 mm/hugetlb.c                                       |  12 +-
 mm/mm_init.c                                       |  15 +-
 mm/page_reporting.c                                |   6 +-
 mm/percpu-km.c                                     |   2 +-
 net/ax25/sysctl_net_ax25.c                         |   2 +-
 net/bluetooth/hci_conn.c                           |  14 +-
 net/bluetooth/hci_sync.c                           |  19 +-
 net/bluetooth/hidp/core.c                          |  30 +-
 net/bluetooth/iso.c                                |   3 +-
 net/bluetooth/l2cap_core.c                         |   5 +
 net/bluetooth/mgmt.c                               |  84 ++-
 net/bridge/br_mrp.c                                |   2 +-
 net/bridge/br_multicast.c                          |   1 +
 net/bridge/br_netfilter_hooks.c                    |   8 +-
 net/can/af_can.c                                   |  14 +-
 net/can/bcm.c                                      |   2 -
 net/can/isotp.c                                    | 337 +++++++---
 net/can/j1939/bus.c                                |   2 +
 net/can/j1939/j1939-priv.h                         |   3 +
 net/can/j1939/main.c                               |   8 +-
 net/can/j1939/socket.c                             |   1 -
 net/can/j1939/transport.c                          |   6 +-
 net/can/raw.c                                      |   7 +-
 net/core/lwt_bpf.c                                 |   4 +-
 net/core/sysctl_net_core.c                         |   2 +-
 net/ieee802154/6lowpan/reassembly.c                |   2 +-
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/ip_fragment.c                             |   2 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/sysctl_net_ipv4.c                         |   2 +-
 net/ipv4/xfrm4_policy.c                            |   2 +-
 net/ipv6/addrconf.c                                |   2 +-
 net/ipv6/fib6_rules.c                              |   1 +
 net/ipv6/ip6_fib.c                                 |  17 +-
 net/ipv6/ip6_output.c                              |   2 +-
 net/ipv6/ndisc.c                                   |   2 +
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   2 +-
 net/ipv6/reassembly.c                              |   2 +-
 net/ipv6/sysctl_net_ipv6.c                         |   6 +-
 net/ipv6/xfrm6_policy.c                            |   2 +-
 net/mac80211/s1g.c                                 |   4 +
 net/mpls/af_mpls.c                                 |   5 +-
 net/mptcp/ctrl.c                                   |   2 +-
 net/mptcp/pm.c                                     |   9 +-
 net/mptcp/pm_netlink.c                             |  29 +-
 net/mptcp/pm_userspace.c                           |  87 ++-
 net/mptcp/protocol.h                               |   6 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   3 +
 net/netfilter/ipvs/ip_vs_core.c                    | 180 +++---
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  19 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  48 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |  54 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  42 +-
 net/netfilter/nf_conntrack_broadcast.c             |   1 +
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_conntrack_expect.c                |   1 +
 net/netfilter/nf_conntrack_h323_main.c             |  12 +-
 net/netfilter/nf_conntrack_helper.c                |   5 +
 net/netfilter/nf_conntrack_netlink.c               |  18 +-
 net/netfilter/nf_conntrack_sip.c                   |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   2 +-
 net/netfilter/nf_log.c                             |   2 +-
 net/netfilter/nf_nat_sip.c                         |   2 +-
 net/netfilter/nf_tables_api.c                      |  10 +-
 net/netfilter/nft_payload.c                        |  12 +-
 net/netfilter/nft_set_pipapo.c                     |  11 +-
 net/netfilter/xt_hashlimit.c                       |  16 +-
 net/openvswitch/actions.c                          |  12 +-
 net/openvswitch/meter.c                            |  33 +-
 net/rds/ib.c                                       |   4 +
 net/rds/ib_cm.c                                    |   4 +
 net/rds/tcp.c                                      |  14 +-
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/call_accept.c                            |   1 +
 net/rxrpc/peer_object.c                            |  12 +-
 net/sctp/associola.c                               |   3 +
 net/sctp/protocol.c                                |  21 +-
 net/sctp/sm_make_chunk.c                           |  17 +-
 net/sctp/sysctl.c                                  |  11 +-
 net/smc/smc_core.c                                 |   2 +-
 net/smc/smc_sysctl.c                               |   2 +-
 net/tipc/socket.c                                  |   2 +-
 net/unix/sysctl_net_unix.c                         |   2 +-
 net/xfrm/xfrm_sysctl.c                             |   2 +-
 security/keys/keyring.c                            |  14 +-
 sound/core/pcm_native.c                            |   7 +
 sound/core/ump.c                                   |   1 +
 sound/pci/hda/patch_hdmi.c                         |  48 +-
 sound/pci/lx6464es/lx6464es.c                      |   5 +-
 sound/pci/lx6464es/lx_core.c                       |   5 +-
 sound/soc/codecs/max98090.c                        |   5 +-
 sound/soc/codecs/max98095.c                        |   5 +-
 sound/soc/codecs/tas2562.c                         |  30 +-
 sound/usb/6fire/chip.c                             |   4 +
 sound/usb/endpoint.c                               |  14 +-
 sound/usb/midi.c                                   |   2 +
 sound/usb/midi2.c                                  |   4 +-
 tools/testing/selftests/clone3/clone3_set_tid.c    |   2 +-
 tools/testing/selftests/mm/mlock-random-test.c     |   2 +-
 305 files changed, 4972 insertions(+), 3146 deletions(-)


