Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E1935C69C;
	Sat, 12 Sep 2026 19:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240856; cv=none; b=C4pw4B9qYm4pnZbacXroXM0Yjvy5hDoMPJAnMLI0tHDKfz+9jucQwf/pqwMGwFCR3yozawdSOWX4rXb1oOt2AR7b2qbTkE5mUixRBJfKmTTEHwXYuXukgwWYJoUx/kT74fk2uYT1t/AOgSeBQtLFLk2ZZesGFjTeXnOjL2dVcsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240856; c=relaxed/simple;
	bh=xgkUJ3t/lIezRdebWrwe4aU59sHGlOLuUep7cRxMU2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LIelzvN4D6gYZda6B4paN1InOuCtifhfMSJdQcZeWo/V1uyg7ABGzIWguKXbAch4RhRULHVkLet9wZiJHi9VFU6HgCIs5qVEsE9SE6issjtfq8h43m0k3v7d4g+zRoIqV18STBaOZMvVpOPF/JJ4GsH0clm5IE6U5KFUqTM2Xz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvmG54uO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvmG54uO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308E51F000FF;
	Sat, 12 Sep 2026 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240850;
	bh=T0w0OBVXABfwaMroqQEh1nFpoendXnsShF/FFT/mseM=;
	h=From:To:Cc:Subject:Date;
	b=zvmG54uOIo7dcR8B4XCk/1pXtyKF+s/nsVfjEMe1JWJjdI0iCaCDxikG6HBis6w8i
	 NU5bTmFZPNK3AV6xWkFdIzkMAzgLXj55YZZMLI2trK2z9zDhaArDdr+gpzmFbS1JZ2
	 Vp6r3CU3Pv3DNYatzBsAtyRnCdn3XTI2Kgnpj0lQ=
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
Subject: [PATCH 5.10 000/798] 5.10.270-rc1 review
Date: Sat, 12 Sep 2026 08:53:48 +0200
Message-ID: <20260912065516.948645775@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.270-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.270-rc1
X-KernelTest-Deadline: 2026-09-14T06:55+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.270 release.
There are 798 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.270-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.270-rc1

Zhang Chen <zhangchen01@kylinos.cn>
    Bluetooth: L2CAP: Fix send LE flow credits in ACL link

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Handle %.*s in trace_check_vprintf()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have trace event string test handle zero length strings

Michael Wu <michael@allwinnertech.com>
    tracing: Fix race between update_event_fields and, event_define_fields

Dan Carpenter <dan.carpenter@linaro.org>
    HID: fix an error code in hid_check_device_match()

Rafael Mendonca <rafaelmendsr@gmail.com>
    scsi: qla2xxx: Fix memory leak in __qlt_24xx_handle_abts()

Andy Shevchenko <andy.shevchenko@gmail.com>
    ACPI: utils: Document for_each_acpi_dev_match() macro

Thomas Gleixner <tglx@linutronix.de>
    mm/highmem: Take kmap_high_get() properly into account

Bjorn Andersson <bjorn.andersson@linaro.org>
    clk: qcom: gdsc: Bump parent usage count when GDSC is found enabled

Hui Tang <tanghui20@huawei.com>
    crypto: testmgr - fix initialization of 'secret_size'

Hui Tang <tanghui20@huawei.com>
    crypto: ecdh - extend 'cra_driver_name' with curve name

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    driver core: platform: don't oops in platform_shutdown() on unbound devices

Jiayuan Chen <jiayuan.chen@linux.dev>
    tcp: fix corruption of urgent data on multi-segment retransmit

Deepanshu Kartikey <kartikey406@gmail.com>
    usb: atm: usbatm: fix invalid ci_range initialization

bui duc phuc <phucduc.bui@gmail.com>
    net: fec: only stop PTP if it was initialized

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

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()

Marino Dzalto <marino.dzalto@gmail.com>
    netfilter: xt_HL: add pr_fmt and checkentry validation

Michal Koutný <mkoutny@suse.com>
    netfilter: xt_cgroup: Make it independent from net_cls

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: move hardware offload step after building the chain blob

bui duc phuc <phucduc.bui@gmail.com>
    net: ethernet: sun4i-emac: Fix IRQ error handling

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
    net_sched: export pfifo_fast prio2band[]

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: change how @inactive is tracked

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: struct sched_data reorg

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    net: ip6_gre: Remove the unused function ip6gre_tnl_addr_conflict()

Frank Sorenson <sorenson@redhat.com>
    cifs: fix clearing stats for fastest execution of each smb2 command

Allison Henderson <achender@kernel.org>
    net/rds: use wq_has_sleeper() in rds_cong_map_updated()

Xiang Mei <xmei5@asu.edu>
    net: qualcomm: rmnet: restore skb->dev on deaggregated frames

Cen Zhang (Microsoft) <blbllhy@gmail.com>
    gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free

Hyunwoo Kim <imv4bel@gmail.com>
    Bluetooth: RFCOMM: Validate MTU in rfcomm_apply_pn() to prevent infinite loop

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio: Take exclusive ownership of the SKB before TX

Pauli Virtanen <pav@iki.fi>
    Bluetooth: 6lowpan: fix cyclic locking warning on netdev unregister

Edward Adam Davis <eadavis@qq.com>
    bluetooth/l2cap: sync sock recv cb and release

Sebastian Urban <surban@surban.net>
    Bluetooth: compute LE flow credits based on recvbuf space

Dan Carpenter <error27@gmail.com>
    scsi: qla2xxx: Fix an loop timeout test

Junrui Luo <moonafterrain@outlook.com>
    NFSv4/pnfs: key the data server cache on the NFS version

Jeff Layton <jlayton@kernel.org>
    nfs: move the nfs4_data_server_cache into struct nfs_net

Junrui Luo <moonafterrain@outlook.com>
    NFSv4.2: fix LAYOUTSTATS send buffer exhaustion

Mahanta Jambigi <mjambigi@linux.ibm.com>
    net/smc: free pending qentry in smc_llc_flow_stop() before memset

Marek Czernohous <marek@czernohous.de>
    forcedeth: stop the tx_timeout register dump past the requested window

Fan Ye <fy15309206903@gmail.com>
    net: thunderbolt: Count delivered packets in rx_packets and rx_bytes

Ruoyu Wang <ruoyuw560@gmail.com>
    net: bridge: Reject descending VLAN tunnel ranges

Serhat Kumral <serhatkumral1@gmail.com>
    RDMA/ucma: Allow path records to exactly fit the output buffer

Bradley Morgan <include@grrlz.net>
    prctl: fix PR_SET_MM_AUXV losing the forced AT_NULL terminator

Yi Ding <yi.s.ding@gmail.com>
    rtc: pcf8563: fix clock provider leak on unbind

Li RongQing <lirongqing@baidu.com>
    vdpa/mlx5: fix wrong list iterated in add_direct_chain error path

Michael S. Tsirkin <mst@redhat.com>
    virtio_balloon: disable indirect descriptors

Ruoyu Wang <ruoyuw560@gmail.com>
    bonding: initialize err for empty target lists

Nguyen Dinh Phi <phind.uet@gmail.com>
    vsock: use sock_error() to consume sk_err after a failed connect

Karl Mehltretter <kmehltretter@gmail.com>
    8139cp: fix Rx and Tx not being disabled in cp_suspend

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Fix connection list comparison in proc output

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix inverted default vlan notification

Joas Antonio dos Santos <joasantonio108@gmail.com>
    ipvs: fix integer overflow in ftp helper port/address parsing

Lukasz Majewski <lukma@denx.de>
    net: hsr: Use full string description when opening HSR network device

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Use a single struct for self_node.

Qingfang Deng <qingfang.deng@linux.dev>
    pppox: drain queued packets on channel handoff

Junseo Lim <zirajs7@gmail.com>
    net: kcm: Hold RCU read lock while running BPF parser

Ruoyu Wang <ruoyuw560@gmail.com>
    NFSv4: remove callback IDR entry on client allocation failure

Arnaud Bonnet <abo@medichon.fr>
    nfs: refactor pNFS functions using clear_and_wake_up_bit

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pnfs: Clean up layout get on open

Arnaud Bonnet <abo@medichon.fr>
    nfs: replace atomic bitops sequence with clear_and_wake_up_bit helper

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Always clear an invalid mapping when attempting a buffered write

Junseo Lim <zirajs7@gmail.com>
    bpf: Reject negative optlen in cgroup getsockopt hook

Junseo Lim <zirajs7@gmail.com>
    lwt_bpf: Restore reserved headroom after xmit program

Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
    hwmon: (emc1403) Add support for EMC1442

Linmao Li <lilinmao@kylinos.cn>
    mailbox: rockchip: disable pclk on probe failure and unbind

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard against cache underflow on short reads in dso_cache__memcpy()

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf dso: Guard close() against invalid fd in dso__decompress_kmodule_path()

Israel Téllez García <i.tellez@btesa.com>
    bpf: Fix pending_pos walk on 32-bit ring position wrap

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have TRACE_DEFINE_ENUM affect trace event types as well

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add DYNAMIC flag for dynamic events

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Add a verifier to check string pointers for trace events

Steven Rostedt (VMware) <rostedt@goodmis.org>
    seq_buf: Add seq_buf_terminate() API

Chandrakanth Patil <chandrakanth.patil@broadcom.com>
    scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check block offset is not negative

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    ocfs2: fix circular locking dependency in ocfs2_init_acl()

Yuan Chen <chenyuan@kylinos.cn>
    bpftool: Fix double close in map dump

Bijan Tabatabai <btabatabai@wisc.edu>
    x86/pkeys: Fix pkey_alloc() return value when pkeys are not supported

Yuho Choi <dbgh9129@gmail.com>
    clocksource/drivers/armada: Unwind timer clock on init failure

Guangshuo Li <lgs201920130244@gmail.com>
    clocksource/drivers/clps711x: Do not unmap clocksource MMIO

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

Yang Li <yang.lee@linux.alibaba.com>
    ubi: Simplify bool conversion

ZhaoLong Wang <wangzhaolong1@huawei.com>
    ubi: fastmap: Add fastmap control support for module parameter

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Add fastmap control support for 'UBI_IOCATT' ioctl

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

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ubi: fastmap: Use the bitmap API to allocate bitmaps

Jilin Yuan <yuanjilin@cdjrlc.com>
    ubi: Fix repeated words in comments

LiangCheng Wang <zaq14760@gmail.com>
    ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: pxa: Use devm_clk_get_optional() for extclk clock

Zhu Yanjun <yanjun.zhu@linux.dev>
    RDMA/cma: Fix WARNING in res_to_rt

Fan Wu <fanwu01@zju.edu.cn>
    RDMA/cxgb4: Free debugfs on registration failure

Guangshuo Li <lgs201920130244@gmail.com>
    dmaengine: qcom-bam-dma: fix autosuspend cleanup during removal

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

Babanpreet Singh <bbnpreetsingh@gmail.com>
    spi: sprd-adi: Fix probe succeeding without registering the controller

Michael Walle <mwalle@kernel.org>
    powerpc/configs: enable CONFIG_RAS to fix EDAC support

Weiming Shi <bestswngs@gmail.com>
    SUNRPC: check rpc_sockaddr2uaddr() return value in rpcb_register_inet4/6

