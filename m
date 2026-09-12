Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504B817A30A;
	Sat, 12 Sep 2026 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219725; cv=none; b=Kgj1YbWdxxfsUzKh4g/tXUTY58TezSG5vDs4q35V+7vDvonO9r6CGqtZwSfcHo3GCDLOdE8mzOMcDPpWHnwDF3Jjpyl+vA8thR7FeuFBYva9nWsRFh3ZU3fvUVoAR/wVBe97Z4WjeeSmzx5iWPtZZmtmAFTtX5lnMZIzWNRwai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219725; c=relaxed/simple;
	bh=V+qiD4fC8ppBwKf7IkVmxA2QgG/2I9xElRouJOpppCI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tytdGTPkZg7fbJTFwDTwHmXDyITYsMjoDiFOCVuK/y5n18xY8lD6WmakWb0wIvhu9kxc6WnY8Bdnkb5uVSAAoKF0ddUpS/6V68/iO1mGbpEntvfs6YFTX4FIHTvgdkEosWjNq5sPDYTuR3vGq5tCPmBXjn3Q8rfY0c1idsTCoGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ipk371m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ipk371m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72181F000FF;
	Sat, 12 Sep 2026 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219717;
	bh=PbaZjh6K7H+FqOEoTb+wfrAphqbDtjQh500+G2Dqi1M=;
	h=From:To:Cc:Subject:Date;
	b=Ipk371m0ZbX/PBkpT7vzQuxNb/GvdvqxvScIabqyyEQPrvHVqfXrbK5y2QSwkpVhb
	 w6Sb6jToWah/Gko5Azy+3zCUrmtesMyPZ4Fg6iuh2inC1FteBZtlD/UnWtwtEZFINb
	 H934UPUTmGiuJ39N+b5EJj3jM8p2+/sh2q8uqE10=
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
Subject: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
Date: Sat, 12 Sep 2026 08:40:32 +0200
Message-ID: <20260912065607.279695368@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.157-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.157-rc1
X-KernelTest-Deadline: 2026-09-14T06:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.157 release.
There are 1424 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.157-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.157-rc1

Xixin Liu <liuxixin@kylinos.cn>
    nvmet-rdma: fix queue leak when connect backlog is exceeded

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Fix the return value of amd_uncore_df_event_init() on error

Eric Dumazet <edumazet@google.com>
    net: hsr: must allocate more bytes for RedBox support

Dan Carpenter <dan.carpenter@linaro.org>
    pinctrl: mediatek: common-v1: Fix error checking in mtk_eint_init()

Tomas Glozar <tglozar@redhat.com>
    tools/build: Use SYSTEM_BPFTOOL for system bpftool

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Fix unannotated kfree() cleanup

Eric Dumazet <edumazet@google.com>
    net: hsr: init prune_proxy_timer sooner

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    net: hsr: Use the seqnr lock for frames received via interlink port.

MD Danish Anwar <danishanwar@ti.com>
    net: hsr: enable promiscuous mode on interlink port with fwd offload

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    wifi: ath11k: Fix error handling in ath11k_wmi_p2p_noa_event()

Matvey Kovalev <matvey.kovalev@ispras.ru>
    wifi: ath11k: fix NULL dereference in ath11k_qmi_m3_load()

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Roll back partial protocol table registration

Thomas Gleixner <tglx@linutronix.de>
    irqdomain: Make build work for CONFIG_GENERIC_IRQ_CHIP=n

Wentao Liang <vulab@iscas.ac.cn>
    nvme: target: rdma: fix ndev refcount leak on queue connect

Catalin Marinas <catalin.marinas@arm.com>
    kselftest/arm64: mte: Use the correct naming for tag check modes in check_hugetlb_options.c

Catalin Marinas <catalin.marinas@arm.com>
    kselftest/arm64: mte: Skip the hugetlb tests if MTE not supported on such mappings

e.kubanski <e.kubanski@partner.samsung.com>
    xsk: Fix offset calculation in unaligned mode

Nick Chan <towinchenmi@gmail.com>
    nvme-apple: Reset q->sq_tail during queue init

Nick Chan <towinchenmi@gmail.com>
    nvme-apple: Prevent shared tags across queues on Apple A11

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: Update cpuidle driver check in __acpi_processor_start()

Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
    ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Remove redundant static variable and rename cstate check function

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Move max_cstate update out of the loop

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Remove redundant cstate check in acpi_processor_power_init

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: common-v1: Fix EINT breakage on older controllers

Hao Chang <ot_chhao.chang@mediatek.com>
    pinctrl: mediatek: Fix new design debounce issue

Chen-Yu Tsai <wenst@chromium.org>
    pinctrl: mediatek: eint: Drop base from mtk_eint_chip_write_mask()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_htb: limit htb_classify inner-class filter hops

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: fix corruption of urgent data on multi-segment retransmit

Deepanshu Kartikey <kartikey406@gmail.com>
    usb: atm: usbatm: fix invalid ci_range initialization

bui duc phuc <phucduc.bui@gmail.com>
    net: fec: only stop PTP if it was initialized

Eric Dumazet <edumazet@google.com>
    slip: remove slip_hangup() to fix use-after-free in slip_receive_buf()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: bound qdisc_pkt_len to prevent qdisc soft lockup

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Account for the UC filter list for filtering tests

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwxgmac: Account for the primary MAC address for UC filtering

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac4: Account for the primary MAC address for UC filtering

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: dwmac1000: Account for the primary MAC address for UC filtering

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Check multiple MMC counters

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/arm64: Treat KSM merge_across_nodes as optional

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/arm64: Print missing MTE TAP headers

Yang Shi <yang@os.amperecomputing.com>
    selftests: arm64: add hugetlb mte tests

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()

Marino Dzalto <marino.dzalto@gmail.com>
    netfilter: xt_HL: add pr_fmt and checkentry validation

Michal Koutný <mkoutny@suse.com>
    netfilter: xt_cgroup: Make it independent from net_cls

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: move hardware offload step after building the chain blob

Alice Mikityanska <alice@isovalent.com>
    virtio-net: Ensure that TCP packets don't overflow gso_segs

Maxime Chevallier <maxime.chevallier@bootlin.com>
    net: stmmac: selftests: Pass the IP proto mask in the TC selftest

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: sun4i-emac: Fix IRQ error handling

Haotian Zhang <vulab@iscas.ac.cn>
    samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-multi-modify

Haotian Zhang <vulab@iscas.ac.cn>
    samples/ftrace: Fix kthread_stop() on ERR_PTR in ftrace-direct-modify

Aleksandr Nogikh <nogikh@google.com>
    libceph: validate banner payload length

Xiubo Li <xiubo.li@clyso.com>
    ceph: revalidate ki_pos for O_APPEND writes after cap acquisition

HyeongJun An <sammiee5311@gmail.com>
    ASoC: dapm: Fix off-by-one check on the second enum channel

John Johansen <john.johansen@canonical.com>
    apparmor: policy_int make sure list heads are initialized before fail path

Thorsten Blum <thorsten.blum@linux.dev>
    apparmor: Replace sprintf/strcpy with scnprintf/strscpy in aa_policy_init

Ruoyu Wang <ruoyuw560@gmail.com>
    tpm: st33zp24: Validate locality read result

Ruoyu Wang <ruoyuw560@gmail.com>
    tpm: st33zp24: Return zero on status read failure

Victor Nogueira <victor@mojatatu.com>
    net/sched: sch_teql: restore skb->dev on the slave failure path

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sfq: clamp quantum to avoid signed overflow soft lockup

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: clamp quantum before hhf_change() to avoid overflow

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_pie: clamp default quantum to avoid signed overflow

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: sch_codel: clamp default mtu to avoid disabling CoDel

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: fq_codel: clamp default quantum and mtu

Eric Dumazet <edumazet@google.com>
    net/sched: act_skbmod: fix length calculations and avoid invalid header warnings

Eric Dumazet <edumazet@google.com>
    net_sched: act_skbmod: use RCU in tcf_skbmod_dump()

Liam R. Howlett (Oracle) <liam@infradead.org>
    maple_tree: fix argument name in header

Muhammad Usama Anjum <usama.anjum@arm.com>
    selftests/mm: skip COW tmpfile cases when fallocate() is unsupported

Mark Brown <broonie@kernel.org>
    selftests/mm: report unique test names for each cow test

Hao Ge <gehao@kylinos.cn>
    selftests/mm/cow: modify the incorrect checking parameters

David Hildenbrand <david@redhat.com>
    selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm/cow: generalize do_run_with_thp() helper

Frank Sorenson <sorenson@redhat.com>
    cifs: fix clearing stats for fastest execution of each smb2 command

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in rds_cong_map_updated()

Naveen Mamindlapalli <naveenm@marvell.com>
    octeontx2-af: Fix TL3/TL2 link config ENA clearing

Xiang Mei <xmei5@asu.edu>
    net: qualcomm: rmnet: restore skb->dev on deaggregated frames

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Fix out-of-bounds DMA read in the TX path

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX

Ismail Tarim <ismailtarim7@gmail.com>
    Bluetooth: btmtk: Do not discard the subsystem reset timeout

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: fix race l2cap_sock_cleanup_listen() vs. put_chan

Pavel Shpakovskiy <pashpakovskii@salutedevices.com>
    Bluetooth: mgmt: fix 'hdev->discovery.uuids' NULL dereference

Pauli Virtanen <pav@iki.fi>
    Bluetooth: L2CAP: reject accept queue add unless BT_LISTEN

Geert Uytterhoeven <geert+renesas@glider.be>
    erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic

Dan Carpenter <error27@gmail.com>
    scsi: qla2xxx: Fix an loop timeout test

Cosmo Chou <chou.cosmo@gmail.com>
    rtc: pcf85363: Add error checking to regmap calls in probe()

Junrui Luo <moonafterrain@outlook.com>
    NFSv4/pnfs: key the data server cache on the NFS version

Jeff Layton <jlayton@kernel.org>
    nfs: move the nfs4_data_server_cache into struct nfs_net

Junrui Luo <moonafterrain@outlook.com>
    NFSv4.2: fix LAYOUTSTATS send buffer exhaustion

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free pending qentry in smc_llc_flow_stop() before memset

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free stashed qentry before overwrite in REQ_ADD_LINK to ADD_LINK transition

Eric Dumazet <edumazet@google.com>
    inetpeer: randomize RB-tree node comparison using SipHash

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    net: add missing ref_tracker_dir_exit() to net_passive_dec()

Ruoyu Wang <ruoyuw560@gmail.com>
    net: ipa: balance runtime PM reference on remove error

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    net: ipa: Convert to platform remove callback returning void

Marek Czernohous <marek@czernohous.de>
    forcedeth: stop the tx_timeout register dump past the requested window

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Count delivered packets in rx_packets and rx_bytes

Ruoyu Wang <ruoyuw560@gmail.com>
    net: bridge: Reject descending VLAN tunnel ranges

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    xsk: fix NULL pointer dereference in __xsk_rcv()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: avoid double checking against rx queue being full

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: Get rid of xdp_buff_xsk::orig_addr

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/ucma: Allow path records to exactly fit the output buffer

Haotian Zhang <vulab@iscas.ac.cn>
    ALSA: ice1712: Fix the card leak at probe error with the auto-cleanup

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: core: Add scoped cleanup helper for card references

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Use guard() for locking

Takashi Iwai <tiwai@suse.de>
    ALSA: control: Use automatic cleanup of kfree()

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: visconti: Make sure clk_init_data is fully initialized

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: ti: Make sure clk_init_data is fully initialized

Bradley Morgan <include@grrlz.net>
    prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator

Linkai Gong <gonglinkai@kylinos.cn>
    rtc: gamecube: check return value of devm_rtc_register_device()

Ruoyu Wang <ruoyuw560@gmail.com>
    i2c: ocores: Disable clock on failed resume

Biju Das <biju.das.jz@bp.renesas.com>
    irqchip/renesas-rzg2l: Fix loss of interrupt

Pengpeng Hou <pengpeng@iscas.ac.cn>
    rtc: zynqmp: Return optional clock lookup errors

Christopher Lusk <clusk@northecho.dev>
    smb: client: fix request buffer leak in smb2_new_read_req()

Yi Ding <yi.s.ding@gmail.com>
    rtc: pcf8563: fix clock provider leak on unbind

Li RongQing <lirongqing@baidu.com>
    vdpa/mlx5: fix wrong list iterated in add_direct_chain error path

Linfeng Sun  <linfeng.sun.dev@gamil.com>
    vdpa_sim: fix cleanup after worker creation failure

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: disable indirect descriptors

Jian-Ming Liao <Jm_Liao@asmedia.com.tw>
    i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Refactor PIO register initialization

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Switch PIO data allocation to devm_kzalloc()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: mipi-i3c-hci: Quieten initialization messages

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Fix number of DAT/DCT entries for HCI versions < 1.1

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    i3c: mipi-i3c-hci: Fix DAT/DCT entry sizes

Ruoyu Wang <ruoyuw560@gmail.com>
    bonding: initialize err for empty target lists

Nikolay Kulikov <nikolayof23@gmail.com>
    mlxbf-bootctl: fix the build error with FIELD_PREP()

Guangshuo Li <lgs201920130244@gmail.com>
    platform/x86: hp-bioscfg: fix password encoding bounds check

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: use sock_error() to consume sk_err after a failed connect

HyeongJun An <sammiee5311@gmail.com>
    platform/x86: dell-wmi-sysman: Fix instance ID bounds

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: hash socket only after full initialisation in smc_sk_init()

Karl Mehltretter <kmehltretter@gmail.com>
    8139cp: fix Rx and Tx not being disabled in cp_suspend

Baul Lee <baul.lee@xbow.com>
    vxlan: mdb: Fix use-after-free in vxlan_mdb_flush()

Ido Schimmel <idosch@nvidia.com>
    vxlan: mdb: Add MDB bulk deletion support

Ido Schimmel <idosch@nvidia.com>
    net: Add MDB bulk deletion device operation

Ido Schimmel <idosch@nvidia.com>
    bridge: add MDB state mask uAPI attribute

Ido Schimmel <idosch@nvidia.com>
    vxlan: mdb: Add MDB get support

Ido Schimmel <idosch@nvidia.com>
    net: Add MDB get device operation

Ido Schimmel <idosch@nvidia.com>
    bridge: add MDB get uAPI attributes

Ido Schimmel <idosch@nvidia.com>
    vxlan: mdb: Factor out a helper for remote entry size calculation

Ido Schimmel <idosch@nvidia.com>
    vxlan: mdb: Adjust function arguments

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Fix connection list comparison in proc output

Baokun Li <libaokun@linux.alibaba.com>
    fuse: check for NULL root inode in fuse_fill_super_submount

Zhang Tianci <zhangtianci.1997@bytedance.com>
    fuse: check attributes staleness on fuse_iget()

Joanne Koong <joannelkoong@gmail.com>
    fuse: convert readdir to use folios

Joanne Koong <joannelkoong@gmail.com>
    fuse: support folios in struct fuse_args_pages and fuse_copy_pages()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: use FUSE_ROOT_ID in fuse_get_root_inode()

Jeff Layton <jlayton@kernel.org>
    fuse: convert to new timestamp accessors

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: validate ef->size covers the record's name and value

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: fix out-of-bounds read in read_log_rec_buf()

Baokun Li <libaokun@linux.alibaba.com>
    cuse: wait for pending RCU callbacks on module exit

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix inverted default vlan notification

Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
    tls: fix RX desync on overlapping skbs

Ruoyu Wang <ruoyuw560@gmail.com>
    net: dsa: mv88e6xxx: Fix PCS link check on CMODE read error

Xiang Mei <xmei5@asu.edu>
    vxlan: vnifilter: enforce exact length of GROUP/GROUP6 attributes

Joas Antonio dos Santos <joasantonio108@gmail.com>
    ipvs: fix integer overflow in ftp helper port/address parsing

Xin Xie <xiexinet@gmail.com>
    net: hsr: free learned nodes on device setup failure

Lukasz Majewski <lukma@denx.de>
    net: hsr: Provide RedBox support (HSR-SAN)

Lukasz Majewski <lukma@denx.de>
    net: hsr: Use full string description when opening HSR network device

Qingfang Deng <qingfang.deng@linux.dev>
    pppox: drain queued packets on channel handoff

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: b53: fix error propagation from b53_fdb_dump()

Junseo Lim <zirajs7@gmail.com>
    net: kcm: Hold RCU read lock while running BPF parser

Karl Mehltretter <kmehltretter@gmail.com>
    octeontx2-af: initialize lmac_bmap in rvu_mcs_set_lmac_bmap()

Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
    clk: ti: mux: resolve parent clocks by DT index, not by name

Ethan Carter Edwards <ethan@ethancedwards.com>
    clk: ti: use kcalloc() instead of kzalloc()

Ruoyu Wang <ruoyuw560@gmail.com>
    NFSv4: remove callback IDR entry on client allocation failure

Arnaud Bonnet <abo@medichon.fr>
    nfs: refactor pNFS functions using clear_and_wake_up_bit

Arnaud Bonnet <abo@medichon.fr>
    nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper

Hang Nan <2122295973@qq.com>
    ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: disconnect on SMB3 decryption failure

Junseo Lim <zirajs7@gmail.com>
    bpf: Reject negative optlen in cgroup getsockopt hook

Andreas Schwab <schwab@linux-m68k.org>
    m68k: nfcon: Do not call console_is_registered() in nfcon_device()

Junseo Lim <zirajs7@gmail.com>
    lwt_bpf: Restore reserved headroom after xmit program

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: preserve error status in smb2_handle_negotiate()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/server: fix invalid pointer dereference in ksmbd_stop_durable_scavenger()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: free preauth sessions on connection teardown

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: do not advertise unimplemented CA support

Yunseong Kim <yunseong.kim@est.tech>
    ksmbd: validate ipc response length before dereferencing its fields

Enzo Matsumiya <ematsumiya@suse.de>
    smb: server: fix leak of ksmbd_ipc_login_request_ext() returned buffer

Guangshuo Li <lgs201920130244@gmail.com>
    ksmbd: Do not skip lock checks for single-byte ranges

Marius Cristea <marius.cristea@microchip.com>
    hwmon: (emc1403) Drop hysteresis for low limit temperature

Guenter Roeck <linux@roeck-us.net>
    hwmon: (emc1403) Rely on subsystem locking

Lars Petter Mostad <larspm@gmail.com>
    hwmon: (emc1403) Add support for EMC1428 and EMC1438.

Guenter Roeck <linux@roeck-us.net>
    hwmon: (emc1403) Support 11 bit accuracy

Guenter Roeck <linux@roeck-us.net>
    hwmon: (emc1403) Convert to with_info API

Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
    hwmon: (emc1403) Add support for EMC1442

Hongyan Xu <getshell@seu.edu.cn>
    block: mtip32xx: synchronize ioctls with device removal

Niklas Cassel <cassel@kernel.org>
    null_blk: serialize configfs attribute updates with device setup

Zizhi Wo <wozizhi@huawei.com>
    null_blk: serialize configfs attribute stores with the lock

Zizhi Wo <wozizhi@huawei.com>
    null_blk: reject per-device queue resize for shared tag set

Zizhi Wo <wozizhi@huawei.com>
    null_blk: free global tag_set on init error path

Zizhi Wo <wozizhi@huawei.com>
    null_blk: register configfs subsystem after creating default devices

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    null_blk: add configfs variable shared_tags

Zizhi Wo <wozizhi@huawei.com>
    null_blk: use DEFINE_MUTEX for the file-scope mutex

Huisong Li <lihuisong@huawei.com>
    mailbox: pcc: Fix command timeout due to missed interrupt

Sudeep Holla <sudeep.holla@arm.com>
    Revert "mailbox/pcc: support mailbox management of the shared buffer"

Adam Young <admiyo@os.amperecomputing.com>
    mailbox/pcc: support mailbox management of the shared buffer

Sudeep Holla <sudeep.holla@arm.com>
    mailbox: pcc: Always map the shared memory communication address

Linmao Li <lilinmao@kylinos.cn>
    mailbox: rockchip: disable pclk on probe failure and unbind

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard against cache underflow on short reads in dso_cache__memcpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()

Zhushuai Yin <yinzhushuai@huawei.com>
    crypto: hisilicon/sec2 - fix CCM algorithm long packet failure

Israel Téllez García <i.tellez@btesa.com>
    bpf: Fix pending_pos walk on 32-bit ring position wrap

Hongyan Xu <getshell@seu.edu.cn>
    ACPI: scan: fix bus ID cleanup on device_add() failures

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ASoC: SOF: validate topology volume range before allocation

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have trace_event_update_all() only handle module that is loading

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing: Remove "__attribute__()" from the type field of event format

Aleksandr Nogikh <nogikh@google.com>
    ALSA: core: Fix use-after-free in snd_card_do_free()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: reject out-of-range evcn in mi_enum_attr()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    fs/ntfs3: fix integer overflow in MFT cluster validation

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: core: Set task state before io_schedule_timeout()

Avri Altman <avri.altman@wdc.com>
    scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR

Andrew Halaney <ahalaney@redhat.com>
    scsi: ufs: core: Remove unnecessary wmb() after ringing doorbell

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers

Eduard Zingerman <eddyz87@gmail.com>
    selftests/bpf: Fix for veristat file/prog filters processing

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check block offset is not negative

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    ocfs2: fix circular locking dependency in ocfs2_init_acl()

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix double close in map dump

Bijan Tabatabai <btabatabai@wisc.edu>
    x86/pkeys: Fix pkey_alloc() return value when pkeys are not supported

John Keeping <jkeeping@inmusicbrands.com>
    ALSA: seq: midi: Serialize input teardown with event_input

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: midi: Optimize event_input locking with RCU

Yuho Choi <dbgh9129@gmail.com>
    clocksource/drivers/armada: Unwind timer clock on init failure

Guangshuo Li <lgs201920130244@gmail.com>
    clocksource/drivers/clps711x: Do not unmap clocksource MMIO

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/debug: Fix deadlock during unregister

Yuho Choi <dbgh9129@gmail.com>
    xenbus: Unregister reboot notifier on init failure

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq28z610: fix invalid AverageEnergy address

Henrik Grimler <henrik.grimler@axis.com>
    power: supply: bq27xxx: bq27520g4: fix REG_TTES address

Matti Vaittinen <mazziesaccount@gmail.com>
    power: supply: bd99954: Drop bad register fields

Felix Gu <ustc.gu@gmail.com>
    spi: img-spfi: don't disable runtime PM on DMA deferred probe

Vineet Gupta <vineet.gupta@linux.dev>
    selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM

Pu Lehui <pulehui@huawei.com>
    selftests/bpf: Add description for running vmtest on RV64

Pu Lehui <pulehui@huawei.com>
    selftests/bpf: Support local rootfs image for vmtest

Pu Lehui <pulehui@huawei.com>
    selftests/bpf: Limit URLS parsing logic to actual scope in vmtest

Mohammad Abu-Khader <mohammad.abukhader@hotmail.com>
    kunit: tool: fix _list_tests filtering wrong variable when list has TAP prefix

Ran Hongyun <ranhongyun1@huawei.com>
    UBI: fix two issues in the ubi.mtd MODULE_PARM_DESC

Rosen Penev <rosenp@gmail.com>
    ASoC: xilinx: formatter_pcm: fix stream_data leak on open error

Yuho Choi <dbgh9129@gmail.com>
    ubi: Fix rollback for explicit UBI device numbers

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Add module parameter to control reserving filling pool PEBs

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix lapsed wear leveling for first 64 PEBs

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Wait until there are enough free PEBs before filling pools

