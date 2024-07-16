Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D496312B72;
	Tue, 16 Jul 2024 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144895; cv=none; b=hfcbVT4quu4/vhK+zLNMU3Oy3Nfp9xWZQfHWmMEX7IGXSD8eJm+/1eb4+Vr5gGxpF8Be7uDyW/T2olQjdo+YyXCy7N4KeOur6EA6WSKYEPBLJBnyQsx6tCWeuvzQSl5fYuSejIavqCkpsEwhqNRTUgDSwhq/f6evjGi6sJcGGNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144895; c=relaxed/simple;
	bh=7LA0ZmaMEiEskfW+6aFFTeBhkT0PX+4B1IXC8s5BvaE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N77eTqJ3PZnuX+m/8AgFPZdUbrPqr+akt9FuW7btjwHFm6H6vjj2BZ+6zkCm/Gc54mD2XiEBI/M/Z79j8jRIkQwJXfDR3rLlwlW7UjzbVv8mKuVrYAWEpTQ7W4PuUKee0QFnATS0x6G8eRM52GJvTaCJ51nCRiciZzar2hp1uGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENKmT67T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENKmT67T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296D6C116B1;
	Tue, 16 Jul 2024 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144895;
	bh=7LA0ZmaMEiEskfW+6aFFTeBhkT0PX+4B1IXC8s5BvaE=;
	h=From:To:Cc:Subject:Date:From;
	b=ENKmT67TLU30+zF64nEdqfNFboQzNTZTcs6AzGMzKF72bYrxouNDN0J/tCYp7AvnN
	 b7Z1m/3pL2c5wCDDxMUonud/we9//8tyT777BUW9A8r4jYusKeg5RBlPCLtgt1XHfY
	 XMcZCuIy7yWGFn2uFpHMmKnuMgD4BZd/RPvRFhRg=
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
Subject: [PATCH 6.9 000/143] 6.9.10-rc1 review
Date: Tue, 16 Jul 2024 17:29:56 +0200
Message-ID: <20240716152755.980289992@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.10-rc1
X-KernelTest-Deadline: 2024-07-18T15:28+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.10 release.
There are 143 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.10-rc1

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    kbuild: rpm-pkg: avoid the warnings with dtb's listed twice

Nathan Chancellor <nathan@kernel.org>
    kbuild: Make ld-version.sh more robust against version string changes

Alexandre Chartre <alexandre.chartre@oracle.com>
    x86/bhi: Avoid warning in #DB handler due to BHI mitigation

Wander Lairson Costa <wander@redhat.com>
    sched/deadline: Fix task_struct reference leak

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: testunit: avoid re-issued work after read message

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: ensure Gen3+ reset does not disturb local targets

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: mark HostNotify target address as used

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: clear NO_RXDMA flag after resetting

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: bring hardware to known state when probing

Baokun Li <libaokun1@huawei.com>
    ext4: avoid ptr null pointer dereference

Komal Bajaj <quic_kbajaj@quicinc.com>
    Revert "dt-bindings: cache: qcom,llcc: correct QDU1000 reg entries"

SeongJae Park <sj@kernel.org>
    mm/damon/core: merge regions aggressively when max_nr_regions is unmet

Gavin Shan <gshan@redhat.com>
    mm/shmem: disable PMD-sized page cache if needed

Gavin Shan <gshan@redhat.com>
    mm/readahead: limit page cache size in page_cache_ra_order()

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Restrict untrusted app to attach to privileged PD

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix ownership reassignment of remote heap

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix memory leak in audio daemon attach operation

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Copy the complete capability structure to user

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Avoid updating PD type for capability request

Ekansh Gupta <quic_ekangupt@quicinc.com>
    misc: fastrpc: Fix DSP capabilities request

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: send: annotate intentional data race in checking empty queue

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: queueing: annotate intentional data race in cpu round robin

Helge Deller <deller@kernel.org>
    wireguard: allowedips: avoid unaligned 64-bit memory accesses

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: use acpi=off instead of -no-acpi for recent QEMU

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq: Allow drivers to advertise boost enabled

Mario Limonciello <mario.limonciello@amd.com>
    cpufreq: ACPI: Mark boost policy as enabled when setting boost

Kuan-Wei Chiu <visitorckw@gmail.com>
    ACPI: processor_idle: Fix invalid comparison with insertion sort for latency

Ilya Dryomov <idryomov@gmail.com>
    libceph: fix race between delayed_work() and ceph_monc_stop()

Taniya Das <quic_tdas@quicinc.com>
    pmdomain: qcom: rpmhpd: Skip retention level for Power Domains

