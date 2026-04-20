Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87B8329C6D;
	Mon, 20 Apr 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700014; cv=none; b=LIMG7+EqLJdBoG0blPIePr8ev3xVDDBR85n59hgKvgbKG8q+UjSGVD9DxjHU2fIZqKYBV92bFvD9aEH/Kpj/IJHRV9CzlBb9xQqXC9ssgtdDcKMRTOZzLZYZrX4Zh03wKoe/GUY9I6kZDIvve56wBNwq5w8WADTIIEgoQqW3CfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700014; c=relaxed/simple;
	bh=6eZ7HL+YeAbfaK3PP7gb5WSebSLBZEQtcIWSNkkQUGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mIsdOsuewukVzU5/omaCe0vHN7guVt6WYB+himzh37RVj2UW+O9dsmCVZDpwvzpdqs857pUWfVhpr9corCxJYqiiTAQIL43rW1LJfXeSfJliQpzWt3XG2noGgmc/BvzQFCbM3/6EWTWZBitjckFUlFakG8waffNqENyV5HZtMmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lj0EWRim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lj0EWRim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAB5C19425;
	Mon, 20 Apr 2026 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700014;
	bh=6eZ7HL+YeAbfaK3PP7gb5WSebSLBZEQtcIWSNkkQUGU=;
	h=From:To:Cc:Subject:Date:From;
	b=lj0EWRim8CDZPEHPFNjjeYkzkNx93rk1uhZMJAU9n+BXRTl4s36AdqXcQDhmx/xYo
	 imH+8Kc7utmADnF4ncIZ1wQZYL46RGYYPZkLvJeXyO7ttQ5Tga3scvdVI42LMlCYb9
	 kk9agjSjRGo5K6LK7rvukKTZdDP8Clg2W78rWbYs=
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
Subject: [PATCH 6.19 000/220] 6.19.14-rc1 review
Date: Mon, 20 Apr 2026 17:39:01 +0200
Message-ID: <20260420153934.013228280@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.19.14-rc1
X-KernelTest-Deadline: 2026-04-22T15:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.19.14 release.
There are 220 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Apr 2026 15:38:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.19.14-rc1

Leon Romanovsky <leon@kernel.org>
    dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output

Leon Romanovsky <leon@kernel.org>
    dma-debug: Allow multiple invocations of overlapping entries

Jianhui Zhou <jianhuizzzzz@gmail.com>
    mm/userfaultfd: fix hugetlb fault mutex hash calculation

Jeongjun Park <aha310510@gmail.com>
    media: hackrf: fix to not free memory after the device is registered in hackrf_probe()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    media: vidtv: fix pass-by-value structs causing MSAN warnings

Deepanshu Kartikey <kartikey406@gmail.com>
    nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map

Jeongjun Park <aha310510@gmail.com>
    media: as102: fix to not free memory after the device is registered in as102_usb_probe()

Shardul Bankar <shardul.b@mpiricsoftware.com>
    wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit

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

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix out-of-bounds write in ocfs2_write_end_inline

Deepanshu Kartikey <kartikey406@gmail.com>
    ocfs2: validate inline data i_size during inode read

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86: Use __DECLARE_FLEX_ARRAY() for UAPI structures with VLAs

Sean Christopherson <seanjc@google.com>
    KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay

Paul Chaignon <paul.chaignon@gmail.com>
    selftests/bpf: Test refinement of single-value tnum

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: call ->free_folio() directly in folio_unmap_invalidate()

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Drop WARN on large size for KVM_MEMORY_ENCRYPT_REG_REGION

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Lock all vCPUs when synchronzing VMSAs for SNP launch finish

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Disallow LAUNCH_FINISH if vCPUs are actively being created

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Reject attempts to sync VMSA of an already-launched/encrypted vCPU

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Remove duplicate resource teardown

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

Ryan Roberts <ryan.roberts@arm.com>
    arm64: mm: Handle invalid large leaf mappings correctly

