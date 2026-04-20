Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612702DE6E3;
	Mon, 20 Apr 2026 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701167; cv=none; b=A9fCCvFXx9GmovvN1p/dZH2Dcf/zPoEqQOSq10NzMdXG2+BdX+CGhuDPrsx4zdSLMJvO9ZJ7X0tLqycTY8b/3wRwfUIO/jkr2jxjfR3N1YyA3BGDq+mbYuL9TA3r4gwB5yd7PhUuIP19X7Ez/1F5raBWOBOSnvNVQ+FSxc8+WsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701167; c=relaxed/simple;
	bh=wteBu3DN+8MwKe3g3zY6MMszqwNwSOHryV8rUksjx9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OQrSDz2L3dzE42OfEpaTSGkbcviqbS9lsnXpNeI/bbaMuoJRTcygP5OKhwNQdFo1pbBDqeXTF1u6h92fLvi7ZqhMdQJqto5N6kRu+YlG4f9z+Y5VvLCPeX31daUfwO6c4cDMkUvZ1p7WBvm+g4goPEsrqpDCKXGaCqjqAZxrlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhL/4DV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhL/4DV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2FEC19425;
	Mon, 20 Apr 2026 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701167;
	bh=wteBu3DN+8MwKe3g3zY6MMszqwNwSOHryV8rUksjx9Q=;
	h=From:To:Cc:Subject:Date:From;
	b=UhL/4DV4HvRhggR0YPA2NponV+VjMoGQNfMUqiFWr9zdSG7a7EZ7oHXzAoY8cPICj
	 Q+EO1IEJy0pgttFFKdTlRgm5B+lGWailpn+Fxu0CuP6aR8eK5dzZLKMpA+XvNs8Dcw
	 7B7Y8a5x8jDZNjKOX738FcrYbOq6uNy6FUqJYbMA=
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
Subject: [PATCH 6.12 000/162] 6.12.83-rc1 review
Date: Mon, 20 Apr 2026 17:40:32 +0200
Message-ID: <20260420153927.006696811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.83-rc1
X-KernelTest-Deadline: 2026-04-22T15:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.83 release.
There are 162 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.83-rc1

John Hancock <john@kernel.doghat.io>
    PCI: Revert "Enable ACS after configuring IOMMU for OF platforms"

Minhong He <heminhong@kylinos.cn>
    ipv6: add NULL checks for idev in SRv6 paths

Lukas Wunner <lukas@wunner.de>
    PCI: Fix placement of pci_save_state() in pci_bus_add_device()

David Howells <dhowells@redhat.com>
    rxrpc: Fix key quota calculation for multitoken keys

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix out-of-bounds write in ocfs2_write_end_inline

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: validate inline data i_size during inode read

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: add inline inode consistency check to ocfs2_validate_inode_block()

Jeongjun Park <aha310510@gmail.com>
    media: hackrf: fix to not free memory after the device is registered in hackrf_probe()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    media: vidtv: fix pass-by-value structs causing MSAN warnings

Deepanshu Kartikey <kartikey406@gmail.com>
    nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map

Jeongjun Park <aha310510@gmail.com>
    media: as102: fix to not free memory after the device is registered in as102_usb_probe()

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fix cached_dev.sb_bio use-after-free and crash

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: 6fire: fix use-after-free on disconnect

Sanman Pradhan <psanman@juniper.net>
    hwmon: (powerz) Fix use-after-free on USB disconnect

Abhishek Kumar <abhishek_sts8@yahoo.com>
    media: em28xx: fix use-after-free in em28xx_v4l2_open()

Fan Wu <fanwu01@zju.edu.cn>
    media: mediatek: vcodec: fix use-after-free in encoder release path

Ruslan Valiyev <linuxoid@gmail.com>
    media: vidtv: fix nfeeds state corruption on start_streaming failure

Breno Leitao <leitao@debian.org>
    mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    mm/kasan: fix double free for kasan pXds

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: move component registration to unmanaged version

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use scratch field in MMIO fragment to hold small write values

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64/arm64/powerpc: clean up and rename __copy_from_user_flushcache

Linus Torvalds <torvalds@linux-foundation.org>
    x86: rename and clean up __copy_from_user_inatomic_nocache()

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64: rename misleadingly named '__copy_user_nocache()' function

Sasha Levin <sashal@kernel.org>
    checkpatch: add support for Assisted-by tag

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86: Use __DECLARE_FLEX_ARRAY() for UAPI structures with VLAs