Karl Mehltretter <kmehltretter@gmail.com>
    m68k: Fix backtraces for non-running tasks

Desnes Nunes <desnesn@redhat.com>
    iommu/vt-d: Fix UCTP context table slot when copying root entries

Danila Chernetsov <listdansp@mail.ru>
    fbdev: kyro: Validate overlay viewport coordinates

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix divide by zero in perf_event__synthesize_threads

Ian Rogers <irogers@google.com>
    perf synthetic-events: Fix uninitialized pthread_join

Ian Rogers <irogers@google.com>
    perf stat: Fix evsel_list leak in cmd_stat

Namhyung Kim <namhyung@kernel.org>
    perf stat: Clear screen only if output file is a tty

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add SATA regulator supplies

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add vcc-supply to GPIO expander

Rosen Penev <rosenp@gmail.com>
    ARM: dts: helios4: add vcc-supply to EEPROM

Tomáš Macholda <tomas.macholda@nic.cz>
    arm64: dts: turris-mox: fix usb3 phys

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: gp2ap002: re-enable irq if runtime suspend fails

Nikhil Gautam <nikhilgtr@gmail.com>
    iio: light: gp2ap002: Fix unbalanced runtime PM on repeated event writes

Ali Ahmet Memis <ali@iusegentoo.com>
    Bluetooth: MSFT: validate evt_prefix_len against the response length

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix integer truncation in do_read() and skip()

Zijun Hu <zijun.hu@oss.qualcomm.com>
    Bluetooth: btusb: Fix BD_ADDR byte order in btusb_set_bdaddr_wcn6855()

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    sched/fair: Check CPU capacity before comparing group types during load balance

Valentin Schneider <valentin.schneider@arm.com>
    sched/fair: Introduce a CPU capacity comparison helper

Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
    regulator: qcom-rpmh: Fix PMIC5 BOB bypass mode handling

Loic Poulain <loic.poulain@oss.qualcomm.com>
    phy: qcom: snps-femto-v2: Fix possible NULL-deref on early runtime suspend

Yichong Chen <chenyichong@uniontech.com>
    hugetlbfs: release subpool on fill_super failure

Simon Glass <sjg@chromium.org>
    pinctrl: rockchip: Reset the pin count when recalculating SoC data

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    firmware_loader: do not queue completed sysfs fallback requests

Russ Weight <russell.h.weight@intel.com>
    firmware_loader: Check fw_state_is_done in loading_store

Manish Rangankar <mrangankar@marvell.com>
    scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Use PFP on the compute queues too

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu/gfx6: Fixup emitting SWITCH_BUFFER packets

Tanushree Shah <tshah@linux.ibm.com>
    perf trace-event: Fix buffer overflow in read_string()

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

Geert Uytterhoeven <geert+renesas@glider.be>
    bitfield: Add non-constant field_{prep,get}() helpers

Geert Uytterhoeven <geert+renesas@glider.be>
    bitfield: Add less-checking __FIELD_{GET,PREP}()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    of: property: use unsigned int return on of_graph_get_endpoint_count()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    of: property: add missing kerneldoc for of_graph_get_endpoint_count()

Jernej Skrabec <jernej.skrabec@gmail.com>
    drm/sun4i: vi scaler: Fix coefficient selection

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: synchronize heartbeat callbacks with o2net teardown

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: use bitmap API in fill_node_map

Xie Yuanbin <xieyuanbin1@huawei.com>
    ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ

Sergei Litvin <litvindev@gmail.com>
    scripts/tags.sh: Prevent binary files appearing in cscope.files

Jialu Xu <xujialu@vimux.org>
    scripts/tags.sh: improve compiled sources generation

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: fix OOB read via signed offset in rsc_table_for_each_entry()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: use rsc_table_for_each_entry() in rproc_handle_resources()

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    remoteproc: Move resource table data structure to its own header

Suman Anna <s-anna@ti.com>
    remoteproc: Fix various kernel-doc warnings

Mathieu Poirier <mathieu.poirier@linaro.org>
    remoteproc: Introduce function rproc_detach()

Mathieu Poirier <mathieu.poirier@linaro.org>
    remoteproc: Introduce function __rproc_detach()

Mathieu Poirier <mathieu.poirier@linaro.org>
    remoteproc: Add new detach() remoteproc operation

Suman Anna <s-anna@ti.com>
    remoteproc: Add a rproc_set_firmware() API

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Add static PCI resource attribute macros

Yichong Chen <chenyichong@uniontech.com>
    fat: release buffer head after rebuilding parent

Guangshuo Li <lgs201920130244@gmail.com>
    rapidio: clear mport->net when rio_add_net() fails

Calvin Owens <calvin@wbinvd.org>
    pps: don't try to wait for negative timeouts in PPS_FETCH

Bradley Morgan <include@grrlz.net>
    lib/string: fix memchr_inv() for large ranges

Tao Cui <cuitao@kylinos.cn>
    block/kyber-iosched: flush per-cpu latency buckets over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-iocost: collect per-cpu latency stats over possible CPUs

Tao Cui <cuitao@kylinos.cn>
    block/blk-stat: drain per-cpu callback stats over possible CPUs

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

Ai Chao <aichao@kylinos.cn>
    HID: i2c-hid: Fix "(null)" output when reading report descriptor fails

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: Switch i2c_hid_parse() to goto style error handling

Yousef Alhouseen <alhouseenyousef@gmail.com>
    HID: synchronize input before cleaning up a failed probe

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: ensure timely release of driver-allocated resources

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    HID: split apart hid_device_probe to make logic more apparent

Karl Mehltretter <kmehltretter@gmail.com>
    tty: clear cdev pointer after cdev_add() failure

Karl Mehltretter <kmehltretter@gmail.com>
    serial: amba-pl011: unprepare console clock on unregister

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    MIPS: ptrace: Fix syscall skipping via PTRACE_SYSCALL

Gou Hao <gouhao@uniontech.com>
    powerpc/smp: add NULL guard for cause_ipi in smp_muxed_ipi_message_pass

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    firmware: coreboot: Validate table bounds

Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
    firmware: google: Add bounds checks in coreboot_table_populate()

Kees Cook <keescook@chromium.org>
    firmware: coreboot: Check size of table entry and use flex-array

Philipp Borgers <borgers@mi.fu-berlin.de>
    mac80211: add ieee80211_is_tx_data helper function

Slawomir Stepien <sst@poczta.fm>
    wifi: zd1211rw: reject secondary interfaces to prevent conflicts

Pranjal Shrivastava <praan@google.com>
    iommu/arm-smmu-v3: Convert to use atomic poll timeout

Linghui Wu <linghui.wu@oss.qualcomm.com>
    wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump

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

Joy Zou <joy.zou@oss.nxp.com>
    regulator: core: use system_freezable_wq for init complete work

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: fix leak in ath11k_service_ready_ext_event()

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    drm/msm/dsi: Drop dev_pm_opp_set_rate(0)

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Make wakeup range check overflow safe

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss

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
    iommu/dma: Check atomic pool allocation result directly

Vladimir Zapolskiy <vz@kernel.org>
    clk: qcom: Return expected ENOMEM error on dynamic allocation failure

Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
    lib/test_hmm: fail dmirror_fault() when the mirrored mm is gone

Pu Lehui <pulehui@huawei.com>
    bpf: Fix potential UAF in bpf_netns_link_update_prog

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: sc2731_charger: cancel work on remove

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    power: supply: sc2731_charger: Convert to platform remove callback returning void

Hongyan Xu <getshell@seu.edu.cn>
    power: supply: isp1704_charger: cancel work on remove

Cheng-Han Wu <hank20010209@gmail.com>
    selftests/zram: fix kernel_gte() for POSIX sh

Sajal Gupta <sajal2005gupta@gmail.com>
    md/raid5-ppl: fix use-after-free in ppl_do_flush()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtlwifi: pci: fix error path in rtl_pci_probe()

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

David Lee <david.lee@trailofbits.com>
    nilfs2: prevent out-of-bounds read in super root block parsing

Joshua Crofts <joshua.crofts1@gmail.com>
    nilfs2: fix infinite loop in nilfs_clean_segments()

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

Ivy Lopez <skunkolee@gmail.com>
    staging: rtl8723bs: use kfree_sensitive() for key material

Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
    remoteproc: Prevent crash handling to race with rproc_del()

Jingyi Wang <jingyi.wang@oss.qualcomm.com>
    remoteproc: core: Attach rproc asynchronously in rproc_add() path via schedule_work()

Mukesh Ojha <quic_mojha@quicinc.com>
    remoteproc: Use unbounded workqueue for recovery work

Alex Elder <elder@linaro.org>
    remoteproc: use freezable workqueue for crash notifications

Mathieu Poirier <mathieu.poirier@linaro.org>
    remoteproc: Add new RPROC_ATTACHED state

Mathieu Poirier <mathieu.poirier@linaro.org>
    remoteproc: Remove useless check in rproc_del()

Babanpreet Singh <bbnpreetsingh@gmail.com>
    w1: ds2482: Fix signedness bug in ds2482_w1_triplet()

Yichong Chen <chenyichong@uniontech.com>
    isofs: release zisofs block pointer buffer head

Maher Sanalla <msanalla@nvidia.com>
    RDMA/mlx5: Fix integer overflow of user QP buffer size

Babanpreet Singh <bbnpreetsingh@gmail.com>
    power: supply: sbs-battery: Use a per-device serial number buffer

Ikjoon Jang <ikjn@chromium.org>
    power: supply: sbs-battery: cache constant string properties

Karl Mehltretter <kmehltretter@gmail.com>
    ARM: lpc32xx: only run SoC init on LPC32xx hardware

Fabio Estevam <festevam@gmail.com>
    arm64: dts: rockchip: Fix Gru WLAN sideband interrupt

Rob Herring <robh@kernel.org>
    arm64: dts: rockchip: Fix PCI node addresses on rk3399-gru

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: rockchip: Add gru-scarlet-dumo board

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet

Can Peng <pengcan@kylinos.cn>
    drm/tve200: add OF module alias for autoloading

Cosmo Chou <chou.cosmo@gmail.com>
    leds: pca9532: Fix phantom device registration on missing hardware

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Avoid truncating AUX buffer sizes to int

Leo Yan <leo.yan@arm.com>
    perf cs-etm: Flush thread stacks after decoder reset

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: allwinner: a10: Fix PMU interrupt

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()

Venkateswara Naralasetty <quic_vnaralas@quicinc.com>
    ath11k: add trace log support

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath11k: Correctly copy the hint BSSID in WMI scan request

Jeff Johnson <jeff.johnson@oss.qualcomm.com>
    wifi: ath6kl: avoid buffer overreads in WMI event handlers

Baokun Li <libaokun@linux.alibaba.com>
    ext4: drain in-flight DIO before buffered write fallback

Pengpeng Hou <pengpeng@iscas.ac.cn>
    thermal: intel: int3400: clean up ODVP on probe failures

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: int340x_thermal: Consolidate priv->data_vault checks

Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
    iommu/qcom: Fix inverted fault report check in qcom_iommu_fault()

Haoxiang Li <haoxiang_li2024@163.com>
    iommu/qcom: Remove sysfs device on probe failure path