Michał Winiarski <michal.winiarski@intel.com>
    vfio/xe: Reorganize the init to decouple migration from reset

Zhihao Cheng <chengzhihao1@huawei.com>
    dcache: Limit the minimal number of bucket to two

Harin Lee <me@harin.net>
    ALSA: ctxfi: Limit PTP to a single page

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A MBIM composition

Alistair Popple <apopple@nvidia.com>
    selftests/mm: hmm-tests: don't hardcode THP size to 2MB

Junrui Luo <moonafterrain@outlook.com>
    staging: sm750fb: fix division by zero in ps_to_hz()

Johan Hovold <johan@kernel.org>
    wifi: rtw88: fix device leak on probe failure

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer.py: avoid FD leak

Benjamin Berg <benjamin.berg@intel.com>
    scripts/gdb/symbols: handle module path parameters

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

Alexey Charkov <alchark@flipper.net>
    usb: typec: fusb302: Switch to threaded IRQ handler

Nathan Rebello <nathan.c.rebello@gmail.com>
    usbip: validate number_of_packets in usbip_pack_ret_submit()

Stefan Metzmacher <metze@samba.org>
    smb: server: avoid double-free in smb_direct_free_sendmsg after smb_direct_flush_send_list()

Stefan Metzmacher <metze@samba.org>
    smb: client: avoid double-free in smbd_free_send_io() after smbd_send_batch_flush()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: require 3 sub-authorities before reading sub_auth[2]

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: validate EaNameLength in smb2_get_ea()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    smb: client: fix OOB reads parsing symlink error response

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
    ALSA: usx2y: us144mkii: fix NULL deref on missing interface 0

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bnge: return after auxiliary_device_uninit() in error path

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

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_aead - Fix minimum RX size check for decryption

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl

Thomas Gleixner <tglx@kernel.org>
    clockevents: Prevent timer interrupt starvation

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Use revised wakeup rule for dl_server

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix die ID init and look up bugs

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

Li RongQing <lirongqing@baidu.com>
    devlink: Fix incorrect skb socket family dumping

Jiexun Wang <wangjiexun2025@gmail.com>
    af_unix: read UNIX_DIAG_VFS data under unix_state_lock

Fabio Baltieri <fabio.baltieri@gmail.com>
    net: txgbe: leave space for null terminators on property_entry

Justin Iurman <justin.iurman@gmail.com>
    net: ioam6: fix OOB and missing lock

Felix Gu <ustc.gu@gmail.com>
    net: mdio: realtek-rtl9300: use scoped device_for_each_child_node loop

Syed Saba Kareem <Syed.SabaKareem@amd.com>
    ASoC: amd: acp: update DMI quirk and add ACP DMIC for Lenovo platforms

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: SDCA: Unregister IRQ handlers on module remove

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: SDCA: Fix overwritten var within for loop

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

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    drm/xe: Fix bug in idledly unit conversion

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Fix memory leak in avs_register_i2s_test_boards()

Francesco Lavra <flavra@baylibre.com>
    pinctrl: mcp23s08: Disable all pin interrupts during probe

Zhengchuan Liang <zcliangcn@gmail.com>
    net: af_key: zero aligned sockaddr tail in PF_KEY exports

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    xfrm_user: fix info leak in build_mapping()

Kotlyarov Mihail <mihailkotlyarow@gmail.com>
    xfrm: fix refcount leak in xfrm_migrate_policy_find

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Wait for RCU readers during policy netns exit

Stefano Garzarella <sgarzare@redhat.com>
    vsock/test: fix send_buf()/recv_buf() EINTR handling

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

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    ixgbe: stop re-reading flash on every get_drvinfo for e610

Kohei Enju <kohei@enjuk.jp>
    ice: ptp: don't WARN when controlling PF is unavailable

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: SOF: Intel: fix iteration in is_endpoint_present()

