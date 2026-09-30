Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22375326DD;
	Wed, 30 Sep 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790679; cv=none; b=htfr1y5otzuyw4KOdxz5Wnu+UoQctABbM1WeJm4Za3s7zdWDDpxe1fPXPoIKNWoUG8zoy6aSvEZ0fhoJRW8/kA64+qc28CQMhhDzqdHCjGKGTBWxYtAkN1twiNM9BxAx4vB33lXl1nZpNgtW7jkgrMhwE8NBngAYCvux6zpMuGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790679; c=relaxed/simple;
	bh=gIbuCWHGlDctviLPVIr3Kipoc6z2SPuNXIiX7Kw09uA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jScAAfTl848EqdBBUVNwurABHT+nYbuhxx/W0WJ4V+6rYkruZ97uf5XFK4RDSxUO/HUls3P6jKXSlHec8TQEPtK8NraFY9UObV1XzzP2ckId65rRim9zVoCQ8wfhTY6xPs4jfNeBVe04gabT15UvkdkWdBxwCCFJDc555CMUeas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcLwITqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcLwITqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8321C1F00898;
	Wed, 30 Sep 2026 17:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790673;
	bh=DSB0fZ4bWBSrV+bed/QWH5K9+Hy8jYrlamr0zNEAo2c=;
	h=From:To:Cc:Subject:Date;
	b=PcLwITqjuF5OHzAihA2uoAZtMihnmGYFDCbuUV2MaH6ZEMRSunUsgtDB55DNQlQJQ
	 ywcLwBYpw8azF3C+kF0M1qgA5zGQqwqBpPeLIBZeHKX/ZiqR8rTWMvzL00GPG+HyRX
	 ENO/G2Af96elCMffPbZQsy1RgA5w464kQgV3KgW4=
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
Subject: [PATCH 5.15 000/752] 5.15.222-rc1 review
Date: Wed, 30 Sep 2026 17:17:50 +0200
Message-ID: <20260930152358.131179731@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.222-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.222-rc1
X-KernelTest-Deadline: 2026-10-02T15:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.222 release.
There are 752 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.222-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.222-rc1

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()

Rengarajan S <rengarajan.s@microchip.com>
    lan78xx: Enable Auto Speed and Auto Duplex configuration for LAN7801 if NO EEPROM is detected

Rengarajan S <rengarajan.s@microchip.com>
    lan78xx: Enable 125 MHz CLK configuration for LAN7801 if NO EEPROM is detected

Florian Eckert <fe@dev.tdt.de>
    tools/thermal/tmon: Fix compilation warning for wrong format

James Clark <james.clark@linaro.org>
    perf test: Change all remaining #!/bin/sh to #!/bin/bash

Christian Brauner <brauner@kernel.org>
    eventpoll: fix ep_remove struct eventpoll / struct file UAF

Christian Brauner <brauner@kernel.org>
    eventpoll: move epi_fget() up

Christian Brauner <brauner@kernel.org>
    eventpoll: rename ep_remove_safe() back to ep_remove()

Christian Brauner <brauner@kernel.org>
    eventpoll: drop vestigial __ prefix from ep_remove_{file,epi}()

Christian Brauner <brauner@kernel.org>
    eventpoll: kill __ep_remove()

Christian Brauner <brauner@kernel.org>
    eventpoll: split __ep_remove()

Christian Brauner <brauner@kernel.org>
    eventpoll: use hlist_is_singular_node() in __ep_remove()

Christian Brauner <brauner@kernel.org>
    file: add fput() cleanup helper

Linus Torvalds <torvalds@linux-foundation.org>
    eventpoll: don't decrement ep refcount while still holding the ep mutex

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix silent data drop under pipe back-pressure

Darrick J. Wong <djwong@kernel.org>
    xfs: fix blockgc group quota scanning when usrquota isn't enforced

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

Peiyang He <peiyang_he@smail.nju.edu.cn>
    drm/nouveau: don't bump pin count on failed re-pin in nouveau_bo_pin_locked()

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

Josef Bacik <josef@toxicpanda.com>
    writeback: report a Tasks-RCU quiescent state per cgwb drain pass

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

Stephen Dolan <sdolan@janestreet.com>
    x86/mm: Fix check/use ordering in switch_mm_irqs_off()

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: WARN and clear role.invalid when creating a child shadow page

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Fix shadow paging use-after-free due to unexpected role

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fix shadow paging use-after-free due to unexpected GFN

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86/mmu: pull call to drop_large_spte() into __link_shadow_page()

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Always pass 0 for @quadrant when gptes are 8 bytes

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Derive shadow MMU page role from parent

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Rename gpte_is_8_bytes to has_4_byte_gpte and invert the direction

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Calculate quadrant when !role.gpte_is_8_bytes

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Remove useless code to set role.gpte_is_8_bytes when role.direct

Paolo Bonzini <pbonzini@redhat.com>
    KVM: MMU: update comment on the number of page role combinations

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Stop passing "direct" to mmu_alloc_root()

David Matlack <dmatlack@google.com>
    KVM: x86/mmu: Use a bool for direct

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

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix UAF on lgr list traversal in smcr_port_err()

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: stop links when their GID is removed

Yilin Zhang <yilinzhang@moonshot.ai>
    tcp: fix use-after-free of retransmit_skb_hint in tcp_send_synack()

Norbert Szetei <norbert@doyensec.com>
    net: xps: reject an out of range traffic class

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ip_gre: Reject enabling collect metadata through changelink

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr

Ido Schimmel <idosch@nvidia.com>
    vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets

Shihuang Liu <shlomojune6@gmail.com>
    net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()

Jakub Kicinski <kuba@kernel.org>
    veth: manage XDP program pointers during channel resize

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

Chris Gellermann <christian.gellermann@codasip.com>
    nfc: virtual_ncidev: Add missing ioctl compat handler

Chris Gellermann <christian.gellermann@codasip.com>
    selftests/nci: Fix out-of-bounds store on thread join

Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
    selftests: nci: Fix uninitialized family ID on missing attribute

Lee Jones <lee@kernel.org>
    nfc: llcp: Fix race condition in accept_queue lifecycle

Lei Zhu <zhulei@kylinos.cn>
    selftests: nci: Correct pthread_create return value check

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

Xin Long <lucien.xin@gmail.com>
    sctp: hold asoc or transport before mod_timer() in timer handlers

Zhao Gongyi <zhaogongyi@BYTEDANCE.COM>
    bpf, sockmap: Reject max_entries > INT_MAX in sock_map_alloc

Emil Tsalapatis <emil@etsalapatis.com>
    bpf: Fix bpf_sock context code generation

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: ti: netcp: fix pm_runtime usage counter leak on error

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Fix NULL pointer dereference in debug_info_copy()

Mikhail Zaslonko <zaslonko@linux.ibm.com>
    s390/debug: Do not register views for failed static debug areas