Zhihao Cheng <chengzhihao1@huawei.com>
    UBI: fastmap: Pass to_be_tortured when reusing old fastmap PEBs

Zhihao Cheng <chengzhihao1@huawei.com>
    UBI: Preserve torture flag when rescheduling failed erasures

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: Replace erase_block() with sync_erase()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Allocate memory with GFP_NOFS in ubi_update_fastmap

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: erase_block: Get erase counter from wl_entry rather than flash

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix missed ec updating after erasing old fastmap data block

LiangCheng Wang <zaq14760@gmail.com>
    ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: pxa: Use devm_clk_get_optional() for extclk clock

Petr Oros <poros@redhat.com>
    ice: clear the default forwarding VSI rule when releasing a VSI

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/cma: Fix WARNING in res_to_rt

Fan Wu <fanwu01@zju.edu.cn>
    RDMA/cxgb4: Free debugfs on registration failure

Guangshuo Li <lgs201920130244@gmail.com>
    dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal

Yun Zhou <yun.zhou@windriver.com>
    nfc: nci: fix use of uninitialized memory in CORE_INIT_RSP parsing

Linmao Li <lilinmao@kylinos.cn>
    nfc: digital: Do not dump a NULL response in command completion

Yinhao Hu <dddddd@hust.edu.cn>
    nfc: pn533: hold a reference to the request skb during send_frame

Doruk Tan Ozturk <doruk@0sec.ai>
    nfc: llcp: bound SNL TLV parsing to the skb and add length checks

Zhenghang Xiao <kipreyyy@gmail.com>
    nfc: nci: fix double completion race in nci_data_exchange_complete

Breno Leitao <leitao@debian.org>
    nfc: llcp: read llcp_sock->local under the socket lock in getsockopt

Breno Leitao <leitao@debian.org>
    nfc: llcp: avoid userspace overflow on invalid optlen

Chao Shi <coshi036@gmail.com>
    nvme: reject passthrough of driver-managed Set Features

Yang Xiuwei <yangxiuwei@kylinos.cn>
    nvme/ioctl: check SUBMIT_IO with nvme_cmd_allowed()

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix NULL pointer dereference in nvmet_execute_identify_ns_zns()

Sven Peter <sven@kernel.org>
    nvme-apple: Drop the PRP null check chicken bit

Nick Chan <towinchenmi@gmail.com>
    nvme: apple: Add Apple A11 support

Sven Peter <sven@kernel.org>
    nvme-apple: Never set the opcode in the NVMMU TCB

Sven Peter <sven@kernel.org>
    nvme-apple: Don't set a DMA direction for commands without a data transfer

Sven Peter <sven@kernel.org>
    nvme-apple: Destroy the admin queue on removal

Guixin Liu <kanie@linux.alibaba.com>
    nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()

Alistair Francis <alistair.francis@wdc.com>
    nvme: Add the DHCHAP maximum HD IDs

Guixin Liu <kanie@linux.alibaba.com>
    nvme: introduce change ptpl and iekey definition

Guixin Liu <kanie@linux.alibaba.com>
    nvme: add reservation command's defines

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    ASoC: qcom: q6apm: keep the graph start count in sync with the DSP

Babanpreet Singh <bbnpreetsingh@gmail.com>
    spi: sprd-adi: Fix probe succeeding without registering the controller

Esteban Urrutia <esteuwu@proton.me>
    phy: qcom: qmp-combo: Correct pre-emphasis table for QMP v4 DP PHYs

Michael Walle <mwalle@kernel.org>
    powerpc/configs: enable CONFIG_RAS to fix EDAC support

Runyu Xiao <runyu.xiao@seu.edu.cn>
    sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE

Weiming Shi <bestswngs@gmail.com>
    SUNRPC: check rpc_sockaddr2uaddr() return value in rpcb_register_inet4/6

Marco Elver <elver@google.com>
    arm64: Disable KCSAN instrumentation in delay.o

Karl Mehltretter <kmehltretter@gmail.com>
    m68k: Fix backtraces for non-running tasks

Desnes Nunes <desnesn@redhat.com>
    iommu/vt-d: Fix UCTP context table slot when copying root entries

Danila Chernetsov <listdansp@mail.ru>
    fbdev: kyro: Validate overlay viewport coordinates

Myeonghun Pak <mhun512@gmail.com>
    fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix uninitialized pthread_join

Ian Rogers <irogers@google.com>
    perf stat: Fix evsel_list leak in cmd_stat

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add SATA regulator supplies

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add vcc-supply to GPIO expander

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add vcc-supply to EEPROM

Tomáš Macholda <tomas.macholda@nic.cz>
    arm64: dts: turris-mox: fix usb3 phys

Guodong Xu <guodong@riscstar.com>
    riscv: cpufeature: Clarify ISA spec version for canonical order

Victor Nogueira <victor@mojatatu.com>
    net/sched: cls_api: fix teardown of an adopted proto on insert-race loss

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: gp2ap002: re-enable irq if runtime suspend fails

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: MSFT: validate evt_prefix_len against the response length

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: MGMT: free the mesh send cancel command when it is cancelled

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_sync: free the advertising instance on the failure and cancel paths

Linmao Li <lilinmao@kylinos.cn>
    Bluetooth: hci_conn: fix the SCO setup context lifetime

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btintel: Fix diagnostics event detection

HyeongJun An <sammiee5311@gmail.com>
    Bluetooth: virtio_bt: avoid OOB read of build info string

Yichong Chen <chenyichong@uniontech.com>
    btrfs: retry verity reads for not-uptodate Merkle folios

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: Fix sd_done() sense handling condition

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix integer truncation in do_read() and skip()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Record matched usb_device_id into btusb_data

Johan Hovold <johan@kernel.org>
    Bluetooth: btusb: refactor endpoint lookup

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Fix BD_ADDR byte order in btusb_set_bdaddr_wcn6855()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btqca: Fix qca_set_bdaddr() waiting for wrong HCI event

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    sched/fair: Check CPU capacity before comparing group types during load balance

Yuho Choi <dbgh9129@gmail.com>
    ACPI: video: Release PCI device reference after lookup

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: qcom-rpmh: Fix PMIC5 BOB bypass mode handling

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix leaked trace id

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix underflow for usage of (nrseqstate - 1)

James Clark <james.clark@linaro.org>
    coresight: Change syncfreq to be a u8

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: etm4x: fix wrong check of etm4x_sspcicrn_present()

Bruce Johnston <bjohnsto@redhat.com>
    md/raid1: don't set array_frozen in raid1_takeover()

Yu Kuai <yukuai@fygo.io>
    md: avoid stale clone I/O accounting timestamps

Yu Kuai <yukuai@fygo.io>
    md/raid5: round bitmap stripes with sector division

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: qmp-usb: Fix possible NULL-deref on early runtime suspend

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: snps-femto-v2: Fix possible NULL-deref on early runtime suspend

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: qmp-usb-legacy: Fix possible NULL-deref on early runtime suspend

Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
    phy: qcom: sgmii-eth: vote for both voltage rails with correct current loads

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    phy: qcom-sgmii-eth: relax order of .power_on() vs .set_mode*()

Linkai Gong <gonglinkai@kylinos.cn>
    soc: fsl: qe: check platform_driver_register() in qe_ic_of_init()

Yichong Chen <chenyichong@uniontech.com>
    hugetlbfs: release subpool on fill_super failure

Simon Glass <sjg@chromium.org>
    pinctrl: rockchip: Reset the pin count when recalculating SoC data

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware_loader: do not queue completed sysfs fallback requests

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Use PFP on the compute queues too

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Fixup emitting SWITCH_BUFFER packets

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix buffer overflow in read_string()

Gerald Loacker <gerald.loacker@wolfvision.net>
    phy: rockchip: phy-rockchip-inno-csidphy: fix rk1808 hsfreq table

Felix Gu <ustc.gu@gmail.com>
    phy: sunplus: fix error handling in sp_uphy_init()

Meghana Malladi <m-malladi@ti.com>
    arm64: dts: ti: k3-am64: Fix MDIO clock reference for ICSSG0 node

Jan Kara <jack@suse.cz>
    ext4: fix spurious message about orphan cleanup on RO fs

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Fixup emit_cntxcntl()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mfd: iqs62x: Reject zero-length firmware records

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mfd: rave-sp: validate received frame payload lengths

Vladimir Murzin <vladimir.murzin@arm.com>
    arm64: hibernate: Restore DAIF state on error

Ada Couprie Diaz <ada.coupriediaz@arm.com>
    arm64: hibernate: mask DAIF before restoring hibernated kernel

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: skip default WMM setup for AP_VLAN links

Leon Romanovsky <leon@kernel.org>
    RDMA/erdma: restrict the driver to little-endian systems

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    RDMA/siw: Fix use-after-free in siw_accept()

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Introduce siw_free_cm_id

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: post the full-feature receive buffers after session registration

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: delay the final Login Response until the session is registered

Karl Mehltretter <kmehltretter@gmail.com>
    cpufreq: imx6q: fix out-of-bounds write when probed more than once

Karl Mehltretter <kmehltretter@gmail.com>
    cpufreq: imx6q: fix devres accumulation across driver rebind

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: hdmi-phy: Fix H6 8-bit MPLL config at 594 MHz

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: dw-hdmi: Drop TCON TOP port reference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon: Drop remote endpoint reference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: crtc: Propagate layer initialization error

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon: Drop TCON TOP device reference

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: tcon: Set output mux for DSI and LVDS

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    of: property: add of_graph_get_next_port_endpoint()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    of: property: add of_graph_get_next_port()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    of: property: use unsigned int return on of_graph_get_endpoint_count()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    of: property: add missing kerneldoc for of_graph_get_endpoint_count()

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: vi scaler: Fix coefficient selection

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: synchronize heartbeat callbacks with o2net teardown

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Hold CQ references when processing EQ events

Robertus Diawan Chris <robertusdchris@gmail.com>
    modpost: prevent leak when early return no suffix .o in read_symbols()

Sergei Litvin <litvindev@gmail.com>
    scripts/tags.sh: Prevent binary files appearing in cscope.files

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix ternary operator precedence in ksm_tests

Sayali Patil <sayalip@linux.ibm.com>
    selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes

Mike Rapoport (Microsoft) <rppt@kernel.org>
    selftests/mm: ksm_tests: use kselftest framework

Li Wang <liwang@redhat.com>
    ksm_tests: skip hugepage test when Transparent Hugepages are disabled

Donet Tom <donettom@linux.ibm.com>
    selftests/mm: add new test cases to the migration test

Baolin Wang <baolin.wang@linux.alibaba.com>
    selftests: mm: support shmem mTHP collapse testing

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm/khugepaged: enlighten for multi-size THP

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm: support multi-size THP interface in thp_settings

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm: factor out thp settings management

Ryan Roberts <ryan.roberts@arm.com>
    selftests/mm/kugepaged: restore thp settings at exit

Pu Lehui <pulehui@huawei.com>
    bpf, cgroup: Fix invalid storage access after __cgroup_bpf_attach failed

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: use rsc_table_for_each_entry() in rproc_handle_resources()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: Move resource table data structure to its own header

Andreas Kemnade <andreas@kemnade.info>
    drm/omap: dsi: Do not copy isr table

Yichong Chen <chenyichong@uniontech.com>
    fat: release buffer head after rebuilding parent

Guangshuo Li <lgs201920130244@gmail.com>
    rapidio: clear mport->net when rio_add_net() fails

Calvin Owens <calvin@wbinvd.org>
    pps-gpio: remove dead capture_clear code

Michael Byczkowski <by@by-online.de>
    pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler

Bastien Curutchet <bastien.curutchet@bootlin.com>
    pps: clients: gpio: Bypass edge's direction check when not needed

Calvin Owens <calvin@wbinvd.org>
    pps: don't try to wait for negative timeouts in PPS_FETCH

Bradley Morgan <include@grrlz.net>
    lib/string: fix memchr_inv() for large ranges

Caleb Sander Mateos <csander@purestorage.com>
    ublk: check for ublk_unmap_io() returning 0

Tao Cui <cuitao@kylinos.cn>
    block/kyber-iosched: flush per-cpu latency buckets over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-iocost: collect per-cpu latency stats over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-stat: drain per-cpu callback stats over possible CPUs

Zheng Qixing <zhengqixing@huawei.com>
    blk-cgroup: skip dying blkg in blkcg_activate_policy()

Breno Leitao <leitao@debian.org>
    phonet: pep: do not write beyond optlen in getsockopt

Sang-Heon Jeon <ekffu200098@gmail.com>
    iio: light: tsl2583: return zero in write_raw() on success

Sang-Heon Jeon <ekffu200098@gmail.com>
    iio: light: isl29028: return zero in write_raw() on success

Yuanshen Cao <alex.caoys@gmail.com>
    iio: light: tsl2772: fix ALS calibscale readback

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf intel-bts: Fix off-by-one in auxtrace_info minimum size check

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf intel-pt: Fix off-by-one in auxtrace_info minimum size check

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf auxtrace: Fix queue grow overflow and old array leak

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf thread-stack: Fix heap buffer overflow on branch stack wrap copy

Jiancheng Huang <jchuang@seu.edu.cn>
    HID: lg4ff: validate report length before fixed offsets

Chao Huang <huangchao@kylinos.cn>
    HID: i2c-hid: goodix: Disable VDD on VDDIO enable failure

Ai Chao <aichao@kylinos.cn>
    HID: i2c-hid: Fix "(null)" output when reading report descriptor fails

Kenny Levinsen <kl@kl.wtf>
    HID: i2c-hid: Revert to await reset ACK before reading report descriptor

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Move i2c_hid_finish_hwreset() to after reading the report-descriptor

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Switch i2c_hid_parse() to goto style error handling

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Split i2c_hid_hwreset() in start() and finish() functions

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Fold i2c_hid_execute_reset() into i2c_hid_hwreset()

Yousef Alhouseen <alhouseenyousef@gmail.com>
    HID: synchronize input before cleaning up a failed probe

谢致邦 (XIE Zhibang) <Yeking@Red54.com>
    HID: i2c-hid: Refactor _DSM helper and add i2c-hid-acpi-prp0001 driver

Karl Mehltretter <kmehltretter@gmail.com>
    tty: clear cdev pointer after cdev_add() failure

Karl Mehltretter <kmehltretter@gmail.com>
    serial: amba-pl011: unprepare console clock on unregister

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL

Saket Kumar Bhaskar <skb99@linux.ibm.com>
    powerpc/irq: Fix missing r2 clobber in PCREL inline assembly

Gou Hao <gouhao@uniontech.com>
    powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    firmware: coreboot: Validate table bounds

Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
    firmware: google: Add bounds checks in coreboot_table_populate()

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: skip unused probe response countdown offsets

Slawomir Stepien <sst@poczta.fm>
    wifi: zd1211rw: reject secondary interfaces to prevent conflicts

Zhao Li <enderaoelyther@gmail.com>
    wifi: mac80211: send TWT teardown to peer after setup TX failure

Davidlohr Bueso <dave@stgolabs.net>
    perf/cxlpmu: Fix 64-bit write to 32-bit HDM filter register

Pranjal Shrivastava <praan@google.com>
    iommu/arm-smmu-v3: Convert to use atomic poll timeout

Linghui Wu <linghui.wu@oss.qualcomm.com>
    wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: report RX chain signal for all RX paths

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1

StanleyYP Wang <StanleyYP.Wang@mediatek.com>
    wifi: mt76: mt7996: fix reg addr remap when addr is 0

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: release hif2 reference on probe IRQ failure

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix ext PHY use-after-free on register error path

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: fix double hif2 init on the non-WED path

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Check snprintf truncation for guest kallsyms path

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Free scandir entries in guest kernel map creation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Reset errno before strtol in guest kernel map creation

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Don't abort guest map creation on first inaccessible dir

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Check snprintf truncation in machines__findnew()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Use snprintf() for guestmount path construction

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Guard against NULL strlist in machines__findnew()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf machine: Fix NULL parent dereference in fork event processing

Joy Zou <joy.zou@oss.nxp.com>
    regulator: core: use system_freezable_wq for init complete work

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix leak in ath11k_service_ready_ext_event()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dsi: Drop dev_pm_opp_set_rate(0)

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dpu: Drop sneaky dev_pm_opp_set_rate(0)

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Make wakeup range check overflow safe

Can Peng <pengcan@kylinos.cn>
    ACPI: processor: Unregister cpufreq notifier on init failure

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Optimize ACPI idle driver registration

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: don't report a zero TX bitrate

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset

Eason Lai <Eason.Lai@mediatek.com>
    wifi: mt76: mt792x: Fix memory leak in SDIO TX path

Zhi-Jun You <hujy652@gmail.com>
    wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7921: validate CLC firmware records

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length

Yichong Chen <chenyichong@uniontech.com>
    fanotify: report full event length for FIONREAD

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    misc: vmc_vmci: Fix potential memory leak in vmci_event_subscribe()

Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
    locking/lockdep: Fix NULL pointer dereference in __lock_set_class()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix device_register() error path

Jakub Kicinski <kuba@kernel.org>
    i3c: dw: avoid shift-out-of-bounds when DAA assigns no devices

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    swiotlb: Preserve allocation virtual address for dynamic pools

Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
    iommu/dma: Check atomic pool allocation result directly

Vladimir Zapolskiy <vz@kernel.org>
    clk: qcom: Return expected ENOMEM error on dynamic allocation failure

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF when reading bpf link info

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF in bpf_netns_link_update_prog

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: sc2731_charger: cancel work on remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: sc2731_charger: Convert to platform remove callback returning void

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: isp1704_charger: cancel work on remove

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <mani@kernel.org>
    arm64: dts: qcom: sm8550: Fix the msi-map entries

Neil Armstrong <neil.armstrong@linaro.org>
    arm64: dts: qcom: sm8550: Use GIC-ITS for PCIe0 and PCIe1

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sc8180x: drop duplicated PCI iommus property

Dawid Wróbel <me@dawidwrobel.com>
    arm64: dts: qcom: sm8250-xiaomi-elish: correct the board ID

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8280xp-crd: Fix the pin index for misc_3p3_reg_en

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    clk: qcom: gcc-qcm2290: don't park QUP RCGs upon registration

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sdm632-motorola-ocean: Fix LED default trigger property

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8998: Don't pull-up I2C pins by default in sleep

Itai Handler <itai.handler@gmail.com>
    rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs

Valentin Schneider <vschneid@redhat.com>
    rcu: Rename rcu_momentary_dyntick_idle() into rcu_momentary_eqs()

Yue Haibing <yuehaibing@huawei.com>
    rcu: Remove unused function declaration rcu_eqs_special_set()

Cheng-Han Wu <hank20010209@gmail.com>
    selftests/zram: fix kernel_gte() for POSIX sh

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc/powerpc: mark ctr and xer as clobbered by system call

Sajal Gupta <sajal2005gupta@gmail.com>
    md/raid5-ppl: fix use-after-free in ppl_do_flush()

Chen Cheng <chencheng@fnnas.com>
    md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    bus: mhi: host: Flush the posted write after writing to MHI_SOC_RESET_REQ_OFFSET

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtlwifi: pci: fix error path in rtl_pci_probe()

Hongyan Xu <getshell@seu.edu.cn>
    platform/chrome: cros_ec_debugfs: Unregister panic notifier

Hongyan Xu <getshell@seu.edu.cn>
    platform/chrome: cros_ec_debugfs: Clean up console log on probe failure

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()

Kang Yang <quic_kangyang@quicinc.com>
    wifi: ath11k: implement handling of P2P NoA event

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: ath11k: refactor ath11k_wmi_tlv_parse_alloc()

Anilkumar Kolli <quic_akolli@quicinc.com>
    wifi: ath11k: add firmware-2.bin support

Kalle Valo <quic_kvalo@quicinc.com>
    wifi: ath11k: qmi: refactor ath11k_qmi_m3_load()

Fan Wu <fanwu01@zju.edu.cn>
    spi: davinci: switch to managed controller allocation

Bastien Curutchet <bastien.curutchet@bootlin.com>
    spi: davinci: Unset POWERDOWN bit when releasing resources

Li Zetao <lizetao1@huawei.com>
    spi: davinci: Use helper function devm_clk_get_enabled()

Guixin Liu <kanie@linux.alibaba.com>
    nvme-fc: unmap cmd_iu DMA on rsp_iu mapping failure in init_request

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: reject login PDUs declaring more data than was received

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: reject PDUs declaring more data than was received

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: free STAG index when TPT entry write fails

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Send cong param changes to the resolved port mdev

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs

David Strahan <David.Strahan@microchip.com>
    scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert nilfs_page_bug() to nilfs_folio_bug()

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert nilfs_btnode_commit_change_key to use a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert nilfs_btnode_prepare_change_key to use a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert to nilfs_folio_buffers_clean()

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert nilfs_forget_buffer to use a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: add nilfs_end_folio_io()

David Lee <david.lee@trailofbits.com>
    nilfs2: prevent out-of-bounds read in super root block parsing

Joshua Crofts <joshua.crofts1@gmail.com>
    nilfs2: fix infinite loop in nilfs_clean_segments()

Alexey Charkov <alchark@flipper.net>
    clk: rockchip: Fix the fractional part denominator on RK3588/RK3576 PLLs

Akari Tsuyukusa <akkun11.open@gmail.com>
    clk: mediatek: mt8135: Fix inverted gate control for devapc_ck

longlong yan <yanlonglong@kylinos.cn>
    clk/x86: pmc_atom: add kasprintf return value check

Myeonghun Pak <mhun512@gmail.com>
    clk: palmas: Manage external-control prepare with devm

Guangshuo Li <lgs201920130244@gmail.com>
    clk: tegra: tegra124-emc: put EMC node on register failure

Ondrej Jirman <megi@xff.cz>
    arm64: dts: allwinner: sun50i-a64-pinephone: Fix mpu6050 mount matrix

Yonatan Nachum <ynachum@amazon.com>
    RDMA/efa: Fix PBL chunk length computation

Weiming Shi <bestswngs@gmail.com>
    fs/ntfs3: reject restart table growth beyond U16_MAX entries

Ivy Lopez <skunkolee@gmail.com>
    staging: rtl8723bs: use kfree_sensitive() for key material

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Prevent crash handling to race with rproc_del()

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: Attach rproc asynchronously in rproc_add() path via schedule_work()

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Allow shutdown of crashed processors

Peng Fan <peng.fan@nxp.com>
    remoteproc: core: Drop redundant initialization of 'ret' in rproc_shutdown()

Babanpreet Singh <bbnpreetsingh@gmail.com>
    w1: ds2482: Fix signedness bug in ds2482_w1_triplet()

Yichong Chen <chenyichong@uniontech.com>
    isofs: release zisofs block pointer buffer head

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Fix integer overflow of user QP buffer size

Can Peng <pengcan@kylinos.cn>
    crypto: keembay - publish OF module alias for OCS AES/SM4

Linmao Li <lilinmao@kylinos.cn>
    crypto: keembay - Initialize completion before requesting IRQ

Li Qiang <liqiang01@kylinos.cn>
    scsi: ufs: debugfs: Reserve space for a string terminator

Babanpreet Singh <bbnpreetsingh@gmail.com>
    power: supply: sbs-battery: Use a per-device serial number buffer

James Clark <james.clark@linaro.org>
    tools/build: Allow versioning of all LLVM tools defined in Makefile.include

Tomas Glozar <tglozar@redhat.com>
    tools/build: Add bpftool-skeletons feature test

Justin Yeh <justin.yeh@mediatek.com>
    pinctrl: mediatek: free EINT resources on unbind