Sean Christopherson <seanjc@google.com>
    KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay

Liam R. Howlett <Liam.Howlett@Oracle.com>
    kernel: be more careful about dup_mmap() failures and uprobe registering

Eric Dumazet <edumazet@google.com>
    net: sched: fix TCF_LAYER_TRANSPORT handling in tcf_get_base_ptr()

Paweł Narewski <pawel.narewski@nokia.com>
    gpiolib: fix race condition for gdev->srcu

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: unify two loops initializing GPIO descriptors

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Drop WARN on large size for KVM_MEMORY_ENCRYPT_REG_REGION

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Disallow LAUNCH_FINISH if vCPUs are actively being created

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Reject attempts to sync VMSA of an already-launched/encrypted vCPU

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Stop cmd_handler work in epf_ntb_epc_cleanup

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: handle invalid dinode in ocfs2_group_extend

Tejas Bharambe <tejas.bharambe@outlook.com>
    ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix possible deadlock between unlink and dio_end_io_write

Ruslan Valiyev <linuxoid@gmail.com>
    media: vidtv: fix NULL pointer dereference in vidtv_channel_pmt_match_sections

Zhihao Cheng <chengzhihao1@huawei.com>
    dcache: Limit the minimal number of bucket to two

Harin Lee <me@harin.net>
    ALSA: ctxfi: Limit PTP to a single page

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A MBIM composition

Junrui Luo <moonafterrain@outlook.com>
    staging: sm750fb: fix division by zero in ps_to_hz()

Johan Hovold <johan@kernel.org>
    wifi: rtw88: fix device leak on probe failure

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer.py: avoid FD leak

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO

Xu Yang <xu.yang_2@nxp.com>
    usb: port: add delay after usb_hub_set_port_power()

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: don't call cdev_init while cdev in use

Dave Carey <carvsdriver@gmail.com>
    USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen

Daniel Brát <danek.brat@gmail.com>
    usb: storage: Expand range of matched versions for VL817 quirks entry

Nathan Rebello <nathan.c.rebello@gmail.com>
    usbip: validate number_of_packets in usbip_pack_ret_submit()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: require 3 sub-authorities before reading sub_auth[2]

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: validate EaNameLength in smb2_get_ea()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    smb: client: fix off-by-8 bounds check in check_wsl_eas()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: renesas_usb3: validate endpoint index in standard request handlers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: f_phonet: fix skb frags[] overflow in pn_rx_complete()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: f_ncm: validate minimum block_len in ncm_unwrap_ntb()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: fireworks: bound device-supplied status before string array lookup

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/vc4: platform_get_irq_byname() returns an int

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    NFC: digital: Bounds check NFC-A cascade depth in SDD response handler

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: cdc-phonet: fix skb frags[] overflow in rx_complete()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: core: clamp report_size in s32ton() to avoid undefined shift

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: alps: fix NULL pointer dereference in alps_raw_event()

Lin YuChen <starpt.official@gmail.com>
    staging: rtl8723bs: initialize le_tmp64 in rtw_BIP_verify()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    i2c: s3c24xx: check the size of the SMBUS message before using it

Samuel Page <sam@bynar.io>
    can: raw: fix ro->uniq use-after-free in raw_rcv()

Junxi Qian <qjx1298677004@gmail.com>
    nfc: llcp: add missing return after LLCP_CLOSED checks

Emil Tantilov <emil.s.tantilov@intel.com>
    idpf: fix PREEMPT_RT raw/bh spinlock nesting for async VC handling

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Improve Focusrite sample rate filtering

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Address thermal zone removal races with resume

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Mark thermal zones as exiting before unregistration

Sasha Levin <sashal@kernel.org>
    Revert "drm/xe: Switch MMIO interface to take xe_mmio instead of xe_gt"

Sasha Levin <sashal@kernel.org>
    Revert "drm/xe/mmio: Avoid double-adjust in 64-bit reads"

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: add missing netlink policy validations

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_aead - Fix minimum RX size check for decryption

Thomas Gleixner <tglx@kernel.org>
    clockevents: Prevent timer interrupt starvation

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Use revised wakeup rule for dl_server

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Skip discovery table for offline dies

Douya Le <ldy3087146292@gmail.com>
    crypto: af_alg - limit RX SG extraction by receive buffer budget

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    gpio: tegra: fix irq_release_resources calling enable instead of disable

Alice Mikityanska <alice@isovalent.com>
    l2tp: Drop large packets with UDP encap