Myeonghun Pak <mhun512@gmail.com>
    tg3: clean up PHYLIB resources on probe failure

Pengpeng Hou <hppiscas@163.com>
    net: usb: sr9700: include receive overhead in the length check

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: Reject short EA=0 frames in rfcomm_recv_frame()

Hui Peng <benquike@gmail.com>
    Bluetooth: bnep: fix out-of-bounds reads on short RX/TX frames and control fallthrough

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: release the GEM object on virtio_gpu_vram_create() errors

Junrui Luo <moonafterrain@outlook.com>
    drm/virtio: fix object leaks in virtio_gpu_resource_create_blob_ioctl()

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

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Restrict CO-RE poisoning to relocatable instructions

Yonghong Song <yhs@fb.com>
    libbpf: Fix an error in 64bit relocation value computation

Zhiling Zou <zhilinz@nebusec.ai>
    xsk: Use a 32-bit compare in xsk_map_gen_lookup

Julian Sun <sunjunchao@bytedance.com>
    fs: avoid repeated scans in evict_inodes()

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Check pmcw.dnv before pmcw.ena in I/O entry points

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Fix cio_update_schib() to not cache invalid schib

Karl Mehltretter <kmehltretter@gmail.com>
    s390/pci/docs: Fix sriov_numvfs attribute name

Niklas Schnelle <schnelle@linux.ibm.com>
    docs: s390/pci: Improve and update PCI documentation

Randy Dunlap <rdunlap@infradead.org>
    Documentation: s390: correct spelling

Christiano Amora <christiano.amora@gmail.com>
    Bluetooth: SMP: reject Security Request over BR/EDR

Ran Hongyun <ranhongyun1@huawei.com>
    squashfs: Add dictionary size range check to prevent shift-out-of-bounds

Slawomir Stepien <sst@poczta.fm>
    HID: amd_sfh: Validate PCI BAR size before mapping

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    HID: amd_sfh: Move common macros and structures

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix out-of-bounds read of rtt_min in sock_ops

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
    bpf: Avoid soft lockup in __htab_map_lookup_and_delete_batch()

Oscar Priego Verdugo <oscar.priegov@gmail.com>
    HID: elecom: fix bus type for M-XGL20DLBK

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix divide-by-zero in btf_struct_walk()

Feng Zhou <zhoufeng.zf@bytedance.com>
    bpf: support access variable length array of integer type

Sven Schnelle <svens@linux.ibm.com>
    selftests/ftrace: Fix unique symbol check in kprobe_non_uniq_symbol.tc

Weiming Shi <bestswngs@gmail.com>
    bpf: Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix bpf_skb_change_tail wrt csum partial skbs

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: Fix IRQ injection with SIGP Stop and Store Status

Vitaly Kuznetsov <vkuznets@redhat.com>
    HID: hyperv: streamline driver probe to avoid devres issues

Junli Liu <liujunli@lixiang.com>
    erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC

Sandeep Dhavale <dhavale@google.com>
    erofs: Fix detection of atomic context

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: zynqmp-gqspi: Use devm_spi_alloc_host()

Itai Handler <itai.handler@gmail.com>
    spi: spi-zynqmp-gqspi: stop the controller on shutdown

Benoît Sevens <bsevens@google.com>
    HID: logitech-hidpp: fix race condition when accessing stale stack pointer

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/hdmi_phy: fix runtime PM cleanup on probe failure

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/adreno: fix autosuspend cleanup during teardown

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: fix out-of-bounds write in gud_plane_atomic_check()

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
    watchdog: msc313e: Fix premature reset during timeout update

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: digicolor: Avoid division by zero

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83793) release probe data through kref

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/tps53679) Fix TPS53676 phase page decoding

Nuno Sá <nuno.sa@analog.com>
    hwmon: (pmbus/core) increase number of phases and add new mask

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

Florian Maillard <florian.maillard@mailoo.org>
    mmc: rtsx_pci_sdmmc: ignore broken write-protect on ThinkPad X260

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

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix tpm2_load_cmd() boundary check

Maoyi Xie <maoyixie.tju@gmail.com>
    keys: translate request_key_auth pid for the reading procfs instance

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: avoid truncating TPACKET_V3 private size

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: clear RX owner on VNET header error

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: cap hh_flows_limit at change time

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: mhi_wwan_mbim: check skb_copy_bits() return value

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: mhi_wwan_mbim: guard against a cyclic NDP chain

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

Thomas Huth <thuth@redhat.com>
    kselftest/arm64: Fix size of thread_data values for pthread_join()

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

Roberts Kursitis <roberts.kursitis@azeron.eu>
    Input: xpad - add support for Azeron devices

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

HyeongJun An <sammiee5311@gmail.com>
    ASoC: hdmi-codec: Report a change when the channel status moves

Sasha Levin <sashal@kernel.org>
    ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV Nested: Change nested guest lookup to use idr

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix out-of-bounds write in reset_per_cpu_data()

Eric Dumazet <edumazet@google.com>
    drop_monitor: synchronize tracepoint unregistration on error path

Eric Dumazet <edumazet@google.com>
    pppoatm: ensure a writable skb header and linear data

Juan Perdomo <jcperdomo100@gmail.com>
    Bluetooth: RFCOMM: avoid socket lock inversion in listener cleanup

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

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dsi: round the byte clock rate after reparenting to the PHY PLL

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: correct byte intf clock rate for 14nm DSI PHY

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
    wifi: mac80211: suppress chanctx warning for debugfs reset

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

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Enforce local fence for IB_WR_REG_MR

Li RongQing <lirongqing@baidu.com>
    RDMA/mad: Fix receive buffer leak when PKey enforcement fails

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: wait for deferred control PDU completions before releasing the connection

Max Gurtovoy <mgurtovoy@nvidia.com>
    scsi: target: iscsi: Rename iscsi_cmd to iscsit_cmd

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

Eric Dumazet <edumazet@google.com>
    xfrm: add missing rcu_read_lock(), skb_dst_force() and dev_hold() for xfrm_trans_reinject()

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

Jens Axboe <axboe@kernel.dk>
    sunvdc: fix -EIO issue due to lack of retries

Günther Noack <gnoack@google.com>
    selftests/landlock: Add tests for whiteout object creation

Sasha Levin <sashal@kernel.org>
    Revert "alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally"

Sasha Levin <sashal@kernel.org>
    Revert "alpha: don't leak hardware-fabricated FP exception bits to user space"

Günther Noack <gnoack@google.com>
    landlock: Require LANDLOCK_ACCESS_FS_MAKE_REG for whiteout creation

Edward Adam Davis <eadavis@qq.com>
    bluetooth/l2cap: sync sock recv cb and release

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix deadlock

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: ensure interrupts are enabled in __do_user_fault()

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix branch predictor hardening

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: fix hash_name() fault