Maciej Strozek <mstrozek@opensource.cirrus.com>
    ASoC: SOF: Intel: Fix endpoint index if endpoints are missing

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Fix errors in IRQ cleanup

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: SDCA: Add ASoC jack hookup in class driver

Pengpeng Hou <pengpeng@iscas.ac.cn>
    tracing/probe: reject non-closed empty immediate strings

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    mshv: Fix infinite fault loop on permission-denied GPA intercepts

Sahil Chandna <sahilchandna@linux.microsoft.com>
    PCI: hv: Fix double ida_free in hv_pci_probe error path

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

Nikolaos Gkarlis <nickgarlis@gmail.com>
    rtnetlink: add missing netlink_ns_capable() check for peer netns

Zijing Yin <yzjaurora@gmail.com>
    bridge: guard local VLAN-0 FDB helpers against NULL vlan group

Eric Dumazet <edumazet@google.com>
    ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()

Lorenzo Bianconi <lorenzo@kernel.org>
    net: airoha: Fix memory leak in airoha_qdma_rx_process()

Eric Dumazet <edumazet@google.com>
    net: lapbether: handle NETDEV_PRE_TYPE_CHANGE

Arnd Bergmann <arnd@arndb.de>
    net: fec: make FIXED_PHY dependency unconditional

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

NeilBrown <neilb@ownmail.net>
    cachefiles: fix incorrect dentry refcount in cachefiles_cull()

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    dma-debug: suppress cacheline overlap warning when arch has no DMA alignment requirement

Michael S. Tsirkin <mst@redhat.com>
    dma-debug: track cache clean flag in entries

Michael S. Tsirkin <mst@redhat.com>
    dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN

Keenan Dong <keenanat2000@gmail.com>
    xfrm: account XFRMA_IF_ID in aevent size calculation

Maximilian Pezzullo <maximilianpezzullo@gmail.com>
    HID: amd_sfh: don't log error when device discovery fails with -EOPNOTSUPP

Long Li <longli@microsoft.com>
    PCI: hv: Set default NUMA node to 0 for devices without affinity info

Mihai Sain <mihai.sain@microchip.com>
    ARM: dts: microchip: sam9x7: fix gpio-lines count for pioB

Felix Gu <ustc.gu@gmail.com>
    soc: microchip: mpfs-mss-top-sysreg: Fix resource leak on driver unbind

Felix Gu <ustc.gu@gmail.com>
    soc: microchip: mpfs-control-scb: Fix resource leak on driver unbind

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    tools/power turbostat: Fix delimiter bug in print functions

Loic Poulain <loic.poulain@oss.qualcomm.com>
    arm64: dts: qcom: monaco: Reserve full Gunyah metadata region

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    tools/power turbostat: Fix --show/--hide for individual cpuidle counters

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    tools/power turbostat: Fix incorrect format variable

Serhii Pievniev <spevnev16@gmail.com>
    tools/power/turbostat: Fix microcode patch level output for AMD/Hygon

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix swidle header vs data display

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    soc: qcom: pd-mapper: Fix element length in servreg_loc_pfr_req_ei

Loic Poulain <loic.poulain@oss.qualcomm.com>
    arm64: dts: qcom: monaco: Fix UART10 pinconf

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: imx93-tqma9352: improve eMMC pad configuration

Markus Niebel <Markus.Niebel@ew.tq-group.com>
    arm64: dts: imx91-tqma9131: improve eMMC pad configuration

Luke Wang <ziniu.wang_1@nxp.com>
    arm64: dts: imx93-9x9-qsb: change usdhc tuning step for eMMC and SD

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq: Set the correct gpu_ahb clock frequency

Ravi Hothi <ravi.hothi@oss.qualcomm.com>
    arm64: dts: qcom: qcm6490-idp: Fix WCD9370 reset GPIO polarity

Daniel J Blueman <daniel@quora.org>
    arm64: dts: qcom: hamoa/x1: fix idle exit latency

