Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3B550E59B;
	Wed, 30 Sep 2026 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782399; cv=none; b=Rx/SlnDv+QK7xbpMDnvXLmIdOi9t291BOYYN4ioGDLTRcC4oedu9eY4fGo/CA4wkFaAIx7HCm0TZudDW1WmfkOLZCHAmNJh35oGVA7qn/vTqAcs2T5f9nVRYkDZgEl/hndUeL6oreUTJgI3J1u4vxd+VxZO6W/Twv8YfcitWGI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782399; c=relaxed/simple;
	bh=nHU7gzsI1h/8jN/li+vdua4jK493lXnl2M4KEgZP9lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ul3WKodPEfkP6sAtQMG2X2MC4r4qBGjvYLryX/TR58vxnMumCd6CU9vNOQ8/0afFiYc3aS+aHUu8RIt14uDN+wPRZ9QT/VgUx5/9SvbQaWPORFWmzAFtZl+UxScErGdP21MYjzEOGNgJ0sTrW6NyoYJEMip1K5f589vTM+MokFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXgyw/x3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXgyw/x3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B341F0089A;
	Wed, 30 Sep 2026 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782368;
	bh=ZEVN75yfwKJF8CayEtMcJ6Mg+zb6w+ZO/We1U3USDJE=;
	h=From:To:Cc:Subject:Date;
	b=jXgyw/x3qPD8+cp95ZpsItqreNSrVPNQx0mnF7dF+tTg0heMIsCfVRTuW8S3Gw819
	 BrMTqONHiDWQ0OWAeo8UDkTry37yqvdp7QhzrPTK9p/WrNSqsqAPX0wsGqGkjcudA2
	 O6WTrP2uYMlX93rhtp14VHeagiLm7X8D0p+D9ggE=
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
Subject: [PATCH 5.10 000/595] 5.10.271-rc1 review
Date: Wed, 30 Sep 2026 17:18:13 +0200
Message-ID: <20260930152347.700140858@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.271-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.271-rc1
X-KernelTest-Deadline: 2026-10-02T15:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.271 release.
There are 595 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.271-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.271-rc1

Pengpeng Hou <pengpeng@iscas.ac.cn>
    can: ems_usb: validate CPC message lengths

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()

Rengarajan S <rengarajan.s@microchip.com>
    lan78xx: Enable Auto Speed and Auto Duplex configuration for LAN7801 if NO EEPROM is detected

Rengarajan S <rengarajan.s@microchip.com>
    lan78xx: Enable 125 MHz CLK configuration for LAN7801 if NO EEPROM is detected

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: fix NULL dereference of dlc->session in RFCOMM_CONNINFO

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: L2CAP: validate frame length before control and FCS access

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: reject out-of-range OCF values

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: validate event length before filtering

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Fix NULL pointer dereference in ccw_device_get_util_str()

Myeonghun Pak <mhun512@gmail.com>
    pinctrl: single: free the IRQ on domain creation failure

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    scsi: libiscsi_tcp: Check the data direction of a Data-In PDU

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: port100: reject frames whose declared length exceeds the received data

Aamir Ahmed <elb12345@hotmail.co.uk>
    nfc: llcp: drop truncated I/RR/RNR PDUs in nfc_llcp_recv_hdlc()

Luxiao Xu <rakukuip@gmail.com>
    nfc: fix use-after-free in nfc_get_local_general_bytes

Luxiao Xu <rakukuip@gmail.com>
    netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read

Weiming Shi <bestswngs@gmail.com>
    netfilter: ip6t_rpfilter: reject routes without inet6_dev

Ming Wang <wangming01@loongson.cn>
    net: usb: cdc_mbim: add MeiG Smart SRM821 to ZLP whitelist

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1e: fix soft lockup on out-of-range hw_next_to_clean read

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1c: fix soft lockup on out-of-range tpd_cons read

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: conntrack: avoid modifying shared unconfirmed ct entry

Wentao Liang <vulab@iscas.ac.cn>
    net: hisilicon: hns_dsaf_mac: fix mdio device leak in hns_mac_register_phy()

Gajdos Tamás <tamas@rimpianto.com>
    net: atl1: fix soft lockup on out-of-range cmb_tpd_next_to_clean read

Zijie Huang <milkory@outlook.com>
    net: arp: terminate device name before lookup

Weiming Shi <bestswngs@gmail.com>
    net/sched: reject IDR error pointers when deleting actions

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: Fix rev_entry reference leak in mlx5_tc_ct_shared_counter_get()

Wei Jie LAW <98lawweijie@gmail.com>
    HID: wacom: fix OOB read in wacom_wac_pen_serial_enforce()

Junjie Cao <junjie.cao@intel.com>
    HID: quirks: add ALWAYS_POLL quirk for SDINNOVATION gaming keyboard

Chen Changcheng <chenchangcheng@kylinos.cn>
    HID: alps: fix use-after-free on input2 registration failure

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix gem reference leak in validate_init()

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: fix double-free in nvif_vmm_dtor

Wentao Liang <vulab@iscas.ac.cn>
    drm/nouveau: Fix bridge reference leak in nv1a_ram_new()

Guangshuo Li <lgs201920130244@gmail.com>
    drm/nouveau: fix autosuspend cleanup during teardown

Dongliang Qin <cccccccccccc777777@gmail.com>
    rds: ib: Clear the sg list when mapping an MR fails

Zixuan Chai <petalzu987@gmail.com>
    llc: reserve device headroom for allocated frames

Ridham Khurana <khurana.ridham222@gmail.com>
    gpio: zynq: fix runtime PM leak on request error path

Wentao Liang <vulab@iscas.ac.cn>
    gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()

Hui Peng <benquike@gmail.com>
    ipv6: sr: enforce exact attribute length for SEG6_ATTR_DST

Norbert Szetei <norbert@doyensec.com>
    ipv6: do not let ipv6_find_hdr() return an offset past the packet end

Wentao Liang <vulab@iscas.ac.cn>
    fsl/fman: Fix clk reference leak in read_dts_node()

Pavankumar Kondeti <pavan.kondeti@oss.qualcomm.com>
    workqueue: Fix NULL current_pwq deref in flush dependency check

Hui Peng <benquike@gmail.com>
    fou: reject omitted FOU_ATTR_IPPROTO on FOU_ENCAP_DIRECT

Dairui Zhang <zhangdairui@gmail.com>
    af_packet: fix integer overflow in prb_calc_retire_blk_tmo()

Aohan Mei <henrymei@tencent.com>
    sctp: discard the rest of the packet on a stale-cookie error

Eric Dumazet <edumazet@google.com>
    tipc: reject invalid and unexpected GRP_ACK_MSG to prevent bc_ackers underflow

Mario Limonciello <mario.limonciello@amd.com>
    x86/PCI: Disable enhanced atomics on AMD NBIO 7.7 and 7.11

Eric Dumazet <edumazet@google.com>
    net: preserve skb_end_offset() in skb_unclone_keeptruesize()

Eric Dumazet <edumazet@google.com>
    net: add skb_set_end_offset() helper

Eric Dumazet <edumazet@google.com>
    net: add and use skb_unclone_keeptruesize() helper

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

Pablo Neira Ayuso <pablo@netfilter.org>
    rculist: add list_splice_rcu() for private lists

Hui Peng <benquike@gmail.com>
    autofs: fix sbi->pipe file reference leak in autofs_kill_sb()

Eric Dumazet <edumazet@google.com>
    vlan: ensure sufficient headroom in vlan_dev_hard_header()

Eric Dumazet <edumazet@google.com>
    net/sched: sch_teql: fix shadowed err in __teql_resolve()

Eric Dumazet <edumazet@google.com>
    bridge: check llc_mac_hdr_init() return value in br_send_bpdu()

Eric Dumazet <edumazet@google.com>
    llc: fix skb UAF and leaks on llc_mac_hdr_init() failure

Ginger Li <ginger.jzllee@gmail.com>
    tipc: Fix a data race on mon->peer_cnt in mon_timeout()

Norbert Szetei <norbert@doyensec.com>
    net: xps: reject an out of range traffic class

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ip_gre: Reject enabling collect metadata through changelink

Shihuang Liu <shlomojune6@gmail.com>
    net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_gate: budget the per-entry list in get_fill_size

Nam Cao <namcao@linutronix.de>
    hrtimers: Introduce hrtimer_setup() to replace hrtimer_init()

Nam Cao <namcao@linutronix.de>
    hrtimers: Add missing hrtimer_init() trace points

Baowen Zheng <baowen.zheng@corigine.com>
    flow_offload: rename offload functions with offload instead of flow

Deepanshu Kartikey <kartikey406@gmail.com>
    nfc: pn533: fix OOB read in pn533_acr122_is_rx_frame_valid()

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix slab-out-of-bounds reads when logging service names

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix WKS SAP hijacking via prefix match in nfc_llcp_wks_sap()

Ömer Mete Kaya <omermetekaya0@gmail.com>
    nfc: llcp: fix -ENOMEM on connect with zero-length service name

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: st21nfca: validate ISO15693 inventory length

Cong Nguyen <congnt264@gmail.com>
    nfc: llcp: fix sdreq TLV list leak on parse/alloc/send failure

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix race condition in accept_queue lifecycle

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    nfc: llcp: Fix list corruption / refcount desync in nfc_llcp_recv_dm()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: st21nfca: validate received frame size

Colin Ian King <colin.i.king@gmail.com>
    nfc: st21nfca: remove redundant assignment to variable i

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: nfcmrvl: validate helper command length before pull

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac4: Use the correct bufzise when the len is exactly 8K

Andrew Halaney <ahalaney@redhat.com>
    net: stmmac: Remove some unnecessary void pointers

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Capture all packets for vlan checks

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Check the dev->features for S-TAG offload testing

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Support running selftests on DSA conduits

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix bpf_sock context code generation

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error

Myeonghun Pak <mhun512@gmail.com>
    tg3: clean up PHYLIB resources on probe failure

Pengpeng Hou <hppiscas@163.com>
    net: usb: sr9700: include receive overhead in the length check

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: Reject short EA=0 frames in rfcomm_recv_frame()

