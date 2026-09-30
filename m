Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AA64EDCA2;
	Wed, 30 Sep 2026 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784087; cv=none; b=lLkcNomWi4ndMLbZRuVpBgZKFdWbPKXkgjTE4npVfulaTI36Ii0YrpeWzbsDQsOfPpurrdNtwXj9ZjknQe2UtzZYv+b14F6qQDKF6Bbpo4+nwW1YMrfmqQpbnhfx7E/umDCKQcAgIucqgFVmJQw8gO/WEmuqAML8NGRHgjHkzrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784087; c=relaxed/simple;
	bh=SmLw2SENxwseY1q3tWjf9cj/FliFi2V75ozPLCiC6/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eCDPJmfQ19EHJdVzv2ebdLoUqjiYHAGzCU/+0TgarJXBsLLymhFYyzhVI0dSHB8C1WBMMCb76NCJbKW9nc+E0X0I+pWgBt+jLcxARn+zZECYlt5FovGVnU8UHM/ojSk5Ltu1D1MjiisEf4ylwbB8IHeqBzTq6NN4IFVzODOVVKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ettCvrqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ettCvrqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799061F00899;
	Wed, 30 Sep 2026 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784071;
	bh=qIqkYYoeA/Xq+SdtGALyg9c8Q3tpAMjnWd2WlspTfcU=;
	h=From:To:Cc:Subject:Date;
	b=ettCvrqSx0DPcMRYGriteq3MJ3ef/hTTLg++GEupZQfWVRYKENAiIDGRzDAEJQcz0
	 PCwy8Twq2wENeFT2MCy19MbLu13V41HZPp4qSWojOm/3PLelMUP2XsyfM9dczfU5DN
	 CEFISNcYf96gLUX6gwDXO8aM0IM2BoUrNX2+P8jg=
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
Subject: [PATCH 6.1 000/982] 6.1.189-rc1 review
Date: Wed, 30 Sep 2026 17:12:16 +0200
Message-ID: <20260930152416.775402466@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.189-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.189-rc1
X-KernelTest-Deadline: 2026-10-02T15:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.189 release.
There are 982 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.189-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.189-rc1

Denis Arefev <arefev@swemel.ru>
    ALSA: hda: Fix missing pointer check in hda_component_manager_init function

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

Jakub Kicinski <kuba@kernel.org>
    net: tls: fix silent data drop under pipe back-pressure

Darrick J. Wong <djwong@kernel.org>
    xfs: fix blockgc group quota scanning when usrquota isn't enforced

Zihan Xi <zihanx@nebusec.ai>
    smb: client: validate POSIX create context length

Hui Peng <benquike@gmail.com>
    Bluetooth: RFCOMM: fix NULL dereference of dlc->session in RFCOMM_CONNINFO

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: L2CAP: validate frame length before control and FCS access

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: reject out-of-range OCF values

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    Bluetooth: hci_sock: validate event length before filtering

Myeonghun Pak <mhun512@gmail.com>
    RISC-V: KVM: Synchronize hrtimer callback during teardown

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

Wentao Liang <vulab@iscas.ac.cn>
    net: usb: lan78xx: Fix URB reference leak in lan78xx_submit_deferred_urbs()

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

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()

Wentao Liang <vulab@iscas.ac.cn>
    drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()

Christian König <ckoenig.leichtzumerken@gmail.com>
    drm/i915: fix incorrect RCU teardown order

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

Patrick Lu (Anthropic) <perf.patrick.lu@gmail.com>
    writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes

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

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Drop all SCM attributes for SOCKMAP.

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

Pablo Neira Ayuso <pablo@netfilter.org>
    rculist: add list_splice_rcu() for private lists

Mark Amirkan <markdamirkan@gmail.com>
    mptcp: return sk_wait_data() errors from recvmsg()

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Don't write PEBS_ENABLED on host<=>guest xfers if CPU has PEBS isolation, to fix stuck PEBS_ENABLED

Sean Christopherson <seanjc@google.com>
    perf/x86/intel: Ensure KVM guest PEBS path doesn't set unwanted PERF_GLOBAL_CTRL bits

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

Coia Prant <coiaprant@gmail.com>
    net: ethernet: stmmac: dwmac-rk: fix bulk clock leak when the PHY clock fails

Ginger Li <ginger.jzllee@gmail.com>
    tipc: Fix a data race on mon->peer_cnt in mon_timeout()

Sidraya Jayagond <sidraya@linux.ibm.com>
    net/smc: fix UAF on lgr list traversal in smcr_port_err()

Yilin Zhang <yilinzhang@moonshot.ai>
    tcp: fix use-after-free of retransmit_skb_hint in tcp_send_synack()

Norbert Szetei <norbert@doyensec.com>
    net: xps: reject an out of range traffic class

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    vxlan: use one headroom snapshot for neighbour replies

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    ip_gre: Reject enabling collect metadata through changelink

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: mask DMA_TIMEOUT_MASK when reading DMA_RING0_TIMEOUT

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: validate Ethernet address in bcmgenet_set_mac_addr

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: do not skip WoL power up on GENET V1

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: allow return of power up status

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: move bcmgenet_power_up into resume_noirq

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: initialize u64 stats seq counter for all queues

Florian Fainelli <florian.fainelli@broadcom.com>
    net: bcmgenet: fix 64-bit RTNL stats reading in ethtool on 32-bit systems

Ivan Delalande <colona@arista.com>
    tg3: use random MAC address when tg3_get_device_address fails

Dragan Simic <dsimic@manjaro.org>
    driver core: Add device probe log helper dev_warn_probe()

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    driver core: Make dev_err_probe() silent for -ENOMEM

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    driver core: Better advertise dev_err_probe()

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf: Fix BSWAP 32 and 16 on MIPS64

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    bpf: Fix immediate JMP JEQ/JNE on MIPS32

Ido Schimmel <idosch@nvidia.com>
    vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets

Shihuang Liu <shlomojune6@gmail.com>
    net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()

Jakub Kicinski <kuba@kernel.org>
    veth: manage XDP program pointers during channel resize

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_gate: budget the per-entry list in get_fill_size

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

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: nfcmrvl: validate helper command length before pull

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac4: Use the correct bufzise when the len is exactly 8K

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Capture all packets for vlan checks

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Check the dev->features for S-TAG offload testing

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Support running selftests on DSA conduits

Xin Long <lucien.xin@gmail.com>
    sctp: hold asoc or transport before mod_timer() in timer handlers

Bernardo Soares <bsoares.it@gmail.com>
    net/mlx5: Bridge, don't fail unlink of untracked/unsupported peer ports

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, pass net device when linking vport to bridge

Bernardo Soares <bsoares.it@gmail.com>
    net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, snoop igmp/mld packets

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, extract code to lookup parent bridge of port

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, move additional data structures to priv header

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Bridge, increase bridge tables sizes

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5: Add mlx5_ifc definitions for bridge multicast support

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

Dan Carpenter <error27@gmail.com>
    drm/nouveau/clk: fix list cursor use after loop in nvkm_clk_ustate_update

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: make ocfs2_calc_xattr_init() return void

Naman Gulati <namangulati@google.com>
    netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name

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

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    libbpf: Reject truncated ldimm64 CO-RE relocations

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Restrict CO-RE poisoning to relocatable instructions

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_u32: fix manual hash table handle IDR aliasing

Weiming Shi <bestswngs@gmail.com>
    bpf: Skip unsettled links in link iterator

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

Bart Van Assche <bvanassche@acm.org>
    scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()

Lee Jones <lee@kernel.org>
    Bluetooth: mgmt: Dequeue pending mesh_send_sync entries on cancel

Christiano Amora <christiano.amora@gmail.com>
    Bluetooth: SMP: reject Security Request over BR/EDR

Ran Hongyun <ranhongyun1@huawei.com>
    squashfs: Add dictionary size range check to prevent shift-out-of-bounds

Slawomir Stepien <sst@poczta.fm>
    HID: amd_sfh: Validate PCI BAR size before mapping

Sean Anderson <sanderson@brivo.com>
    pinctrl: meson: Fix typo in s4 group name

Geliang Tang <tanggeliang@kylinos.cn>
    bpf, sockmap: Fix self-redirect copied_seq double-counting

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

Xingui Yang <yangxingui@huawei.com>
    scsi: hisi_sas: Grab sas_dev lock when traversing the members of sas_dev.list

Boris Burkov <boris@bur.io>
    btrfs: insert tree mod log move in push_node_left

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: rtw88: delete timer and free skb queue when unloading

Duoming Zhou <duoming@zju.edu.cn>
    sh: push-switch: Reorder cleanup operations to avoid use-after-free bug

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5e: TC, Fix internal port memory leak

Hans de Goede <hdegoede@redhat.com>
    media: ipu-bridge: Fix null pointer deref on SSDB/PLD parsing warnings

ndesaulniers@google.com <ndesaulniers@google.com>
    start_kernel: Add __no_stack_protector function attribute

Vitaly Kuznetsov <vkuznets@redhat.com>
    HID: hyperv: streamline driver probe to avoid devres issues

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_sk_storage: Fix the missing uncharge in sk_omem_alloc

Jinjie Ruan <ruanjinjie@huawei.com>
    spi: zynqmp-gqspi: Use devm_spi_alloc_host()

Junli Liu <liujunli@lixiang.com>
    erofs: fix atomic context detection when !CONFIG_DEBUG_LOCK_ALLOC

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add layout1.refer_mount_root

Sandeep Dhavale <dhavale@google.com>
    erofs: Fix detection of atomic context

Bjorn Andersson <quic_bjorande@quicinc.com>
    drm/msm/dp: Drop aux devices together with DP controller

Martin KaFai Lau <martin.lau@kernel.org>
    bpf: bpf_sk_storage: Fix invalid wait context lockdep report

Itai Handler <itai.handler@gmail.com>
    spi: spi-zynqmp-gqspi: stop the controller on shutdown

Chen Xiaokun <shinnkka1@gmail.com>
    io_uring/io-wq: Fix memory leak in io_wq_create() on success path

Christoph Hellwig <hch@lst.de>
    btrfs: don't check PageError in __extent_writepage

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: always check if connection is alive before deleting

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix UAF in hci_disconnect_all_sync

Chengming Zhou <zhouchengming@bytedance.com>
    blk-mq: fix tags UAF when shrinking q->nr_hw_queues

Chengming Zhou <zhouchengming@bytedance.com>
    blk-mq: fix tags leak when shrink nr_hw_queues

Benoît Sevens <bsevens@google.com>
    HID: logitech-hidpp: fix race condition when accessing stale stack pointer

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc4-topology: Clarify bind failure caused by missing fw_module

Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
    ASoC: SOF: avoid a NULL dereference with unsupported widgets

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix missing lower-bound check on DFS referral string offsets

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix server->total_read for compound encrypted PDUs

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix potential OOB read in smb3_enum_snapshots()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix smbd_connection leak on cifs_get_tcp_session() error

Frank Sorenson <sorenson@redhat.com>
    smb: client: reject short Next offsets in parse_server_interfaces()

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
    watchdog: msc313e: Propagate error code in resume()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix premature reset during timeout update

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: digicolor: Avoid division by zero

Li Jun <lijun01@kylinos.cn>
    watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog

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

Alvin Šipraga <alvin.sipraga@analog.com>
    Input: adp5588-keys - cache GPIO state before registering the gpiochip

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

Fan Wu <fanwu01@zju.edu.cn>
    mmc: core: Cancel SDIO IRQ work before freeing host

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

Yifei Gao <gyf161023@gmail.com>
    memstick: ms_block: destroy io_queue workqueue on removal

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