Bastien Curutchet <bastien.curutchet@bootlin.com>
    mmc: davinci_mmc: Prevent transmitted data size from exceeding sgm's length

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci: Fix max_seg_size for 64KiB PAGE_SIZE

Audra Mitchell <audra@redhat.com>
    Fix userfaultfd_api to return EINVAL as expected

Wentong Wu <wentong.wu@intel.com>
    mei: vsc: Utilize the appropriate byte order swap function

Wentong Wu <wentong.wu@intel.com>
    mei: vsc: Prevent timeout error with added delay post-firmware download

Wentong Wu <wentong.wu@intel.com>
    mei: vsc: Enhance IVSC chipset stability during warm reboot

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on VAIO PRO PX

Nazar Bilinskyi <nbilinskyi@gmail.com>
    ALSA: hda/realtek: Enable Mute LED on HP 250 G7

Michał Kopeć <michal.kopec@3mdeb.com>
    ALSA: hda/realtek: add quirk for Clevo V5[46]0TU

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    serial: imx: ensure RTS signal is not left active after shutdown

Jacky Huang <ychuang3@nuvoton.com>
    tty: serial: ma35d1: Add a NULL check for of_node

Armin Wolf <W_Armin@gmx.de>
    platform/x86: toshiba_acpi: Fix array out-of-bounds access

Thomas Weißschuh <linux@weissschuh.net>
    nvmem: core: limit cell sysfs permissions to main attribute ones

Thomas Weißschuh <linux@weissschuh.net>
    nvmem: core: only change name to fram for current attribute

Joy Chakraborty <joychakr@google.com>
    nvmem: meson-efuse: Fix return value of nvmem callbacks

Joy Chakraborty <joychakr@google.com>
    nvmem: rmem: Fix return value of rmem_read()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: x1e80100-crd: fix DAI used for headset recording

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: x1e80100-crd: fix WCD audio codec TX port mapping

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp-x13s: fix touchscreen power on

Cong Zhang <quic_congzhan@quicinc.com>
    arm64: dts: qcom: sa8775p: Correct IRQ number of EL2 non-secure physical timer

João Paulo Gonçalves <joao.goncalves@toradex.com>
    iio: trigger: Fix condition for own trigger

Damien Le Moal <dlemoal@kernel.org>
    scsi: sd: Do not repeat the starting disk message

Hobin Woo <hobin.woo@samsung.com>
    ksmbd: discard write access to the directory open

Gavin Shan <gshan@redhat.com>
    mm/filemap: make MAX_PAGECACHE_ORDER acceptable to xarray

Gavin Shan <gshan@redhat.com>
    mm/filemap: skip to create PMD-sized page cache if needed

ZhangPeng <zhangpeng362@huawei.com>
    filemap: replace pte_offset_map() with pte_offset_map_nolock()

Hugh Dickins <hughd@google.com>
    mm: fix crashes from deferred split racing folio migration

Uladzislau Rezki (Sony) <urezki@gmail.com>
    mm: vmalloc: check if a hash-index is in cpu_possible_mask

Nhat Pham <nphamcs@gmail.com>
    cachestat: do not flush stats in recency check

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug on rename operation of broken directory

Heiko Carstens <hca@linux.ibm.com>
    s390/mm: Add NULL pointer check to crst_table_free() base_crst_free()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: always resume roothubs if xHC was reset during resume

He Zhe <zhe.he@windriver.com>
    hpet: Support 32-bit userspace

Joy Chakraborty <joychakr@google.com>
    misc: microchip: pci1xxxx: Fix return value of nvmem callbacks

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix duplicate endpoint bug by clearing reserved bits in the descriptor

Lee Jones <lee@kernel.org>
    usb: gadget: configfs: Prevent OOB read/write in usb_string_copy()

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: core: add missing of_node_put() in usb_of_has_devices_or_graph

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add support for the Intel Panther Lake

WangYuli <wangyuli@uniontech.com>
    USB: Add USB_QUIRK_NO_SET_INTF quirk for START BP-850k

Dmitry Smirnov <d.smirnov@inbox.lv>
    USB: serial: mos7840: fix crash on resume

Vanillan Wang <vanillanwang@163.com>
    USB: serial: option: add Rolling RW350-GL variants

Mank Wang <mank.wang@netprisma.us>
    USB: serial: option: add Netprisma LCUK54 series modules

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add support for Foxconn T99W651