Hui Peng <benquike@gmail.com>
    Bluetooth: bnep: fix out-of-bounds reads on short RX/TX frames and control fallthrough

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leak in virtio_gpu_resource_create_ioctl()

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leak when drm_gem_handle_create() fails

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_hfsc: bound the classify inner-filter walk with a drift budget

Aamir Ahmed <elb12345@hotmail.co.uk>
    net: usb: catc: bound the RX packet length in catc_rx_done()

Yiqi Sun <sunyiqixm@gmail.com>
    sctp: avoid livelock while updating retransmit path

Kuniyuki Iwashima <kuniyu@google.com>
    ip6_gre: Call ip6erspan_tunnel_unlink_md() in ip6erspan_changelink().

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    net: gue: reject invalid REMCSUM offsets

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    net/sched: act_ct: don't WARN on benign flow_offload_alloc() failure

Francesco Magazzu <postadelmaga@gmail.com>
    drm/nouveau/clk: don't clobber reclock status when restoring volt/fan

Dan Carpenter <dan.carpenter@oracle.com>
    drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: make ocfs2_calc_xattr_init() return void

Julian Anastasov <ja@ssi.bg>
    ipvs: revalidate ihl before icmp_send

Karl Mehltretter <kmehltretter@gmail.com>
    netfilter: nft_synproxy: use the family-aware checksum helper

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: hold nfnl mutex in event notifier

Scott Mitchell <scott.k.mitch1@gmail.com>
    netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: flowtable: publish HW_DEAD after worker is done

Vlad Buslov <vladbu@nvidia.com>
    netfilter: flowtable: allow unidirectional rules

Zhiling Zou <zhilinz@nebusec.ai>
    xsk: Use a 32-bit compare in xsk_map_gen_lookup

Julian Sun <sunjunchao@bytedance.com>
    fs: avoid repeated scans in evict_inodes()

Karl Mehltretter <kmehltretter@gmail.com>
    s390/pci/docs: Fix sriov_numvfs attribute name

Niklas Schnelle <schnelle@linux.ibm.com>
    docs: s390/pci: Improve and update PCI documentation

Randy Dunlap <rdunlap@infradead.org>
    Documentation: s390: correct spelling

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: expose UID uniqueness guarantee

Christiano Amora <christiano.amora@gmail.com>
    Bluetooth: SMP: reject Security Request over BR/EDR

Ran Hongyun <ranhongyun1@huawei.com>
    squashfs: Add dictionary size range check to prevent shift-out-of-bounds

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix out-of-bounds read of rtt_min in sock_ops

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc

Weiming Shi <bestswngs@gmail.com>
    bpf: Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix bpf_skb_change_tail wrt csum partial skbs

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix IRQ injection with SIGP Stop and Store Status

NeilBrown <neilb@suse.de>
    SUNRPC: lock against ->sock changing during sysfs read

Vitaly Kuznetsov <vkuznets@redhat.com>
    HID: hyperv: streamline driver probe to avoid devres issues

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: zynqmp-gqspi: Use devm_spi_alloc_host()

Benoît Sevens <bsevens@google.com>
    HID: logitech-hidpp: fix race condition when accessing stale stack pointer

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/hdmi_phy: fix runtime PM cleanup on probe failure

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/adreno: fix autosuspend cleanup during teardown

Rik van Riel <riel@surriel.com>
    wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: validate action frame fixed fields

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: mwifiex: validate scan response extents

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length

Shengzhuo Wei <me@cherr.cc>
    wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST

Shengzhuo Wei <me@cherr.cc>
    wifi: p54: validate curve data length in the calibration curve converters

Tianchu Chen <flynnnchen@tencent.com>
    wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()

Ali Ahmet Memis <ali@iusegentoo.com>
    wifi: wilc1000: fix out-of-bounds read in P2P public action frames

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: wlcore: release runtime PM ref on regdomain config failure

Tianchu Chen <flynnnchen@tencent.com>
    wifi: rsi: fix heap OOB write on key removal

Jiangshan Yi <yijiangshan@kylinos.cn>
    wifi: libertas_tf: fix UAF in lbtf_free_adapter()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: fix broadcast stations deallocation

Jiangshan Yi <yijiangshan@kylinos.cn>
    wifi: brcmsmac: fix UAF in brcms_free_timer()

Wentao Liang <vulab@iscas.ac.cn>
    watchdog: sp5100_tco: Fix pci_dev reference leak in sp5100_tco_init()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: digicolor: Avoid division by zero

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83793) release probe data through kref

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    Input: zero ff_effect before compat copy in input_ff_effect_from_user

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - fix GPF in suspend and resume when unbound

Raphaël Larocque <rlarocque@disroot.org>
    Input: synaptics - disable InterTouch on ThinkPad T440p (board id 2722)

Hans de Goede <johannes.goede@oss.qualcomm.com>
    Input: soc_button_array - check btns_desc->package.count

Hans de Goede <johannes.goede@oss.qualcomm.com>
    Input: soc_button_array - fix MS Surface Pro 11 probe failure

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: rmi_smbus - fix out-of-bounds read in rmi_smb_write_block()

Chris Sommers <chris.sommers@icloud.com>
    Input: i8042 - add quirk for Acer Aspire Go 15 AG15-42P

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    Input: evdev - zero absinfo before partial copy in EVIOCSABS

Alexei Turtanov <9alexei9@gmail.com>
    Input: atkbd - skip deactivate for Xiaomi Redmi Book Pro 16 2026

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Reset command and data lines on failed tuning

Xu Rao <raoxu@uniontech.com>
    mmc: spi: reset bytes_xfered before retrying CRC failures

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mmc: sh_mmcif: initialize IRQ-thread mutex before requesting interrupt

Felix Gu <ustc.gu@gmail.com>
    mmc: sdio_uart: fix xmit_fifo leak when the port table is full

Myeonghun Pak <mhun512@gmail.com>
    mmc: sdhci-of-aspeed: Remove children before releasing SDC resources

Fan Wu <fanwu01@zju.edu.cn>
    mmc: mxcmmc: cancel data work and watchdog on remove

Zhu Ling <zhuling0805@qq.com>
    mmc: core: Fix OF node reference leak on card add failure

Christian Göttsche <cgzones@googlemail.com>
    selinux: always fill AVC decision in avc_has_perm_noaudit()

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    IB/mlx4: Fix use-after-free on pkey sysfs registration failure

Shengzhuo Wei <me@cherr.cc>
    i2c: imx: release DMA channels on probe error

Shengzhuo Wei <me@cherr.cc>
    i2c: at91: release DMA channels on remove and probe error

Maoyi Xie <maoyixie.tju@gmail.com>
    keys: translate request_key_auth pid for the reading procfs instance

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: avoid truncating TPACKET_V3 private size

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: clear RX owner on VNET header error

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: cap hh_flows_limit at change time

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: xfrm: use full sockets in local error paths

Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
    dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix non-atomic read of DMA position registers

Nicolas Thibert <nithibert@gmail.com>
    Bluetooth: btusb: fix NXP IW610 composite device handling

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_and() mask generation

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_write() casting

Wyatt Feng <wf.kernel.dev@gmail.com>
    net: xfrm: reject unrepresentable espintcp transport headers

Zhiling Zou <zhilinz@nebusec.ai>
    openvswitch: avoid reallocating confirmed conntrack labels

Jeffin Philip <jeffinphilip14@gmail.com>
    RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()

Quanye Yang <quanyeyang@proton.me>
    RDMA/ucma: Serialize join and leave on copy_to_user failure

Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>
    tcp: exclude old ACKs from tcp fast path

Aohan Mei <henrymei@tencent.com>
    rds: ib: use rds_conn_drop() on protocol version mismatch

Niklas Cassel <cassel@kernel.org>
    ata: libahci: clear PxCLBU and PxFBU for AHCI_HFLAG_32BIT_ONLY

Jeremy Nyberg <slickstretch3.0@gmail.com>
    Input: xpad - fix PDP Marvel Xbox 360 controller

Erich Sartison <byt.es@mailbox.org>
    Input: xpad - add support for Victrix Pro BFG Controller

hackyzh002 <hackyzh002@gmail.com>
    drm/amdgpu: Fix integer overflow in amdgpu_cs_pass1

hpp.iscas <hppiscas@163.com>
    Input: eeti_ts - publish the OF module alias

Dmitriy Okunev <dokunevdmitriy@gmail.com>
    net: mvpp2: prevent buffer overflow in page_pool allocation

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Ack RX overrun interrupt correctly

Eric Dumazet <edumazet@google.com>
    net: lock the socket in sock_gettstamp()

Yige Jiang <yigejiang86@gmail.com>
    net: netsec: fix device_node reference leak on phy_np

Sasha Levin <sashal@kernel.org>
    ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix out-of-bounds write in reset_per_cpu_data()

Eric Dumazet <edumazet@google.com>
    drop_monitor: synchronize tracepoint unregistration on error path

Tzung-Bi Shih <tzungbi@kernel.org>
    Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown

Baineng Shou <shoubaineng@gmail.com>
    dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()

Eric Dumazet <edumazet@google.com>
    tcp: do not let tcp_rmem be set below 4096

Kuniyuki Iwashima <kuniyu@google.com>
    tcp: Don't call skb_clone_and_charge_r() for close()d listener in tcp_v6_do_rcv().

Karl Mehltretter <kmehltretter@gmail.com>
    wifi: brcmfmac: fix lost 802.1x TX completion wakeup

Hohyun Sim <tlaghgus0425@korea.ac.kr>
    net: fddi: skfp: fix NULL deref when setting the MAC address while down

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: set IPSKB_L3SLAVE from IP6SKB_L3SLAVE on IPIP decapsulation

Filipe Manana <fdmanana@suse.com>
    btrfs: tree-checker: print dev extent offset in error message

Slavin Liu <bolin.liu@seu.edu.cn>
    ALSA: hda: trace PCM open only after assigning a stream

Zihan Xi <zihanx@nebusec.ai>
    wifi: virt_wifi: don't transfer operstate before register

Karl Mehltretter <kmehltretter@gmail.com>
    Input: trackpoint - fix the inertia attribute name in the ABI document

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: pcm: set timer->private_data before registering the PCM timer