Mark Amirkan <markdamirkan@gmail.com>
    net: lan743x: fix RX checksum use-after-free

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: xfrm: use full sockets in local error paths

Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
    dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix non-atomic read of DMA position registers

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Serialize local codec list cleanup

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_codec: validate vendor codec count length

Aamir Ahmed <elb12345@hotmail.co.uk>
    Bluetooth: eir: validate service data length before reading UUID

Nicolas Thibert <nithibert@gmail.com>
    Bluetooth: btusb: fix NXP IW610 composite device handling

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_and() mask generation

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_write() casting

Koichiro Den <den@valinux.co.jp>
    arm64: dts: renesas: r8a779f0: Set UFS lane count

Bradley Morgan <include@grrlz.net>
    arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc

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

Yuho Choi <oss.patchbox@gmail.com>
    ALSA: virtio: reset device before deleting virtqueues

Jeremy Nyberg <slickstretch3.0@gmail.com>
    Input: xpad - fix PDP Marvel Xbox 360 controller

Roberts Kursitis <roberts.kursitis@azeron.eu>
    Input: xpad - add support for Azeron devices

Erich Sartison <byt.es@mailbox.org>
    Input: xpad - add support for Victrix Pro BFG Controller

Andrea Righi <arighi@nvidia.com>
    sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    sched/fair: Move is_core_idle() out of CONFIG_NUMA

Tomer Tayar <ttayar@habana.ai>
    accel/habanalabs: postpone mem_mgr IDR destruction to hpriv_release()

Dmitriy Okunev <dokunevdmitriy@gmail.com>
    net: mvpp2: prevent buffer overflow in page_pool allocation

James Clark <jjc@jclark.com>
    net: macb: fix ordering around PTP timestamp read

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

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: mst: move switchdev call outside rcu

Karl Mehltretter <kmehltretter@gmail.com>
    wifi: brcmfmac: fix lost 802.1x TX completion wakeup

Hohyun Sim <tlaghgus0425@korea.ac.kr>
    net: fddi: skfp: fix NULL deref when setting the MAC address while down

Dong Chenchen <dongchenchen2@huawei.com>
    ipv4: icmp: reject RTN_UNREACHABLE input routes in icmp_route_lookup

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

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Rework definition of I/O read and write helpers

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Remove little-endianism from I/O helpers

Thomas Zimmermann <tzimmermann@suse.de>
    drm/atomic-helper: Add atomic_enable plane-helper callback

Zihan Xi <zihanx@nebusec.ai>
    wifi: virt_wifi: don't transfer operstate before register

Xiang Mei <xmei5@asu.edu>
    ALSA: 6fire: fix OOB write from device-reported iso length

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: 6fire: Avoid embedded URBs

Takashi Iwai <tiwai@suse.de>
    ALSA: 6fire: Clean ups with guard()

Karl Mehltretter <kmehltretter@gmail.com>
    Input: trackpoint - fix the inertia attribute name in the ABI document

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: pcm: set timer->private_data before registering the PCM timer

Takashi Iwai <tiwai@suse.de>
    ALSA: bcd2000: Fix race between rawmidi and disconnect

Karl Mehltretter <kmehltretter@gmail.com>
    keys: fix lost wakeup when reaping a dead key type

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr

Shouping Wang <allen.wang@hj-micro.com>
    perf/arm-cmn: Fix wp_dev_sel2 setting for multi-DTM configurations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: hold reference on ct until flow is released

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_nat: fully initialise new_addr in netmap setup

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    RDMA/siw: Bound fragmented header copies by the remaining length

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Keep EQ resources alive while IRQ is registered

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Keep admin queues alive while IRQ is registered

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order

Karl Mehltretter <kmehltretter@gmail.com>
    scsi: qla2xxx: Fix the ql2xfc2target parameter description

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: set up the TX info early to fix failure paths

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: rework ack_frame_id handling a bit

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: release the channel if start fails

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: add HE 6 GHz capability in the scan elems len

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't access the TSF of a down interface

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't RCU-dereference the mesh CSA settings we just set

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't allow link changes when iface is down

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: require a peer station for TDLS setup confirm

Mukesh Sisodiya <mukesh.sisodiya@intel.com>
    wifi: mac80211: handle TDLS negotiation with MLO

Mukesh Sisodiya <mukesh.sisodiya@intel.com>
    wifi: cfg80211: make TDLS management link-aware

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: trace: remove MAC_PR_{FMT,ARG}

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: unlist vifs when their netdev is unregistered

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

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/iser: reject a remote invalidation of an unregistered direction

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    RDMA/core: Reject unregistering netdevs in ib_get_eth_speed

Eric Dumazet <edumazet@google.com>
    net: convert dev->reg_state to u8

Jiri Pirko <jiri@nvidia.com>
    net: devlink: take RTNL in port_fill() function only if it is not held

Jiri Pirko <jiri@nvidia.com>
    net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()

Jiri Pirko <jiri@nvidia.com>
    net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()

Jiri Pirko <jiri@nvidia.com>
    net: devlink: convert devlink port type-specific pointers to union

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: insert mcg into mcg_tree only after rxe_mcast_add() succeeds

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

Maher Azzouzi <maherazz04@gmail.com>
    esp: downgrade zerocopy managed frags before mutating skb frags

Eric Dumazet <edumazet@google.com>
    xfrm: add missing rcu_read_lock(), skb_dst_force() and dev_hold() for xfrm_trans_reinject()

Kyle Zeng <kylebot@openai.com>
    xfrm: fix compat ALLOCSPI request use-after-free

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: avoid RCU warnings around the per-netns netlink socket

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

Jens Axboe <axboe@kernel.dk>
    sunvdc: fix -EIO issue due to lack of retries

Günther Noack <gnoack@google.com>
    selftests/landlock: Add tests for whiteout object creation

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg

Sasha Levin <sashal@kernel.org>
    Revert "alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally"

Sasha Levin <sashal@kernel.org>
    Revert "alpha: don't leak hardware-fabricated FP exception bits to user space"

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Add disconnected leafs and branch test suites

Tingmao Wang <m@maowtm.org>
    selftests/landlock: Add tests for access through disconnected paths

Mickaël Salaün <mic@digikod.net>
    landlock: Fix handling of disconnected directories

Paolo Abeni <pabeni@redhat.com>
    mptcp: close race between scheduler and state change

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid unneeded actions on subflow reset

Paolo Abeni <pabeni@redhat.com>
    mptcp: consolidate subflow cleanup

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

Gary Guo <gary@garyguo.net>
    net: usb: pegasus: don't rely on id table pointer arithmetic

Gary Guo <gary@garyguo.net>
    media: as102: do not rely on id table address comparison

Gary Guo <gary@garyguo.net>
    usb: usbtmc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    wifi: ath9k_htc: don't store usb_device_id

Gary Guo <gary@garyguo.net>
    usb: xusbatm: don't rely on id table pointer arithmetic

Sasha Levin <sashal@kernel.org>
    Revert "perf tests: Fix flakiness in BPF counters test on hybrid systems"

Sasha Levin <sashal@kernel.org>
    Revert "nvme: apple: Add Apple A11 support"

Sasha Levin <sashal@kernel.org>
    Revert "nvme-apple: Drop the PRP null check chicken bit"

Sasha Levin <sashal@kernel.org>
    Revert "nvme-apple: Prevent shared tags across queues on Apple A11"

Sasha Levin <sashal@kernel.org>
    Revert "nvme-apple: Reset q->sq_tail during queue init"

Eric Dumazet <edumazet@google.com>
    ipv6: mcast: extend RCU protection in igmp6_send()

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"

Sasha Levin <sashal@kernel.org>
    Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"

Suraj Jitindar Singh <surajjs@amazon.com>
    bpftool: remove duplicate free_btf_vmlinux() definition

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount when cifs_sb_tlink() fails

Bjoern Doebel <doebel@amazon.de>
    smb: client: avoid leaking refcount in cifs_queue_oplock_break()

Aohan Mei <henrymei@tencent.com>
    smb: client: reject userspace cifs.idmap descriptions

Gang Yan <yangang@kylinos.cn>
    selftests: mptcp: fix an UAF in mptcp_connect.c

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: syncookies: remember the request backup flag

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: subflow: no need to copy thmac during ulp_clone

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: handle MPC data + csum reqd + no csum

Joe Damato <joe@dama.to>
    bnxt_en: Propagate RX ring init failures in bnxt_init_nic()

Joe Damato <joe@dama.to>
    bnxt_en: Handle buffer allocation failure in bnxt_rx_ring_reset()

Joe Damato <joe@dama.to>
    bnxt_en: Only restore LRO if the device supports TPA

Michael Bommarito <michael.bommarito@gmail.com>
    media: v4l2-ctrls: validate HEVC tile counts

Haotian Zhang <vulab@iscas.ac.cn>
    media: v4l2-h264: Fix memcmp() size in B1 reference list comparison

Michael Bommarito <michael.bommarito@gmail.com>
    media: verisilicon: hantro: bound G2 HEVC tile loop to the buffer capacity

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

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ring-buffer: Acquire the lock with irqsave in rb_wake_up_waiters()

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
    tracing: Keep the entry count when the histogram stats allocation fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Let histogram values keep the percent and graph modifiers

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the field rejected for a bad modifier

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram var refs regardless of how often they are referenced

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Free histogram the var ref when its initialization fails

Thomas Gleixner <tglx@linutronix.de>
    tick/broadcast: Plug clockevents replacement race

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

Eric Dumazet <edumazet@google.com>
    ipv4: start using dst_dev_rcu()

Eric Dumazet <edumazet@google.com>
    net: dst: introduce dst->dev_rcu

Eric Dumazet <edumazet@google.com>
    ipv4: adopt dst_dev, skb_dst_dev and skb_dst_dev_net[_rcu]

Eric Dumazet <edumazet@google.com>
    net: dst: add four helpers to annotate data-races around dst->dev

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

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: fix wrong flag value in get_ipv6_ext_hdrs()

Greg Marsden <greg.marsden@oracle.com>
    net/rds: fix tcp stream corruption with large pages

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

Qingfang Deng <qingfang.deng@linux.dev>
    ppp_synctty: ensure a writeable skb header

Eric Dumazet <edumazet@google.com>
    vxlan: initialize _md in vxlan_xmit_one()

Guillaume Nault <gnault@redhat.com>
    vxlan: Pull inner IP header in vxlan_xmit_one().

Beniamino Galvani <b.galvani@gmail.com>
    vxlan: use generic function for tunnel IPv6 route lookup

Beniamino Galvani <b.galvani@gmail.com>
    ipv6: add new arguments to udp_tunnel6_dst_lookup()

Beniamino Galvani <b.galvani@gmail.com>
    ipv6: remove "proto" argument from udp_tunnel6_dst_lookup()

Beniamino Galvani <b.galvani@gmail.com>
    vxlan: use generic function for tunnel IPv4 route lookup

Pengpeng Hou <pengpeng@iscas.ac.cn>
    hwmon: (aspeed-pwm-tacho) Propagate reset deassert errors

Cong Nguyen <congnt264@gmail.com>
    hwmon: (gpio-fan) take fan_data->lock in gpio_fan_shutdown()

Marek Vasut <marex@nabladev.com>
    net: ks8851: Fix receiver error in 100BASE-TX mode following software power-down

Yicong Hui <yiconghui@gmail.com>
    net/micrel: Fix typos in micrel driver code comments

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Sync timeout value if WDT was running at boot

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix undefined behavior

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix spurious reset on suspend

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Enable clock before accessing hardware registers

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix clock leak and spurious timer in settimeout()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Avoid division by zero

David Arcari <darcari@redhat.com>
    watchdog: fix hrtimer start when pretimeout is zero

Nicolai Buchwitz <nb@tipi-net.de>
    net: macb: destroy the phylink instance on the probe error path

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: btusb: Fix UAF of btusb_data by rx_work

