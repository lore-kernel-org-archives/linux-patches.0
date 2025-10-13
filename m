Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B979B30C361;
	Mon, 13 Oct 2025 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368799; cv=none; b=N63toYZfRKrOlQWDeEzsGnK1W4ACTnwMtVOKHMAX+E/WdzVZiowEqRITVJOVBH12yM37ONcNCxEvw5e3rn2DNcAuB2lpjis3j8qNXp1tMl+PDQrtrYRK9QCIPVpJgV56w7uDpVaioxCPE6uIXfgAucLPzq8ZxvSZN2M00l2cvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368799; c=relaxed/simple;
	bh=Pp4tTkWcBNVkwgT8r0s1OklgYe92uY68QIBaKZnz/6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GKs1F08kEHLe2wNeE186O2XL+C8CX9602JmrQ/1mf5aF+kjR+2Tc8dx4tCmjnxDHBzri1U4aMQJyOCBYxZ3TDg0nWE9t3JH4cTCexo9uYGyMv2j7uyA735iBsRzVta5OG1Cmy8ttUGMrneIive7yDQeXF19C1hYTa6aEDhuRj8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8M23Qph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8M23Qph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DE1C4CEE7;
	Mon, 13 Oct 2025 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368799;
	bh=Pp4tTkWcBNVkwgT8r0s1OklgYe92uY68QIBaKZnz/6k=;
	h=From:To:Cc:Subject:Date:From;
	b=y8M23QphpMGq1KZvtnkY4aWoflD88B8YK6fbSAZvXBbkJsoRVpQCtRlxjgesecqaR
	 UILvJYFHM4aJM113kR9sbJJ2BIC/Tw905lnBahzzCWf7lSvltZiQxZDYmuuszKWKVC
	 jyG5GhUWR6zDNSlwHw9/2EHxYSzILSdCMT2da5Ho=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.17 000/563] 6.17.3-rc1 review
Date: Mon, 13 Oct 2025 16:37:41 +0200
Message-ID: <20251013144411.274874080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.17.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.17.3-rc1
X-KernelTest-Deadline: 2025-10-15T14:44+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.17.3 release.
There are 563 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.17.3-rc1

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu/vcn: Fix double-free of vcn dump buffer

Marek Szyprowski <m.szyprowski@samsung.com>
    scsi: ufs: core: Fix PM QoS mutex initialization

Miaoqian Lin <linmq006@gmail.com>
    usb: cdns3: cdnsp-pci: remove redundant pci_disable_device() call

Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
    arm64: dts: qcom: qcm2290: Disable USB SS bus instances in park mode

Sven Peter <sven@kernel.org>
    usb: typec: tipd: Clear interrupts first

Oleksij Rempel <o.rempel@pengutronix.de>
    net: usb: asix: hold PM usage ref to avoid PM/MDIO + RTNL deadlock

Dominique Martinet <asmadeus@codewreck.org>
    net/9p: Fix buffer overflow in USB transport layer

Salah Triki <salah.triki@gmail.com>
    bus: fsl-mc: Check return value of platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    pinctrl: check the return value of pinmux_ops::get_function_name()

Jens Wiklander <jens.wiklander@linaro.org>
    tee: fix register_shm_helper()

Duoming Zhou <duoming@zju.edu.cn>
    thunderbolt: Fix use-after-free in tb_dp_dprx_work

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    PCI: endpoint: pci-epf-test: Add NULL check for DMA channels before release

Zhen Ni <zhen.ni@easystack.cn>
    remoteproc: pru: Fix potential NULL pointer dereference in pru_rproc_set_ctable()

Breno Leitao <leitao@debian.org>
    PCI/AER: Avoid NULL pointer dereference in aer_ratelimit()

Lei Lu <llfamsec@gmail.com>
    sunrpc: fix null pointer dereference on zero-length checksum

Zhen Ni <zhen.ni@easystack.cn>
    Input: uinput - zero-initialize uinput_ff_upload_compat to avoid info leak

Marek Vasut <marek.vasut@mailbox.org>
    Input: atmel_mxt_ts - allow reset GPIO to sleep

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: Skip reference for DMA handles

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: fix possible map leak in fastrpc_put_args

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: Fix fastrpc_map_lookup operation

Ling Xu <quic_lxu5@quicinc.com>
    misc: fastrpc: Save actual DMA size in fastrpc_map structure

Guangshuo Li <lgs201920130244@gmail.com>
    nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()

Lance Yang <lance.yang@linux.dev>
    selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled

Yang Shi <yang@os.amperecomputing.com>
    mm: hugetlb: avoid soft lockup when mprotect to large memory area

Janne Grunau <j@jannau.net>
    fbdev: simplefb: Fix use after free in simplefb_detach_genpds()

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid

Jan Kara <jack@suse.cz>
    ext4: fix checks for orphan inodes

Baokun Li <libaokun1@huawei.com>
    ext4: fix potential null deref in ext4_mb_init()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add max ip connections parameter

Matvey Kovalev <matvey.kovalev@ispras.ru>
    ksmbd: fix error code overwriting in smb2_get_info_filesystem()

Yunseong Kim <ysk@kzalloc.com>
    ksmbd: Fix race condition in RPC handle list access

Jakub Acs <acsjakub@amazon.de>
    mm/ksm: fix flag-dropping behavior in ksm_madvise

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: BPF: Fix uninitialized symbol 'retval_off'

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Remove duplicated flags check

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: No text_poke() for kernel text

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Remove duplicated bpf_flush_icache()

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Make error handling robust in arch_prepare_bpf_trampoline()

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Make trampoline size stable

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Don't align trampoline size

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: No support of struct argument in trampoline programs

Hengqi Chen <hengqi.chen@gmail.com>
    LoongArch: BPF: Sign-extend struct ops return values properly

Xi Ruoyao <xry111@xry111.site>
    pwm: loongson: Fix LOONGSON_PWM_FREQ_DEFAULT

Youling Tang <tangyouling@kylinos.cn>
    LoongArch: Automatically disable kaslr if boot from kexec_file

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix NULL pointer dereference in __dm_suspend()

Zheng Qixing <zhengqixing@huawei.com>
    dm: fix queue start/stop imbalance under suspend/load/resume races

Steven Rostedt <rostedt@goodmis.org>
    tracing: Stop fortify-string from warning in tracing_mark_raw_write()

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix tracing_mark_raw_write() to use buf and not ubuf

Steven Rostedt <rostedt@goodmis.org>
    tracing: Have trace_marker use per-cpu data to read user space

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix irqoff tracers on failure of acquiring calltime

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix wakeup tracers on failure of acquiring calltime

Yuan Chen <chenyuan@kylinos.cn>
    tracing: Fix race condition in kprobe initialization causing NULL pointer dereference

Sasha Levin <sashal@kernel.org>
    tracing: Fix lock imbalance in s_start() memory allocation failure path

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()

Hans de Goede <hansg@kernel.org>
    mfd: intel_soc_pmic_chtdc_ti: Set use_single_read regmap_config flag

Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
    mfd: rz-mtu3: Fix MTU5 NFCR register offset

Deepak Sharma <deepak.sharma.472935@gmail.com>
    net: nfc: nci: Add parameter validation for packet data

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    fs: udf: fix OOB read in lengthAllocDescs handling

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: ipc4-pcm: fix start offset calculation for chain DMA

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: ipc4-pcm: fix delay calculation when DSP resamples

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wcd937x: make stub functions inline

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: codecs: wcd937x: set the comp soundwire port correctly

Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
    ASoC: SOF: ipc3-topology: Fix multi-core and static pipelines tear down

Ma Ke <make24@iscas.ac.cn>
    ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/zcrx: fix overshooting recv limit

Jens Axboe <axboe@kernel.dk>
    io_uring/waitid: always prune wait queue entry in io_waitid_wait()

Miaoqian Lin <linmq006@gmail.com>
    hisi_acc_vfio_pci: Fix reference leak in hisi_acc_vfio_debug_init

Naman Jain <namjain@linux.microsoft.com>
    uio_hv_generic: Let userspace take care of interrupt mask

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix uninit-value in squashfs_get_parent

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Spectre 14t-ea100

Steven 'Steve' Kendall <skend@chromium.org>
    ALSA: hda/hdmi: Add pin fix for HP ProDesk model

Jarkko Sakkinen <jarkko@kernel.org>
    tpm: Disable TPM2_TCG_HMAC by default

Yazhou Tang <tangyazhou518@outlook.com>
    bpf: Reject negative offsets for ALU ops

Brahmajit Das <listout@listout.xyz>
    bpf: Skip scalar adjustment for BPF_NEG if dst is a pointer

Jiri Olsa <jolsa@kernel.org>
    selftests/bpf: Fix realloc size in bpf_get_addrs

Menglong Dong <menglong8.dong@gmail.com>
    selftests/bpf: move get_ksyms and get_addrs to trace_helpers.c

Shubham Sharma <slopixelz@gmail.com>
    selftests/bpf: Fix typos and grammar in test sources

zhang jiao <zhangjiao2@cmss.chinamobile.com>
    vhost: vringh: Modify the return value check

Bo Sun <bo@mboxify.com>
    octeontx2-pf: fix bitmap leak

Bo Sun <bo@mboxify.com>
    octeontx2-vf: fix bitmap leak

Mike Snitzer <snitzer@kernel.org>
    nfs/localio: avoid issuing misaligned IO using O_DIRECT

Mike Snitzer <snitzer@kernel.org>
    NFSD: filecache: add STATX_DIOALIGN and STATX_DIO_READ_ALIGN support

Jakub Kicinski <kuba@kernel.org>
    Revert "net/mlx5e: Update and set Xon/Xoff upon MTU set"

Guixin Liu <kanie@linux.alibaba.com>
    iommufd: Register iommufd mock devices with fwspec

Wei Fang <wei.fang@nxp.com>
    net: enetc: initialize SW PIR and CIR based HW PIR and CIR values

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix xfrm offload feature setup on active-backup mode

Enzo Matsumiya <ematsumiya@suse.de>
    smb: client: fix crypto buffers in non-linear memory

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: fw reset, add reset timeout work

Shay Drory <shayd@nvidia.com>
    net/mlx5: pagealloc: Fix reclaim race during command interface teardown

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Stop polling for command response if interface goes down

Yeounsu Moon <yyyynoom@gmail.com>
    net: dlink: handle copy_thresh allocation failure

Kohei Enju <enjuk@amazon.com>
    net: ena: return 0 in ena_get_rxfh_key_size() when RSS hash key is not configurable

Kohei Enju <enjuk@amazon.com>
    nfp: fix RSS hash key size when RSS is not supported

Eric Dumazet <edumazet@google.com>
    tcp: use skb->len instead of skb->truesize in tcp_can_ingest()

Alok Tiwari <alok.a.tiwari@oracle.com>
    idpf: fix mismatched free function for dma_alloc_coherent

Alok Tiwari <alok.a.tiwari@oracle.com>
    PCI: j721e: Fix incorrect error message in probe()

Erick Karanja <karanja99erick@gmail.com>
    mtd: rawnand: atmel: Fix error handling path in atmel_nand_controller_add_nands

Chao Yu <chao@kernel.org>
    f2fs: fix UAF issue in f2fs_merge_page_bio()

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: fix double free in register_one_node()

Dan Carpenter <dan.carpenter@linaro.org>
    ocfs2: fix double free in user_cluster_connect()

Alistair Popple <apopple@nvidia.com>
    cramfs: fix incorrect physical page address calculation

Nishanth Menon <nm@ti.com>
    hwrng: ks-sa - fix division by zero in ks_sa_rng_init

Fan Wu <wufan@kernel.org>
    KEYS: X.509: Fix Basic Constraints CA flag parsing

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix using random address for BIG/PA advertisements

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: don't leak skb in ISO_CONT RX

Pauli Virtanen <pav@iki.fi>
    Bluetooth: ISO: free rx_skb if not consumed

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix possible UAF on iso_conn_free

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not exposing debug UUID on MGMT_OP_READ_EXP_FEATURES_INFO