Bjørn Mork <bjorn@mork.no>
    USB: serial: option: add Fibocom FM350-GL

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN912 rmnet compositions

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit generic core-dump composition

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix potential TX stall after interface reopen

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix deadlock with the SPI chip variant

Josh Don <joshdon@google.com>
    Revert "sched/fair: Make sure to try to detach at least one movable task"

Steve French <stfrench@microsoft.com>
    cifs: fix setting SecurityFlags to true

Satheesh Paul <psatheesh@marvell.com>
    octeontx2-af: fix issue with IPv4 match for RSS

Kiran Kumar K <kirankumark@marvell.com>
    octeontx2-af: fix issue with IPv6 ext match for RSS

Michal Mazur <mmazur2@marvell.com>
    octeontx2-af: fix detection of IP layer

Srujana Challa <schalla@marvell.com>
    octeontx2-af: fix a issue with cpt_lf_alloc mailbox

Nithin Dabilpuram <ndabilpuram@marvell.com>
    octeontx2-af: replace cpt slot with lf id on reg write

Aleksandr Loktionov <aleksandr.loktionov@intel.com>
    i40e: fix: remove needless retries of NVM update

Saeed Mahameed <saeedm@nvidia.com>
    net: ethtool: Fix RSS setting

Chen Ni <nichen@iscas.ac.cn>
    ARM: davinci: Convert comma to semicolon

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Use strnlen() on name fields in V1 wmfw files

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: hda: fix null deref on system suspend entry

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Prevent buffer overrun when processing V2 alg headers

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Validate payload length before processing block

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Return error if block header overflows file

Richard Fitzgerald <rf@opensource.cirrus.com>
    firmware: cs_dsp: Fix overflow checking of wmfw header

Komal Bajaj <quic_kbajaj@quicinc.com>
    arm64: dts: qcom: qdu1000: Fix LLCC reg property

Caleb Connolly <caleb.connolly@linaro.org>
    arm64: dts: qcom: sm6115: add iommu for sdhc_1

Abel Vesa <abel.vesa@linaro.org>
    arm64: dts: qcom: x1e80100: Fix PCIe 6a reg offsets and add MHI

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: allwinner: Fix PMIC interrupt number

Konrad Dybcio <konrad.dybcio@linaro.org>
    arm64: dts: qcom: x1e80100-*: Allocate some CMA buffers

Bjorn Andersson <quic_bjorande@quicinc.com>
    arm64: dts: qcom: sc8180x: Fix LLCC reg property again

Daniel Borkmann <daniel@iogearbox.net>
    net, sunrpc: Remap EPERM in case of connection failure in xs_tcp_setup_socket

Chengen Du <chengen.du@canonical.com>
    net/sched: Fix UAF when resolving a clash

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Set SOCK_RCU_FREE earlier in udp_lib_get_port().

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: prefer nft_chain_validate

Florian Westphal <fw@strlen.de>
    netfilter: nfnetlink_queue: drop bogus WARN_ON

Oleksij Rempel <o.rempel@pengutronix.de>
    ethtool: netlink: do not return SQI value if link is down

Dmitry Antipov <dmantipov@yandex.ru>
    ppp: reject claimed-as-LCP but actually malformed packets

Jian Hui Lee <jianhui.lee@canonical.com>
    net: ethernet: mtk-star-emac: set mac_managed_pm when probing

Eric Dumazet <edumazet@google.com>
    tcp: avoid too many retransmit packets

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Defer work in bpf_timer_cancel_and_free

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fail bpf_timer_cancel when callback is being cancelled

Benjamin Tissoires <bentiss@kernel.org>
    bpf: replace bpf_timer_init with a generic helper

Benjamin Tissoires <bentiss@kernel.org>
    bpf: make timer data struct more generic

Mohammad Shehar Yaar Tausif <sheharyaar48@gmail.com>
    bpf: fix order of args in call to bpf_map_kvcalloc

Matthew Wilcox (Oracle) <willy@infradead.org>
    minixfs: Fix minixfs_rename with HIGHMEM

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: ethernet: lantiq_etop: fix double free in detach

Michal Kubiak <michal.kubiak@intel.com>
    i40e: Fix XDP program unloading while removing the driver

Hugh Dickins <hughd@google.com>
    net: fix rc7's __skb_datagram_iter()

David Lechner <dlechner@baylibre.com>
    spi: add defer_optimize_message controller flag

David Lechner <dlechner@baylibre.com>
    spi: don't unoptimize message in spi_async()

Aleksandr Mishin <amishin@t-argos.ru>
    octeontx2-af: Fix incorrect value output on error path in rvu_check_rsrc_availability()