Jacob Keller <jacob.e.keller@intel.com>
    ice: add missing xa_destroy for sched_node_ids

HyeongJun An <sammiee5311@gmail.com>
    ALSA: hda: Report a change when only the channel status bytes move

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/common: Use guard() for mutex locks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/common: Use cleanup macros for PM controls

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Introduce auto cleanup macros for PM

Karl Mehltretter <kmehltretter@gmail.com>
    drm/logicvc: Drop the select of the nonexistent CONFIG_DRM_KMS_DMA_HELPER

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

Karl Mehltretter <kmehltretter@gmail.com>
    virtio_input: stop callbacks before unregistering input device

Xiong Weimin <xiongweimin@kylinos.cn>
    virtio_input: reset device if input_register_device() fails

Andrew Stellman <astellman@stellman-greene.com>
    virtio-pci: return IRQ_HANDLED after non-zero ISR

Linfeng Sun <linfeng.sun.dev@gmail.com>
    vdpa_sim_blk: reject out-of-range sector starts

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

Vineeth Karumanchi <vineeth.karumanchi@amd.com>
    net: macb: fix NULL pointer dereference on unbind with fixed-link

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: rename bp->sgmii_phy field to bp->phy

Allen Pais <apais@linux.microsoft.com>
    workqueue: Introduce from_work() helper for cleaner callback declarations

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

Weiming Shi <bestswngs@gmail.com>
    net/sched: defer qdisc freeing after failed creation

Thorsten Blum <thorsten.blum@linux.dev>
    powerpc/kexec_file: Use inclusive range checks in add_usable_mem()

Jamal Hadi Salim <jhs@mojatatu.com>
    net: cap tx_queue_len at S16_MAX to prevent oversized ring allocations

Seungwon Bae <qotmddnjs@ajou.ac.kr>
    vxlan: reject dynamic fdb entries that reference a nexthop id

Jason Winter <jjx@live.nl>
    net: usb: cx82310_eth: drop URB after 0xffff reboot sentinel to prevent partial_data heap overflow

Viswajith Murali <viswajithm@marvell.com>
    octeontx2-af: mcs: Clear stale X2P calibration state before calibration

Jakub Kicinski <kuba@kernel.org>
    net: dsa: mv88e6xxx: bound the policy rule dump by the caller's buffer size

Jakub Kicinski <kuba@kernel.org>
    net: dsa: bcm_sf2: bound the CFP rule dump by the caller's buffer size

Eric Dumazet <edumazet@google.com>
    bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()

Ido Schimmel <idosch@nvidia.com>
    nexthop: Initialize extack in remove_nh_grp_entry()

Jiayuan Chen <jiayuan.chen@linux.dev>
    selftests/bpf: Fix flaky bpf_nf test when random NAT port is 0

Brad Cowie <brad@faucet.nz>
    selftests/bpf: Update tests for new ct zone opts for nf_conntrack kfuncs

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Mark bpf_btf_find_by_name_kind() as sleepable

Yonghong Song <yhs@fb.com>
    bpf: Introduce might_sleep field in bpf_func_proto

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: avs: Clean up the bus when fetching ML caps fails

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA/ASoC: hda: ext: add 'ext' prefix to snd_hdac_link_free_all

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref in btf_var_show()

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix NULL-ptr-deref when showing a void BTF type

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potential double-free at error path

HyeongJun An <sammiee5311@gmail.com>
    selftests/alsa: Fix the step check for INTEGER controls

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
    mfd: db8500-prcmu: Fold dbx500 header into db8500

Kees Cook <kees@kernel.org>
    arm: Handle KCOV __init vs inline mismatches

Zijun Hu <quic_zijuhu@quicinc.com>
    mfd: db8500-prcmu: Remove needless return in three void APIs

YueHaibing <yuehaibing@huawei.com>
    mfd: db8500-prcmu: Remove unused inline functions

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

Eric Dumazet <edumazet@google.com>
    bonding: alb: fix uninitialized transport header access in alb_determine_nd()

Guanghui Yang <3497809730@qq.com>
    btrfs: restore active device pointers after failed sprout

Guanghui Yang <3497809730@qq.com>
    btrfs: detach failed sprout device from transaction update list

wangdicheng <wangdicheng@kylinos.cn>
    ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()

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

Eric Dumazet <edumazet@google.com>
    ip6_gre: check tunnel info before xmit in ip6gre_tunnel_xmit

Eric Dumazet <edumazet@google.com>
    ipv6: tunnels: use DEV_STATS_INC()

Qingfang Deng <qingfang.deng@linux.dev>
    ppp: ppp_async: simplify tty disc_data access

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: cls_u32: fix duplicate handle when node ID pool is exhausted

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Validate and program TDM slots correctly

Linus Walleij <linusw@kernel.org>
    ASoC: ab8500: Correct digital interface format setup

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

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    raw: annotate disconnect-side IPv4 match writers

Henry Martin <bsdhenrymartin@gmail.com>
    sctp: fix soft lockup from unpadded ASCONF-ACK parameter iteration

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    smb: client: transport: Fix debug printing in __release_mid()

Huiwen He <hehuiwen@kylinos.cn>
    smb/client: mark file sparse before emulating insert range

Milan P. Gandhi <mgandhi@redhat.com>
    scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()

Milan P. Gandhi <mgandhi@redhat.com>
    scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()

Xin Long <lucien.xin@gmail.com>
    sctp: fix a TOCTOU race in SCTP_CMD_TIMER_START

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: fix skb sizing and action leak on reoffload delete

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_api: conditional notification of events

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: act_api: don't open code max()

Pedro Tammela <pctammela@mojatatu.com>
    rtnl: add helper to send if skb is not null

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: size the RTM_GETACTION reply from the actions

Victor Nogueira <victor@mojatatu.com>
    net/sched: act_api: budget all shared attributes in notify skbs

Eric Dumazet <edumazet@google.com>
    net: icmp: avoid invalid transport header access in icmp_send tracepoint

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

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    ARM: ensure interrupts are enabled in __do_user_fault()

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9484/1: enable interrupts when unhandled user faults are triggered

Sasha Levin <sashal@kernel.org>
    Revert "Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU"

Sasha Levin <sashal@kernel.org>
    Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"

SJ Park <sj@kernel.org>
    mm/damon/core: avoid infinite kdamond_merge_regions() internal loop

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Unlink scc_entry in unix_del_edge().

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use memcmp() to compare ClientGUIDs

HyeongJun An <sammiee5311@gmail.com>
    ASoC: meson: aiu: Validate written enum values

Kuniyuki Iwashima <kuniyu@google.com>
    ipv4: fib: Don't dump dying fib_info in fib_leaf_notify().

Xin Long <lucien.xin@gmail.com>
    sctp: fix err_chunk memory leaks in INIT handling

Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
    bpf: Mask pseudo pointer values in verifier logs

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: fix malformed ISO_END/CONT handling

Pauli Virtanen <pav@iki.fi>
    Bluetooth: mgmt: hold reference for hci_conn in mgmt_pending_cmds

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    tipc: fix integer overflow in tipc_recvmsg() and tipc_recvstream()

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    net: drop_monitor: fix info leak in NET_DM_ATTR_PAYLOAD

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix size calculations for 64-bit attributes

Eric Dumazet <edumazet@google.com>
    drop_monitor: perform u64_stats updates under IRQ-disabled section

Zhiling Zou <roxy520tt@gmail.com>
    sctp: close UDP tunnel sockets during netns teardown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate ACE size against SID sub-authorities

Vlatko Kosturjak <kost@linux.hr>
    ppp_async: drop the errored frame instead of resetting its headroom

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: skip unknown CLC firmware records

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: at91: pmc: #undef field_{get,prep}() before definition

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tracing/histograms: Simplify last_cmd_set()

Gil Portnoy <dddhkts1@gmail.com>
    ksmbd: remove stale channels from all sessions on teardown

Genevieve Chan <genevieve.chan@altera.com>
    firmware: stratix10-svc: fix FCS SMC call kernel-doc

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_log: wait for rcu grace period before freeing pernet state

Zizhi Wo <wozizhi@huawei.com>
    scsi: core: Do not block on tag allocation in scsi_eh_lock_door()

Rudi Heitbaum <rudi@heitbaum.com>
    ASoC: rt5645: Perform the initial jack detect at probe

Jisheng Zhang <jszhang@kernel.org>
    spi: dw: fix wrong RX_SAMPLE_DLY setting after resume

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

Markus Lindner <lindner.markus@outlook.at>
    ALSA: usb-audio: Add dB map quirk for Razer Barracuda X 2.4

Minhong He <heminhong@kylinos.cn>
    phonet: check register_netdevice_notifier() error in phonet_device_init()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    drm/gma500: return errors from Oaktrail HDMI I2C reads

Ibrahim Hashimov <security@auditcode.ai>
    wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: core: clamp voltage constraints before applying apply_uV

Jay Vadayath <jay@artiphishell.com>
    smb: client: bound dirent name against end of SMB response in cifs_filldir

Georgi Valkov <gvalkov@gmail.com>
    wifi: mwifiex: replace one-element arrays with flexible array members

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: acpi: validate WGDS table revision index

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

Marcel Kłos <marcel@marmak.net.pl>
    ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix sched scan IE sizing

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix an off-by-1 boundary check

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reloc root cleanup in merge_reloc_roots()

Wang YuWei <1973615295@qq.com>
    spi: dw-dma: Wait for controller idle before completing Tx

Filipe Manana <fdmanana@suse.com>
    btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()

Dave Chen <davechen@synology.com>
    btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()

Chen Bowen <hicbowen@gmail.com>
    ALSA: hda/realtek: Fix speakers on MECHREVO WUJIE Series

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

Zhao Li <enderaoelyther@gmail.com>
    wifi: cfg80211: validate assoc response length before status and IE access

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

Jetha Chan <jethachan@gmail.com>
    ASoC: amd: yc: Add Alienware m15 R7 AMD to DMIC quirk table

David Howells <dhowells@redhat.com>
    cachefiles: Fix double fput

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix outstanding credit leak on abort and error paths

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

Praveen Talari <praveen.talari@oss.qualcomm.com>
    spi: core: Abort active target transfer on controller suspend

Haoxiang Li <haoxiang_li2024@163.com>
    fbdev: pm2fb: unwind WC setup on probe failure

Arnd Bergmann <arnd@arndb.de>
    eth: mlx5: fix macsec dependency

Adriana Stancu <adriana@arista.com>
    rtc: bq32000: add delay between RTC reads

Yu Kuai <yukuai@fygo.io>
    blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    net: au1000: move free_irq out of the close-time spinlocked section

Pengpeng Hou <pengpeng@iscas.ac.cn>
    regulator: da9121: Use subvariant ids in the I2C table

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Use kstrtobool() to parse the ROM attribute input

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Fix race between pci_proc_init() and pci_bus_add_device()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: break RH leases before delete-on-close

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: start file id allocation at 1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: apply create security descriptor first

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: treat unnamed DATA stream as base file

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use connection ClientGUID for lease lookup

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: align SMB2 oplock break ack handling

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

Jakub Kicinski <kuba@kernel.org>
    tls: reject the combination of TLS and sockmap

Ai Chao <aichao@kylinos.cn>
    ALSA: usb-audio: Add quirk flags for SC13A

guoqi0226 <guoqi0226@163.com>
    spi: Add NULL check for spi_get_device_id() in spi_get_device_match_data()

Rob Herring (Arm) <robh@kernel.org>
    gpio: pisosr: Read "ngpios" as u32

Arnd Bergmann <arnd@arndb.de>
    scsi: bfa: Reduce kernel stack usage in bfa_fcs_lport_fdmi_build_portattr_block()