Alexander Koskovich <akoskovich@pm.me>
    net: ipa: fix event ring index not programmed for IPA v5.0+

Alexander Koskovich <akoskovich@pm.me>
    net: ipa: fix GENERIC_CMD register field masks for IPA v5.0+

Jiexun Wang <wangjiexun2025@gmail.com>
    af_unix: read UNIX_DIAG_VFS data under unix_state_lock

Fabio Baltieri <fabio.baltieri@gmail.com>
    net: txgbe: leave space for null terminators on property_entry

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: make hash table per queue

Scott Mitchell <scott.k.mitch1@gmail.com>
    netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation

Zhengchuan Liang <zcliangcn@gmail.com>
    netfilter: ip6t_eui64: reject invalid MAC header for all packets

Ren Wei <n05ec@lzu.edu.cn>
    netfilter: xt_multiport: validate range encoding in checkentry

Xiang Mei <xmei5@asu.edu>
    netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator

Weiming Shi <bestswngs@gmail.com>
    ipvs: fix NULL deref in ip_vs_add_service error path

Daniel Golle <daniel@makrotopia.org>
    selftests: net: bridge_vlan_mcast: wait for h1 before querier check

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    xfrm_user: fix info leak in build_mapping()

Kotlyarov Mihail <mihailkotlyarow@gmail.com>
    xfrm: fix refcount leak in xfrm_migrate_policy_find

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Wait for RCU readers during policy netns exit

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: validate MTU against usable frame size on bind

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: fix XDP_UMEM_SG_FLAG issues

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: respect tailroom for ZC setups

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: tighten UMEM headroom validation to account for tailroom and min frame

Agalakov Daniil <ade@amicon.ru>
    e1000: check return value of e1000_read_eeprom

Michal Schmidt <mschmidt@redhat.com>
    ixgbevf: add missing negotiate_features op to Hyper-V ops table

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing/probe: reject non-closed empty immediate strings

Jon Hunter <jonathanh@nvidia.com>
    dt-bindings: net: Fix Tegra234 MGBE PTP clock

Jon Hunter <jonathanh@nvidia.com>
    net: stmmac: Fix PTP ref clock for Tegra234

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: s3fwrn5: allocate rx skb before consuming bytes

Chris J Arges <carges@cloudflare.com>
    net: increase IP_TUNNEL_RECURSION_LIMIT to 5

Yiqi Sun <sunyiqixm@gmail.com>
    ipv4: icmp: fix null-ptr-deref in icmp_build_probe()

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv4: nexthop: allocate skb dynamically in rtm_get_nexthop()

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv4: nexthop: avoid duplicate NHA_HW_STATS_ENABLE on nexthop group dump

Eric Dumazet <edumazet@google.com>
    net: lapbether: handle NETDEV_PRE_TYPE_CHANGE

Ruide Cao <caoruide123@gmail.com>
    net: sched: act_csum: validate nested VLAN headers

Nicholas Carlini <nicholas@carlini.com>
    eventpoll: defer struct eventpoll free to RCU grace period

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Protect madv read in vc4_gem_object_mmap() with madv_lock

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Fix a memory leak in hang state error path

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Fix memory leak of BO array in hang state

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Release runtime PM reference after binding V3D

Keenan Dong <keenanat2000@gmail.com>
    xfrm: account XFRMA_IF_ID in aevent size calculation

Maximilian Pezzullo <maximilianpezzullo@gmail.com>
    HID: amd_sfh: don't log error when device discovery fails with -EOPNOTSUPP

Long Li <longli@microsoft.com>
    PCI: hv: Set default NUMA node to 0 for devices without affinity info

Serhii Pievniev <spevnev16@gmail.com>
    tools/power/turbostat: Fix microcode patch level output for AMD/Hygon

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    soc: qcom: pd-mapper: Fix element length in servreg_loc_pfr_req_ei

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: imx93-tqma9352: improve eMMC pad configuration

Luke Wang <ziniu.wang_1@nxp.com>
    arm64: dts: imx93-9x9-qsb: change usdhc tuning step for eMMC and SD

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency

Daniel J Blueman <daniel@quora.org>
    arm64: dts: qcom: hamoa/x1: fix idle exit latency

Potin Lai <potin.lai.pt@gmail.com>
    soc: aspeed: socinfo: Mask table entries for accurate SoC ID matching

Tomasz Merta <tomasz.merta@arrow.com>
    ASoC: stm32_sai: fix incorrect BCLK polarity for DSP_A/B, LEFT_J