Darrick J. Wong <djwong@kernel.org>
    iomap: iomap: fix memory corruption when recording errors during writeback

Paolo Abeni <pabeni@redhat.com>
    mptcp: close race between scheduler and state change

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded actions on subflow reset

Eric Biggers <ebiggers@kernel.org>
    netfilter: nft_set_pipapo_avx2: add missing vzeroupper

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ss - Remove crypto_rng interface

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ce - Remove crypto_rng interface

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    fou: Fix use-after-free in fou_create()

Weiming Shi <bestswngs@gmail.com>
    net: appletalk: fix NULL pointer dereference in aarp_send_ddp()

Weiming Shi <bestswngs@gmail.com>
    i2c: smbus: reject oversized block transfers in the common path

Kazuki Hanai <hnkz.64@gmail.com>
    ALSA: us122l: Prevent write upgrades for read mappings

Sasha Levin <sashal@kernel.org>
    Revert "perf tests: Fix flakiness in BPF counters test on hybrid systems"

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: extend RCU protection in igmp6_send()

Suraj Jitindar Singh <surajjs@amazon.com>
    bpftool: remove duplicate free_btf_vmlinux() definition

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: syncookies: remember the request backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: handle MPC data + csum reqd + no csum

Joe Damato <joe@dama.to>
    bnxt_en: Propagate RX ring init failures in bnxt_init_nic()

Joe Damato <joe@dama.to>
    bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate HEVC tile counts

Haotian Zhang <vulab@iscas.ac.cn>
    media: v4l2-h264: Fix memcmp() size in B1 reference list comparison

Michael Bommarito <michael.bommarito@gmail.com>
    media: hevc: add bounded tile-count helpers

Vishnu Razdan <vrazdan@openai.com>
    hwmon: (pmbus) Clear generic status alarms with CLEAR_FAULTS

Fan Wu <fanwu01@zju.edu.cn>
    hwmon: (gpio-fan) Fix use-after-free in alarm work

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

Chengfeng Ye <nicoyip.dev@gmail.com>
    netfilter: nf_log: unregister loggers before per-net teardown

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

Tristan Madani <tristan@talencesecurity.com>
    ALSA: usbusx2y: fix in04_last array size mismatch with in04_buf

Roman Prucha <zorgan.roman@gmail.com>
    ALSA: ctxfi: Fix CA20K2 S/PDIF passthrough

Zihan Xi <zihanx@nebusec.ai>
    ipv6: fix fib6 walker UAF on seq stop

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/eeh: Fix recursive locking on devices without EEH sensitive driver

Sasha Levin <sashal@kernel.org>
    Revert "scsi: smartpqi: Capture controller reason codes"

Sasha Levin <sashal@kernel.org>
    Revert "scsi: core: Register sysfs attributes earlier"

Sasha Levin <sashal@kernel.org>
    Revert "scsi: smartpqi: Switch to attribute groups"

Sasha Levin <sashal@kernel.org>
    Revert "scsi: smartpqi: Fix BUILD_BUG_ON() statements"

Sasha Levin <sashal@kernel.org>
    Revert "scsi: smartpqi: Stop using the SCSI pointer"

Sasha Levin <sashal@kernel.org>
    Revert "scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches."

Eric Dumazet <edumazet@google.com>
    macvlan: inherit needed_headroom and needed_tailroom from lowerdev

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent out-of-bounds reads in share config responses

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

Dmitry Bogdanov <d.bogdanov@yadro.com>
    scsi: target: iscsi: Handle abort for WRITE_PENDING cmds

WenTao Liang <vulab@iscas.ac.cn>
    drm/amd/display: set new_stream to NULL after release

Stian Halseth <stian@itx.no>
    sunvdc: unmap LDC cookies when the descriptor send fails

Greg Marsden <greg.marsden@oracle.com>
    net/rds: fix tcp stream corruption with large pages

Linus Walleij <linus.walleij@linaro.org>
    net/rds: Pass a pointer to virt_to_page()

Ratheesh Kannoth <rkannoth@marvell.com>
    octeontx2-af: fix PF/CGX debugfs PCI bus lookup

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

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: initialize ptp_lock at probe time

Yannick Vignon <yannick.vignon@nxp.com>
    net: stmmac: optimize locking around PTP clock reads

Qingfang Deng <qingfang.deng@linux.dev>
    ppp_synctty: ensure a writeable skb header

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors

Cong Nguyen <congnt264@gmail.com>
    hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix clock leak and spurious timer in settimeout()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Avoid division by zero

David Arcari <darcari@redhat.com>
    watchdog: fix hrtimer start when pretimeout is zero

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

Alice Mikityanska <alice@isovalent.com>
    net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward

Andrew Stellman <astellman@stellman-greene.com>
    virtio-pci: return IRQ_HANDLED after non-zero ISR

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim_blk: reject out-of-range sector starts

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim_blk: make vdpasim_blk_check_range usable by other requests

Stefano Garzarella <sgarzare@redhat.com>
    vdpa_sim_blk: use dev_dbg() to print errors

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

Lama Kayal <lkayal@nvidia.com>
    net/mlx5: E-Switch, prevent mc_list repopulation during vport disable

Yael Chemla <ychemla@nvidia.com>
    net/mlx5: E-Switch: fix use-after-free in mlx5_eswitch_termtbl_put

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Fix use-after-free race in sample_restore_put()

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

Ido Schimmel <idosch@nvidia.com>
    nexthop: Initialize extack in remove_nh_grp_entry()

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

Eduard Zingerman <eddyz87@gmail.com>
    bpf: reject BPF_PSEUDO_FUNC reference to the main program

Henry Martin <bsdhenrymartin@gmail.com>
    tracing/probes: Fix use-after-free on field name/type of events with multiple probes

Joas Antonio dos Santos <joasantonio108@gmail.com>
    netfilter: nf_conntrack_sip: fix OOB read in sip_skip_whitespace()

Kyle Zeng <kylebot@openai.com>
    ipvs: fix reversed sequence option serialization

Qu Wenruo <wqu@suse.com>
    btrfs: do not force reloc root creation during qgroup_account_snapshot()

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

Eric Dumazet <edumazet@google.com>
    locking/lockdep: Invalidate stale class_cache entries for zapped classes

Kent Overstreet <kent.overstreet@linux.dev>
    lockdep: Add lock_set_cmp_fn() annotation

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Improve the deadlock scenario print for sync and read lock

Boqun Feng <boqun.feng@gmail.com>
    locking/lockdep: Introduce lock_sync()

Leo Yan <leo.yan@arm.com>
    perf/core: Skip empty AUX records with only format flags

Ivy Lopez <skunkolee@gmail.com>
    scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()

Nitesh Narayan Lal <nitesh@redhat.com>
    scsi: mpt3sas: Use irq_set_affinity_and_hint()