Zhang Tianci <zhangtianci.1997@bytedance.com>
    fuse: set ff->flock only on success

Jiri Kosina <jkosina@suse.com>
    HID: hidpp: fix potential UAF in hidpp_connect_event()

Viktor Menshin <ripeeerr@gmail.com>
    ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT

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

Cris <cxs1494089474@gmail.com>
    Bluetooth: btusb: Add support for TP-Link TL-UB250

Hrvoje Nuic <hrvoje.nuic@gmail.com>
    Bluetooth: btusb: Add Mercusys MA530 for Realtek RTL8761BUV

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    spi: xilinx: let transfers timeout in case of no IRQ

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

Furst Blumier <seal@furst.blue>
    ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC

Evgenii Burenchev <evg28bur@yandex.ru>
    vdpa/ifcvf: handle dev_set_name() failure in ifcvf_vdpa_dev_add()

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

Dai Ngo <dai.ngo@oracle.com>
    NFS: fix eof updates after NFSv4.2 fallocate/zero-range

Zhang Cen <rollkingzzc@gmail.com>
    btrfs: tree-checker: validate names in ROOT_REF and ROOT_BACKREF

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

Cyrill Gorcunov <gorcunov@gmail.com>
    RDMA/irdma: Fix typo in SQ completions generation

Asad Kamal <asad.kamal@amd.com>
    drm/amd/pm: bound pp_dpm_set_pp_table() memcpy

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

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: wwan: t7xx: Add delay between MD and SAP suspend

Wentao Liang <vulab@iscas.ac.cn>
    net: qrtr: fix node refcount leak on ctrl packet alloc failure

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear _DEP dependencies after PCI root bridge attach

liyouhong <liyouhong@kylinos.cn>
    ata: ahci: fail probe if BAR too small for claimed ports

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: codecs: pcm3168a: Drop CONFIG_PM-conditional preproc directive

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: return error code to consumers on failures

Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
    wifi: ath11k: fix invalid data access in ath11k_dp_rx_h_undecap_nwifi

Rosen Penev <rosenp@gmail.com>
    net: ibm: emac: Reserve VLAN header in MJS limit

Daniel Borkmann <daniel@iogearbox.net>
    libbpf: Also reset {insn,data}_cur on realloc failure

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: accel: mma8452: switch to non-devm request_threaded_irq()

Rik van Riel <riel@surriel.com>
    perf/ftrace: Fix WARNING in __unregister_ftrace_function

Miao Li <limiao@kylinos.cn>
    iio: light: stk3310: Deal with the ps interrupt issue in PM

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC

Karl Mehltretter <kmehltretter@gmail.com>
    tracing: Disable KCOV instrumentation for trace_irqsoff.o

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC

Osama Abdelkader <osama.abdelkader@gmail.com>
    mmc: davinci: fix mmc_add_host order in probe

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: only handle alert events when the peripheral is attached

Charles Keepax <ckeepax@opensource.cirrus.com>
    soundwire: dmi-quirks: Disable ghost Realtek devices

Tiezhu Yang <yangtiezhu@loongson.cn>
    libbpf: Add __NR_bpf definition for LoongArch

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: catpt: Complete coredump handling

Alexandre Courbot <acourbot@nvidia.com>
    scripts: modpost: detect and report truncated buf_printf() output

shayderrr <darknessshayder@gmail.com>
    host1x: bus: Fix missing ops null check in error teardown

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    pinctrl: renesas: rzv2m: Use -ENOTSUPP instead of -EOPNOTSUPP

Viacheslav Dubeyko <slava@dubeyko.com>
    hfs: rework hfsplus_readdir() logic

ikaros <void0red@gmail.com>
    ACPICA: add boundary checks in two places

ikaros <void0red@gmail.com>
    ACPICA: Enhance buffer validation in acpi_ut_walk_aml_resources()

Weiming Shi <bestswngs@gmail.com>
    ACPICA: Fix NULL pointer dereference in acpi_ns_custom_package()

ikaros <void0red@gmail.com>
    ACPICA: Enhance OEM ID and Table ID validation in acpi_ex_load_table_op()

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

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    net: thunderx: fix PTP device ref leak in nicvf_probe()

Fernando Fernandez Mancera <fmancera@suse.de>
    ipv6: addrconf: fix temp address generation after prefix deprecation

Luka Gejak <luka.gejak@linux.dev>
    net: hsr: require valid EOT supervision TLV

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

Dian-Syuan Yang <dian_syuan0116@realtek.com>
    wifi: rtw89: pci: enable LTR based on pcie control register

Venkat Rao Bagalkote <venkat88@linux.ibm.com>
    char/nvram: Remove redundant nvram_mutex

Christian Marangi <ansuelsmth@gmail.com>
    usb: host: add ARCH_AIROHA in XHCI MTK dependency

Marco Felsch <m.felsch@pengutronix.de>
    serial: 8250: fix possible ISR soft lockup

Maoyi Xie <maoyixie.tju@gmail.com>
    usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue

Dave Carey <carvsdriver@gmail.com>
    USB: cdc-acm: start bulk-IN polling when ALWAYS_POLL_CTRL is set

Stepan Ionichev <sozdayvek@gmail.com>
    usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log

Oliver Neukum <oneukum@suse.com>
    usb: core: hcd: fix possible deadlock in rh control transfers

Adrian Wowk <dev@adrianwowk.com>
    usbip: vhci_hcd: fix NULL deref in status_show_vhci

Nikhil Chatterjee <nikhilc1527@gmail.com>
    HID: bpf: Add Huion Inspiroy Frego M button quirk

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

Maurizio Lombardi <mlombard@redhat.com>
    nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl

Yury Norov <ynorov@nvidia.com>
    bitfield: wire __bf_shf to __builtin_ctzll

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't call ieee80211_handle_reconfig_failure when not needed

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate BASE_ERROR_EVENT payload size

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Validate SENSOR_UPDATE payload size

Pierre Barre <pierre@barre.sh>
    9p: use kvzalloc for readdir buffer

Leonardo Bras <leo.bras@arm.com>
    arm64/daifflags: Make local_daif_*() helpers __always_inline

Pierre Barre <pierre@barre.sh>
    9p: invalidate readdir buffer on seek

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usx2y: Drain pending US-428 pipe-4 output commands

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds on allocate_doorbell

David Francis <David.Francis@amd.com>
    drm/amdkfd: Check bounds for allocate_sdma_queue restore_sdma_id

Bjorn Helgaas <helgaas@kernel.org>
    PCI: Wait for device readiness after D3hot -> D0uninitialized transition

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

Alexey Klimov <alexey.klimov@linaro.org>
    clk: samsung: exynos850: mark APM I3C clocks as critical

Stefan Berger <stefanb@linux.ibm.com>
    integrity: Check for NULL returned by asymmetric_key_public_key

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: add support for RTL8367SB

Arash Golgol <arash.golgol@gmail.com>
    media: video-i2c: use vb2_video_unregister_device on driver removal

Sophie D <patches@scd31.com>
    drm/gud: Add RCade Display Adapter VID/PID pair

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: rework hfsplus_readdir() logic

Florian Eckert <fe@dev.tdt.de>
    PCI: intel-gw: Enable clock before PHY init

Tom Chung <chiahsuan.chung@amd.com>
    drm/amd/display: Fix CRC open failure during active rendering

Stepan Ionichev <sozdayvek@gmail.com>
    mmc: davinci: avoid NULL deref of host->data in IRQ handler

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: core: Add validation for host-provided max_segs

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ASoC: ti: omap3pandora: update board check to use DT compatible

Parth Pancholi <parth.pancholi@toradex.com>
    drm/bridge: tc358768: Set pre_enable_prev_first for reverse order

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

Ben Reed <Ben.Reed@microchip.com>
    PCI: switchtec: Add Gen6 Device IDs

Marek Behún <kabel@kernel.org>
    net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family

Zhaoyang Yu <2426767509@qq.com>
    media: dm1105: fix missing error check for dma_alloc_coherent

Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
    thunderbolt: Don't create multiple DMA tunnels on firmware connection manager

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Set tb->root_switch to NULL when domain is stopped

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep the domain reference while processing hotplug

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Keep XDomain reference during the lifetime of a service

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

Siew Chin Lim <elly.siew.chin.lim@intel.com>
    firmware: stratix10-svc: change get provision data to async SMC call

Marco Elver <elver@google.com>
    kcsan: Silence -Wmaybe-uninitialized when calling __kcsan_check_access()

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
    wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: always allow transmitting null-data on TXQs

Johannes Berg <johannes.berg@intel.com>
    wifi: nl80211: reject beacons with bad HE operation

Viacheslav Dubeyko <slava@dubeyko.com>
    hfsplus: fix issue of direct writes beyond end-of-file

Lukas Wunner <lukas@wunner.de>
    PCI: Stop setting cached power state to 'unknown' on unbind

Hirokazu Honda <hiroh@chromium.org>
    tee: optee: Allow MT_NORMAL_TAGGED shared memory

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: udc: skip pullup() if already connected

Goldwyn Rodrigues <rgoldwyn@suse.de>
    ima: return error early if file xattr cannot be changed

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Propagate write errors in generic mixer put callbacks

Ioana Ciornei <ioana.ciornei@nxp.com>
    bus: fsl-mc: wait for the MC firmware to complete its boot

Boris Brezillon <boris.brezillon@collabora.com>
    drm/gem: Consider GEM object reclaimable if shrinking fails


-------------