Potin Lai <potin.lai.pt@gmail.com>
    soc: aspeed: socinfo: Mask table entries for accurate SoC ID matching

Tomasz Merta <tomasz.merta@arrow.com>
    ASoC: stm32_sai: fix incorrect BCLK polarity for DSP_A/B, LEFT_J

Linus Torvalds <torvalds@linux-foundation.org>
    x86: shadow stacks: proper error handling for mmap lock

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

Even Xu <even.xu@intel.com>
    HID: Intel-thc-hid: Intel-quickspi: Add NVL Device IDs

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

Donet Tom <donettom@linux.ibm.com>
    drm/amdkfd: Fix queue preemption/eviction failures by aligning control stack size to GPU page size

songxiebing <songxiebing@kylinos.cn>
    ALSA: hda/realtek: Add quirk for Lenovo Yoga Slim 7 14AKP10

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

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed Speaker Mute LED for HP EliteBoard G1a platform

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo_avx2: don't return non-matching entry on expiry

Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>
    ALSA: hda/realtek: add HP Laptop 15-fd0xxx mute LED quirk

Joel Fernandes <joelagnelf@nvidia.com>
    srcu: Use irq_work to start GP in tiny SRCU

Donet Tom <donettom@linux.ibm.com>
    drm/amdgpu: Handle GPU page faults correctly on non-4K page systems

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: ctnetlink: ensure safe access to master conntrack

César Montoya <sprit152009@gmail.com>
    ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg0xxx

Goldwyn Rodrigues <rgoldwyn@suse.de>
    btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()

Krishna Chomal <krishna.chomal108@gmail.com>
    platform/x86: hp-wmi: Add support for Omen 16-wf1xxx (8C76)

Filipe Manana <fdmanana@suse.com>
    btrfs: fix zero size inode with non-zero size after log replay

Matthew Schwartz <matthew.schwartz@linux.dev>
    platform/x86: asus-nb-wmi: add DMI quirk for ASUS ROG Flow Z13-KJP GZ302EAC

Frank Zhang <rmxpzlb@gmail.com>
    ALSA:usb:qcom: add AUXILIARY_BUS to Kconfig dependencies

Hasun Park <hasunpark@gmail.com>
    ASoC: amd: acp: add ASUS HN7306EA quirk for legacy SDW machine

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

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda/realtek: add quirk for Lenovo Yoga 7 2-in-1 16AKP10

Andrii Kovalchuk <coderpy4@proton.me>
    ALSA: hda/realtek: Add HP ENVY Laptop 13-ba0xxx quirk

Vee Satayamas <vsatayamas@gmail.com>
    ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Fix double free related to rereg_user_mr

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    dmaengine: idxd: Fix lockdep warnings when calling idxd_device_config()


-------------