Guanghui Yang <3497809730@qq.com>
    btrfs: restore active device pointers after failed sprout

Anand Jain <anand.jain@oracle.com>
    btrfs: consolidate device_list_mutex in prepare_sprout to its parent

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

Tung Nguyen <tung.quang.nguyen@est.tech>
    tipc: fix NULL deref in tipc_named_node_up() on empty publication list

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

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rate limit unmapped SID errors

Yilin Zhang <yilinzhang@moonshot.ai>
    ALSA: pcm: Serialize PCM mmap with buffer reallocation to fix page UAF

Colin Ian King <colin.i.king@gmail.com>
    OPP: of: Fix potential multiplication overflow when calculating freq

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix NULL pointer dereference in PM callbacks

James Nugraha <aslan.jnn@gmail.com>
    net: amd-xgbe: discard rx packets with bad FCS

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    smb: client: transport: Fix debug printing in __release_mid()

Xin Long <lucien.xin@gmail.com>
    sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: size the RTM_GETACTION reply from the actions

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: budget all shared attributes in notify skbs

Hongfu Li <lihongfu@kylinos.cn>
    selftests/cgroup: Fix cg_run_in_subcgroups ignoring arg parameter

Xixin Liu <liuxixin@kylinos.cn>
    nvme-rdma: fix -EIO cleanup order in queue_rq

Dan Carpenter <error27@gmail.com>
    drm/virtio: Fix a NULL vs ERR_PTR() bug in virtio_gpu_user_framebuffer_create()

Jad Keskes <inasj268@gmail.com>
    EDAC/device_sysfs: Use kstrtouint() for poll_msec to prevent truncation

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel address decode for non-hash mode

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix channel selection hash

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/igen6: Fix interleave boundary condition

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9484/1: enable interrupts when unhandled user faults are triggered

Sasha Levin <sashal@kernel.org>
    Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"

Sasha Levin <sashal@kernel.org>
    Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"

SJ Park <sj@kernel.org>
    mm/damon/core: avoid infinite kdamond_merge_regions() internal loop

Vlatko Kosturjak <kost@linux.hr>
    ppp_async: drop the errored frame instead of resetting its headroom

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: at91: pmc: #undef field_{get,prep}() before definition

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state

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

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: core: clamp voltage constraints before applying apply_uV

Georgi Valkov <gvalkov@gmail.com>
    wifi: mwifiex: replace one-element arrays with flexible array members

Daniel C. Ribeiro <dcoutinho.96@gmail.com>
    ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless

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
    wifi: iwlwifi: mvm: fix sched scan IE sizing

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix an off-by-1 boundary check

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reloc root cleanup in merge_reloc_roots()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()

Dave Chen <davechen@synology.com>
    btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rsi: validate beacon length before fixed buffer copy

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: mark the rcu locked areas properly

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: libipw: fix key index receive bound checks

Liang Hao <haohlliang@gmail.com>
    gpio: dwapb: Mask interrupts at hardware initialization

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate rx/tx MLME callback frame lengths before access

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate SID namespace before mapping IDs

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: mark invalid session responses as signed

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: find bound sessions during reauthentication

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

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix credit charge calculation for SMB2 QUERY_INFO

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/gntalloc: validate grant count before allocation

Farhad Alemi <farhad.alemi@berkeley.edu>
    freevxfs: don't BUG() on unknown typed-extent type

Yousef Alhouseen <alhouseenyousef@gmail.com>
    xen/front-pgdir-shbuf: free grant reference head on errors

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/komeda: fix error handling for clk_prepare_enable() and callers

Qiang Liu <liuqiang@kylinos.cn>
    ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_expect: zero at allocation time

Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
    drm/arm/malidp: use clk_bulk API in runtime PM resume and suspend

Weiming Shi <bestswngs@gmail.com>
    btrfs: tree-checker: validate INODE_REF's namelen

Haoxiang Li <haoxiang_li2024@163.com>
    fbdev: pm2fb: unwind WC setup on probe failure

Adriana Stancu <adriana@arista.com>
    rtc: bq32000: add delay between RTC reads

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: au1000: move free_irq out of the close-time spinlocked section

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Use kstrtobool() to parse the ROM attribute input

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: break RH leases before delete-on-close

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: apply create security descriptor first

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: treat unnamed DATA stream as base file

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use connection ClientGUID for lease lookup

Tommy Huang <tommy_huang@aspeedtech.com>
    rtc: aspeed: add AST2700 compatible

Samuel Moelius <sam.moelius@trailofbits.com>
    f2fs: validate inline dentry name lengths before conversion

Chen Cheng <chencheng@fnnas.com>
    md/raid5: let stripe batch bm_seq comparison wrap-safe

Yu Kuai <yukuai@fygo.io>
    md/raid5: account discard IO

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

Matthew Bystrin <dev.mbstr@gmail.com>
    mfd: rsmu: Add 8a34002 support

Tobias Deiminger <tobias.deiminger@linutronix.de>
    leds: pca9532: Don't stop blinking for non-zero brightness

Yousef Alhouseen <alhouseenyousef@gmail.com>
    leds: uleds: Return -EFAULT on copy_to_user() failure

Galen Hassen <rwekyes@gmail.com>
    ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10

guoqi0226 <guoqi0226@163.com>
    spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()

Rob Herring (Arm) <robh@kernel.org>
    gpio: pisosr: Read "ngpios" as u32

Arnd Bergmann <arnd@arndb.de>
    scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()

Zhang Tianci <zhangtianci.1997@bytedance.com>
    fuse: set ff->flock only on success

Rosen Penev <rosenp@gmail.com>
    sparc: Disable compat support with LLD

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Tolerate i3c_master_add_i3c_dev_locked() failures in DAA

Alice Mikityanska <alice@isovalent.com>
    net/sched: act_csum: don't mangle UDP tunnel GSO packets

Agalakov Daniil <ade@amicon.ru>
    e1000e: limit endianness conversion to boundary words

Raf Dickson <rafdog35@gmail.com>
    vsock: use sk_acceptq_is_full() helper in all transports

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    ptp: ocp: add shutdown callback

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

Tze Yee Ng <tze.yee.ng@altera.com>
    dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc

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

KangNing Liao <lkangn.kernel@gmail.com>
    btrfs: protect sb_write_pointer() with invalidate lock

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

Aurelien DESBRIERES <aurelien@hackers.camp>
    RDMA/rtrs-srv: Fix integer underflow in process_read and process_write

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

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/umem: Be careful about boundary conditions in ib_umem_find_best_pgsz()

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

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix handling of NAPI on the remove path

David Yang <mmyangfl@gmail.com>
    net: dsa: sja1105: flower: reject cross-chip redirect

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: fix the error path in dpaa2_switch_rx()