Nícolas F. R. A. Prado <nfraprado@collabora.com>
    pinctrl: mediatek: eint: Fix invalid pointer dereference for v1 platforms

Hao Chang <ot_chhao.chang@mediatek.com>
    pinctrl: mediatek: Fix the invalid conditions

Hao Chang <ot_chhao.chang@mediatek.com>
    pinctrl: mediatek: Add EINT support for multiple addresses

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: mediatek: Use C99 initializers in PINCTRL_PIN_GROUP()

Alison Schofield <alison.schofield@intel.com>
    cxl/region: Fix use-after-free in find_pos_and_ways() error path

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix memory leak on subtest_states reallocation

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix incorrect error checking for pthread_create

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: lpc32xx: only run SoC init on LPC32xx hardware

Fabio Estevam <festevam@gmail.com>
    arm64: dts: rockchip: Fix Gru WLAN sideband interrupt

Weiming Wu <weiming3@asu.edu>
    fs/ntfs3: fix out-of-bounds read of INDEX_ROOT in reparse/objid init

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet

Can Peng <pengcan@kylinos.cn>
    drm/tve200: add OF module alias for autoloading

Cosmo Chou <chou.cosmo@gmail.com>
    leds: pca9532: Fix phantom device registration on missing hardware

Malaya Kumar Rout <malayarout91@gmail.com>
    PM: hibernate: Fix memory leak in snapshot_write_next() error path

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    xfrm: Fix skb double-free in xfrm_dev_direct_output()

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Avoid truncating AUX buffer sizes to int

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Flush thread stacks after decoder reset

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unrequest devices if driver registration fails

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Add multiple protocols registration support

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: allwinner: a10: Fix PMU interrupt

Xiang Mei <xmei5@asu.edu>
    ext4: check dir entry fits before reading the hash trailer in ext4_search_dir()

Guanghui Yang <3497809730@qq.com>
    ext4: fix buffer_head leak in ext4_init_orphan_info

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: Correctly copy the hint BSSID in WMI scan request

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath12k: Correctly copy the hint BSSID in WMI scan request

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath6kl: avoid buffer overreads in WMI event handlers

Baokun Li <libaokun@linux.alibaba.com>
    ext4: drain in-flight DIO before buffered write fallback

Gerald Yang <gerald.yang@canonical.com>
    ext4: clear stale xarray tags on folios skipped during writeback

Pengpeng Hou <pengpeng@iscas.ac.cn>
    thermal: intel: int3400: clean up ODVP on probe failures

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Fix inverted fault report check in qcom_iommu_fault()

Haoxiang Li <haoxiang_li2024@163.com>
    iommu/qcom: Remove sysfs device on probe failure path

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Fix requested device removal race

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_dealloc_pd_user()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_free_cq()

Mark Zhang <markzhang@nvidia.com>
    RDMA/core: Add driver APIs pre_destroy_cq() and post_destroy_cq()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in counter_release()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_destroy_srq_user()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix potential use after free in ib_destroy_cq_user()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Fix use after free in ib_query_qp()

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Add rdma_restrack_begin/abort/commit_del() operations

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/nldev: Fix locking when accessing mr->pd

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/restrack: Fix typos in the comments

Chiara Meiohas <cmeiohas@nvidia.com>
    RDMA/core: Add an option to display driver-specific QPs in the rdmatool

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/core: Add support to set privileged QKEY parameter

Myeonghun Pak <mhun512@gmail.com>
    RDMA/erdma: Fix CEQ tasklet use-after-free on removal

Takuma Fujiwara <t-fujiwara1@ti.com>
    PCI: j721e: Fix incorrect max_lanes for J7200

Leon Romanovsky <leon@kernel.org>
    RDMA/srpt: Pass the mapped task attribute to target_init_cmd()

Ricardo B. Marlière <rbm@suse.com>
    libbpf: Search /lib64 and /lib in resolve_full_path()

Yun Zhou <yun.zhou@windriver.com>
    ext4: skip extra isize expansion during mount to prevent deadlock

Xiang Mei <xmei5@asu.edu>
    ext4: fix out-of-bounds read in ext4_read_inline_dir()

Yun Zhou <yun.zhou@windriver.com>
    ext4: fix circular lock dependency in ext4_ext_migrate

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear driver_data on all paths that free the acpi_pci_root

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ACPI: processor: validate MADT IOAPIC entry bounds

Zhu Ling <zhuling2709@phytium.com.cn>
    ACPI: EC: Avoid _REG disconnect on GPIO IRQ defer

Pengpeng Hou <pengpeng@iscas.ac.cn>
    RDMA/nldev: validate dynamic counter attribute length

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()

Viktor Malik <vmalik@redhat.com>
    selftests/bpf: Silence array bounds warning in global_map_resize

Marco Elver <elver@google.com>
    kcsan: avoid unintended access checking in NMIs

TanZheng <tanzheng@kylinos.cn>
    RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters

Ibrahim Hashimov <security@auditcode.ai>
    RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]

Danila Chernetsov <listdansp@mail.ru>
    RDMA/hfi1: Propagate sdma_txinit_ahg() errors

Jun Yan <jerrysteve1101@gmail.com>
    arm64: dts: amlogic: meson-axg-s400: enable mipi_pcie_analog_dphy for PCIe

Can Peng <pengcan@kylinos.cn>
    phy: starfive: Fix runtime PM cleanup in JH7110 DPHY RX probe

Linmao Li <lilinmao@kylinos.cn>
    ASoC: meson: Keep link pointers valid on realloc failure

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Clear stale requests on termination

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Serialize channel state checks

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Serialize abort state updates

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Terminate all descriptors without callbacks

Yuho Choi <dbgh9129@gmail.com>
    driver core: soc: Unregister bus on early device registration failure

Alban Bedel <alban.bedel@lht.dlh.de>
    software node: Fix software_node_get_reference_args() with index -1

Ian Rogers <irogers@google.com>
    perf ui hists: Fix uninitialized stack memory free on pstack allocation failure

zhouminqiang <zhouminqiang2@huawei.com>
    mtd: part: reject MTDPART_OFS_RETAIN in mtd_add_partition()

Ruoyu Wang <ruoyuw560@gmail.com>
    mtd: mtdswap: Avoid freeing registered blktrans device twice

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: ti: knav_qmss: Remove debugfs file on teardown

Md Shofiqul Islam <shofiqtest@gmail.com>
    soc: ti: knav_qmss_queue: Implement resource cleanup in remove()

Xiang Mei <xmei5@asu.edu>
    vfio/pci: clear vdev->msi_perm after freeing it on init failure

Myeonghun Pak <mhun512@gmail.com>
    char: xilinx_hwicap: unregister class on init errors

Pei Xiao <xiaopei01@kylinos.cn>
    ipack: ipoctal: fix UAF, null-ptr-deref, and use-after-free in cleanup on remove

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    tty: ipoctal: convert to u8 and size_t

Linmao Li <lilinmao@kylinos.cn>
    ppdev: prevent overflow when setting port timeout

Breno Leitao <leitao@debian.org>
    cacheinfo: don't propagate DT/ACPI error when arch supplies info (arm64)

Pengpeng Hou <pengpeng@iscas.ac.cn>
    misc: ad525x_dpot: use driver core groups for sysfs files

Gleb Markov <markov.gi@npc-ksb.ru>
    misc: rtsx: add missing write register handling

Gui-Dong Han <hanguidong02@gmail.com>
    misc: bcm-vk: Use acquire/release for msgq_inited

Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
    speakup: keyhelp: guard letter_offsets possible out-of-range indexing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    accessibility: speakup: Fix incorrect string length computation in report_char_chartab_status()

Yuho Choi <dbgh9129@gmail.com>
    uio: Fix stale info pointer in failed registration path

David Lee <david.lee@trailofbits.com>
    UDF symlink pathComponent header OOB read

Karl Mehltretter <kmehltretter@gmail.com>
    tty: hvc: restrict HVC_DCC to ARMv6+ and ARM64

Xu Yang <xu.yang_2@nxp.com>
    usb: gadget: f_uac1_legacy: remove broken string configfs attributes

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: processor: idle: Expand _LPI package sanity checks

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: sl3516 - drop invalid sg_dma_len checks before DMA mapping

Pu Lehui <pulehui@huawei.com>
    bpf: Sync tail_call_reachable with callee state on entry

Shivam Rawat <shivrawa@qti.qualcomm.com>
    drm/msm/a6xx: Fix stale rpmh votes after suspend

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Avoid stack over-read in debug output helpers

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix offset calculation in trace_write_gather

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: pass correct argument to function

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: check SAP message length before reading it

Avraham Stern <avraham.stern@intel.com>
    wifi: iwlwifi: mei: add support for SAP version 4

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs

Ian Rogers <irogers@google.com>
    perf jevents: Add more components to the metric sorting order

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: correct frequencies in the Iris OPP table

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    arm64: dts: qcom: sm8250: sort out Iris power domains

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: msm8996-xiaomi-gemini: Fix up ti,drv2604 enable GPIO

Maoyi Xie <maoyixie.tju@gmail.com>
    drm/bridge: tc358767: clamp the reported AUX read size to the request

Uday Khare <udaykhare77@gmail.com>
    remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Fix setting minimum P-state at init time

Biren Pandya <birenpandya@gmail.com>
    media: i2c: rdacm21: Fix missing media_entity_cleanup()

Qingshuang Fu <fuqingshuang@kylinos.cn>
    irqchip/renesas-irqc: Fix generic interrupt chip leak on remove

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Add support for generic irq chips creation before publishing a domain

Herve Codina <herve.codina@bootlin.com>
    genirq/generic_chip: Introduce irq_domain_{alloc,remove}_generic_chips()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Introduce init() and exit() hooks

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Handle domain hierarchy parent in irq_domain_instantiate()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Handle additional domain flags in irq_domain_instantiate()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Introduce irq_domain_instantiate()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Introduce irq_domain_free()

Yuho Choi <dbgh9129@gmail.com>
    PCI: xgene: Drop unnecessary OF node reference

Marc Zyngier <maz@kernel.org>
    PCI: xgene: Drop XGENE_PCIE_IP_VER_UNKN

Dan Carpenter <error27@gmail.com>
    cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()

John Groves <John@Groves.net>
    dax: read holder_ops once in dax_holder_notify_failure()

Bryam Vargas <hexlabsecurity@proton.me>
    libnvdimm/labels: Bound the on-media label size before the shift

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Drop handle on protocol bind failures

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Protect device request lookup with RCU

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Use channel ID for transport teardown

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Reject out of range DT protocol IDs

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Avoid IDR updates while cleaning channels

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Free transport channel on IDR failure

Sudeep Holla <sudeep.holla@kernel.org>
    firmware: arm_scmi: Unregister device notifier before IDR teardown

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: cap out-of-range rx MCS instead of leaving bogus rate

Kyle Zeng <kylebot@openai.com>
    hfsplus: validate thread record before delete key rebuild

HE WEI（ギカク） <skyexpoc@gmail.com>
    fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()

Nirbhay Sharma <nirbhay.lkd@gmail.com>
    fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Mark inode as bad as soon as error detected in mi_enum_attr()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Add more checks in mi_enum_attr (part 2)

Dave Jiang <dave.jiang@intel.com>
    cxl/pci: Honor -EPROBE_DEFER from component register setup

Robert Richter <rrichter@amd.com>
    cxl/pci: Store the endpoint's Component Register mappings in struct cxl_dev_state

Dave Jiang <dave.jiang@intel.com>
    cxl/mbox: Break poison list loop on an empty payload

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    rpmsg: glink: fix deadlock in endpoint destroy during driver detach

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: remove duplicate code for rpmsg device remove

Hans Verkuil <hverkuil+cisco@kernel.org>
    media: v4l2-async: Unregister sub-device if asc_list is empty

Sebastian Reichel <sre@kernel.org>
    media: v4l: async: Drop useless list move operation

Xiang Mei <xmei5@asu.edu>
    isofs: fix out-of-bounds page array access on empty zisofs block

James Calligeros <jcalligeros99@gmail.com>
    ASoC: apple: mca: increase SERDES reset delay

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Initialize debugfs after probe completes

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Stop flushing the global IB workqueue

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Create workqueues before device initialization

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Remove redundant PCI device ID validation

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Free RX data on late probe failure

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Preserve unit 0 on allocation failure

Sean Rhodes <sean@starlabs.systems>
    misc: rtsx_usb: avoid USB I/O in runtime autosuspend

Pengpeng Hou <pengpeng@iscas.ac.cn>
    pmdomain: bcm: bcm2835: handle genpd provider registration errors

Evgenii Burenchev <evg28bur@yandex.ru>
    ALSA: hpi: Check transport errors during HPI6000 adapter initialization

Xiang Mei <xmei5@asu.edu>
    xfrm6: fix out-of-bounds write in xfrm6_input_addr() when secpath is full

Yuho Choi <dbgh9129@gmail.com>
    hwrng: ks-sa - Fix runtime PM cleanup on registration failure

Martin Kaiser <martin@kaiser.cx>
    hwrng: ks-sa - access private data via struct hwrng

Allison Henderson <achender@kernel.org>
    RDMA/rxe: Avoid reprocessing the current packet after the QP enters the error state

Leon Romanovsky <leon@kernel.org>
    RDMA/ipoib: Drain RCU callbacks during module teardown

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Drain RCU callbacks during module teardown

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Wait for RCU callbacks before unloading ib_core

Mert Seftali <mertsftl@gmail.com>
    iio: accel: dmard09: Implement IIO_CHAN_INFO_SCALE

Pengpeng Hou <pengpeng@iscas.ac.cn>
    bus: qcom-ebi2: use managed resources for clocks and children

Pengpeng Hou <pengpeng@iscas.ac.cn>
    soc: qcom: rpmh-rsc: manage PM notifiers with devres

Yu Peng <pengyu@kylinos.cn>
    perf metricgroup: Fix metric expression copy leaks

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    drm/panel: samsung-s6d16d0: Power off on prepare failure

Biju Das <biju.das.jz@bp.renesas.com>
    usb: renesas_usbhs: Fix power-off ordering on unbind

Fei Shao <fshao@chromium.org>
    usb: mtu3: allow system suspend during active gadget connection

Linmao Li <lilinmao@kylinos.cn>
    platform/surface: acpi-notify: Check ACPI companion before use

Linmao Li <lilinmao@kylinos.cn>
    platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL

Gary Guo <gary@garyguo.net>
    usb: fix UAF when probe runs concurrent to dyn ID removal

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: make to_usb_driver() use container_of_const()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: make single lock for all usb dynamic id lists

Yajun Deng <yajun.deng@linux.dev>
    USB: core: Use device_driver directly in struct usb_driver and usb_device_driver

Ruoyu Wang <ruoyuw560@gmail.com>
    usb: gadget: aspeed_udc: check endpoint DMA allocation

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: gadget: aspeed_udc: Convert to platform remove callback returning void

Michael Bommarito <michael.bommarito@gmail.com>
    usb: gadget: configfs: fix out-of-bounds read of qw_sign

Yuho Choi <dbgh9129@gmail.com>
    serial: ma35d1: Fix OF node reference leaks in console init

Wolfram Sang <wsa+renesas@sang-engineering.com>
    hwspinlock: propagate errno when registering single lock

Felix Gu <gu_0233@qq.com>
    remoteproc: qcom_q6v5_adsp: Fix reference leak for device node

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-wmi-base: Fix resource leak on module load failure

Armin Wolf <W_Armin@gmx.de>
    platform/x86: dell-privacy: Fix race condition

Cosmo Chou <chou.cosmo@gmail.com>
    leds: pca9532: Fix inverted GPIO output polarity

Wei Wang <wei.w.wang@hotmail.com>
    iommu/amd: Fix false positive in SB IOAPIC IVRS validation

Fu Hao <fuhao@open-hieco.net>
    iommu/amd: Add support for Hygon family 18h model 4h IOAPIC

Wei Wang <wei.w.wang@hotmail.com>
    iommu/amd: Prevent SB IOAPIC from overriding IVRS validation errors

Vladimir Zapolskiy <vz@kernel.org>
    iommu/msm: Return -ENOMEM on memory allocation failure in probe

Akari Tsuyukusa <akkun11.open@gmail.com>
    iommu/mediatek-v1: Fix off-by-one in MT2701_LARB_NR_MAX

Yuho Choi <dbgh9129@gmail.com>
    bus: mhi: ep: Fix device refcount leak in the error path of MHI device creation

Sanghyun Park <sanghyun.park.cnu@gmail.com>
    bpf: Fix use-after-free on mm_struct in bpf_find_vma()

Breno Leitao <leitao@debian.org>
    efi: fix stale reference to efi_recover_from_page_fault()

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix vmlinux BTF prep race in bpf_get_btf_vmlinux

Aleksandr Nogikh <nogikh@google.com>
    udf: Mark LVID buffer as uptodate before marking it dirty

Hongyan Xu <getshell@seu.edu.cn>
    usb: gadget: r8a66597: avoid double free of ep0_req in probe error path

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    usb: typec: ucsi: unregister debugfs entries on teardown

Dan Carpenter <error27@gmail.com>
    thermal/drivers/rcar: Fix error checking in probe()

Tanushree Shah <tshah@linux.ibm.com>
    perf data convert json: Fix trace_seq memory leak in process_sample_event()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x-lenovo-flex-5g: Rename regulator nodes

Bjorn Andersson <quic_bjorande@quicinc.com>
    arm64: dts: qcom: sc8180x: Enable the power key

Anton Bambura <jenneron@postmarketos.org>
    arm64: dts: qcom: sc8180x-lenovo-flex-5g: move pinctrl to appropriate nodes

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: sc8180x-primus: Rename regulator nodes

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: propagate gdsc_enable() failure for ALWAYS_ON domains

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: propagate gdsc_check_status() errors from gdsc_poll_status

David Woodhouse <dwmw@amazon.co.uk>
    timekeeping: Account for monotonicity adjustment in ntp_error

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    y2038: uapi: Use 64-bit __kernel_old_timespec::tv_nsec on x32

Yuho Choi <dbgh9129@gmail.com>
    clocksource: Unregister subsystem on device registration failure

Jiangshan Yi <yijiangshan@kylinos.cn>
    selftests: timers: leap-a-day: Fix -w option and update usage comment

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Fix its node leak in gic_acpi_parse_madt_its()

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Fix memleak in its_probe_one()

Feng Yang <yangfeng@kylinos.cn>
    selftests/bpf: Fix memory leak in msg_alloc_iov

Malaya Kumar Rout <malayarout91@gmail.com>
    selftests/bpf: Fix memory leak in msg_alloc_iov error path

Evgenii Burenchev <evg28bur@yandex.ru>
    ALSA: via82xx: Remove unreachable branch in snd_via686_pcm_pointer()

Dawei Feng <dawei.feng@seu.edu.cn>
    staging: rtl8723bs: fix mismatched free of HalData in rtw_sdio_if1_init()

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: replace pr_warn with dev_warn in fill and rx paths

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: ethernet-mem: replace pr_warn with dev_warn in free functions

Yuvraj Singh Chauhan <ysinghcin@gmail.com>
    staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown

Ayush Mukkanwar <ayushmukkanwar@gmail.com>
    staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown

Dan Carpenter <error27@gmail.com>
    staging: fbtft: Use sysfs_emit_at() to print to sysfs file

Bryam Vargas <hexlabsecurity@proton.me>
    greybus: audio: bound the topology section sizes against the fetched size

Ahmet Sezgin Duran <ahmet@sezginduran.net>
    staging: sm750fb: gate dualview dataflow using g_dualview

Alexander A. Klimov <grandmaster@al2klimov.de>
    staging: greybus: audio: correct sscanf() return value check

Cen Zhang <zzzccc427@gmail.com>
    wifi: mac80211_hwsim: avoid NULL skb in stop queue drain

Ruoyu Wang <ruoyuw560@gmail.com>
    bus: qcom-ebi2: Fix clock leak on probe failure

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    bus: qcom-ebi2: Simplify with scoped for each OF child loop

Luca Weiss <luca.weiss@fairphone.com>
    arm64: dts: qcom: sm7225-fairphone-fp4: Fix address in fb node name

Haowen Tu <tuhaowen@uniontech.com>
    PM: sleep: Fix off-by-one in wakelocks number limit check

Yuho Choi <dbgh9129@gmail.com>
    bus: ti-sysc: Fix /chosen node reference leak

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet-rdma: fix response resource leak on queue teardown

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet-rdma: factor out response resource cleanup

Guixin Liu <kanie@linux.alibaba.com>
    nvmet-rdma: use sbitmap to replace rsp free list

Hannes Reinecke <hare@suse.de>
    nvmet-rdma: avoid circular locking dependency on install_queue()

Gui-Dong Han <hanguidong02@gmail.com>
    nvme-apple: Use acquire/release for queue enabled state

Myeonghun Pak <mhun512@gmail.com>
    crypto: keembay - Fix AEAD unregister count in error path

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: rk3288 - fail ahash requests on HASH idle timeout

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: sa2ul - stop probe if context pool creation fails

Lothar Rubusch <l.rubusch@gmail.com>
    crypto: atmel-sha204a - fix heap info leak on I2C transfer failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - reject hardware ECDH without a public key

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - clean up and improve ECDH comments

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - replace min_t with min

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - clear AES key schedule from stack

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Add group validation

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Refactor uncore management

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Fix thread leaks on trace queue init failure

James Clark <james.clark@linaro.org>
    perf cs-etm: Queue context packets for frontend

James Clark <james.clark@arm.com>
    perf cs-etm: Create decoders after both AUX and HW_ID search passes

Besar Wicaksono <bwicaksono@nvidia.com>
    perf cs-etm: Fix incorrect or missing decoder for raw trace

Pengpeng Hou <pengpeng@iscas.ac.cn>
    wifi: rtw89: fix HE extended capability length check

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: sensorhub: Fix memory overread in ring handler

Hisam Mehboob <hisamshar@gmail.com>
    selftests/rseq: Replace glibc-specific __GNUC_PREREQ with portable check

Hanlin Song <pgeorge8929@gmail.com>
    csky: Fix a4/a5 restoration in syscall trace path

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: orientation: hid-sensor-rotation: Avoid race between callback setup and device exposure

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    soundwire: qcom: Fix port exhaustion check in stream_alloc_ports

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure

Leon Hwang <leon.hwang@linux.dev>
    bpf: Copy per-CPU map value padding in copy_map_value_long()

Yichong Chen <chenyichong@uniontech.com>
    tools/bpf/bpftool: Reset vmlinux BTF after struct_ops commands

Yichong Chen <chenyichong@uniontech.com>
    tools/bpf/bpftool: Reset vmlinux BTF after map commands

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in Vega10 lookup

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in SMU7 lookup

Uday Khare <udaykhare77@gmail.com>
    regulator: tps6594: Fix device node reference leaks in multiphase loop

Michael Walle <mwalle@kernel.org>
    regulator: tps6594-regulator: refactor variant descriptions

Michael Walle <mwalle@kernel.org>
    regulator: tps6594-regulator: remove hardcoded buck config

Michael Walle <mwalle@kernel.org>
    regulator: tps6594-regulator: remove interrupt_count

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    regulator: tps6594-regulator: Constify struct tps6594_regulator_irq_type

Thomas Richard <thomas.richard@bootlin.com>
    regulator: tps6594-regulator: Fix the number of irqs for TPS65224 and TPS6594

Nirmala Devi Mal Nadar <m.nirmaladevi@ltts.com>
    regulator: tps6594-regulator: Add TI TPS65224 PMIC regulators

Nirmala Devi Mal Nadar <m.nirmaladevi@ltts.com>
    mfd: tps6594: Add register definitions for TI TPS65224 PMIC