Kiran K <kiran.k@intel.com>
    Bluetooth: btintel_pcie: Refactor Device Coredump

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: single dma_alloc_coherent() for DMA descriptors

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: move ring size computation to functions

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: remove illusion about TBQPH/RBQPH being per-queue

Michael S. Tsirkin <mst@redhat.com>
    vhost: vringh: Fix copy_to_iter return value check

I Viswanath <viswanathiyyappan@gmail.com>
    ptp: Add a upper bound on max_vclocks

I Viswanath <viswanathiyyappan@gmail.com>
    net: usb: Remove disruptive netif_wake_queue in rtl8150_set_multicast

Claudiu Manoil <claudiu.manoil@nxp.com>
    net: enetc: Fix probing error message typo for the ENETCv4 PF driver

Bernard Metzler <bernard.metzler@linux.dev>
    RDMA/siw: Always report immediate post SQ errors

Alessandro Zanni <alessandro.zanni87@gmail.com>
    iommu/selftest: prevent use of uninitialized variable

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Disallow dirty tracking if incoherent page walk

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    ASoC: qcom: sc8280xp: use sa8775p/ subdir for QCS9100 / QCS9075

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Fix inverted break condition in PHY initialization

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Assure reset occurs before DBI access

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Add missing 1ms delay after PWR reset assertion

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    usb: vhci-hcd: Prevent suspending virtually attached devices

Ranjan Kumar <ranjan.kumar@broadcom.com>
    scsi: mpt3sas: Fix crash in transport port remove by using ioc_info()

Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
    scsi: ufs: core: Fix data race in CPU latency PM QoS request handling

Eric Dumazet <edumazet@google.com>
    netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nfnetlink: reset nlh pointer during batch replay

Slavin Liu <slavin452@gmail.com>
    ipvs: Defer ip_vs_ftp unregister during netns cleanup

Vadim Fedorenko <vadim.fedorenko@linux.dev>
    net: ethtool: tsconfig: set command must provide a reply

Anthony Iliopoulos <ailiop@suse.com>
    NFSv4.1: fix backchannel max_resp_sz verification check

Lin Yujun <linyujun809@h-partners.com>
    coresight: Fix incorrect handling for return value of devm_kzalloc

Jie Gan <jie.gan@oss.qualcomm.com>
    coresight: tpda: fix the logic to setup the element size

Leo Yan <leo.yan@arm.com>
    coresight: trbe: Return NULL pointer for allocation failures

Leo Yan <leo.yan@arm.com>
    coresight: Avoid enable programming clock duplicately

Leo Yan <leo.yan@arm.com>
    coresight: Appropriately disable trace bus clocks

Leo Yan <leo.yan@arm.com>
    coresight: Appropriately disable programming clocks

Leo Yan <leo.yan@arm.com>
    coresight: etm4x: Support atclk

Leo Yan <leo.yan@arm.com>
    coresight: catu: Support atclk

Leo Yan <leo.yan@arm.com>
    coresight: tmc: Support atclk

Yuanfang Zhang <yuanfang.zhang@oss.qualcomm.com>
    coresight-etm4x: Conditionally access register TRCEXTINSELR

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight: fix indentation error in cscfg_remove_owned_csdev_configs()

Ivan Abramov <i.abramov@mt-integration.ru>
    dm vdo: return error on corrupted metadata in start_restoring_volume functions

Ryder Lee <ryder.lee@mediatek.com>
    wifi: cfg80211: fix width unit in cfg80211_radio_chandef_valid()

Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
    wifi: ath12k: Fix flush cache failure during RX queue update

Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
    wifi: ath12k: Refactor RX TID deletion handling into helper function

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: pas: Shutdown lite ADSP DTB on X1E

Stephan Gerhold <stephan.gerhold@linaro.org>
    remoteproc: qcom: q6v5: Avoid disabling handover IRQ twice

Nagarjuna Kristam <nkristam@nvidia.com>
    PCI: tegra194: Fix duplicate PLL disable in pex_ep_event_pex_rst_assert()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: avoid circular locking dependency in ser_state_run()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw89: fix leak in rtw89_core_send_nullfunc()

Chunyu Hu <chuhu@redhat.com>
    selftests/mm: fix va_high_addr_switch.sh failure on x86_64

Gui-Dong Han <hanguidong02@gmail.com>
    RDMA/rxe: Fix race in do_task() when draining

Dmitry Baryshkov <lumag@kernel.org>
    remoteproc: qcom_q6v5_mss: support loading MBN file on msm8974

Barnabás Czémán <barnabas.czeman@mainlining.org>
    rpmsg: qcom_smd: Fix fallback to qcom,ipc parse

Hari Chandrakanthan <quic_haric@quicinc.com>
    wifi: ath12k: Fix peer lookup in ath12k_dp_mon_rx_deliver_msdu()

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs

Dan Moulding <dan@danm.net>
    crypto: comp - Use same definition of context alloc and free ops

Zilin Guan <zilin@seu.edu.cn>
    vfio/pds: replace bitmap_free with vfree

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from,to}_user for M7

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_to_user for Niagara 4

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from_to}_user for Niagara

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC III

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    sparc: fix accurate exception reporting in copy_{from_to}_user for UltraSPARC

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Intel: sof_sdw: Prevent jump to NULL add_sidecar callback

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: mac80211: fix Rx packet handling when pubsta information is not available

Vineeth Pillai (Google) <vineeth@bitbyteword.org>
    iommu/vt-d: debugfs: Fix legacy mode page table dump logic

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath10k: avoid unnecessary wait for service ready message

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: fix wrong logging ID used for CE

Sriram R <quic_srirrama@quicinc.com>
    wifi: ath12k: Add fallback for invalid channel number in PHY metadata

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix the fetching of combined rssi

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix HAL_PHYRX_COMMON_USER_INFO handling in monitor mode

Kang Yang <kang.yang@oss.qualcomm.com>
    wifi: ath12k: fix signal in radiotap for WCN7850

Baochen Qiang <quic_bqiang@quicinc.com>
    wifi: ath12k: fix overflow warning on num_pwr_levels

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: ath12k: initialize eirp_power before use

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: SOF: ipc4-pcm: Fix incorrect comparison with number of tdm_slots

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram

Vlad Dumitrescu <vdumitrescu@nvidia.com>
    IB/sa: Fix sa_local_svc_timeout_ms read race

Parav Pandit <parav@nvidia.com>
    RDMA/core: Resolve MAC of next-hop device without ARP support

Michal Pecio <michal.pecio@gmail.com>
    Revert "usb: xhci: Avoid Stop Endpoint retry loop if the endpoint seems Running"

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Use __sk_dst_get() and dst_dev_rcu() in mptcp_active_enable().

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Call dst_release() in mptcp_active_enable().

Kuniyuki Iwashima <kuniyu@google.com>
    tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in smc_vlan_by_tcpsk().

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in smc_clc_prfx_match().

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Use __sk_dst_get() and dst_dev_rcu() in in smc_clc_prfx_set().

Kuniyuki Iwashima <kuniyu@google.com>
    smc: Fix use-after-free in __pnet_find_base_ndev().

wangzijie <wangzijie1@honor.com>
    f2fs: fix zero-sized extent for precache extents

Benjamin Tissoires <bentiss@kernel.org>
    HID: hidraw: tighten ioctl command parsing

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: Fix incorrect sign of error code in qla_nvme_xmt_ls_rsp()

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: Fix incorrect sign of error code in START_SP_W_RETRIES()

Qianfeng Rong <rongqianfeng@vivo.com>
    scsi: qla2xxx: edif: Fix incorrect sign of error code

Colin Ian King <colin.i.king@gmail.com>
    ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    ALSA: pcm: Disable bottom softirqs as part of spin_lock_irq() on PREEMPT_RT

Fangyu Yu <fangyu.yu@linux.alibaba.com>
    RISC-V: KVM: Write hgatp register with valid mode bits

Chao Yu <chao@kernel.org>
    f2fs: fix to mitigate overhead of f2fs_zero_post_eof_page()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid migrating empty section

Chao Yu <chao@kernel.org>
    f2fs: fix to truncate first page in error path of f2fs_truncate()

Chao Yu <chao@kernel.org>
    f2fs: fix to update map->m_next_extent correctly in f2fs_map_blocks()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Fix allocating extra dwords for rings (v2)

Zqiang <qiang.zhang@linux.dev>
    srcu/tiny: Remove preempt_disable/enable() in srcu_gp_start_if_needed()

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: hda-sdw-bpt: set persistent_buffer false

Felix Fietkau <nbd@nbd.name>
    wifi: mt76: mt7996: remove redundant per-phy mac80211 calls during restart

Zhi-Jun You <hujy652@gmail.com>
    wifi: mt76: mt7915: fix mt7981 pre-calibration

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Convert mt7996_wed_rro_addr to LE

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix RX packets configuration for primary WED device

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix tx-queues initialization for second phy on mt7996

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Check phy before init msta_link in mt7996_mac_sta_add_links()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Use proper link_id in link_sta_rc_update callback

Abdun Nihaal <abdun.nihaal@gmail.com>
    wifi: mt76: fix potential memory leak in mt76_wmac_probe()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix mt7996_mcu_bss_mld_tlv routine

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix mt7996_mcu_sta_ba wcid configuration

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/cm: Rate limit destroy CM ID timeout error message

Donet Tom <donettom@linux.ibm.com>
    drivers/base/node: handle error properly in register_one_node()

Niklas Cassel <cassel@kernel.org>
    PCI: endpoint: pci-epf-test: Fix doorbell test support

Christophe Leroy <christophe.leroy@csgroup.eu>
    watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog

Guenter Roeck <linux@roeck-us.net>
    watchdog: intel_oc_wdt: Do not try to write into const memory

Jiri Kosina <jikos@kernel.org>
    HID: steelseries: Fix STEELSERIES_SRWS1 handling in steelseries_remove()

Zhang Tengfei <zhtfdev@gmail.com>
    ipvs: Use READ_ONCE/WRITE_ONCE for ipvs->enable

Zhen Ni <zhen.ni@easystack.cn>
    netfilter: ipset: Remove unused htable_bits in macro ahash_region

Edward Srouji <edwards@nvidia.com>
    RDMA/mlx5: Fix page size bitmap calculation for KSM mode

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    tools: ynl: fix undefined variable name

Kuan-Wei Chiu <visitorckw@gmail.com>
    mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal

Hans de Goede <hansg@kernel.org>
    iio: consumers: Fix offset handling in iio_convert_raw_to_processed()

Hans de Goede <hansg@kernel.org>
    iio: consumers: Fix handling of negative channel scale in iio_convert_raw_to_processed()

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    fs/ntfs3: reject index allocation if $BITMAP is empty but blocks exist

Vitaly Grigoryev <Vitaly.Grigoryev@kaspersky.com>
    fs: ntfs3: Fix integer overflow in run_unpack()

Sarika Sharma <quic_sarishar@quicinc.com>
    wifi: mac80211: fix reporting of all valid links in sta_set_sinfo()

Qianfeng Rong <rongqianfeng@vivo.com>
    drm/msm/dpu: fix incorrect type for ret

Akhil P Oommen <akhilpo@oss.qualcomm.com>
    drm/msm: Fix bootup splat with separate_gpu_drm modparam

Eric Dumazet <edumazet@google.com>
    ipv6: snmp: do not track per idev ICMP6_MIB_RATELIMITHOST

Eric Dumazet <edumazet@google.com>
    ipv6: snmp: do not use SNMP_MIB_SENTINEL anymore

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5651: Fix invalid quirk input mapping

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcr_rt5640: Fix invalid quirk input mapping

Takashi Iwai <tiwai@suse.de>
    ASoC: Intel: bytcht_es8316: Fix invalid quirk input mapping

Alexander Lobakin <aleksander.lobakin@intel.com>
    idpf: fix Rx descriptor ready check barrier in splitq

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm: stop supporting no-IOMMU configuration

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/mdp4: stop supporting no-IOMMU configuration