Miaoqian Lin <linmq006@gmail.com>
    iommu/arm-smmu: Add missing pm_runtime_disable() in qcom_iommu_device_probe

Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
    RDMA/restrack: Fix typos in the comments

Leon Romanovsky <leon@kernel.org>
    RDMA/srpt: Pass the mapped task attribute to target_init_cmd()

Mike Christie <michael.christie@oracle.com>
    scsi: target: srpt: Convert to new submission API

Mike Christie <michael.christie@oracle.com>
    scsi: target: core: Break up target_submit_cmd_map_sgls()

Mike Christie <michael.christie@oracle.com>
    scsi: target: core: Rename transport_init_se_cmd()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    scsi: target: core: Replace in_interrupt() usage in target_submit_cmd_map_sgls()

Mike Christie <michael.christie@oracle.com>
    scsi: qla2xxx: Move sess cmd list/lock to driver

Mike Christie <michael.christie@oracle.com>
    scsi: target: Remove TARGET_SCF_LOOKUP_LUN_FROM_TAG

Mike Christie <michael.christie@oracle.com>
    scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG

Yun Zhou <yun.zhou@windriver.com>
    ext4: skip extra isize expansion during mount to prevent deadlock

Chen Pei <cp0613@linux.alibaba.com>
    ACPI: PCI: Clear driver_data on all paths that free the acpi_pci_root

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ACPI: processor: validate MADT IOAPIC entry bounds

Kemeng Shi <shikemeng@huaweicloud.com>
    irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()

TanZheng <tanzheng@kylinos.cn>
    RDMA/srpt: Fix srpt_alloc_rw_ctxs() unwind counters

Danila Chernetsov <listdansp@mail.ru>
    RDMA/hfi1: Propagate sdma_txinit_ahg() errors

Linmao Li <lilinmao@kylinos.cn>
    ASoC: meson: Keep link pointers valid on realloc failure

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Clear stale requests on termination

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Serialize channel state checks

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Serialize abort state updates

Yuho Choi <dbgh9129@gmail.com>
    driver core: soc: Unregister bus on early device registration failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    driver core: soc: remove layering violation for the soc_bus

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

Linmao Li <lilinmao@kylinos.cn>
    ppdev: prevent overflow when setting port timeout

Pengpeng Hou <pengpeng@iscas.ac.cn>
    misc: ad525x_dpot: use driver core groups for sysfs files

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    misc: ad525x_dpot: Make ad_dpot_remove() return void

Gleb Markov <markov.gi@npc-ksb.ru>
    misc: rtsx: add missing write register handling

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

Wolfram Sang <wsa+renesas@sang-engineering.com>
    ACPI: move from strlcpy() with unused retval to strscpy()

Daniel Scally <djrscally@gmail.com>
    media: ACPI / bus: Add acpi_dev_get_next_match_dev() and helper macro

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Avoid stack over-read in debug output helpers

Mikko Perttunen <mperttunen@nvidia.com>
    gpu: host1x: Fix offset calculation in trace_write_gather

Maoyi Xie <maoyixie.tju@gmail.com>
    drm/bridge: tc358767: clamp the reported AUX read size to the request

Uday Khare <udaykhare77@gmail.com>
    remoteproc: qcom: Fix glink->node reference leak in qcom_add_glink_subdev

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    cpufreq: schedutil: Fix self-contradictory comment in sugov_iowait_apply()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: schedutil: Add util to struct sg_cpu

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: intel_pstate: Simplify intel_cpufreq_update_pstate()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Handle additional domain flags in irq_domain_instantiate()

Herve Codina <herve.codina@bootlin.com>
    irqdomain: Introduce irq_domain_instantiate()

Dan Carpenter <error27@gmail.com>
    cpufreq: spear: Fix an IS_ERR() vs NULL bug in spear1340_set_cpu_rate()

Bryam Vargas <hexlabsecurity@proton.me>
    libnvdimm/labels: Bound the on-media label size before the shift

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath11k: cap out-of-range rx MCS instead of leaving bogus rate

Kyle Zeng <kylebot@openai.com>
    hfsplus: validate thread record before delete key rebuild

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    rpmsg: glink: fix deadlock in endpoint destroy during driver detach

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    rpmsg: glink: remove duplicate code for rpmsg device remove

Arun Kumar Neelakantam <aneela@codeaurora.org>
    rpmsg: glink: Remove the rpmsg dev in close_ack

Ira Weiny <ira.weiny@intel.com>
    iov_iter: lift memzero_page() to highmem.h

Thomas Gleixner <tglx@linutronix.de>
    highmem: Provide generic variant of kmap_atomic*

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Initialize debugfs after probe completes

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Stop flushing the global IB workqueue

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Create workqueues before device initialization

Leon Romanovsky <leon@kernel.org>
    RDMA/hfi1: Remove redundant PCI device ID validation

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

Leon Romanovsky <leon@kernel.org>
    RDMA/ipoib: Drain RCU callbacks during module teardown

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Wait for RCU callbacks before unloading ib_core

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    RDMA/core: Avoid flush_workqueue(system_unbound_wq) usage

Mert Seftali <mertsftl@gmail.com>
    iio: accel: dmard09: Implement IIO_CHAN_INFO_SCALE

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    drm/panel: samsung-s6d16d0: Power off on prepare failure

Biju Das <biju.das.jz@bp.renesas.com>
    usb: renesas_usbhs: Fix power-off ordering on unbind

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    platform: Provide a remove callback that returns no value

Uwe Kleine-König <uwe@kleine-koenig.org>
    driver core: platform: Emit a warning if a remove callback returned non-zero

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    driver core: platform: use bus_type functions

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    driver core: platform: change logic implementing platform_driver_probe

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    driver core: platform: reorder functions

Michael Bommarito <michael.bommarito@gmail.com>
    usb: gadget: configfs: fix out-of-bounds read of qw_sign

Wolfram Sang <wsa+renesas@sang-engineering.com>
    hwspinlock: propagate errno when registering single lock

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

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix vmlinux BTF prep race in bpf_get_btf_vmlinux

Aleksandr Nogikh <nogikh@google.com>
    udf: Mark LVID buffer as uptodate before marking it dirty

Hongyan Xu <getshell@seu.edu.cn>
    usb: gadget: r8a66597: avoid double free of ep0_req in probe error path

Herman van Hazendonk <github.com@herrie.org>
    clk: qcom: gdsc: tear down per-domain genpds in gdsc_unregister()

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gdsc: Capture pm_genpd_add_subdomain result code

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: gdsc: Release pm subdomains in reverse add order

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: gdsc: enable optional power domain support

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

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    of: Add cleanup.h based auto release via __free(device_node) markings

Haowen Tu <tuhaowen@uniontech.com>
    PM: sleep: Fix off-by-one in wakelocks number limit check

Yuho Choi <dbgh9129@gmail.com>
    bus: ti-sysc: Fix /chosen node reference leak

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    nvmet-rdma: factor out response resource cleanup

Pengpeng Hou <pengpeng@iscas.ac.cn>
    crypto: sa2ul - stop probe if context pool creation fails

Tang Bin <tangbin@cmss.chinamobile.com>
    crypto: sa2ul - Use the defined variable to clean code

Lothar Rubusch <l.rubusch@gmail.com>
    crypto: atmel-sha204a - fix heap info leak on I2C transfer failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - reject hardware ECDH without a public key

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - clean up and improve ECDH comments

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - replace min_t with min

Lee Jones <lee.jones@linaro.org>
    crypto: atmel-ecc - Struct headers need to start with keyword 'struct'

Meng Yu <yumeng18@huawei.com>
    crypto: ecdh - move curve_id of ECDH from the key to algorithm name

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

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: add static port map support

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: qcom: update port map allocation bit mask

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: add static port mapping support

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe

Suraj Gupta <suraj.gupta2@amd.com>
    dmaengine: xilinx_dma: Fix channel idle state management in AXIDMA and MCDMA interrupt handlers

Vladimir Zapolskiy <vz@kernel.org>
    dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in Vega10 lookup

Asad Kamal <asad.kamal@amd.com>
    drm/amdgpu/pm/powerplay: bounds-check voltage index in SMU7 lookup

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_HAUPPAUGE_NEW keymap define

Sean Young <sean@mess.org>
    media: keymaps: Remove obsolete RC_MAP_RC5_TV keymap define

Daniel McCarthy <daniel@dragonzap.com>
    pinctrl: bcm2835: Don't remove an unregistered GPIO chip

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails

Henrik Grimler <henrik.grimler@axis.com>
    drm/lima: call drm_mm_init() with a valid allocation range

Brian Masney <bmasney@redhat.com>
    clk: imx: scu: drop redundant init.ops variable assignment

Anson Huang <Anson.Huang@nxp.com>
    clk: imx: scu: Add A72 frequency scaling support

Anson Huang <Anson.Huang@nxp.com>
    clk: imx: scu: Add A53 frequency scaling support

Weigang He <geoffreyhe2@gmail.com>
    ARM: imx: fix device_node refcount leak in imx_src_init()

Min zhang <zhangmin2026@yeah.net>
    clk: hisilicon: reset: Use devm_kzalloc to initialize hisi_reset_controller

Alexander A. Klimov <grandmaster@al2klimov.de>
    clk: moxart: remove unused variables, fix refcount leak

Gui-Dong Han <hanguidong02@gmail.com>
    media: cec-pin: Fix event FIFO ordering

Weigang He <geoffreyhe2@gmail.com>
    soc: samsung: exynos-pmu: fix of_node refcount leak in exynos_get_pmu_regmap()

Michael Bommarito <michael.bommarito@gmail.com>
    HID: roccat: bound device-supplied profile index

Philipp Weber <kernel@phwe.de>
    HID: core: quiesce input in hid_hw_stop() to prevent use-after-free

Konstantin Andreev <andreev@swemel.ru>
    smack: restrict smackfs/{direct,mapped} values to 0-255

Konstantin Andreev <andreev@swemel.ru>
    smack: deduplicate smackfs/{direct,mapped} file_operations

Dmitry Antipov <dmantipov@yandex.ru>
    smack: simplify write handlers of sysfs entries

Austin Kim <austin.kim@lge.com>
    smack: mark 'smack_enabled' global variable as __initdata

Konstantin Andreev <andreev@swemel.ru>
    smack: fix incorrect task context in smack_msg_queue_msgrcv

Casey Schaufler <casey@schaufler-ca.com>
    Smack: fix W=1 build warnings

Maxime Ripard <mripard@kernel.org>
    drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Enforce expected_attach_type for tailcall compatibility

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: align gxbb_32k_clk_sel number of parents with actual count

Mahesh Rao <mahesh.rao@altera.com>
    firmware: stratix10-svc: Add mutex in stratix10 memory management

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf sched: Fix register_pid() overflow, strcpy, and BUG_ON

Sven Eckelmann <sven@narfation.org>
    batman-adv: bla: avoid CRC corruption due to parallel claim add

Jian Shen <shenjian15@huawei.com>
    net: hns3: don't auto enable misc vector

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Input: aiptek - validate raw macro indices before updating state

Jiayuan Chen <jiayuan.chen@linux.dev>
    bpf: Fix same-register dst/src OOB read and pointer leak in sock_ops