Ian Rogers <irogers@google.com>
    perf tests: Fix flakiness in BPF counters test on hybrid systems

Namhyung Kim <namhyung@kernel.org>
    perf test: Fix perf stat --bpf-counters on hybrid machines

Tengda Wu <wutengda@huaweicloud.com>
    perf test: Use sqrtloop workload to test bperf event

Veronika Molnarova <vmolnaro@redhat.com>
    perf test stat_bpf_counter.sh: Stabilize the test results

Ian Rogers <irogers@google.com>
    perf test bpf-counters: Add test for BPF event modifier

Thomas Richter <tmricht@linux.ibm.com>
    perf test: raise limit to 20 percent for perf_stat_--bpf-counters_test

Ian Rogers <irogers@google.com>
    perf tests: Skip metrics validation if system-wide recording lacks permission

Namhyung Kim <namhyung@kernel.org>
    perf test: Do not skip when some metrics tests succeeded

Ian Rogers <irogers@google.com>
    perf test all metrics: Fully ignore Default metric failures

Ian Rogers <irogers@google.com>
    perf test metrics: Update all metrics for possibly failing default metrics

Ian Rogers <irogers@google.com>
    perf tests metrics: Permission related fixes

Ian Rogers <irogers@google.com>
    perf test stat_all_metrics: Ensure missing events fail test

Namhyung Kim <namhyung@kernel.org>
    perf test: Update all metrics test like metricgroups test

Weilin Wang <weilin.wang@intel.com>
    perf test: Simplify metric value validation test final report

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define

Daniel McCarthy <daniel@dragonzap.com>
    pinctrl: bcm2835: Don't remove an unregistered GPIO chip

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails

Chen, Yu C <yu.c.chen@intel.com>
    sched/fair: Fix overflow in update_tg_cfs_runnable()

Wei Yang <richard.weiyang@gmail.com>
    mm/mm_init: fix incorrect node_spanned_pages

Henrik Grimler <henrik.grimler@axis.com>
    drm/lima: call drm_mm_init() with a valid allocation range

Brian Masney <bmasney@redhat.com>
    clk: imx: scu: drop redundant init.ops variable assignment

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leaks in imx7_src_init()

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leak in imx_src_init()

Min zhang <zhangmin2026@yeah.net>
    clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_audmix: rework runtime PM handling in probe

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: rt700-sdw: always drain jack work on remove

Joey Lu <a0987203069@gmail.com>
    clk: nuvoton: ma35d1: fix ma35d1_clk_pll_determine_rate logic

Brian Masney <bmasney@redhat.com>
    clk: nuvoton: ma35d1-pll: convert from round_rate() to determine_rate()

Joey Lu <a0987203069@gmail.com>
    clk: nuvoton: ma35d1: fix PLL_CTL1_FRAC bit field width and fractional calc

Joey Lu <a0987203069@gmail.com>
    clk: nuvoton: ma35d1: fix ignored div_u64 return values in PLL freq calculation

Alexander A. Klimov <grandmaster@al2klimov.de>
    clk: moxart: remove unused variables, fix refcount leak

Myeonghun Pak <mhun512@gmail.com>
    clk: versaclock7: Fix APLL clock leak on probe failure

Gui-Dong Han <hanguidong02@gmail.com>
    media: cec-pin: Fix event FIFO ordering

Weigang He <geoffreyhe2@gmail.com>
    soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()

Michael Bommarito <michael.bommarito@gmail.com>
    HID: roccat: bound device-supplied profile index

Christos Maragkos <whitetowersoftware@gmail.com>
    HID: nintendo: Fix imu_timestamp_us double increment per report

Philipp Weber <kernel@phwe.de>
    HID: core: quiesce input in hid_hw_stop() to prevent use-after-free

Maoyi Xie <maoyixie.tju@gmail.com>
    platform/chrome: cros_ec_typec: Reject out-of-bounds PD cap count

Jens Remus <jremus@linux.ibm.com>
    x86/cfi: Use symmetric SYM_START and SYM_END in __CFI_TYPE()

Konstantin Andreev <andreev@swemel.ru>
    smack: restrict smackfs/{direct,mapped} values to 0-255

Konstantin Andreev <andreev@swemel.ru>
    smack: deduplicate smackfs/{direct,mapped} file_operations

Dmitry Antipov <dmantipov@yandex.ru>
    smack: simplify write handlers of sysfs entries

Konstantin Andreev <andreev@swemel.ru>
    smack: fix incorrect task context in smack_msg_queue_msgrcv

Maxime Ripard <mripard@kernel.org>
    drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    drm/rockchip: vop2: Recognise 10-bit YUV422 as YUV format

Paul Kocialkowski <paulk@sys-base.io>
    drm: lcdif: Wait for vblank before disabling DMA

Yicong Hui <yiconghui@gmail.com>
    drm: Remove unused header in drm_dumb_buffers.c

SJ Park <sj@kernel.org>
    mm/damon/core: skip aging from repeated aggressive merging

Huang Wei <huangwei@kylinos.cn>
    usb: typec: ucsi: use UCSI_TIMEOUT_MS for sync command completion

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: align gxbb_32k_clk_sel number of parents with actual count

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix register_pid() overflow, strcpy, and BUG_ON

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: avoid CRC corruption due to parallel claim add

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: atomically update mac addresses

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
    ceph: fix BUG_ON in __ceph_build_xattrs_blob() due to stale blob size

Junyi Liu <moss80199@gmail.com>
    ksmbd: fix durable reconnect error path file lifetime

Akif <akif.sait111@gmail.com>
    ksmbd: fix use-after-free in smb2_open during durable reconnect

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix same-register dst/src OOB read and pointer leak in sock_ops

Xiang Mei <xmei5@asu.edu>
    bridge: mrp: reject zero test interval to avoid OOM panic

Brian Witte <brianwitte@mailfence.com>
    netfilter: nft_counter: serialize reset with spinlock

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Reject narrower access to pointer ctx fields

Daniel Vogelbacher <daniel@chaospixel.com>
    ceph: fix oops due to invalid pointer for kfree() in parse_longname()

Al Viro <viro@zeniv.linux.org.uk>
    parse_longname(): strrchr() expects NUL-terminated string

Jonathan Currier <dullfire@yahoo.com>
    net/niu: Niu requires MSIX ENTRY_DATA fields touch before entry reads

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"

Norbert Szetei <norbert@doyensec.com>
    ksmbd: fix overflow in dacloffset bounds check

Jiawen Wu <jiawenwu@trustnetic.com>
    net: libwx: fix Tx L4 checksum

Su Yue <glass.su@suse.com>
    md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb

Manivannan Sadhasivam <mani@kernel.org>
    wifi: ath11k: Clear affinity hint before calling ath11k_pcic_free_irq() in error path

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix kernel crash when 1588 is sent on HIP08 devices

Jian Shen <shenjian15@huawei.com>
    net: hns3: don't auto enable misc vector

SJ Park <sj@kernel.org>
    mm/damon/tests/core-kunit: catch test failure in test_merge_regions_of()

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: handle region split failure in filter_out()

SJ Park <sj@kernel.org>
    mm/damon/vaddr-kunit: check region count in three_regions test

SJ Park <sj@kernel.org>
    mm/damon/paddr: drop last same folio access check reuse optimization

SJ Park <sj@kernel.org>
    mm/damon/vaddr: drop last same folio access check optimization

SJ Park <sj@kernel.org>
    mm/damon/core-kunit: check region count before testing in split_at()

Kazuki Hanai <hnkz.64@gmail.com>
    nvmet-auth: Synchronize timeout work during SQ teardown

Dragos Tatulea <dtatulea@nvidia.com>
    net/mlx5e: xsk: Fix unlocked writing to ICOSQ

Sechang Lim <rhkrqnwk98@gmail.com>
    tcp: clear sock_ops cb flags before force-closing a child socket

Arthur Gautier <baloo@superbaloo.net>
    xhci: fix lost bounce buffers on TDs spanning several ring segments

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: clear the dirty flag when unwinding an OP_UNMAP_SPARSE

Zhenhao Wan <whi4ed0g@gmail.com>
    drm/nouveau/uvmm: fix premature region free on failed OP_UNMAP_SPARSE

Faith Ekstrand <faith.ekstrand@collabora.com>
    drm/nouveau: Use write-combined maps for coherent

Sunday Clement <Sunday.Clement@amd.com>
    drm/amdkfd: Reject zero-sized AQL queue allocations after size halving

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT

Guangshuo Li <lgs201920130244@gmail.com>
    drm/amdgpu: fix autosuspend cleanup during removal

Yang Wang <kevinyang.wang@amd.com>
    drm/amdgpu: check thunderbolt before switcheroo registration

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_crtc_commit leak if signaled when PAGE_FLIP_EVENT is used

Kavan Smith <kavansmith82@gmail.com>
    drm/msm/dsi: round 6G byte clock rate to the PLL-achievable value

Tao Yu <tao1.yu@intel.com>
    drm/gud: validate TV mode names before creating enum property

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/gud: NUL-terminate TV mode names read from the device

David (Ming Qiang) Wu <David.Wu3@amd.com>
    drm/amdgpu/vcn: fix integer overflow in dec_msg buffer count check

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: avoid divide-by-zero in __is_lut_linear()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Use drm_atomic_helper_check_plane_state()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Fix list of formats on the primary plane

Wentao Liang <vulab@iscas.ac.cn>
    drm/sun4i: fix refcount leak in sun4i_backend_init_sat()

Deepanshu Kartikey <kartikey406@gmail.com>
    drm/i915: Guard against NULL driver_data in i915_pci_probe()

Danilo Krummrich <dakr@kernel.org>
    drm: fix race between partial drm_dev_register() failure and ioctl

Johan Hovold <johan@kernel.org>
    drm/panel-edp: fix i2c adapter leak on probe failure

Johan Hovold <johan@kernel.org>
    drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure

Chao Yu <chao@kernel.org>
    f2fs: fix to zero post-EOF data when extending file size

Chao Yu <chao@kernel.org>
    f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: fix i_size when pinned fallocate partially fails

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return writeback error from collapse range

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: use the mount idmap for the owner check in f2fs_xattr_advise_set()

Hao-Qun Huang <alvinhuang0603@gmail.com>
    f2fs: reject overlapping move range after len expansion

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return symlink writeback errors

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Drop vport reference under lock in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid double completion in async IOCB timeout

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Quiesce response IRQ before freeing request queue

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_iocb()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Don't query firmware state while chip is down

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix FCE trace enable parsing in debugfs

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix cs84xx use-after-free on host teardown

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Serialize flash version read in reset handler

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Initialize NVMe abort_work once at submission

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound i2c->length in I2C bsg handlers

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers

Ruoyu Wang <ruoyuw560@gmail.com>
    media: zoran: Avoid freeing a registered video_device twice

Arash Golgol <arash.golgol@gmail.com>
    media: vimc: fix pixel format lookup in enum_framesizes

Uday Khare <udaykhare77@gmail.com>
    media: video-i2c: fix kthread error pointer left in kthread_vid_cap on failure

Mohammed EL Kadiri <med08elkadiri@gmail.com>
    media: venus: fix payload size calculation in parse_raw_formats()

Mohammed EL Kadiri <med08elkadiri@gmail.com>
    media: venus: fix payload size returned by parse_caps() and parse_alloc_mode()

Biren Pandya <birenpandya@gmail.com>
    media: v4l2-fwnode: Fix fwnode leak in v4l2_fwnode_parse_link

Ming Qian <ming.qian@oss.nxp.com>
    media: v4l2-ctrls: Allow unknown HDR10 white point and luminance

Xu Rao <raoxu@uniontech.com>
    media: v4l2-async: avoid deleting unlinked ASC entry on link error

Ilya Krutskih <devsec@tpz.ru>
    media: tda18250: fix possible integer overflow

Guangshuo Li <lgs201920130244@gmail.com>
    media: saa7164: fix cleanup on resource allocation failure

Lei Huang <huanglei@kylinos.cn>
    media: s2255: check firmware size before reading trailing marker

HyeongJun An <sammiee5311@gmail.com>
    media: s2255: bound JPEG frame size before copying into the buffer

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: release URBs and stream buffers on start_streaming() failure

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: use vb2_video_unregister_device() on remove to fix DMA leak

Myeonghun Pak <mhun512@gmail.com>
    media: rc: sunxi-cir: Unregister rc device on probe failure

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Use BIT_ULL() for 64-bit stream masks

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Correct color map between V4L2 and ISI

Guoniu Zhou <guoniu.zhou@oss.nxp.com>
    media: nxp: imx8-isi: Fix stream ID validation bypass in crossbar routing

Christian Hewitt <christianshewitt@gmail.com>
    media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov7740: fix use-after-destroy in remove

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov02a10: fix endpoint parsing use-after-free

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: go7007: defer the ALSA v4l2 put until card release

Jiangong.Han <jiangong.han@windriver.com>
    media: em28xx: fix use-after-free of dev_next->devlist on disconnect

Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
    media: em28xx: defer audio-only extension registration

Fan Wu <fanwu01@zju.edu.cn>
    media: cx23885: cancel NetUP CI work before teardown

Bryam Vargas <hexlabsecurity@proton.me>
    media: cx231xx: reject geometry changes while the VBI queue is busy

Ruoyu Wang <ruoyuw560@gmail.com>
    media: cobalt: Avoid freeing ALSA private data twice

Dawei Feng <dawei.feng@seu.edu.cn>
    media: cedrus: fix memory leak in cedrus_init_ctrls()

Ruoyu Wang <ruoyuw560@gmail.com>
    media: cec: Serialize exclusive follower delivery

Yi Ding <yi.s.ding@gmail.com>
    media: cec: meson: ao-cec-g12a: name the CEC core regmap to avoid debugfs clash

Jonas Karlman <jonas@kwiboo.se>
    media: cec: core: Fix kmemleak due to missed rc_free_device() call

Valery Borovsky <vebohr@gmail.com>
    media: airspy: use vb2_video_unregister_device() on disconnect to fix NULL deref

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    LoongArch: Avoid preempt count underflow without probe

Wentao Guan <guanwentao@uniontech.com>
    LoongArch: Do not save/restore percpu base register in rethook trampoline

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Restore sigset on error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: pv: Fix rc/rrc offset for PVM_DUMP

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize irq in reinject_machine_check

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Take srcu when importing watchpoint data

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Free guest debug data on vcpu destroy

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix old_data leak in guest debug error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory leak in guest debug handling

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix length check __import_wp_info()

Carlos López <clopez@suse.de>
    KVM: x86: hyper-v: Clamp stimer deadline to avoid livelock

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Service local TLB flushes on failed nested VM-Enter

Yosry Ahmed <yosry@kernel.org>
    KVM: nVMX: Always flush vpid02 on first use

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix reversed GENMASK() arguments in fault count mask

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Reject integration times with a non-zero seconds part

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix incompatible pointer type passed to div_u64_rem()

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: opt4001: Fix power down clearing bits of the wrong register

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()

Cong Nguyen <congnt264@gmail.com>
    iio: srf04: fix pm_runtime handling on probe error path

Can Peng <pengcan@kylinos.cn>
    iio: pressure: mpl115: Fix runtime PM cleanup

Rupesh Majhi <zoone.rupert@gmail.com>
    iio: pressure: dps310: fix NULL pointer dereference on ACPI probe

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    iio: light: gp2ap002: Disable regulators on resume failure

Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
    iio: light: cm32181: return zero after writing calibscale

Cong Nguyen <congnt264@gmail.com>
    iio: gyro: mpu3050: fix sign of raw angular velocity readings

Erick Henrique <erick.henrique.rodrigues@usp.br>
    iio: dac: m62332: Fix regulator reference count imbalance

Linmao Li <lilinmao@kylinos.cn>
    iio: chemical: sgp30: Handle IAQ thread creation failure

Fan Wu <fanwu01@zju.edu.cn>
    iio: chemical: atlas-sensor: use iio_trigger_poll_nested() to fix remove UAF

Moksh Panicker <mokshpanicker.7@gmail.com>
    iio: chemical: atlas-sensor: fix PM reference leak in buffer postenable

WenTao Liang <vulab@iscas.ac.cn>
    ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get

Haoxiang Li <haoxiang_li2024@163.com>
    AsoC: intel: sst: fix PCI device reference leak on probe failure

Haoxiang Li <haoxiang_li2024@163.com>
    ASoC: fsl: mpc5200-i2s: Free DMA resources on probe failure

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: cs35l34: drain threaded IRQ before runtime suspend

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ASoC: cs35l33: drain threaded IRQ before runtime suspend

Linkai Gong <gonglinkai@kylinos.cn>
    i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-mdm9607: Drop incorrect BIMC PLL and related clocks

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-mdm9607: Fix halt_reg for gcc_apss_axi_clk

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Fix enable_reg for gcc_blsp1_sleep_clk

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Drop incorrect system_noc_bfdcd_clk_src

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Drop incorrect apss_tcu_clk_src

Heiko Stuebner <heiko.stuebner@cherry.de>
    clk: rockchip: rk3588: Don't change PLL rates when setting dclk_vop2_src

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-msm8939: Fix enable_reg for gcc_blsp1_sleep_clk

Stephan Gerhold <stephan.gerhold@linaro.org>
    clk: qcom: gcc-msm8916: Fix enable_reg for gcc_blsp1_sleep_clk

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: prevent CRC corruptions after claim flush

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: fix freeing of claims on meshif deletion

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: avoid unaligned fault in IP extraction

Zhiling Zou <zhilinz@nebusec.ai>
    batman-adv: fix stale receive device on merged fragments

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: rawnand: validate ONFI extended parameter page sections

Xu Rao <raoxu@uniontech.com>
    mtd: mtdoops: free page bitmap when the backing MTD is removed

Pengpeng Hou <pengpeng@iscas.ac.cn>
    mtd: afs: validate v2 image info bounds

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix required lock not held during update of ap_matrix_mdev object

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix potential use of uninitialized apm_filtered bitmap

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix NULL deref in status_show() during queue probe

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix hot-unplug skipped when last AP adapter or domain removed

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix dereference matrix_mdev->kvm without checking for NULL

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix control domain removal in vfio_ap_mdev_cfg_remove

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: Fix stale do_remove flag across iterations in vfio_ap_mdev_cfg_remove

Anthony Krowiak <akrowiak@linux.ibm.com>
    s390/vfio-ap: fix stale pqap_hook pointer on error in vfio_ap_mdev_set_kvm()

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/crash: stop watchdogs before booting kdump kernel

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/pseries: Move H_WATCHDOG definitions to a common header

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/pseries: Handle and log pseries-wdt registration failures

Muchun Song <muchun.song@linux.dev>
    powerpc/mm: fix wrong addr_pfn tracking in compound vmemmap population

Helge Deller <deller@gmx.de>
    parisc: Fix alignment of asm statements in head.S

Pei Xiao <xiaopei01@kylinos.cn>
    parisc: eisa: Fix infinite loop when parsing invalid IRQ value

Bryam Vargas <hexlabsecurity@proton.me>
    nvdimm/btt: reject an arena whose nfree is below the lane count

Wupeng Ma <mawupeng1@huawei.com>
    mm/hugetlb: fix missing migratable flag on same-node hugetlb migration

caina <caina@uniontech.com>
    Revert "irqchip/mbigen: Fix mbigen node address layout"

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvmet-tcp: reject unsolicited H2CData PDUs

Shivam Kumar <kumar.shivam43666@gmail.com>
    nvmet-tcp: fix out-of-bounds write when receiving an over-long PDU

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: check the data direction of a C2HData PDU

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Fix race between non-atomic ops and trigger-start

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: harmony: initialize locks before requesting IRQ

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: mm: Fix the lockless page-table walk in show_pte()

Ahmad Byagowi <ahmadexp@gmail.com>
    i2c: mux: Fix channel node leak on adapter add failure

Vasileios Almpanis <vasilisalmpanis@gmail.com>
    i2c: core: fix debugfs UAF on adapter removal

Sizhe Liu <liusizhe5@huawei.com>
    perf hisi-ptt: Fix PTT trace TLP header parsing

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix kernel address leakages in LBR stack

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Disable alarm interrupt before reprogramming alarm registers

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    rtc: rzn1: Fix weekday underflow when alarm crosses month boundary

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Input: aiptek - validate raw macro indices before updating state

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    kprobes: Protect kprobe_blacklist with RCU

Bradley Morgan <brads@mainlining.org>
    ima: Check for ERR_PTR from dentry_path() in validate_hash_algo()

Hajo Noerenberg <hajo-linux-ide@noerenberg.de>
    ata: ahci: work around lost interrupts on Marvell 88SE61xx

Damien Le Moal <dlemoal@kernel.org>
    block: flag zoned disks with GENHD_FL_NO_PART

Linkai Gong <gonglinkai@kylinos.cn>
    cpuidle: dt_idle_genpd: kfree() the original name allocation

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Initialize IRQ data before requesting IRQs

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Complete descriptors before pausing

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Fix HDMA channel status register access

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix resume-vs-remove race

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix race when loading and unloading a table

Ibrahim Hashimov <security@auditcode.ai>
    HID: wacom: validate report length in wacom_intuos_pro2_bt_irq

Wei Jie Law <98lawweijie@gmail.com>
    HID: rmi: fix OOB access with undersized RMI reports

Yao Kai <yaokai34@huawei.com>
    futex: Prevent rcuwait use-after-free during requeue PI

SJ Park <sj@kernel.org>
    mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs: kobject_del() region and target (error) dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme region dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme filter dirs

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: kobject_del() scheme dirs

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: pm8001: Use rollback index when freeing MSI-X vectors

Sujal Tuladhar <sujaltuladhar1231@gmail.com>
    scsi: target: iscsi: Reserve a terminator byte for the login payload

Can Peng <pengcan@kylinos.cn>
    spi: bcmbca-hsspi: disable clocks on resume failure

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx: disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    spi: bcm63xx-hsspi: disable clocks on resume failure

Kanishka De Silva <kpskanna1915@gmail.com>
    ublk: clear VM_MAYWRITE on read-only ublk char device mmap

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/qoriq: Disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/imx: Disable clock on runtime resume failure

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read / stack overflow in rtw_get_wps_attr()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: fix null pointer dereference in usb_put_function_instance()

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()

Ivy Lopez <skunkolee@gmail.com>
    usb: gadget: f_midi2: fix use-after-free in string attribute show path

Aleksandr Nogikh <nogikh@google.com>
    usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Fix OOB altmode array index

Fan Wu <fanwu01@zju.edu.cn>
    usb: typec: qcom-pmic: cancel reset_work on stop

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()

Liu Qi <liuqi@longcheer.com>
    usb-storage: ene_ub6250: fix race between scan work and probe

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: usbtv: keep device alive while ALSA card exists

Stephan Gerhold <stephan@gerhold.net>
    clk: qcom: gcc-mdm9607: Increase delay for USB PHY reset

HyeongJun An <sammiee5311@gmail.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: image: mdc800: change kmalloc() to kzalloc()

Hari Mishal <harimishal1@gmail.com>
    drm/amd/display: fix division by zero in get_estimated_bw()

Petr Vaganov <p.vaganov@ideco.ru>
    scsi: core: Fill in DMA padding bytes in scsi_alloc_sgtables()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions

Steven Rostedt <rostedt@goodmis.org>
    tracing/mmiotrace: Remove reference to unused per CPU data pointer

Koichiro Den <den@valinux.co.jp>
    net: ntb_netdev: Fix TX busy and drop handling