Liao Yuanhong <liaoyuanhong@vivo.com>
    wifi: iwlwifi: Remove redundant header files

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix missing VM_BIND offset/range validation

Rob Clark <robin.clark@oss.qualcomm.com>
    drm/msm: Fix obj leak in VM_BIND error path

Wang Liang <wangliang74@huawei.com>
    pps: fix warning in pps_register_cdev when register device fail

Colin Ian King <colin.i.king@gmail.com>
    misc: genwqe: Fix incorrect cmd field being reported in error

Seppo Takalo <seppo.takalo@nordicsemi.no>
    tty: n_gsm: Don't block input queue by waiting MSC

William Wu <william.wu@rock-chips.com>
    usb: gadget: configfs: Correctly set use_os_string at bind

Xichao Zhao <zhao.xichao@vivo.com>
    usb: phy: twl6030: Fix incorrect type for ret

Qianfeng Rong <rongqianfeng@vivo.com>
    drm/amdkfd: Fix error code sign for EINVAL in svm_ioctl()

Anderson Nascimento <anderson@allelesecurity.com>
    fanotify: Validate the return value of mnt_ns_from_dentry() before dereferencing

Eric Dumazet <edumazet@google.com>
    tcp: fix __tcp_close() to only send RST when required

Ziyue Zhang <ziyue.zhang@oss.qualcomm.com>
    PCI: qcom: Add equalization settings for 8.0 GT/s and 32.0 GT/s

Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
    wifi: mac80211: consider links for validating SCAN_FLAG_AP in scan request during MLO

Alok Tiwari <alok.a.tiwari@oracle.com>
    PCI: tegra: Fix devm_kcalloc() argument order for port->phys allocation

Jun Nie <jun.nie@linaro.org>
    drm/msm: Do not validate SSPP when it is not ready

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix 43752 SDIO FWVID incorrectly labelled as Cypress (CYW)