Ioana Ciornei <ioana.ciornei@nxp.com>
    dpaa2-switch: rework FDB management on the bridge leave path

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq: oss: Reject reads that cannot fit the next event

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: codecs: rk3328: Use managed GPIO and clock helpers

Alessandro Schino <7991aleschino@gmail.com>
    ntfs3: fix out-of-bounds read in ntfs_dir_emit() and hdr_find_e()

ZhengYuan Huang <gality369@gmail.com>
    fs/ntfs3: validate index entry key bounds

ZhengYuan Huang <gality369@gmail.com>
    fs/ntfs3: preserve non-DOS attribute bits in system.dos_attrib

Simon Xue <xxm@rock-chips.com>
    iommu/rockchip: disable fetch dte time limit

Wentao Liang <vulab@iscas.ac.cn>
    net: qrtr: fix node refcount leak on ctrl packet alloc failure

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach

liyouhong <liyouhong@kylinos.cn>
    ata: ahci: fail probe if BAR too small for claimed ports

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: Reserve VLAN header in MJS limit

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Also reset {insn,data}_cur on realloc failure

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: accel: mma8452: switch to non-devm request_threaded_irq()

Rik van Riel <riel@surriel.com>
    perf/ftrace: Fix WARNING in __unregister_ftrace_function

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC

Osama Abdelkader <osama.abdelkader@gmail.com>
    mmc: davinci: fix mmc_add_host order in probe

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: only handle alert events when the peripheral is attached

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Complete coredump handling

Alexandre Courbot <acourbot@nvidia.com>
    scripts: modpost: detect and report truncated buf_printf() output

shayderrr <darknessshayder@gmail.com>
    host1x: bus: Fix missing ops null check in error teardown

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

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate SENSOR_UPDATE payload size

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

Stefan Berger <stefanb@linux.ibm.com>
    integrity: Check for NULL returned by asymmetric_key_public_key

Sophie D <patches@scd31.com>
    drm/gud: Add RCade Display Adapter VID/PID pair

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: rework hfsplus_readdir() logic

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix CRC open failure during active rendering

Stepan Ionichev <sozdayvek@gmail.com>
    mmc: davinci: avoid NULL deref of host->data in IRQ handler

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Add validation for host-provided max_segs

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ASoC: ti: omap3pandora: update board check to use DT compatible

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Add number of clock cells check

Ruoyu Wang <ruoyuw560@gmail.com>
    crypto: ixp4xx - fix buffer chain unwind on allocation failure

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    media: em28xx-video: fix missing res_free() on init_usb_xfer failure

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: enable .rmu_disable() for 6320 family

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: define .pot_clear() for 6321

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

Vineeth Vijayan <vneethv@linux.ibm.com>
    s390/cio: Purge based on the cdev's online status

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

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: wait for the MC firmware to complete its boot


-------------