Geliang Tang <tanggeliang@kylinos.cn>
    skmsg: Skip zero length skb in sk_msg_recvmsg

Oleksij Rempel <o.rempel@pengutronix.de>
    net: phy: microchip: lan87xx: reinit PHY after cable test

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix too early release of tcx_entry

Neal Cardwell <ncardwell@google.com>
    tcp: fix incorrect undo caused by DSACK of TLP retransmit

Dan Carpenter <dan.carpenter@linaro.org>
    net: bcmasp: Fix error code in probe()

Brian Foster <bfoster@redhat.com>
    vfs: don't mod negative dentry count when on shrinker list

linke li <lilinke99@qq.com>
    fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading

Jeff Layton <jlayton@kernel.org>
    filelock: fix potential use-after-free in posix_lock_inode

Christian Eggers <ceggers@arri.de>
    dsa: lan9303: Fix mapping between DSA port number and PHY address

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: lan9303: provide own phylink MAC operations

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: allow DSA switch drivers to provide their own phylink mac ops

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: dsa: introduce dsa_phylink_to_port()

Jingbo Xu <jefflexu@linux.alibaba.com>
    cachefiles: add missing lock protection when polling

Baokun Li <libaokun1@huawei.com>
    cachefiles: cyclic allocation of msg_id to avoid reuse

Hou Tao <houtao1@huawei.com>
    cachefiles: wait for ondemand_object_worker to finish when dropping object

Baokun Li <libaokun1@huawei.com>
    cachefiles: cancel all requests for the object that is being dropped

Baokun Li <libaokun1@huawei.com>
    cachefiles: stop sending new request when dropping object

Baokun Li <libaokun1@huawei.com>
    cachefiles: propagate errors from vfs_getxattr() to avoid infinite loop

David Lechner <dlechner@baylibre.com>
    spi: axi-spi-engine: fix sleep calculation

Yi Liu <yi.l.liu@intel.com>
    vfio/pci: Init the count variable in collecting hot-reset devices

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix ufshcd_abort_one racing issue

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Fix ufshcd_clear_cmd racing issue

Waiman Long <longman@redhat.com>
    mm: prevent derefencing NULL ptr in pfn_section_valid()


-------------