Jinjie Ruan <ruanjinjie@huawei.com>
    entry: Fix seccomp bypass after ptrace with TSYNC

Eric Dumazet <edumazet@google.com>
    tcp: fix potential race in tcp_v6_syn_recv_sock()

Youngjae Kwon <yjkwon0026@snu.ac.kr>
    fsnotify: Fix stale object mask after concurrent mark updates

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    wifi: mt76: mt7996: validate default EEPROM firmware size

Günther Noack <gnoack@google.com>
    landlock: Require LANDLOCK_ACCESS_FS_MAKE_REG for whiteout creation

Yuqi Xu <xuyuqiabc@gmail.com>
    openvswitch: Fix CT limit teardown use-after-free

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix kernel-doc warnings in internal headers

Norbert Szetei <norbert@doyensec.com>
    net: skbuff: don't skb_tx_error() the source skb in skb_zerocopy()

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: sensorhub: Fix dropped timestamp events and log spam

Zhan Xusheng <zhanxusheng1024@gmail.com>
    udf: Fix i_lenExtents truncation on 32-bit kernels

Thomas Gleixner <tglx@kernel.org>
    timer: Keep debugobjects state consistent in migrate_timer_list()

Bradley Morgan <include@grrlz.net>
    taskstats: fix cpumask parsing cutting off the last character

Jann Horn <jannh@google.com>
    smack: fix cred UAF in smack_file_send_sigiotask()

Bradley Morgan <include@grrlz.net>
    signal: avoid shared siginfo namespace rewrites

Helge Deller <deller@gmx.de>
    sticon/parisc: Detect default STI graphics card for console output

Myeonghun Pak <mhun512@gmail.com>
    tpm: tpm_i2c_nuvoton: disable IRQ on wait timeout

Zi Yan <ziy@nvidia.com>
    xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()

Maoyi Xie <maoyixie.tju@gmail.com>
    w1: ds28e17: reject an oversize length on an I2C block read

Chengfeng Ye <nicoyip.dev@gmail.com>
    vsock/virtio: flush works in dependency order

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: mt76: mt7615: avoid waiting for mac work under the mt76 mutex

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: rtl818x: initialize eeprom_93cx6 struct to zero

Fabio Estevam <festevam@nabladev.com>
    wifi: mwifiex: Detach sync cmd buffer on interrupted wait

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()

Maoyi Xie <maoyixie.tju@gmail.com>
    i3c: master: svc: bound IBI payload to the requested max_payload_len

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix info leak and UAF in device unregister path

Haotian Zhang <vulab@iscas.ac.cn>
    dm-switch: use WRITE_ONCE() in switch_region_table_write()

Mikulas Patocka <mpatocka@redhat.com>
    dm-stats: fix a crash if allocation of per-cpu data fails

Nathan Chancellor <nathan@kernel.org>
    arch_numa: avoid false positive fortify warning in setup_node_to_cpumask_map()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/tdx: Fix zero-extension for 32-bit port I/O

Naman Jain <namjain@linux.microsoft.com>
    PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip

Karl Mehltretter <kmehltretter@gmail.com>
    cgroup/cpuset: Fix misplaced DL migration reset

Takashi Iwai <tiwai@suse.de>
    ALSA: virmidi: Check card index validity at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: serial-u16550: Check card index validity at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: portman2x4: Check card index validity at probe

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: pcxhr: initialize mutexes before requesting threaded IRQ

Takashi Iwai <tiwai@suse.de>
    ALSA: mts64: Check card index validity at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: mpu401: Check card index validity at probe

Baul Lee <baul.lee@xbow.com>
    ALSA: bcd2000: clear the URB pointers on disconnect

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Check card index validity at probe

Baul Lee <baul.lee@xbow.com>
    ALSA: 6fire: bound the MIDI event length from the device

Zhiling Zou <zhilinz@nebusec.ai>
    seg6: reset IP6CB after IPv6 decapsulation

Norbert Szetei <norbert@doyensec.com>
    net: skbuff: don't touch shared zerocopy state in skb_tx_error()

Breno Leitao <leitao@debian.org>
    net: fix spurious TX timeout after dev_activate()

Zhiling Zou <zhilinz@nebusec.ai>
    net: cap advertised IP tunnel headroom

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: unregister the connection before draining the rx tasklet

Hidayath Khan <hidayath@linux.ibm.com>
    net/smc: fix use-after-free in smc_rx_pipe_buf_release()

Hidayath Khan <hidayath@linux.ibm.com>
    net/smc: fix socket refcount leak in smc_switch_conns()

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: do not dereference an unset send buffer on the SMC-D teardown path

Koichiro Den <den@valinux.co.jp>
    net: ntb_netdev: Count packets dropped on RX refill failure

Koichiro Den <den@valinux.co.jp>
    net: ntb_netdev: Avoid double-accounting netif_rx() drops

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_transport: Reject oversized TX buffers

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_transport: Fail TX enqueue when the QP link is down

Koichiro Den <den@valinux.co.jp>
    NTB: ntb_transport: Recycle TX entries before client callbacks

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Mark the connection down when bringing it up fails

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Release the Rx HopID that was handed out on mismatch

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net: ravb: avoid dereferencing an invalid PTP clock

Ruoyu Wang <ruoyuw560@gmail.com>
    net: openvswitch: fix nf_connlabels leak in ovs_ct_init

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix flow mask use-after-free on flow deletion

Asim Viladi Oglu Manizada <manizada@pm.me>
    net: tun: bound receive headroom

Fabio Porcedda <fabio.porcedda@gmail.com>
    net: usb: qmi_wwan: add Telit Cinterion FE990D50 composition

Aleksandr Khromov <haa@amicon.ru>
    slip: fix use-after-free in sl_sync()

Weiming Shi <bestswngs@gmail.com>
    xdp: fix zero-copy frame layout

Alexandra Winter <wintera@linux.ibm.com>
    net/iucv: filter frames in afiucv_hs_rcv() by ingress device

Seiji Nishikawa <snishika@redhat.com>
    ipmi: si: Fix NULL pointer dereference after failed registration

Yousef Alhouseen <alhouseenyousef@gmail.com>
    ipmi: ipmb: validate write message length

Kuan-Wei Chiu <visitorckw@gmail.com>
    interconnect: Fix use after free in icc_get() and of_icc_get_by_index()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: warn on element type mismatch instead of failing

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: pass validated element count to package parsers

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix ORD_LIST_ELEMENTS never being parsed

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix off-by-one write in hp_get_string_from_buffer()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix new_password_store() overwriting current_password

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix heap OOB read on empty password write

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: fix heap OOB read in sk_store() and kek_store()

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: bound ordered-list parsing by the package count

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: advance elem past consumed array elements

Muhammad Bilal <meatuni001@gmail.com>
    platform/x86: hp-bioscfg: accept reduced ACPI packages from older HP BIOS

Bryam Vargas <hexlabsecurity@proton.me>
    platform/chrome: sensorhub: Bound the EC-reported sensor number

Ma Ke <make_ruc2021@163.com>
    platform/x86: ishtp_eclite: Fix ACPI device reference leak in probe error path

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate logical CPU id and clos id

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Just allow 2 bits for SST feature enable

Fan Wu <fanwu01@zju.edu.cn>
    mmc: via-sdmmc: stop card-detect handling on probe failure

HyeongJun An <sammiee5311@gmail.com>
    platform/x86: ISST: Validate socket ID in clos_assoc ioctl

HyeongJun An <sammiee5311@gmail.com>
    platform/x86: ISST: Validate level in perf mask ioctls

HyeongJun An <sammiee5311@gmail.com>
    platform/x86: dell-wmi-sysman: Don't hex dump attribute security buffer

Kevin Tian <kevin.tian@intel.com>
    iommu/vt-d: Force requesting ACS when tboot is enabled

Kevin Tian <kevin.tian@intel.com>
    iommu/vt-d: Fix no_iommu to disable platform opt-in

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Warn on writes to kernel-exclusive config space regions

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Use file_ns_capable() when checking config space read access

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Avoid spurious runtime PM wakeup on config space accesses

Farhan Ali <alifm@linux.ibm.com>
    PCI/MSI: Enable memory decoding before restoring MSI-X messages

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Avoid spurious runtime PM wakeup on config space accesses

Tim Harvey <tharvey@gateworks.com>
    PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]

Ronald Claveau <linux-kernel-dev@aliel.fr>
    PCI: meson: Fix GPIO state while requesting PERST#

Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
    PCI: Fix 32-bit config write in Intel PCH Root Port MPC ACS quirk

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Propagate partial completion length across ERP recovery

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Guard sysfs discipline callbacks against unallocated private data

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: Do not complete a failed ESE read as successful

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: Handle CPU hotplug via prepare/dead callbacks

Jianing Li <m13940358460@163.com>
    power: supply: max17040: synchronize work cancellation on suspend

Jianing Li <m13940358460@163.com>
    power: supply: max17040: drop incorrect I2C functionality check

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: ucs1002: fix use-after-free on remove

Maoyi Xie <maoyixie.tju@gmail.com>
    power: supply: twl4030_charger: cancel workers via devm

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: rt9455: quiesce delayed work before teardown

HyeongJun An <sammiee5311@gmail.com>
    power: supply: qcom_battmgr: terminate the strings from firmware

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: lp8727: fix use-after-free in lp8727_release_irq()

Jameson Thies <jthies@google.com>
    power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS

Bryam Vargas <hexlabsecurity@proton.me>
    power: supply: cros_usbpd-charger: bound the EC-reported port count

Ma Ke <make_ruc2021@163.com>
    power: supply: bq25890: Fix power_supply reference leak

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: bq256xx: drain usb_work before freeing the charger

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: bq24257: fix use-after-free on remove

Jun Yang <junvyyang@tencent.com>
    sctp: fix stream->outcnt underflow on duplicate RECONF responses

Jun Yang <junvyyang@tencent.com>
    sctp: distinguish sequence zero from wildcard in reconf lookup

Weiming Shi <bestswngs@gmail.com>
    sctp: fix NULL deref on untransmitted RECONF completion

Hyunwoo Kim <imv4bel@gmail.com>
    sctp: drop a chunk if its transport was removed

Hyunwoo Kim <imv4bel@gmail.com>
    sctp: stop processing a packet once its association is deleted

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: reject a read that transferred too few bytes

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: fix host memory disclosure on R2T for a read command

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme-tcp: do not accept C2HData based on blk_rq_payload_bytes() alone

Myeonghun Pak <mhun512@gmail.com>
    nvme-pci: disable controller on admin queue IRQ setup failure

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    nvme: zero the discard fallback page

Ewan D. Milne <emilne@redhat.com>
    nvme: nvme-fc: Fix nvme_fc_create_hw_io_queues() queue deletion in error path

Michael Bommarito <michael.bommarito@gmail.com>
    lockd: pin next file across nlm_inspect_file lock-drop

Cong Nguyen <congnt264@gmail.com>
    hwmon: (max6621) fix temperature clamp range

Cong Nguyen <congnt264@gmail.com>
    hwmon: (max6621) fix negative temperature offset and crit readings

Christopher Tolang <christophertolang@gmail.com>
    ASoC: amd: yc: Add DMI entry for MSI Thin A15 B7UC

Karl Mehltretter <kmehltretter@gmail.com>
    arm64: compat: Fix decrementing LDM/STM alignment emulation

HyeongJun An <sammiee5311@gmail.com>
    ALSA: ump: Fix corrupted data bytes at MIDI 1.0 SysEx to UMP conversion

Norbert Szetei <norbert@doyensec.com>
    openvswitch: only skb_tx_error() a packet we are about to drop

Ali Ahmet Memis <ali@iusegentoo.com>
    openrisc: fix arbitrary kernel memory access via or1k_atomic syscall

Zhan Xusheng <zhanxusheng1024@gmail.com>
    ocfs2: fix readdir position truncation on 32-bit kernels

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: cluster: fix o2hb_dependent_users leak on pin failure

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from drop_item

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: cluster: don't sleep while holding o2hb_live_lock in o2hb_region_pin()

Ibrahim Hashimov <security@auditcode.ai>
    ocfs2: validate rl_used against rl_count in refcount block validator

Bryam Vargas <hexlabsecurity@proton.me>
    ocfs2: validate lengths in dlm_mig_lockres_handler

Bryam Vargas <hexlabsecurity@proton.me>
    ocfs2: bound namelen in dlm_migrate_request_handler

Dmitry Antipov <dmantipov@yandex.ru>
    ocfs2: always run deallocs on copy-on-write completion

Zhiling Zou <zhilinz@nebusec.ai>
    orangefs: skip leading spaces before parsing client debug masks

Yifei Gao <gyf161023@gmail.com>
    orangefs: fix double-free of trailer_buf on readdir copy failure

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    regulator: qcom-refgen: correct the regulator type to CURRENT

WenTao Liang <vulab@iscas.ac.cn>
    regulator: max8998_pmic_dt_parse_pdata: of_node_put on reg_np after ownership transferred to rdata

WenTao Liang <vulab@iscas.ac.cn>
    regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer

Norbert Szetei <norbert@doyensec.com>
    RDMA/ucma: Lock the handler in ucma_set_ib_path()

Fan Wu <fanwu01@zju.edu.cn>
    RDMA/cxgb4: Cancel reg_work before freeing device on remove

Vaibhav Nagare <nagarevaibhav@gmail.com>
    qede: Fix NULL pointer dereference in TPA fragment processing

Johan Hovold <johan@kernel.org>
    remoteproc: scp: Fix device reference leak on failed lookup

Fabio Estevam <festevam@nabladev.com>
    arm64: dts: rockchip: Fix rk3399-roc-pc-plus analog audio

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix eMMC reset polarity on PX30 Ringneck

Chunkai Deng <chunkai.deng@oss.qualcomm.com>
    rpmsg: glink: smem: order FIFO read after availability check

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: media: tegra-video: vi: fix probe failure on skipped last port

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: media: tegra-video: fix of_node_put() on VIP parse errors

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets

David Lee <david.lee@trailofbits.com>
    udf: reject VAT indexes equal to the entry count

Chris Mason <clm@meta.com>
    svcrdma: Fix pcl_for_each_segment for empty chunks

Chris Mason <clm@meta.com>
    svcrdma: Fix offset arithmetic in read_chunk_range

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    SUNRPC: wait for in-flight client TLS handshake callback

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject krb5 v2 wrap tokens with oversized ec field

Chris Mason <clm@meta.com>
    sunrpc: init gssp_lock before publishing proc entry

Chris Mason <clm@meta.com>
    SUNRPC: harden gss_unwrap_resp_priv length checks

Chris Mason <clm@meta.com>
    SUNRPC: harden gss_krb5_unwrap_v2 against short tokens

Chris Mason <clm@meta.com>
    SUNRPC: Guard svcauth_gss_release() dispatch on rq_auth_stat

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Check svc pool percpu counter allocation

Jeff Layton <jlayton@kernel.org>
    SUNRPC: always drain cache_cleaner before destroying a cache_detail

Jeff Layton <jlayton@kernel.org>
    sunrpc: route to a populated pool in svc_pool_for_cpu()

Chris Mason <clm@meta.com>
    SUNRPC: svcauth_gss: enforce krb5 token minimum length

Chris Mason <clm@meta.com>
    SUNRPC: Zero rpc_gss_wire_cred at svcauth_gss_decode_credbody() entry

Chris Mason <clm@meta.com>
    SUNRPC: xdr_buf_trim: clamp buf->len to avoid underflow

Dave Airlie <airlied@redhat.com>
    nouveau/gem: reserve the bo in the info ioctl around the vma lookup

Harshit Varu <harshitvaru666@gmail.com>
    mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction

Qing Ming <a0yami@mailbox.org>
    mpls: reload header after pskb_may_pull()

Coly Li <colyli@fygo.io>
    md: do overflow check for sb->bblog_shift in super_1_load()

Anup Vishwakarma <anup.vishwakarma@oss.qualcomm.com>
    mailbox: qcom-ipcc: fix duplicate channel allocation across holes

Bryam Vargas <hexlabsecurity@proton.me>
    libnvdimm/labels: Prevent integer overflow in __nd_label_validate()

Yuyang Huang <sigefriedhyy@gmail.com>
    ipv6: use RCU iterator to dump route exceptions

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_gre: fix hardware header length for NBMA tunnels

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_tunnel: use skb_cow_head() in ip6_tnl_xmit()

Anton Danilov <littlesmilingcloud@gmail.com>
    ipip: fix skb leak in collect_md mode when metadata_dst allocation fails

Hui Su <sh_def@163.com>
    kasan: fix cache shrink race with CPU hotplug

Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>
    Bluetooth: hci_sync: Clear HCI_CMD_PENDING when dropping the last request

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: hci_h5: fix usage_count leak when autosuspend_delay is negative

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_event: clear HCI_LE_ADV only on a created connection

Xin Chen <xin.chen2@oss.qualcomm.com>
    Bluetooth: hci_core: use skb_get() instead of skb_clone() for req_skb

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_conn: re-enable advertising only for peripheral role

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: serialize security confirmation handling

Hang Nan <2122295973@qq.com>
    Bluetooth: ISO: fix use-after-free of listener socket in iso_conn_ready

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: hci_uart: Fix false success return in hci_uart_setup()

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative

Alison Schofield <alison.schofield@intel.com>
    cxl/pmem: Format the nvdimm serial number as unsigned decimal

Hui Su <sh_def@163.com>
    cpufreq: schedutil: Fix rate limit overflow

Bryam Vargas <hexlabsecurity@proton.me>
    dm array: reject an array block whose value size is not the caller's

Ilya Krutskih <devsec@tpz.ru>
    dm raid1: reserve space for NUL-terminator in build_constructor_string()

liyouhong <liyouhong@kylinos.cn>
    dm-era: fix shadowed superblock leak on take-snap failure

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    bpf: Harden bloom filter sizing and indexing on 32-bit kernels

Jiangshan Yi <yijiangshan@kylinos.cn>
    bnx2x: fix double free in bnx2x_init_firmware() error path

HyeongJun An <sammiee5311@gmail.com>
    Bluetooth: eir: Fix OOB read in eir_get_service_data()

Christoph Zwerschke <cito@online.de>
    Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU

Christoph Zwerschke <cito@online.de>
    Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU

胡连勤 <hulianqin@vivo.com>
    block: set QUEUE_FLAG_DYING unconditionally in blk_mark_disk_dead()

Hongyan Xu <getshell@seu.edu.cn>
    auxdisplay: charlcd: cancel backlight work on registration failure

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix DSM TRIM for sector sizes larger than 2048 bytes

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ARM: 9477/1: Disable broken eBPF JIT on the Risc PC

Matt Turner <mattst88@gmail.com>
    alpha: marvel: Fix lock ordering in init_io7_irqs()

Matt Turner <mattst88@gmail.com>
    alpha: marvel: Fix irq_set_status_flags to use correct IRQ number

Krzysztof Wilczyński <kwilczynski@kernel.org>
    alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()

Anirudh Prasad <icarus@a0rg.com>
    ACPI: pfr_update: fix stack buffer overflow in query_capability()

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    hsi: omap_ssi_core: fix missing DMA mask setup for SSI controller device

Tien Sung Ang <tien.sung.ang@altera.com>
    fpga: stratix10-soc: Fix SVC mailbox handling during reconfiguration

Marek Czernohous <marek@czernohous.de>
    forcedeth: fix off-by-one when saving/restoring non-PCI config space

Myeonghun Pak <mhun512@gmail.com>
    fbdev: uvesafb: unregister connector callback on init failure

Hui Su <sh_def@163.com>
    fbdev: ssd1307fb: defer I2C transfers from damage callbacks

Florian Fuchs <fuchsfl@gmail.com>
    fbdev: pvr2fb: correct user pointer annotation and sentinel initializer

Runyu Xiao <runyu.xiao@seu.edu.cn>
    fbdev: omapfb: panel-dsi-cm: initialize lock before registering display

Yemu Lu <prcups@krgm.moe>
    fat: restore original value when fat_ent_write failed

Ard Biesheuvel <ardb@kernel.org>
    efivarfs: Rate limit statfs() handler

Yichong Chen <chenyichong@uniontech.com>
    ecryptfs: show filename encryption options

Yichong Chen <chenyichong@uniontech.com>
    ecryptfs: release message context on send failure

Yichong Chen <chenyichong@uniontech.com>
    ecryptfs: reject too-small tag 70 packets

HanQuan <eilaimemedsnaimel@gmail.com>
    ecryptfs: reject oversized encrypted_key_size in parse_tag_3_packet

Yichong Chen <chenyichong@uniontech.com>
    ecryptfs: pass packet set buffer size to parser

Yichong Chen <chenyichong@uniontech.com>
    ecryptfs: hold msg ctx list lock when cleaning daemon queue

Yichong Chen <chenyichong@uniontech.com>
    ecryptfs: fix tag 11 packet exact-fit size check

Pengpeng Hou <pengpeng@iscas.ac.cn>
    eCryptfs: bound the packet-length peek to the user buffer

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: bound page_lcns[] index by the log record

Samuel Page <sam@bynar.io>
    fs/ntfs3: fix info-leak on partial LZNT decompress in ni_read_frame()

Xiang Mei <xmei5@asu.edu>
    fs/ntfs3: validate dirty page table on log replay

Deepanshu Kartikey <kartikey406@gmail.com>
    eventfs: Initialize ei->children and ei->list in init_ei()

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: validate report size in mcp2221_raw_event()

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: stop device IO before hid_hw_stop

Haoxiang Li <haoxiang_li2024@163.com>
    HID: sensor: custom: Fix field sysfs group cleanup on failure

Xu Rao <raoxu@uniontech.com>
    HID: roccat: free buffered reports when destroying device

Ibrahim Hashimov <security@auditcode.ai>
    HID: picolcd: clamp eeprom debugfs read to bytes actually received

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: harden DFS cache against invalid target hints

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix copy-paste error in WSL EA length accounting for $LXDEV

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix ALIGN() overflow in symlink_data() error context loop

Fredric Cover <fredric.cover.lkernel@gmail.com>
    smb: client: clear ce->tgthint in free_tgts()

Frank Sorenson <sorenson@redhat.com>
    cifs: fix loff_t underflow in cifs_remap_file_range() when len == 0

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    audit: avoid dropping live tree ref on fsnotify rule autoremove

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound xattr value length in __build_xattrs()

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound num_export_targets array for mds info v2/v3

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound copied dentry name length in NFS export get_name

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    ceph: reject export_targets ranks >= CEPH_MAX_MDS in mdsmap decode

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix UAF in __kick_flushing_caps() on cf entry freed during unlock

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    libceph: reject buckets with mismatched CRUSH ids

Michael Bommarito <michael.bommarito@gmail.com>
    libceph: validate OSD extent maps before cursor advance

Chuck Lever <cel@kernel.org>
    NFSD: Prevent lock owner use-after-free during client teardown

Jeff Layton <jlayton@kernel.org>
    nfsd: revoke copy-notify stateids before dropping their reference

Jeff Layton <jlayton@kernel.org>
    nfsd: reject reclaim LOCK after RECLAIM_COMPLETE

Robbie Ko <robbieko@synology.com>
    nfsd: reject out-of-range useconds in NFSv2 SETATTR/CREATE

Jeff Layton <jlayton@kernel.org>
    nfsd: initialize copy-notify stateid before publishing it

Chris Mason <clm@meta.com>
    nfsd: gate nfs3 setacl by argp->mask

Chuck Lever <chuck.lever@oracle.com>
    nfsd: gate nfs2 setacl by argp->mask

Jeff Layton <jlayton@kernel.org>
    nfsd: fix XDR padding calculation in ff_encode_getdeviceinfo