Diffstat:

 .../ABI/testing/sysfs-devices-platform-trackpoint  |   2 +-
 Documentation/driver-api/serial/tty.rst            |   2 +-
 Documentation/networking/ip-sysctl.rst             |   2 +
 Documentation/s390/pci.rst                         | 144 ++++--
 Documentation/s390/vfio-ccw.rst                    |   2 +-
 Documentation/virt/kvm/mmu.rst                     |   8 +-
 Makefile                                           |   4 +-
 arch/alpha/include/uapi/asm/fpu.h                  |   8 +-
 arch/alpha/kernel/traps.c                          |   6 +-
 arch/alpha/math-emu/math.c                         |  88 +---
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
 arch/powerpc/include/asm/kvm_host.h                |   3 +-
 arch/powerpc/kernel/eeh_driver.c                   |   2 -
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kexec/file_load_64.c                  |   2 +-
 arch/powerpc/kvm/book3s_hv.c                       |   4 +-
 arch/powerpc/kvm/book3s_hv_nested.c                | 112 ++--
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   5 +-
 arch/powerpc/platforms/pseries/kexec.c             |  13 +-
 arch/s390/crypto/aes_s390.c                        |  16 +-
 arch/s390/include/asm/debug.h                      |   8 +-
 arch/s390/kernel/debug.c                           |  15 +-
 arch/s390/kvm/interrupt.c                          |  72 +--
 arch/sparc/Kconfig                                 |   1 +
 arch/sparc/kernel/uprobes.c                        |   1 +
 arch/x86/include/asm/kvm_host.h                    |  32 +-
 arch/x86/kvm/mmu/mmu.c                             | 187 ++++---
 arch/x86/kvm/mmu/mmutrace.h                        |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |  30 +-
 arch/x86/kvm/mmu/spte.h                            |   5 +
 arch/x86/kvm/mmu/tdp_mmu.c                         |   2 +-
 arch/x86/mm/tlb.c                                  |  16 +-
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
 drivers/acpi/pci_root.c                            |   4 +
 drivers/ata/ahci.c                                 |  22 +
 drivers/ata/libahci.c                              |  15 +-
 drivers/ata/libata-pmp.c                           |   7 +-
 drivers/block/sunvdc.c                             |  26 +-
 drivers/bluetooth/btmtksdio.c                      |   4 +-
 drivers/bluetooth/btusb.c                          |  23 +-
 drivers/bluetooth/hci_mrvl.c                       |   3 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  46 ++
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
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  | 162 ------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  29 --
 drivers/crypto/allwinner/sun8i-ss/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  39 --
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  | 172 -------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  23 -
 drivers/crypto/atmel-ecc.c                         |   3 +
 drivers/crypto/ixp4xx_crypto.c                     |  25 +-
 drivers/dma/dmaengine.c                            |  10 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |  11 +-
 drivers/dma/mmp_pdma.c                             |   2 +-
 drivers/dma/sprd-dma.c                             |   3 +-
 drivers/dma/sun6i-dma.c                            |   9 +-
 drivers/dma/ti/k3-udma-glue.c                      |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  26 +-
 drivers/edac/edac_device_sysfs.c                   |  11 +-
 drivers/edac/igen6_edac.c                          |  27 +-
 drivers/firmware/arm_scmi/base.c                   |  15 +-
 drivers/firmware/arm_scmi/sensors.c                |  10 +-
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
 drivers/gpu/drm/gud/gud_drv.c                      |   1 +
 drivers/gpu/drm/gud/gud_pipe.c                     |   4 +-
 drivers/gpu/drm/i915/i915_query.c                  |   4 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +
 drivers/gpu/drm/msm/dsi/dsi.h                      |   1 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  38 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |   4 +
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |   8 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |   3 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |  23 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c   |   2 +
 drivers/gpu/drm/panel/panel-simple.c               |  28 +
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |   2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |   6 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c              |  17 +-
 drivers/gpu/host1x/bus.c                           |   4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_common.h           |  63 +++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |  10 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h             |  42 +-
 drivers/hid/hid-alps.c                             |   6 +-
 drivers/hid/hid-hyperv.c                           |  58 ++-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-logitech-hidpp.c                   |  10 +-
 drivers/hid/hid-quirks.c                           |   3 +-
 drivers/hid/wacom_sys.c                            |   5 +-
 drivers/hwmon/adt7462.c                            |   8 +
 drivers/hwmon/applesmc.c                           |   7 +-
 drivers/hwmon/aspeed-pwm-tacho.c                   |   4 +-
 drivers/hwmon/gpio-fan.c                           |  13 +-
 drivers/hwmon/pmbus/lm25066.c                      |  60 +--
 drivers/hwmon/pmbus/pmbus.h                        |   3 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |   4 +-
 drivers/hwmon/pmbus/tps53679.c                     |  11 +-
 drivers/hwmon/w83791d.c                            |   1 +
 drivers/hwmon/w83793.c                             |   4 +-
 drivers/i2c/busses/i2c-at91-core.c                 |   3 +
 drivers/i2c/busses/i2c-at91-master.c               |  12 +-
 drivers/i2c/busses/i2c-at91.h                      |   1 +
 drivers/i2c/busses/i2c-imx.c                       |   2 +
 drivers/i2c/i2c-core-smbus.c                       |  12 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |   4 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |   4 +-
 drivers/iio/accel/mma8452.c                        |  19 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |  18 +-
 drivers/infiniband/core/iwpm_util.c                |   9 +-
 drivers/infiniband/core/mad.c                      |   3 +-
 drivers/infiniband/core/ucma.c                     |   7 +-
 drivers/infiniband/core/umem.c                     |  18 +-
 drivers/infiniband/hw/irdma/verbs.c                |   2 +-
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
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   8 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.h             |   2 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |  12 +-
 drivers/input/evdev.c                              |   2 +
 drivers/input/input-compat.c                       |   2 +
 drivers/input/joystick/xpad.c                      |  10 +-
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
 drivers/md/raid5.c                                 |  35 +-
 drivers/media/i2c/video-i2c.c                      |   5 +-
 drivers/media/pci/dm1105/dm1105.c                  |   7 +-
 drivers/media/rc/imon.c                            |   4 +
 drivers/media/rc/mceusb.c                          |   2 +
 drivers/media/usb/em28xx/em28xx-video.c            |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  12 +
 drivers/media/v4l2-core/v4l2-h264.c                |   3 +-
 drivers/mfd/rsmu_i2c.c                             |   2 +
 drivers/mfd/rsmu_spi.c                             |   2 +
 drivers/mmc/core/bus.c                             |   2 +-
 drivers/mmc/core/queue.c                           |   8 +-
 drivers/mmc/core/sdio_uart.c                       |   3 +
 drivers/mmc/host/davinci_mmc.c                     |  16 +-
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/mxcmmc.c                          |   4 +
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |   2 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   5 +
 drivers/mmc/host/sdhci-of-aspeed.c                 |   5 +-
 drivers/mmc/host/sdhci_am654.c                     |   4 +-
 drivers/mmc/host/sh_mmcif.c                        |   3 +-
 drivers/net/bonding/bond_alb.c                     |  19 +-
 drivers/net/bonding/bond_main.c                    |   4 +-
 drivers/net/can/slcan.c                            |   3 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  23 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |   4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   2 +
 drivers/net/ethernet/amd/au1000_eth.c              |   3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |   3 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   3 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   3 +
 drivers/net/ethernet/atheros/atlx/atl1.c           |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  16 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   3 +
 drivers/net/ethernet/broadcom/tg3.c                |   4 +
 drivers/net/ethernet/cortina/gemini.c              |  79 +--
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |  69 ++-
 drivers/net/ethernet/freescale/fman/fman.c         |   1 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   3 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |   4 +-
 drivers/net/ethernet/ibm/emac/core.c               |   3 +-
 drivers/net/ethernet/ibm/emac/mal.c                |   6 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  19 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  20 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   3 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   8 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   7 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  10 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |   4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |  12 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |   4 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |   6 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |  11 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  32 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   9 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |  21 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 114 ++++-
 drivers/net/ethernet/ti/cpsw_new.c                 |   4 +-
 drivers/net/ethernet/ti/netcp_core.c               |   2 +-
 drivers/net/fddi/skfp/skfddi.c                     |   3 +-
 drivers/net/macvlan.c                              |   4 +
 drivers/net/ppp/ppp_async.c                        |  90 +---
 drivers/net/ppp/ppp_synctty.c                      |  17 +-
 drivers/net/slip/slip.c                            |   3 +-
 drivers/net/usb/catc.c                             |  15 +-
 drivers/net/usb/cdc_mbim.c                         |   5 +
 drivers/net/usb/cx82310_eth.c                      |   1 +
 drivers/net/usb/hso.c                              |   2 +-
 drivers/net/usb/lan78xx.c                          |   7 +-
 drivers/net/usb/qmi_wwan.c                         |   2 +
 drivers/net/usb/sr9700.c                           |   3 +-
 drivers/net/veth.c                                 |   2 +
 drivers/net/vrf.c                                  |   2 -
 drivers/net/vxlan/vxlan_core.c                     |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   4 +
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |  10 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   4 +-
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
 drivers/net/wwan/mhi_wwan_mbim.c                   |  28 +-
 drivers/nfc/microread/microread.c                  |   6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |  11 +-
 drivers/nfc/pn533/pn533.c                          |  14 +-
 drivers/nfc/pn533/pn533.h                          |   4 +-
 drivers/nfc/pn533/usb.c                            |   4 +-
 drivers/nfc/pn544/pn544.c                          |   7 +-
 drivers/nfc/port100.c                              |   7 +
 drivers/nfc/st21nfca/core.c                        |  12 +-
 drivers/nfc/st21nfca/i2c.c                         |  33 +-
 drivers/nfc/virtual_ncidev.c                       |   3 +-
 drivers/nvme/host/rdma.c                           |  18 +-
 drivers/opp/of.c                                   |   2 +-
 drivers/pci/controller/pcie-altera.c               |   2 +
 drivers/pci/controller/pcie-iproc.c                |   2 +
 drivers/pci/controller/pcie-mediatek.c             |   2 +
 drivers/pci/controller/pcie-rockchip-host.c        |   2 +
 drivers/pci/pci-driver.c                           |  10 +-
 drivers/pci/pci-sysfs.c                            |  11 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/pinctrl/pinctrl-single.c                   |   3 +-
 drivers/platform/x86/dell/dell-laptop.c            |   9 +
 drivers/platform/x86/intel/hid.c                   |   7 +
 drivers/ptp/ptp_ocp.c                              |   1 +
 drivers/regulator/core.c                           | 163 +++---
 drivers/rtc/rtc-aspeed.c                           |   1 +
 drivers/rtc/rtc-bq32k.c                            |   9 +
 drivers/s390/char/zcore.c                          |   8 +-
 drivers/s390/cio/cio.c                             |  11 +-
 drivers/s390/cio/device.c                          |   2 +-
 drivers/s390/cio/device_ops.c                      |  14 +
 drivers/s390/net/qeth_l2.h                         |   3 +-
 drivers/s390/net/qeth_l2_main.c                    |  26 +-
 drivers/s390/net/qeth_l2_sys.c                     |   7 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   2 +-
 drivers/scsi/hosts.c                               |  23 +-
 drivers/scsi/libiscsi_tcp.c                        |   3 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  24 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   8 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   7 +
 drivers/scsi/scsi_priv.h                           |   4 +-
 drivers/scsi/scsi_sysfs.c                          |  81 ++-
 drivers/scsi/smartpqi/smartpqi.h                   |  25 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 123 ++---
 drivers/scsi/smartpqi/smartpqi_sis.c               |  11 +-
 drivers/scsi/smartpqi/smartpqi_sis.h               |   4 +-
 drivers/soundwire/bus.c                            |   4 +
 drivers/soundwire/cadence_master.c                 |   7 +
 drivers/soundwire/slave.c                          |   4 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  52 +-
 drivers/spi/spi.c                                  |   6 +-
 drivers/staging/fbtft/fbtft-core.c                 |   9 +-
 drivers/target/iscsi/cxgbit/cxgbit.h               |   8 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |   4 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c        |  34 +-
 drivers/target/iscsi/iscsi_target.c                | 165 +++---
 drivers/target/iscsi/iscsi_target.h                |  14 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |  14 +-
 drivers/target/iscsi/iscsi_target_datain_values.c  |  18 +-
 drivers/target/iscsi/iscsi_target_datain_values.h  |  12 +-
 drivers/target/iscsi/iscsi_target_device.c         |   2 +-
 drivers/target/iscsi/iscsi_target_device.h         |   4 +-
 drivers/target/iscsi/iscsi_target_erl0.c           |  30 +-
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
 drivers/target/iscsi/iscsi_target_util.c           |  66 +--
 drivers/target/iscsi/iscsi_target_util.h           |  48 +-
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
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |  53 +-
 drivers/vhost/scsi.c                               |   3 +-
 drivers/vhost/vdpa.c                               |  12 +-
 drivers/video/fbdev/pm2fb.c                        |   1 +
 drivers/video/fbdev/vfb.c                          |  11 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/digicolor_wdt.c                   |  13 +-
 drivers/watchdog/msc313e_wdt.c                     |  35 +-
 drivers/watchdog/sp5100_tco.c                      |   6 +-
 drivers/watchdog/sunxi_wdt.c                       |  45 +-
 drivers/watchdog/watchdog_hrtimer_pretimeout.c     |   1 +
 drivers/xen/gntalloc.c                             |  13 +-
 drivers/xen/xen-front-pgdir-shbuf.c                |  12 +-
 fs/9p/vfs_dir.c                                    |  12 +
 fs/affs/affs.h                                     |   5 -
 fs/affs/super.c                                    |   6 +-
 fs/autofs/inode.c                                  |   4 +
 fs/befs/linuxvfs.c                                 |   3 +-
 fs/bfs/inode.c                                     |   3 +-
 fs/btrfs/inode.c                                   |   3 +-
 fs/btrfs/relocation.c                              |  47 +-
 fs/btrfs/transaction.c                             |  13 +-
 fs/btrfs/tree-checker.c                            |   8 +-
 fs/btrfs/volumes.c                                 |  79 ++-
 fs/btrfs/zoned.c                                   |   2 +
 fs/cifs/cifsacl.c                                  |   3 +
 fs/cifs/transport.c                                |  11 +-
 fs/configfs/dir.c                                  |  12 +-
 fs/erofs/zdata.c                                   |  13 +-
 fs/eventpoll.c                                     | 152 +++---
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
 fs/ksmbd/mgmt/share_config.c                       |  36 +-
 fs/ksmbd/misc.c                                    |  14 +-
 fs/ksmbd/oplock.c                                  |  16 +-
 fs/ksmbd/oplock.h                                  |   2 +-
 fs/ksmbd/server.c                                  |   6 +
 fs/ksmbd/smb2misc.c                                |   9 +-
 fs/ksmbd/smb2pdu.c                                 |  35 +-
 fs/ksmbd/smbacl.c                                  |  25 +-
 fs/ksmbd/transport_ipc.c                           |  24 +-
 fs/ksmbd/vfs.c                                     |  14 +-
 fs/minix/inode.c                                   |   3 +-
 fs/ntfs3/dir.c                                     |   4 +-
 fs/ntfs3/fslog.c                                   |  28 +-
 fs/ntfs3/index.c                                   |  41 +-
 fs/ntfs3/xattr.c                                   |   4 +-
 fs/ocfs2/namei.c                                   |   9 +-
 fs/ocfs2/xattr.c                                   |  13 +-
 fs/ocfs2/xattr.h                                   |   8 +-
 fs/omfs/inode.c                                    |   6 +-
 fs/qnx4/inode.c                                    |   3 +-
 fs/squashfs/xz_wrapper.c                           |   6 +-
 fs/ufs/cylinder.c                                  |  10 +
 fs/ufs/super.c                                     |  17 +-
 fs/xfs/xfs_icache.c                                |   2 +-
 include/keys/request_key_auth-type.h               |   2 +-
 include/linux/bitfield.h                           |   2 +-
 include/linux/file.h                               |   2 +
 include/linux/kcsan-checks.h                       |   6 +-
 include/linux/lockdep.h                            |  16 +-
 include/linux/lockdep_types.h                      |   8 +
 include/linux/lsm_hook_defs.h                      |   2 +-
 include/linux/lsm_hooks.h                          |   1 +
 include/linux/mailbox_controller.h                 |   2 +
 include/linux/platform_data/asoc-ux500-msp.h       |  20 -
 include/linux/rculist.h                            |  29 ++
 include/linux/tty_ldisc.h                          |   2 +-
 include/media/v4l2-hevc.h                          |  41 ++
 include/net/cfg80211.h                             |   2 +-
 include/net/gue.h                                  |  19 +-
 include/net/ip6_route.h                            |   2 +
 include/net/netfilter/nf_conntrack.h               |   5 +
 include/net/netfilter/nf_flow_table.h              |   1 +
 include/net/netns/xfrm.h                           |   2 +-
 include/net/nfc/hci.h                              |   2 +-
 include/net/nfc/nfc.h                              |   3 +-
 include/rdma/ib_umem.h                             |   4 +-
 include/scsi/scsi_device.h                         |   7 -
 include/scsi/scsi_host.h                           |  12 -
 include/target/iscsi/iscsi_target_core.h           |  34 +-
 include/target/iscsi/iscsi_transport.h             |  92 ++--
 include/uapi/linux/landlock.h                      |   1 +
 kernel/bpf/btf.c                                   |  29 +-
 kernel/bpf/cgroup.c                                |   1 +
 kernel/bpf/hashtab.c                               |  24 +-
 kernel/bpf/verifier.c                              |   9 +
 kernel/dma/coherent.c                              |  13 +-
 kernel/events/ring_buffer.c                        |   9 +-
 kernel/locking/lockdep.c                           | 230 +++++++--
 kernel/trace/trace_event_perf.c                    |  12 +-
 kernel/trace/trace_events_hist.c                   |   2 +-
 kernel/trace/trace_probe.c                         |  48 +-
 kernel/trace/trace_probe.h                         |   2 +
 kernel/workqueue.c                                 |   2 +-
 mm/backing-dev.c                                   |   5 +-
 mm/damon/core.c                                    |  13 +-
 net/8021q/vlan_dev.c                               |   5 +
 net/appletalk/aarp.c                               |   5 +
 net/atm/pppoatm.c                                  |  42 +-
 net/bluetooth/bnep/core.c                          |  17 +-
 net/bluetooth/bnep/netdev.c                        |   8 +-
 net/bluetooth/hci_sock.c                           |  20 +-
 net/bluetooth/l2cap_core.c                         |  31 +-
 net/bluetooth/l2cap_sock.c                         |  10 +-
 net/bluetooth/rfcomm/core.c                        |   6 +
 net/bluetooth/rfcomm/sock.c                        |  19 +-
 net/bluetooth/smp.c                                |  17 +
 net/bridge/br_arp_nd_proxy.c                       |  16 +-
 net/bridge/br_multicast.c                          |   2 -
 net/bridge/br_stp_bpdu.c                           |   5 +-
 net/core/dev.c                                     |   4 +-
 net/core/drop_monitor.c                            |   4 +-
 net/core/filter.c                                  |  33 +-
 net/core/skbuff.c                                  |  16 +-
 net/core/sock.c                                    |   9 +-
 net/core/sock_map.c                                |   1 +
 net/hsr/hsr_netlink.c                              |   9 +-
 net/ieee802154/6lowpan/core.c                      |   2 +-
 net/ipv4/arp.c                                     |   1 +
 net/ipv4/fib_rules.c                               |   4 +-
 net/ipv4/fou_core.c                                |   6 +-
 net/ipv4/ip_gre.c                                  |  12 +
 net/ipv4/ip_tunnel_core.c                          |   6 +
 net/ipv4/nexthop.c                                 |   2 +-
 net/ipv4/sysctl_net_ipv4.c                         |   4 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_output.c                              |   3 +
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
 net/mac80211/cfg.c                                 |   5 +-
 net/mac80211/debugfs.c                             |   2 +-
 net/mac80211/debugfs_netdev.c                      |   6 +
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/iface.c                               |   2 +
 net/mac80211/mesh.c                                |   1 -
 net/mac80211/mlme.c                                |   6 +-
 net/mac80211/pm.c                                  |   8 +-
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/util.c                                |   6 +-
 net/mptcp/options.c                                |   3 +-
 net/mptcp/protocol.c                               |  10 +-
 net/mptcp/protocol.h                               |   3 +-
 net/mptcp/subflow.c                                |  11 +
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
 net/netfilter/nf_log_syslog.c                      |   6 +-
 net/netfilter/nf_tables_api.c                      |   4 +-
 net/netfilter/nfnetlink_log.c                      |  28 +-
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
 net/sched/cls_api.c                                |   2 +-
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
 net/sctp/input.c                                   |   7 +-
 net/sctp/ipv6.c                                    |  12 +-
 net/sctp/protocol.c                                |  10 +-
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/sm_sideeffect.c                           |  48 +-
 net/sctp/sm_statefuns.c                            |   2 +
 net/smc/smc_clc.c                                  |   8 +-
 net/smc/smc_clc.h                                  |   9 +-
 net/smc/smc_core.c                                 |   2 +
 net/smc/smc_ib.c                                   |  59 +++
 net/sunrpc/xprtrdma/verbs.c                        |  21 +-
 net/tipc/group.c                                   |   4 +-
 net/tipc/monitor.c                                 |   3 +-
 net/tipc/name_table.c                              |  32 +-
 net/tls/tls_sw.c                                   |   6 +-
 net/vmw_vsock/hyperv_transport.c                   |   2 +-
 net/vmw_vsock/vmci_transport.c                     |   2 +-
 net/wireless/mlme.c                                |  49 +-
 net/wireless/nl80211.c                             |   2 +-
 net/wireless/scan.c                                |  12 +-
 net/wireless/util.c                                |  26 +-
 net/wireless/wext-sme.c                            |   9 +
 net/xdp/xskmap.c                                   |   2 +-
 net/xfrm/espintcp.c                                |   6 +-
 net/xfrm/xfrm_input.c                              |  11 +
 net/xfrm/xfrm_user.c                               | 228 ++++++---
 scripts/mod/modpost.c                              |  11 +-
 security/apparmor/lsm.c                            |   7 +-
 security/integrity/digsig_asymmetric.c             |   4 +
 security/integrity/ima/ima_appraise.c              |   5 +
 security/keys/gc.c                                 |   4 +-
 security/keys/request_key_auth.c                   |  12 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  12 +-
 security/landlock/errata/abi-1.h                   |  24 +
 security/landlock/fs.c                             |  40 +-
 security/security.c                                |   4 +-
 security/selinux/avc.c                             |   5 +-
 security/tomoyo/tomoyo.c                           |   4 +-
 sound/core/pcm_native.c                            |  35 +-
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
 sound/soc/codecs/hdmi-codec.c                      |   6 +-
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
 sound/usb/quirks.c                                 |   2 +
 sound/usb/usx2y/us122l.c                           |   9 +-
 sound/usb/usx2y/usbusx2y.c                         |  45 +-
 sound/usb/usx2y/usbusx2y.h                         |   4 +-
 tools/bpf/bpftool/map.c                            |   6 -
 tools/lib/bpf/gen_loader.c                         |   2 +
 tools/lib/bpf/relo_core.c                          |  60 ++-
 tools/perf/tests/shell/stat_bpf_counters.sh        |  30 +-
 tools/perf/util/cs-etm.c                           |  81 +--
 .../selftests/arm64/mte/check_gcr_el1_cswitch.c    |   2 +-
 tools/testing/selftests/cgroup/test_kmem.c         |   2 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |   2 +-
 tools/testing/selftests/landlock/fs_test.c         | 154 ++++++
 tools/testing/selftests/nci/nci_dev.c              |  45 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  28 +
 tools/testing/selftests/net/pmtu.sh                |   2 +-
 tools/testing/selftests/powerpc/tm/tm.h            |   8 +-
 tools/thermal/tmon/tui.c                           |   2 +-
 727 files changed, 7788 insertions(+), 4869 deletions(-)