Karl Mehltretter <kmehltretter@gmail.com>
    keys: fix lost wakeup when reaping a dead key type

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: hold reference on ct until flow is released

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_nat: fully initialise new_addr in netmap setup

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    RDMA/siw: Bound fragmented header copies by the remaining length

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't access the TSF of a down interface

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't RCU-dereference the mesh CSA settings we just set

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't filter by BSS type when removing stale entries

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: only group hidden BSSes with beacon entries

Shivank Garg <shivankg@amd.com>
    dmaengine: wait for RCU readers before releasing dma_device

Shivank Garg <shivankg@amd.com>
    dmaengine: fix use-after-free in dma_chan_put() and dma_release_channel()

Shivank Garg <shivankg@amd.com>
    dmaengine: Fix device kref underflow in dma_chan_put()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    dma-coherent: report a failed reserved memory assignment

Chen-Yu Tsai <wenst@chromium.org>
    dma-coherent: Warn if OF reserved memory is beyond current coherent DMA mask

Christoph Hellwig <hch@lst.de>
    dma-mapping: simplify dma_init_coherent_memory

Orgad Shaneh <orgads@gmail.com>
    MIPS: Octeon: apply USB FDT fixups also when USB is modular

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: cadence_master: wait and cancel cdns->work before clock stop

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: check IP header size in cfg80211_classify8021d()

Carolina Jubran <cjubran@nvidia.com>
    IB/IPoIB: Avoid restoring OPER_UP after multicast flush

Shmulik Cohen <anuk909@gmail.com>
    wifi: libipw: reject too-short association responses

Shmulik Cohen <anuk909@gmail.com>
    wifi: libipw: reject too-short beacon and probe responses

Peng Hao <flyingpenghao@gmail.com>
    wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path

Mariano Baragiola <mbaragiola@linux.com>
    wifi: virt_wifi: free skb when disconnected

Ruoyu Wang <ruoyuw560@gmail.com>
    dmaengine: sprd: Fix runtime PM reference leak in probe

Li RongQing <lirongqing@baidu.com>
    RDMA/mad: Fix receive buffer leak when PKey enforcement fails

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: wait for deferred control PDU completions before releasing the connection

Max Gurtovoy <mgurtovoy@nvidia.com>
    scsi: target: iscsi: Rename iscsi_cmd to iscsit_cmd

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    scsi: target: iscsi: Redo iscsit_check_session_usage_count() return code

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_check_session_usage_count()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_close_session()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/iser: reject a remote invalidation of an unregistered direction

Max Gurtovoy <mgurtovoy@nvidia.com>
    IB/iser: Use iser_fr_desc as registration context

Max Gurtovoy <mgurtovoy@nvidia.com>
    IB/iser: Remove iser_reg_data_sg helper function

Max Gurtovoy <mgurtovoy@nvidia.com>
    IB/iser: Align coding style across driver

Xixin Liu <liuxixin@kylinos.cn>
    clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate

Xixin Liu <liuxixin@kylinos.cn>
    firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Cleanup siw_accept

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Introduce siw_cep_set_free_and_put

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ARM: socfpga: select the PL310 erratum 753970 workaround

Kyle Zeng <kylebot@openai.com>
    xfrm: fix compat ALLOCSPI request use-after-free

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: avoid RCU warnings around the per-netns netlink socket

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: add extack support to verify_newsa_info

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: add extack to verify_sec_ctx_len

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: propagate extack to all netlink doit handlers

Ido Schimmel <idosch@nvidia.com>
    ipv6: Honor oif when choosing nexthop for locally generated traffic

Ido Schimmel <idosch@nvidia.com>
    ipv6: Select best matching nexthop object in fib6_table_lookup()

Arash Golgol <arash.golgol@gmail.com>
    media: video-i2c: fix buffer queue ordering

Sasha Levin <sashal@kernel.org>
    Revert "perf cs-etm: Flush thread stacks after decoder reset"

Sasha Levin <sashal@kernel.org>
    Revert "perf cs-etm: Avoid truncating AUX buffer sizes to int"

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check smcd_v2_ext_offset when receiving proposal msg

Jens Axboe <axboe@kernel.dk>
    sunvdc: fix -EIO issue due to lack of retries

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: ensure interrupts are enabled in __do_user_fault()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix branch predictor hardening

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix hash_name() fault

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix deadlock

Sasha Levin <sashal@kernel.org>
    Reapply "bluetooth/l2cap: sync sock recv cb and release"

Darrick J. Wong <djwong@kernel.org>
    iomap: iomap: fix memory corruption when recording errors during writeback

Paolo Abeni <pabeni@redhat.com>
    mptcp: close race between scheduler and state change

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded actions on subflow reset

Florian Westphal <fw@strlen.de>
    mptcp: hold mptcp socket before calling tcp_done

Eric Biggers <ebiggers@kernel.org>
    netfilter: nft_set_pipapo_avx2: add missing vzeroupper

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ce - Remove crypto_rng interface

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ss - Remove crypto_rng interface

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fou: Fix use-after-free in fou_create()

Weiming Shi <bestswngs@gmail.com>
    net: appletalk: fix NULL pointer dereference in aarp_send_ddp()

Weiming Shi <bestswngs@gmail.com>
    i2c: smbus: reject oversized block transfers in the common path

Kazuki Hanai <hnkz.64@gmail.com>
    ALSA: us122l: Prevent write upgrades for read mappings

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: extend RCU protection in igmp6_send()

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: syncookies: remember the request backup flag

Joe Damato <joe@dama.to>
    bnxt_en: Propagate RX ring init failures in bnxt_init_nic()

Joe Damato <joe@dama.to>
    bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()

Haotian Zhang <vulab@iscas.ac.cn>
    media: v4l2-h264: Fix memcmp() size in B1 reference list comparison

Michael Bommarito <michael.bommarito@gmail.com>
    media: hevc: add bounded tile-count helpers

Vishnu Razdan <vrazdan@openai.com>
    hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS

Cong Nguyen <congnt264@gmail.com>
    hwmon: (applesmc) fix key backlight workqueue leak on register failure

Harald Freudenberger <freude@linux.ibm.com>
    s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm

Nagamani PV <nagamani@linux.ibm.com>
    s390/qeth: allow bridgeport queries despite OS_MISMATCH

leixiang <leixiang@kylinos.cn>
    KVM: PPC: Book3S HV: Set irqfd->producer only on success

Kyle Zeng <kylebot@openai.com>
    ipvs: reject invalid states in connection template sync records

Zihan Xi <zihanx@nebusec.ai>
    ipv4: fib: bound automatic table ID allocation

Zhiling Zou <zhilinz@nebusec.ai>
    ieee802154: 6lowpan: fix NULL dereference in lowpan_newlink

Weiming Shi <bestswngs@gmail.com>
    fbdev: vfb: defer cleanup until the last reference

Ilya Maximets <i.maximets@ovn.org>
    netfilter: report NLM_F_DUMP_FILTERED when all is filtered out

Norbert Szetei <norbert@doyensec.com>
    net: openvswitch: fix use-after-free of the flow table mask array

Fourie Zhang <littleddfu@gmail.com>
    net: mpls: clear inner_protocol when the last label is popped

Johan Hovold <johan@kernel.org>
    net: hso: fix TIOCMIWAIT race

Thorsten Blum <thorsten.blum@linux.dev>
    drm/i915: Fix memory leak in query_perf_config_list()

Jann Horn <jannh@google.com>
    exec: do_close_on_exec() before taking exec_update_lock

Runyu Xiao <runyu.xiao@seu.edu.cn>
    cpufreq: initialize policy rwsem before sysfs publication

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: zero-initialize policy cpumask before sysfs publication

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: sti: initialize IRQ lock before requesting IRQ

Tianchu Chen <flynnnchen@tencent.com>
    ASoC: sprd: validate compress buffer sizes against fixed allocations

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the var ref when its initialization fails

Ido Schimmel <idosch@nvidia.com>
    tunnels: Drop stale dst when building an ICMP error for PMTUD

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: validate cylinder group metadata before caching it

Ali Ahmet Memis <ali@iusegentoo.com>
    ufs: create the root dentry after loading cylinder metadata

James Hilliard <james.hilliard1@gmail.com>
    watchdog: sunxi_wdt: preserve boot-enabled watchdog

Harry Wentland <harry.wentland@amd.com>
    dm/amdgpu: fix malformed link_settings debugfs output

Roman Prucha <zorgan.roman@gmail.com>
    ALSA: ctxfi: Fix CA20K2 S/PDIF passthrough

Zihan Xi <zihanx@nebusec.ai>
    ipv6: fix fib6 walker UAF on seq stop

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/eeh: Fix recursive locking on devices without EEH sensitive driver

Eric Dumazet <edumazet@google.com>
    macvlan: inherit needed_headroom and needed_tailroom from lowerdev

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Handle abort for WRITE_PENDING cmds

Sasha Levin <sashal@kernel.org>
    Revert "bluetooth/l2cap: sync sock recv cb and release"

WenTao Liang <vulab@iscas.ac.cn>
    drm/amd/display: set new_stream to NULL after release

Stian Halseth <stian@itx.no>
    sunvdc: unmap LDC cookies when the descriptor send fails

Greg Marsden <greg.marsden@oracle.com>
    net/rds: fix tcp stream corruption with large pages

Linus Walleij <linus.walleij@linaro.org>
    net/rds: Pass a pointer to virt_to_page()

Aamir Ahmed <elb12345@hotmail.co.uk>
    net: hinic: fix mailbox segment buffer overflow

Li Youhong <liyouhong@kylinos.cn>
    net: sun4i-emac: fix missing of_node_put() for phy_node

Kuniyuki Iwashima <kuniyu@google.com>
    net/sched: cls_api: Don't replay RTM_GETCHAIN in tc_ctl_chain().

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_route: free emptied bucket on filter move

Thibault Ferrante <thibault.ferrante@canonical.com>
    selftests/powerpc/tm: Fix tcheck() reading uninitialised CR value

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors

Cong Nguyen <congnt264@gmail.com>
    hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX descriptors for freeq refill

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count RX drops once per frame

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: No mapping is a dropped rx

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Count dropped frames as NAPI work

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Finish RX updates before NAPI completion

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Fix budget accounting