Jeff Layton <jlayton@kernel.org>
    nfsd: fix XDR length calculation in nfsd4_ff_encode_layoutget

Jeff Layton <jlayton@kernel.org>
    nfsd: fix version mismatch loops in nfsd_acl_init_request()

Chris Mason <clm@meta.com>
    nfsd: fix cpntf publish race in nfs4_init_cp_state

Jeff Layton <jlayton@kernel.org>
    nfsd: check client ownership when cancelling a copy-notify stateid

Jeff Layton <jlayton@kernel.org>
    nfsd: block non-SAVEFH ops after FOREIGN PUTFH to prevent NULL deref

Jeff Layton <jlayton@kernel.org>
    nfsd: add filehandle match check to nfsd4_delegreturn()

Jeff Layton <jlayton@kernel.org>
    nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()

Jeff Layton <jlayton@kernel.org>
    nfsd: validate symlink target length in NFSv4 CREATE

Chuck Lever <chuck.lever@oracle.com>
    nfsd: sample writeback error cursor before async COPY loop

Jeff Layton <jlayton@kernel.org>
    nfsd: return NFS4ERR_NOTSUPP for unsupported netloc4 types

Chuck Lever <chuck.lever@oracle.com>
    nfsd: Reset write verifier when async COPY writeback fails

Chris Mason <clm@meta.com>
    nfsd: release path refs on follow_down() error

Junrui Luo <moonafterrain@outlook.com>
    NFSv4.1: fix layout segment leak on the pnfs_layout_process() forget path

Mike Snitzer <snitzer@kernel.org>
    NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check

Michael Bommarito <michael.bommarito@gmail.com>
    NFSD: restart ssc_expire_umount walk after dropping nfsd_ssc_lock

Chuck Lever <cel@kernel.org>
    NFSD: Fix off-by-one in DRC bucket pruning limit

Chuck Lever <cel@kernel.org>
    NFSD: Encode only the status in NFS-ACL v2 GETACL error replies

Ibrahim Hashimov <security@auditcode.ai>
    ubifs: fix out-of-bounds read in signature length check

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    of: fix out-of-bounds read in of_alias_scan() stem parser

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix slab-out-of-bounds in nilfs_direct_propagate after truncation

Junrui Luo <moonafterrain@outlook.com>
    media: vicodec: fix out-of-bounds write in FWHT encoder

Weigang He <geoffreyhe2@gmail.com>
    media: cec: stm32: prevent out-of-bounds write on RX overflow

Vincent Mailhol <mailhol@kernel.org>
    lib/ucs2_string.c: fix out-of-bounds read in ucs2_strnlen()

Xingrui Li <baka9@bakabaka9.tech>
    HID: sensor-hub: Fix out-of-bounds write in sensor_hub_get_feature

Daisuke Matsuda <matsuda@preferred.jp>
    fpga: altera-cvp: Avoid out-of-bounds read in trailing byte write

Neill Kapron <nkapron@google.com>
    usb: gadget: f_fs: Prevent deadlock during ep0 read loop

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: uvc: fix dangling pointers in uvc_function_bind() and uvc_function_unbind()

Yun Zhou <yun.zhou@windriver.com>
    usb: gadget: f_tcm: fix deadlock in usbg_make_tpg()

Joshua Crofts <joshua.crofts1@gmail.com>
    usb: gadget: midi2: remove default configfs groups on teardown

Myeonghun Pak <mhun512@gmail.com>
    usb: gadget: snps_udc_plat: clean up PHY on probe deferral

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: u_audio: Fix use-after-free on sound card disconnect

Johan Hovold <johan@kernel.org>
    USB: phy: fsl-usb: fix missing static keywords

Francesco Lavra <flavra@baylibre.com>
    usb: dwc2: gadget: Exit partial power down state when changing USB pull-up

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: greybus: hid: fix SET_REPORT return value

Hans Verkuil <hverkuil+cisco@kernel.org>
    Revert "media: v4l2-dev: fix error handling in __video_register_device()"

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in dma_req_free()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    powerpc/powermac: fix OF node refcount

Xu Yang <xu.yang_2@nxp.com>
    device property: fix infinite loop in fwnode_for_each_child_node()

Hui Su <sh_def@163.com>
    tracing: Fix use-after-free with same-name named triggers

Hui Su <sh_def@163.com>
    tracing: Fix crash passing ERR_PTR to kthread_stop()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tracing/user_events: Clear copied tracing state before fork duplication

Sanman Pradhan <psanman@juniper.net>
    hwtracing: hisi_ptt: Propagate DMA reset timeout in trace_start()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/insn-eval: Move assign_register() out of KVM as insn_assign_reg()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/tdx: Fix off-by-one in port I/O handling

Joy H.J. Lee <rkr0k0r@gmail.com>
    tools/compiler: match glibc 2.42 definition of __attribute_const__

Guopeng Zhang <zhangguopeng@kylinos.cn>
    mm: memcg: stop reclaim when a limit update is superseded

Breno Leitao <leitao@debian.org>
    mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()

Breno Leitao <leitao@debian.org>
    mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()

Jordan R Abrahams-Whitehead <ajordanr@google.com>
    include/linux/list.h: mark list_add and __list_add as __always_inline

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    timers/itimer: Zero-init old itimerval before copy to userspace

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: switch to Default DMA window during kdump

Felix Yan <felixonmars@archlinux.org>
    clocksource/drivers/timer-sun4i: Advertise a real minimum delta

Matt Turner <mattst88@gmail.com>
    alpha: don't leak hardware-fabricated FP exception bits to user space

Matt Turner <mattst88@gmail.com>
    alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix die ID init and look up bugs

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aloop: Fix peer runtime UAF during format-change stop

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Fix racy access at PCM trigger

Eric Dumazet <edumazet@google.com>
    ipv4: start using dst_dev_rcu()

Eric Dumazet <edumazet@google.com>
    net: dst: introduce dst->dev_rcu

Eric Dumazet <edumazet@google.com>
    ipv4: adopt dst_dev, skb_dst_dev and skb_dst_dev_net[_rcu]

Eric Dumazet <edumazet@google.com>
    net: dst: add four helpers to annotate data-races around dst->dev

Karl Mehltretter <kmehltretter@gmail.com>
    Revert "arm64: mm: Don't remap pgtables for allocate vs populate"


-------------