Zhengchuan Liang <zcliangcn@gmail.com>
    net: af_key: zero aligned sockaddr tail in PF_KEY exports

Xiang Mei <xmei5@asu.edu>
    bridge: mrp: reject zero test interval to avoid OOM panic

Wang Liang <wangliang74@huawei.com>
    net: fix NULL pointer dereference in l3mdev_l3_rcv

Andrei Matei <andreimatei1@gmail.com>
    bpf: Guard stack limits against 32bit overflow

Sechang Lim <rhkrqnwk98@gmail.com>
    tcp: clear sock_ops cb flags before force-closing a child socket

Arthur Gautier <baloo@superbaloo.net>
    xhci: fix lost bounce buffers on TDs spanning several ring segments

Sunil Khatri <sunil.khatri@amd.com>
    drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_crtc_commit leak if signaled when PAGE_FLIP_EVENT is used

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: avoid divide-by-zero in __is_lut_linear()

Thomas Zimmermann <tzimmermann@suse.de>
    drm/hibmc: Fix list of formats on the primary plane

Wentao Liang <vulab@iscas.ac.cn>
    drm/sun4i: fix refcount leak in sun4i_backend_init_sat()

Danilo Krummrich <dakr@kernel.org>
    drm: fix race between partial drm_dev_register() failure and ioctl

Johan Hovold <johan@kernel.org>
    drm/bridge: dw-hdmi: fix i2c adapter leak on probe failure

Zhan Xusheng <zhanxusheng1024@gmail.com>
    f2fs: fix i_size when pinned fallocate partially fails

Hao-Qun Huang <alvinhuang0603@gmail.com>
    f2fs: reject overlapping move range after len expansion

Wenjie Qi <qwjhust@gmail.com>
    f2fs: return symlink writeback errors

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Drop vport reference under lock in report ID acquisition

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Avoid double completion in async IOCB timeout

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
    scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Bound i2c->length in I2C bsg handlers

Nilesh Javali <njavali@marvell.com>
    scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers

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

Ilya Krutskih <devsec@tpz.ru>
    media: tda18250: fix possible integer overflow

Lei Huang <huanglei@kylinos.cn>
    media: s2255: check firmware size before reading trailing marker

HyeongJun An <sammiee5311@gmail.com>
    media: s2255: bound JPEG frame size before copying into the buffer

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: release URBs and stream buffers on start_streaming() failure

Valery Borovsky <vebohr@gmail.com>
    media: rtl2832_sdr: use vb2_video_unregister_device() on remove to fix DMA leak

Christian Hewitt <christianshewitt@gmail.com>
    media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common

Biren Pandya <birenpandya@gmail.com>
    media: i2c: ov7740: fix use-after-destroy in remove

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

Valery Borovsky <vebohr@gmail.com>
    media: airspy: use vb2_video_unregister_device() on disconnect to fix NULL deref

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Restore sigset on error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Zero initialize irq in reinject_machine_check

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Free guest debug data on vcpu destroy

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix old_data leak in guest debug error path

Christian Borntraeger <borntraeger@linux.ibm.com>
    KVM: s390: Fix memory leak in guest debug handling

Carlos López <clopez@suse.de>
    KVM: x86: hyper-v: Clamp stimer deadline to avoid livelock

Sanjay Chitroda <sanjayembeddedse@gmail.com>
    iio: temperature: hid-sensor-temperature: switch to non-devm iio_device_register()

Cong Nguyen <congnt264@gmail.com>
    iio: srf04: fix pm_runtime handling on probe error path

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

Helge Deller <deller@gmx.de>
    parisc: Fix alignment of asm statements in head.S

Pei Xiao <xiaopei01@kylinos.cn>
    parisc: eisa: Fix infinite loop when parsing invalid IRQ value

Bryam Vargas <hexlabsecurity@proton.me>
    nvdimm/btt: reject an arena whose nfree is below the lane count

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

Ahmad Byagowi <ahmadexp@gmail.com>
    i2c: mux: Fix channel node leak on adapter add failure

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix kernel address leakages in LBR stack

Hajo Noerenberg <hajo-linux-ide@noerenberg.de>
    ata: ahci: work around lost interrupts on Marvell 88SE61xx

Koichiro Den <den@valinux.co.jp>
    dmaengine: dw-edma: Complete descriptors before pausing

Mikulas Patocka <mpatocka@redhat.com>
    dm: fix resume-vs-remove race

Ibrahim Hashimov <security@auditcode.ai>
    HID: wacom: validate report length in wacom_intuos_pro2_bt_irq

Wei Jie Law <98lawweijie@gmail.com>
    HID: rmi: fix OOB access with undersized RMI reports

Runyu Xiao <runyu.xiao@seu.edu.cn>
    scsi: pm8001: Use rollback index when freeing MSI-X vectors

Sujal Tuladhar <sujaltuladhar1231@gmail.com>
    scsi: target: iscsi: Reserve a terminator byte for the login payload

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/qoriq: Disable clock on resume failure

Can Peng <pengcan@kylinos.cn>
    thermal/drivers/imx: Disable clock on runtime resume failure

Muhammad Bilal <meatuni001@gmail.com>
    staging: rtl8723bs: fix OOB read in rtw_action_frame_parse()

Jeffin Philip <jeffinphilip14@gmail.com>
    usb: gadget: fix null pointer dereference in usb_put_function_instance()

Lovekesh Solanki <lovekeshsolanki00@gmail.com>
    USB: gadget: fix NULL pointer dereference in gadget_dev_ioctl()

Jameson Thies <jthies@google.com>
    usb: typec: ucsi: displayport: Fix OOB altmode array index

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: f_mass_storage: Bump local buffer size in fsg_common_create_luns()

Liu Qi <liuqi@longcheer.com>
    usb-storage: ene_ub6250: fix race between scan work and probe

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    media: usbtv: keep device alive while ALSA card exists

HyeongJun An <sammiee5311@gmail.com>
    ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()

Griffin Kroah-Hartman <griffin@kroah.com>
    usb: image: mdc800: change kmalloc() to kzalloc()

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: remove encap socket caching to avoid reference leak

Petr Vaganov <p.vaganov@ideco.ru>
    scsi: core: Fill in DMA padding bytes in scsi_alloc_sgtables()

Masami Hiramatsu (Google) <mhiramat@kernel.org>
    tracing/mmiotrace: Add NULL check for mmio_trace_array in logging functions

Steven Rostedt <rostedt@goodmis.org>
    tracing/mmiotrace: Remove reference to unused per CPU data pointer

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix potential panic dues to unprotected smc_llc_srv_add_link()

Zack Rusin <zack.rusin@broadcom.com>
    drm/vmwgfx: drop dma_buf reference on foreign-fd prime import

Koichiro Den <den@valinux.co.jp>
    net: ntb_netdev: Fix TX busy and drop handling

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject an unclaimed class value in security_get_classes()

Christian Göttsche <cgzones@googlemail.com>
    selinux: avoid implicit conversions in services code

Eric Dumazet <edumazet@google.com>
    tcp: fix potential race in tcp_v6_syn_recv_sock()

Youngjae Kwon <yjkwon0026@snu.ac.kr>
    fsnotify: Fix stale object mask after concurrent mark updates

Jinjie Ruan <ruanjinjie@huawei.com>
    entry: Fix seccomp bypass after ptrace with TSYNC

Tristan Madani <tristmd@gmail.com>
    RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Use the correct size of wqe when processing SRQ

Dan Carpenter <dan.carpenter@oracle.com>
    RDMA/rxe: Missing unlock on error in get_srq_wqe()

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix over copying in get_srq_wqe

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: make nft_object rhltable per table

Yuqi Xu <xuyuqiabc@gmail.com>
    openvswitch: Fix CT limit teardown use-after-free

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix kernel-doc warnings in internal headers

Norbert Szetei <norbert@doyensec.com>
    net: skbuff: don't skb_tx_error() the source skb in skb_zerocopy()

Norbert Szetei <norbert@doyensec.com>
    net: skbuff: don't touch shared zerocopy state in skb_tx_error()

Sonali Pradhan <sonalipradhan@google.com>
    usb: gadget: u_audio: Fix use-after-free on sound card disconnect

Tzung-Bi Shih <tzungbi@kernel.org>
    platform/chrome: sensorhub: Fix dropped timestamp events and log spam

Zhan Xusheng <zhanxusheng1024@gmail.com>
    udf: Fix i_lenExtents truncation on 32-bit kernels

Thomas Gleixner <tglx@kernel.org>
    timer: Keep debugobjects state consistent in migrate_timer_list()

Bradley Morgan <include@grrlz.net>
    signal: avoid shared siginfo namespace rewrites

Myeonghun Pak <mhun512@gmail.com>
    tpm: tpm_i2c_nuvoton: disable IRQ on wait timeout

Maoyi Xie <maoyixie.tju@gmail.com>
    w1: ds28e17: reject an oversize length on an I2C block read

Chengfeng Ye <nicoyip.dev@gmail.com>
    vsock/virtio: flush works in dependency order

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: rtl818x: initialize eeprom_93cx6 struct to zero

Fabio Estevam <festevam@nabladev.com>
    wifi: mwifiex: Detach sync cmd buffer on interrupted wait

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix info leak and UAF in device unregister path

Haotian Zhang <vulab@iscas.ac.cn>
    dm-switch: use WRITE_ONCE() in switch_region_table_write()

Mikulas Patocka <mpatocka@redhat.com>
    dm-stats: fix a crash if allocation of per-cpu data fails

Naman Jain <namjain@linux.microsoft.com>
    PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: free sk if last

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: pm: ADD_ADDR rtx: always decrease sk refcount

Haoze Xie <royenheart@gmail.com>
    netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst

Takashi Iwai <tiwai@suse.de>
    ALSA: serial-u16550: Check card index validity at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: portman2x4: Check card index validity at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: mts64: Check card index validity at probe

Takashi Iwai <tiwai@suse.de>
    ALSA: mpu401: Check card index validity at probe

Baul Lee <baul.lee@xbow.com>
    ALSA: bcd2000: clear the URB pointers on disconnect

Baul Lee <baul.lee@xbow.com>
    ALSA: 6fire: bound the MIDI event length from the device

Zhiling Zou <zhilinz@nebusec.ai>
    seg6: reset IP6CB after IPv6 decapsulation

Zhiling Zou <zhilinz@nebusec.ai>
    net: cap advertised IP tunnel headroom

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

Bryam Vargas <hexlabsecurity@proton.me>
    platform/chrome: sensorhub: Bound the EC-reported sensor number

Fan Wu <fanwu01@zju.edu.cn>
    mmc: via-sdmmc: stop card-detect handling on probe failure

Kevin Tian <kevin.tian@intel.com>
    iommu/vt-d: Fix no_iommu to disable platform opt-in

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Use file_ns_capable() when checking config space read access

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Avoid spurious runtime PM wakeup on config space accesses

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Avoid spurious runtime PM wakeup on config space accesses

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

Jianing Li <m13940358460@163.com>
    power: supply: max17040: synchronize work cancellation on suspend

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: lp8727: fix use-after-free in lp8727_release_irq()

Jameson Thies <jthies@google.com>
    power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS

Bryam Vargas <hexlabsecurity@proton.me>
    power: supply: cros_usbpd-charger: bound the EC-reported port count

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
    nvme-tcp: do not accept C2HData based on blk_rq_payload_bytes() alone

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

Chunkai Deng <chunkai.deng@oss.qualcomm.com>
    rpmsg: glink: smem: order FIFO read after availability check

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets

David Lee <david.lee@trailofbits.com>
    udf: reject VAT indexes equal to the entry count

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

Jeff Layton <jlayton@kernel.org>
    SUNRPC: always drain cache_cleaner before destroying a cache_detail

Jeff Layton <jlayton@kernel.org>
    sunrpc: route to a populated pool in svc_pool_for_cpu()

Chris Mason <clm@meta.com>
    SUNRPC: xdr_buf_trim: clamp buf->len to avoid underflow

Harshit Varu <harshitvaru666@gmail.com>
    mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction

Qing Ming <a0yami@mailbox.org>
    mpls: reload header after pskb_may_pull()

Coly Li <colyli@fygo.io>
    md: do overflow check for sb->bblog_shift in super_1_load()

Bryam Vargas <hexlabsecurity@proton.me>
    libnvdimm/labels: Prevent integer overflow in __nd_label_validate()

Yuyang Huang <sigefriedhyy@gmail.com>
    ipv6: use RCU iterator to dump route exceptions

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_gre: fix hardware header length for NBMA tunnels

Zhiling Zou <zhilinz@nebusec.ai>
    ip6_tunnel: use skb_cow_head() in ip6_tnl_xmit()

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: hci_intel: fix usage_count leak when autosuspend_delay is negative

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_event: clear HCI_LE_ADV only on a created connection

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: RFCOMM: serialize security confirmation handling

Gongwei Li <ligongwei@kylinos.cn>
    Bluetooth: hci_uart: Fix false success return in hci_uart_setup()

Guangshuo Li <lgs201920130244@gmail.com>
    Bluetooth: hci_bcm: fix usage_count leak when autosuspend_delay is negative

Hui Su <sh_def@163.com>
    cpufreq: schedutil: Fix rate limit overflow

Bryam Vargas <hexlabsecurity@proton.me>
    dm array: reject an array block whose value size is not the caller's

Ilya Krutskih <devsec@tpz.ru>
    dm raid1: reserve space for NUL-terminator in build_constructor_string()

liyouhong <liyouhong@kylinos.cn>
    dm-era: fix shadowed superblock leak on take-snap failure

Jiangshan Yi <yijiangshan@kylinos.cn>
    bnx2x: fix double free in bnx2x_init_firmware() error path

Christoph Zwerschke <cito@online.de>
    Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU

Christoph Zwerschke <cito@online.de>
    Bluetooth: btusb: Add ASUS USB-BT540 for Realtek 8761CU

Niklas Cassel <cassel@kernel.org>
    ata: libata-scsi: fix DSM TRIM for sector sizes larger than 2048 bytes

Matt Turner <mattst88@gmail.com>
    alpha: marvel: Fix lock ordering in init_io7_irqs()

Matt Turner <mattst88@gmail.com>
    alpha: marvel: Fix irq_set_status_flags to use correct IRQ number

Krzysztof Wilczyński <kwilczynski@kernel.org>
    alpha/PCI: Fix I/O port accessor argument order in pci_legacy_write()

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    hsi: omap_ssi_core: fix missing DMA mask setup for SSI controller device

Tien Sung Ang <tien.sung.ang@altera.com>
    fpga: stratix10-soc: Fix SVC mailbox handling during reconfiguration

Marek Czernohous <marek@czernohous.de>
    forcedeth: fix off-by-one when saving/restoring non-PCI config space

Myeonghun Pak <mhun512@gmail.com>
    fbdev: uvesafb: unregister connector callback on init failure

Florian Fuchs <fuchsfl@gmail.com>
    fbdev: pvr2fb: correct user pointer annotation and sentinel initializer

Runyu Xiao <runyu.xiao@seu.edu.cn>
    fbdev: omapfb: panel-dsi-cm: initialize lock before registering display

Yemu Lu <prcups@krgm.moe>
    fat: restore original value when fat_ent_write failed

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

Jiangshan Yi <yijiangshan@kylinos.cn>
    HID: mcp2221: validate report size in mcp2221_raw_event()

Haoxiang Li <haoxiang_li2024@163.com>
    HID: sensor: custom: Fix field sysfs group cleanup on failure

Xu Rao <raoxu@uniontech.com>
    HID: roccat: free buffered reports when destroying device

Ibrahim Hashimov <security@auditcode.ai>
    HID: picolcd: clamp eeprom debugfs read to bytes actually received

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    audit: avoid dropping live tree ref on fsnotify rule autoremove

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound xattr value length in __build_xattrs()

Xiubo Li <xiubo.li@clyso.com>
    ceph: fix UAF in __kick_flushing_caps() on cf entry freed during unlock

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    libceph: reject buckets with mismatched CRUSH ids

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

Myeonghun Pak <mhun512@gmail.com>
    usb: gadget: snps_udc_plat: clean up PHY on probe deferral

Johan Hovold <johan@kernel.org>
    USB: phy: fsl-usb: fix missing static keywords

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: greybus: hid: fix SET_REPORT return value

Hans Verkuil <hverkuil+cisco@kernel.org>
    Revert "media: v4l2-dev: fix error handling in __video_register_device()"

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in dma_req_free()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    powerpc/powermac: fix OF node refcount

Hui Su <sh_def@163.com>
    tracing: Fix crash passing ERR_PTR to kthread_stop()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/insn-eval: Move assign_register() out of KVM as insn_assign_reg()

Joy H.J. Lee <rkr0k0r@gmail.com>
    tools/compiler: match glibc 2.42 definition of __attribute_const__

Guopeng Zhang <zhangguopeng@kylinos.cn>
    mm: memcg: stop reclaim when a limit update is superseded

Breno Leitao <leitao@debian.org>
    mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()

Jordan R Abrahams-Whitehead <ajordanr@google.com>
    include/linux/list.h: mark list_add and __list_add as __always_inline

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    timers/itimer: Zero-init old itimerval before copy to userspace

Felix Yan <felixonmars@archlinux.org>
    clocksource/drivers/timer-sun4i: Advertise a real minimum delta

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Fix racy access at PCM trigger

Fedor Pchelkin <pchelkin@ispras.ru>
    Revert "USB: serial: keyspan_pda: fix information leak"


-------------