Andrew Stellman <astellman@stellman-greene.com>
    virtio-pci: return IRQ_HANDLED after non-zero ISR

Yu Zhang <yuz08559@gmail.com>
    vhost-vdpa: don't install the eventfd_ctx_fdget() error in config_ctx

Jia Jia <physicalmtea@gmail.com>
    virtio_console: do not free control-out buffers on remove

Xianting Tian <xianting.tian@linux.alibaba.com>
    virtio-console: call scheduler when we free unused buffs

hpp.iscas <hppiscas@163.com>
    ASoC: mt6351: Publish the OF module alias

Florian Westphal <fw@strlen.de>
    netfilter: ip6_tables: set F_PROTO when proto value is nonzero

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: cope with concurrent instance destruction

hpp.iscas <hppiscas@163.com>
    ASoC: Intel: SST: Publish the PCI module aliases

hpp.iscas <hppiscas@163.com>
    ASoC: bcm: bcm63xx: Publish the OF module aliases

Edward Adam Davis <eadavis@sina.com>
    ALSA: caiaq: Decoupling ep1_in_urb in caiaq dev

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: ets: clamp quantum in parse and fallback paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: drr: clamp quantum in change class

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: pie: clamp psched_mtu in pie_drop_early

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: clamp quantum in change and init paths

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sfq: clamp quantum in change path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_pie: clamp quantum in change path

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq_pie: implement lockless fq_pie_dump()

Yael Chemla <ychemla@nvidia.com>
    net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix ETS zero BW reporting when one TC holds 100%

Shahar Shitrit <shshitrit@nvidia.com>
    net/mlx5e: Fix setting RS FEC after remapping

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks in add_usable_mem()

Jamal Hadi Salim <jhs@mojatatu.com>
    net: cap tx_queue_len at S16_MAX to prevent oversized ring allocations

Seungwon Bae <qotmddnjs@ajou.ac.kr>
    vxlan: reject dynamic fdb entries that reference a nexthop id

Jason Winter <jjx@live.nl>
    net: usb: cx82310_eth: drop URB after 0xffff reboot sentinel to prevent partial_data heap overflow

Jakub Kicinski <kuba@kernel.org>
    net: dsa: mv88e6xxx: bound the policy rule dump by the caller's buffer size

Jakub Kicinski <kuba@kernel.org>
    net: dsa: bcm_sf2: bound the CFP rule dump by the caller's buffer size

Eric Dumazet <edumazet@google.com>
    bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref in btf_var_show()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref when showing a void BTF type

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potential double-free at error path

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: reconfigure RX packet parser table in stmmac_hw_setup() after reset

Allison Henderson <achender@kernel.org>
    net/rds: don't let rds_conn_shutdown() consume a concurrent drop

Håkon Bugge <haakon.bugge@oracle.com>
    net/rds: acquire the fastpath locks in rds_conn_shutdown()

Allison Henderson <achender@kernel.org>
    net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()

Gerd Rausch <gerd.rausch@oracle.com>
    net/rds: tcp: don't force RDS_CONN_RESETTING over a concurrent shutdown

Allison Henderson <achender@kernel.org>
    net/rds: clear cp_flags bits individually in rds_conn_path_reset()

Allison Henderson <achender@kernel.org>
    net/rds: use clear_bit_unlock() in release_refill()

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in release_in_xmit()

Eric Dumazet <edumazet@google.com>
    bonding: do not clear curr_active_slave prematurely when releasing all slaves

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/probes: Fix use-after-free on field name/type of events with multiple probes

Joas Antonio dos Santos <joasantonio108@gmail.com>
    netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

Kyle Zeng <kylebot@openai.com>
    ipvs: fix reversed sequence option serialization

Qu Wenruo <wqu@suse.com>
    btrfs: do not force reloc root creation during qgroup_account_snapshot()

Josef Bacik <josef@toxicpanda.com>
    btrfs: return an error from btrfs_record_root_in_trans

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Program the MSP FIFO watermarks

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Request the MSP MMIO resource

Arnd Bergmann <arnd@arndb.de>
    ASoC: ux500: remove stedma40 references

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Validate MSP DAI configuration

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Correct MSP frame and bit clock setup

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Propagate MSP setup errors

Arnd Bergmann <arnd@arndb.de>
    ASoC: ux500: remove platform_data support

Linus Walleij <linusw@kernel.org>
    ASoC: ux500: Fix MSP stream lifecycle handling

Guanghui Yang <3497809730@qq.com>
    btrfs: detach failed sprout device from transaction update list

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits

Hui Su <sh_def@163.com>
    staging: fbtft: make dirty_lock IRQ-safe

Kuniyuki Iwashima <kuniyu@google.com>
    af_packet: Don't cast tpacket_hdr.tp_len to int in tpacket_parse_header().

Eric Dumazet <edumazet@google.com>
    ipv6: sr: restore network header before routing and forwarding

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_async: simplify tty disc_data access

Jiri Slaby <jirislaby@kernel.org>
    tty: make tty_ldisc_ops::hangup return void

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Validate and program TDM slots correctly

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Correct digital interface format setup

Mark Brown <broonie@kernel.org>
    ASoC: ab8500: Update to modern clocking terminology

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Repair the DAPM capture graph

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Reset the audio block before configuring it

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: hci_mrvl: Fix wrong return value check of wait_on_bit_timeout()

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: clear FLAG_DEFER_SETUP only for same PID/PSM

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix chan mode for LE_CONN_REQ + EXT_FLOWCTL pchan

Colin Ian King <colin.i.king@gmail.com>
    OPP: of: Fix potential multiplication overflow when calculating freq

James Nugraha <aslan.jnn@gmail.com>
    net: amd-xgbe: discard rx packets with bad FCS

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration

Xin Long <lucien.xin@gmail.com>
    sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: size the RTM_GETACTION reply from the actions

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: budget all shared attributes in notify skbs

Hongfu Li <lihongfu@kylinos.cn>
    selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

Dan Carpenter <error27@gmail.com>
    drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()

Jad Keskes <inasj268@gmail.com>
    EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9484/1: enable interrupts when unhandled user faults are triggered

Sasha Levin <sashal@kernel.org>
    Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"

Sasha Levin <sashal@kernel.org>
    Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Reject monmaps advertising zero monitors

Vlatko Kosturjak <kost@linux.hr>
    ppp_async: drop the errored frame instead of resetting its headroom

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: at91: pmc: #undef field_{get,prep}() before definition

Rudi Heitbaum <rudi@heitbaum.com>
    ASoC: rt5645: Perform the initial jack detect at probe

Jia Jia <physicalmtea@gmail.com>
    vhost-scsi: flush backend after device ioctls

Robert Abrahamse <denobyte2@gmail.com>
    ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)

Jiale Yao <yaojiale02@163.com>
    Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame

Deepanshu Kartikey <kartikey406@gmail.com>
    wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()

Li Qiang <liqiang01@kylinos.cn>
    cifs: validate idmap key payload length

Vaibhav Jain <vaibhav@linux.ibm.com>
    powerpc/pseries: Ensure vpa,slb_shadow & dtl are unregistered during crash

Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
    ice: pass the return value of skb_checksum_help()

Madhavender Singh <madhav@disroot.org>
    ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx

Minhong He <heminhong@kylinos.cn>
    phonet: check register_netdevice_notifier() error in phonet_device_init()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/gma500: return errors from Oaktrail HDMI I2C reads

Ibrahim Hashimov <security@auditcode.ai>
    wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO

Georgi Valkov <gvalkov@gmail.com>
    wifi: mwifiex: replace one-element arrays with flexible array members

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: bound aligned TLV advance in FW parser

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm/si: Don't schedule thermal work when queue isn't initialized

Pu Hu <hupu@transsion.com>
    arm64: kprobes: Allow reentering kprobes while single-stepping

Yu Peng <pengyu@kylinos.cn>
    arm64: fixmap: Allow 256K early_ioremap() at any offset

Tao Cui <cuitao@kylinos.cn>
    blk-cgroup: fix leaks and online flag on radix_tree_insert failure

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix an off-by-1 boundary check

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reloc root cleanup in merge_reloc_roots()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: validate beacon length before fixed buffer copy

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: mark the rcu locked areas properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libipw: fix key index receive bound checks

Liang Hao <haohlliang@gmail.com>
    gpio: dwapb: Mask interrupts at hardware initialization

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libertas: reject short monitor TX frames

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: avoid reading TKIP MIC keys for non-TKIP ciphers

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: validate deauth frame length before reason access

Corentin Labbe <clabbe@baylibre.com>
    wifi: ralink: RT2X00: init EEPROM properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ALSA: usb-audio: caiaq: validate EP1 reply lengths

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/gntalloc: validate grant count before allocation

Farhad Alemi <farhad.alemi@berkeley.edu>
    freevxfs: don't BUG() on unknown typed-extent type

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/front-pgdir-shbuf: free grant reference head on errors

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/komeda: fix error handling for clk_prepare_enable() and callers

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_expect: zero at allocation time

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend

Haoxiang Li <haoxiang_li2024@163.com>
    fbdev: pm2fb: unwind WC setup on probe failure

Adriana Stancu <adriana@arista.com>
    rtc: bq32000: add delay between RTC reads

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: au1000: move free_irq out of the close-time spinlocked section

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Use kstrtobool() to parse the ROM attribute input

Tommy Huang <tommy_huang@aspeedtech.com>
    rtc: aspeed: add AST2700 compatible

Samuel Moelius <sam.moelius@trailofbits.com>
    f2fs: validate inline dentry name lengths before conversion

Chen Cheng <chencheng@fnnas.com>
    md/raid5: let stripe batch bm_seq comparison wrap-safe

Hans Zhang <18255117159@163.com>
    PCI: mediatek: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: rockchip: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: altera: Protect root bus removal with rescan lock

Hans Zhang <18255117159@163.com>
    PCI: iproc: Protect root bus removal with rescan lock

Jean-Louis Colaco <jean-louis.colaco@orange.fr>
    ALSA: usb-audio: Add quirk for YAMAHA CDS3000