John Pavlick <jspavlick@posteo.net>
    net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: brcmfmac: validate bsscfg indices in IF events

Arthur Husband <artmoty@gmail.com>
    ata: ahci: force 32-bit DMA for JMicron JMB582/JMB585

Benoît Sevens <bsevens@google.com>
    HID: roccat: fix use-after-free in roccat_report_event

songxiebing <songxiebing@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IAH10

leo vriska <leo@60228.dev>
    HID: quirks: add HID_QUIRK_ALWAYS_POLL for 8BitDo Pro 3

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Add Thinkpad L14 Gen3 to quirk_s2idle_bug

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)

Alexander Savenko <alex.sav4387@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IMH9

Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>
    ASoC: amd: yc: Add DMI entry for HP Laptop 15-fc0xxx

Fredric Cover <FredTheDude@proton.me>
    fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath

Phil Willoughby <willerz@gmail.com>
    ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for Samsung Book2 Pro 360 (NP950QED)

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: soc-core: call missing INIT_LIST_HEAD() for card_aux_list

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: wl1251: validate packet IDs before indexing tx_frames

Dustin L. Howett <dustin@howett.net>
    ALSA: hda/realtek: add quirk for Framework F111:000F

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry

Joel Fernandes <joelagnelf@nvidia.com>
    srcu: Use irq_work to start GP in tiny SRCU

Donet Tom <donettom@linux.ibm.com>
    drm/amdgpu: Handle GPU page faults correctly on non-4K page systems

César Montoya <sprit152009@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg0xxx

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()

Matthew Schwartz <matthew.schwartz@linux.dev>
    platform/x86: asus-nb-wmi: add DMI quirk for ASUS ROG Flow Z13-KJP GZ302EAC

Wenyuan Li <2063309626@qq.com>
    can: mcp251x: add error handling for power enable in open and resume

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: SOF: topology: reject invalid vendor array size in token parser

Zhang Heng <zhangheng@kylinos.cn>
    ASoC: amd: yc: Add DMI quirk for Thin A15 B7VF

Cen Zhang <zzzccc427@gmail.com>
    Bluetooth: hci_sync: annotate data-races around hdev->req_status

Arnd Bergmann <arnd@arndb.de>
    ALSA: asihpi: avoid write overflow check warning

Arnd Bergmann <arnd@arndb.de>
    media: rkvdec: reduce stack usage in rkvdec_init_v4l2_vp9_count_tbl()

Matthew Schwartz <matthew.schwartz@linux.dev>
    ALSA: hda/realtek: Add quirk for ASUS ROG Flow Z13-KJP GZ302EAC

Andrii Kovalchuk <coderpy4@proton.me>
    ALSA: hda/realtek: Add HP ENVY Laptop 13-ba0xxx quirk

Vee Satayamas <vsatayamas@gmail.com>
    ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix double free related to rereg_user_mr


-------------