Diffstat:

 .../ABI/testing/configfs-usb-gadget-uac1_legacy    |   3 -
 Documentation/usb/gadget-testing.rst               |   3 -
 Makefile                                           |   4 +-
 arch/alpha/kernel/pci-sysfs.c                      |   6 +-
 arch/alpha/kernel/sys_marvel.c                     |  25 +-
 arch/arm/boot/dts/armada-388-helios4.dts           |  13 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   2 +-
 arch/arm/mach-imx/src.c                            |   1 +
 arch/arm/mach-lpc32xx/common.c                     |   5 +-
 arch/arm/mach-lpc32xx/common.h                     |   2 +
 arch/arm/mach-lpc32xx/phy3250.c                    |   2 +
 arch/arm/mach-lpc32xx/pm.c                         |   5 +-
 arch/arm/mm/fault.c                                |  16 +-
 .../boot/dts/allwinner/sun50i-a64-pinephone.dtsi   |   4 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   3 +-
 arch/arm64/boot/dts/rockchip/Makefile              |   1 +
 .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |   6 +-
 .../boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts  |  41 ++
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |   1 +
 arch/arm64/kernel/hibernate.c                      |  16 +-
 arch/csky/kernel/entry.S                           |   6 +-
 arch/m68k/kernel/traps.c                           |   4 +-
 arch/mips/kernel/ptrace.c                          |   6 +-
 arch/openrisc/kernel/entry.S                       |  43 ++-
 arch/parisc/kernel/head.S                          |   1 +
 arch/powerpc/configs/85xx-hw.config                |   1 +
 arch/powerpc/kernel/smp.c                          |   3 +
 arch/powerpc/platforms/powermac/low_i2c.c          |   2 +-
 arch/s390/kvm/guestdbg.c                           |   7 +-
 arch/s390/kvm/interrupt.c                          |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   7 +-
 arch/x86/events/intel/lbr.c                        |  12 +-
 arch/x86/events/intel/uncore.c                     |   2 -
 arch/x86/include/asm/insn-eval.h                   |  36 ++
 arch/x86/include/asm/pkeys.h                       |   3 +
 arch/x86/kvm/emulate.c                             |  26 +-
 arch/x86/kvm/hyperv.c                              |  25 +-
 block/blk-iocost.c                                 |   2 +-
 block/blk-stat.c                                   |   2 +-
 block/kyber-iosched.c                              |   2 +-
 crypto/ecdh.c                                      |  74 ++--
 crypto/ecdh_helper.c                               |   4 +-
 crypto/testmgr.c                                   |  13 +-
 crypto/testmgr.h                                   |  42 +-
 drivers/accessibility/speakup/keyhelp.c            |  17 +-
 drivers/accessibility/speakup/kobjects.c           |   6 +-
 drivers/acpi/bus.c                                 |   4 +-
 drivers/acpi/pci_root.c                            |   3 +-
 drivers/acpi/processor_core.c                      |  31 +-
 drivers/acpi/processor_idle.c                      |  34 +-
 drivers/acpi/utils.c                               |  50 ++-
 drivers/ata/ahci.c                                 |  49 +++
 drivers/ata/libata-scsi.c                          |  28 +-
 drivers/base/firmware_loader/fallback.c            |  38 +-
 drivers/base/firmware_loader/firmware.h            |  10 +
 drivers/base/platform.c                            | 424 +++++++++++----------
 drivers/base/soc.c                                 |  19 +-
 drivers/base/swnode.c                              |   2 +-
 drivers/bluetooth/btmtksdio.c                      |  13 +-
 drivers/bluetooth/btusb.c                          |  15 +-
 drivers/bluetooth/hci_bcm.c                        |   1 +
 drivers/bluetooth/hci_intel.c                      |   1 +
 drivers/bluetooth/hci_ldisc.c                      |   2 +-
 drivers/bluetooth/hci_serdev.c                     |   2 +-
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
 drivers/clk/hisilicon/reset.c                      |   2 +-
 drivers/clk/imx/clk-scu.c                          |   7 +-
 drivers/clk/meson/gxbb.c                           |   2 +-
 drivers/clk/qcom/common.c                          |   4 +-
 drivers/clk/qcom/gcc-msm8916.c                     |   5 +-
 drivers/clk/qcom/gcc-msm8939.c                     |   5 +-
 drivers/clk/qcom/gdsc.c                            | 108 +++++-
 drivers/clk/qcom/gdsc.h                            |   2 +
 drivers/clk/tegra/clk-tegra124-emc.c               |   1 +
 drivers/clk/x86/clk-pmc-atom.c                     |   3 +
 drivers/clocksource/clps711x-timer.c               |   2 +-
 drivers/clocksource/timer-armada-370-xp.c          |  18 +-
 drivers/clocksource/timer-sun4i.c                  |   2 +-
 drivers/cpufreq/imx6q-cpufreq.c                    |   6 +-
 drivers/cpufreq/intel_pstate.c                     |   9 +-
 drivers/cpufreq/spear-cpufreq.c                    |   4 +-
 drivers/crypto/atmel-ecc.c                         |  73 ++--
 drivers/crypto/atmel-sha204a.c                     |   6 +-
 drivers/crypto/sa2ul.c                             |  19 +-
 drivers/dma/dw-edma/dw-edma-core.c                 |  34 +-
 drivers/dma/hisi_dma.c                             |   2 +-
 drivers/dma/mediatek/mtk-uart-apdma.c              |   2 +-
 drivers/dma/qcom/bam_dma.c                         |   1 +
 drivers/dma/xilinx/xilinx_dma.c                    |  12 +-
 drivers/firmware/google/coreboot_table.c           |  35 +-
 drivers/firmware/google/coreboot_table.h           |   1 +
 drivers/firmware/stratix10-svc.c                   |  21 +-
 drivers/fpga/altera-cvp.c                          |  10 +-
 drivers/fpga/stratix10-soc.c                       |  21 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v6_0.c              |  74 ++--
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_color.c    |   6 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c    |  24 ++
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |  35 +-
 .../gpu/drm/bridge/cadence/cdns-mhdp8546-core.c    |   2 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c          |   3 +-
 drivers/gpu/drm/bridge/tc358767.c                  |   2 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |   2 +
 drivers/gpu/drm/drm_drv.c                          |  34 +-
 drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_de.c     |   6 +-
 drivers/gpu/drm/lima/lima_device.c                 |  12 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 -
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c      |  10 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c              |   2 +-
 drivers/gpu/drm/sun4i/sun4i_crtc.c                 |   2 +-
 drivers/gpu/drm/sun4i/sun4i_tcon.c                 |  20 +-
 drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c              |   2 +
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c             |   2 +-
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c            |  18 +-
 drivers/gpu/drm/tve200/tve200_drv.c                |   1 +
 drivers/gpu/drm/vmwgfx/ttm_object.c                |   7 +-
 drivers/gpu/host1x/debug.c                         |   4 +-
 drivers/gpu/host1x/hw/channel_hw.c                 |   5 +-
 drivers/hid/hid-core.c                             | 127 +++---
 drivers/hid/hid-lg4ff.c                            |   8 +
 drivers/hid/hid-mcp2221.c                          |   7 +
 drivers/hid/hid-picolcd_debugfs.c                  |   9 +
 drivers/hid/hid-rmi.c                              |  46 ++-
 drivers/hid/hid-roccat-kone.c                      |   8 +-
 drivers/hid/hid-roccat.c                           |  13 +-
 drivers/hid/hid-sensor-custom.c                    |   9 +-
 drivers/hid/hid-sensor-hub.c                       |  46 ++-
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  16 +-
 drivers/hid/wacom_wac.c                            |  13 +
 drivers/hsi/controllers/omap_ssi_core.c            |   6 +
 drivers/hwmon/emc1403.c                            |   6 +-
 drivers/hwmon/max6621.c                            |   8 +-
 drivers/hwspinlock/hwspinlock_core.c               |   2 +-
 drivers/i2c/i2c-mux.c                              |   1 +
 drivers/i2c/muxes/i2c-demux-pinctrl.c              |   1 +
 drivers/i3c/master.c                               |  11 +-
 drivers/i3c/master/dw-i3c-master.c                 |  10 +-
 drivers/iio/accel/dmard09.c                        |   7 +
 drivers/iio/chemical/sgp30.c                       |   3 +
 drivers/iio/dac/m62332.c                           |  17 +-
 drivers/iio/gyro/mpu3050-core.c                    |   2 +-
 drivers/iio/light/cm32181.c                        |   2 +-
 drivers/iio/light/gp2ap002.c                       |  24 +-
 drivers/iio/light/isl29028.c                       |   2 +-
 drivers/iio/light/tsl2583.c                        |   2 +-
 drivers/iio/light/tsl2772.c                        |   2 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |  20 +-
 drivers/iio/proximity/srf04.c                      |   1 +
 drivers/iio/temperature/hid-sensor-temperature.c   |   3 +-
 drivers/infiniband/core/cma.c                      |   6 +-
 drivers/infiniband/core/device.c                   |  25 +-
 drivers/infiniband/core/restrack.c                 |   4 +-
 drivers/infiniband/core/ucma.c                     |   7 +-
 drivers/infiniband/hw/cxgb4/device.c               |   8 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |   4 +-
 drivers/infiniband/hw/efa/efa_verbs.c              |  15 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   4 +-
 drivers/infiniband/hw/hfi1/hfi.h                   |   2 -
 drivers/infiniband/hw/hfi1/init.c                  |  43 +--
 drivers/infiniband/hw/hfi1/user_sdma.c             |  13 +-
 drivers/infiniband/hw/mlx5/cong.c                  |   8 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  25 +-
 drivers/infiniband/sw/rxe/rxe_resp.c               |  13 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |  32 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +
 drivers/infiniband/ulp/isert/ib_isert.c            |  85 ++++-
 drivers/infiniband/ulp/isert/ib_isert.h            |   1 +
 drivers/infiniband/ulp/srp/ib_srp.c                |  45 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  20 +-
 drivers/input/tablet/aiptek.c                      |  13 +-
 drivers/interconnect/core.c                        |   7 +-
 drivers/iommu/amd/init.c                           |  42 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   5 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c            |  14 +-
 drivers/iommu/dma-iommu.c                          |  13 +-
 drivers/iommu/intel/iommu.c                        |  16 +-
 drivers/iommu/msm_iommu.c                          |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  15 +-
 drivers/irqchip/irq-mbigen.c                       |  20 +-
 drivers/leds/leds-pca9532.c                        |  18 +-
 drivers/mailbox/rockchip-mailbox.c                 |  17 +-
 drivers/md/dm-era-target.c                         |   5 +
 drivers/md/dm-log-userspace-base.c                 |   1 +
 drivers/md/dm-stats.c                              |   6 +-
 drivers/md/dm-switch.c                             |   2 +-
 drivers/md/dm.c                                    |   2 +-
 drivers/md/md.c                                    |   7 +
 drivers/md/persistent-data/dm-array.c              |  16 +
 drivers/md/raid5-ppl.c                             |   4 +-
 drivers/media/cec/core/cec-adap.c                  |   8 +-
 drivers/media/cec/core/cec-pin.c                   |   8 +-
 drivers/media/cec/platform/meson/ao-cec-g12a.c     |   1 +
 drivers/media/cec/platform/stm32/stm32-cec.c       |   3 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |  23 +-
 drivers/media/i2c/ov7740.c                         |   4 +-
 drivers/media/i2c/video-i2c.c                      |   8 +-
 drivers/media/pci/cobalt/cobalt-alsa-main.c        |   1 -
 drivers/media/pci/cx23885/cimax2.c                 |   1 +
 drivers/media/platform/qcom/venus/hfi_parser.c     |   9 +-
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
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   2 +
 drivers/mfd/iqs62x.c                               |   2 +-
 drivers/mfd/rave-sp.c                              |  64 +++-
 drivers/misc/ad525x_dpot-i2c.c                     |   4 +-
 drivers/misc/ad525x_dpot-spi.c                     |   4 +-
 drivers/misc/ad525x_dpot.c                         | 181 +++++----
 drivers/misc/ad525x_dpot.h                         |   5 +-
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
 drivers/mtd/ubi/build.c                            |  63 ++-
 drivers/mtd/ubi/cdev.c                             |   5 +-
 drivers/mtd/ubi/eba.c                              |   5 +-
 drivers/mtd/ubi/fastmap-wl.c                       |  53 ++-
 drivers/mtd/ubi/fastmap.c                          |  76 +---
 drivers/mtd/ubi/io.c                               |  13 +-
 drivers/mtd/ubi/ubi.h                              |  19 +-
 drivers/mtd/ubi/wl.c                               |  38 +-
 drivers/mtd/ubi/wl.h                               |   6 +-
 drivers/net/bonding/bond_netlink.c                 |   2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +
 drivers/net/ethernet/freescale/fec_main.c          |   6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  12 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   6 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   8 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |   1 +
 drivers/net/ethernet/realtek/8139cp.c              |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |  35 +-
 drivers/net/gtp.c                                  |   2 +
 drivers/net/ipvlan/ipvlan_l3s.c                    |   1 -
 drivers/net/ntb_netdev.c                           |  38 +-
 drivers/net/ppp/pppox.c                            |  17 +
 drivers/net/slip/slip.c                            |  11 +-
 drivers/net/thunderbolt.c                          |   6 +-
 drivers/net/tun.c                                  |  21 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath10k/snoc.c             |   9 +-
 drivers/net/wireless/ath/ath11k/debug.c            |  12 +-
 drivers/net/wireless/ath/ath11k/debug.h            |   3 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  32 +-
 drivers/net/wireless/ath/ath11k/trace.c            |   1 +
 drivers/net/wireless/ath/ath11k/trace.h            | 172 +++++++++
 drivers/net/wireless/ath/ath11k/wmi.c              |  15 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   5 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   3 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  12 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   6 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   6 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   1 +
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   8 +
 drivers/nfc/pn533/pn533.c                          |  21 +-
 drivers/ntb/ntb_transport.c                        |  38 +-
 drivers/nvdimm/btt.c                               |   8 +
 drivers/nvdimm/label.c                             |  17 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/fc.c                             |   8 +-
 drivers/nvme/host/tcp.c                            |  11 +-
 drivers/nvme/target/rdma.c                         |  13 +-
 drivers/nvme/target/tcp.c                          |  10 +
 drivers/of/base.c                                  |   2 +-
 drivers/of/property.c                              |  10 +-
 drivers/parisc/eisa.c                              |   5 +
 drivers/pci/controller/dwc/pci-meson.c             |   2 +-
 drivers/pci/controller/pci-hyperv.c                |   1 +
 drivers/pci/pci-sysfs.c                            |  45 ++-
 drivers/pci/proc.c                                 |   8 +-
 drivers/pci/quirks.c                               |   2 +-
 drivers/perf/arm_spe_pmu.c                         |   2 +-
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c      |  26 +-
 drivers/pinctrl/bcm/pinctrl-bcm2835.c              |   1 -
 drivers/pinctrl/pinctrl-rockchip.c                 |  10 +
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |  28 +-
 drivers/power/supply/bd99954-charger.h             |  23 +-
 drivers/power/supply/bq27xxx_battery.c             |   6 +-
 drivers/power/supply/cros_usbpd-charger.c          |  17 +-
 drivers/power/supply/isp1704_charger.c             |   1 +
 drivers/power/supply/lp8727_charger.c              |   4 +-
 drivers/power/supply/max17040_battery.c            |   2 +-
 drivers/power/supply/sbs-battery.c                 | 160 +++++---
 drivers/power/supply/sc2731_charger.c              |   8 +-
 drivers/pps/pps.c                                  |  10 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  10 +-
 drivers/rapidio/rio-scan.c                         |   1 +
 drivers/regulator/as3722-regulator.c               |   1 -
 drivers/regulator/core.c                           |   6 +-
 drivers/regulator/max8998.c                        |   1 -
 drivers/regulator/qcom-rpmh-regulator.c            |   6 +-
 drivers/remoteproc/mtk_scp.c                       |   9 +-
 drivers/remoteproc/qcom_common.c                   |   4 +-
 drivers/remoteproc/remoteproc_core.c               | 357 +++++++++++++----
 drivers/remoteproc/remoteproc_elf_loader.c         |  12 +-
 drivers/remoteproc/remoteproc_sysfs.c              |  35 +-
 drivers/remoteproc/remoteproc_virtio.c             |   6 +-
 drivers/rpmsg/qcom_glink_native.c                  |  36 +-
 drivers/rpmsg/qcom_glink_smem.c                    |   7 +
 drivers/rtc/rtc-pcf8563.c                          |   4 +-
 drivers/s390/block/dasd.c                          |   6 +-
 drivers/s390/block/dasd_eckd.c                     |  40 +-
 drivers/s390/block/dasd_erp.c                      |   3 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +
 drivers/scsi/pm8001/pm8001_init.c                  |   4 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   7 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  39 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   2 +
 drivers/scsi/qla2xxx/qla_dfs.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  47 ++-
 drivers/scsi/qla2xxx/qla_inline.h                  |  13 +
 drivers/scsi/qla2xxx/qla_isr.c                     |  20 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  26 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  14 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  24 +-
 drivers/scsi/qla2xxx/qla_target.h                  |   1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  61 +--
 drivers/scsi/scsi_lib.c                            |   2 +
 drivers/soc/bcm/bcm2835-power.c                    |   7 +-
 drivers/soc/samsung/exynos-pmu.c                   |   4 +-
 drivers/soc/ti/knav_qmss.h                         |   1 +
 drivers/soc/ti/knav_qmss_queue.c                   |  14 +-
 drivers/soundwire/qcom.c                           |  31 +-
 drivers/spi/spi-img-spfi.c                         |   5 +-
 drivers/spi/spi-sprd-adi.c                         |   6 +
 drivers/staging/fbtft/fbtft-sysfs.c                |   2 +-
 drivers/staging/greybus/audio_gb.c                 |  13 +
 drivers/staging/greybus/audio_manager_sysfs.c      |   2 +-
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/media/meson/vdec/vdec.c            |   4 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c        |   4 +-
 drivers/staging/octeon/ethernet-mem.c              |  31 +-
 drivers/staging/octeon/ethernet-mem.h              |   5 +-
 drivers/staging/octeon/ethernet-rx.c               |   2 +-
 drivers/staging/octeon/ethernet-tx.c               |   2 +
 drivers/staging/octeon/ethernet.c                  |   6 +-
 drivers/staging/rtl8723bs/core/rtw_cmd.c           |   8 +-
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     |   3 +
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |   4 +-
 drivers/staging/sm750fb/sm750.c                    |   4 +-
 drivers/target/iscsi/iscsi_target.c                |  16 +-
 drivers/target/iscsi/iscsi_target_login.c          |   2 +-
 drivers/target/target_core_transport.c             | 345 +++++++++--------
 drivers/target/target_core_xcopy.c                 |   8 +-
 drivers/thermal/imx_thermal.c                      |   9 +-
 .../intel/int340x_thermal/int3400_thermal.c        |   9 +-
 drivers/thermal/qoriq_thermal.c                    |  13 +-
 drivers/tty/hvc/Kconfig                            |   2 +-
 drivers/tty/serial/amba-pl011.c                    |  10 +
 drivers/tty/tty_io.c                               |   4 +-
 drivers/uio/uio.c                                  |   5 +
 drivers/usb/atm/usbatm.c                           |   4 +-
 drivers/usb/gadget/configfs.c                      |   4 +-
 drivers/usb/gadget/function/f_fs.c                 |  14 +-
 drivers/usb/gadget/function/f_mass_storage.c       |   2 +-
 drivers/usb/gadget/function/f_tcm.c                |  43 ++-
 drivers/usb/gadget/function/f_uac1_legacy.c        |  56 ---
 drivers/usb/gadget/function/f_uvc.c                |   7 +-
 drivers/usb/gadget/function/u_audio.c              |  24 +-
 drivers/usb/gadget/function/u_uac1_legacy.h        |   3 -
 drivers/usb/gadget/functions.c                     |   2 +-
 drivers/usb/gadget/legacy/inode.c                  |   3 +-
 drivers/usb/gadget/udc/r8a66597-udc.c              |   1 -
 drivers/usb/gadget/udc/snps_udc_plat.c             |   5 +-
 drivers/usb/host/xhci-ring.c                       |  32 +-
 drivers/usb/image/mdc800.c                         |   4 +-
 drivers/usb/phy/phy-fsl-usb.c                      |  52 +--
 drivers/usb/phy/phy-fsl-usb.h                      |   6 +-
 drivers/usb/renesas_usbhs/common.c                 |   6 +-
 drivers/usb/serial/keyspan_pda.c                   |   2 +-
 drivers/usb/storage/ene_ub6250.c                   |   2 +
 drivers/usb/typec/ucsi/displayport.c               |   2 +-
 drivers/vdpa/mlx5/core/mr.c                        |   2 +-
 drivers/vfio/pci/vfio_pci_config.c                 |   1 +
 drivers/video/fbdev/kyro/fbdev.c                   |  24 +-
 .../fbdev/omap2/omapfb/displays/panel-dsi-cm.c     |   4 +-
 drivers/video/fbdev/pvr2fb.c                       |   4 +-
 drivers/video/fbdev/uvesafb.c                      |   2 +
 drivers/virtio/virtio_balloon.c                    |   6 +
 drivers/w1/masters/ds2482.c                        |   4 +
 drivers/w1/slaves/w1_ds28e17.c                     |   8 +
 drivers/xen/xenbus/xenbus_xs.c                     |  16 +-
 fs/ceph/caps.c                                     |  11 +-
 fs/ceph/xattr.c                                    |   1 +
 fs/cifs/cifs_debug.c                               |   2 +-
 fs/ecryptfs/crypto.c                               |   2 +-
 fs/ecryptfs/ecryptfs_kernel.h                      |   3 +-
 fs/ecryptfs/keystore.c                             |  45 ++-
 fs/ecryptfs/messaging.c                            |  11 +-
 fs/ecryptfs/miscdev.c                              |   5 +-
 fs/ecryptfs/super.c                                |   7 +
 fs/ext4/file.c                                     |   7 +
 fs/ext4/inode.c                                    |  10 +
 fs/f2fs/file.c                                     |   9 +-
 fs/f2fs/namei.c                                    |  11 +-
 fs/fat/misc.c                                      |   4 +
 fs/fat/nfs.c                                       |   4 +-
 fs/hfsplus/catalog.c                               |  25 +-
 fs/hfsplus/hfsplus_fs.h                            |   6 +
 fs/hugetlbfs/inode.c                               |   3 +-
 fs/isofs/compress.c                                |   1 +
 fs/lockd/svcsubs.c                                 |  53 +--
 fs/nfs/client.c                                    |  21 +-
 fs/nfs/file.c                                      |   2 +
 fs/nfs/filelayout/filelayoutdev.c                  |   3 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |   3 +-
 fs/nfs/inode.c                                     | 111 +++---
 fs/nfs/internal.h                                  |   1 +
 fs/nfs/netns.h                                     |   6 +-
 fs/nfs/nfs4client.c                                |   1 +
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfs/pnfs.c                                      |  61 ++-
 fs/nfs/pnfs.h                                      |   3 +-
 fs/nfs/pnfs_nfs.c                                  |  39 +-
 fs/nfsd/flexfilelayoutxdr.c                        |  20 +-
 fs/nfsd/nfs2acl.c                                  |  31 +-
 fs/nfsd/nfs4proc.c                                 |  39 +-
 fs/nfsd/nfs4state.c                                | 206 +++++++---
 fs/nfsd/nfs4xdr.c                                  |  17 +
 fs/nfsd/nfscache.c                                 |   2 +-
 fs/nfsd/nfsfh.c                                    |   4 +-
 fs/nfsd/nfsproc.c                                  |   7 +
 fs/nfsd/nfssvc.c                                   |   4 +-
 fs/nfsd/nfsxdr.c                                   |  32 +-
 fs/nilfs2/bmap.c                                   |   2 +-
 fs/nilfs2/bmap.h                                   |   2 +-
 fs/nilfs2/btree.c                                  |  39 +-
 fs/nilfs2/direct.c                                 |   4 +-
 fs/nilfs2/segment.c                                |   4 +
 fs/nilfs2/the_nilfs.c                              |   6 +
 fs/notify/fanotify/fanotify_user.c                 |  17 +-
 fs/notify/inotify/inotify_user.c                   |  15 +-
 fs/ocfs2/acl.c                                     | 141 ++++---
 fs/ocfs2/acl.h                                     |  19 +-
 fs/ocfs2/cluster/heartbeat.c                       | 201 +++++++---
 fs/ocfs2/cluster/heartbeat.h                       |   7 +-
 fs/ocfs2/cluster/netdebug.c                        |   2 +-
 fs/ocfs2/cluster/nodemanager.c                     |  10 +
 fs/ocfs2/cluster/nodemanager.h                     |   1 +
 fs/ocfs2/cluster/tcp.c                             |  89 ++++-
 fs/ocfs2/cluster/tcp.h                             |   1 +
 fs/ocfs2/dir.c                                     |   2 +-
 fs/ocfs2/dlm/dlmdomain.c                           |   2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |   6 +
 fs/ocfs2/dlm/dlmrecovery.c                         |   9 +
 fs/ocfs2/namei.c                                   |  17 +-
 fs/ocfs2/refcounttree.c                            |  47 ++-
 fs/ocfs2/stack_o2cb.c                              |   6 +-
 fs/ocfs2/xattr.c                                   |  91 +++--
 fs/ocfs2/xattr.h                                   |   9 +-
 fs/orangefs/devorangefs-req.c                      |   1 +
 fs/orangefs/orangefs-debugfs.c                     |   1 +
 fs/squashfs/cache.c                                |   2 +-
 fs/ubifs/auth.c                                    |   2 +-
 fs/udf/inode.c                                     |   2 +-
 fs/udf/partition.c                                 |   2 +-
 fs/udf/super.c                                     |  23 +-
 fs/udf/symlink.c                                   |   2 +
 include/acpi/acpi_bus.h                            |  21 +
 include/crypto/ecdh.h                              |   2 -
 include/linux/bitfield.h                           |  95 ++++-
 include/linux/bpf.h                                |   1 +
 include/linux/hid.h                                |   1 +
 include/linux/highmem.h                            |  89 ++++-
 include/linux/irqdomain.h                          |  23 ++
 include/linux/list.h                               |  15 +-
 include/linux/nfs_fs.h                             |   1 +
 include/linux/nfs_xdr.h                            |   3 +-
 include/linux/of.h                                 |   2 +
 include/linux/of_graph.h                           |   4 +-
 include/linux/platform_device.h                    |  11 +
 include/linux/remoteproc.h                         | 297 ++-------------
 include/linux/rsc_table.h                          | 364 ++++++++++++++++++
 include/linux/rtsx_usb.h                           |   3 +
 include/linux/seq_buf.h                            |  25 ++
 include/linux/soundwire/sdw.h                      |   2 +
 include/linux/trace_events.h                       |   3 +
 include/media/rc-map.h                             |   2 -
 include/net/bluetooth/l2cap.h                      |  11 +-
 include/net/inet_connection_sock.h                 |  11 +-
 include/net/ip_tunnels.h                           |  11 +-
 include/net/mac80211.h                             |  18 +
 include/net/netfilter/nf_queue.h                   |   1 +
 include/net/netfilter/nf_tables.h                  |   4 +-
 include/net/pkt_sched.h                            |   1 +
 include/net/sch_generic.h                          |   1 +
 include/net/sctp/structs.h                         |   2 +-
 include/net/tcp.h                                  |  13 +-
 include/net/xfrm.h                                 |   1 -
 include/target/target_core_base.h                  |   1 -
 include/target/target_core_fabric.h                |  10 +-
 include/uapi/linux/time_types.h                    |   2 +-
 include/uapi/mtd/ubi-user.h                        |   8 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/bpf/cgroup.c                                |   2 +-
 kernel/bpf/core.c                                  |   4 +
 kernel/bpf/net_namespace.c                         |  17 +-
 kernel/bpf/ringbuf.c                               |   2 +-
 kernel/bpf/verifier.c                              |  26 +-
 kernel/entry/common.c                              |   3 +
 kernel/irq/irqdomain.c                             |  41 +-
 kernel/locking/lockdep.c                           |   2 +
 kernel/power/wakelock.c                            |   2 +-
 kernel/sched/cpufreq_schedutil.c                   |  59 +--
 kernel/sched/fair.c                                |  53 +--
 kernel/signal.c                                    |   4 +
 kernel/sys.c                                       |   2 +-
 kernel/time/clocksource.c                          |   8 +-
 kernel/time/itimer.c                               |   2 +-
 kernel/time/timekeeping.c                          |   6 +
 kernel/time/timer.c                                |   1 +
 kernel/trace/trace.c                               | 228 +++++++++++
 kernel/trace/trace.h                               |   3 +
 kernel/trace/trace_dynevent.h                      |   4 +-
 kernel/trace/trace_events.c                        |  32 ++
 kernel/trace/trace_events_synth.c                  |   2 +-
 kernel/trace/trace_kprobe.c                        |   4 +-
 kernel/trace/trace_mmiotrace.c                     |  24 +-
 kernel/trace/trace_output.c                        |   2 +-
 kernel/trace/trace_printk.c                        |  11 +
 kernel/trace/trace_uprobe.c                        |   4 +-
 lib/iov_iter.c                                     |   8 +-
 lib/string.c                                       |   3 +-
 lib/test_hmm.c                                     |   2 +-
 lib/ucs2_string.c                                  |   2 +-
 mm/Kconfig                                         |   3 +
 mm/highmem.c                                       | 151 +++++++-
 mm/memcontrol.c                                    |   6 +
 mm/vmscan.c                                        |   2 +-
 net/batman-adv/bridge_loop_avoidance.c             |  80 ++--
 net/batman-adv/distributed-arp-table.c             |   8 +-
 net/batman-adv/main.c                              |   4 +
 net/bluetooth/6lowpan.c                            |  25 +-
 net/bluetooth/ecdh_helper.c                        |   2 -
 net/bluetooth/hci_event.c                          |   7 +-
 net/bluetooth/l2cap_core.c                         |  58 ++-
 net/bluetooth/l2cap_sock.c                         | 114 +++++-
 net/bluetooth/msft.c                               |   5 +
 net/bluetooth/rfcomm/core.c                        |  12 +-
 net/bluetooth/selftest.c                           |   2 +-
 net/bluetooth/smp.c                                |   6 +-
 net/bridge/br_mrp_netlink.c                        |   4 +-
 net/bridge/br_netlink_tunnel.c                     |   3 +-
 net/bridge/br_vlan.c                               |   4 +-
 net/ceph/osdmap.c                                  |   2 +
 net/core/filter.c                                  |   6 +-
 net/core/lwt_bpf.c                                 |  15 +-
 net/core/skbuff.c                                  |  11 +-
 net/core/xdp.c                                     |   4 +-
 net/dccp/dccp.h                                    |   4 +-
 net/dccp/ipv4.c                                    |   4 +-
 net/dccp/ipv6.c                                    |   7 +-
 net/dccp/minisocks.c                               |   2 +-
 net/hsr/hsr_device.c                               |  14 +-
 net/hsr/hsr_framereg.c                             |  63 ++-
 net/hsr/hsr_main.h                                 |   8 +-
 net/ipv4/esp4.c                                    |  49 +--
 net/ipv4/inet_connection_sock.c                    |   9 +
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp_fastopen.c                            |   2 +-
 net/ipv4/tcp_ipv4.c                                |   8 +-
 net/ipv4/tcp_minisocks.c                           |   2 +-
 net/ipv4/tcp_output.c                              |   2 +-
 net/ipv6/esp6.c                                    |  49 +--
 net/ipv6/ip6_gre.c                                 |  34 +-
 net/ipv6/ip6_tunnel.c                              |  22 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/seg6_local.c                              |   9 +
 net/ipv6/sit.c                                     |   2 +-
 net/ipv6/tcp_ipv6.c                                |  98 ++---
 net/ipv6/xfrm6_input.c                             |   2 +-
 net/iucv/af_iucv.c                                 |   2 +
 net/kcm/kcmsock.c                                  |   3 +
 net/key/af_key.c                                   |  52 ++-
 net/mpls/af_mpls.c                                 |   2 +
 net/mptcp/pm_netlink.c                             |  30 +-
 net/mptcp/subflow.c                                |   6 +-
 net/mptcp/syncookies.c                             |   1 +
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |  10 +-
 net/netfilter/nf_nat_sip.c                         |   5 +
 net/netfilter/nf_queue.c                           |  16 +
 net/netfilter/nf_tables_api.c                      |  48 +--
 net/netfilter/nfnetlink_queue.c                    |   3 +
 net/netfilter/xt_cgroup.c                          |  21 +-
 net/netfilter/xt_hl.c                              |  27 ++
 net/nfc/digital_core.c                             |   2 +-
 net/nfc/llcp_core.c                                |  29 +-
 net/nfc/llcp_sock.c                                |  14 +-
 net/nfc/nci/data.c                                 |  10 +-
 net/openvswitch/conntrack.c                        | 130 ++++---
 net/openvswitch/conntrack.h                        |   6 +-
 net/openvswitch/datapath.c                         |  60 +--
 net/openvswitch/datapath.h                         |  26 +-
 net/openvswitch/vport.h                            |   8 +
 net/phonet/pep.c                                   |   2 +-
 net/rds/cong.c                                     |   4 +-
 net/sched/sch_api.c                                |   7 +-
 net/sched/sch_codel.c                              |   2 +-
 net/sched/sch_fq.c                                 |  30 +-
 net/sched/sch_fq_codel.c                           |   6 +-
 net/sched/sch_fq_pie.c                             |   3 +-
 net/sched/sch_generic.c                            |   9 +-
 net/sched/sch_hhf.c                                |   4 +
 net/sched/sch_sfq.c                                |   3 +-
 net/sched/sch_teql.c                               |   1 +
 net/sctp/inqueue.c                                 |   7 +-
 net/sctp/sm_sideeffect.c                           |   4 +
 net/sctp/stream.c                                  |  48 ++-
 net/smc/af_smc.c                                   |   2 +
 net/smc/smc_llc.c                                  |   1 +
 net/sunrpc/auth_gss/auth_gss.c                     |   6 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  13 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   6 -
 net/sunrpc/auth_gss/gss_rpc_upcall.h               |   1 -
 net/sunrpc/auth_gss/svcauth_gss.c                  |   3 +-
 net/sunrpc/cache.c                                 |   7 +-
 net/sunrpc/rpcb_clnt.c                             |   4 +
 net/sunrpc/sunrpc_syms.c                           |   1 +
 net/sunrpc/svc.c                                   |  29 +-
 net/sunrpc/xdr.c                                   |   2 +-
 net/vmw_vsock/af_vsock.c                           |   6 +-
 net/vmw_vsock/virtio_transport.c                   |   2 +-
 net/xfrm/xfrm_state.c                              |   3 -
 scripts/tags.sh                                    |   2 +-
 security/apparmor/lib.c                            |  20 +-
 security/selinux/include/security.h                |   4 +-
 security/selinux/selinuxfs.c                       |   7 +-
 security/selinux/ss/services.c                     |  45 ++-
 security/smack/smack.h                             |   7 +-
 security/smack/smack_lsm.c                         |  95 +++--
 security/smack/smackfs.c                           | 222 ++++-------
 sound/core/pcm_native.c                            |   2 +
 sound/drivers/aloop.c                              | 101 +++--
 sound/drivers/mpu401/mpu401.c                      |   6 +
 sound/drivers/mts64.c                              |   6 +
 sound/drivers/portman2x4.c                         |   6 +
 sound/drivers/serial-u16550.c                      |   6 +
 sound/pci/asihpi/hpi6000.c                         |   5 +
 sound/pci/hda/hda_proc.c                           |   2 +-
 sound/pci/via82xx_modem.c                          |  26 +-
 sound/soc/codecs/cs35l33.c                         |  14 +-
 sound/soc/codecs/cs35l34.c                         |  14 +-
 sound/soc/fsl/fsl-asoc-card.c                      |   4 +-
 sound/soc/fsl/mpc5200_psc_i2s.c                    |   1 +
 sound/soc/intel/atom/sst/sst_pci.c                 |   4 +-
 sound/soc/meson/meson-card-utils.c                 |  17 +-
 sound/soc/pxa/pxa-ssp.c                            |   7 +-
 sound/soc/samsung/aries_wm8994.c                   |   1 +
 sound/soc/soc-dapm.c                               |   2 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  14 +-
 sound/usb/6fire/comm.c                             |   9 +-
 sound/usb/bcd2000/bcd2000.c                        |  11 +-
 sound/usb/midi.c                                   |   2 +
 tools/bpf/bpftool/map.c                            |   4 +-
 tools/include/linux/compiler.h                     |   2 +-
 tools/perf/builtin-sched.c                         |  40 +-
 tools/perf/builtin-stat.c                          |  15 +-
 tools/perf/ui/browsers/hists.c                     |   6 +-
 tools/perf/util/auxtrace.c                         |  15 +-
 tools/perf/util/cs-etm.c                           |  81 +++-
 tools/perf/util/dso.c                              |  19 +-
 tools/perf/util/intel-bts.c                        |   2 +-
 tools/perf/util/intel-pt.c                         |   2 +-
 tools/perf/util/machine.c                          |  34 +-
 tools/perf/util/synthetic-events.c                 |   6 +-
 tools/perf/util/thread-stack.c                     |   2 +-
 tools/perf/util/trace-event-read.c                 |  33 +-
 .../selftests/arm64/mte/check_ksm_options.c        |  29 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   3 +-
 .../selftests/rseq/rseq-x86-thread-pointer.h       |   4 +-
 tools/testing/selftests/timers/leap-a-day.c        |  19 +-
 tools/testing/selftests/zram/zram_lib.sh           |   2 +-
 708 files changed, 8383 insertions(+), 4068 deletions(-)