Diffstat:

 Documentation/admin-guide/mm/damon/reclaim.rst     |   4 +
 .../bindings/net/nvidia,tegra234-mgbe.yaml         |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/microchip/sam9x7.dtsi            |   2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx91-tqma9131.dtsi  |  20 +-
 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts    |   2 +
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi  |  26 +--
 arch/arm64/boot/dts/qcom/hamoa.dtsi                |   2 +-
 arch/arm64/boot/dts/qcom/monaco.dtsi               |   9 +-
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts           |   2 +-
 arch/arm64/include/asm/pgtable-prot.h              |   2 +
 arch/arm64/include/asm/pgtable.h                   |   9 +-
 arch/arm64/include/asm/uaccess.h                   |   2 +-
 arch/arm64/kvm/guest.c                             |   4 +-
 arch/arm64/mm/mmu.c                                |   4 +
 arch/arm64/mm/pageattr.c                           |  50 ++---
 arch/arm64/mm/trans_pgd.c                          |  42 +---
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
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/events/intel/uncore_discovery.c           |   2 +-
 arch/x86/events/intel/uncore_snbep.c               |  13 +-
 arch/x86/include/asm/uaccess.h                     |   2 +-
 arch/x86/include/asm/uaccess_32.h                  |   8 +-
 arch/x86/include/asm/uaccess_64.h                  |  16 +-
 arch/x86/include/uapi/asm/kvm.h                    |  12 +-
 arch/x86/kernel/shstk.c                            |   3 +-
 arch/x86/kvm/svm/sev.c                             |  46 +++--
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/lib/copy_user_uncached_64.S               |   6 +-
 arch/x86/lib/usercopy_32.c                         |   9 +-
 arch/x86/lib/usercopy_64.c                         |  12 +-
 crypto/af_alg.c                                    |   6 +-
 crypto/algif_aead.c                                |   2 +-
 crypto/algif_skcipher.c                            |   5 +
 drivers/ata/ahci.c                                 |  14 ++
 drivers/dma/idxd/device.c                          |  17 +-
 drivers/dma/idxd/init.c                            |  10 +-
 drivers/gpio/gpio-tegra.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   7 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |   2 +-
 drivers/gpu/drm/vc4/vc4_bo.c                       |   3 +
 drivers/gpu/drm/vc4/vc4_gem.c                      |  19 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  14 +-
 drivers/gpu/drm/vc4/vc4_v3d.c                      |   1 +
 drivers/gpu/drm/xe/xe_hw_engine.c                  |   3 +-
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   3 +-
 drivers/hid/hid-alps.c                             |   3 +
 drivers/hid/hid-core.c                             |   3 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-roccat.c                           |   2 +
 .../intel-thc-hid/intel-quickspi/pci-quickspi.c    |   6 +
 .../intel-thc-hid/intel-quickspi/quickspi-dev.h    |   2 +
 drivers/hv/mshv_root_main.c                        |  15 +-
 drivers/hwmon/powerz.c                             |   8 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   7 +-
 drivers/infiniband/hw/irdma/verbs.c                |   1 +
 drivers/infiniband/sw/rdmavt/qp.c                  |   8 +-
 drivers/md/bcache/super.c                          |   7 +
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c   |   9 +
 .../media/platform/rockchip/rkvdec/rkvdec-vp9.c    |   3 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |   4 +
 drivers/media/test-drivers/vidtv/vidtv_mux.c       |   4 +-
 drivers/media/test-drivers/vidtv/vidtv_ts.c        |  48 ++---
 drivers/media/test-drivers/vidtv/vidtv_ts.h        |   4 +-
 drivers/media/usb/as102/as102_usb_drv.c            |   2 +
 drivers/media/usb/em28xx/em28xx-video.c            |  14 +-
 drivers/media/usb/hackrf/hackrf.c                  |   7 +-
 drivers/net/can/spi/mcp251x.c                      |  29 ++-
 drivers/net/ethernet/airoha/airoha_eth.c           |   3 +-
 drivers/net/ethernet/broadcom/bnge/bnge_auxr.c     |   1 +
 drivers/net/ethernet/freescale/Kconfig             |   2 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |   8 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   8 +-
 drivers/net/ethernet/intel/ixgbe/devlink/devlink.c |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |  13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  10 +
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |  19 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   8 +-
 drivers/net/ipa/reg/gsi_reg-v5.0.c                 |   9 +-
 drivers/net/mdio/mdio-realtek-rtl9300.c            |   3 +-
 drivers/net/phy/sfp.c                              |  16 ++
 drivers/net/usb/cdc-phonet.c                       |   7 +-
 drivers/net/wan/lapbether.c                        |  13 +-
 drivers/net/wireguard/device.c                     |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   5 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   3 +-
 drivers/net/wireless/ti/wl1251/tx.c                |   8 +-
 drivers/nfc/s3fwrn5/uart.c                         |  10 +-
 drivers/ntb/ntb_transport.c                        |   7 +-
 drivers/pci/controller/pci-hyperv.c                |  12 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  20 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   2 +-
 drivers/pinctrl/pinctrl-mcp23s08.c                 |   9 +
 drivers/platform/x86/amd/pmc/pmc-quirks.c          |   9 +
 drivers/platform/x86/asus-nb-wmi.c                 |   2 +-
 drivers/platform/x86/hp/hp-wmi.c                   |   4 +
 drivers/soc/aspeed/aspeed-socinfo.c                |   2 +-
 drivers/soc/microchip/mpfs-control-scb.c           |   6 +-
 drivers/soc/microchip/mpfs-mss-top-sysreg.c        |   6 +-
 drivers/soc/qcom/pdr_internal.h                    |   2 +-
 drivers/soc/qcom/qcom_pdr_msg.c                    |   2 +-
 drivers/staging/rtl8723bs/core/rtw_security.c      |   2 +-
 drivers/staging/sm750fb/sm750.c                    |   3 +
 drivers/usb/class/cdc-acm.c                        |  53 ++++-
 drivers/usb/core/port.c                            |   1 +
 drivers/usb/gadget/function/f_hid.c                |  15 +-
 drivers/usb/gadget/function/f_ncm.c                |   4 +-
 drivers/usb/gadget/function/f_phonet.c             |   9 +
 drivers/usb/gadget/udc/renesas_usb3.c              |   7 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/storage/unusual_devs.h                 |   7 +-
 drivers/usb/typec/tcpm/fusb302.c                   |   5 +-
 drivers/usb/usbip/usbip_common.c                   |  12 ++
 drivers/vfio/pci/xe/main.c                         |  43 +++--
 drivers/video/fbdev/tdfxfb.c                       |   3 +
 drivers/video/fbdev/udlfb.c                        |   3 +
 fs/btrfs/tree-log.c                                |  98 ++++++----
 fs/cachefiles/namei.c                              |   5 +
 fs/dcache.c                                        |   4 +-
 fs/eventpoll.c                                     |   6 +-
 fs/nilfs2/dat.c                                    |   3 +
 fs/ocfs2/aops.c                                    |   3 +-
 fs/ocfs2/inode.c                                   |  35 +++-
 fs/ocfs2/mmap.c                                    |   7 +-
 fs/ocfs2/ocfs2_trace.h                             |  10 +-
 fs/ocfs2/resize.c                                  |  10 +-
 fs/smb/client/fs_context.c                         |   4 +
 fs/smb/client/smb2file.c                           |  20 +-
 fs/smb/client/smb2inode.c                          |   2 +-
 fs/smb/client/smbdirect.c                          |   8 +
 fs/smb/server/connection.c                         |   1 +
 fs/smb/server/smb2pdu.c                            |   7 +-
 fs/smb/server/smbacl.c                             |   3 +-
 fs/smb/server/transport_rdma.c                     |   8 +-
 include/hyperv/hvgdk_mini.h                        |   6 +
 include/hyperv/hvhdk.h                             |   4 +-
 include/linux/clockchips.h                         |   2 +
 include/linux/dma-mapping.h                        |   7 +
 include/linux/hugetlb.h                            |  17 ++
 include/linux/kvm_host.h                           |  93 +++++----
 include/linux/mmap_lock.h                          |   6 +-
 include/linux/soc/qcom/pdr.h                       |   1 +
 include/linux/srcutiny.h                           |   4 +
 include/linux/uaccess.h                            |  11 +-
 include/net/ip_tunnels.h                           |   2 +-
 include/net/netfilter/nf_conntrack_core.h          |   5 +
 include/net/netfilter/nf_queue.h                   |   1 -
 include/net/xdp_sock.h                             |   2 +-
 include/net/xdp_sock_drv.h                         |  23 ++-
 include/sound/sdca_interrupts.h                    |   5 +
 include/trace/events/btrfs.h                       |  11 +-
 include/trace/events/dma.h                         |   3 +-
 include/uapi/linux/kvm.h                           |  19 +-
 kernel/dma/debug.c                                 |  35 +++-
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
 mm/filemap.c                                       |   3 +-
 mm/internal.h                                      |   1 -
 mm/kasan/init.c                                    |   8 +-
 mm/truncate.c                                      |   6 +-
 mm/userfaultfd.c                                   |   2 +-
 net/bluetooth/hci_conn.c                           |   2 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/bluetooth/hci_sync.c                           |  20 +-
 net/bridge/br_fdb.c                                |   6 +
 net/can/raw.c                                      |  11 +-
 net/core/rtnetlink.c                               |  40 ++--
 net/devlink/health.c                               |   2 +-
 net/ipv4/icmp.c                                    |   7 +
 net/ipv4/nexthop.c                                 |  41 ++--
 net/ipv6/ioam6.c                                   |  33 ++--
 net/ipv6/netfilter/ip6t_eui64.c                    |   3 +-
 net/key/af_key.c                                   |  52 +++--
 net/l2tp/l2tp_core.c                               |   5 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   1 -
 net/netfilter/nf_conntrack_ecache.c                |   2 +
 net/netfilter/nf_conntrack_expect.c                |  10 +-
 net/netfilter/nf_conntrack_netlink.c               |  28 ++-
 net/netfilter/nfnetlink_log.c                      |   8 +-
 net/netfilter/nfnetlink_queue.c                    | 214 ++++++++-------------
 net/netfilter/nft_set_pipapo_avx2.c                |  20 +-
 net/netfilter/xt_multiport.c                       |  34 +++-
 net/nfc/digital_technology.c                       |   6 +
 net/nfc/llcp_core.c                                |   2 +
 net/sched/act_csum.c                               |   6 +-
 net/unix/diag.c                                    |  21 +-
 net/xdp/xdp_umem.c                                 |   3 +-
 net/xdp/xsk.c                                      |   4 +-
 net/xdp/xsk_buff_pool.c                            |  32 ++-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_user.c                               |  11 +-
 scripts/checkpatch.pl                              |  10 +
 scripts/gdb/linux/symbols.py                       |   2 +-
 scripts/generate_rust_analyzer.py                  |   3 +-
 sound/firewire/fireworks/fireworks_command.c       |   5 +-
 sound/hda/codecs/realtek/alc269.c                  |  35 +++-
 sound/pci/asihpi/hpimsgx.c                         |   6 +-
 sound/pci/ctxfi/ctvmem.h                           |   2 +-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c            |  16 +-
 sound/soc/amd/yc/acp6x-mach.c                      |  21 ++
 sound/soc/intel/avs/board_selection.c              |   9 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |  14 +-
 sound/soc/sdca/sdca_class_function.c               |  30 +++
 sound/soc/sdca/sdca_interrupts.c                   |  80 +++++++-
 sound/soc/soc-core.c                               |   1 +
 sound/soc/sof/intel/hda.c                          |  10 +-
 sound/soc/sof/topology.c                           |   2 +-
 sound/soc/stm/stm32_sai_sub.c                      |   3 +
 sound/usb/6fire/chip.c                             |  17 +-
 sound/usb/Kconfig                                  |   1 +
 sound/usb/quirks.c                                 |   2 +
 sound/usb/usx2y/us144mkii.c                        |   6 +-
 tools/objtool/check.c                              |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  67 ++++---
 .../testing/selftests/bpf/progs/verifier_bounds.c  | 137 +++++++++++++
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  |   2 -
 tools/testing/selftests/mm/hmm-tests.c             |  83 ++------
 .../selftests/net/forwarding/bridge_vlan_mcast.sh  |   1 +
 tools/testing/vsock/util.c                         |   8 +-
 virt/kvm/binary_stats.c                            |   2 +-
 virt/kvm/kvm_main.c                                |  20 +-
 245 files changed, 1954 insertions(+), 958 deletions(-)