Diffstat:

 Documentation/admin-guide/mm/damon/reclaim.rst     |   4 +
 .../bindings/net/nvidia,tegra234-mgbe.yaml         |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts    |   2 +
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi  |  26 +--
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |   2 +-
 arch/arm64/include/asm/uaccess.h                   |   2 +-
 arch/arm64/kvm/guest.c                             |   4 +-
 arch/loongarch/kvm/vcpu.c                          |   2 +-
 arch/loongarch/kvm/vm.c                            |   2 +-
 arch/mips/kvm/mips.c                               |   4 +-
 arch/powerpc/include/asm/uaccess.h                 |   3 +-
 arch/powerpc/kvm/book3s.c                          |   4 +-
 arch/powerpc/kvm/booke.c                           |   4 +-
 arch/powerpc/lib/pmem.c                            |  11 +-
 arch/riscv/kvm/vcpu.c                              |   2 +-
 arch/riscv/kvm/vm.c                                |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/x86/events/intel/uncore_discovery.c           |   2 +-
 arch/x86/include/asm/uaccess.h                     |   2 +-
 arch/x86/include/asm/uaccess_32.h                  |   8 +-
 arch/x86/include/asm/uaccess_64.h                  |  16 +-
 arch/x86/include/uapi/asm/kvm.h                    |  12 +-
 arch/x86/kvm/svm/sev.c                             |  24 ++-
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/lib/copy_user_uncached_64.S               |   6 +-
 arch/x86/lib/usercopy_32.c                         |   9 +-
 arch/x86/lib/usercopy_64.c                         |  12 +-
 crypto/af_alg.c                                    |   2 +
 crypto/algif_aead.c                                |   2 +-
 crypto/algif_skcipher.c                            |   5 +
 drivers/ata/ahci.c                                 |  14 ++
 drivers/gpio/gpio-tegra.c                          |   2 +-
 drivers/gpio/gpiolib.c                             |  43 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |   2 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   3 +
 drivers/gpu/drm/vc4/vc4_gem.c                      |  19 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  14 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   1 +
 drivers/gpu/drm/xe/xe_mmio.c                       | 135 ++++++-------
 drivers/gpu/drm/xe/xe_mmio.h                       |  72 ++-----
 drivers/gpu/drm/xe/xe_trace.h                      |   7 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   3 +-
 drivers/hid/hid-alps.c                             |   3 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-roccat.c                           |   2 +
 drivers/hwmon/powerz.c                             |   8 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   7 +-
 drivers/infiniband/hw/irdma/verbs.c                |   1 +
 drivers/infiniband/sw/rdmavt/qp.c                  |   8 +-
 drivers/md/bcache/super.c                          |   7 +
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c   |   9 +
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   4 +
 drivers/media/test-drivers/vidtv/vidtv_mux.c       |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_ts.c        |  48 ++---
 drivers/media/test-drivers/vidtv/vidtv_ts.h        |   4 +-
 drivers/media/usb/as102/as102_usb_drv.c            |   2 +
 drivers/media/usb/em28xx/em28xx-video.c            |  14 +-
 drivers/media/usb/hackrf/hackrf.c                  |   7 +-
 drivers/net/can/spi/mcp251x.c                      |  29 ++-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |   8 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |  15 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |  19 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   8 +-
 drivers/net/ipa/reg/gsi_reg-v5.0.c                 |   9 +-
 drivers/net/phy/sfp.c                              |  16 ++
 drivers/net/usb/cdc-phonet.c                       |   7 +-
 drivers/net/wan/lapbether.c                        |  13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   5 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   3 +-
 drivers/net/wireless/ti/wl1251/tx.c                |   8 +-
 drivers/nfc/s3fwrn5/uart.c                         |  10 +-
 drivers/ntb/ntb_transport.c                        |   7 +-
 drivers/pci/bus.c                                  |   6 +-
 drivers/pci/controller/pci-hyperv.c                |   8 +
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |   1 +
 drivers/pci/pci-driver.c                           |   8 -
 drivers/pci/pci.c                                  |  10 +-
 drivers/pci/pci.h                                  |   1 -
 drivers/pinctrl/intel/pinctrl-intel.c              |   2 +-
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |   9 +
 drivers/platform/x86/asus-nb-wmi.c                 |   2 +-
 drivers/soc/aspeed/aspeed-socinfo.c                |   2 +-
 drivers/soc/qcom/pdr_internal.h                    |   2 +-
 drivers/soc/qcom/qcom_pdr_msg.c                    |   2 +-
 drivers/staging/media/rkvdec/rkvdec-vp9.c          |   3 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |   2 +-
 drivers/staging/sm750fb/sm750.c                    |   3 +
 drivers/thermal/thermal_core.c                     |  36 +++-
 drivers/thermal/thermal_core.h                     |   1 +
 drivers/usb/class/cdc-acm.c                        |  53 ++++-
 drivers/usb/core/port.c                            |   1 +
 drivers/usb/gadget/function/f_hid.c                |  15 +-
 drivers/usb/gadget/function/f_ncm.c                |   4 +-
 drivers/usb/gadget/function/f_phonet.c             |   9 +
 drivers/usb/gadget/udc/renesas_usb3.c              |   7 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/storage/unusual_devs.h                 |   7 +-
 drivers/usb/usbip/usbip_common.c                   |  12 ++
 drivers/video/fbdev/tdfxfb.c                       |   3 +
 drivers/video/fbdev/udlfb.c                        |   3 +
 fs/dcache.c                                        |   4 +-
 fs/eventpoll.c                                     |   6 +-
 fs/nilfs2/dat.c                                    |   3 +
 fs/ocfs2/aops.c                                    |   3 +-
 fs/ocfs2/inode.c                                   |  31 +++
 fs/ocfs2/mmap.c                                    |   7 +-
 fs/ocfs2/ocfs2_trace.h                             |  10 +-
 fs/ocfs2/resize.c                                  |  10 +-
 fs/smb/client/fs_context.c                         |   4 +
 fs/smb/client/smb2inode.c                          |   2 +-
 fs/smb/server/connection.c                         |   1 +
 fs/smb/server/smb2pdu.c                            |   7 +-
 fs/smb/server/smbacl.c                             |   3 +-
 include/linux/clockchips.h                         |   2 +
 include/linux/kvm_host.h                           |  93 +++++----
 include/linux/soc/qcom/pdr.h                       |   1 +
 include/linux/srcutiny.h                           |   4 +
 include/linux/uaccess.h                            |  11 +-
 include/net/ip_tunnels.h                           |   2 +-
 include/net/netfilter/nf_queue.h                   |   1 -
 include/net/pkt_cls.h                              |   2 +
 include/net/xdp_sock.h                             |   2 +-
 include/net/xdp_sock_drv.h                         |  23 ++-
 include/trace/events/btrfs.h                       |  11 +-
 include/uapi/linux/kvm.h                           |  19 +-
 kernel/events/uprobes.c                            |   4 +
 kernel/fork.c                                      |  17 +-
 kernel/rcu/srcutiny.c                              |  19 +-
 kernel/sched/deadline.c                            |   2 +-
 kernel/time/clockevents.c                          |  27 ++-
 kernel/time/hrtimer.c                              |   1 +
 kernel/time/tick-broadcast.c                       |   8 +-
 kernel/time/tick-common.c                          |   1 +
 kernel/time/tick-sched.c                           |   1 +
 kernel/trace/trace_probe.c                         |   2 +-
 lib/iov_iter.c                                     |   4 +-
 mm/backing-dev.c                                   |   5 +-
 mm/kasan/init.c                                    |   8 +-
 net/bluetooth/hci_conn.c                           |   2 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/bluetooth/hci_sync.c                           |  20 +-
 net/can/raw.c                                      |  11 +-
 net/ipv4/icmp.c                                    |   7 +
 net/ipv4/nexthop.c                                 |  41 ++--
 net/ipv6/exthdrs.c                                 |   4 +
 net/ipv6/netfilter/ip6t_eui64.c                    |   3 +-
 net/ipv6/seg6_hmac.c                               |   2 +
 net/l2tp/l2tp_core.c                               |   5 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   1 -
 net/netfilter/nf_conntrack_netlink.c               |   2 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   3 +-
 net/netfilter/nfnetlink_log.c                      |   8 +-
 net/netfilter/nfnetlink_queue.c                    | 214 ++++++++-------------
 net/netfilter/nft_set_pipapo_avx2.c                |  20 +-
 net/netfilter/xt_multiport.c                       |  34 +++-
 net/nfc/digital_technology.c                       |   6 +
 net/nfc/llcp_core.c                                |   2 +
 net/rxrpc/key.c                                    |   5 +-
 net/sched/act_csum.c                               |   6 +-
 net/sched/em_cmp.c                                 |   5 +-
 net/sched/em_nbyte.c                               |   2 +
 net/sched/em_text.c                                |  11 +-
 net/unix/diag.c                                    |  21 +-
 net/xdp/xdp_umem.c                                 |   3 +-
 net/xdp/xsk.c                                      |   4 +-
 net/xdp/xsk_buff_pool.c                            |  32 ++-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_user.c                               |  11 +-
 scripts/checkpatch.pl                              |  10 +
 scripts/generate_rust_analyzer.py                  |   3 +-
 sound/firewire/fireworks/fireworks_command.c       |   5 +-
 sound/pci/asihpi/hpimsgx.c                         |   6 +-
 sound/pci/ctxfi/ctvmem.h                           |   2 +-
 sound/pci/hda/patch_realtek.c                      |  10 +
 sound/soc/amd/yc/acp6x-mach.c                      |  21 ++
 sound/soc/qcom/qdsp6/q6apm.c                       |  14 +-
 sound/soc/soc-core.c                               |   1 +
 sound/soc/sof/topology.c                           |   2 +-
 sound/soc/stm/stm32_sai_sub.c                      |   3 +
 sound/usb/6fire/chip.c                             |  17 +-
 sound/usb/format.c                                 |  86 +++++++--
 sound/usb/quirks.c                                 |   2 +
 tools/objtool/check.c                              |   2 +-
 tools/power/x86/turbostat/turbostat.c              |   9 +-
 .../selftests/net/forwarding/bridge_vlan_mcast.sh  |   1 +
 virt/kvm/binary_stats.c                            |   2 +-
 virt/kvm/kvm_main.c                                |  20 +-
 195 files changed, 1379 insertions(+), 736 deletions(-)