Tobias Deiminger <tobias.deiminger@linutronix.de>
    leds: pca9532: Don't stop blinking for non-zero brightness

Yousef Alhouseen <alhouseenyousef@gmail.com>
    leds: uleds: Return -EFAULT on copy_to_user() failure

Galen Hassen <rwekyes@gmail.com>
    ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10

Rob Herring (Arm) <robh@kernel.org>
    gpio: pisosr: Read "ngpios" as u32

Arnd Bergmann <arnd@arndb.de>
    scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()

Zhang Tianci <zhangtianci.1997@bytedance.com>
    fuse: set ff->flock only on success

Rosen Penev <rosenp@gmail.com>
    sparc: Disable compat support with LLD

Alice Mikityanska <alice@isovalent.com>
    net/sched: act_csum: don't mangle UDP tunnel GSO packets

Agalakov Daniil <ade@amicon.ru>
    e1000e: limit endianness conversion to boundary words

Raf Dickson <rafdog35@gmail.com>
    vsock: use sk_acceptq_is_full() helper in all transports

Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
    net: stmmac: xgmac2: disable RBUE in default RX interrupt mask

Rosen Penev <rosenp@gmail.com>
    sparc64: uprobes: add missing break

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: spdif: Restore regcache cache-only mode on sync failure

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt

Samuel Moelius <sam.moelius@trailofbits.com>
    Bluetooth: L2CAP: validate connectionless PSM length

Potin Lai <potin.lai.pt@gmail.com>
    hwmon: (pmbus/lm25066) Fix PMBus coefficients for LM5064/5066/5066i

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems

Yuho Choi <dbgh9129@gmail.com>
    sctp: Unwind address notifier registration on failure

Nikolay Metchev <nikolaymetchev@gmail.com>
    platform/x86: intel-hid: Add HP ProBook x360 440 G1 to button_array_table

Xu Rao <raoxu@uniontech.com>
    ata: libata-pmp: add JMicron JMS562 quirk

Kory Maincent <kory.maincent@bootlin.com>
    hwmon: (adt7462) Add of_match_table to support devicetree

Jiajia Liu <liujiajia@kylinos.cn>
    wifi: mt76: transform aspm_conf for pci_disable_link_state

Gleb Sonichev <sonichev555@gmail.com>
    platform/x86: dell-laptop: add Inspiron N5110 to touchpad LED quirk table

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: mal: fix potential system hang in mal_remove()

Al Viro <viro@zeniv.linux.org.uk>
    configfs_depend_prep(): pass configfs_dirent instead of dentry

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Add request-pool slack for delayed recycling

ZhengYuan Huang <gality369@gmail.com>
    btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()

Rosen Penev <rosenp@gmail.com>
    netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()

Ruoyu Wang <ruoyuw560@gmail.com>
    ALSA: es18xx: check control allocation before private data setup

Maoyi Xie <maoyixie.tju@gmail.com>
    hsr: broadcast netlink notifications in the device's net namespace

Guangshuo Li <lgs201920130244@gmail.com>
    net: cpsw_new: unregister devlink on port registration failure

Dawei Feng <dawei.feng@seu.edu.cn>
    bpf: NUL-terminate replaced sysctl value

Li RongQing <lirongqing@baidu.com>
    RDMA/mlx5: Fix state and counter desync on loopback enable failure

Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>
    wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications

Rosen Penev <rosenp@gmail.com>
    ipmi: si: Use platform_get_irq_optional() to retrieve interrupt

Andrei Faleichyk <andrei.faleichyk@noogadev.com>
    ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP

Michael Walle <mwalle@kernel.org>
    clk: keystone: don't cache clock rate

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent queuing new commands if xhci is inaccessible

David Yang <mmyangfl@gmail.com>
    net: dsa: sja1105: flower: reject cross-chip redirect

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: oss: Reject reads that cannot fit the next event

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: codecs: rk3328: Use managed GPIO and clock helpers

Simon Xue <xxm@rock-chips.com>
    iommu/rockchip: disable fetch dte time limit

Wentao Liang <vulab@iscas.ac.cn>
    net: qrtr: fix node refcount leak on ctrl packet alloc failure

liyouhong <liyouhong@kylinos.cn>
    ata: ahci: fail probe if BAR too small for claimed ports

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: Reserve VLAN header in MJS limit

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: accel: mma8452: switch to non-devm request_threaded_irq()

Rik van Riel <riel@surriel.com>
    perf/ftrace: Fix WARNING in __unregister_ftrace_function

Osama Abdelkader <osama.abdelkader@gmail.com>
    mmc: davinci: fix mmc_add_host order in probe

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: only handle alert events when the peripheral is attached

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Complete coredump handling

Alexandre Courbot <acourbot@nvidia.com>
    scripts: modpost: detect and report truncated buf_printf() output

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: rework hfsplus_readdir() logic

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in two places

ikaros <void0red@gmail.com>
    ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()

Weiming Shi <bestswngs@gmail.com>
    ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()

ikaros <void0red@gmail.com>
    ACPICA: Add validation for node in acpi_ns_build_normalized_path()

ikaros <void0red@gmail.com>
    ACPICA: Add package limit checks in parser functions

ikaros <void0red@gmail.com>
    ACPICA: validate handler object type in two places

ikaros <void0red@gmail.com>
    ACPICA: Improve argument parsing in acpi_ps_get_next_simple_arg()

ikaros <void0red@gmail.com>
    ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)

ikaros <void0red@gmail.com>
    ACPICA: Prevent adding invalid references

ikaros <void0red@gmail.com>
    ACPICA: validate byte_count in acpi_ps_get_next_package_length()

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in acpi_ps_get_next_field()

ikaros <void0red@gmail.com>
    ACPICA: Fix use-after-free in acpi_ds_terminate_control_method()

ikaros <void0red@gmail.com>
    ACPICA: Fix condition check in acpi_ps_parse_loop()

Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>
    drm/amd/pm/si: Fix updating clock limits from power states

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: addrconf: fix temp address generation after prefix deprecation

Uwe Küchler <uwe@kuechler.org>
    ALSA: usb-audio: Add quirk for Novation Mininova

Mostafa Saleh <smostafa@google.com>
    irqchip/gic-v4: Don't advertise VLPIs if no ITS is probed

Stepan Ionichev <sozdayvek@gmail.com>
    iio: adc: qcom-spmi-iadc: balance enable_irq_wake() on driver unbind

Rosen Penev <rosenp@gmail.com>
    mips: cps: Assemble jr.hb with an R2 ISA level

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    drm/panel: simple: Add AM-1280800W8TZQW-T00H

Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
    thermal/drivers/tegra/soctherma: Switch to devm cooling device registration

Adrian Ng Ho Yin <adrian.ho.yin.ng@altera.com>
    clk: socfpga: agilex: implement l3_main_free_clk

Heiko Carstens <hca@linux.ibm.com>
    s390/zcore: Removed unused variables

Jiayuan Chen <jiayuan.chen@linux.dev>
    rds: annotate data-race around rs_seen_congestion

Maoyi Xie <maoyixie.tju@gmail.com>
    rds: filter RDS_INFO_* getsockopt by caller's netns

Chenguang Zhao <zhaochenguang@kylinos.cn>
    netlabel: fix IPv6 unlabeled address add error handling

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    char/nvram: Remove redundant nvram_mutex

Christian Marangi <ansuelsmth@gmail.com>
    usb: host: add ARCH_AIROHA in XHCI MTK dependency

Marco Felsch <m.felsch@pengutronix.de>
    serial: 8250: fix possible ISR soft lockup

Stepan Ionichev <sozdayvek@gmail.com>
    usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log

Oliver Neukum <oneukum@suse.com>
    usb: core: hcd: fix possible deadlock in rh control transfers

Adrian Wowk <dev@adrianwowk.com>
    usbip: vhci_hcd: fix NULL deref in status_show_vhci

Christoph Hellwig <hch@lst.de>
    isofs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    omfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    hpfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    jfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    qnx4: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    minix: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    bfs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    affs: handle set_blocksize failures

Christoph Hellwig <hch@lst.de>
    befs: handle set_blocksize failures

Allison Henderson <achender@kernel.org>
    net/rds: Don't sleep inside rds_ib_conn_path_shutdown

Eric Dumazet <edumazet@google.com>
    net/sched: sch_drr: make cl->quantum lockless

Eric Dumazet <edumazet@google.com>
    net: bridge: remove stale rcu_barrier() in br_multicast_dev_del()

Jan Volckaert <janvolck@gmail.com>
    net: usb: qmi_wwan: add MeiG SRM813Q

Yury Norov <ynorov@nvidia.com>
    bitfield: wire __bf_shf to __builtin_ctzll

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't call ieee80211_handle_reconfig_failure when not needed

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size

Leonardo Bras <leo.bras@arm.com>
    arm64/daifflags: Make local_daif_*() helpers __always_inline

Pierre Barre <pierre@barre.sh>
    9p: invalidate readdir buffer on seek

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usx2y: Drain pending US-428 pipe-4 output commands

Joonwon Kang <joonwonkang@google.com>
    mailbox: Make mbox_send_message() return error code when tx fails

Chenguang Zhao <zhaochenguang@kylinos.cn>
    RDMA/mlx5: Use QP port when decoding responder CQEs

Alessandro Baldi <baldovic@virgilio.it>
    media: imon: Add iMON VFD HID OEM v1.2 key mappings

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - add support for atecc608b

Lukas Wunner <lukas@wunner.de>
    crypto: ecc - Unbreak the build on arm with CONFIG_KASAN_STACK=y

Kumar Meiyappan <kumar.meiyappan@microchip.com>
    scsi: pm8001: Reject non-fatal dump when controller is crashed

Kumar Meiyappan <kumar.meiyappan@microchip.com>
    scsi: pm8001: Reject firmware update in fatal error state

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: rework hfsplus_readdir() logic

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix CRC open failure during active rendering

Stepan Ionichev <sozdayvek@gmail.com>
    mmc: davinci: avoid NULL deref of host->data in IRQ handler

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ASoC: ti: omap3pandora: update board check to use DT compatible

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Add number of clock cells check

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: em28xx-video: fix missing res_free() on init_usb_xfer failure

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family