Diffstat:

 .../ABI/testing/sysfs-devices-platform-trackpoint  |    2 +-
 Documentation/networking/ip-sysctl.rst             |    2 +
 Documentation/s390/pci.rst                         |  144 +-
 Documentation/s390/vfio-ccw.rst                    |    2 +-
 Makefile                                           |    4 +-
 arch/alpha/include/uapi/asm/fpu.h                  |    8 +-
 arch/alpha/kernel/traps.c                          |    6 +-
 arch/alpha/math-emu/math.c                         |   88 +-
 arch/arm/mach-socfpga/Kconfig                      |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |    6 +-
 arch/arm/mm/cache-feroceon-l2.c                    |    2 +-
 arch/arm/mm/cache-tauros2.c                        |    2 +-
 arch/arm/mm/fault.c                                |   12 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   64 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   12 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |    8 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |    8 +-
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |    1 +
 arch/arm64/include/asm/daifflags.h                 |   10 +-
 arch/arm64/include/asm/fixmap.h                    |    6 +-
 arch/arm64/include/asm/kprobes.h                   |    6 +
 arch/arm64/include/asm/percpu.h                    |   16 +-
 arch/arm64/kernel/hibernate-asm.S                  |    2 +
 arch/arm64/kernel/probes/kprobes.c                 |   23 +-
 arch/mips/cavium-octeon/octeon-platform.c          |    4 +-
 arch/mips/kernel/cps-vec.S                         |    6 +
 arch/mips/net/bpf_jit_comp32.c                     |    2 +-
 arch/mips/net/bpf_jit_comp64.c                     |    3 +-
 arch/powerpc/kernel/eeh_driver.c                   |    2 -
 arch/powerpc/kernel/iommu.c                        |    2 +-
 arch/powerpc/kernel/smp.c                          |    1 +
 arch/powerpc/kexec/file_load_64.c                  |    2 +-
 arch/powerpc/kvm/book3s_hv.c                       |    4 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |    2 +
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |    5 +-
 arch/powerpc/platforms/pseries/kexec.c             |   13 +-
 arch/riscv/kvm/vcpu_timer.c                        |    5 +-
 arch/s390/crypto/aes_s390.c                        |   16 +-
 arch/s390/include/asm/debug.h                      |    8 +-
 arch/s390/kernel/debug.c                           |   15 +-
 arch/s390/kvm/interrupt.c                          |   72 +-
 arch/sh/drivers/push-switch.c                      |    2 +-
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/kernel/uprobes.c                        |    1 +
 arch/x86/events/intel/core.c                       |   55 +-
 arch/x86/pci/fixup.c                               |   99 ++
 block/blk-cgroup.c                                 |   13 +-
 block/blk-mq.c                                     |    8 +-
 crypto/Makefile                                    |    5 +
 drivers/acpi/acpica/dsmethod.c                     |   43 +
 drivers/acpi/acpica/evhandler.c                    |   11 +
 drivers/acpi/acpica/exconfig.c                     |   26 +-
 drivers/acpi/acpica/exoparg3.c                     |    2 +-
 drivers/acpi/acpica/nsnames.c                      |    6 +
 drivers/acpi/acpica/nsprepkg.c                     |    7 +
 drivers/acpi/acpica/nsxfname.c                     |    4 +
 drivers/acpi/acpica/psargs.c                       |  134 +-
 drivers/acpi/acpica/psloop.c                       |   30 +-
 drivers/acpi/acpica/psparse.c                      |   14 +
 drivers/acpi/acpica/utcopy.c                       |   10 +-
 drivers/acpi/acpica/utresrc.c                      |   30 +
 drivers/acpi/pci_root.c                            |    4 +
 drivers/ata/ahci.c                                 |   22 +
 drivers/ata/libahci.c                              |   15 +-
 drivers/ata/libata-pmp.c                           |    7 +-
 drivers/base/core.c                                |  119 +-
 drivers/block/sunvdc.c                             |   26 +-
 drivers/bluetooth/btmtksdio.c                      |    4 +-
 drivers/bluetooth/btusb.c                          |   41 +-
 drivers/bluetooth/hci_mrvl.c                       |    3 +-
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   46 +
 drivers/char/ipmi/ipmi_si_platform.c               |    5 +-
 drivers/char/nvram.c                               |   16 +-
 drivers/char/virtio_console.c                      |   22 +-
 drivers/clk/at91/pmc.h                             |    2 +
 drivers/clk/clk-scpi.c                             |    2 +-
 drivers/clk/keystone/sci-clk.c                     |    8 +
 drivers/clk/renesas/renesas-cpg-mssr.c             |    3 +
 drivers/clk/samsung/clk-exynos850.c                |    5 +-
 drivers/clk/socfpga/clk-agilex.c                   |    2 +
 drivers/clk/ux500/clk-prcmu.c                      |   20 +-
 drivers/clk/ux500/u8500_of_clk.c                   |    2 +-
 drivers/clocksource/timer-orion.c                  |    2 +-
 drivers/cpufreq/cpufreq.c                          |    6 +-
 drivers/cpuidle/cpuidle-ux500.c                    |    6 +-
 drivers/crypto/allwinner/Kconfig                   |   16 -
 drivers/crypto/allwinner/sun8i-ce/Makefile         |    1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   55 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  |  160 --
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |   29 -
 drivers/crypto/allwinner/sun8i-ss/Makefile         |    1 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |   39 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  |  170 --
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |   23 -
 drivers/crypto/atmel-ecc.c                         |    3 +
 drivers/crypto/ixp4xx_crypto.c                     |   25 +-
 drivers/dma/dmaengine.c                            |   10 +-
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   11 +-
 drivers/dma/mmp_pdma.c                             |    2 +-
 drivers/dma/sprd-dma.c                             |    3 +-
 drivers/dma/sun6i-dma.c                            |    9 +-
 drivers/dma/ti/k3-udma-glue.c                      |    5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |   26 +-
 drivers/edac/edac_device_sysfs.c                   |   11 +-
 drivers/edac/igen6_edac.c                          |   27 +-
 drivers/firmware/arm_scmi/base.c                   |   15 +-
 drivers/firmware/arm_scmi/sensors.c                |   10 +-
 drivers/firmware/arm_scpi.c                        |    4 +-
 drivers/firmware/stratix10-svc.c                   |    4 +-
 drivers/gpio/gpio-arizona.c                        |    8 +-
 drivers/gpio/gpio-dwapb.c                          |   17 +
 drivers/gpio/gpio-pisosr.c                         |    4 +-
 drivers/gpio/gpio-zynq.c                           |   10 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |    4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |    1 +
 drivers/gpu/drm/amd/amdgpu/atom.c                  |    9 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |    9 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |    1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c  |    7 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |   20 +-
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |   31 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |    3 +
 drivers/gpu/drm/arm/display/komeda/komeda_dev.c    |    6 +-
 drivers/gpu/drm/arm/display/komeda/komeda_drv.c    |   14 +-
 drivers/gpu/drm/arm/malidp_drv.c                   |   22 +-
 drivers/gpu/drm/ast/ast_drv.h                      |   52 +-
 drivers/gpu/drm/bridge/tc358768.c                  |    2 +
 drivers/gpu/drm/drm_atomic_helper.c                |   20 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   13 +-
 drivers/gpu/drm/drm_gem.c                          |   10 +
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c         |   21 +-
 drivers/gpu/drm/gud/gud_drv.c                      |    1 +
 drivers/gpu/drm/gud/gud_pipe.c                     |    4 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |    2 +-
 drivers/gpu/drm/i915/i915_query.c                  |    4 +-
 drivers/gpu/drm/logicvc/Kconfig                    |    1 -
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |    2 +
 drivers/gpu/drm/msm/dp/dp_display.c                |   14 +-
 drivers/gpu/drm/msm/dsi/dsi.h                      |    1 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   38 +-
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c              |    4 +
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |    8 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |    3 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    5 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |    2 +
 drivers/gpu/drm/nouveau/nvif/vmm.c                 |    1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |   23 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c   |    2 +
 drivers/gpu/drm/panel/panel-simple.c               |   28 +
 drivers/gpu/drm/virtio/virtgpu_display.c           |    2 +-
 drivers/gpu/drm/virtio/virtgpu_gem.c               |    2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |    6 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c              |   17 +-
 drivers/gpu/host1x/bus.c                           |    4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_common.h           |    4 +
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c             |   10 +
 .../hid/bpf/progs/Huion__Inspiroy-Frego-M.bpf.c    |   87 +
 drivers/hid/hid-alps.c                             |    6 +-
 drivers/hid/hid-hyperv.c                           |   58 +-
 drivers/hid/hid-ids.h                              |    3 +
 drivers/hid/hid-logitech-hidpp.c                   |   11 +-
 drivers/hid/hid-quirks.c                           |    3 +-
 drivers/hid/wacom_sys.c                            |    5 +-
 drivers/hwmon/adt7462.c                            |    8 +
 drivers/hwmon/applesmc.c                           |    7 +-
 drivers/hwmon/aspeed-pwm-tacho.c                   |    4 +-
 drivers/hwmon/gpio-fan.c                           |   13 +-
 drivers/hwmon/pmbus/lm25066.c                      |   60 +-
 drivers/hwmon/pmbus/pmbus.h                        |    3 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |    4 +-
 drivers/hwmon/pmbus/tps53679.c                     |   11 +-
 drivers/hwmon/w83791d.c                            |    1 +
 drivers/hwmon/w83793.c                             |    4 +-
 drivers/i2c/busses/i2c-at91-core.c                 |    3 +
 drivers/i2c/busses/i2c-at91-master.c               |   12 +-
 drivers/i2c/busses/i2c-at91.h                      |    1 +
 drivers/i2c/busses/i2c-imx.c                       |    2 +
 drivers/i2c/i2c-core-smbus.c                       |   12 +
 drivers/i3c/master/mipi-i3c-hci/cmd_v1.c           |    4 +-
 drivers/i3c/master/mipi-i3c-hci/cmd_v2.c           |    4 +-
 drivers/iio/accel/mma8452.c                        |   19 +-
 drivers/iio/adc/qcom-spmi-iadc.c                   |   18 +-
 drivers/iio/light/stk3310.c                        |   76 +-
 drivers/infiniband/core/iwpm_util.c                |    9 +-
 drivers/infiniband/core/mad.c                      |    3 +-
 drivers/infiniband/core/ucma.c                     |    7 +-
 drivers/infiniband/core/umem.c                     |   18 +-
 drivers/infiniband/core/verbs.c                    |   12 +-
 drivers/infiniband/hw/efa/efa_com.c                |    7 +-
 drivers/infiniband/hw/efa/efa_com.h                |    1 +
 drivers/infiniband/hw/efa/efa_main.c               |   35 +-
 drivers/infiniband/hw/irdma/utils.c                |    2 +-
 drivers/infiniband/hw/irdma/verbs.c                |    2 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |    4 +
 drivers/infiniband/hw/mlx5/cq.c                    |    3 +-
 drivers/infiniband/hw/mlx5/main.c                  |   11 +
 drivers/infiniband/sw/rxe/rxe_mcast.c              |   50 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   75 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |    7 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   12 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   16 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |   16 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |   22 +
 drivers/infiniband/ulp/isert/ib_isert.h            |    2 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |    8 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.h             |    2 +
 drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   12 +-
 drivers/input/evdev.c                              |    2 +
 drivers/input/input-compat.c                       |    2 +
 drivers/input/joystick/xpad.c                      |   10 +-
 drivers/input/keyboard/adp5588-keys.c              |   12 +-
 drivers/input/keyboard/atkbd.c                     |    8 +
 drivers/input/misc/soc_button_array.c              |   16 +-
 drivers/input/mouse/synaptics.c                    |    8 +
 drivers/input/rmi4/rmi_driver.c                    |   13 +
 drivers/input/rmi4/rmi_smbus.c                     |   10 +-
 drivers/input/serio/i8042-acpipnpio.h              |    7 +
 drivers/iommu/rockchip-iommu.c                     |    8 +
 drivers/irqchip/irq-gic-v3-its.c                   |    1 +
 drivers/leds/leds-pca9532.c                        |    8 +-
 drivers/leds/uleds.c                               |   11 +-
 drivers/mailbox/mailbox.c                          |    6 +-
 drivers/md/raid5.c                                 |   35 +-
 drivers/media/i2c/video-i2c.c                      |    7 +-
 drivers/media/pci/dm1105/dm1105.c                  |    7 +-
 drivers/media/pci/intel/ipu3/cio2-bridge.c         |    5 +
 .../platform/verisilicon/hantro_g2_hevc_dec.c      |    6 +-
 drivers/media/rc/imon.c                            |    4 +
 drivers/media/rc/mceusb.c                          |    2 +
 drivers/media/usb/as102/as102_usb_drv.c            |   75 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    4 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |   12 +
 drivers/media/v4l2-core/v4l2-h264.c                |    3 +-
 drivers/memstick/core/ms_block.c                   |    2 +
 drivers/mfd/ab8500-core.c                          |    2 +-
 drivers/mfd/db8500-prcmu.c                         |    6 +-
 drivers/mfd/rsmu_i2c.c                             |    2 +
 drivers/mfd/rsmu_spi.c                             |    2 +
 drivers/misc/habanalabs/common/device.c            |    9 +
 drivers/misc/habanalabs/common/habanalabs.h        |    1 +
 drivers/misc/habanalabs/common/habanalabs_drv.c    |    1 +
 drivers/misc/habanalabs/common/memory_mgr.c        |   13 +-
 drivers/mmc/core/bus.c                             |    2 +-
 drivers/mmc/core/host.c                            |    1 +
 drivers/mmc/core/queue.c                           |    8 +-
 drivers/mmc/core/sdio_uart.c                       |    3 +
 drivers/mmc/host/davinci_mmc.c                     |   16 +-
 drivers/mmc/host/mmc_spi.c                         |    1 +
 drivers/mmc/host/mxcmmc.c                          |    4 +
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |    2 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |    5 +
 drivers/mmc/host/sdhci-of-aspeed.c                 |    5 +-
 drivers/mmc/host/sdhci_am654.c                     |    4 +-
 drivers/mmc/host/sh_mmcif.c                        |    3 +-
 drivers/net/bareudp.c                              |   11 +-
 drivers/net/bonding/bond_alb.c                     |   32 +-
 drivers/net/bonding/bond_main.c                    |    4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |    2 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   23 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |   14 +
 drivers/net/dsa/sja1105/sja1105_flower.c           |    4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    2 +
 drivers/net/ethernet/amd/au1000_eth.c              |    3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |    3 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    3 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    3 +
 drivers/net/ethernet/atheros/atlx/atl1.c           |    3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   19 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   63 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |    5 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   20 +-
 drivers/net/ethernet/broadcom/tg3.c                |   15 +-
 drivers/net/ethernet/cadence/macb.h                |    2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   39 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |    9 +
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |    8 +-
 drivers/net/ethernet/cortina/gemini.c              |   79 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   69 +-
 drivers/net/ethernet/freescale/fman/fman.c         |    1 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    3 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |    4 +-
 drivers/net/ethernet/ibm/emac/core.c               |    3 +-
 drivers/net/ethernet/ibm/emac/mal.c                |    6 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |   19 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |    9 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |    4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   20 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |    2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |   10 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   15 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   58 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |    7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   11 +
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  213 +--
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   21 +-
 .../ethernet/mellanox/mlx5/core/esw/bridge_mcast.c |  316 ++++
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |  104 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    8 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |    7 +-
 drivers/net/ethernet/micrel/ks8842.c               |    4 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |   10 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |    4 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |    2 +-
 drivers/net/ethernet/socionext/netsec.c            |    2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |    4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |    2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    9 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    1 -
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  106 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |    4 +-
 drivers/net/ethernet/ti/netcp_core.c               |    2 +-
 drivers/net/fddi/skfp/skfddi.c                     |    3 +-
 drivers/net/ppp/ppp_async.c                        |   89 +-
 drivers/net/ppp/ppp_synctty.c                      |   14 +-
 drivers/net/usb/catc.c                             |   15 +-
 drivers/net/usb/cdc_mbim.c                         |    5 +
 drivers/net/usb/cx82310_eth.c                      |    1 +
 drivers/net/usb/hso.c                              |    2 +-
 drivers/net/usb/lan78xx.c                          |    9 +-
 drivers/net/usb/pegasus.c                          |   54 +-
 drivers/net/usb/pegasus.h                          |    3 -
 drivers/net/usb/qmi_wwan.c                         |    2 +
 drivers/net/usb/sr9700.c                           |    3 +-
 drivers/net/veth.c                                 |    2 +
 drivers/net/vrf.c                                  |    2 -
 drivers/net/vxlan/vxlan_core.c                     |  266 +--
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   50 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   12 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    2 +
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |    4 +
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   10 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    5 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    4 +-
 drivers/net/wireless/intersil/p54/eeprom.c         |   22 +-
 drivers/net/wireless/mac80211_hwsim.c              |   45 +-
 drivers/net/wireless/marvell/libertas/tx.c         |    7 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    8 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   18 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |    8 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |   54 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |    2 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   33 +-
 drivers/net/wireless/mediatek/mt76/pci.c           |    8 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   14 +
 drivers/net/wireless/microchip/wilc1000/wlan.c     |    9 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |    2 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    3 +
 drivers/net/wireless/realtek/rtw88/main.c          |    4 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   16 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    8 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    8 +-
 drivers/net/wireless/ti/wlcore/main.c              |    4 +-
 drivers/net/wireless/virt_wifi.c                   |    4 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |   28 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c                |    4 +
 drivers/net/wwan/t7xx/t7xx_pci.c                   |    3 +
 drivers/nfc/microread/microread.c                  |    6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |   11 +-
 drivers/nfc/pn533/pn533.c                          |   14 +-
 drivers/nfc/pn533/pn533.h                          |    4 +-
 drivers/nfc/pn533/usb.c                            |    4 +-
 drivers/nfc/pn544/pn544.c                          |    7 +-
 drivers/nfc/port100.c                              |    7 +
 drivers/nfc/st21nfca/core.c                        |   12 +-
 drivers/nfc/st21nfca/i2c.c                         |   29 +-
 drivers/nfc/virtual_ncidev.c                       |    3 +-
 drivers/nvme/host/apple.c                          |  182 +-
 drivers/nvme/host/core.c                           |    6 +-
 drivers/nvme/host/rdma.c                           |   18 +-
 drivers/opp/of.c                                   |    2 +-
 drivers/pci/controller/dwc/pcie-intel-gw.c         |   19 +-
 drivers/pci/controller/pcie-altera.c               |    2 +
 drivers/pci/controller/pcie-iproc.c                |    2 +
 drivers/pci/controller/pcie-mediatek.c             |    2 +
 drivers/pci/controller/pcie-rockchip-host.c        |    2 +
 drivers/pci/pci-driver.c                           |   10 +-
 drivers/pci/pci-sysfs.c                            |   11 +-
 drivers/pci/pci.c                                  |   24 +-
 drivers/pci/proc.c                                 |   79 +-
 drivers/pci/quirks.c                               |    3 +
 drivers/pci/switch/switchtec.c                     |   16 +
 drivers/perf/arm-cmn.c                             |   10 +-
 drivers/pinctrl/meson/pinctrl-meson-s4.c           |    2 +-
 drivers/pinctrl/pinctrl-single.c                   |    3 +-
 drivers/pinctrl/renesas/pinctrl-rzv2m.c            |    4 +-
 drivers/platform/x86/dell/dell-laptop.c            |    9 +
 drivers/platform/x86/intel/hid.c                   |    7 +
 drivers/ptp/ptp_ocp.c                              |    1 +
 drivers/regulator/core.c                           |  163 +-
 drivers/regulator/da9121-regulator.c               |   18 +-
 drivers/regulator/db8500-prcmu.c                   |   12 +-
 drivers/rtc/rtc-aspeed.c                           |    1 +
 drivers/rtc/rtc-bq32k.c                            |    9 +
 drivers/s390/char/zcore.c                          |    8 +-
 drivers/s390/cio/cio.c                             |   11 +-
 drivers/s390/cio/device.c                          |    2 +-
 drivers/s390/cio/device_ops.c                      |   14 +
 drivers/s390/net/qeth_l2.h                         |    3 +-
 drivers/s390/net/qeth_l2_main.c                    |   26 +-
 drivers/s390/net/qeth_l2_sys.c                     |    7 +-
 drivers/scsi/bfa/bfa_fcs_lport.c                   |    2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   23 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |    2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    4 +-
 drivers/scsi/libiscsi_tcp.c                        |    3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |    4 +-
 drivers/scsi/mpi3mr/mpi3mr_transport.c             |    8 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    5 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |    8 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |    7 +
 drivers/scsi/qla2xxx/qla_os.c                      |    2 +-
 drivers/scsi/scsi_error.c                          |    2 +-
 drivers/soc/ti/pm33xx.c                            |    2 +-
 drivers/soundwire/bus.c                            |    4 +
 drivers/soundwire/cadence_master.c                 |    7 +
 drivers/soundwire/dmi-quirks.c                     |   35 +
 drivers/soundwire/slave.c                          |    4 +-
 drivers/spi/spi-dw-dma.c                           |    3 +-
 drivers/spi/spi-dw.h                               |    1 +
 drivers/spi/spi-xilinx.c                           |    6 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |   52 +-
 drivers/spi/spi.c                                  |    9 +-
 drivers/staging/fbtft/fbtft-core.c                 |    9 +-
 drivers/target/iscsi/iscsi_target.c                |   15 +-
 drivers/tee/optee/call.c                           |    3 +-
 drivers/thermal/db8500_thermal.c                   |   10 +-
 drivers/thermal/tegra/soctherm.c                   |    6 +-
 drivers/thunderbolt/icm.c                          |   10 +
 drivers/thunderbolt/tb.c                           |    6 +-
 drivers/thunderbolt/xdomain.c                      |   41 +-
 drivers/tty/serial/8250/8250_port.c                |    7 +
 drivers/usb/atm/xusbatm.c                          |    6 +-
 drivers/usb/class/cdc-acm.c                        |    6 +
 drivers/usb/class/usbtmc.c                         |    2 -
 drivers/usb/core/hcd.c                             |   14 +-
 drivers/usb/gadget/udc/aspeed_udc.c                |    7 +-
 drivers/usb/gadget/udc/core.c                      |    7 +-
 drivers/usb/gadget/udc/goku_udc.c                  |    3 +-
 drivers/usb/host/Kconfig                           |    2 +-
 drivers/usb/host/xhci-ring.c                       |    6 +
 drivers/usb/host/xhci.c                            |    4 +
 drivers/usb/usbip/vhci_sysfs.c                     |   52 +-
 drivers/vdpa/ifcvf/ifcvf_main.c                    |   11 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c               |    3 +-
 drivers/vhost/scsi.c                               |    3 +-
 drivers/vhost/vdpa.c                               |   12 +-
 drivers/video/fbdev/pm2fb.c                        |    1 +
 drivers/video/fbdev/vfb.c                          |   11 +-
 drivers/virtio/virtio_input.c                      |    9 +-
 drivers/virtio/virtio_pci_common.c                 |    4 +-
 drivers/watchdog/da9063_wdt.c                      |    4 +-
 drivers/watchdog/db8500_wdt.c                      |   22 +-
 drivers/watchdog/digicolor_wdt.c                   |   13 +-
 drivers/watchdog/msc313e_wdt.c                     |   88 +-
 drivers/watchdog/sp5100_tco.c                      |    6 +-
 drivers/watchdog/sunxi_wdt.c                       |   45 +-
 drivers/watchdog/watchdog_hrtimer_pretimeout.c     |    1 +
 drivers/xen/gntalloc.c                             |   13 +-
 drivers/xen/xen-front-pgdir-shbuf.c                |   12 +-
 fs/9p/vfs_dir.c                                    |   14 +-
 fs/affs/affs.h                                     |    5 -
 fs/affs/super.c                                    |    6 +-
 fs/autofs/inode.c                                  |    4 +
 fs/befs/linuxvfs.c                                 |    3 +-
 fs/bfs/inode.c                                     |    3 +-
 fs/btrfs/ctree.c                                   |   10 +-
 fs/btrfs/extent_io.c                               |   33 +-
 fs/btrfs/inode.c                                   |    3 +-
 fs/btrfs/ioctl.c                                   |   11 +-
 fs/btrfs/relocation.c                              |   47 +-
 fs/btrfs/transaction.c                             |   13 +-
 fs/btrfs/tree-checker.c                            |   43 +-
 fs/btrfs/tree-mod-log.c                            |   73 +-
 fs/btrfs/volumes.c                                 |   10 +-
 fs/btrfs/zoned.c                                   |    2 +
 fs/cachefiles/namei.c                              |    1 -
 fs/configfs/dir.c                                  |   12 +-
 fs/erofs/zdata.c                                   |   13 +-
 fs/exec.c                                          |   22 +-
 fs/f2fs/inline.c                                   |    7 +
 fs/freevxfs/vxfs_bmap.c                            |    3 +-
 fs/fs-writeback.c                                  |   25 +-
 fs/fuse/file.c                                     |    3 +-
 fs/hfs/catalog.c                                   |    9 -
 fs/hfs/dir.c                                       |   28 +-
 fs/hfs/hfs.h                                       |    3 +-
 fs/hfs/hfs_fs.h                                    |    2 -
 fs/hfs/inode.c                                     |    4 -
 fs/hfsplus/catalog.c                               |   11 -
 fs/hfsplus/dir.c                                   |   28 +-
 fs/hfsplus/hfsplus_fs.h                            |    5 +-
 fs/hfsplus/inode.c                                 |   40 +-
 fs/hfsplus/super.c                                 |    2 -
 fs/hpfs/super.c                                    |    3 +-
 fs/inode.c                                         |   11 +-
 fs/isofs/inode.c                                   |    3 +-
 fs/jfs/super.c                                     |    3 +-
 fs/minix/inode.c                                   |    3 +-
 fs/nfs/nfs42proc.c                                 |   15 +-
 fs/ntfs3/dir.c                                     |    4 +-
 fs/ntfs3/fslog.c                                   |   28 +-
 fs/ntfs3/index.c                                   |   41 +-
 fs/ntfs3/xattr.c                                   |    4 +-
 fs/ocfs2/namei.c                                   |    9 +-
 fs/ocfs2/xattr.c                                   |   13 +-
 fs/ocfs2/xattr.h                                   |    8 +-
 fs/omfs/inode.c                                    |    6 +-
 fs/qnx4/inode.c                                    |    3 +-
 fs/smb/client/cifsacl.c                            |   18 +
 fs/smb/client/connect.c                            |    1 +
 fs/smb/client/file.c                               |    5 +-
 fs/smb/client/misc.c                               |   19 +-
 fs/smb/client/readdir.c                            |    9 +-
 fs/smb/client/smb2ops.c                            |   31 +-
 fs/smb/client/smb2pdu.c                            |    7 +-
 fs/smb/client/transport.c                          |   11 +-
 fs/smb/server/ksmbd_work.h                         |    7 +
 fs/smb/server/mgmt/share_config.c                  |   36 +-
 fs/smb/server/mgmt/user_session.c                  |   25 +-
 fs/smb/server/misc.c                               |   14 +-
 fs/smb/server/oplock.c                             |   16 +-
 fs/smb/server/oplock.h                             |    2 +-
 fs/smb/server/server.c                             |   20 +
 fs/smb/server/smb2misc.c                           |   18 +-
 fs/smb/server/smb2pdu.c                            |  148 +-
 fs/smb/server/smbacl.c                             |   38 +-
 fs/smb/server/transport_ipc.c                      |   24 +-
 fs/smb/server/vfs.c                                |   14 +-
 fs/smb/server/vfs_cache.c                          |    3 +-
 fs/smb/server/vfs_cache.h                          |    7 +-
 fs/squashfs/xz_wrapper.c                           |    6 +-
 fs/ufs/cylinder.c                                  |   10 +
 fs/ufs/super.c                                     |   17 +-
 fs/xfs/xfs_icache.c                                |    2 +-
 include/drm/drm_atomic_helper.h                    |   26 +
 include/drm/drm_modeset_helper_vtables.h           |   29 +-
 include/keys/request_key_auth-type.h               |    2 +-
 include/linux/bitfield.h                           |    2 +-
 include/linux/bpf.h                                |    1 +
 include/linux/compiler_attributes.h                |   12 +
 include/linux/dev_printk.h                         |    1 +
 include/linux/firmware/intel/stratix10-smc.h       |   18 +-
 include/linux/kcsan-checks.h                       |    6 +-
 include/linux/lockdep.h                            |   16 +-
 include/linux/lockdep_types.h                      |    8 +
 include/linux/mailbox_controller.h                 |    2 +
 include/linux/mfd/db8500-prcmu.h                   |  252 ++-
 include/linux/mfd/dbx500-prcmu.h                   |  596 -------
 include/linux/mlx5/mlx5_ifc.h                      |    7 +-
 include/linux/netdevice.h                          |   23 +-
 include/linux/platform_data/asoc-ux500-msp.h       |   20 -
 include/linux/rculist.h                            |   29 +
 include/linux/rtnetlink.h                          |    7 +
 include/linux/switchtec.h                          |    1 +
 include/linux/thunderbolt.h                        |    2 +
 include/linux/workqueue.h                          |    3 +
 include/media/v4l2-hevc.h                          |   41 +
 include/net/cfg80211.h                             |    9 +-
 include/net/devlink.h                              |   13 +-
 include/net/dst.h                                  |   34 +-
 include/net/gue.h                                  |   19 +-
 include/net/inet_hashtables.h                      |    2 +-
 include/net/ip.h                                   |   14 +-
 include/net/ip6_route.h                            |    2 +
 include/net/ip_fib.h                               |    5 +
 include/net/mac80211.h                             |    9 +-
 include/net/netfilter/nf_conntrack.h               |    5 +
 include/net/netns/xfrm.h                           |    2 +-
 include/net/nfc/hci.h                              |    2 +-
 include/net/nfc/nfc.h                              |    3 +-
 include/net/route.h                                |    2 +-
 include/net/sch_generic.h                          |    2 +-
 include/net/udp_tunnel.h                           |    7 +-
 include/rdma/ib_umem.h                             |    4 +-
 include/sound/hda_codec.h                          |   30 +
 include/sound/hdaudio_ext.h                        |    2 +-
 include/trace/events/icmp.h                        |   13 +-
 init/main.c                                        |    3 +-
 io_uring/io-wq.c                                   |    1 +
 kernel/bpf/bpf_local_storage.c                     |   49 +-
 kernel/bpf/bpf_lsm.c                               |    6 +-
 kernel/bpf/btf.c                                   |   30 +-
 kernel/bpf/cgroup.c                                |    1 +
 kernel/bpf/disasm.c                                |    5 +-
 kernel/bpf/hashtab.c                               |   24 +-
 kernel/bpf/helpers.c                               |    2 +
 kernel/bpf/syscall.c                               |    5 +-
 kernel/bpf/verifier.c                              |   14 +
 kernel/dma/coherent.c                              |   13 +-
 kernel/events/ring_buffer.c                        |    9 +-
 kernel/locking/lockdep.c                           |  230 ++-
 kernel/sched/fair.c                                |   45 +-
 kernel/time/clockevents.c                          |   35 +-
 kernel/time/tick-broadcast.c                       |   36 +-
 kernel/time/tick-internal.h                        |    2 +
 kernel/trace/Makefile                              |    5 +-
 kernel/trace/bpf_trace.c                           |    4 +-
 kernel/trace/ring_buffer.c                         |   13 +-
 kernel/trace/trace_event_perf.c                    |   12 +-
 kernel/trace/trace_events_hist.c                   |   41 +-
 kernel/trace/trace_probe.c                         |   48 +-
 kernel/trace/trace_probe.h                         |    2 +
 kernel/workqueue.c                                 |    2 +-
 mm/backing-dev.c                                   |    5 +-
 mm/damon/core.c                                    |   13 +-
 net/8021q/vlan_dev.c                               |    5 +
 net/9p/client.c                                    |    2 +-
 net/appletalk/aarp.c                               |    5 +
 net/atm/pppoatm.c                                  |   42 +-
 net/bluetooth/bnep/core.c                          |   17 +-
 net/bluetooth/bnep/netdev.c                        |    8 +-
 net/bluetooth/eir.c                                |   10 +-
 net/bluetooth/hci_codec.c                          |   36 +-
 net/bluetooth/hci_sock.c                           |   20 +-
 net/bluetooth/hci_sync.c                           |   60 +-
 net/bluetooth/iso.c                                |   31 +-
 net/bluetooth/l2cap_core.c                         |   28 +-
 net/bluetooth/mgmt.c                               |   45 +-
 net/bluetooth/rfcomm/core.c                        |    6 +
 net/bluetooth/rfcomm/sock.c                        |   19 +-
 net/bluetooth/smp.c                                |   17 +
 net/bridge/br_arp_nd_proxy.c                       |   16 +-
 net/bridge/br_mst.c                                |   20 +-
 net/bridge/br_multicast.c                          |    2 -
 net/bridge/br_stp_bpdu.c                           |    5 +-
 net/core/dev.c                                     |   12 +-
 net/core/drop_monitor.c                            |   22 +-
 net/core/dst.c                                     |    4 +-
 net/core/filter.c                                  |   33 +-
 net/core/skbuff.c                                  |   16 +-
 net/core/skmsg.c                                   |    4 +
 net/core/sock.c                                    |   15 +-
 net/core/sock_map.c                                |    1 +
 net/devlink/leftover.c                             |   99 +-
 net/hsr/hsr_forward.c                              |    2 +-
 net/hsr/hsr_netlink.c                              |    9 +-
 net/ieee802154/6lowpan/core.c                      |    2 +-
 net/ipv4/arp.c                                     |    1 +
 net/ipv4/esp4.c                                    |    6 +
 net/ipv4/fib_rules.c                               |    4 +-
 net/ipv4/fib_trie.c                                |    4 +
 net/ipv4/fou_core.c                                |    6 +-
 net/ipv4/icmp.c                                    |   45 +-
 net/ipv4/igmp.c                                    |    2 +-
 net/ipv4/ip_fragment.c                             |    9 +-
 net/ipv4/ip_gre.c                                  |   12 +
 net/ipv4/ip_output.c                               |    4 +-
 net/ipv4/ip_tunnel_core.c                          |    6 +
 net/ipv4/ip_vti.c                                  |    4 +-
 net/ipv4/ipmr.c                                    |    2 +-
 net/ipv4/netfilter.c                               |    4 +-
 net/ipv4/nexthop.c                                 |    2 +-
 net/ipv4/route.c                                   |   10 +-
 net/ipv4/sysctl_net_ipv4.c                         |    4 +-
 net/ipv4/tcp_fastopen.c                            |    4 +-
 net/ipv4/tcp_input.c                               |    3 +-
 net/ipv4/tcp_ipv4.c                                |    3 +-
 net/ipv4/tcp_metrics.c                             |    8 +-
 net/ipv4/tcp_output.c                              |    3 +
 net/ipv4/udp.c                                     |    4 +-
 net/ipv4/xfrm4_output.c                            |    2 +-
 net/ipv6/addrconf.c                                |   10 +-
 net/ipv6/esp6.c                                    |    6 +
 net/ipv6/exthdrs.c                                 |    4 +-
 net/ipv6/exthdrs_core.c                            |    3 +
 net/ipv6/ip6_fib.c                                 |    4 +-
 net/ipv6/ip6_gre.c                                 |   19 +-
 net/ipv6/ip6_tunnel.c                              |   26 +-
 net/ipv6/ip6_udp_tunnel.c                          |   37 +-
 net/ipv6/ip6_vti.c                                 |   16 +-
 net/ipv6/ip6mr.c                                   |   10 +-
 net/ipv6/mcast.c                                   |   32 +-
 net/ipv6/netfilter/ip6_tables.c                    |    5 +
 net/ipv6/netfilter/ip6t_rpfilter.c                 |    2 +-
 net/ipv6/netfilter/ip6t_rt.c                       |   11 +-
 net/ipv6/route.c                                   |   22 +-
 net/ipv6/seg6.c                                    |    4 +-
 net/ipv6/seg6_local.c                              |    3 +
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/ipv6/xfrm6_output.c                            |   10 +-
 net/llc/llc_c_ac.c                                 |    2 +-
 net/llc/llc_s_ac.c                                 |    4 +
 net/llc/llc_sap.c                                  |    8 +-
 net/mac80211/cfg.c                                 |   14 +-
 net/mac80211/debugfs.c                             |    2 +-
 net/mac80211/debugfs_netdev.c                      |    9 +
 net/mac80211/ieee80211_i.h                         |   15 +-
 net/mac80211/iface.c                               |   28 +-
 net/mac80211/main.c                                |    4 +
 net/mac80211/mesh.c                                |    1 -
 net/mac80211/mlme.c                                |    6 +-
 net/mac80211/pm.c                                  |    8 +-
 net/mac80211/status.c                              |    4 +-
 net/mac80211/tdls.c                                |  194 ++-
 net/mac80211/tx.c                                  |   46 +-
 net/mac80211/util.c                                |    6 +-
 net/mptcp/options.c                                |    3 +-
 net/mptcp/protocol.c                               |   12 +-
 net/mptcp/protocol.h                               |    3 +-
 net/mptcp/subflow.c                                |   47 +-
 net/mptcp/syncookies.c                             |    5 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   13 +-
 net/netfilter/ipvs/ip_vs_core.c                    |    6 +
 net/netfilter/ipvs/ip_vs_sync.c                    |   20 +-
 net/netfilter/nf_conntrack_expect.c                |    3 +-
 net/netfilter/nf_conntrack_netlink.c               |   16 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   10 +-
 net/netfilter/nf_conntrack_sip.c                   |    2 +-
 net/netfilter/nf_flow_table_core.c                 |   12 +-
 net/netfilter/nf_flow_table_offload.c              |    7 +-
 net/netfilter/nf_log_syslog.c                      |    6 +-
 net/netfilter/nf_tables_api.c                      |    4 +-
 net/netfilter/nfnetlink_log.c                      |   28 +-
 net/netfilter/nfnetlink_queue.c                    |   77 +-
 net/netfilter/nft_nat.c                            |    2 +-
 net/netfilter/nft_set_pipapo_avx2.c                |    1 +
 net/netfilter/nft_synproxy.c                       |    3 +-
 net/netlabel/netlabel_unlabeled.c                  |    2 +-
 net/nfc/core.c                                     |   15 +-
 net/nfc/digital_dep.c                              |    8 +-
 net/nfc/llcp.h                                     |    1 +
 net/nfc/llcp_commands.c                            |    2 +-
 net/nfc/llcp_core.c                                |  173 +-
 net/nfc/llcp_sock.c                                |   67 +-
 net/nfc/nci/core.c                                 |   10 +-
 net/nfc/netlink.c                                  |    7 +-
 net/nfc/nfc.h                                      |    3 +-
 net/openvswitch/conntrack.c                        |   14 +-
 net/openvswitch/flow.c                             |    4 +-
 net/openvswitch/flow_table.c                       |    4 +-
 net/packet/af_packet.c                             |   11 +-
 net/packet/internal.h                              |    2 +-
 net/phonet/pn_dev.c                                |   30 +-
 net/qrtr/af_qrtr.c                                 |    4 +-
 net/rds/af_rds.c                                   |   63 +-
 net/rds/connection.c                               |  102 +-
 net/rds/ib_cm.c                                    |   27 +-
 net/rds/ib_frmr.c                                  |   11 +-
 net/rds/ib_recv.c                                  |    9 +-
 net/rds/message.c                                  |    4 +-
 net/rds/send.c                                     |   16 +-
 net/rds/tcp.c                                      |  164 +-
 net/rds/tcp_listen.c                               |    6 +-
 net/sched/act_api.c                                |  136 +-
 net/sched/act_csum.c                               |    8 +-
 net/sched/act_ct.c                                 |    5 +-
 net/sched/act_gate.c                               |   30 +-
 net/sched/cls_api.c                                |    2 +-
 net/sched/cls_route.c                              |   45 +-
 net/sched/cls_u32.c                                |   44 +-
 net/sched/sch_api.c                                |    2 +-
 net/sched/sch_drr.c                                |   13 +-
 net/sched/sch_ets.c                                |   12 +-
 net/sched/sch_fq_pie.c                             |   62 +-
 net/sched/sch_generic.c                            |   24 +-
 net/sched/sch_hfsc.c                               |   22 +
 net/sched/sch_hhf.c                                |   15 +-
 net/sched/sch_pie.c                                |    2 +-
 net/sched/sch_sfq.c                                |    7 +-
 net/sched/sch_teql.c                               |    7 +-
 net/sctp/associola.c                               |   15 +-
 net/sctp/input.c                                   |    7 +-
 net/sctp/ipv6.c                                    |   12 +-
 net/sctp/protocol.c                                |   11 +-
 net/sctp/sm_make_chunk.c                           |   14 +-
 net/sctp/sm_sideeffect.c                           |   48 +-
 net/sctp/sm_statefuns.c                            |    7 +
 net/smc/af_smc.c                                   |    3 +-
 net/smc/smc_clc.c                                  |    8 +-
 net/smc/smc_clc.h                                  |    8 +-
 net/smc/smc_core.c                                 |    2 +
 net/smc/smc_ib.c                                   |   10 +-
 net/sunrpc/xprtrdma/verbs.c                        |   21 +-
 net/tipc/group.c                                   |    4 +-
 net/tipc/monitor.c                                 |    3 +-
 net/tipc/name_table.c                              |   32 +-
 net/tipc/socket.c                                  |    4 +-
 net/tls/tls_main.c                                 |   11 +
 net/tls/tls_sw.c                                   |    6 +-
 net/unix/af_unix.c                                 |   42 +-
 net/unix/garbage.c                                 |    1 +
 net/vmw_vsock/hyperv_transport.c                   |    2 +-
 net/vmw_vsock/vmci_transport.c                     |    2 +-
 net/wireless/mlme.c                                |  105 +-
 net/wireless/nl80211.c                             |   15 +-
 net/wireless/rdev-ops.h                            |   15 +-
 net/wireless/scan.c                                |   12 +-
 net/wireless/trace.h                               |  255 ++-
 net/wireless/util.c                                |   26 +-
 net/wireless/wext-sme.c                            |    9 +
 net/xdp/xskmap.c                                   |    2 +-
 net/xfrm/espintcp.c                                |    6 +-
 net/xfrm/xfrm_input.c                              |   11 +
 net/xfrm/xfrm_user.c                               |   37 +-
 scripts/mod/modpost.c                              |   11 +-
 security/integrity/digsig_asymmetric.c             |    4 +
 security/integrity/ima/ima_appraise.c              |    5 +
 security/keys/gc.c                                 |    4 +-
 security/keys/request_key_auth.c                   |   12 +-
 security/keys/trusted-keys/trusted_tpm2.c          |   12 +-
 security/landlock/errata/abi-1.h                   |   15 +
 security/landlock/fs.c                             |   40 +-
 security/selinux/avc.c                             |    5 +-
 sound/core/pcm_native.c                            |   35 +-
 sound/core/pcm_timer.c                             |    7 +-
 sound/core/seq/oss/seq_oss_rw.c                    |    3 +-
 sound/hda/ext/hdac_ext_controller.c                |    6 +-
 sound/isa/es18xx.c                                 |    4 +
 sound/pci/ctxfi/cthw20k2.c                         |    1 +
 sound/pci/hda/hda_codec.c                          |  119 +-
 sound/pci/hda/hda_controller.c                     |   26 +-
 sound/pci/hda/hda_proc.c                           |    4 +-
 sound/pci/hda/hda_sysfs.c                          |   77 +-
 sound/pci/hda/patch_conexant.c                     |   12 +
 sound/pci/hda/patch_realtek.c                      |   19 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |    2 +-
 sound/soc/amd/yc/acp6x-mach.c                      |    7 +
 sound/soc/amd/yc/acp6x-pdm-dma.c                   |    2 +
 sound/soc/bcm/bcm63xx-i2s-whistler.c               |    1 +
 sound/soc/codecs/ab8500-codec.c                    |  543 +++---
 sound/soc/codecs/hdmi-codec.c                      |    6 +-
 sound/soc/codecs/mt6351.c                          |    1 +
 sound/soc/codecs/pcm3168a.c                        |   20 +-
 sound/soc/codecs/rk3328_codec.c                    |   54 +-
 sound/soc/codecs/rt5645.c                          |    4 +
 sound/soc/intel/atom/sst/sst_pci.c                 |    1 +
 sound/soc/intel/avs/core.c                         |   13 +-
 sound/soc/intel/catpt/ipc.c                        |    8 +
 sound/soc/intel/catpt/loader.c                     |    3 +
 sound/soc/intel/catpt/registers.h                  |   12 +
 sound/soc/intel/skylake/skl.c                      |    2 +-
 sound/soc/meson/aiu-acodec-ctrl.c                  |    3 +
 sound/soc/meson/aiu-codec-ctrl.c                   |    3 +
 sound/soc/qcom/qdsp6/q6apm.c                       |   10 +-
 sound/soc/rockchip/rockchip_pdm.c                  |   16 +-
 sound/soc/rockchip/rockchip_spdif.c                |    1 +
 sound/soc/sof/intel/hda.c                          |    2 +-
 sound/soc/sof/ipc4-topology.c                      |   10 +
 sound/soc/sprd/sprd-pcm-compress.c                 |   15 +-
 sound/soc/sti/uniperif_reader.c                    |    4 +-
 sound/soc/ti/omap3pandora.c                        |    5 +-
 sound/soc/ux500/mop500.c                           |    8 +-
 sound/soc/ux500/ux500_msp_dai.c                    |  169 +-
 sound/soc/ux500/ux500_msp_dai.h                    |   11 -
 sound/soc/ux500/ux500_msp_i2s.c                    |  326 ++--
 sound/soc/ux500/ux500_msp_i2s.h                    |   30 +-
 sound/soc/ux500/ux500_pcm.c                        |   83 +-
 sound/usb/6fire/chip.c                             |   40 +-
 sound/usb/6fire/comm.c                             |   42 +-
 sound/usb/6fire/comm.h                             |    2 +-
 sound/usb/6fire/midi.c                             |   64 +-
 sound/usb/6fire/midi.h                             |    2 +-
 sound/usb/6fire/pcm.c                              |  221 +--
 sound/usb/6fire/pcm.h                              |    5 +-
 sound/usb/bcd2000/bcd2000.c                        |   33 +-
 sound/usb/caiaq/audio.c                            |   10 +-
 sound/usb/caiaq/device.c                           |   53 +-
 sound/usb/caiaq/device.h                           |    4 +-
 sound/usb/caiaq/input.c                            |    6 +
 sound/usb/caiaq/midi.c                             |    6 +-
 sound/usb/mixer.c                                  |   17 +-
 sound/usb/mixer_maps.c                             |   25 +
 sound/usb/quirks-table.h                           |   22 +
 sound/usb/quirks.c                                 |    4 +
 sound/usb/usx2y/us122l.c                           |    9 +-
 sound/usb/usx2y/usbusx2y.c                         |   45 +-
 sound/usb/usx2y/usbusx2y.h                         |    4 +-
 sound/virtio/virtio_card.c                         |    4 +-
 tools/bpf/bpftool/map.c                            |    5 -
 tools/build/feature/test-bpf.c                     |    2 +
 tools/lib/bpf/bpf.c                                |    2 +
 tools/lib/bpf/gen_loader.c                         |    2 +
 tools/lib/bpf/libbpf.c                             |    7 +
 tools/lib/bpf/relo_core.c                          |   58 +-
 tools/perf/tests/shell/stat_bpf_counters.sh        |   30 +-
 tools/perf/util/cs-etm.c                           |   81 +-
 tools/testing/selftests/alsa/mixer-test.c          |    4 +-
 .../selftests/arm64/mte/check_gcr_el1_cswitch.c    |    2 +-
 tools/testing/selftests/bpf/config                 |    1 +
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |    7 +
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  112 +-
 tools/testing/selftests/cgroup/test_kmem.c         |    2 +-
 .../ftrace/test.d/kprobe/kprobe_non_uniq_symbol.tc |    2 +-
 tools/testing/selftests/landlock/fs_test.c         | 1746 +++++++++++++++++++-
 tools/testing/selftests/nci/nci_dev.c              |   45 +-
 tools/testing/selftests/net/fib_nexthops.sh        |   28 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |    4 +-
 tools/testing/selftests/net/pmtu.sh                |    2 +-
 tools/testing/selftests/powerpc/tm/tm.h            |    8 +-
 tools/thermal/tmon/tui.c                           |    2 +-
 916 files changed, 12377 insertions(+), 6492 deletions(-)