Diffstat:

 .../ABI/testing/configfs-usb-gadget-uac1_legacy    |   3 -
 Documentation/ABI/testing/sysfs-bus-nvdimm         |   3 +-
 Documentation/hwmon/emc1403.rst                    |  25 +-
 Documentation/trace/hisi-ptt.rst                   |  28 +-
 Documentation/usb/gadget-testing.rst               |   3 -
 .../media/v4l/ext-ctrls-colorimetry.rst            |  12 +-
 Makefile                                           |   4 +-
 arch/alpha/include/uapi/asm/fpu.h                  |   8 +-
 arch/alpha/kernel/pci-sysfs.c                      |   6 +-
 arch/alpha/kernel/sys_marvel.c                     |  25 +-
 arch/alpha/kernel/traps.c                          |   6 +-
 arch/alpha/math-emu/math.c                         |  88 ++-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm/boot/dts/allwinner/sun4i-a10.dtsi         |   2 +-
 arch/arm/boot/dts/marvell/armada-388-helios4.dts   |  13 +
 arch/arm/mach-imx/src.c                            |   3 +
 arch/arm/mach-lpc32xx/common.c                     |   5 +-
 arch/arm/mach-lpc32xx/common.h                     |   2 +
 arch/arm/mach-lpc32xx/phy3250.c                    |   2 +
 arch/arm/mach-lpc32xx/pm.c                         |   5 +-
 arch/arm/mm/fault.c                                |  16 +-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |   4 +-
 arch/arm64/boot/dts/amlogic/meson-axg-s400.dts     |   4 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +-
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-gemini.dts |   2 +-
 .../boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi |   4 -
 arch/arm64/boot/dts/qcom/msm8998-xiaomi-sagit.dts  |   5 -
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  24 +-
 .../arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts |  61 +-
 arch/arm64/boot/dts/qcom/sc8180x-pmics.dtsi        |   2 +-
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts        |  12 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |  20 +-
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts          |   4 +-
 arch/arm64/boot/dts/qcom/sdm632-motorola-ocean.dts |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |  64 +-
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts  |   6 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   8 +-
 .../boot/dts/qcom/sm8250-xiaomi-elish-common.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  48 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   8 +-
 arch/arm64/boot/dts/qcom/sm8550.dtsi               |  12 +-
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |   2 +-
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |   3 +-
 .../arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts |  12 +
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi           |   2 +-
 arch/arm64/kernel/compat_alignment.c               |   4 +-
 arch/arm64/kernel/hibernate.c                      |  16 +-
 arch/arm64/lib/Makefile                            |   4 +
 arch/arm64/mm/fault.c                              |  12 +-
 arch/arm64/mm/mmu.c                                |  58 +-
 arch/csky/kernel/entry.S                           |   6 +-
 arch/loongarch/kernel/kprobes.c                    |   3 +
 arch/loongarch/kernel/rethook_trampoline.S         |   2 -
 arch/m68k/emu/nfcon.c                              |   2 +-
 arch/m68k/kernel/traps.c                           |   4 +-
 arch/mips/kernel/ptrace.c                          |   6 +-
 arch/openrisc/kernel/entry.S                       |  43 +-
 arch/parisc/kernel/head.S                          |   1 +
 arch/powerpc/configs/85xx-hw.config                |   1 +
 arch/powerpc/include/asm/papr-watchdog.h           |  64 ++
 arch/powerpc/kernel/irq.c                          |  16 +-
 arch/powerpc/kernel/smp.c                          |   3 +
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   7 +-
 arch/powerpc/platforms/powermac/low_i2c.c          |   2 +-
 arch/powerpc/platforms/pseries/iommu.c             |  23 +-
 arch/powerpc/platforms/pseries/setup.c             |  28 +-
 arch/riscv/kernel/cpufeature.c                     |   3 +-
 arch/s390/kernel/debug.c                           |  10 +-
 arch/s390/kernel/perf_cpum_cf.c                    | 221 ++++--
 arch/s390/kvm/guestdbg.c                           |   9 +-
 arch/s390/kvm/interrupt.c                          |   2 +-
 arch/s390/kvm/kvm-s390.c                           |  15 +-
 arch/x86/coco/tdx/tdx.c                            |  10 +-
 arch/x86/events/amd/uncore.c                       | 781 +++++++++++----------
 arch/x86/events/intel/lbr.c                        |  12 +-
 arch/x86/events/intel/uncore.c                     |   3 +-
 arch/x86/events/intel/uncore_snbep.c               |  13 +-
 arch/x86/include/asm/insn-eval.h                   |  36 +
 arch/x86/include/asm/linkage.h                     |   2 +-
 arch/x86/include/asm/pkeys.h                       |   3 +
 arch/x86/kvm/emulate.c                             |  26 +-
 arch/x86/kvm/hyperv.c                              |  25 +-
 arch/x86/kvm/vmx/nested.c                          |  18 +
 block/blk-cgroup.c                                 |   2 +
 block/blk-iocost.c                                 |   2 +-
 block/blk-stat.c                                   |   2 +-
 block/genhd.c                                      |   8 +
 block/kyber-iosched.c                              |   2 +-
 drivers/accessibility/speakup/keyhelp.c            |  17 +-
 drivers/accessibility/speakup/kobjects.c           |   6 +-
 drivers/acpi/ec.c                                  |  40 +-
 drivers/acpi/pci_root.c                            |   3 +-
 drivers/acpi/pfr_update.c                          |  45 +-
 drivers/acpi/processor_core.c                      |  31 +-
 drivers/acpi/processor_driver.c                    |  18 +-
 drivers/acpi/processor_idle.c                      | 116 +--
 drivers/acpi/scan.c                                |  13 +-
 drivers/acpi/video_detect.c                        |   4 +-
 drivers/ata/ahci.c                                 |  49 ++
 drivers/ata/libata-scsi.c                          |  28 +-
 drivers/auxdisplay/charlcd.c                       |  21 +-
 drivers/base/arch_numa.c                           |  12 +
 drivers/base/cacheinfo.c                           |   9 +-
 drivers/base/firmware_loader/fallback.c            |  10 +
 drivers/base/property.c                            |  19 +-
 drivers/base/soc.c                                 |  15 +-
 drivers/base/swnode.c                              |   2 +-
 drivers/block/mtip32xx/mtip32xx.c                  |   7 +
 drivers/block/mtip32xx/mtip32xx.h                  |   2 +
 drivers/block/null_blk/main.c                      |  96 +--
 drivers/block/null_blk/null_blk.h                  |   1 +
 drivers/block/ublk_drv.c                           |  14 +-
 drivers/bluetooth/btintel.c                        |   2 +-
 drivers/bluetooth/btmtk.c                          |   7 +-
 drivers/bluetooth/btmtksdio.c                      |  37 +-
 drivers/bluetooth/btqca.c                          |   3 +-
 drivers/bluetooth/btusb.c                          |  80 +--
 drivers/bluetooth/hci_bcm.c                        |   1 +
 drivers/bluetooth/hci_h5.c                         |   4 +-
 drivers/bluetooth/hci_intel.c                      |   1 +
 drivers/bluetooth/hci_ldisc.c                      |   2 +-
 drivers/bluetooth/hci_serdev.c                     |   2 +-
 drivers/bluetooth/virtio_bt.c                      |   8 +-
 drivers/bus/mhi/ep/main.c                          |  15 +-
 drivers/bus/mhi/host/main.c                        |   6 +
 drivers/bus/qcom-ebi2.c                            |  51 +-
 drivers/bus/ti-sysc.c                              |  12 +-
 drivers/char/hw_random/ks-sa-rng.c                 |  22 +-
 drivers/char/ipmi/ipmb_dev_int.c                   |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   1 +
 drivers/char/ppdev.c                               |  10 +-
 drivers/char/tpm/st33zp24/st33zp24.c               |   8 +-
 drivers/char/tpm/tpm_i2c_nuvoton.c                 |   6 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |   5 +-
 drivers/clk/clk-moxart.c                           |  14 -
 drivers/clk/clk-palmas.c                           |  14 +-
 drivers/clk/clk-versaclock7.c                      |   2 +-
 drivers/clk/hisilicon/reset.c                      |   2 +-
 drivers/clk/imx/clk-scu.c                          |   1 -
 drivers/clk/mediatek/clk-mt8135.c                  |   5 +-
 drivers/clk/meson/gxbb.c                           |   2 +-
 drivers/clk/nuvoton/clk-ma35d1-pll.c               |  52 +-
 drivers/clk/qcom/common.c                          |   4 +-
 drivers/clk/qcom/gcc-mdm9607.c                     | 182 +----
 drivers/clk/qcom/gcc-msm8916.c                     |   5 +-
 drivers/clk/qcom/gcc-msm8939.c                     |   5 +-
 drivers/clk/qcom/gcc-qcm2290.c                     |  12 +-
 drivers/clk/qcom/gdsc.c                            |  25 +-
 drivers/clk/rockchip/clk-pll.c                     |   9 +-
 drivers/clk/rockchip/clk-rk3588.c                  |   2 +-
 drivers/clk/tegra/clk-tegra124-emc.c               |   1 +
 drivers/clk/ti/adpll.c                             |   4 +-
 drivers/clk/ti/divider.c                           |   2 +-
 drivers/clk/ti/mux.c                               |  22 +-
 drivers/clk/visconti/clkc.c                        |   2 +-
 drivers/clk/x86/clk-pmc-atom.c                     |   3 +
 drivers/clocksource/clps711x-timer.c               |   2 +-
 drivers/clocksource/timer-armada-370-xp.c          |  18 +-
 drivers/clocksource/timer-sun4i.c                  |   2 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   6 +-
 drivers/cpufreq/intel_pstate.c                     |  19 +-
 drivers/cpufreq/spear-cpufreq.c                    |   4 +-
 drivers/cpuidle/dt_idle_genpd.c                    |   3 +-
 drivers/crypto/atmel-ecc.c                         |  45 +-
 drivers/crypto/atmel-sha204a.c                     |   6 +-
 drivers/crypto/gemini/sl3516-ce-cipher.c           |   8 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |  12 +-
 .../crypto/intel/keembay/keembay-ocs-aes-core.c    |   9 +-
 drivers/crypto/intel/qat/qat_common/qat_algs.c     |   1 +
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |   7 +-
 drivers/crypto/sa2ul.c                             |   6 +-
 drivers/cxl/core/mbox.c                            |   7 +
 drivers/cxl/core/pmem.c                            |  10 +-
 drivers/cxl/core/region.c                          |   7 +-
 drivers/cxl/cxl.h                                  |   3 +-
 drivers/cxl/cxlmem.h                               |   2 +
 drivers/cxl/pci.c                                  |  14 +-
 drivers/cxl/pmem.c                                 |   2 +-
 drivers/dax/super.c                                |  12 +-
 drivers/dma/dw-edma/dw-edma-core.c                 | 127 +++-
 drivers/dma/dw-edma/dw-hdma-v0-core.c              |   2 +-
 drivers/dma/hisi_dma.c                             |   2 +-
 drivers/dma/mediatek/mtk-uart-apdma.c              |   2 +-
 drivers/dma/qcom/bam_dma.c                         |   1 +
 drivers/dma/xilinx/xilinx_dma.c                    |  12 +-
 drivers/firmware/arm_scmi/bus.c                    |  69 +-
 drivers/firmware/arm_scmi/driver.c                 |  54 +-
 drivers/firmware/google/coreboot_table.c           |  26 +-
 drivers/fpga/altera-cvp.c                          |  10 +-
 drivers/fpga/stratix10-soc.c                       |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   7 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |  74 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |  10 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |  10 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   3 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |   6 +
 .../display/dc/link/protocols/link_dp_dpia_bw.c    |   5 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  24 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  35 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   2 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   3 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   2 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   2 +
 drivers/gpu/drm/drm_drv.c                          |  34 +-
 drivers/gpu/drm/drm_dumb_buffers.c                 |   1 -
 drivers/gpu/drm/gud/gud_connector.c                |  12 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |  54 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   3 +
 drivers/gpu/drm/lima/lima_device.c                 |  12 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   5 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_core_perf.c      |   4 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  14 +-
 drivers/gpu/drm/mxsfb/lcdif_kms.c                  |  15 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  11 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |   4 +-
 drivers/gpu/drm/nouveau/nouveau_uvmm.c             |   3 +
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |   7 +-
 drivers/gpu/drm/omapdrm/dss/dsi.h                  |   2 -
 drivers/gpu/drm/panel/panel-edp.c                  |  19 +-
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c      |  10 +-
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |   2 +
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   2 +-
 drivers/gpu/drm/sun4i/sun4i_crtc.c                 |   2 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  22 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |   2 +
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |   2 +-
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c            |  18 +-
 drivers/gpu/drm/tve200/tve200_drv.c                |   1 +
 drivers/gpu/host1x/debug.c                         |   4 +-
 drivers/gpu/host1x/hw/channel_hw.c                 |   5 +-
 drivers/hid/hid-core.c                             |   9 +
 drivers/hid/hid-lg4ff.c                            |   8 +
 drivers/hid/hid-mcp2221.c                          |   9 +
 drivers/hid/hid-nintendo.c                         |   1 -
 drivers/hid/hid-picolcd_debugfs.c                  |   9 +
 drivers/hid/hid-rmi.c                              |  46 +-
 drivers/hid/hid-roccat-kone.c                      |   8 +-
 drivers/hid/hid-roccat.c                           |  13 +-
 drivers/hid/hid-sensor-custom.c                    |   9 +-
 drivers/hid/hid-sensor-hub.c                       |  46 +-
 drivers/hid/i2c-hid/Makefile                       |   2 +-
 drivers/hid/i2c-hid/i2c-hid-acpi-prp0001.c         | 104 +++
 drivers/hid/i2c-hid/i2c-hid-acpi.c                 |  54 +-
 drivers/hid/i2c-hid/i2c-hid-acpi.h                 |  33 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 | 119 ++--
 drivers/hid/i2c-hid/i2c-hid-of-goodix.c            |   4 +-
 drivers/hid/wacom_wac.c                            |  13 +
 drivers/hsi/controllers/omap_ssi_core.c            |   6 +
 drivers/hwmon/emc1403.c                            | 756 ++++++++++++--------
 drivers/hwmon/max6621.c                            |   8 +-
 drivers/hwspinlock/hwspinlock_core.c               |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x-cfg.c  |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  15 +-
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   6 +-
 drivers/hwtracing/coresight/coresight-etm4x.h      |   9 +-
 drivers/hwtracing/ptt/hisi_ptt.c                   |  20 +-
 drivers/i2c/busses/i2c-ocores.c                    |   6 +-
 drivers/i2c/i2c-core-base.c                        |   6 +
 drivers/i2c/i2c-mux.c                              |   1 +
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/i3c/master.c                               |  11 +-
 drivers/i3c/master/dw-i3c-master.c                 |  10 +-
 drivers/i3c/master/mipi-i3c-hci/core.c             |  30 +-
 drivers/i3c/master/mipi-i3c-hci/dma.c              |   4 +-
 drivers/i3c/master/mipi-i3c-hci/ext_caps.c         |  55 +-
 drivers/i3c/master/mipi-i3c-hci/pio.c              |  54 +-
 drivers/i3c/master/svc-i3c-master.c                |  10 +-
 drivers/iio/accel/dmard09.c                        |   7 +
 drivers/iio/chemical/atlas-sensor.c                |  19 +-
 drivers/iio/chemical/sgp30.c                       |   3 +
 drivers/iio/dac/m62332.c                           |  17 +-
 drivers/iio/gyro/mpu3050-core.c                    |   2 +-
 drivers/iio/light/cm32181.c                        |   2 +-
 drivers/iio/light/gp2ap002.c                       |  24 +-
 drivers/iio/light/isl29028.c                       |   2 +-
 drivers/iio/light/opt4001.c                        |  37 +-
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/iio/light/tsl2772.c                        |   2 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |  20 +-
 drivers/iio/pressure/dps310.c                      |   3 +-
 drivers/iio/pressure/mpl115.c                      |  11 +-
 drivers/iio/proximity/srf04.c                      |   1 +
 drivers/iio/temperature/hid-sensor-temperature.c   |   3 +-
 drivers/infiniband/core/cma.c                      |   6 +-
 drivers/infiniband/core/core_priv.h                |   1 +
 drivers/infiniband/core/counters.c                 |   5 +-
 drivers/infiniband/core/cq.c                       |  14 +-
 drivers/infiniband/core/device.c                   |   3 +
 drivers/infiniband/core/nldev.c                    | 106 ++-
 drivers/infiniband/core/restrack.c                 | 186 ++++-
 drivers/infiniband/core/restrack.h                 |   4 +
 drivers/infiniband/core/ucma.c                     |   7 +-
 drivers/infiniband/core/uverbs_cmd.c               |  13 +-
 drivers/infiniband/core/verbs.c                    |  32 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   6 +-
 drivers/infiniband/hw/cxgb4/device.c               |   8 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   4 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |  15 +-
 drivers/infiniband/hw/erdma/Kconfig                |   2 +-
 drivers/infiniband/hw/erdma/erdma_eq.c             |   7 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |  12 +-
 drivers/infiniband/hw/erdma/erdma_verbs.h          |  25 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   4 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   2 -
 drivers/infiniband/hw/hfi1/init.c                  |  44 +-
 drivers/infiniband/hw/hfi1/user_sdma.c             |  13 +-
 drivers/infiniband/hw/mlx5/cong.c                  |   8 +-
 drivers/infiniband/hw/mlx5/main.c                  |   2 +
 drivers/infiniband/hw/mlx5/qp.c                    |  25 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  15 +
 drivers/infiniband/sw/rxe/rxe_resp.c               |   9 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |  32 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +
 drivers/infiniband/ulp/isert/ib_isert.c            |  85 ++-
 drivers/infiniband/ulp/isert/ib_isert.h            |   1 +
 drivers/infiniband/ulp/srp/ib_srp.c                |  45 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   9 +-
 drivers/input/tablet/aiptek.c                      |  13 +-
 drivers/interconnect/core.c                        |   7 +-
 drivers/iommu/amd/init.c                           |  42 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   5 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |   6 +-
 drivers/iommu/dma-iommu.c                          |  13 +-
 drivers/iommu/intel/dmar.c                         |  15 +-
 drivers/iommu/intel/iommu.c                        |  18 +-
 drivers/iommu/intel/iommu.h                        |   2 +
 drivers/iommu/msm_iommu.c                          |   2 +-
 drivers/iommu/mtk_iommu_v1.c                       |   2 +-
 drivers/ipack/devices/ipoctal.c                    |  70 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  23 +-
 drivers/irqchip/irq-mbigen.c                       |  20 +-
 drivers/irqchip/irq-renesas-irqc.c                 |   1 +
 drivers/irqchip/irq-renesas-rzg2l.c                |   4 +-
 drivers/leds/leds-pca9532.c                        |  18 +-
 drivers/mailbox/pcc.c                              |  70 +-
 drivers/mailbox/qcom-ipcc.c                        |  17 +-
 drivers/mailbox/rockchip-mailbox.c                 |  17 +-
 drivers/md/dm-era-target.c                         |   5 +
 drivers/md/dm-log-userspace-base.c                 |   1 +
 drivers/md/dm-stats.c                              |   6 +-
 drivers/md/dm-switch.c                             |   2 +-
 drivers/md/dm.c                                    |  14 +-
 drivers/md/md-bitmap.c                             |   6 +-
 drivers/md/md.c                                    |   9 +
 drivers/md/persistent-data/dm-array.c              |  16 +
 drivers/md/raid1.c                                 |   2 -
 drivers/md/raid5-ppl.c                             |   4 +-
 drivers/md/raid5.c                                 |  23 +-
 drivers/media/cec/core/cec-adap.c                  |   8 +-
 drivers/media/cec/core/cec-core.c                  |   2 -
 drivers/media/cec/core/cec-pin.c                   |   8 +-
 drivers/media/cec/platform/meson/ao-cec-g12a.c     |   1 +
 drivers/media/cec/platform/stm32/stm32-cec.c       |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  23 +-
 drivers/media/i2c/ov02a10.c                        |  12 +-
 drivers/media/i2c/ov7740.c                         |   4 +-
 drivers/media/i2c/rdacm21.c                        |   5 +-
 drivers/media/i2c/video-i2c.c                      |   8 +-
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |   1 -
 drivers/media/pci/cx23885/cimax2.c                 |   1 +
 drivers/media/pci/saa7164/saa7164-core.c           |   8 +-
 drivers/media/pci/zoran/zoran_card.c               |   2 +-
 .../platform/nxp/imx8-isi/imx8-isi-crossbar.c      |   6 +-
 .../media/platform/nxp/imx8-isi/imx8-isi-video.c   |   2 +-
 drivers/media/platform/qcom/venus/hfi_parser.c     |   9 +-
 drivers/media/rc/sunxi-cir.c                       |   9 +-
 drivers/media/test-drivers/vicodec/vicodec-core.c  |   4 +-
 drivers/media/test-drivers/vimc/vimc-capture.c     |   4 +-
 drivers/media/tuners/tda18250.c                    |   4 +-
 drivers/media/usb/airspy/airspy.c                  |  19 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   3 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   2 +
 drivers/media/usb/go7007/snd-go7007.c              |  10 +-
 drivers/media/usb/s2255/s2255drv.c                 |  11 +
 drivers/media/usb/usbtv/usbtv-audio.c              |  11 +
 drivers/media/v4l2-core/v4l2-async.c               |  19 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |  49 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   2 +
 drivers/mfd/iqs62x.c                               |   2 +-
 drivers/mfd/rave-sp.c                              |  64 +-
 drivers/misc/ad525x_dpot-i2c.c                     |   1 +
 drivers/misc/ad525x_dpot-spi.c                     |   1 +
 drivers/misc/ad525x_dpot.c                         | 177 +++--
 drivers/misc/ad525x_dpot.h                         |   3 +
 drivers/misc/bcm-vk/bcm_vk_msg.c                   |   6 +-
 drivers/misc/cardreader/rtsx_pcr.c                 |   2 +
 drivers/misc/cardreader/rtsx_usb.c                 |  23 +-
 drivers/misc/vmw_vmci/vmci_event.c                 |   4 +-
 drivers/mmc/host/via-sdmmc.c                       |   8 +-
 drivers/mtd/mtdoops.c                              |   3 +
 drivers/mtd/mtdpart.c                              |   3 +-
 drivers/mtd/mtdswap.c                              |   1 +
 drivers/mtd/nand/raw/nand_onfi.c                   |  27 +-
 drivers/mtd/parsers/afs.c                          |   7 +
 drivers/mtd/ubi/attach.c                           |   4 +-
 drivers/mtd/ubi/build.c                            |  35 +-
 drivers/mtd/ubi/cdev.c                             |   3 +-
 drivers/mtd/ubi/eba.c                              |   3 -
 drivers/mtd/ubi/fastmap-wl.c                       |  53 +-
 drivers/mtd/ubi/fastmap.c                          |  68 +-
 drivers/mtd/ubi/io.c                               |  11 +-
 drivers/mtd/ubi/ubi.h                              |  12 +-
 drivers/mtd/ubi/wl.c                               |  32 +-
 drivers/mtd/ubi/wl.h                               |   6 +-
 drivers/net/bonding/bond_netlink.c                 |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/dsa/b53/b53_common.c                   |   2 +-
 drivers/net/dsa/mv88e6xxx/pcs-6352.c               |   5 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  12 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   2 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   6 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   8 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |   1 +
 drivers/net/ethernet/realtek/8139cp.c              |   2 +-
 drivers/net/ethernet/renesas/ravb.h                |   1 +
 drivers/net/ethernet/renesas/ravb_main.c           |   3 +-
 drivers/net/ethernet/renesas/ravb_ptp.c            |  15 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  41 +-
 drivers/net/ethernet/sun/niu.c                     |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |   4 +-
 drivers/net/gtp.c                                  |   2 +
 drivers/net/ipa/ipa_main.c                         |  29 +-
 drivers/net/ntb_netdev.c                           |  38 +-
 drivers/net/ppp/pppox.c                            |  17 +
 drivers/net/slip/slip.c                            |  19 +-
 drivers/net/thunderbolt/main.c                     |  18 +-
 drivers/net/tun.c                                  |  21 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/vxlan/vxlan_core.c                     |   2 +
 drivers/net/vxlan/vxlan_mdb.c                      | 365 +++++++++-
 drivers/net/vxlan/vxlan_private.h                  |   4 +
 drivers/net/vxlan/vxlan_vnifilter.c                |   6 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   9 +-
 drivers/net/wireless/ath/ath11k/Makefile           |   4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   8 +
 drivers/net/wireless/ath/ath11k/core.h             |  15 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  32 +-
 drivers/net/wireless/ath/ath11k/fw.c               | 168 +++++
 drivers/net/wireless/ath/ath11k/fw.h               |  27 +
 drivers/net/wireless/ath/ath11k/mhi.c              |  18 +-
 drivers/net/wireless/ath/ath11k/p2p.c              | 149 ++++
 drivers/net/wireless/ath/ath11k/p2p.h              |  22 +
 drivers/net/wireless/ath/ath11k/pci.c              |   2 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  56 +-
 drivers/net/wireless/ath/ath11k/testmode.c         |   2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              | 167 +++--
 drivers/net/wireless/ath/ath11k/wmi.h              |  35 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  12 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   5 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   3 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   8 +-
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |  10 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  66 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  12 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  18 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   6 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   2 -
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |  12 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |  11 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   1 +
 drivers/net/wireless/realtek/rtw89/mac.c           |   2 +-
 drivers/net/wireless/virtual/mac80211_hwsim.c      |   5 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   8 +
 drivers/nfc/pn533/pn533.c                          |  21 +-
 drivers/ntb/ntb_transport.c                        |  38 +-
 drivers/nvdimm/btt.c                               |   8 +
 drivers/nvdimm/label.c                             |  17 +-
 drivers/nvme/host/apple.c                          | 227 ++++--
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/fc.c                             |   8 +-
 drivers/nvme/host/ioctl.c                          | 117 +--
 drivers/nvme/host/pci.c                            |   1 +
 drivers/nvme/host/tcp.c                            |  52 +-
 drivers/nvme/target/auth.c                         |   6 +
 drivers/nvme/target/core.c                         |   2 +-
 drivers/nvme/target/fabrics-cmd-auth.c             |  12 +-
 drivers/nvme/target/nvmet.h                        |   2 +
 drivers/nvme/target/rdma.c                         | 121 ++--
 drivers/nvme/target/tcp.c                          |  10 +
 drivers/nvme/target/zns.c                          |   2 +-
 drivers/of/base.c                                  |   2 +-
 drivers/of/property.c                              |  91 ++-
 drivers/parisc/eisa.c                              |   5 +
 drivers/pci/controller/cadence/pci-j721e.c         |   4 +-
 drivers/pci/controller/dwc/pci-meson.c             |   2 +-
 drivers/pci/controller/pci-hyperv.c                |   1 +
 drivers/pci/controller/pci-xgene.c                 |  11 +-
 drivers/pci/msi/msi.c                              |  10 +
 drivers/pci/pci-sysfs.c                            |   4 +-
 drivers/pci/proc.c                                 |  16 +-
 drivers/pci/quirks.c                               |   6 +-
 drivers/perf/arm_spe_pmu.c                         |   2 +-
 drivers/perf/cxl_pmu.c                             |   2 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |   2 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c     |  12 +-
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            |  12 +-
 drivers/phy/qualcomm/phy-qcom-sgmii-eth.c          |  43 +-
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c      |  26 +-
 drivers/phy/rockchip/phy-rockchip-inno-csidphy.c   |   2 +-
 drivers/phy/starfive/phy-jh7110-dphy-rx.c          |   5 +-
 drivers/phy/sunplus/phy-sunplus-usb2.c             |   6 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |   1 -
 drivers/pinctrl/mediatek/mtk-eint.c                | 340 +++++----
 drivers/pinctrl/mediatek/mtk-eint.h                |  28 +-
 drivers/pinctrl/mediatek/pinctrl-moore.h           |  12 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |  40 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h   |   1 +
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |  14 +-
 drivers/pinctrl/mediatek/pinctrl-paris.h           |  19 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |  10 +
 drivers/platform/chrome/cros_ec_debugfs.c          |   6 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |  28 +-
 drivers/platform/chrome/cros_ec_typec.c            |   6 +
 drivers/platform/mellanox/mlxbf-bootctl.c          |   1 +
 drivers/platform/mellanox/mlxbf-pmc.c              |  10 +-
 drivers/platform/surface/surface_acpi_notify.c     |   6 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |  17 +-
 drivers/platform/x86/dell/dell-wmi-privacy.c       |   4 +-
 .../x86/dell/dell-wmi-sysman/biosattr-interface.c  |   1 -
 .../x86/dell/dell-wmi-sysman/dell-wmi-sysman.h     |   2 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |  18 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h       |   8 +
 .../platform/x86/hp/hp-bioscfg/enum-attributes.c   |  15 +-
 .../platform/x86/hp/hp-bioscfg/int-attributes.c    |   6 +-
 .../x86/hp/hp-bioscfg/order-list-attributes.c      |  14 +-
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |  19 +-
 .../platform/x86/hp/hp-bioscfg/spmobj-attributes.c |   4 +-
 .../platform/x86/hp/hp-bioscfg/string-attributes.c |   6 +-
 drivers/platform/x86/intel/ishtp_eclite.c          |   5 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |  30 +-
 drivers/pmdomain/bcm/bcm2835-power.c               |   7 +-
 drivers/power/supply/bd99954-charger.h             |  23 +-
 drivers/power/supply/bq24257_charger.c             |  16 +-
 drivers/power/supply/bq256xx_charger.c             |  29 +-
 drivers/power/supply/bq25890_charger.c             |  12 +
 drivers/power/supply/bq27xxx_battery.c             |   6 +-
 drivers/power/supply/cros_usbpd-charger.c          |  17 +-
 drivers/power/supply/isp1704_charger.c             |   1 +
 drivers/power/supply/lp8727_charger.c              |   4 +-
 drivers/power/supply/max17040_battery.c            |   6 +-
 drivers/power/supply/qcom_battmgr.c                |   2 +-
 drivers/power/supply/rt9455_charger.c              |  21 +-
 drivers/power/supply/sbs-battery.c                 |   7 +-
 drivers/power/supply/sc2731_charger.c              |   8 +-
 drivers/power/supply/twl4030_charger.c             |  12 +-
 drivers/power/supply/ucs1002_power.c               |   6 +-
 drivers/pps/clients/pps-gpio.c                     |  62 +-
 drivers/pps/pps.c                                  |  10 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  10 +-
 drivers/rapidio/rio-scan.c                         |   1 +
 drivers/regulator/Kconfig                          |   4 +-
 drivers/regulator/as3722-regulator.c               |   1 -
 drivers/regulator/core.c                           |   6 +-
 drivers/regulator/max8998.c                        |   1 -
 drivers/regulator/qcom-refgen-regulator.c          |   4 +-
 drivers/regulator/qcom-rpmh-regulator.c            |   6 +-
 drivers/regulator/tps6594-regulator.c              | 445 +++++++++---
 drivers/remoteproc/mtk_scp.c                       |   9 +-
 drivers/remoteproc/qcom_common.c                   |   4 +-
 drivers/remoteproc/qcom_q6v5_adsp.c                |   1 +
 drivers/remoteproc/remoteproc_core.c               | 156 ++--
 drivers/remoteproc/remoteproc_sysfs.c              |   1 -
 drivers/rpmsg/qcom_glink_native.c                  |  44 +-
 drivers/rpmsg/qcom_glink_smem.c                    |   7 +
 drivers/rtc/rtc-gamecube.c                         |   4 +-
 drivers/rtc/rtc-pcf85363.c                         |  17 +-
 drivers/rtc/rtc-pcf8563.c                          |   4 +-
 drivers/rtc/rtc-rzn1.c                             |  10 +-
 drivers/rtc/rtc-zynqmp.c                           |   7 +-
 drivers/s390/block/dasd.c                          |   6 +-
 drivers/s390/block/dasd_eckd.c                     |  40 +-
 drivers/s390/block/dasd_erp.c                      |   3 +
 drivers/s390/crypto/vfio_ap_ops.c                  | 176 +++--
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +
 drivers/scsi/pm8001/pm8001_init.c                  |   4 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   7 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  39 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  61 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |  13 +
 drivers/scsi/qla2xxx/qla_isr.c                     |  39 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  28 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  31 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/scsi_lib.c                            |   2 +
 drivers/scsi/sd.c                                  |   4 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |  18 +
 drivers/soc/fsl/qe/qe_ic.c                         |   3 +-
 drivers/soc/qcom/rpmh-rsc.c                        |  37 +-
 drivers/soc/samsung/exynos-pmu.c                   |   4 +-
 drivers/soc/ti/knav_qmss.h                         |   1 +
 drivers/soc/ti/knav_qmss_queue.c                   |  14 +-
 drivers/soundwire/qcom.c                           |   2 +-
 drivers/spi/spi-bcm63xx-hsspi.c                    |   8 +-
 drivers/spi/spi-bcm63xx.c                          |   6 +-
 drivers/spi/spi-bcmbca-hsspi.c                     |   8 +-
 drivers/spi/spi-davinci.c                          |  22 +-
 drivers/spi/spi-img-spfi.c                         |   5 +-
 drivers/spi/spi-sprd-adi.c                         |   6 +
 drivers/staging/fbtft/fbtft-sysfs.c                |   2 +-
 drivers/staging/greybus/audio_gb.c                 |  13 +
 drivers/staging/greybus/audio_manager_sysfs.c      |   2 +-
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/media/tegra-video/vi.c             |   9 +-
 drivers/staging/media/tegra-video/vip.c            |  10 +-
 drivers/staging/octeon/ethernet-mem.c              |  43 +-
 drivers/staging/octeon/ethernet-mem.h              |   8 +-
 drivers/staging/octeon/ethernet-rx.c               |  53 +-
 drivers/staging/octeon/ethernet-rx.h               |  13 +-
 drivers/staging/octeon/ethernet-tx.c               |   2 +
 drivers/staging/octeon/ethernet.c                  |  43 +-
 drivers/staging/octeon/octeon-ethernet.h           |  14 +
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |   8 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   7 +
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   4 +-
 drivers/staging/sm750fb/sm750.c                    |   4 +-
 drivers/target/iscsi/iscsi_target_login.c          |   2 +-
 drivers/thermal/imx_thermal.c                      |   9 +-
 .../intel/int340x_thermal/int3400_thermal.c        |   4 +-
 drivers/thermal/qoriq_thermal.c                    |  13 +-
 drivers/thermal/rcar_thermal.c                     |  15 +-
 drivers/tty/hvc/Kconfig                            |   2 +-
 drivers/tty/serial/amba-pl011.c                    |  10 +
 drivers/tty/serial/ma35d1_serial.c                 |  12 +-
 drivers/tty/tty_io.c                               |   4 +-
 drivers/ufs/core/ufs-debugfs.c                     |   2 +-
 drivers/ufs/core/ufshcd.c                          |  18 +-
 drivers/uio/uio.c                                  |   5 +
 drivers/usb/atm/usbatm.c                           |   4 +-
 drivers/usb/common/common.c                        |   3 +
 drivers/usb/core/driver.c                          |  88 +--
 drivers/usb/core/usb.c                             |   2 +-
 drivers/usb/core/usb.h                             |   8 +-
 drivers/usb/dwc2/gadget.c                          |  11 +-
 drivers/usb/gadget/configfs.c                      |   4 +-
 drivers/usb/gadget/function/f_fs.c                 |  14 +-
 drivers/usb/gadget/function/f_mass_storage.c       |   2 +-
 drivers/usb/gadget/function/f_midi2.c              |  19 +-
 drivers/usb/gadget/function/f_tcm.c                |  23 +-
 drivers/usb/gadget/function/f_uac1_legacy.c        |  56 --
 drivers/usb/gadget/function/f_uvc.c                |   7 +-
 drivers/usb/gadget/function/u_audio.c              |  24 +-
 drivers/usb/gadget/function/u_uac1_legacy.h        |   3 -
 drivers/usb/gadget/functions.c                     |   2 +-
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 drivers/usb/gadget/udc/aspeed_udc.c                |  43 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   1 -
 drivers/usb/gadget/udc/snps_udc_plat.c             |   5 +-
 drivers/usb/host/xhci-ring.c                       |  32 +-
 drivers/usb/image/mdc800.c                         |   4 +-
 drivers/usb/misc/onboard_usb_hub.c                 |   2 +-
 drivers/usb/mtu3/mtu3_core.c                       |  11 +-
 drivers/usb/phy/phy-fsl-usb.c                      |  52 +-
 drivers/usb/phy/phy-fsl-usb.h                      |   6 +-
 drivers/usb/renesas_usbhs/common.c                 |   6 +-
 drivers/usb/serial/bus.c                           |   6 +-
 drivers/usb/serial/usb-serial.c                    |   6 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +
 drivers/usb/storage/uas.c                          |   2 +-
 .../usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c    |   2 +
 drivers/usb/typec/ucsi/debugfs.c                   |   1 +
 drivers/usb/typec/ucsi/displayport.c               |   2 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  12 +-
 drivers/usb/typec/ucsi/ucsi.h                      |   3 +
 drivers/usb/typec/ucsi/ucsi_acpi.c                 |   3 +-
 drivers/usb/usbip/stub_main.c                      |   8 +-
 drivers/vdpa/mlx5/core/mr.c                        |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |  25 +-
 drivers/vfio/pci/vfio_pci_config.c                 |   1 +
 drivers/video/fbdev/kyro/fbdev.c                   |  24 +-
 .../fbdev/omap2/omapfb/displays/panel-dsi-cm.c     |   4 +-
 drivers/video/fbdev/pvr2fb.c                       |   4 +-
 drivers/video/fbdev/ssd1307fb.c                    |  72 +-
 drivers/video/fbdev/tdfxfb.c                       |   2 +-
 drivers/video/fbdev/uvesafb.c                      |   2 +
 drivers/video/sticore.c                            |  22 +-
 drivers/virtio/virtio_balloon.c                    |   6 +
 drivers/w1/masters/ds2482.c                        |   4 +
 drivers/w1/slaves/w1_ds28e17.c                     |   8 +
 drivers/watchdog/pseries-wdt.c                     |  53 +-
 drivers/xen/xenbus/xenbus_xs.c                     |  16 +-
 fs/btrfs/verity.c                                  |  16 +-
 fs/ceph/caps.c                                     |  11 +-
 fs/ceph/crypto.c                                   |  34 +-
 fs/ceph/export.c                                   |  26 +-
 fs/ceph/file.c                                     |  48 ++
 fs/ceph/mdsmap.c                                   |  11 +-
 fs/ceph/xattr.c                                    |  17 +
 fs/ecryptfs/crypto.c                               |   2 +-
 fs/ecryptfs/ecryptfs_kernel.h                      |   3 +-
 fs/ecryptfs/keystore.c                             |  45 +-
 fs/ecryptfs/messaging.c                            |  11 +-
 fs/ecryptfs/miscdev.c                              |   5 +-
 fs/ecryptfs/super.c                                |   7 +
 fs/efivarfs/super.c                                |  30 +-
 fs/erofs/Kconfig                                   |   8 +-
 fs/ext4/file.c                                     |   7 +
 fs/ext4/inline.c                                   |  11 +-
 fs/ext4/inode.c                                    |  28 +-
 fs/ext4/migrate.c                                  |   3 +-
 fs/ext4/namei.c                                    |   2 +
 fs/ext4/orphan.c                                   |  10 +-
 fs/f2fs/file.c                                     | 116 ++-
 fs/f2fs/namei.c                                    |  11 +-
 fs/f2fs/xattr.c                                    |   2 +-
 fs/fat/misc.c                                      |   4 +
 fs/fat/nfs.c                                       |   4 +-
 fs/fuse/control.c                                  |   2 +-
 fs/fuse/cuse.c                                     |   5 +
 fs/fuse/dev.c                                      |  40 +-
 fs/fuse/dir.c                                      |  21 +-
 fs/fuse/fuse_i.h                                   |  36 +-
 fs/fuse/inode.c                                    |  87 ++-
 fs/fuse/readdir.c                                  |  42 +-
 fs/hfsplus/catalog.c                               |  25 +-
 fs/hfsplus/hfsplus_fs.h                            |   6 +
 fs/hugetlbfs/inode.c                               |   3 +-
 fs/isofs/compress.c                                |   7 +-
 fs/lockd/svcsubs.c                                 |  53 +-
 fs/nfs/client.c                                    |  21 +-
 fs/nfs/filelayout/filelayoutdev.c                  |   3 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   3 +-
 fs/nfs/inode.c                                     |   4 +-
 fs/nfs/internal.h                                  |   1 +
 fs/nfs/netns.h                                     |   6 +-
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/pnfs.c                                      |  36 +-
 fs/nfs/pnfs.h                                      |   3 +-
 fs/nfs/pnfs_nfs.c                                  |  39 +-
 fs/nfsd/flexfilelayoutxdr.c                        |  20 +-
 fs/nfsd/nfs2acl.c                                  |  52 +-
 fs/nfsd/nfs3acl.c                                  |  17 +-
 fs/nfsd/nfs4proc.c                                 |  39 +-
 fs/nfsd/nfs4state.c                                | 206 ++++--
 fs/nfsd/nfs4xdr.c                                  |  17 +
 fs/nfsd/nfscache.c                                 |   2 +-
 fs/nfsd/nfsfh.c                                    |   4 +-
 fs/nfsd/nfsproc.c                                  |   7 +
 fs/nfsd/nfssvc.c                                   |   4 +-
 fs/nfsd/nfsxdr.c                                   |  32 +-
 fs/nfsd/vfs.c                                      |   4 +-
 fs/nilfs2/bmap.c                                   |   2 +-
 fs/nilfs2/bmap.h                                   |   2 +-
 fs/nilfs2/btnode.c                                 |  30 +-
 fs/nilfs2/btree.c                                  |  39 +-
 fs/nilfs2/direct.c                                 |   4 +-
 fs/nilfs2/page.c                                   |  66 +-
 fs/nilfs2/page.h                                   |   8 +-
 fs/nilfs2/segment.c                                |  40 +-
 fs/nilfs2/the_nilfs.c                              |   6 +
 fs/notify/fanotify/fanotify_user.c                 |  17 +-
 fs/notify/inotify/inotify_user.c                   |  15 +-
 fs/ntfs3/attrib.c                                  |  11 +-
 fs/ntfs3/frecord.c                                 |  88 ++-
 fs/ntfs3/fslog.c                                   |  47 +-
 fs/ntfs3/fsntfs.c                                  |   8 +-
 fs/ntfs3/ntfs_fs.h                                 |  21 +-
 fs/ntfs3/record.c                                  | 125 ++--
 fs/ntfs3/super.c                                   |  13 +-
 fs/ntfs3/xattr.c                                   |  25 +-
 fs/ocfs2/acl.c                                     | 141 ++--
 fs/ocfs2/acl.h                                     |  19 +-
 fs/ocfs2/cluster/heartbeat.c                       | 193 +++--
 fs/ocfs2/cluster/heartbeat.h                       |   5 +
 fs/ocfs2/cluster/nodemanager.c                     |  10 +
 fs/ocfs2/cluster/nodemanager.h                     |   1 +
 fs/ocfs2/cluster/tcp.c                             |  83 ++-
 fs/ocfs2/cluster/tcp.h                             |   1 +
 fs/ocfs2/dir.c                                     |   2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |   6 +
 fs/ocfs2/dlm/dlmrecovery.c                         |   9 +
 fs/ocfs2/namei.c                                   |  17 +-
 fs/ocfs2/refcounttree.c                            |  47 +-
 fs/ocfs2/xattr.c                                   |  91 ++-
 fs/ocfs2/xattr.h                                   |   9 +-
 fs/orangefs/devorangefs-req.c                      |   1 +
 fs/orangefs/orangefs-debugfs.c                     |   1 +
 fs/smb/client/cifs_debug.c                         |   2 +-
 fs/smb/client/cifsfs.c                             |  15 +-
 fs/smb/client/dfs_cache.c                          |  33 +-
 fs/smb/client/smb1ops.c                            |   2 +-
 fs/smb/client/smb2file.c                           |   5 +-
 fs/smb/client/smb2pdu.c                            |  16 +-
 fs/smb/server/auth.c                               |   1 +
 fs/smb/server/connection.c                         |  19 +
 fs/smb/server/connection.h                         |   1 +
 fs/smb/server/mgmt/user_config.c                   |   1 +
 fs/smb/server/mgmt/user_session.c                  |  11 +
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/server.c                             |   4 +-
 fs/smb/server/smb2ops.c                            |  11 +-
 fs/smb/server/smb2pdu.c                            |  39 +-
 fs/smb/server/smbacl.c                             |  20 +-
 fs/smb/server/transport_ipc.c                      |  12 +
 fs/smb/server/transport_tcp.c                      |   6 +
 fs/smb/server/vfs.c                                |   3 -
 fs/smb/server/vfs_cache.c                          |  13 +-
 fs/squashfs/cache.c                                |   2 +-
 fs/tracefs/event_inode.c                           |   7 +-
 fs/ubifs/auth.c                                    |   2 +-
 fs/udf/inode.c                                     |   2 +-
 fs/udf/partition.c                                 |   2 +-
 fs/udf/super.c                                     |  23 +-
 fs/udf/symlink.c                                   |   2 +
 include/acpi/pcc.h                                 |   5 -
 include/acpi/processor.h                           |   2 +
 include/linux/bpf.h                                |   4 +-
 include/linux/efi.h                                |   4 +-
 include/linux/irq.h                                |  35 +
 include/linux/irqdomain.h                          |  46 ++
 include/linux/kprobes.h                            |   1 +
 include/linux/list.h                               |  15 +-
 include/linux/maple_tree.h                         |   2 +-
 include/linux/mfd/tps6594.h                        | 347 ++++++++-
 include/linux/netdevice.h                          |  10 +
 include/linux/nfs_xdr.h                            |   2 +-
 include/linux/nvme.h                               |  81 +++
 include/linux/of_graph.h                           |  53 +-
 include/linux/rcutiny.h                            |   2 +-
 include/linux/rcutree.h                            |   3 +-
 include/linux/remoteproc.h                         | 284 +-------
 include/linux/rsc_table.h                          | 364 ++++++++++
 include/linux/rtsx_usb.h                           |   3 +
 include/linux/sunrpc/svc_rdma_pcl.h                |   2 +-
 include/linux/usb.h                                |  29 +-
 include/linux/virtio_net.h                         |   4 +
 include/media/rc-map.h                             |   2 -
 include/net/bluetooth/hci_core.h                   |   2 +-
 include/net/bluetooth/l2cap.h                      |   5 +
 include/net/dst.h                                  |  34 +-
 include/net/inet_connection_sock.h                 |  12 +-
 include/net/inet_hashtables.h                      |   2 +-
 include/net/inetpeer.h                             |   4 +
 include/net/ip.h                                   |  11 +-
 include/net/ip_tunnels.h                           |  11 +-
 include/net/pkt_sched.h                            |   1 +
 include/net/route.h                                |   2 +-
 include/net/sctp/structs.h                         |   2 +-
 include/net/tc_act/tc_skbmod.h                     |   1 +
 include/net/tcp.h                                  |  13 +-
 include/net/xsk_buff_pool.h                        |  19 +-
 include/rdma/ib_verbs.h                            |  14 +
 include/rdma/restrack.h                            |   7 +-
 include/sound/core.h                               |   2 +
 include/uapi/linux/if_bridge.h                     |  19 +
 include/uapi/linux/if_link.h                       |   1 +
 include/uapi/linux/landlock.h                      |   1 +
 include/uapi/linux/time_types.h                    |   2 +-
 include/uapi/rdma/rdma_netlink.h                   |   8 +
 kernel/auditfilter.c                               |   6 +-
 kernel/bpf/bloom_filter.c                          |  19 +-
 kernel/bpf/cgroup.c                                |  18 +-
 kernel/bpf/net_namespace.c                         |  17 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/syscall.c                               |  21 +-
 kernel/bpf/task_iter.c                             |  36 +-
 kernel/bpf/verifier.c                              |  24 +-
 kernel/cgroup/cpuset.c                             |   4 +-
 kernel/dma/swiotlb.c                               |  31 +-
 kernel/entry/common.c                              |   3 +
 kernel/futex/requeue.c                             |  12 +-
 kernel/irq/generic-chip.c                          | 147 ++--
 kernel/irq/irqdomain.c                             |  91 ++-
 kernel/kcsan/core.c                                |  12 +-
 kernel/kprobes.c                                   |  14 +-
 kernel/locking/lockdep.c                           |   2 +
 kernel/power/snapshot.c                            |   5 +-
 kernel/power/wakelock.c                            |   2 +-
 kernel/rcu/rcutorture.c                            |   4 +-
 kernel/rcu/tree.c                                  |   4 +-
 kernel/rcu/tree_nocb.h                             |   2 +-
 kernel/rcu/tree_plugin.h                           |  16 +-
 kernel/sched/cpufreq_schedutil.c                   |  17 +-
 kernel/sched/fair.c                                |  27 +-
 kernel/signal.c                                    |   4 +
 kernel/stop_machine.c                              |   2 +-
 kernel/sys.c                                       |   2 +-
 kernel/taskstats.c                                 |   3 +-
 kernel/time/clocksource.c                          |   8 +-
 kernel/time/itimer.c                               |   2 +-
 kernel/time/timekeeping.c                          |   6 +
 kernel/time/timer.c                                |   1 +
 kernel/trace/trace.c                               |  28 +-
 kernel/trace/trace.h                               |   4 +-
 kernel/trace/trace_events.c                        | 136 +++-
 kernel/trace/trace_events_hist.c                   |   4 +-
 kernel/trace/trace_events_user.c                   |   3 +
 kernel/trace/trace_mmiotrace.c                     |  24 +-
 kernel/trace/trace_osnoise.c                       |   4 +-
 lib/string.c                                       |   3 +-
 lib/test_hmm.c                                     |   2 +-
 lib/ucs2_string.c                                  |   2 +-
 lib/xarray.c                                       |   3 +
 mm/damon/core-test.h                               |  15 +-
 mm/damon/core.c                                    |  17 +-
 mm/damon/paddr.c                                   |  21 +-
 mm/damon/sysfs-schemes.c                           |  10 +-
 mm/damon/sysfs.c                                   |  19 +-
 mm/damon/vaddr-test.h                              |   5 +
 mm/damon/vaddr.c                                   |  34 +-
 mm/hugetlb.c                                       |  14 +-
 mm/kasan/quarantine.c                              |   7 +-
 mm/memcontrol.c                                    |   6 +
 mm/migrate.c                                       |   2 +-
 mm/mm_init.c                                       |   5 +-
 mm/vmscan.c                                        |   2 +-
 net/batman-adv/bridge_loop_avoidance.c             |  80 ++-
 net/batman-adv/distributed-arp-table.c             |  66 +-
 net/batman-adv/main.c                              |   4 +
 net/batman-adv/types.h                             |   2 +-
 net/bluetooth/eir.c                                |   3 +-
 net/bluetooth/hci_conn.c                           |  23 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/bluetooth/hci_event.c                          |   7 +-
 net/bluetooth/hci_sync.c                           |  14 +-
 net/bluetooth/iso.c                                |   8 +
 net/bluetooth/l2cap_sock.c                         |  36 +-
 net/bluetooth/mgmt.c                               |  27 +-
 net/bluetooth/msft.c                               |   5 +
 net/bluetooth/rfcomm/core.c                        |  12 +-
 net/bridge/br_mrp_netlink.c                        |   4 +-
 net/bridge/br_netlink_tunnel.c                     |   3 +-
 net/bridge/br_vlan.c                               |   4 +-
 net/ceph/messenger_v2.c                            |   5 +
 net/ceph/osd_client.c                              |  30 +
 net/ceph/osdmap.c                                  |   2 +
 net/core/dst.c                                     |   4 +-
 net/core/filter.c                                  |  26 +-
 net/core/lwt_bpf.c                                 |  15 +-
 net/core/net_namespace.c                           |   4 +
 net/core/skbuff.c                                  |  10 +-
 net/core/sock.c                                    |   8 +-
 net/core/xdp.c                                     |   4 +-
 net/dccp/dccp.h                                    |   4 +-
 net/dccp/ipv4.c                                    |   4 +-
 net/dccp/ipv6.c                                    |   7 +-
 net/dccp/minisocks.c                               |   2 +-
 net/hsr/hsr_device.c                               |  70 +-
 net/hsr/hsr_device.h                               |   4 +-
 net/hsr/hsr_forward.c                              |  85 ++-
 net/hsr/hsr_framereg.c                             |  52 ++
 net/hsr/hsr_framereg.h                             |   4 +
 net/hsr/hsr_main.h                                 |   7 +
 net/hsr/hsr_netlink.c                              |  30 +-
 net/hsr/hsr_slave.c                                |  23 +-
 net/ipv4/icmp.c                                    |  28 +-
 net/ipv4/igmp.c                                    |   2 +-
 net/ipv4/inet_connection_sock.c                    |   9 +
 net/ipv4/inetpeer.c                                |  38 +-
 net/ipv4/ip_fragment.c                             |   6 +-
 net/ipv4/ip_output.c                               |   4 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv4/ip_vti.c                                  |   4 +-
 net/ipv4/ipip.c                                    |   2 +-
 net/ipv4/ipmr.c                                    |   2 +-
 net/ipv4/netfilter.c                               |   4 +-
 net/ipv4/route.c                                   |  10 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp_fastopen.c                            |   6 +-
 net/ipv4/tcp_ipv4.c                                |  11 +-
 net/ipv4/tcp_metrics.c                             |   8 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv4/xfrm4_output.c                            |   2 +-
 net/ipv6/ip6_gre.c                                 |  14 +-
 net/ipv6/ip6_tunnel.c                              |  22 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/seg6_local.c                              |   9 +
 net/ipv6/sit.c                                     |   2 +-
 net/ipv6/tcp_ipv6.c                                |  97 ++-
 net/ipv6/xfrm6_input.c                             |   2 +-
 net/iucv/af_iucv.c                                 |   2 +
 net/kcm/kcmsock.c                                  |   3 +
 net/mac80211/link.c                                |   3 +-
 net/mac80211/s1g.c                                 |   2 +-
 net/mac80211/tx.c                                  |   3 +-
 net/mpls/af_mpls.c                                 |   2 +
 net/mptcp/subflow.c                                |   6 +-
 net/mptcp/syncookies.c                             |   1 +
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |  10 +-
 net/netfilter/nf_nat_sip.c                         |   5 +
 net/netfilter/nf_tables_api.c                      |  14 +-
 net/netfilter/nft_counter.c                        |  20 +-
 net/netfilter/xt_cgroup.c                          |  21 +-
 net/netfilter/xt_hl.c                              |  27 +
 net/nfc/digital_core.c                             |   2 +-
 net/nfc/llcp_core.c                                |  29 +-
 net/nfc/llcp_sock.c                                |  14 +-
 net/nfc/nci/data.c                                 |  10 +-
 net/nfc/nci/rsp.c                                  |  41 +-
 net/openvswitch/conntrack.c                        | 130 ++--
 net/openvswitch/conntrack.h                        |   6 +-
 net/openvswitch/datapath.c                         |  60 +-
 net/openvswitch/datapath.h                         |  26 +-
 net/openvswitch/vport.h                            |   9 +
 net/phonet/pep.c                                   |   2 +-
 net/rds/cong.c                                     |   4 +-
 net/sched/act_skbmod.c                             |  38 +-
 net/sched/cls_api.c                                |  18 +-
 net/sched/sch_api.c                                |   7 +-
 net/sched/sch_codel.c                              |   2 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_fq_pie.c                             |   3 +-
 net/sched/sch_generic.c                            |   2 +-
 net/sched/sch_hhf.c                                |   4 +
 net/sched/sch_htb.c                                |   7 +-
 net/sched/sch_sfq.c                                |   3 +-
 net/sched/sch_teql.c                               |   1 +
 net/sctp/inqueue.c                                 |   7 +-
 net/sctp/sm_sideeffect.c                           |   4 +
 net/sctp/stream.c                                  |  48 +-
 net/smc/af_smc.c                                   |  11 +-
 net/smc/smc_core.c                                 |  27 +-
 net/smc/smc_llc.c                                  |   3 +
 net/smc/smc_rx.c                                   |  11 +-
 net/smc/smc_tx.h                                   |   6 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   6 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  13 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   6 -
 net/sunrpc/auth_gss/gss_rpc_upcall.h               |   1 -
 net/sunrpc/auth_gss/svcauth_gss.c                  |   8 +-
 net/sunrpc/cache.c                                 |   7 +-
 net/sunrpc/rpcb_clnt.c                             |   4 +
 net/sunrpc/sunrpc_syms.c                           |   1 +
 net/sunrpc/svc.c                                   |  74 +-
 net/sunrpc/xdr.c                                   |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |   9 +-
 net/sunrpc/xprtsock.c                              |  32 +-
 net/tls/tls_strp.c                                 |  16 +-
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/vmw_vsock/virtio_transport.c                   |   2 +-
 net/xdp/xsk.c                                      |  46 +-
 net/xdp/xsk_buff_pool.c                            |   4 +-
 net/xdp/xsk_queue.h                                |  16 +-
 net/xfrm/xfrm_output.c                             |   4 +-
 samples/ftrace/ftrace-direct-modify.c              |  12 +-
 samples/ftrace/ftrace-direct-multi-modify.c        |  12 +-
 scripts/mod/modpost.c                              |   6 +-
 scripts/tags.sh                                    |   2 +-
 security/apparmor/lib.c                            |  20 +-
 security/integrity/ima/ima_appraise.c              |   2 +
 security/landlock/errata/abi-1.h                   |  23 +
 security/landlock/fs.c                             |  40 +-
 security/smack/smack.h                             |   5 +-
 security/smack/smack_lsm.c                         |  67 +-
 security/smack/smackfs.c                           | 222 ++----
 sound/core/control.c                               | 464 +++++-------
 sound/core/control_compat.c                        |  87 +--
 sound/core/control_led.c                           |   9 +-
 sound/core/init.c                                  |   4 +-
 sound/core/pcm_native.c                            |   2 +
 sound/core/seq/seq_midi.c                          |  61 +-
 sound/core/ump_convert.c                           |   1 +
 sound/drivers/aloop.c                              | 104 ++-
 sound/drivers/mpu401/mpu401.c                      |   6 +
 sound/drivers/mts64.c                              |   6 +
 sound/drivers/portman2x4.c                         |   6 +
 sound/drivers/serial-u16550.c                      |   6 +
 sound/drivers/virmidi.c                            |   6 +
 sound/parisc/harmony.c                             |   6 +-
 sound/pci/asihpi/hpi6000.c                         |   5 +
 sound/pci/hda/hda_proc.c                           |   2 +-
 sound/pci/ice1712/ice1712.c                        |   7 +-
 sound/pci/pcxhr/pcxhr.c                            |  14 +-
 sound/pci/via82xx_modem.c                          |  26 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/apple/mca.c                              |   6 +-
 sound/soc/codecs/cs35l33.c                         |  14 +-
 sound/soc/codecs/cs35l34.c                         |  14 +-
 sound/soc/codecs/rt700-sdw.c                       |   6 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   4 +-
 sound/soc/fsl/fsl_audmix.c                         |  24 +-
 sound/soc/fsl/mpc5200_psc_i2s.c                    |   1 +
 sound/soc/intel/atom/sst/sst_pci.c                 |   4 +-
 sound/soc/meson/meson-card-utils.c                 |  17 +-
 sound/soc/pxa/pxa-ssp.c                            |   7 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |  12 +-
 sound/soc/samsung/aries_wm8994.c                   |   1 +
 sound/soc/soc-dapm.c                               |   2 +-
 sound/soc/sof/topology.c                           |  18 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  14 +-
 sound/usb/6fire/comm.c                             |   9 +-
 sound/usb/bcd2000/bcd2000.c                        |  11 +-
 sound/usb/midi.c                                   |   2 +
 tools/bpf/bpftool/map.c                            |  16 +-
 tools/bpf/bpftool/struct_ops.c                     |   4 +
 tools/build/Makefile.feature                       |   3 +-
 tools/build/feature/Makefile                       |   3 +
 tools/include/linux/compiler.h                     |   2 +-
 tools/include/nolibc/arch-powerpc.h                |   2 +-
 tools/lib/bpf/libbpf.c                             |   3 +-
 tools/perf/builtin-sched.c                         |  40 +-
 tools/perf/builtin-stat.c                          |   9 +-
 tools/perf/pmu-events/jevents.py                   |   5 +-
 tools/perf/pmu-events/metric.py                    |   6 +-
 .../perf/tests/shell/lib/perf_metric_validation.py | 236 ++++---
 tools/perf/tests/shell/stat_all_metrics.sh         | 167 ++++-
 tools/perf/tests/shell/stat_bpf_counters.sh        |  97 ++-
 tools/perf/tests/shell/stat_metrics_values.sh      |  11 +-
 tools/perf/ui/browsers/hists.c                     |   6 +-
 tools/perf/util/auxtrace.c                         |  15 +-
 tools/perf/util/cs-etm-decoder/cs-etm-decoder.c    |  21 +-
 tools/perf/util/cs-etm.c                           | 595 ++++++++++------
 tools/perf/util/cs-etm.h                           |   8 +-
 tools/perf/util/data-convert-json.c                |   1 +
 tools/perf/util/dso.c                              |  19 +-
 .../util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.c   |  47 +-
 .../util/hisi-ptt-decoder/hisi-ptt-pkt-decoder.h   |  12 +
 tools/perf/util/intel-bts.c                        |   2 +-
 tools/perf/util/intel-pt.c                         |   2 +-
 tools/perf/util/machine.c                          |  37 +-
 tools/perf/util/metricgroup.c                      |   7 +-
 tools/perf/util/synthetic-events.c                 |   6 +-
 tools/perf/util/thread-stack.c                     |   2 +-
 tools/perf/util/trace-event-read.c                 |  33 +-
 tools/scripts/Makefile.include                     |  38 +-
 tools/testing/kunit/kunit.py                       |   2 +-
 tools/testing/kunit/kunit_tool_test.py             |  12 +
 .../selftests/arm64/mte/check_buffer_fill.c        |   2 +
 .../selftests/arm64/mte/check_child_memory.c       |   2 +
 .../selftests/arm64/mte/check_gcr_el1_cswitch.c    |   1 +
 .../selftests/arm64/mte/check_hugetlb_options.c    | 298 ++++++++
 .../selftests/arm64/mte/check_ksm_options.c        |  31 +-
 .../selftests/arm64/mte/check_mmap_options.c       |   2 +
 .../selftests/arm64/mte/check_tags_inclusion.c     |   2 +
 tools/testing/selftests/arm64/mte/check_user_mem.c |   2 +
 tools/testing/selftests/bpf/README.rst             |  32 +-
 .../selftests/bpf/prog_tests/global_map_resize.c   |   8 +-
 tools/testing/selftests/bpf/test_progs.c           |  11 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   3 +-
 tools/testing/selftests/bpf/veristat.c             |  76 +-
 tools/testing/selftests/bpf/vmtest.sh              |  71 +-
 tools/testing/selftests/mm/Makefile                |   4 +-
 tools/testing/selftests/mm/cow.c                   | 549 +++++++++------
 tools/testing/selftests/mm/khugepaged.c            | 417 ++---------
 tools/testing/selftests/mm/ksm_tests.c             | 210 +++---
 tools/testing/selftests/mm/migration.c             | 107 +++
 tools/testing/selftests/mm/run_vmtests.sh          |   2 +
 tools/testing/selftests/mm/soft-dirty.c            |   9 +-
 tools/testing/selftests/mm/thp_settings.c          | 394 +++++++++++
 tools/testing/selftests/mm/thp_settings.h          |  89 +++
 .../selftests/rseq/rseq-x86-thread-pointer.h       |   4 +-
 tools/testing/selftests/timers/leap-a-day.c        |  19 +-
 tools/testing/selftests/zram/zram_lib.sh           |   2 +-
 1191 files changed, 17852 insertions(+), 8450 deletions(-)