Diffstat:

 Documentation/admin-guide/cifs/usage.rst           |  34 +--
 .../devicetree/bindings/cache/qcom,llcc.yaml       |   2 +-
 Makefile                                           |   4 +-
 arch/arm/mach-davinci/pm.c                         |   2 +-
 .../dts/allwinner/sun50i-h64-remix-mini-pc.dts     |   2 +-
 arch/arm64/boot/dts/qcom/qdu1000.dtsi              |  16 +-
 arch/arm64/boot/dts/qcom/sa8775p.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sc8180x.dtsi              |  11 +-
 .../dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts     |  15 +-
 arch/arm64/boot/dts/qcom/sm6115.dtsi               |   1 +
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts          |  13 +-
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts          |   9 +
 arch/arm64/boot/dts/qcom/x1e80100.dtsi             |  10 +-
 arch/s390/mm/pgalloc.c                             |   4 +
 arch/x86/entry/entry_64_compat.S                   |  14 +-
 drivers/acpi/processor_idle.c                      |  37 ++--
 drivers/char/hpet.c                                |  34 ++-
 drivers/cpufreq/acpi-cpufreq.c                     |   4 +-
 drivers/cpufreq/cpufreq.c                          |   3 +-
 drivers/firmware/cirrus/cs_dsp.c                   | 231 +++++++++++++------
 drivers/i2c/busses/i2c-rcar.c                      |  27 ++-
 drivers/i2c/i2c-core-base.c                        |   1 +
 drivers/i2c/i2c-slave-testunit.c                   |   7 +
 drivers/iio/industrialio-trigger.c                 |   2 +-
 drivers/misc/fastrpc.c                             |  41 +++-
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_otpe2p.c  |   4 -
 drivers/misc/mei/platform-vsc.c                    |   4 +-
 drivers/misc/mei/vsc-tp.c                          |  16 +-
 drivers/mmc/host/davinci_mmc.c                     |   3 +
 drivers/mmc/host/sdhci.c                           |  15 ++
 drivers/net/dsa/lan9303-core.c                     |  54 +++--
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_adminq.h      |   4 -
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   9 +-
 drivers/net/ethernet/lantiq_etop.c                 |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  23 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  12 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |   7 +
 drivers/net/ethernet/micrel/ks8851_common.c        |  10 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |   4 +-
 drivers/net/phy/microchip_t1.c                     |   2 +-
 drivers/net/ppp/ppp_generic.c                      |  15 ++
 drivers/net/wireguard/allowedips.c                 |   4 +-
 drivers/net/wireguard/queueing.h                   |   4 +-
 drivers/net/wireguard/send.c                       |   2 +-
 drivers/nvmem/core.c                               |   7 +-
 drivers/nvmem/meson-efuse.c                        |  14 +-
 drivers/nvmem/rmem.c                               |   5 +-
 drivers/platform/x86/toshiba_acpi.c                |   1 +
 drivers/pmdomain/qcom/rpmhpd.c                     |   7 +
 drivers/scsi/sd.c                                  |   5 +-
 drivers/spi/spi-axi-spi-engine.c                   |  26 ++-
 drivers/spi/spi-mux.c                              |   1 +
 drivers/spi/spi.c                                  |  20 +-
 drivers/tty/serial/imx.c                           |  51 +++++
 drivers/tty/serial/ma35d1_serial.c                 |  13 +-
 drivers/ufs/core/ufs-mcq.c                         |  11 +-
 drivers/ufs/core/ufshcd.c                          |   2 +
 drivers/usb/core/config.c                          |  18 +-
 drivers/usb/core/of.c                              |   7 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   8 +
 drivers/usb/gadget/configfs.c                      |   3 +
 drivers/usb/host/xhci.c                            |  16 +-
 drivers/usb/serial/mos7840.c                       |  45 ++++
 drivers/usb/serial/option.c                        |  38 ++++
 drivers/vfio/pci/vfio_pci_core.c                   |   2 +-
 fs/cachefiles/daemon.c                             |   4 +-
 fs/cachefiles/internal.h                           |   3 +
 fs/cachefiles/ondemand.c                           |  52 ++++-
 fs/cachefiles/xattr.c                              |   5 +-
 fs/dcache.c                                        |  12 +-
 fs/ext4/sysfs.c                                    |   2 +
 fs/locks.c                                         |   2 +-
 fs/minix/namei.c                                   |   3 +-
 fs/nilfs2/dir.c                                    |  32 ++-
 fs/smb/client/cifsglob.h                           |   4 +-
 fs/smb/server/smb2pdu.c                            |  13 +-
 fs/userfaultfd.c                                   |   7 +-
 include/linux/mmzone.h                             |   3 +-
 include/linux/pagemap.h                            |  11 +-
 include/linux/spi/spi.h                            |   4 +
 include/linux/swap.h                               |   3 +-
 include/net/dsa.h                                  |  11 +
 include/net/tcx.h                                  |  13 +-
 include/uapi/misc/fastrpc.h                        |   3 +
 kernel/bpf/bpf_local_storage.c                     |   4 +-
 kernel/bpf/helpers.c                               | 245 +++++++++++++++------
 kernel/sched/deadline.c                            |   7 +-
 kernel/sched/fair.c                                |  12 +-
 mm/damon/core.c                                    |  21 +-
 mm/filemap.c                                       |  10 +-
 mm/memcontrol.c                                    |  11 -
 mm/migrate.c                                       |  13 ++
 mm/readahead.c                                     |   8 +-
 mm/shmem.c                                         |  15 +-
 mm/vmalloc.c                                       |  10 +-
 mm/workingset.c                                    |  14 +-
 net/ceph/mon_client.c                              |  14 +-
 net/core/datagram.c                                |   3 +-
 net/core/skmsg.c                                   |   3 +-
 net/dsa/dsa.c                                      |  11 +
 net/dsa/port.c                                     |  38 +++-
 net/ethtool/ioctl.c                                |   3 +-
 net/ethtool/linkstate.c                            |  41 ++--
 net/ipv4/tcp_input.c                               |  11 +-
 net/ipv4/tcp_timer.c                               |  17 +-
 net/ipv4/udp.c                                     |   4 +-
 net/netfilter/nf_tables_api.c                      | 158 ++-----------
 net/netfilter/nfnetlink_queue.c                    |   2 +-
 net/sched/act_ct.c                                 |   8 +
 net/sched/sch_ingress.c                            |  12 +-
 net/sunrpc/xprtsock.c                              |   7 +
 scripts/ld-version.sh                              |   8 +-
 scripts/package/kernel.spec                        |   1 -
 sound/pci/hda/patch_realtek.c                      |   4 +
 sound/soc/sof/intel/hda-dai.c                      |  12 +-
 tools/testing/selftests/wireguard/qemu/Makefile    |   8 +-
 121 files changed, 1350 insertions(+), 610 deletions(-)