Zhaoyang Yu <2426767509@qq.com>
    media: dm1105: fix missing error check for dma_alloc_coherent

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Set tb->root_switch to NULL when domain is stopped

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep the domain reference while processing hotplug

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()

Riccardo Boninsegna <rboninsegna2@gmail.com>
    media: rc: mceusb: Add support for 04eb:e033

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soundwire: validate DT compatible before parsing it

Danielle Ratson <danieller@nvidia.com>
    bridge: Do not suppress ARP probes and DAD NS unconditionally

Marco Elver <elver@google.com>
    kcsan: Silence -Wmaybe-uninitialized when calling __kcsan_check_access()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: always allow transmitting null-data on TXQs

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix issue of direct writes beyond end-of-file

Lukas Wunner <lukas@wunner.de>
    PCI: Stop setting cached power state to 'unknown' on unbind

Hirokazu Honda <hiroh@chromium.org>
    tee: optee: Allow MT_NORMAL_TAGGED shared memory

Goldwyn Rodrigues <rgoldwyn@suse.de>
    ima: return error early if file xattr cannot be changed

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Propagate write errors in generic mixer put callbacks

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: atomically update mac addresses


-------------

Diffstat:

 .../ABI/testing/sysfs-devices-platform-trackpoint  |   2 +-
 Documentation/driver-api/serial/tty.rst            |   2 +-
 Documentation/networking/ip-sysctl.rst             |   2 +
 Documentation/s390/pci.rst                         | 138 +++--
 Documentation/s390/vfio-ccw.rst                    |   2 +-
 Makefile                                           |   4 +-
 arch/arm/mach-socfpga/Kconfig                      |   2 +-
 arch/arm/mm/alignment.c                            |   4 +
 arch/arm/mm/fault.c                                |  82 ++-
 arch/arm64/include/asm/daifflags.h                 |  10 +-
 arch/arm64/include/asm/fixmap.h                    |   6 +-
 arch/arm64/include/asm/kprobes.h                   |   6 +
 arch/arm64/include/asm/percpu.h                    |  16 +-
 arch/arm64/kernel/probes/kprobes.c                 |  23 +-
 arch/mips/cavium-octeon/octeon-platform.c          |   4 +-
 arch/mips/kernel/cps-vec.S                         |   6 +
 arch/powerpc/kernel/eeh_driver.c                   |   2 -
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kexec/file_load_64.c                  |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   5 +-
 arch/powerpc/platforms/pseries/kexec.c             |  13 +-
 arch/s390/crypto/aes_s390.c                        |  16 +-
 arch/s390/kvm/interrupt.c                          |  72 +--
 arch/s390/pci/pci_sysfs.c                          |   9 +
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/kernel/uprobes.c                        |   1 +
 arch/x86/pci/fixup.c                               |  99 ++++
 block/blk-cgroup.c                                 |   4 +-
 crypto/Makefile                                    |   5 +
 drivers/acpi/acpica/dsmethod.c                     |  43 ++
 drivers/acpi/acpica/evhandler.c                    |  11 +
 drivers/acpi/acpica/exoparg3.c                     |   2 +-
 drivers/acpi/acpica/nsnames.c                      |   6 +
 drivers/acpi/acpica/nsprepkg.c                     |   7 +
 drivers/acpi/acpica/nsxfname.c                     |   4 +
 drivers/acpi/acpica/psargs.c                       | 134 ++++-
 drivers/acpi/acpica/psloop.c                       |  30 +-
 drivers/acpi/acpica/psparse.c                      |  14 +
 drivers/acpi/acpica/utcopy.c                       |  10 +-
 drivers/acpi/acpica/utresrc.c                      |  30 ++
 drivers/ata/ahci.c                                 |  22 +
 drivers/ata/libahci.c                              |  15 +-
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/block/sunvdc.c                             |  26 +-
 drivers/bluetooth/btmtksdio.c                      |   4 +-
 drivers/bluetooth/btusb.c                          |  23 +-
 drivers/bluetooth/hci_mrvl.c                       |   3 +-
 drivers/char/ipmi/ipmi_si_platform.c               |   5 +-
 drivers/char/nvram.c                               |  16 +-
 drivers/char/virtio_console.c                      |  22 +-
 drivers/clk/at91/pmc.h                             |   2 +
 drivers/clk/clk-scpi.c                             |   2 +-
 drivers/clk/keystone/sci-clk.c                     |   8 +
 drivers/clk/renesas/renesas-cpg-mssr.c             |   3 +
 drivers/clk/socfpga/clk-agilex.c                   |   2 +
 drivers/cpufreq/cpufreq.c                          |   6 +-
 drivers/crypto/allwinner/Kconfig                   |  16 -
 drivers/crypto/allwinner/sun8i-ce/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  54 --
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  | 164 ------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  29 --
 drivers/crypto/allwinner/sun8i-ss/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  39 --
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  | 175 -------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  23 -
 drivers/crypto/atmel-ecc.c                         |   3 +
 drivers/dma/dmaengine.c                            |  10 +-
 drivers/dma/mmp_pdma.c                             |   2 +-
 drivers/dma/sprd-dma.c                             |   3 +-
 drivers/dma/sun6i-dma.c                            |   9 +-
 drivers/dma/ti/k3-udma-glue.c                      |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  26 +-
 drivers/edac/edac_device_sysfs.c                   |  11 +-
 drivers/firmware/arm_scmi/base.c                   |  15 +-
 drivers/firmware/arm_scpi.c                        |   4 +-
 drivers/gpio/gpio-arizona.c                        |   8 +-
 drivers/gpio/gpio-dwapb.c                          |  17 +
 drivers/gpio/gpio-pisosr.c                         |   4 +-
 drivers/gpio/gpio-zynq.c                           |  10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   3 +-
 drivers/gpu/drm/amd/amdgpu/atom.c                  |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |   7 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  20 +-
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c          |  31 +-
 drivers/gpu/drm/arm/display/komeda/komeda_dev.c    |   6 +-
 drivers/gpu/drm/arm/display/komeda/komeda_drv.c    |  14 +-
 drivers/gpu/drm/arm/malidp_drv.c                   |  22 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |  13 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |  21 +-
 drivers/gpu/drm/i915/i915_query.c                  |   4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |   8 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |  23 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c   |   2 +
 drivers/gpu/drm/panel/panel-simple.c               |  28 +
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |   2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   2 +-
 drivers/hid/hid-alps.c                             |   6 +-
 drivers/hid/hid-hyperv.c                           |  58 ++-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-logitech-hidpp.c                   |  10 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/wacom_sys.c                            |   5 +-
 drivers/hwmon/adt7462.c                            |   8 +
 drivers/hwmon/applesmc.c                           |   7 +-
 drivers/hwmon/aspeed-pwm-tacho.c                   |   4 +-
 drivers/hwmon/gpio-fan.c                           |   5 +-
 drivers/hwmon/pmbus/lm25066.c                      |  60 +--
 drivers/hwmon/pmbus/pmbus_core.c                   |   4 +-
 drivers/hwmon/w83791d.c                            |   1 +
 drivers/hwmon/w83793.c                             |   4 +-
 drivers/i2c/busses/i2c-at91-core.c                 |   3 +
 drivers/i2c/busses/i2c-at91-master.c               |  12 +-
 drivers/i2c/busses/i2c-at91.h                      |   1 +
 drivers/i2c/busses/i2c-imx.c                       |   2 +
 drivers/i2c/i2c-core-smbus.c                       |  12 +
 drivers/iio/accel/mma8452.c                        |  19 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |  18 +-
 drivers/infiniband/core/iwpm_util.c                |   9 +-
 drivers/infiniband/core/mad.c                      |   3 +-
 drivers/infiniband/core/ucma.c                     |   7 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |   4 +
 drivers/infiniband/hw/mlx5/cq.c                    |   3 +-
 drivers/infiniband/hw/mlx5/main.c                  |  11 +
 drivers/infiniband/sw/siw/siw_cm.c                 |  75 ++-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   7 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  12 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  16 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  72 +--
 drivers/infiniband/ulp/iser/iscsi_iser.h           |   8 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |  49 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |  87 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c           |  56 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  86 ++--
 drivers/infiniband/ulp/isert/ib_isert.h            |   4 +-
 drivers/input/evdev.c                              |   2 +
 drivers/input/input-compat.c                       |   2 +
 drivers/input/joystick/xpad.c                      |   3 +-
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/misc/soc_button_array.c              |  16 +-
 drivers/input/mouse/synaptics.c                    |   8 +
 drivers/input/rmi4/rmi_driver.c                    |  13 +
 drivers/input/rmi4/rmi_smbus.c                     |  10 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/input/serio/serport.c                      |   3 +-
 drivers/input/touchscreen/eeti_ts.c                |   1 +
 drivers/iommu/rockchip-iommu.c                     |   8 +
 drivers/irqchip/irq-gic-v3-its.c                   |   1 +
 drivers/leds/leds-pca9532.c                        |   8 +-
 drivers/leds/uleds.c                               |  11 +-
 drivers/mailbox/mailbox.c                          |   6 +-
 drivers/md/raid5.c                                 |   2 +-
 drivers/media/i2c/video-i2c.c                      |   5 +-
 drivers/media/pci/dm1105/dm1105.c                  |   7 +-
 drivers/media/rc/imon.c                            |   4 +
 drivers/media/rc/mceusb.c                          |   2 +
 drivers/media/usb/em28xx/em28xx-video.c            |   4 +-
 drivers/media/v4l2-core/v4l2-h264.c                |   3 +-
 drivers/mmc/core/bus.c                             |   2 +-
 drivers/mmc/core/sdio_uart.c                       |   3 +
 drivers/mmc/host/davinci_mmc.c                     |  16 +-
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/mxcmmc.c                          |   4 +
 drivers/mmc/host/sdhci-of-aspeed.c                 |   5 +-
 drivers/mmc/host/sdhci_am654.c                     |   4 +-
 drivers/mmc/host/sh_mmcif.c                        |   3 +-
 drivers/net/bonding/bond_alb.c                     |  19 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/can/slcan.c                            |   3 +-
 drivers/net/can/usb/ems_usb.c                      |  43 ++
 drivers/net/dsa/bcm_sf2_cfp.c                      |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  22 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |   4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   2 +
 drivers/net/ethernet/amd/au1000_eth.c              |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |   3 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   3 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   3 +
 drivers/net/ethernet/atheros/atlx/atl1.c           |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  16 +-
 drivers/net/ethernet/broadcom/tg3.c                |   4 +
 drivers/net/ethernet/cortina/gemini.c              |  79 +--
 drivers/net/ethernet/freescale/fman/fman.c         |   1 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   3 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |   4 +-
 drivers/net/ethernet/ibm/emac/core.c               |   3 +-
 drivers/net/ethernet/ibm/emac/mal.c                |   6 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  19 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  20 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   7 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  10 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  12 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   4 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   6 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  11 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  32 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   8 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 106 +++-
 drivers/net/ethernet/ti/cpsw_new.c                 |   4 +-
 drivers/net/ethernet/ti/netcp_core.c               |   2 +-
 drivers/net/fddi/skfp/skfddi.c                     |   3 +-
 drivers/net/macvlan.c                              |   4 +
 drivers/net/ppp/ppp_async.c                        |  90 +---
 drivers/net/ppp/ppp_synctty.c                      |   3 +-
 drivers/net/slip/slip.c                            |   3 +-
 drivers/net/usb/catc.c                             |  15 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/cx82310_eth.c                      |   1 +
 drivers/net/usb/hso.c                              |   2 +-
 drivers/net/usb/lan78xx.c                          |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/sr9700.c                           |   3 +-
 drivers/net/vxlan/vxlan_core.c                     |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   4 +
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |  10 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/intersil/p54/eeprom.c         |  22 +-
 drivers/net/wireless/mac80211_hwsim.c              |   6 +-
 drivers/net/wireless/marvell/libertas/tx.c         |   7 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |  18 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |   8 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  54 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   2 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |  10 +-
 drivers/net/wireless/mediatek/mt76/pci.c           |   8 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  14 +
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   9 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   8 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   8 +-
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/virt_wifi.c                   |   4 +-
 drivers/nfc/microread/microread.c                  |   6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |  11 +-
 drivers/nfc/pn533/pn533.c                          |  14 +-
 drivers/nfc/pn533/pn533.h                          |   4 +-
 drivers/nfc/pn533/usb.c                            |   4 +-
 drivers/nfc/pn544/pn544.c                          |   7 +-
 drivers/nfc/port100.c                              |   7 +
 drivers/nfc/st21nfca/core.c                        |  12 +-
 drivers/nfc/st21nfca/i2c.c                         |  33 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/pcie-altera.c               |   2 +
 drivers/pci/controller/pcie-iproc.c                |   2 +
 drivers/pci/controller/pcie-mediatek.c             |   2 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +
 drivers/pci/pci-driver.c                           |  10 +-
 drivers/pci/pci-sysfs.c                            |  11 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/pinctrl/pinctrl-single.c                   |   3 +-
 drivers/platform/x86/dell-laptop.c                 |   9 +
 drivers/platform/x86/intel-hid.c                   |   7 +
 drivers/rtc/rtc-aspeed.c                           |   1 +
 drivers/rtc/rtc-bq32k.c                            |   9 +
 drivers/s390/char/zcore.c                          |   8 +-
 drivers/s390/cio/device_ops.c                      |   2 +
 drivers/s390/net/qeth_l2.h                         |   3 +-
 drivers/s390/net/qeth_l2_main.c                    |  26 +-
 drivers/s390/net/qeth_l2_sys.c                     |   7 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   2 +-
 drivers/scsi/libiscsi_tcp.c                        |   3 +
 drivers/scsi/pm8001/pm8001_ctl.c                   |   8 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   7 +
 drivers/soundwire/bus.c                            |   4 +
 drivers/soundwire/cadence_master.c                 |   7 +
 drivers/soundwire/slave.c                          |   4 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  18 +-
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/target/iscsi/cxgbit/cxgbit.h               |   8 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |   4 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |  34 +-
 drivers/target/iscsi/iscsi_target.c                | 185 +++----
 drivers/target/iscsi/iscsi_target.h                |  16 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |  14 +-
 drivers/target/iscsi/iscsi_target_datain_values.c  |  18 +-
 drivers/target/iscsi/iscsi_target_datain_values.h  |  12 +-
 drivers/target/iscsi/iscsi_target_device.c         |   2 +-
 drivers/target/iscsi/iscsi_target_device.h         |   4 +-
 drivers/target/iscsi/iscsi_target_erl0.c           |  32 +-
 drivers/target/iscsi/iscsi_target_erl0.h           |   8 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |  42 +-
 drivers/target/iscsi/iscsi_target_erl1.h           |  20 +-
 drivers/target/iscsi/iscsi_target_erl2.c           |  20 +-
 drivers/target/iscsi/iscsi_target_erl2.h           |   8 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   2 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c   |  34 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h   |  10 +-
 drivers/target/iscsi/iscsi_target_tmr.c            |  38 +-
 drivers/target/iscsi/iscsi_target_tmr.h            |   8 +-
 drivers/target/iscsi/iscsi_target_util.c           |  77 +--
 drivers/target/iscsi/iscsi_target_util.h           |  50 +-
 drivers/tee/optee/call.c                           |   3 +-
 drivers/thermal/tegra/soctherm.c                   |   6 +-
 drivers/thunderbolt/tb.c                           |   6 +-
 drivers/thunderbolt/xdomain.c                      |  13 +-
 drivers/tty/serial/8250/8250_port.c                |   7 +
 drivers/usb/core/hcd.c                             |  14 +-
 drivers/usb/gadget/udc/goku_udc.c                  |   3 +-
 drivers/usb/host/Kconfig                           |   2 +-
 drivers/usb/host/xhci-ring.c                       |   6 +
 drivers/usb/host/xhci.c                            |   4 +
 drivers/usb/usbip/vhci_sysfs.c                     |  52 +-
 drivers/vhost/scsi.c                               |   3 +-
 drivers/vhost/vdpa.c                               |  12 +-
 drivers/video/fbdev/pm2fb.c                        |   1 +
 drivers/video/fbdev/vfb.c                          |  11 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/digicolor_wdt.c                   |  13 +-
 drivers/watchdog/sp5100_tco.c                      |   6 +-
 drivers/watchdog/sunxi_wdt.c                       |  45 +-
 drivers/xen/gntalloc.c                             |  13 +-
 drivers/xen/xen-front-pgdir-shbuf.c                |  12 +-
 fs/9p/vfs_dir.c                                    |  12 +
 fs/affs/affs.h                                     |   5 -
 fs/affs/super.c                                    |   6 +-
 fs/autofs/inode.c                                  |   4 +
 fs/befs/linuxvfs.c                                 |   3 +-
 fs/bfs/inode.c                                     |   3 +-
 fs/btrfs/relocation.c                              |  47 +-
 fs/btrfs/transaction.c                             |  16 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/volumes.c                                 |   8 +-
 fs/cifs/cifsacl.c                                  |   3 +
 fs/configfs/dir.c                                  |  12 +-
 fs/exec.c                                          |  22 +-
 fs/f2fs/inline.c                                   |   7 +
 fs/freevxfs/vxfs_bmap.c                            |   3 +-
 fs/fuse/file.c                                     |   3 +-
 fs/hfs/catalog.c                                   |   9 -
 fs/hfs/dir.c                                       |  28 +-
 fs/hfs/hfs.h                                       |   3 +-
 fs/hfs/hfs_fs.h                                    |   2 -
 fs/hfs/inode.c                                     |   4 -
 fs/hfsplus/catalog.c                               |  11 -
 fs/hfsplus/dir.c                                   |  28 +-
 fs/hfsplus/hfsplus_fs.h                            |   5 +-
 fs/hfsplus/inode.c                                 |  40 +-
 fs/hfsplus/super.c                                 |   2 -
 fs/hpfs/super.c                                    |   3 +-
 fs/inode.c                                         |  11 +-
 fs/iomap/buffered-io.c                             |   2 +-
 fs/isofs/inode.c                                   |   3 +-
 fs/jfs/super.c                                     |   3 +-
 fs/minix/inode.c                                   |   3 +-
 fs/ocfs2/namei.c                                   |   9 +-
 fs/ocfs2/xattr.c                                   |  13 +-
 fs/ocfs2/xattr.h                                   |   8 +-
 fs/omfs/inode.c                                    |   6 +-
 fs/qnx4/inode.c                                    |   3 +-
 fs/squashfs/xz_wrapper.c                           |   6 +-
 fs/ufs/cylinder.c                                  |  10 +
 fs/ufs/super.c                                     |  17 +-
 include/keys/request_key_auth-type.h               |   2 +-
 include/linux/bitfield.h                           |   2 +-
 include/linux/hrtimer.h                            |  21 +-
 include/linux/kcsan-checks.h                       |   6 +-
 include/linux/mailbox_controller.h                 |   2 +
 include/linux/platform_data/asoc-ux500-msp.h       |  20 -
 include/linux/rculist.h                            |  29 ++
 include/linux/skbuff.h                             |  26 +
 include/linux/tty_ldisc.h                          |   2 +-
 include/media/v4l2-hevc.h                          |  41 ++
 include/net/cfg80211.h                             |   2 +-
 include/net/gue.h                                  |  19 +-
 include/net/netfilter/nf_conntrack.h               |   5 +
 include/net/netfilter/nf_flow_table.h              |   1 +
 include/net/netns/xfrm.h                           |   2 +-
 include/net/nfc/hci.h                              |   2 +-
 include/net/nfc/nfc.h                              |   3 +-
 include/net/pkt_cls.h                              |   6 +-
 include/target/iscsi/iscsi_target_core.h           |  34 +-
 include/target/iscsi/iscsi_transport.h             |  92 ++--
 kernel/bpf/btf.c                                   |  19 +-
 kernel/bpf/cgroup.c                                |   1 +
 kernel/dma/coherent.c                              |  79 ++-
 kernel/time/hrtimer.c                              | 103 ++--
 kernel/trace/trace_event_perf.c                    |  12 +-
 kernel/trace/trace_events_hist.c                   |   2 +-
 kernel/trace/trace_probe.c                         |  48 +-
 kernel/trace/trace_probe.h                         |   2 +
 kernel/workqueue.c                                 |   2 +-
 net/8021q/vlan_dev.c                               |   5 +
 net/appletalk/aarp.c                               |   5 +
 net/batman-adv/distributed-arp-table.c             |  65 ++-
 net/batman-adv/types.h                             |   2 +-
 net/bluetooth/bnep/core.c                          |  17 +-
 net/bluetooth/bnep/netdev.c                        |   8 +-
 net/bluetooth/hci_sock.c                           |  20 +-
 net/bluetooth/l2cap_core.c                         |  31 +-
 net/bluetooth/l2cap_sock.c                         |  13 +-
 net/bluetooth/rfcomm/core.c                        |   6 +
 net/bluetooth/rfcomm/sock.c                        |   6 +-
 net/bluetooth/smp.c                                |  17 +
 net/bridge/br_arp_nd_proxy.c                       |  16 +-
 net/bridge/br_multicast.c                          |   2 -
 net/bridge/br_stp_bpdu.c                           |   5 +-
 net/ceph/mon_client.c                              |   2 +-
 net/core/dev.c                                     |   4 +-
 net/core/drop_monitor.c                            |   4 +-
 net/core/filter.c                                  |  33 +-
 net/core/skbuff.c                                  |  81 +--
 net/core/sock.c                                    |   9 +-
 net/hsr/hsr_netlink.c                              |   9 +-
 net/ieee802154/6lowpan/core.c                      |   2 +-
 net/ipv4/arp.c                                     |   1 +
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fou_core.c                                |   6 +-
 net/ipv4/ip_gre.c                                  |  12 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/sysctl_net_ipv4.c                         |   4 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_output.c                              |   6 +-
 net/ipv6/addrconf.c                                |  10 +-
 net/ipv6/exthdrs.c                                 |   4 +-
 net/ipv6/exthdrs_core.c                            |   3 +
 net/ipv6/ip6_fib.c                                 |   4 +-
 net/ipv6/ip6_gre.c                                 |   2 +-
 net/ipv6/mcast.c                                   |  32 +-
 net/ipv6/netfilter/ip6_tables.c                    |   5 +
 net/ipv6/netfilter/ip6t_rpfilter.c                 |   2 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  11 +-
 net/ipv6/route.c                                   |  22 +-
 net/ipv6/seg6.c                                    |   4 +-
 net/ipv6/seg6_local.c                              |   3 +
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/ipv6/xfrm6_output.c                            |  10 +-
 net/llc/llc_c_ac.c                                 |   2 +-
 net/llc/llc_s_ac.c                                 |   4 +
 net/llc/llc_sap.c                                  |   8 +-
 net/mac80211/cfg.c                                 |   3 +
 net/mac80211/debugfs_netdev.c                      |   6 +
 net/mac80211/iface.c                               |   2 +
 net/mac80211/mesh.c                                |   1 -
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/util.c                                |   6 +-
 net/mptcp/protocol.c                               |  10 +-
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |  18 +-
 net/mptcp/syncookies.c                             |   5 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  13 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   6 +
 net/netfilter/ipvs/ip_vs_sync.c                    |  20 +-
 net/netfilter/nf_conntrack_expect.c                |   3 +-
 net/netfilter/nf_conntrack_netlink.c               |  13 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  10 +-
 net/netfilter/nf_conntrack_sip.c                   |   2 +-
 net/netfilter/nf_flow_table_core.c                 |  12 +-
 net/netfilter/nf_flow_table_offload.c              |  19 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |  13 +-
 net/netfilter/nfnetlink_queue.c                    |  77 ++-
 net/netfilter/nft_nat.c                            |   2 +-
 net/netfilter/nft_set_pipapo_avx2.c                |   1 +
 net/netfilter/nft_synproxy.c                       |   3 +-
 net/netlabel/netlabel_unlabeled.c                  |   2 +-
 net/nfc/core.c                                     |  15 +-
 net/nfc/digital_dep.c                              |   8 +-
 net/nfc/llcp.h                                     |   1 +
 net/nfc/llcp_commands.c                            |   2 +-
 net/nfc/llcp_core.c                                | 173 +++++--
 net/nfc/llcp_sock.c                                |  67 ++-
 net/nfc/nci/core.c                                 |  10 +-
 net/nfc/netlink.c                                  |   7 +-
 net/nfc/nfc.h                                      |   3 +-
 net/openvswitch/conntrack.c                        |  14 +-
 net/openvswitch/flow_table.c                       |   4 +-
 net/packet/af_packet.c                             |  11 +-
 net/packet/internal.h                              |   2 +-
 net/phonet/pn_dev.c                                |  30 +-
 net/qrtr/af_qrtr.c                                 |   4 +-
 net/rds/af_rds.c                                   |  63 ++-
 net/rds/connection.c                               | 102 +++-
 net/rds/ib_cm.c                                    |  27 +-
 net/rds/ib_frmr.c                                  |  11 +-
 net/rds/ib_recv.c                                  |   9 +-
 net/rds/message.c                                  |   6 +-
 net/rds/send.c                                     |  16 +-
 net/rds/tcp.c                                      | 164 ++++--
 net/rds/tcp_listen.c                               |   6 +-
 net/sched/act_api.c                                |  22 +-
 net/sched/act_csum.c                               |   8 +-
 net/sched/act_ct.c                                 |   5 +-
 net/sched/act_gate.c                               |  30 +-
 net/sched/cls_api.c                                |  14 +-
 net/sched/cls_flower.c                             |   8 +-
 net/sched/cls_matchall.c                           |   8 +-
 net/sched/cls_route.c                              |  45 +-
 net/sched/sch_drr.c                                |  13 +-
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_fq_pie.c                             |  62 ++-
 net/sched/sch_hfsc.c                               |  22 +
 net/sched/sch_hhf.c                                |  15 +-
 net/sched/sch_pie.c                                |   2 +-
 net/sched/sch_sfq.c                                |   7 +-
 net/sched/sch_teql.c                               |   7 +-
 net/sctp/associola.c                               |  15 +-
 net/sctp/ipv6.c                                    |  12 +-
 net/sctp/protocol.c                                |  10 +-
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/sm_sideeffect.c                           |  11 +-
 net/sctp/sm_statefuns.c                            |   2 +
 net/smc/smc_clc.c                                  |   8 +-
 net/smc/smc_clc.h                                  |  17 +-
 net/sunrpc/xprtrdma/verbs.c                        |  21 +-
 net/sunrpc/xprtsock.c                              |   7 +-
 net/tipc/group.c                                   |   4 +-
 net/tipc/monitor.c                                 |   3 +-
 net/vmw_vsock/hyperv_transport.c                   |   2 +-
 net/vmw_vsock/vmci_transport.c                     |   2 +-
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/scan.c                                |  12 +-
 net/wireless/util.c                                |  26 +-
 net/wireless/wext-sme.c                            |   9 +
 net/xdp/xskmap.c                                   |   2 +-
 net/xfrm/espintcp.c                                |   6 +-
 net/xfrm/xfrm_user.c                               | 228 ++++++---
 scripts/mod/modpost.c                              |  11 +-
 security/integrity/ima/ima_appraise.c              |   5 +
 security/keys/gc.c                                 |   4 +-
 security/keys/request_key_auth.c                   |  12 +-
 security/selinux/avc.c                             |   5 +-
 sound/core/pcm_timer.c                             |   7 +-
 sound/core/seq/oss/seq_oss_rw.c                    |   3 +-
 sound/isa/es18xx.c                                 |   4 +
 sound/pci/ctxfi/cthw20k2.c                         |   1 +
 sound/pci/hda/hda_controller.c                     |   2 +-
 sound/pci/hda/patch_conexant.c                     |  12 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +-
 sound/soc/bcm/bcm63xx-i2s-whistler.c               |   1 +
 sound/soc/codecs/ab8500-codec.c                    | 565 ++++++++++-----------
 sound/soc/codecs/cx20442.c                         |   3 +-
 sound/soc/codecs/mt6351.c                          |   1 +
 sound/soc/codecs/pcm3168a.c                        |  20 +-
 sound/soc/codecs/rk3328_codec.c                    |  54 +-
 sound/soc/codecs/rt5645.c                          |   4 +
 sound/soc/intel/atom/sst/sst_pci.c                 |   1 +
 sound/soc/intel/catpt/ipc.c                        |   8 +
 sound/soc/intel/catpt/loader.c                     |   3 +
 sound/soc/intel/catpt/registers.h                  |  12 +
 sound/soc/rockchip/rockchip_pdm.c                  |  16 +-
 sound/soc/rockchip/rockchip_spdif.c                |   1 +
 sound/soc/sprd/sprd-pcm-compress.c                 |  15 +-
 sound/soc/sti/uniperif_reader.c                    |   4 +-
 sound/soc/ti/ams-delta.c                           |   3 +-
 sound/soc/ti/omap3pandora.c                        |   5 +-
 sound/soc/ux500/mop500.c                           |   8 +-
 sound/soc/ux500/ux500_msp_dai.c                    | 167 ++----
 sound/soc/ux500/ux500_msp_dai.h                    |  11 -
 sound/soc/ux500/ux500_msp_i2s.c                    | 326 ++++++------
 sound/soc/ux500/ux500_msp_i2s.h                    |  30 +-
 sound/soc/ux500/ux500_pcm.c                        |  83 +--
 sound/usb/caiaq/audio.c                            |  10 +-
 sound/usb/caiaq/device.c                           |  53 +-
 sound/usb/caiaq/device.h                           |   4 +-
 sound/usb/caiaq/input.c                            |   6 +
 sound/usb/caiaq/midi.c                             |   6 +-
 sound/usb/mixer.c                                  |  17 +-
 sound/usb/mixer_maps.c                             |  10 +
 sound/usb/quirks-table.h                           |  22 +
 sound/usb/usx2y/us122l.c                           |   9 +-
 sound/usb/usx2y/usbusx2y.c                         |  39 +-
 tools/perf/util/cs-etm.c                           |  81 +--
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  28 +
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/powerpc/tm/tm.h            |   8 +-
 592 files changed, 5904 insertions(+), 3858 deletions(-)