Stefan Kerkmann <s.kerkmann@pengutronix.de>
    wifi: mwifiex: send world regulatory domain to driver

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mac80211: Make CONNECTION_MONITOR optional for MLO sta

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable SCLK switching on Oland with high pixel clocks (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable MCLK switching with non-DC at 120 Hz+ (v2)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Treat zero vblank time as too short in si_dpm (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Adjust si_upload_smc_data register programming (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Fix si_upload_smc_data (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amd/pm: Disable ULV even if unsupported (v3)

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Power up UVD 3 for FW validation (v2)

Yuanfang Zhang <quic_yuanfang@quicinc.com>
    coresight: Only register perf symlink for sinks with alloc_buffer

James Clark <james.clark@linaro.org>
    coresight: Fix missing include for FIELD_GET

James Clark <james.clark@linaro.org>
    coresight: trbe: Add ISB after TRBLIMITR write

Nathan Lynch <nathan.lynch@amd.com>
    dmaengine: Fix dma_async_tx_descriptor->tx_submit documentation

Eric Dumazet <edumazet@google.com>
    inet: ping: check sock_net() in ping_get_port() and ping_lookup()

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - request reserved interrupt for virtual function

Zhushuai Yin <yinzhushuai@huawei.com>
    crypto: hisilicon/qm - check whether the input function and PF are on the same device

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon - check the sva module status while enabling or disabling address prefetch

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon - re-enable address prefetch after device resuming

Chenghai Huang <huangchenghai2@huawei.com>
    crypto: hisilicon/zip - remove unnecessary validation for high-performance mode configurations

Eric Dumazet <edumazet@google.com>
    ipv4: start using dst_dev_rcu()

Eric Dumazet <edumazet@google.com>
    tcp_metrics: use dst_dev_net_rcu()

Eric Dumazet <edumazet@google.com>
    net: use dst_dev_rcu() in sk_setup_caps()

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_output()

Eric Dumazet <edumazet@google.com>
    ipv6: use RCU in ip6_xmit()

Eric Dumazet <edumazet@google.com>
    ipv6: start using dst_dev_rcu()

Yue Haibing <yuehaibing@huawei.com>
    ipv6: mcast: Add ip6_mc_find_idev() helper

Eric Dumazet <edumazet@google.com>
    net: dst: introduce dst->dev_rcu

Geert Uytterhoeven <geert+renesas@glider.be>
    efi: Explain OVMF acronym in OVMF_DEBUG_LOG help text

Qianfeng Rong <rongqianfeng@vivo.com>
    accel/amdxdna: Use int instead of u32 to store error codes

Lijo Lazar <lijo.lazar@amd.com>
    drm/amdgpu: Check vcn state before profile switch

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/vcn: Hold pg_lock before vcn power off

Sathishkumar S <sathishkumar.sundararaju@amd.com>
    drm/amdgpu/vcn: Add regdump helper functions

Arnd Bergmann <arnd@arndb.de>
    media: st-delta: avoid excessive stack usage

Qianfeng Rong <rongqianfeng@vivo.com>
    ALSA: lx_core: use int type to store negative error codes

Dan Carpenter <dan.carpenter@linaro.org>
    HID: i2c-hid: Fix test in i2c_hid_core_register_panel_follower()

Nirmoy Das <nirmoyd@nvidia.com>
    PCI/ACPI: Fix pci_acpi_preserve_config() memory leak

Nipun Gupta <nipun.gupta@amd.com>
    cdx: don't select CONFIG_GENERIC_MSI_IRQ

Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
    PCI: qcom: Restrict port parsing only to PCIe bridge child nodes

Joanne Koong <joannelkoong@gmail.com>
    fuse: remove unneeded offset assignment when filling write pages

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    PCI: rcar-host: Pass proper IRQ domain to generic_handle_domain_irq()

Christian Marangi <ansuelsmth@gmail.com>
    net: phy: as21xxx: better handle PHY HW reset on soft-reboot

Christian Marangi <ansuelsmth@gmail.com>
    net: phy: introduce phy_id_compare_vendor() PHY ID helper

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Use led->brightness_set_blocking for PCI too

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Fix vport loopback forcing for MPV device

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Better estimate max_qp_wr to reflect WQE count

Pin-yen Lin <treapking@chromium.org>
    HID: i2c-hid: Make elan touch controllers power on after panel is enabled

Pin-yen Lin <treapking@chromium.org>
    drm/panel: Allow powering on panel follower after panel is enabled

Benjamin Mugnier <benjamin.mugnier@foss.st.com>
    media: i2c: vd55g1: Fix duster register address

Bingbu Cao <bingbu.cao@intel.com>
    media: staging/ipu7: cleanup the MMU correctly in IPU7 driver release

Bingbu Cao <bingbu.cao@intel.com>
    media: staging/ipu7: Don't set name for IPU7 PCI device

Bingbu Cao <bingbu.cao@intel.com>
    media: staging/ipu7: convert to use pci_alloc_irq_vectors() API

Zhang Shurong <zhang_shurong@foxmail.com>
    media: rj54n1cb0c: Fix memleak in rj54n1_probe()

Xaver Hugl <xaver.hugl@kde.org>
    drm: re-allow no-op changes on non-primary planes in async flips

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: octeontx2 - Call strscpy() with correct size argument

Val Packett <val@packett.cool>
    drm/dp: drm_edp_backlight_set_level: do not always send 3-byte commands

Chao Yu <chao@kernel.org>
    f2fs: fix to allow removing qf_name

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid NULL pointer dereference in f2fs_check_quota_consistency()

Chao Yu <chao@kernel.org>
    f2fs: fix to clear unusable_cap for checkpoint=enable

Thomas Fourier <fourier.thomas@gmail.com>
    scsi: myrs: Fix dma_alloc_coherent() error check

Kuniyuki Iwashima <kuniyu@google.com>
    mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Add helper function to get the local phy id

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Use dev_parent_is_expander() helper

Niklas Cassel <cassel@kernel.org>
    scsi: libsas: Add dev_parent_is_expander() helper

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod

Niklas Cassel <cassel@kernel.org>
    scsi: pm80xx: Restore support for expanders

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    fwctl/mlx5: Fix memory alloc/free in mlx5ctl_fw_rpc()

Jorge Marques <jorge.marques@analog.com>
    docs: iio: ad3552r: Fix malformed code-block directive

Arnd Bergmann <arnd@arndb.de>
    hwrng: nomadik - add ARM_AMBA dependency

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: keembay - Add missing check after sg_nents_for_len()

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Add NULL pointer checks in dc_stream cursor attribute functions

Liao Yuanhong <liaoyuanhong@vivo.com>
    drm/amd/display: Remove redundant semicolons

Dan Carpenter <dan.carpenter@linaro.org>
    serial: max310x: Add error checking in probe()

Dan Carpenter <dan.carpenter@linaro.org>
    misc: pci_endpoint_test: Fix array underflow in pci_endpoint_test_ioctl()

Geert Uytterhoeven <geert+renesas@glider.be>
    PCI/pwrctrl: Fix double cleanup on devm_add_action_or_reset() failure

Komal Bajaj <komal.bajaj@oss.qualcomm.com>
    usb: misc: qcom_eud: Access EUD_MODE_MANAGER2 through secure calls

Dan Carpenter <dan.carpenter@linaro.org>
    usb: host: max3421-hcd: Fix error pointer dereference in probe cleanup

Aradhya Bhatia <aradhya.bhatia@linux.dev>
    drm/bridge: cdns-dsi: Fix the _atomic_check()

Jonas Karlman <jonas@kwiboo.se>
    phy: rockchip: naneng-combphy: Enable U3 OTG port for RK3568

Jacopo Mondi <jacopo.mondi@ideasonboard.com>
    media: zoran: Remove zoran_fh structure

Jack Xiao <Jack.Xiao@amd.com>
    drm/amdgpu: fix incorrect vm flags to map bo

Jeongjun Park <aha310510@gmail.com>
    HID: steelseries: refactor probe() and remove()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtw88: Lock rtwdev->mutex before setting the LED

Chia-I Wu <olvaffe@gmail.com>
    drm/bridge: it6505: select REGMAP_I2C

Chao Yu <chao@kernel.org>
    f2fs: fix to zero data after EOF for compressed file correctly

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid overflow while left shift operation

Chao Yu <chao@kernel.org>
    f2fs: fix condition in __allow_reserved_blocks()

Brahmajit Das <listout@listout.xyz>
    drm/radeon/r600_cs: clean up of dead code in r600_cs

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: xgene-msi: Return negative -EINVAL in xgene_msi_handler_setup()

Dan Carpenter <dan.carpenter@linaro.org>
    PCI: endpoint: pci-ep-msi: Fix NULL vs IS_ERR() check in pci_epf_write_msi_msg()

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Fix vcn v4.0.3 poison irq call trace on sriov guest

Xiang Liu <xiang.liu@amd.com>
    drm/amdgpu: Fix jpeg v4.0.3 poison irq call trace on sriov guest

Arnd Bergmann <arnd@arndb.de>
    drm/amdgpu: fix link error for !PM_SLEEP

Brigham Campbell <me@brighamcampbell.com>
    drm/panel: novatek-nt35560: Fix invalid return value

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Reduce Stack Usage by moving 'audio_output' into 'stream_res' v4

Colin Ian King <colin.i.king@gmail.com>
    drm/vmwgfx: fix missing assignment to ts

Langyan Ye <yelangyan@huaqin.corp-partner.google.com>
    drm/panel-edp: Add 50ms disable delay for four panels

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/display: bridge-connector: correct CEC bridge pointers in drm_bridge_connector_init

Langyan Ye <yelangyan@huaqin.corp-partner.google.com>
    drm/panel-edp: Add disable to 100ms for MNB601LS1-4

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Fix a race in DRM_GPU_SCHED_STAT_NO_HANG test

Dzmitry Sankouski <dsankouski@gmail.com>
    mfd: max77705: Setup the core driver as an interrupt controller

Arnd Bergmann <arnd@arndb.de>
    i3c: fix big-endian FIFO transfers

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Enforce expected_attach_type for tailcall compatibility

D. Wythe <alibuda@linux.alibaba.com>
    libbpf: Fix error when st-prefix_ops and ops from differ btf

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    i2c: designware: Add disabling clocks when probe fails

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    i2c: designware: Fix clock issue when PM is disabled

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    i2c: spacemit: ensure SDA is released after bus reset

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    i2c: spacemit: check SDA instead of SCL after bus reset

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    i2c: spacemit: disable SDA glitch fix to avoid restart delay

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    i2c: spacemit: remove stop function to avoid bus error

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    i2c: spacemit: ensure bus release check runs when wait_bus_idle() fails

Leilk.Liu <leilk.liu@mediatek.com>
    i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    thermal/drivers/qcom/lmh: Add missing IRQ includes

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    thermal/drivers/qcom: Make LMH select QCOM_SCM

André Almeida <andrealmeid@igalia.com>
    tools/nolibc: add stdbool.h to nolibc includes

Vadim Pasternak <vadimp@nvidia.com>
    hwmon: (mlxreg-fan) Separate methods of fan setting coming from different subsystems

Qi Xi <xiqi2@huawei.com>
    once: fix race by moving DO_ONCE to separate section

Andrea Righi <arighi@nvidia.com>
    bpf: Mark kfuncs as __noclone

Arnd Bergmann <arnd@arndb.de>
    clocksource/drivers/tegra186: Avoid 64-bit division

Guenter Roeck <linux@roeck-us.net>
    clocksource/drivers/timer-tegra186: Avoid 64-bit divide operation

Jonas Gorski <jonas.gorski@gmail.com>
    spi: fix return code when spi device has too many chipselects

Zhouyi Zhou <zhouzhouyi@gmail.com>
    tools/nolibc: make time_t robust if __kernel_old_time_t is missing in host headers

Dzmitry Sankouski <dsankouski@gmail.com>
    power: supply: max77705_charger: rework interrupts

Dzmitry Sankouski <dsankouski@gmail.com>
    power: supply: max77705_charger: use regfields for config registers

Dzmitry Sankouski <dsankouski@gmail.com>
    power: supply: max77705_charger: refactoring: rename charger to chg

Dzmitry Sankouski <dsankouski@gmail.com>
    mfd: max77705: max77705_charger: move active discharge setting to mfd parent

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    smp: Fix up and expand the smp_call_function_many() kerneldoc

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: always install UAPI headers to the correct directory

Janne Grunau <j@jannau.net>
    arm64: dts: apple: Add ethernet0 alias for J375 template

Hector Martin <marcan@marcan.st>
    arm64: dts: apple: t600x: Add bluetooth device nodes

Hector Martin <marcan@marcan.st>
    arm64: dts: apple: t600x: Add missing WiFi properties

Hengqi Chen <hengqi.chen@gmail.com>
    bpf, arm64: Call bpf_jit_binary_pack_finalize() in bpf_jit_free()

Eduard Zingerman <eddyz87@gmail.com>
    bpf: dont report verifier bug for missing bpf_scc_visit on speculative path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    selftest/futex: Compile also with libnuma < 2.0.16

André Almeida <andrealmeid@igalia.com>
    selftest/futex: Make the error check more precise for futex_numa_mpol

Dan Carpenter <dan.carpenter@linaro.org>
    selftests/futex: Fix futex_wait() for 32bit ARM

Mikko Rapeli <mikko.rapeli@linaro.org>
    mmc: select REGMAP_MMIO with MMC_LOONGSON2

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Explicitly check accesses to bpf_sock_addr

Yu Kuai <yukuai3@huawei.com>
    blk-throttle: fix throtl_data leak during disk release

Yi Lai <yi1.lai@intel.com>
    selftests/kselftest_harness: Add harness-selftest.expected to TEST_FILES

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported

John Garry <john.g.garry@oracle.com>
    block: fix stacking of atomic writes when atomics are not supported

John Garry <john.g.garry@oracle.com>
    block: update validation of atomic writes boundary for stacked devices

Stanley Chu <stanley.chuys@gmail.com>
    i3c: master: svc: Recycle unused IBI slot

Stanley Chu <yschu@nuvoton.com>
    i3c: master: svc: Use manual response for IBI events

Martin George <martinus.gpy@gmail.com>
    nvme-tcp: send only permitted commands for secure concat

Daniel Wagner <wagi@kernel.org>
    nvmet-fcloop: call done callback even when remote port is gone

Daniel Wagner <wagi@kernel.org>
    nvmet-fc: move lsop put work to nvmet_fc_ls_req_op

Martin George <martinus.gpy@gmail.com>
    nvme-auth: update bi_directional flag

Hengqi Chen <hengqi.chen@gmail.com>
    riscv, bpf: Sign extend struct ops return values properly

Dmitry Antipov <dmantipov@yandex.ru>
    ACPICA: Fix largest possible resource descriptor index

Ahmed Salem <x0rw3ll@gmail.com>
    ACPICA: Apply ACPI_NONSTRING

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Fix corner case in clock divisor calculation

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Fix various off-by-one errors in duty-cycle calculation

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Make code comment in .free() more useful

Uwe Kleine-König <u.kleine-koenig@baylibre.com>
    pwm: tiehrpwm: Don't drop runtime PM reference in .free()

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: t527: orangepi-4a: hook up external 32k crystal

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: t527: avaota-a1: hook up external 32k crystal

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: a527: cubie-a5e: Drop external 32.768 KHz crystal

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: a527: cubie-a5e: Add LEDs

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt8395-kontron-i1200: Fix MT6360 regulator nodes

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt7986a: Fix PCI-Express T-PHY node address

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6795-xperia-m5: Fix mmc0 latch-ck value

Bean Huo <beanhuo@micron.com>
    mmc: core: Fix variable shadowing in mmc_route_rpmb_frames()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6331: Fix pmic, regulators, rtc, keys node names

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: r9a09g047e57-smarc: Fix gpio key's pin control node

Akashdeep Kaur <a-kaur@ti.com>
    arm64: dts: ti: k3-pinctrl: Fix the bug in existing macros

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8186-tentacruel: Fix touchscreen model

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mediatek: mt8188: Change efuse fallback compatible to mt8186

Beleswar Padhi <b-padhi@ti.com>
    Revert "arm64: dts: ti: k3-j721e-beagleboneai64: Fix reversed C6x carveout locations"

Beleswar Padhi <b-padhi@ti.com>
    Revert "arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations"

Beleswar Padhi <b-padhi@ti.com>
    arm64: dts: ti: k3: Rename rproc reserved-mem nodes to 'memory@addr'

Beleswar Padhi <b-padhi@ti.com>
    arm64: dts: ti: k3-j742s2-mcu-wakeup: Override firmware-name for MCU R5F cores

Sebastian Reichel <sebastian.reichel@collabora.com>
    arm64: dts: rockchip: Fix network on rk3576 evb1 board

Alexey Charkov <alchark@gmail.com>
    arm64: dts: rockchip: Add WiFi on rk3576-evb1-v10

Alexey Charkov <alchark@gmail.com>
    arm64: dts: rockchip: Add RTC on rk3576-evb1-v10

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: t527: avaota-a1: Add ethernet PHY reset setting

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: allwinner: a527: cubie-a5e: Add ethernet PHY reset setting

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix potential deadlock while nr_requests grown

Yu Kuai <yukuai3@huawei.com>
    blk-mq-sched: add new parameter nr_requests in blk_mq_alloc_sched_tags()

Yu Kuai <yukuai3@huawei.com>
    blk-mq: split bitmap grow and resize case in blk_mq_update_nr_requests()

Yu Kuai <yukuai3@huawei.com>
    blk-mq: cleanup shared tags case in blk_mq_update_nr_requests()

Yu Kuai <yukuai3@huawei.com>
    blk-mq: convert to serialize updating nr_requests with update_nr_hwq_lock

Yu Kuai <yukuai3@huawei.com>
    blk-mq: check invalid nr_requests in queue_requests_store()

Yu Kuai <yukuai3@huawei.com>
    blk-mq: remove useless checkings in blk_mq_update_nr_requests()

Yu Kuai <yukuai3@huawei.com>
    block: fix ordering of recursive split IO

Yu Kuai <yukuai3@huawei.com>
    block: skip unnecessary checks for split bio

Yu Kuai <yukuai3@huawei.com>
    block: factor out a helper bio_submit_split_bioset()

Yu Kuai <yukuai3@huawei.com>
    block: initialize bio issue time in blk_mq_submit_bio()

Yu Kuai <yukuai3@huawei.com>
    block: cleanup bio_issue

Johan Hovold <johan@kernel.org>
    cpuidle: qcom-spm: fix device and OF node leaks at probe

Johan Hovold <johan@kernel.org>
    soc: mediatek: mtk-svs: fix device leaks on mt8192 probe failure

Johan Hovold <johan@kernel.org>
    soc: mediatek: mtk-svs: fix device leaks on mt8183 probe failure

Xianwei Zhao <xianwei.zhao@amlogic.com>
    dts: arm: amlogic: fix pwm node for c3

Johan Hovold <johan@kernel.org>
    firmware: firmware: meson-sm: fix compile-test default

Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
    PM / devfreq: rockchip-dfi: double count on RK3588

Eric Dumazet <edumazet@google.com>
    nbd: restrict sockets to TCP and UDP

Rob Herring (Arm) <robh@kernel.org>
    arm64: dts: mediatek: mt8183: Fix out of range pull values

Guoqing Jiang <guoqing.jiang@canonical.com>
    arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie0

Bibo Mao <maobibo@loongson.cn>
    tick: Do not set device to detached state in tick_shutdown()

Dan Carpenter <dan.carpenter@linaro.org>
    irqchip/gic-v5: Fix error handling in gicv5_its_irq_domain_alloc()

Dan Carpenter <dan.carpenter@linaro.org>
    irqchip/gic-v5: Fix loop in gicv5_its_create_itt_two_level() cleanup path

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: vDSO: vdso_test_abi: Correctly skip whole test with missing vDSO

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    selftests: vDSO: Fix -Wunitialized in powerpc VDSO_CALL() wrapper

Han Guangjiang <hanguangjiang@lixiang.com>
    blk-throttle: fix access race during throttle policy activation

Genjian Zhang <zhanggenjian@kylinos.cn>
    null_blk: Fix the description of the cache_size module argument

Yulin Lu <luyulin@eswincomputing.com>
    pinctrl: eswin: Fix regulator error check and Kconfig dependency

Qianfeng Rong <rongqianfeng@vivo.com>
    pinctrl: renesas: Use int type to store negative error codes

Eugene Shalygin <eugene.shalygin@gmail.com>
    hwmon: (asus-ec-sensors) Narrow lock for X870E-CREATOR WIFI

Andy Yan <andyshrk@163.com>
    power: supply: cw2015: Fix a alignment coding style issue

Dan Carpenter <dan.carpenter@linaro.org>
    PM / devfreq: mtk-cci: Fix potential error pointer dereference in probe()

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: omap: am335x-cm-t335: Remove unused mcasp num-serializer property

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: ti: omap: omap3-devkit8000-lcd: Fix ti,keep-vref-on property to use correct boolean syntax in DTS

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: ti: omap: am335x-baltos: Fix ti,en-ck32k-xtal property in DTS to use correct boolean syntax

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    vdso: Add struct __kernel_old_timeval forward declaration to gettime.h

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix elevator depth_updated method

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: sleep: core: Clear power.must_resume in noirq suspend error path

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    vdso/datastore: Gate time data behind CONFIG_GENERIC_GETTIMEOFDAY

Ricardo B. Marlière <rbm@suse.com>
    selftests/bpf: Fix count write in testapp_xdp_metadata_copy()

Brian Norris <briannorris@chromium.org>
    genirq/test: Ensure CPU 1 is online for hotplug test

Brian Norris <briannorris@chromium.org>
    genirq/test: Drop CONFIG_GENERIC_IRQ_MIGRATION assumptions

Brian Norris <briannorris@chromium.org>
    genirq/test: Depend on SPARSE_IRQ

Brian Norris <briannorris@chromium.org>
    genirq/test: Select IRQ_DOMAIN

David Gow <davidgow@google.com>
    genirq/test: Fix depth tests on architectures with NOREQUEST by default.

Rob Herring (Arm) <robh@kernel.org>
    dt-bindings: vendor-prefixes: Add undocumented vendor prefixes

Jihed Chaibi <jihed.chaibi.dev@gmail.com>
    ARM: dts: stm32: stm32mp151c-plyaqm: Use correct dai-format property

Qianfeng Rong <rongqianfeng@vivo.com>
    block: use int to store blk_stack_limits() return value

Inochi Amaoto <inochiama@gmail.com>
    PCI/MSI: Check MSI_FLAG_PCI_MSI_MASK_PARENT in cond_[startup|shutdown]_parent()

Andrei Lalaev <andrei.lalaev@anton-paar.com>
    leds: leds-lp55xx: Use correct address for memory programming

Benjamin Berg <benjamin.berg@intel.com>
    selftests/nolibc: fix EXPECT_NZ macro

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc: avoid error in dup2() if old fd equals new fd

Waiman Long <longman@redhat.com>
    selftests/futex: Fix some futex_numa_mpol subtests

Qianfeng Rong <rongqianfeng@vivo.com>
    regulator: scmi: Use int type to store negative error codes

Janne Grunau <j@jannau.net>
    arm64: dts: apple: t8103-j457: Fix PCIe ethernet iommu-map

Nicolas Ferre <nicolas.ferre@microchip.com>
    ARM: at91: pm: fix MCKx restore routine

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    selftests/futex: Remove the -g parameter from futex_priv_hash

Li Nan <linan122@huawei.com>
    blk-mq: check kobject state_in_sysfs before deleting in blk_mq_unregister_hctx

Da Xue <da@libre.computer>
    pinctrl: meson-gxl: add missing i2c_d pinmux

Sneh Mankad <sneh.mankad@oss.qualcomm.com>
    soc: qcom: rpmh-rsc: Unconditionally clear _TRIGGER bit for TCS

Vlastimil Babka <vbabka@suse.cz>
    scripts/misc-check: update export checks for EXPORT_SYMBOL_FOR_MODULES()

Inochi Amaoto <inochiama@gmail.com>
    irqchip/sg2042-msi: Fix broken affinity setting

Inochi Amaoto <inochiama@gmail.com>
    PCI/MSI: Add startup/shutdown for per device domains

Inochi Amaoto <inochiama@gmail.com>
    genirq: Add irq_chip_(startup/shutdown)_parent()

Huisong Li <lihuisong@huawei.com>
    ACPI: processor: idle: Fix memory leak when register cpuidle device failed

Tao Chen <chen.dylane@linux.dev>
    bpf: Remove preempt_disable in bpf_try_get_buffers

Joy Zou <joy.zou@nxp.com>
    arm64: dts: imx95: Correct the lpuart7 and lpuart8 srcid

Frieder Schrempf <frieder.schrempf@kontron.de>
    arm64: dts: imx93-kontron: Fix USB port assignment

Annette Kobou <annette.kobou@kontron.de>
    arm64: dts: imx93-kontron: Fix GPIO for panel regulator

Junnan Wu <junnan01.wu@samsung.com>
    firmware: arm_scmi: Mark VirtIO ready before registering scmi_virtio_driver

Mykyta Yatsenko <yatsenko@meta.com>
    libbpf: Export bpf_object__prepare symbol

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: sparrow-hawk: Set VDDQ18_25_AVB voltage on EVTB1

Marek Vasut <marek.vasut+renesas@mailbox.org>
    arm64: dts: renesas: sparrow-hawk: Invert microSD voltage selector on EVTB1

Florian Fainelli <florian.fainelli@broadcom.com>
    cpufreq: scmi: Account for malformed DT in scmi_dev_used_by_cpus()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Write back tail call counter for BPF_PSEUDO_CALL

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/bpf: Do not write tail call counter into helper and kfunc frames

Fenglin Wu <fenglin.wu@oss.qualcomm.com>
    leds: flash: leds-qcom-flash: Update torch current clamp setting

Len Bao <len.bao@gmx.us>
    leds: max77705: Function return instead of variable assignment

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: renesas: porter: Fix CAN pin group

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    tools/nolibc: fix error return value of clock_nanosleep()

Yureka Lilian <yuka@yuka.dev>
    libbpf: Fix reuse of DEVMAP

Tao Chen <chen.dylane@linux.dev>
    bpf: Remove migrate_disable in kprobe_multi_link_prog_run

Matt Bobrowski <mattbobrowski@google.com>
    bpf/selftests: Fix test_tcpnotify_user

Baptiste Lepers <baptiste.lepers@gmail.com>
    rust: cpumask: Mark CpumaskVar as transparent

Amery Hung <ameryhung@gmail.com>
    selftests/bpf: Copy test_kmods when installing selftest

Geert Uytterhoeven <geert+renesas@glider.be>
    regmap: Remove superfluous check for !config in __regmap_init()

Paul Chaignon <paul.chaignon@gmail.com>
    bpf: Tidy verifier bug message

Biju Das <biju.das.jz@bp.renesas.com>
    arm64: dts: renesas: rzg2lc-smarc: Disable CAN-FD channel0

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    pinctrl: renesas: rzg2l: Fix invalid unsigned return in rzg3s_oen_read()

Qu Wenruo <wqu@suse.com>
    btrfs: fix symbolic link reading when bs > ps

Qu Wenruo <wqu@suse.com>
    btrfs: return any hit error from extent_writepage_io()

Chen Ridong <chenridong@huawei.com>
    cpuset: fix failure to enable isolated partition when containing isolcpus

Randy Dunlap <rdunlap@infradead.org>
    lsm: CONFIG_LSM can depend on CONFIG_SECURITY

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Get rid of sched_domains_curr_level hack for tl->cpumask()

Michal Koutný <mkoutny@suse.com>
    selftests: cgroup: Make test_pids backwards compatible

Uros Bizjak <ubizjak@gmail.com>
    x86/vdso: Fix output operand size of RDPID

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Fix IA32_PMC_x_CFG_B MSRs access error

Dapeng Mi <dapeng1.mi@linux.intel.com>
    perf/x86/intel: Use early_initcall() to hook bts_init()

Qiuxu Zhuo <qiuxu.zhuo@intel.com>
    EDAC/i10nm: Skip DIMM enumeration on a disabled memory controller

Stefan Metzmacher <metze@samba.org>
    smb: server: fix IRD/ORD negotiation with the client

Stefan Metzmacher <metze@samba.org>
    smb: client: fix sending the iwrap custom IRD/ORD negotiation messages

Gao Xiang <xiang@kernel.org>
    erofs: avoid reading more for fragment maps

Leo Yan <leo.yan@arm.com>
    perf: arm_spe: Prevent overflow in PERF_IDX2OFF()

Leo Yan <leo.yan@arm.com>
    coresight: trbe: Prevent overflow in PERF_IDX2OFF()

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    raid6: riscv: Clean up unused header file inclusion

Jeremy Linton <jeremy.linton@arm.com>
    uprobes: uprobe_warn should use passed task

Joe Lawrence <joe.lawrence@redhat.com>
    powerpc64/modules: correctly iterate over stubs in setup_ftrace_ool_stubs

Joe Lawrence <joe.lawrence@redhat.com>
    powerpc/ftrace: ensure ftrace record ops are always set for NOPs

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/603: Really copy kernel PGD entries into all PGDIRs

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Remove left-over instruction and comments in DataStoreTLBMiss handler

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Add proper lockspace locking

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: do_xmote cleanup

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Remove duplicate check in do_xmote

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix LM_FLAG_TRY* logic in add_to_queue

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Further sanitize lock_dlm.c

Colin Ian King <colin.i.king@gmail.com>
    gfs2: Remove space before newline

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix GLF_INVALIDATE_IN_PROGRESS flag clearing in do_xmote

Kang Chen <k.chen@smail.nju.edu.cn>
    hfsplus: fix slab-out-of-bounds read in hfsplus_uni2asc()

Thomas Weißschuh <linux@weissschuh.net>
    kselftest/arm64/gcs: Correctly check return value when disabling GCS

Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
    selftests: arm64: Fix -Waddress warning in tpidr2 test

Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
    selftests: arm64: Check fread return value in exec_target

Kienan Stewart <kstewart@efficios.com>
    kbuild: Add missing $(objtree) prefix to powerpc crtsavres.o artifact

Johannes Nixdorf <johannes@nixdorf.dev>
    seccomp: Fix a race with WAIT_KILLABLE_RECV if the tracer replies too fast

Linus Torvalds <torvalds@linux-foundation.org>
    Fix CC_HAS_ASM_GOTO_OUTPUT on non-x86 architectures

Christian Göttsche <cgzones@googlemail.com>
    pid: use ns_capable_noaudit() when determining net sysctl permissions

Geert Uytterhoeven <geert+renesas@glider.be>
    init: INITRAMFS_PRESERVE_MTIME should depend on BLK_DEV_INITRD

Jeff Layton <jlayton@kernel.org>
    filelock: add FL_RECLAIM to show_fl_flags() macro

Simon Schuster <schuster.simon@siemens-energy.com>
    arch: copy_thread: pass clone_flags as u64


-------------

Diffstat:

 .../devicetree/bindings/vendor-prefixes.yaml       |  50 ++++
 Documentation/iio/ad3552r.rst                      |   3 +-
 Documentation/trace/histogram-design.rst           |   4 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/process.c                        |   2 +-
 arch/arc/kernel/process.c                          |   2 +-
 arch/arm/boot/dts/renesas/r8a7791-porter.dts       |   2 +-
 arch/arm/boot/dts/st/stm32mp151c-plyaqm.dts        |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi       |   2 +-
 arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts       |   2 -
 .../dts/ti/omap/omap3-devkit8000-lcd-common.dtsi   |   2 +-
 arch/arm/kernel/process.c                          |   2 +-
 arch/arm/mach-at91/pm_suspend.S                    |   4 +-
 .../boot/dts/allwinner/sun55i-a527-cubie-a5e.dts   |  25 +-
 .../boot/dts/allwinner/sun55i-t527-avaota-a1.dts   |  11 +
 .../boot/dts/allwinner/sun55i-t527-orangepi-4a.dts |   8 +
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi        |   2 +-
 arch/arm64/boot/dts/apple/t6000-j314s.dts          |   8 +
 arch/arm64/boot/dts/apple/t6000-j316s.dts          |   8 +
 arch/arm64/boot/dts/apple/t6001-j314c.dts          |   8 +
 arch/arm64/boot/dts/apple/t6001-j316c.dts          |   8 +
 arch/arm64/boot/dts/apple/t6001-j375c.dts          |   8 +
 arch/arm64/boot/dts/apple/t6002-j375d.dts          |   8 +
 arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi     |  10 +
 arch/arm64/boot/dts/apple/t600x-j375.dtsi          |  11 +
 arch/arm64/boot/dts/apple/t8103-j457.dts           |  12 +-
 .../boot/dts/freescale/imx93-kontron-bl-osm-s.dts  |  32 ++-
 arch/arm64/boot/dts/freescale/imx95.dtsi           |   4 +-
 arch/arm64/boot/dts/mediatek/mt6331.dtsi           |  10 +-
 .../boot/dts/mediatek/mt6795-sony-xperia-m5.dts    |   2 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |  12 +-
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi     |  14 +-
 arch/arm64/boot/dts/mediatek/mt8183-pumpkin.dts    |  14 +-
 .../boot/dts/mediatek/mt8186-corsola-krabby.dtsi   |   8 +-
 .../mt8186-corsola-tentacruel-sku262144.dts        |   4 +
 arch/arm64/boot/dts/mediatek/mt8188.dtsi           |   2 +-
 arch/arm64/boot/dts/mediatek/mt8195.dtsi           |   3 -
 .../dts/mediatek/mt8395-kontron-3-5-sbc-i1200.dts  |  16 +-
 arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts    |   2 +-
 arch/arm64/boot/dts/qcom/qcm2290.dtsi              |   1 +
 .../boot/dts/renesas/r8a779g3-sparrow-hawk.dts     |   6 +-
 arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts |   6 +-
 arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi      |   5 +-
 arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts   | 118 ++++++++-
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi    |  10 +-
 arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts   |   6 +-
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |   2 +-
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts     |   2 +-
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi   |  12 +-
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts            |  12 +-
 arch/arm64/boot/dts/ti/k3-am62d2-evm.dts           |  14 +-
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi        |   2 +-
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts            |   8 +-
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |   8 +-
 arch/arm64/boot/dts/ti/k3-am64-phycore-som.dtsi    |  22 +-
 arch/arm64/boot/dts/ti/k3-am642-evm.dts            |  22 +-
 arch/arm64/boot/dts/ti/k3-am642-sk.dts             |  22 +-
 arch/arm64/boot/dts/ti/k3-am642-sr-som.dtsi        |  16 +-
 arch/arm64/boot/dts/ti/k3-am642-tqma64xxl.dtsi     |  18 +-
 arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi |  10 +-
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts     |  10 +-
 arch/arm64/boot/dts/ti/k3-am67a-beagley-ai.dts     |  22 +-
 arch/arm64/boot/dts/ti/k3-am68-phycore-som.dtsi    |  34 +--
 arch/arm64/boot/dts/ti/k3-am68-sk-som.dtsi         |  34 +--
 arch/arm64/boot/dts/ti/k3-am69-sk.dts              |  48 ++--
 arch/arm64/boot/dts/ti/k3-j7200-som-p0.dtsi        |  18 +-
 arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts |  40 +--
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts             |  40 +--
 arch/arm64/boot/dts/ti/k3-j721e-som-p0.dtsi        |  38 +--
 arch/arm64/boot/dts/ti/k3-j721s2-som-p0.dtsi       |  34 +--
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts            |  22 +-
 arch/arm64/boot/dts/ti/k3-j742s2-mcu-wakeup.dtsi   |  17 ++
 arch/arm64/boot/dts/ti/k3-j742s2.dtsi              |   1 +
 arch/arm64/boot/dts/ti/k3-j784s4-evm.dts           |   4 +-
 .../boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi   |  44 ++--
 arch/arm64/boot/dts/ti/k3-pinctrl.h                |   4 +-
 arch/arm64/kernel/process.c                        |   2 +-
 arch/arm64/net/bpf_jit_comp.c                      |   3 +-
 arch/csky/kernel/process.c                         |   2 +-
 arch/hexagon/kernel/process.c                      |   2 +-
 arch/loongarch/kernel/process.c                    |   2 +-
 arch/loongarch/kernel/relocate.c                   |   4 +
 arch/loongarch/net/bpf_jit.c                       |  80 ++++--
 arch/m68k/kernel/process.c                         |   2 +-
 arch/microblaze/kernel/process.c                   |   2 +-
 arch/mips/kernel/process.c                         |   2 +-
 arch/nios2/kernel/process.c                        |   2 +-
 arch/openrisc/kernel/process.c                     |   2 +-
 arch/parisc/kernel/process.c                       |   2 +-
 arch/powerpc/Kconfig                               |   4 +
 arch/powerpc/Makefile                              |   2 +-
 arch/powerpc/include/asm/book3s/32/pgalloc.h       |  10 +-
 arch/powerpc/include/asm/nohash/pgalloc.h          |   2 +-
 arch/powerpc/include/asm/topology.h                |   2 +
 arch/powerpc/kernel/head_8xx.S                     |   9 +-
 arch/powerpc/kernel/module_64.c                    |   2 +-
 arch/powerpc/kernel/process.c                      |   2 +-
 arch/powerpc/kernel/smp.c                          |  27 +-
 arch/powerpc/kernel/trace/ftrace.c                 |  10 +-
 arch/riscv/kernel/process.c                        |   2 +-
 arch/riscv/kvm/vmid.c                              |   3 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  42 +++-
 arch/s390/kernel/process.c                         |   2 +-
 arch/s390/kernel/topology.c                        |  20 +-
 arch/s390/net/bpf_jit_comp.c                       |  42 +++-
 arch/sh/kernel/process_32.c                        |   2 +-
 arch/sparc/kernel/process_32.c                     |   2 +-
 arch/sparc/kernel/process_64.c                     |   2 +-
 arch/sparc/lib/M7memcpy.S                          |  20 +-
 arch/sparc/lib/Memcpy_utils.S                      |   9 +
 arch/sparc/lib/NG4memcpy.S                         |   2 +-
 arch/sparc/lib/NGmemcpy.S                          |  29 ++-
 arch/sparc/lib/U1memcpy.S                          |  19 +-
 arch/sparc/lib/U3memcpy.S                          |   2 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/x86/events/intel/bts.c                        |   2 +-
 arch/x86/events/intel/core.c                       |   3 +-
 arch/x86/include/asm/fpu/sched.h                   |   2 +-
 arch/x86/include/asm/segment.h                     |   8 +-
 arch/x86/include/asm/shstk.h                       |   4 +-
 arch/x86/kernel/fpu/core.c                         |   2 +-
 arch/x86/kernel/process.c                          |   2 +-
 arch/x86/kernel/shstk.c                            |   2 +-
 arch/x86/kernel/smpboot.c                          |   8 +-
 arch/x86/kvm/svm/svm.c                             |  12 +-
 arch/xtensa/kernel/process.c                       |   2 +-
 block/bfq-iosched.c                                |  22 +-
 block/bio.c                                        |   2 +-
 block/blk-cgroup.c                                 |   6 -
 block/blk-cgroup.h                                 |  12 +-
 block/blk-core.c                                   |  19 +-
 block/blk-iolatency.c                              |  14 +-
 block/blk-merge.c                                  |  64 +++--
 block/blk-mq-sched.c                               |  14 +-
 block/blk-mq-sched.h                               |  13 +-
 block/blk-mq-sysfs.c                               |   6 +-
 block/blk-mq-tag.c                                 |  23 +-
 block/blk-mq.c                                     |  84 ++++---
 block/blk-mq.h                                     |  18 +-
 block/blk-settings.c                               |  44 ++--
 block/blk-sysfs.c                                  |  57 ++++-
 block/blk-throttle.c                               |  15 +-
 block/blk-throttle.h                               |  18 +-
 block/blk.h                                        |  45 +---
 block/elevator.c                                   |   3 +-
 block/elevator.h                                   |   2 +-
 block/kyber-iosched.c                              |  19 +-
 block/mq-deadline.c                                |  16 +-
 crypto/842.c                                       |   6 +-
 crypto/asymmetric_keys/x509_cert_parser.c          |  16 +-
 crypto/lz4.c                                       |   6 +-
 crypto/lz4hc.c                                     |   6 +-
 crypto/lzo-rle.c                                   |   6 +-
 crypto/lzo.c                                       |   6 +-
 drivers/accel/amdxdna/aie2_ctx.c                   |   6 +-
 drivers/acpi/acpica/aclocal.h                      |   2 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/acpi/processor_idle.c                      |   3 +
 drivers/base/node.c                                |   4 +
 drivers/base/power/main.c                          |  14 +-
 drivers/base/regmap/regmap.c                       |   2 +-
 drivers/block/nbd.c                                |   8 +
 drivers/block/null_blk/main.c                      |   2 +-
 drivers/bluetooth/btintel_pcie.c                   | 218 ++++++----------
 drivers/bluetooth/btintel_pcie.h                   |   2 +
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |   3 +
 drivers/cdx/Kconfig                                |   1 -
 drivers/cdx/cdx.c                                  |   4 +-
 drivers/cdx/controller/Kconfig                     |   1 -
 drivers/cdx/controller/cdx_controller.c            |   3 +-
 drivers/char/hw_random/Kconfig                     |   1 +
 drivers/char/hw_random/ks-sa-rng.c                 |   4 +
 drivers/char/tpm/Kconfig                           |   2 +-
 drivers/clocksource/timer-tegra186.c               |   4 +-
 drivers/cpufreq/scmi-cpufreq.c                     |  10 +
 drivers/cpuidle/cpuidle-qcom-spm.c                 |   7 +-
 drivers/crypto/hisilicon/debugfs.c                 |   1 +
 drivers/crypto/hisilicon/hpre/hpre_main.c          |  86 +++++--
 drivers/crypto/hisilicon/qm.c                      |  45 +++-
 drivers/crypto/hisilicon/sec2/sec_main.c           | 126 +++++++---
 drivers/crypto/hisilicon/zip/zip_main.c            | 102 +++++---
 .../crypto/intel/keembay/keembay-ocs-hcu-core.c    |   5 +-
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c    |   2 +-
 drivers/crypto/nx/nx-common-powernv.c              |   6 +-
 drivers/crypto/nx/nx-common-pseries.c              |   6 +-
 drivers/devfreq/event/rockchip-dfi.c               |   7 +-
 drivers/devfreq/mtk-cci-devfreq.c                  |   3 +-
 drivers/edac/i10nm_base.c                          |  14 ++
 drivers/firmware/arm_scmi/transports/virtio.c      |   3 +
 drivers/firmware/efi/Kconfig                       |   7 +-
 drivers/firmware/meson/Kconfig                     |   2 +-
 drivers/fwctl/mlx5/main.c                          |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  20 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c           |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h           |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.c            | 170 ++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h            |  11 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v1_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |   2 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c              |  29 ++-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |  27 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   1 -
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c            |   2 -
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_stream.c    |   8 +-
 .../display/dc/dml/dcn32/display_rq_dlg_calc_32.c  |   1 -
 .../drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  |  32 ++-
 drivers/gpu/drm/amd/display/dc/inc/core_types.h    |   5 +-
 .../amd/display/dc/link/accessories/link_dp_cts.c  |  12 +-
 .../amd/display/dc/resource/dcn31/dcn31_resource.c |   5 +-
 .../amd/display/dc/resource/dcn31/dcn31_resource.h |   3 +-
 drivers/gpu/drm/amd/pm/amdgpu_dpm_internal.c       |   7 +
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c         |  92 +++++--
 drivers/gpu/drm/bridge/Kconfig                     |   1 +
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c     |   4 +-
 drivers/gpu/drm/display/drm_bridge_connector.c     |   4 +
 drivers/gpu/drm/display/drm_dp_helper.c            |   4 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |  23 +-
 drivers/gpu/drm/drm_panel.c                        |  73 +++++-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c    |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c          |   4 +
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c           |   6 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   1 +
 drivers/gpu/drm/msm/msm_gem_vma.c                  |  31 ++-
 drivers/gpu/drm/msm/msm_kms.c                      |   5 +-
 drivers/gpu/drm/panel/panel-edp.c                  |  20 +-
 drivers/gpu/drm/panel/panel-novatek-nt35560.c      |   2 +-
 drivers/gpu/drm/radeon/r600_cs.c                   |   4 +-
 drivers/gpu/drm/scheduler/tests/mock_scheduler.c   |   2 +-
 drivers/gpu/drm/scheduler/tests/sched_tests.h      |   7 +-
 drivers/gpu/drm/scheduler/tests/tests_basic.c      |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |   2 +-
 drivers/hid/hid-ids.h                              |   2 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/hid-steelseries.c                      | 108 +++-----
 drivers/hid/hidraw.c                               | 262 ++++++++++---------
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  46 ++--
 drivers/hid/i2c-hid/i2c-hid-of-elan.c              |  11 +-
 drivers/hwmon/asus-ec-sensors.c                    |   2 +-
 drivers/hwmon/mlxreg-fan.c                         |  24 +-
 drivers/hwtracing/coresight/coresight-catu.c       |  31 ++-
 drivers/hwtracing/coresight/coresight-catu.h       |   1 +
 drivers/hwtracing/coresight/coresight-core.c       |   6 +-
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |   6 +-
 drivers/hwtracing/coresight/coresight-ctcu-core.c  |  10 +-
 drivers/hwtracing/coresight/coresight-etb10.c      |  10 +-
 drivers/hwtracing/coresight/coresight-etm3x-core.c |   9 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  41 +--
 .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   1 +
 drivers/hwtracing/coresight/coresight-etm4x.h      |   6 +-
 drivers/hwtracing/coresight/coresight-funnel.c     |  42 +---
 drivers/hwtracing/coresight/coresight-replicator.c |  40 +--
 drivers/hwtracing/coresight/coresight-stm.c        |  13 +-
 drivers/hwtracing/coresight/coresight-syscfg.c     |   2 +-
 drivers/hwtracing/coresight/coresight-tmc-core.c   |  26 +-
 drivers/hwtracing/coresight/coresight-tmc.h        |   2 +
 drivers/hwtracing/coresight/coresight-tpda.c       |   3 +
 drivers/hwtracing/coresight/coresight-tpiu.c       |  14 +-
 drivers/hwtracing/coresight/coresight-trbe.c       |  12 +-
 drivers/hwtracing/coresight/ultrasoc-smb.h         |   1 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |   5 +-
 drivers/i2c/busses/i2c-k1.c                        |  71 ++++--
 drivers/i2c/busses/i2c-mt65xx.c                    |  17 +-
 drivers/i3c/internals.h                            |  12 +-
 drivers/i3c/master/svc-i3c-master.c                |  31 ++-
 drivers/iio/inkern.c                               |  30 +--
 drivers/infiniband/core/addr.c                     |  10 +-
 drivers/infiniband/core/cm.c                       |   4 +-
 drivers/infiniband/core/sa_query.c                 |   6 +-
 drivers/infiniband/hw/mlx5/main.c                  |  67 ++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   5 +
 drivers/infiniband/sw/rxe/rxe_task.c               |   8 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |  25 +-
 drivers/input/misc/uinput.c                        |   1 +
 drivers/input/touchscreen/atmel_mxt_ts.c           |   2 +-
 drivers/iommu/intel/debugfs.c                      |  17 +-
 drivers/iommu/intel/iommu.h                        |   3 +-
 drivers/iommu/iommu-priv.h                         |   2 +
 drivers/iommu/iommu.c                              |  26 ++
 drivers/iommu/iommufd/selftest.c                   |   2 +-
 drivers/irqchip/irq-gic-v5-its.c                   |  24 +-
 drivers/irqchip/irq-sg2042-msi.c                   |  18 +-
 drivers/leds/flash/leds-qcom-flash.c               |  62 +++--
 drivers/leds/leds-lp55xx-common.c                  |   2 +-
 drivers/leds/leds-max77705.c                       |   2 +-
 drivers/md/dm-core.h                               |   1 +
 drivers/md/dm-vdo/indexer/volume-index.c           |   4 +-
 drivers/md/dm.c                                    |  13 +-
 drivers/media/i2c/rj54n1cb0c.c                     |   9 +-
 drivers/media/i2c/vd55g1.c                         |   2 +-
 drivers/media/pci/zoran/zoran.h                    |   6 -
 drivers/media/pci/zoran/zoran_driver.c             |   3 +-
 .../media/platform/st/sti/delta/delta-mjpeg-dec.c  |  20 +-
 drivers/mfd/intel_soc_pmic_chtdc_ti.c              |   2 +
 drivers/mfd/max77705.c                             |  38 ++-
 drivers/mfd/rz-mtu3.c                              |   2 +-
 drivers/mfd/vexpress-sysreg.c                      |   6 +-
 drivers/misc/fastrpc.c                             |  89 ++++---
 drivers/misc/genwqe/card_ddcb.c                    |   2 +-
 drivers/misc/pci_endpoint_test.c                   |   2 +-
 drivers/mmc/core/block.c                           |   6 +-
 drivers/mmc/host/Kconfig                           |   1 +
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   4 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/bonding/bond_netlink.c                 |  16 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   5 +-
 drivers/net/ethernet/cadence/macb.h                |   4 -
 drivers/net/ethernet/cadence/macb_main.c           | 134 +++++-----
 drivers/net/ethernet/dlink/dl2k.c                  |   7 +-
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c   |   2 +-
 drivers/net/ethernet/freescale/enetc/ntmp.c        |  15 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   8 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c    |   6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   6 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  12 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  24 ++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   7 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   2 +-
 drivers/net/phy/as21xxx.c                          |   7 +-
 drivers/net/usb/asix_devices.c                     |  29 +++
 drivers/net/usb/rtl8150.c                          |   2 -
 drivers/net/wireless/ath/ath10k/wmi.c              |  39 ++-
 drivers/net/wireless/ath/ath12k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath12k/debug.h            |   1 +
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  56 +++--
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  45 +++-
 drivers/net/wireless/ath/ath12k/hal_rx.h           |  12 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  16 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   8 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |   1 -
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.h |   1 -
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  29 +--
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  29 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    | 137 +++-------
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 106 ++++++--
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  38 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |  22 +-
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |   2 +-
 drivers/net/wireless/realtek/rtw88/led.c           |  13 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   1 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   3 +-
 drivers/nvme/host/auth.c                           |   5 +-
 drivers/nvme/host/tcp.c                            |   3 +
 drivers/nvme/target/fc.c                           |  19 +-
 drivers/nvme/target/fcloop.c                       |   8 +-
 drivers/pci/controller/cadence/pci-j721e.c         |   2 +-
 drivers/pci/controller/dwc/pcie-designware.h       |   1 -
 drivers/pci/controller/dwc/pcie-qcom-common.c      |  58 +++--
 drivers/pci/controller/dwc/pcie-qcom-common.h      |   2 +-
 drivers/pci/controller/dwc/pcie-qcom-ep.c          |   6 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |   8 +-
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |  26 +-
 drivers/pci/controller/dwc/pcie-tegra194.c         |   4 +-
 drivers/pci/controller/pci-tegra.c                 |   2 +-
 drivers/pci/controller/pci-xgene-msi.c             |   2 +-
 drivers/pci/controller/pcie-rcar-host.c            |   2 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  31 ++-
 drivers/pci/endpoint/pci-ep-msi.c                  |   2 +-
 drivers/pci/msi/irqdomain.c                        |  57 +++++
 drivers/pci/pci-acpi.c                             |   6 +-
 drivers/pci/pcie/aer.c                             |   3 +
 drivers/pci/pwrctrl/slot.c                         |  12 +-
 drivers/perf/arm_spe_pmu.c                         |   3 +-
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c |  12 +
 drivers/pinctrl/Kconfig                            |   2 +
 drivers/pinctrl/meson/pinctrl-meson-gxl.c          |  10 +
 drivers/pinctrl/pinctrl-eic7700.c                  |   2 +-
 drivers/pinctrl/pinmux.c                           |   2 +-
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   2 +-
 drivers/pinctrl/renesas/pinctrl.c                  |   3 +-
 drivers/power/supply/cw2015_battery.c              |   3 +-
 drivers/power/supply/max77705_charger.c            | 198 +++++++--------
 drivers/pps/kapi.c                                 |   5 +-
 drivers/pps/pps.c                                  |   5 +-
 drivers/ptp/ptp_private.h                          |   1 +
 drivers/ptp/ptp_sysfs.c                            |   2 +-
 drivers/pwm/pwm-loongson.c                         |   2 +-
 drivers/pwm/pwm-tiehrpwm.c                         | 154 +++++-------
 drivers/regulator/scmi-regulator.c                 |   3 +-
 drivers/remoteproc/pru_rproc.c                     |   3 +-
 drivers/remoteproc/qcom_q6v5.c                     |   3 -
 drivers/remoteproc/qcom_q6v5_mss.c                 |  11 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |   6 +
 drivers/rpmsg/qcom_smd.c                           |   2 +-
 drivers/scsi/libsas/sas_expander.c                 |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   8 +-
 drivers/scsi/myrs.c                                |   8 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  11 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |  31 ++-
 drivers/scsi/pm8001/pm8001_sas.h                   |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  10 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   2 +-
 drivers/soc/mediatek/mtk-svs.c                     |  23 ++
 drivers/soc/qcom/rpmh-rsc.c                        |   7 +-
 drivers/spi/spi.c                                  |   2 +-
 drivers/staging/media/ipu7/ipu7.c                  |  28 +--
 drivers/tee/tee_shm.c                              |   8 +
 drivers/thermal/qcom/Kconfig                       |   3 +-
 drivers/thermal/qcom/lmh.c                         |   2 +
 drivers/thunderbolt/tunnel.c                       |   5 +-
 drivers/tty/n_gsm.c                                |  25 +-
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/ufs/core/ufs-sysfs.c                       |   2 +
 drivers/ufs/core/ufshcd.c                          |   9 +
 drivers/uio/uio_hv_generic.c                       |   7 +-
 drivers/usb/cdns3/cdnsp-pci.c                      |   5 +-
 drivers/usb/gadget/configfs.c                      |   2 +
 drivers/usb/host/max3421-hcd.c                     |   2 +-
 drivers/usb/host/xhci-ring.c                       |  11 +-
 drivers/usb/misc/Kconfig                           |   1 +
 drivers/usb/misc/qcom_eud.c                        |  33 ++-
 drivers/usb/phy/phy-twl6030-usb.c                  |   3 +-
 drivers/usb/typec/tipd/core.c                      |  24 +-
 drivers/usb/usbip/vhci_hcd.c                       |  22 ++
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c     |   6 +-
 drivers/vfio/pci/pds/dirty.c                       |   2 +-
 drivers/vhost/vringh.c                             |  14 +-
 drivers/video/fbdev/simplefb.c                     |  31 ++-
 drivers/watchdog/intel_oc_wdt.c                    |   8 +-
 drivers/watchdog/mpc8xxx_wdt.c                     |   2 +
 fs/btrfs/extent_io.c                               |   9 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/cramfs/inode.c                                  |   2 +-
 fs/erofs/zdata.c                                   |   4 +-
 fs/ext4/ext4.h                                     |  10 +
 fs/ext4/file.c                                     |   2 +-
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |  10 +
 fs/ext4/orphan.c                                   |   6 +-
 fs/ext4/super.c                                    |   4 +-
 fs/f2fs/compress.c                                 |  25 +-
 fs/f2fs/data.c                                     |  11 +-
 fs/f2fs/f2fs.h                                     |   4 +-
 fs/f2fs/file.c                                     |  49 ++--
 fs/f2fs/gc.c                                       |  16 +-
 fs/f2fs/super.c                                    |  10 +-
 fs/fuse/file.c                                     |   1 -
 fs/gfs2/file.c                                     |  23 +-
 fs/gfs2/glock.c                                    | 121 ++++-----
 fs/gfs2/glock.h                                    |   4 +
 fs/gfs2/incore.h                                   |   3 +-
 fs/gfs2/lock_dlm.c                                 |  72 ++++--
 fs/gfs2/trace_gfs2.h                               |   1 -
 fs/hfsplus/dir.c                                   |   2 +-
 fs/hfsplus/hfsplus_fs.h                            |   8 +-
 fs/hfsplus/unicode.c                               |  24 +-
 fs/hfsplus/xattr.c                                 |   6 +-
 fs/nfs/localio.c                                   |  65 ++++-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfsd/filecache.c                                |  34 +++
 fs/nfsd/filecache.h                                |   4 +
 fs/nfsd/localio.c                                  |  11 +
 fs/nfsd/trace.h                                    |  27 ++
 fs/nfsd/vfs.h                                      |   4 +
 fs/notify/fanotify/fanotify_user.c                 |   3 +
 fs/ntfs3/index.c                                   |  10 +
 fs/ntfs3/run.c                                     |  12 +-
 fs/ocfs2/stack_user.c                              |   1 +
 fs/smb/client/smb2ops.c                            |  17 +-
 fs/smb/client/smbdirect.c                          | 110 +++++++-
 fs/smb/client/smbdirect.h                          |   4 +-
 fs/smb/server/ksmbd_netlink.h                      |   5 +-
 fs/smb/server/mgmt/user_session.c                  |  26 +-
 fs/smb/server/server.h                             |   1 +
 fs/smb/server/smb2pdu.c                            |   3 +-
 fs/smb/server/transport_ipc.c                      |   3 +
 fs/smb/server/transport_rdma.c                     |  97 ++++++-
 fs/smb/server/transport_tcp.c                      |  27 +-
 fs/squashfs/inode.c                                |   7 +
 fs/squashfs/squashfs_fs_i.h                        |   2 +-
 fs/udf/inode.c                                     |   3 +
 include/acpi/actbl.h                               |   2 +-
 include/asm-generic/vmlinux.lds.h                  |   1 +
 include/crypto/internal/scompress.h                |  11 +-
 include/drm/drm_panel.h                            |  14 ++
 include/linux/blk_types.h                          |   7 +-
 include/linux/blkdev.h                             |   2 +
 include/linux/bpf.h                                |   1 +
 include/linux/bpf_verifier.h                       |  12 +-
 include/linux/btf.h                                |   2 +-
 include/linux/coresight.h                          |  25 +-
 include/linux/dmaengine.h                          |   2 +-
 include/linux/hid.h                                |   2 +
 include/linux/irq.h                                |   2 +
 include/linux/memcontrol.h                         |   6 +
 include/linux/mm.h                                 |   2 +-
 include/linux/mmc/sdio_ids.h                       |   2 +-
 include/linux/msi.h                                |   2 +
 include/linux/nfslocalio.h                         |   2 +
 include/linux/once.h                               |   4 +-
 include/linux/phy.h                                |  23 +-
 include/linux/power/max77705_charger.h             | 102 ++++----
 include/linux/sched/topology.h                     |  28 ++-
 include/linux/topology.h                           |   2 +-
 include/net/bonding.h                              |   1 +
 include/net/dst.h                                  |  16 +-
 include/net/ip.h                                   |  30 ++-
 include/net/ip6_route.h                            |   2 +-
 include/net/route.h                                |   2 +-
 include/scsi/libsas.h                              |   8 +
 include/trace/events/filelock.h                    |   3 +-
 include/trace/misc/fs.h                            |  22 ++
 include/uapi/linux/hidraw.h                        |   2 +
 include/ufs/ufshcd.h                               |   3 +
 include/vdso/gettime.h                             |   1 +
 init/Kconfig                                       |   3 +-
 io_uring/waitid.c                                  |   3 +-
 io_uring/zcrx.c                                    |   4 +
 kernel/bpf/core.c                                  |   5 +
 kernel/bpf/helpers.c                               |   3 -
 kernel/bpf/verifier.c                              |  28 ++-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/events/uprobes.c                            |   2 +-
 kernel/irq/Kconfig                                 |   2 +
 kernel/irq/chip.c                                  |  37 +++
 kernel/irq/irq_test.c                              |  18 +-
 kernel/pid.c                                       |   2 +-
 kernel/rcu/srcutiny.c                              |   4 +-
 kernel/sched/topology.c                            |  28 +--
 kernel/seccomp.c                                   |  12 +-
 kernel/smp.c                                       |  11 +-
 kernel/time/clockevents.c                          |   2 +-
 kernel/time/tick-common.c                          |  16 +-
 kernel/time/tick-internal.h                        |   2 +-
 kernel/trace/bpf_trace.c                           |   9 +-
 kernel/trace/trace.c                               | 278 +++++++++++++++++----
 kernel/trace/trace_events.c                        |   3 +-
 kernel/trace/trace_fprobe.c                        |  10 +-
 kernel/trace/trace_irqsoff.c                       |  23 +-
 kernel/trace/trace_kprobe.c                        |  11 +-
 kernel/trace/trace_probe.h                         |   9 +-
 kernel/trace/trace_sched_wakeup.c                  |  16 +-
 kernel/trace/trace_uprobe.c                        |  12 +-
 lib/raid6/recov_rvv.c                              |   2 -
 lib/raid6/rvv.c                                    |   3 -
 lib/vdso/datastore.c                               |   6 +-
 mm/hugetlb.c                                       |   2 +
 mm/memcontrol.c                                    |  13 +
 mm/slub.c                                          |   5 +-
 net/9p/trans_usbg.c                                |  16 +-
 net/bluetooth/hci_sync.c                           |  10 +-
 net/bluetooth/iso.c                                |  11 +-
 net/bluetooth/mgmt.c                               |  10 +-
 net/core/dst.c                                     |   2 +-
 net/core/filter.c                                  |  16 +-
 net/core/sock.c                                    |  16 +-
 net/ethtool/tsconfig.c                             |  12 +-
 net/ipv4/icmp.c                                    |   6 +-
 net/ipv4/ip_fragment.c                             |   6 +-
 net/ipv4/ipmr.c                                    |   6 +-
 net/ipv4/ping.c                                    |  14 +-
 net/ipv4/route.c                                   |   8 +-
 net/ipv4/tcp.c                                     |   9 +-
 net/ipv4/tcp_input.c                               |  15 +-
 net/ipv4/tcp_metrics.c                             |   6 +-
 net/ipv6/anycast.c                                 |   2 +-
 net/ipv6/icmp.c                                    |   9 +-
 net/ipv6/ip6_output.c                              |  64 ++---
 net/ipv6/mcast.c                                   |  67 +++--
 net/ipv6/ndisc.c                                   |   2 +-
 net/ipv6/output_core.c                             |   8 +-
 net/ipv6/proc.c                                    |  47 ++--
 net/ipv6/route.c                                   |   7 +-
 net/mac80211/cfg.c                                 |  21 +-
 net/mac80211/main.c                                |   3 -
 net/mac80211/rx.c                                  |  28 ++-
 net/mac80211/sta_info.c                            |  10 +-
 net/mptcp/ctrl.c                                   |   9 +-
 net/mptcp/subflow.c                                |  11 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   8 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  11 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   6 +-
 net/netfilter/ipvs/ip_vs_est.c                     |  16 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   4 +-
 net/netfilter/nf_conntrack_standalone.c            |   3 +
 net/netfilter/nfnetlink.c                          |   2 +
 net/nfc/nci/ntf.c                                  | 135 +++++++---
 net/smc/smc_clc.c                                  |  67 ++---
 net/smc/smc_core.c                                 |  27 +-
 net/smc/smc_pnet.c                                 |  43 ++--
 net/sunrpc/auth_gss/svcauth_gss.c                  |   2 +-
 net/tls/tls_device.c                               |  18 +-
 net/wireless/util.c                                |   2 +-
 rust/bindings/bindings_helper.h                    |   1 +
 rust/kernel/cpumask.rs                             |   1 +
 scripts/misc-check                                 |   4 +-
 security/Kconfig                                   |   1 +
 sound/core/pcm_native.c                            |  21 +-
 sound/hda/codecs/hdmi/hdmi.c                       |   1 +
 sound/hda/codecs/realtek/alc269.c                  |   1 +
 sound/pci/lx6464es/lx_core.c                       |   4 +-
 sound/soc/codecs/wcd934x.c                         |  17 +-
 sound/soc/codecs/wcd937x.c                         |   4 +-
 sound/soc/codecs/wcd937x.h                         |   6 +-
 sound/soc/intel/boards/bytcht_es8316.c             |  20 +-
 sound/soc/intel/boards/bytcr_rt5640.c              |   7 +-
 sound/soc/intel/boards/bytcr_rt5651.c              |  26 +-
 sound/soc/intel/boards/sof_sdw.c                   |   2 +-
 sound/soc/qcom/sc8280xp.c                          |   4 +-
 sound/soc/sof/intel/hda-sdw-bpt.c                  |   2 +-
 sound/soc/sof/ipc3-topology.c                      |  10 +-
 sound/soc/sof/ipc4-pcm.c                           | 101 ++++++--
 sound/soc/sof/ipc4-topology.c                      |   1 -
 sound/soc/sof/ipc4-topology.h                      |   2 +
 tools/include/nolibc/nolibc.h                      |   1 +
 tools/include/nolibc/std.h                         |   2 +-
 tools/include/nolibc/sys.h                         |  13 +
 tools/include/nolibc/time.h                        |   5 +-
 tools/lib/bpf/libbpf.c                             |  46 ++--
 tools/lib/bpf/libbpf.h                             |   2 +-
 tools/net/ynl/pyynl/lib/ynl.py                     |   2 +-
 .../acpi/os_specific/service_layers/oslinuxtbl.c   |   4 +-
 tools/testing/nvdimm/test/ndtest.c                 |  13 +-
 tools/testing/selftests/arm64/abi/tpidr2.c         |   8 +-
 tools/testing/selftests/arm64/gcs/basic-gcs.c      |   2 +-
 tools/testing/selftests/arm64/pauth/exec_target.c  |   7 +-
 tools/testing/selftests/bpf/Makefile               |   4 +-
 tools/testing/selftests/bpf/bench.c                |   2 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/fd_array.c  |   2 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   | 220 +---------------
 .../selftests/bpf/prog_tests/module_attach.c       |   2 +-
 .../testing/selftests/bpf/prog_tests/reg_bounds.c  |   4 +-
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |   2 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   2 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |   2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |   2 +-
 .../selftests/bpf/prog_tests/stacktrace_map_skip.c |   2 +-
 tools/testing/selftests/bpf/progs/bpf_cc_cubic.c   |   2 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |   2 +-
 .../selftests/bpf/progs/freplace_connect_v4_prog.c |   2 +-
 .../selftests/bpf/progs/iters_state_safety.c       |   2 +-
 tools/testing/selftests/bpf/progs/rbtree_search.c  |   2 +-
 .../selftests/bpf/progs/struct_ops_kptr_return.c   |   2 +-
 .../selftests/bpf/progs/struct_ops_refcounted.c    |   2 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |   2 +-
 .../selftests/bpf/progs/test_cls_redirect_dynptr.c |   2 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |   1 -
 .../testing/selftests/bpf/progs/uretprobe_stack.c  |   4 +-
 .../selftests/bpf/progs/verifier_scalar_ids.c      |   2 +-
 .../testing/selftests/bpf/progs/verifier_var_off.c |   6 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   2 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |  20 +-
 tools/testing/selftests/bpf/trace_helpers.c        | 214 ++++++++++++++++
 tools/testing/selftests/bpf/trace_helpers.h        |   3 +
 tools/testing/selftests/bpf/verifier/calls.c       |   8 +-
 tools/testing/selftests/bpf/xdping.c               |   2 +-
 tools/testing/selftests/bpf/xsk.h                  |   4 +-
 tools/testing/selftests/bpf/xskxceiver.c           |  14 +-
 tools/testing/selftests/cgroup/lib/cgroup_util.c   |  12 +
 .../selftests/cgroup/lib/include/cgroup_util.h     |   1 +
 tools/testing/selftests/cgroup/test_pids.c         |   3 +
 tools/testing/selftests/futex/functional/Makefile  |   5 +-
 .../selftests/futex/functional/futex_numa_mpol.c   |  59 ++---
 .../selftests/futex/functional/futex_priv_hash.c   |   1 -
 tools/testing/selftests/futex/functional/run.sh    |   1 -
 tools/testing/selftests/futex/include/futextest.h  |  11 +
 tools/testing/selftests/iommu/iommufd_utils.h      |   8 +-
 tools/testing/selftests/kselftest_harness/Makefile |   1 +
 tools/testing/selftests/lib.mk                     |   5 +-
 tools/testing/selftests/mm/madv_populate.c         |  21 +-
 tools/testing/selftests/mm/soft-dirty.c            |   5 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |   4 +-
 tools/testing/selftests/mm/vm_util.c               |  17 ++
 tools/testing/selftests/mm/vm_util.h               |   1 +
 tools/testing/selftests/nolibc/nolibc-test.c       |   5 +-
 tools/testing/selftests/vDSO/vdso_call.h           |   7 +-
 tools/testing/selftests/vDSO/vdso_test_abi.c       |   9 +-
 tools/testing/selftests/watchdog/watchdog-test.c   |   6 +
 684 files changed, 6525 insertions(+), 3960 deletions(-)


