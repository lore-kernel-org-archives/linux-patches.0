Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585244;
	b=mWW9NOu97aZL50SGtdzGUMPgKAAiPY3ohTizP+DIFUVuwKETFyaP1uZF2wgwieen6Ayo
	 5TOJRV737iIRlb7gBGExdAjdN9yVqECmyVw0DDgkz1vRcoieIl3BO/kTBrnRcsS83GXEi
	 oUoW5y0g2c+kvoVX3AdyF4RjJxsjetIP/skla9IyKZggBM4qTFkACVanV07CzJYMrSw8T
	 uRdyeeind/WWZiAxpfuh8vJ8P9UOGhNSADV1jA8w83e4uV9LXAnznwtDn6475BTaS+FQN
	 sHmLezGjDVgZbNUvFZ4x+2wFq6+3Y+CxamIRtWLOcWsAijD6gXujMknwT9p3gnNv8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=738jW1gpQt7vdTu6z7Usc8QaJhtbjZPlT5iYDASm5vI=;
	b=TYQbUDQScu3haKTQTivz2DUojHHBXqolQMb4c0Wi3ZzNrbx1jphx/0l2y4QsYKIEK/or
	 uRVtCwbjsWinUYR02+hEE8pKaagNwJfjFx8nMb0iR5fBJ9d5vLF4xhZWRSaLTG2/JAKg5
	 hJ3V4wElIBbXQ1952f1igu32bBEf19PTFf6HS48ZyObAQLrazjqYIDcTmjTSYC7KkXzVA
	 4C9unGzL4wiirG5y+65+3r698aQrMYJZ5OPzQZyLGVzpOBTe6WMgLmPDOYj2v+Ev9Px7k
	 BLdHmcGnQ1LsfRBXlqDBkoEFglitG+toRGoLj2VeI7BFeJ9/5ji2wftfUvWtmWPv/fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLaNRB3a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A321606A330;
	Fri, 13 Nov 2026 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLaNRB3a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFAD1F000C4;
	Fri, 13 Nov 2026 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585244;
	bh=738jW1gpQt7vdTu6z7Usc8QaJhtbjZPlT5iYDASm5vI=;
	h=From:To:Cc:Subject:Date;
	b=OLaNRB3aXZPFdX0Q0t3x7TFMryMwijO69M8dGe4OtjuS6BkGm70H5TApYbh+PNFTQ
	 mC14HTU970JElUTcUyYBL/dTpSXqrne89nbQeO/1RB9ioVHN42pXqiUX3l7A0h/hEk
	 0QoiqeVVd6ZcoXqwNF74hi+XyNTu6NYhjReuXTgo=
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
Subject: [PATCH 6.18 000/686] 6.18.64-rc1 review
Date: Fri, 13 Nov 2026 10:42:13 -0500
Message-ID: <20261113153820.902362109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.64-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.64-rc1
X-KernelTest-Deadline: 2026-11-15T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.64 release.
There are 686 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.64-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.64-rc1

José Miguel Castellanos Valladolid <josstamy@gmail.com>
    ALSA: hda/realtek: Enable mute LEDs on HP OmniBook X Flip 14-fm0xxx

Jaeho Cho <jaeho2025@gmail.com>
    ALSA: hda/realtek: Enable mute LEDs on HP OmniBook 7 17-dc0xxx

Gianluca Balboni <gianluca.balboni06@gmail.com>
    ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx

Armaan Sandhu <armaan.sandhu0504@gmail.com>
    lib/cmdline: fix get_options() count and overflow with large ranges

Shuvam Pandey <shuvampandey1@gmail.com>
    lib/tests: extend cmdline KUnit with next_arg() tests

Wang Yan <wangyan01@kylinos.cn>
    selftests/landlock: Fix snprintf truncation checks in test files

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Free the parse error entries when parsing fails

Karl Mehltretter <kmehltretter@gmail.com>
    fbdev: sh_mobile_lcdcfb: Restore the per-overlay sysfs attributes

Chintan Patel <chintanlike@gmail.com>
    fbdev: sh_mobile_lcdc: Make FB_DEVICE dependency optional

Chintan Patel <chintanlike@gmail.com>
    fb: Add dev_of_fbinfo() helper for optional sysfs support

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmf: Add AMDI0112 ACPI ID

Myeonghun Pak <mhun512@gmail.com>
    fbdev: nvidia: Release write-combining handle on probe failure

Shixiong Ou <oushixiong@kylinos.cn>
    fbdev: nvidia: Convert to managed PCI and ioremap API

Wentao Liang <vulab@iscas.ac.cn>
    power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()

Au Dang <au.dang.jx@renesas.com>
    irqchip/renesas-rzv2h: Preserve TIEN state in rzv2h_tint_set_type()

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: omap-sham - fix crypto engine cleanup

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: omap - add omap_sham_unregister_algs helper

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    hwmon: (coretemp) Return -ENODATA for invalid temperature readings

Andrea Parri <parri.andrea@gmail.com>
    iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: avoid broken uffd merge on mremap

David Carlier <devnexen@gmail.com>
    media: ipu6: Fix firmware config leak on stream start

Antti Laakso <antti.laakso@linux.intel.com>
    media: ipu6: Rename pointer to firmware context

Daeho Jeong <daehojeong@google.com>
    f2fs: release a removed xattr node in roll-forward recovery

Miquel Raynal <miquel.raynal@bootlin.com>
    clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: clock: ma35d1: Add missing WDT/WWDT parent clocks

Miquel Raynal <miquel.raynal@bootlin.com>
    dt-bindings: clock: ma35d1: Drop CLK_MAX_IDX define

Miquel Raynal <miquel.raynal@bootlin.com>
    clk: nuvoton: ma35d1: Keep the clock count in the driver

Sumit Kumar <sumit.kumar@oss.qualcomm.com>
    PCI: dwc: Set DMA_BYPASS bit in outbound IATU CTRL2 register

David Hildenbrand (Arm) <david@kernel.org>
    mm/huge_memory: split huge PUDs when adjusting VMA boundaries

Rudi Heitbaum <rudi@heitbaum.com>
    PCI: imx6: Avoid dereferencing a NULL clock name

Hung-Jui Lin <alex.lin.programmer@gmail.com>
    posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers

Thomas Gleixner <tglx@kernel.org>
    posix-timers: Handle the timer_[re]arm() return value

Evgeny Akhtimirov <evgeny@devduty.com>
    ALSA: hda/realtek: Enable all four speaker amps on Lenovo ThinkBook X G2 IAH

Bradley Morgan <brads@mainlining.org>
    panic: restore variable arguments to nmi_panic()

Steve Wahl <steve.wahl@hpe.com>
    watchdog/hpwdt: Refine hpwdt message for UV platform

Yingjie Wang <1075151112@qq.com>
    nvme-tcp: validate the TLS handshake timeout

Yingjie Wang <1075151112@qq.com>
    nvmet-tcp: validate the TLS handshake timeout

Borislav Petkov (AMD) <bp@alien8.de>
    Documentation/kernel-parameters: Move the kernel build options

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Don't init & online empty nodes

Chao Yu <chao@kernel.org>
    f2fs: fix to invalidate curseg if change_curseg() fails

David Carlier <devnexen@gmail.com>
    mm/shmem: don't release a swapin-error marker as a swap entry

Christian Brauner <brauner@kernel.org>
    iomap: don't mark unwritten parts of a folio uptodate

Linmao Li <lilinmao@kylinos.cn>
    PCI: cadence: Store the core controller in platform drvdata

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    arm64/gcs: release GCS on failed fork

Giorgi Kobakhia <gkobakhi@asu.edu>
    ocfs2: fix array out of bound access in __ocfs2_find_path()

Edward Adam Davis <eadavis@qq.com>
    ocfs2: fix oob in __ocfs2_find_path

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix one-shot limitation for perf hardware breakpoints

Nikolaos Karaolidis <nick@karaolidis.com>
    fs: don't lose inodes that another LRU walker is isolating

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Restore the codec device type on unbind

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Allocate the private data at codec driver bind

Hongfu Li <lihongfu@kylinos.cn>
    mm/memfd: fix hugetlb reservation accounting in error paths

Jinmeng Zhou <jinmengzhou22@gmail.com>
    mm/hugetlb: charge folios to the target mm's memcg

Josef Bacik <josef@toxicpanda.com>
    mm/vma: don't leak the commit charge on mmap failure

Hongfu Li <lihongfu@kylinos.cn>
    mm/memcg: migrate per-node hugetlb lruvec stat together with hugetlb folio

Ye Liu <ye.liu@linux.dev>
    mm: use enum migrate_reason instead of int for migration reason parameters

Qi Zheng <zhengqi.arch@bytedance.com>
    mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()

Nikolaos Karaolidis <nick@karaolidis.com>
    fs: rotate inodes whose page cache could not be dropped

Jan Kara <jack@suse.cz>
    fs: Ignore inode metadata buffers in inode_lru_isolate()

Mateusz Guzik <mjguzik@gmail.com>
    fs: provide accessors for ->i_state

Mateusz Guzik <mjguzik@gmail.com>
    fs: spell out fenced ->i_state accesses with explicit smp_wmb/smp_rmb

Mateusz Guzik <mjguzik@gmail.com>
    fs: add missing fences to I_NEW handling

Mateusz Guzik <mjguzik@gmail.com>
    fs: assert on ->i_count in iput_final()

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    tpm: tpm2_probe: propagate transport errors

Alexey Charkov <alchark@flipper.net>
    nvmem: rockchip-otp: Serialize reads

Rosen Penev <rosenp@gmail.com>
    nvmem: rockchip-otp: alloc clks with main struct

Ming Lei <tom.leiming@gmail.com>
    ublk: mark the io command cancelable before publishing it

Gregory Price <gourry@gourry.net>
    mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()

Wentao Liang <vulab@iscas.ac.cn>
    xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()

Ackerley Tng <ackerleytng@google.com>
    mm: hugetlb: drop refcount before freeing on memcg charge failure

Ackerley Tng <ackerleytng@google.com>
    mm: hugetlb: return -ENOSPC on memcg charge failure

Yao Yiqi <yaoyiqi3@huawei.com>
    fbcon: Retry rotated font allocation after failure

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: ad4080: enable address ascension for chip identification

Rong Zhang <i@rong.moe>
    platform/x86: lenovo-wmi-capdata: Do not stop the AC notifier chain on error

Rong Zhang <i@rong.moe>
    platform/x86: Rename lenovo-wmi-capdata01 to lenovo-wmi-capdata

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Stop the target vcpu when disabling LPIs

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf evsel: Close the fds opened so far when disabling missing features

Hui Su <sh_def@163.com>
    perf evsel: Restrict incremental open error unwind

Art O Cathain <art.home@gmail.com>
    ASoC: amd: acp-config: force SoundWire probe on Dell 14S DS14265

Sehat Mahde <hskmahde@gmail.com>
    ASoC: amd: acp-config: force SoundWire probe on HP OmniBook X Flip 16

Jackie Dong <xy-jackie@139.com>
    ASoC: amd: acp: Add DMI quirk for Lenovo Yoga Pro 7 15ASH11

Jasper Smet <josbeir@gmail.com>
    ASoC: amd: acp: Add DMI quirk for ASUS Zenbook S16 UM5606GA

Hasun Park <hasunpark@gmail.com>
    ASoC: amd: acp: add DMI override for ACP70 flag

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: move the channel survey when the channel changes

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: mt7921: assert sniffer on chanctx change

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs

Chao Yu <chao@kernel.org>
    f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()

Tal Zussman <tz2294@columbia.edu>
    block: introduce bio_in_atomic()

Kaixuan Li <kaixuanli0131@gmail.com>
    f2fs: bound the SIT/NAT bitmaps by the checkpoint pack

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: advance valid_size to EOF for append writes

Andrea Parri <parri.andrea@gmail.com>
    iomap: don't lose a failed direct I/O bio's error when zeroing the tail

Pankaj Raghav <p.raghav@samsung.com>
    iomap: use largest_zero_folio() in iomap_dio_zero()

Vladyslav Tymoshchuk <tvlad744@gmail.com>
    ASoC: qcom: q6apm-dai: wrap the position of a full ring to 0

Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
    media: iris: Fix power-off ordering to disable power domain after clocks

Martin Fuzzey <martin.fuzzey@flowbird.group>
    serial: sc16is7xx: fix data corruption due to unexpected xon/xoff

Sinan Turunc <enscrpt@pm.me>
    ALSA: ua101: Bound packet copies by the PCM buffer size

Ruide Cao <caoruide123@gmail.com>
    mptcp: fix MP_CAPABLE token migration when cloning reqsk

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    rculist: Add hlist_nulls_replace_rcu() and hlist_nulls_replace_init_rcu()

Sung Byeongchan <tjdqudcks0424@naver.com>
    virtiofs: validate fixed-output response length

Yuto Ohnuki <ytohnuki@amazon.com>
    virtiofs: add FUSE protocol validation

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: declare MCR and IER as volatile registers

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: add comments for lock requirements

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: declare SPR/TLR/XOFF2 register as volatile

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Add error cleanup in zpci_directed_irq_init()

Darrick J. Wong <djwong@kernel.org>
    xfarray: don't crash when sorting if array element crosses a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    xfs: Use folio_next_pos()

Matthew Wilcox (Oracle) <willy@infradead.org>
    filemap: Add folio_next_pos()

Fan Wu <fanwu01@zju.edu.cn>
    media: rockchip: rga: quiesce IRQ before releasing m2m state

Sven Püschel <s.pueschel@pengutronix.de>
    media: rockchip: rga: use clk_bulk api

Marc Zyngier <maz@kernel.org>
    KVM: arm64: nv: Move L2->L1 switch on interrupt early

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex

Ma Ke <make_ruc2021@163.com>
    ALSA: hda: cs35l41: Fix ACPI device reference leak on probe failure

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: cs35l41: Use auto-cleanup for put_device()

Myeonghun Pak <mhun512@gmail.com>
    mfd: twl-core: Unregister the auxiliary platform device on unbind

Thorsten Blum <thorsten.blum@linux.dev>
    mfd: twl-core: Use i2c_check_functionality as boolean value

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm:restate all customized OD features on every table upload for smu 13.0.0/smu 14.0.2

Daeho Jeong <daehojeong@google.com>
    f2fs: return -EIO for a lost inode block after cp_error

Ridong Chen <chenridong@xiaomi.com>
    mm/mglru: fix ineffective memory protection for non-kswapd reclaim

Tejun Heo <tj@kernel.org>
    cgroup: Expose some cgroup helpers

Chao Yu <chao@kernel.org>
    f2fs: zone: fix to avoid bio split on sequential zone

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ata: sata_inic162x: remove dangerous broken driver

Bart Van Assche <bvanassche@acm.org>
    ata: libata: Add an argument to ata_eh_reset()

Li RongQing <lirongqing@baidu.com>
    vfio/pci: Restore 8-byte ioeventfd support

Karl Mehltretter <kmehltretter@gmail.com>
    spi: atmel-quadspi: balance runtime PM and pclk across system sleep

Robert Marko <robert.marko@sartura.hr>
    spi: atmel-quadspi: use init callback for gclk variants

Robert Marko <robert.marko@sartura.hr>
    spi: atmel-quadspi: add controller init callback

Matej Sochan <matej.sochan@gmail.com>
    ALSA: hda/realtek: Fix silent speakers on Lenovo Legion S7 15IMH05

Nicholas Bonello <hadobedo@gmail.com>
    ALSA: hda/realtek: Fix Legion 7 16ITHG6 speaker amp binding

Rámon van Raaij <ramon@vanraaij.eu>
    ALSA: hda/realtek: Add codec SSID quirk for Lenovo Yoga Pro 9 16IMH9

Jiale Yao <yaojiale02@163.com>
    iio: dac: mcp4821: reject devices without match data

Myeonghun Pak <mhun512@gmail.com>
    ASoC: stm: stm32_i2s: request IRQ after regmap initialization

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: stm: stm32_i2s: Drop redundant error messages

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: free interrupt before the clock in error path

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (tmp108) Fix jiffies wraparound in conversion-ready check

Yunpeng Tian <shionthanatos@gmail.com>
    udf: validate the device specification EA before using it

Chris Mason <mason@kernel.org>
    ovl: fail the mount if the casefold flag has changed

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: widen the ATIM window while an AP interface is up

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue

Mehmet Fide <mehmet.fide@screeningeagle.com>
    wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery

Martin Belanger <martin.belanger@dell.com>
    nvme-tcp: skip TLS control records while waiting for the ICResp

Zhiling Zou <zhilinz@nebusec.ai>
    ipmr: only copy pktinfo to cache reports

Eric Dumazet <edumazet@google.com>
    ipmr: prevent info-leak in pmr_cache_report()

Baolin Wang <baolin.wang@linux.alibaba.com>
    mm: memory: fix truncation removing mapped folios

Weibin Liu <liuwb@xiaopeng.com>
    spi: cadence-xspi: reject SDMA transfers larger than the requested length

Jisheng Zhang <jszhang@kernel.org>
    spi: cadence-xspi: group marvell support code together

Hans Zhang <18255117159@163.com>
    spi: cadence-xspi: Use FIELD_MODIFY()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: cadence-xspi: Replace ACPI specifics by agnostic APIs

Chris Mason <mason@kernel.org>
    mm/shmem: honour F_SEAL_EXEC when an ACL is set

Kyle Zeng <kylebot@openai.com>
    mm/page_vma_mapped: continue past nonmatching huge PMDs

Jiangshan Yi <yijiangshan@kylinos.cn>
    ceph: fix longname buffer overflow in ceph_fname_to_usr()

David Hildenbrand (Arm) <david@kernel.org>
    mm/userfaultfd: only allocate anon_vma in CoW mappings

Josef Bacik <josef@toxicpanda.com>
    mm/hugetlb: unmap the page where the other VMA maps it

Yuejie Shi <syjcnss@gmail.com>
    fs/ntfs3: validate the EA value length in ntfs_read_ea()

Vaibhav Nagare <vnagare@redhat.com>
    bnxt_en: don't leave an XDP program installed when the open fails

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Refactor some basic ring setup and adjustment logic

Jun Yang <junvyyang@tencent.com>
    sctp: re-point retained control chunks on association migration

David Lee <david.lee@trailofbits.com>
    sctp: hold shkey across socket migration

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM

Dave Jiang <dave.jiang@intel.com>
    cxl/port: Clear cached dport pointers when a dport is removed

Dan Williams <dan.j.williams@intel.com>
    cxl/port: Cleanup handling of the nr_dports 0 -> 1 transition

Yifei Gao <gyf161023@gmail.com>
    misc: fastrpc: fix double-free in fastrpc_map_attach() error path

Kumari Pallavi <kumari.pallavi@oss.qualcomm.com>
    misc: fastrpc: Rename phys to dma_addr for clarity

Ming Lei <tom.leiming@gmail.com>
    ublk: keep a canceled FETCH round canceling until the server is gone

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Establish memslot<=>guest_memfd bindings *after* memslot is ready

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: ov5647: fix power cleanup on remove

Sean Young <sean@mess.org>
    media: redrat3: Error path leaves device in transmitting state

Esben Haabendal <esben@geanix.com>
    iio: light: ltr501: Power down chip if request irq fails

Pan Chuang <panchuang@vivo.com>
    iio: light: Remove redundant dev_err()/dev_err_probe()

Chao Yu <chao@kernel.org>
    f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: Add TCEs for 16GB pages when RAM is pre-mapped

Christopher Lusk <clusk@northecho.dev>
    m68k: Fix seccomp filtering on ColdFire and 68000

Daniel Palmer <daniel@0x0f.com>
    m68k: Fix task info flags handling for 68000

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid folio->mapping dereference in is_{meta, node}_folio()

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: og01a1b: power off sensor on remove

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Switch from .s_stream to .enable_streams/.disable_streams

Jiaming Zhang <r772577952@gmail.com>
    gfs2: reject invalid inode sizes

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: usb-audio: Protect Roland control activation

Nicholas Hobson <nicholas.hobson@outlook.com>
    ALSA: usb-audio: keep MIDI input running for Roland TD-11

Danish Khateeb <danishkhateeb03@gmail.com>
    ALSA: timer: Handle userspace-driven timer ioctls from 32-bit tasks

bui duc phuc <phucduc.bui@gmail.com>
    ALSA: core: Clean up file_operations definitions

Jiale Yao <yaojiale02@163.com>
    iio: adc: ad7192: reject devices without match data

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: adc: ad7192: Revert "properly check spi_get_device_match_data()"

Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
    media: iris: Fix iova allocation from restrict region

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Account for rate_factor in control steps

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Account rate_factor in setting upper exposure limit

Tarang Raval <tarang.raval@siliconsignals.io>
    media: i2c: imx219: Replace exposure magic value with named constant

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix SBGGR10 Bayer pattern

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix ISC_PFG_CFG0_BPS macro name typo

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: store the unshifted PFE_CFG0 BPS value

Wei-Lin Chang <weilin.chang@arm.com>
    KVM: arm64: ptdump: Check the page tables aren't freed when accessing

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()

Fabio Cesari <fabio.cesari@gmail.com>
    iio: light: isl29028: fix runtime PM reference leak on error paths

Sang-Heon Jeon <ekffu200098@gmail.com>
    iio: light: isl29028: remove isl29028_set_pm_runtime_busy() helper

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Split bind() into prepare()+commit() phases

Hans de Goede <johannes.goede@oss.qualcomm.com>
    platform/x86: int3472: Increase handshake GPIO delay to 200 ms

Tarang Raval <tarang.raval@siliconsignals.io>
    platform: int3472: discrete: Support multiple HIDs per GPIO map entry

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Manage virtual NTB and PCI bus lifetime

Abel Vesa <abel.vesa@linaro.org>
    soc: qcom: pmic_glink: Fix device access from worker during suspend

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: The horizontal blanking step is 8

Tarang Raval <tarang.raval@siliconsignals.io>
    media: i2c: imx219: Propagate errors from control range updates

Cheng Ming Lin <chengminglin@mxic.com.tw>
    mtd: spi-nor: macronix: Restore fallback parameters for MX25L12805D

Maxi Saparov <masaparov@coreweave.com>
    kho: do not reserve scratch memory in the kdump kernel

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips: Disable Octeon SHA code on little-endian kernels

Abhishek Dubey <adubey@linux.ibm.com>
    powerpc/bpf: fix buffer overflow in JIT for large BPF programs

Zhao Gongyi <zhaogongyi@bytedance.com>
    ata: libata-scsi: reject data-in commands with a data-out buffer

Michal Blaszczyk <michalblk@google.com>
    sched_ext: Reset runnable_at when a task leaves its scheduler

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw, isotp: copy socket options outside of lock_sock()

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: don't drop local events queued during TVLV update

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: only update flags for TT events

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: ignore ROAM flag of received ADD changes

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: send ROAM_ADV on each roamed back client

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: clear ROAM flag when re-adding a pending local client

Sven Eckelmann <sven@narfation.org>
    batman-adv: tt: only transmit local ROAM flag together with DEL

Sven Eckelmann <sven@narfation.org>
    batman-adv: tpmeter: fix u32 truncation of reported bytes

SJ Park <sj@kernel.org>
    mm/damon/core: move static variable last_nr_regions to damon_ctx

Ido Schimmel <idosch@nvidia.com>
    vxlan: Stop rejecting dynamic FDB entries with a nexthop ID

Daehyeon Ko <4ncienth@gmail.com>
    timekeeping: Require permission to set auxiliary clocks

Hamid Nassiby <hamid.nassiby@nokia.com>
    Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"

Guanglei Zhu <zhugl3@xiaopeng.com>
    ceph: clamp the inline data length in ceph_fill_inline_data()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: protect the receive lists with a per-device lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: replace ARPHRD_CAN type checks with can_get_ml_priv()

Sasha Levin <sashal@kernel.org>
    Revert "hugetlb: remove VMEMMAP_SYNCHRONIZE_RCU"

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Force device table to maximum size

Chris Mason <mason@kernel.org>
    x86/mm: Fix global ASID handed out to two processes

Marco Ziliani <rylos78@gmail.com>
    ata: libata-pmp: disable the SEMB port on Marvell 88SM9705

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Preserve the interrupted context's exception registers

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Run the event handler on the kernel vectors

Thorsten Blum <blum@kernel.org>
    x86/boot: Fix off-by-one error in sme_clear_pgd()

Jinjie Ruan <ruanjinjie@huawei.com>
    arm64: kexec_file: Fix elf_headers memory leak in retry loop

Akshay Jindal <Akshay.Jindal@amd.com>
    iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions

Breno Leitao <leitao@debian.org>
    x86/nmi: Ignore negative NMI handler durations

Danish Khateeb <danishkhateeb03@gmail.com>
    perf/core: Don't send SIGTRAP after exec removed the event

Shao Mingyin <shao.mingyin@zte.com.cn>
    nvmet: bound the traddr and trsvcid configfs writes

Qiliang Yuan <odys.yuan@gmail.com>
    nvme: wait for SRCU readers before splicing the namespace list

Qiliang Yuan <odys.yuan@gmail.com>
    srcu: Add list_splice_init_srcu()

Imre Kaloz <kaloz@kernel.org>
    MIPS: sgi-ip32: Leave MACE PCI control alone in config accesses

Imre Kaloz <kaloz@kernel.org>
    MIPS: sgi-ip32: Mask MACE PCI interrupts in CRIME only

Imre Kaloz <kaloz@kernel.org>
    MIPS: mm: Fix the cache error vector jump for XKPHYS kernels

Matthias Goergens <matthias.goergens@gmail.com>
    udf: don't use eloc after the end of the unallocated space table

Matthias Goergens <matthias.goergens@gmail.com>
    udf: fix preallocation discarding before an empty allocation extent

Matthias Goergens <matthias.goergens@gmail.com>
    udf: check the unallocated space table when it is loaded

Matthias Goergens <matthias.goergens@gmail.com>
    udf: don't let the extent type hide an exhausted free-space table extent

Kyle Zeng <kylebot@openai.com>
    mptcp: pm: kernel: use RCU to free endpoint listeners

Christian Gmeiner <cgmeiner@igalia.com>
    drm/etnaviv: Flush the tile status cache through both the PE and BLT

James Clark <jjc@jclark.com>
    net: ethernet: ti: am65-cpsw-nuss: Enable timestamping of unicast PTP packets

Ray Zhang <sgzhang@google.com>
    net: count last skb of each sk_backlog pass in __release_sock()

Bryam Vargas <hexlabsecurity@proton.me>
    net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data

Hungyu Lin <dennylin0707@gmail.com>
    ext2: preserve IOMAP_F_DIRTY for extending direct writes

Sinan Turunc <enscrpt@pm.me>
    ALSA: usx2y: Guard the playback copy

Sinan Turunc <enscrpt@pm.me>
    ALSA: usx2y: Require a buffer of two URBs

Wentao Liang <vulab@iscas.ac.cn>
    ALSA: caiaq: free the EP4 URB when input setup fails

Sinan Turunc <enscrpt@pm.me>
    ALSA: line6: Reject capture buffers smaller than two packets

Mohamed Yassine Jebabli <med.jebabli@gmail.com>
    ALSA: hda/tas2781: Only accept CRC-less V1 data if all entries are valid

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: usx2y: Refuse a retried DSP load after a failure

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close

Alex Kazinsky <a.kazinsky@ideco.ru>
    ALSA: cs46xx: Handle SCB creation failures before dereferencing

Chris Simpson <chris@nilk.net>
    ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3

HyeongJun An <sammiee5311@gmail.com>
    ALSA: ump: Fix dropped data bytes at UMP System message conversion

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts

Finn Zeruhn <fzeruhn@icloud.com>
    drm/dp: keep MOT set between messages when no_zero_sized is set

Rosen Penev <rosenp@gmail.com>
    drm/nouveau/nvkm: clear use.enabled when subdev init fails

Hengyu Liang <hengyul@cs.unc.edu>
    l2tp: only return sessions of the given tunnel in l2tp_session_get()

Chris Mason <mason@kernel.org>
    ovl: look up the index by the decoded origin

Sasha Levin <sashal@kernel.org>
    nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for KIOXIA XG10d

Zhao Gongyi <zhaogongyi@bytedance.com>
    arm64: mm: validate /dev/mem mmap ranges without overflow

Wei Wang <wvw@google.com>
    arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend

Ewan D. Milne <emilne@redhat.com>
    nvmet: don't return memory contents beyond valid data when reading ANA log page

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: don't drop the gang dependency fence twice

renpanpan <renpanpan@kylinos.cn>
    drm/amdgpu: Only enable HDMI audio if display supports it

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: drop the dma-buf reference when a KFD import fails

Hugo Sales <hugo@hsal.es>
    drm/amdgpu: Clamp the ATIF backlight curve to its 99 points

Erhan Bilgili <erhan.bilgili@gmail.com>
    drm/amdgpu: Report MES ring wait timeouts.

Erhan Bilgili <erhan.bilgili@gmail.com>
    drm/amdgpu: Fix duplicate dependency fence releases

Kylie C <kyliepc@proton.me>
    drm/amd/display: Don't select zero V_TOTAL_MIN/MAX on seamless boot

Matthew Schwartz <matthew.schwartz@linux.dev>
    drm/amd/display: Keep the nominal vtotal while VRR is inactive

Misha Nasledov <misha@nasledov.com>
    drm/amd/display: Drop clock requirements on DCN32 when no displays are active

Roman Demidov <roman.demidov.nn@gmail.com>
    drm/amd/display: Fix NULL deref in dcn401_update_clocks_update_dtb_dto

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu/gfx12: disallow GFXOFF while updating the SPM VMID

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Avoid closing unowned DDC pins

Milan Milicevic <Milan.Milicevic@amd.com>
    drm/amdgpu: publish IH enabled before PSP programs IH_RB_CNTL

Milan Milicevic <Milan.Milicevic@amd.com>
    drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih

Prike Liang <Prike.Liang@amd.com>
    drm/amdgpu: finish GPU recovery callbacks before restarting schedulers

Dariusz Marcinkiewicz <darekm@google.com>
    drm/amdgpu: check amdgpu_vm_ready() in dma-buf move notify

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdkfd: use the queue's process info for the WPTR BO eviction fence

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: keep the CS user fence BO in GTT

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Check cs flags.

Jarkko Sakkinen <jarkko@kernel.org>
    nvme-keyring: Add a missing key_put() call to nvme_tls_key_lookup()

Yitang Yang <yi1tang.yang@gmail.com>
    ublk: add missing DEL_DEV_ASYNC to unprivileged permission check

Yilin Zhang <yilinzhang@moonshot.ai>
    mptcp: do not use Fast Open on MP_JOIN subflows

Daehyeon Ko <4ncienth@gmail.com>
    vhost/vsock: size receive SKBs from declared payload

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: clamp skb->queue_mapping before indexing the tx queue

Chris Mason <mason@kernel.org>
    ovl: do not let chattr change the casefold flag

Xia Yan <yanxia@cmss.chinamobile.com>
    ipv6: fix device binding after failed datagram connect

Samiullah Khawaja <skhawaja@google.com>
    mm/gup: check folio->mapping under folio lock in memfd_pin_folios()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    mm/huge_memory: set the mmu_gather page size in zap_huge_pud()

David Hildenbrand (Arm) <david@kernel.org>
    mm/memory-tiers: unregister empty tiers outside memory_tier_lock

Chris Mason <mason@kernel.org>
    mm/vma: call ->may_split() before a partial merge

David Hildenbrand (Arm) <david@kernel.org>
    mm/ksm: reset the unstable trees of all nodes

Chris Mason <mason@kernel.org>
    mm: fix unkillable fault loop on MAP_DROPPABLE memory

Josef Bacik <josef@toxicpanda.com>
    mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit

Chris Mason <mason@kernel.org>
    mm/memory: reject remote COW faults on PFN mappings

David Hildenbrand (Arm) <david@kernel.org>
    mm/madvise: fix data loss from MADV_FREE on a KSM page

Josef Bacik <josef@toxicpanda.com>
    mm/mremap: fix moving PUD leaves

David Hildenbrand (Arm) <david@kernel.org>
    mm/mremap: recheck PUDs under the page table lock

David Hildenbrand (Arm) <david@kernel.org>
    mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs

Chris Mason <mason@kernel.org>
    mm/mmu_notifier: set ->mm only after mmgrab()

Josef Bacik <josef@toxicpanda.com>
    mm/mmu_notifier: finish non-blocking interval invalidation on error

Josef Bacik <josef@toxicpanda.com>
    mm/mmu_gather: fix flushing ranges with 4 GiB or larger

David Hildenbrand (Arm) <david@kernel.org>
    mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast

Chris Mason <mason@kernel.org>
    mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast

Chris Mason <mason@kernel.org>
    mm/gup: fix clearing folios in memfd_pin_folios()

David Hildenbrand (Arm) <david@kernel.org>
    mm/gup: recheck the PUD under PTL in follow_pud_mask()

Chris Mason <mason@kernel.org>
    mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs

Josef Bacik <josef@toxicpanda.com>
    mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()

Josef Bacik <josef@toxicpanda.com>
    mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()

Liu Changjie <liucj1228@outlook.com>
    can: peak_usb: pcan_usb_fd_decode_buf(): accept short uCAN end-of-list records

ChunYuZhiQiang <chunyuzhiqiang@yinhe.ht>
    can: dev: can_fill_info(): don't wake up controller if interface is down

Oliver Hartkopp <socketcan@hartkopp.net>
    can: proc: skip stats calculation after reset in can_stat_update()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    can: proc: reset pkg_stats atomics individually

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: check the return values of can_rx_register() in isotp_bind()

Cunhao Lu <1579567540@qq.com>
    can: dev: can_put_echo_skb(): free skb on invalid echo index

Kaixuan Li <kaixuanli0131@gmail.com>
    can: isotp: check the frame type, not just the length

Yingjie Wang <1075151112@qq.com>
    nvmet: reject keep-alive timeouts that would overflow

Christoph Hellwig <hch@lst.de>
    xfs: fix recovery of partial attr removals

Hyunwoo Kim <imv4bel@gmail.com>
    net: restore refcount ordering for lockless socket access

Daejun Park <daejun7.park@samsung.com>
    xfs: clamp the pNFS layout range to the maximum file size

Daejun Park <daejun7.park@samsung.com>
    xfs: cap the block count of xfs_iomap_write_direct() at one extent

Daejun Park <daejun7.park@samsung.com>
    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end

Daejun Park <daejun7.park@samsung.com>
    xfs: add a flag to convert unwritten extents without allocating blocks

Daejun Park <daejun7.park@samsung.com>
    xfs: mark the inode preallocated for pNFS write layouts past EOF

Zhe Liu <liuzhe1@kylinos.cn>
    blk-iocost: account flush sequence latency only once

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    blk-mq: fix out-of-bounds read in blk_mq_free_rqs

Reid Downing <skibletz@gmail.com>
    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

Hungyu Lin <dennylin0707@gmail.com>
    block: Return the soft block size for compat BLKBSZGET

Cong Zhang <cong.zhang@oss.qualcomm.com>
    virtio_blk: use synchronous quiesce in virtblk_freeze_priv()

Josef Bacik <josef@toxicpanda.com>
    blk-mq: end the request if getting a keyslot fails

Hungyu Lin <dennylin0707@gmail.com>
    inotify: do not coalesce rename events

chenglong.ma <longpareto@gmail.com>
    vduse: fix VA/PA confusion in the coherent page fault path

Thorsten Blum <blum@kernel.org>
    hwrng: virtio - prevent use-after-free after a failed restore

Esben Haabendal <esben@geanix.com>
    drm/bridge: nwl-dsi: Limit LCDIF specific sync override

Esben Haabendal <esben@geanix.com>
    drm/bridge: nwl-dsi: Cleanup endpoint mux control selection

Yuho Choi <oss.patchbox@gmail.com>
    vdpa/snet: Don't discard the DPU error in snet_send_ctrl_msg()

Yuho Choi <oss.patchbox@gmail.com>
    iommu/virtio: Reset device before deleting virtqueues on probe failure

Fang Xieyan <fangxy@xiaopeng.com>
    vhost: fix used ring index wrap in vhost_add_used_n_in_order

Shubham Antil <shubham@octane.security>
    vhost-scsi: zero misaligned I/O bounce pages

Kyle Zeng <kylebot@openai.com>
    net/sched: sch_qfq: prevent aggregate self-replacement

Jianyun Gao <jianyungao89@gmail.com>
    xfs: fix temporary cursor leak in btree shift corruption paths

Naman Jain <namjain@linux.microsoft.com>
    x86/init: Initialize wall clock in get_rtc_noop()

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: cache the mount context for dentry lock callbacks

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: wait for filecheck kobject release after a failed add

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/cluster: unlink socket containers before releasing resources

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: stop recovery before shutting down local allocators

Cen Zhang <zzzccc427@gmail.com>
    ocfs2/dlm: serialize migration MLE cleanup on failure

Cen Zhang <zzzccc427@gmail.com>
    ocfs2: keep locking_state within the cluster connection lifetime

Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
    fat: hold truncate_lock in fat_write_failed()

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not read the entry array of an empty xattr block

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not index before the entry array when dividing an empty bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: do not read the entry array of an empty xattr bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: find the xattr entry again after converting a block to a bucket

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: find the xattr entry again after defragmenting a bucket

Andrew Morton <akpm@linux-foundation.org>
    openrisc: export __mulsi3 for modules

T.J. Mercier <tjmercier@google.com>
    mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg

Mike Rapoport (Microsoft) <rppt@kernel.org>
    mm/cma: accept memory of CMA areas reserved at a fixed address

Mike Rapoport (Microsoft) <rppt@kernel.org>
    mm/cma: accept memory of multi-range CMA areas

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: update VMA iterator state on error in new VMA merge

Yafang Shao <laoar.shao@gmail.com>
    mm/migrate: snapshot the source nid before the misplaced migration

Hungyu Lin <dennylin0707@gmail.com>
    mm/migrate: untag addresses when querying page nodes

Chris Down <chris@chrisdown.name>
    mm: make swapoff interruptible when unusing mms/shmem

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()

Hengyu Liang <hengyul@cs.unc.edu>
    fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls

Samarth Narang <samarth.colleges@gmail.com>
    mm/ksm: keep soft-dirty when merging a page

Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
    mm/page_alloc: mark pages freed by __free_pages_core() as not tagged

Li Zhe <lizhe.67@bytedance.com>
    mm/hugetlb: fix mremap deadlock when PMD sharing is possible

Li Zhe <lizhe.67@bytedance.com>
    mm/hugetlb: fix mremap move length truncation

Hungyu Lin <dennylin0707@gmail.com>
    mm/page-writeback: avoid 32-bit overflow in dirty threshold shares

Kyle Zeng <kylebot@openai.com>
    mm/khugepaged: flush deferred unmaps before dropping a failed folio

Babu Moger <babu.moger@amd.com>
    x86,fs/resctrl: Keep mbm_assign_mode in default mode at boot

Babu Moger <babu.moger@amd.com>
    x86/resctrl: Correct ABMC counter ID field width

Mohit Sharma <mohit.sharma@oss.qualcomm.com>
    ASoC: qcom: q6apm: Guard callbacks until probe data is ready

Michael McAllister <me@michaelmcallister.org>
    Bluetooth: qca: Fix the WCN3950 NVM baud rate offset

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_sync: pause advertising for the scan address update

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_sync: re-enable legacy advertising on resume

Zack Rusin <zack.rusin@broadcom.com>
    x86/vmware: Fix i386 high-bandwidth hypercall arguments

Yingjie Wang <1075151112@qq.com>
    ipv6: reject wrapped temporary address preferred lifetimes

Sean Christopherson <seanjc@google.com>
    KVM: x86: Unconditionally reset MMU context when emulating INIT

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Cap number of parent PTEs per SP at 1000 (the arbitrary rmap limit)

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry

Sean Christopherson <seanjc@google.com>
    KVM: x86: Conditionally resched when restarting REP string emulation

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Conditionally resched when retrying gPTE walk on A/D update failure

Daejun Park <daejun7.park@samsung.com>
    nvme: unregister when pr_register() is given a zero new key

Vas Zayarskiy <contact@vasily.cc>
    hwmon: (aquacomputer_d5next) Avoid truncating scaled sensor readings

Guenter Roeck <linux@roeck-us.net>
    hwmon: (sht4x) Convert update_interval to jiffies in pending data check

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Check for NULL platform device in hotplug callbacks

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (gpio-fan) Update the speed cache before dropping the PM reference

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Fix return value check from thermal zone registration

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus) Check return value from pmbus_thermal_add_sensor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (pmbus/q54sj108a2) Add missing NULL pointer check

Guenter Roeck <linux@roeck-us.net>
    hwmon: (peci/dimmtemp) Fix devres leak and UAF on concurrent unbind

Guenter Roeck <linux@roeck-us.net>
    hwmon: (nct6683) Fix incorrect struct cast in show_pwm() and store_pwm()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (hp-wmi-sensors) Fix unbounded loops in scale_numeric_sensor()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (hp-wmi-sensors) Avoid global struct mutation

Guenter Roeck <linux@roeck-us.net>
    hwmon: (asus_wmi_sensors) Avoid global struct mutation

Guenter Roeck <linux@roeck-us.net>
    hwmon: (aquacomputer_d5next) Check maxcollection when probing AQUAERO devices

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: do not discard pending alarms on disable

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: balance regulator state

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: enable IRQ processing when regulator is already enabled

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: defer probe when IRQs are unavailable

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix be16 handling

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix off-by-one in command mode retry loop

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    hwmon: chipcap2: fix command error diagnostics

Jiale Yao <yaojiale02@163.com>
    hwmon: (aquacomputer_d5next) reject short status reports

Baek Kyu, Kim <pocj8ur4in@gmail.com>
    hwmon: (corsair-cpro) Cache fan target only after a successful command

Xia Yan <yana06070@163.com>
    veth: keep carrier off when resizing channels with a down peer

Fang Xieyan <fangxy@xiaopeng.com>
    vringh: reject empty / undersized indirect descriptor tables

Fang Xieyan <fangxy@xiaopeng.com>
    vringh: bound top-level re-entry into indirect tables

Tal Zussman <tz2294@columbia.edu>
    vhost-vdpa: fix pinned page leak in vhost_vdpa_pa_map() error path

Qihang <q.h.hack.winter@gmail.com>
    cipso: fix optlen corruption in cipso_v4_delopt()

Maíra Canal <mcanal@igalia.com>
    drm/v3d: Widen cache_clean_lock over the whole L2TCACTL sequence

Jose Maria Casanova Crespo <jmcasanova@igalia.com>
    drm/v3d: Initialize timedout_batches when running a CSD job

Daejun Park <daejun7.park@samsung.com>
    xfs: don't skip free extents of the longest length in a whole-AG FITRIM

Daejun Park <daejun7.park@samsung.com>
    xfs: don't skip free extents in later batches of a whole-AG FITRIM

Hungyu Lin <dennylin0707@gmail.com>
    ext2: preserve completed DIO bytes when buffered fallback fails

David Hildenbrand (Arm) <david@kernel.org>
    mm/filemap: finish fault cleanup before dropping the fault lock

Josef Bacik <josef@toxicpanda.com>
    mm/filemap: don't lose a folio lock wakeup to a signal

Josef Bacik <josef@toxicpanda.com>
    mm/memfd: make f_pos accesses atomic

Josef Bacik <josef@toxicpanda.com>
    mm/mglru: don't use stack pointers when walking PUD and PMD tables

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix truncation of files containing only swapin-error markers

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix truncate loop after boundary swapin failure

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: fix truncate hang in large swap entry

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: rescan after nonuniform folio splitting

David Hildenbrand (Arm) <david@kernel.org>
    mm/shmem: discard whole new large folios on fallocate rollback

Chris Mason <mason@kernel.org>
    mm/shmem: preserve data in clean folios when splitting fails

Chris Mason <mason@kernel.org>
    mm/shmem: stop retrying folios that cannot be split

Josef Bacik <josef@toxicpanda.com>
    tmpfs: preserve explicitly disabled quota limits

Josef Bacik <josef@toxicpanda.com>
    tmpfs: keep the quota soft limits of an unused id

Chris Mason <mason@kernel.org>
    mm/mempolicy: charge shared policy nodes

Ian Bridges <icb@fastmail.org>
    ksmbd: grant a POSIX ACL group entry only to the group's members

Federico Musto <federico@rimpianto.com>
    net: atl1c: drop oversized RX frames instead of panicking

Vidya Srinivas <vidya.srinivas@intel.com>
    drm/i915/display: Single scaler per pipe on WCL

Lu Yao <yaolu@kylinos.cn>
    drm/i915/gem: Reset err for each fence entry

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Don't clip plane state destination rectangle

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Fix SFF and CFF CTL register bit definitions

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Disable linked plane sel fetch as well

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/display: Add enabled pipe planes into state for selective fetch

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Clear selective fetch area when duplicating plane state

Breno Leitao <leitao@debian.org>
    x86/bugs: Select the BHI mitigation based on the attack vector properly

Miguel Ojeda <ojeda@kernel.org>
    rust: cpufreq: fix `undocumented_unsafe_blocks` in `PolicyCpu::from_cpu()`

Ian Bridges <icb@fastmail.org>
    ksmbd: require DELETE access for delete-on-close opens

Jamal Hadi Salim <jhs@mojatatu.com>
    bpf: Fix skb_pull() BUG in __bpf_redirect_neigh()

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: hwdep: Serialize DSP load requests

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: usx2y: Initialize idle URBs before submitting streams

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: us122l: Fix NULL dereference at hwdep open and release

YuanZhe Liu <25031212351@stu.xidian.edu.cn>
    ALSA: us122l: Add missing NULL check in usb_stream_hwdep_mmap()

Evanshenf <archwse@gmail.com>
    drm/loongson: Handle buffer mapping failures when clearing a BO

Evanshenf <archwse@gmail.com>
    drm/loongson: Fix double free on BO initialization failure

Evanshenf <archwse@gmail.com>
    drm/loongson: Fix framebuffer selection in async cursor updates

Shao Mingyin <shao.mingyin@zte.com.cn>
    scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store

Yuanhe Shu <xiangzao@linux.alibaba.com>
    scsi: target: Verify the iSCSI ISID is null-terminated

Yingjie Wang <x-professor@outlook.com>
    scsi: bsg: Report synchronous data copyback failures

Yu Zhang <yuz08559@gmail.com>
    ptp: fix use-after-free in extts_fifo_show() reading tsevqs unlocked

guolingxing <guolingxing@tju.edu.cn>
    btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()

Masafumi Suzuki <shengshilingmu97@gmail.com>
    sctp: account for chunk padding in sctp_init_cause()

Lucas Tanure <lucas.tanure@neat.no>
    drm/vc4: hdmi: enable scrambling before the TMDS clock starts

Lucas Tanure <lucas.tanure@neat.no>
    drm/vc4: hdmi: always cancel the scrambling work synchronously

Dom Cobley <popcornmix@gmail.com>
    drm/vc4: hdmi: power down the BCM2712 PHY when the output is disabled

Zhou Qiuyue <n0ps1edzz@gmail.com>
    ipv6: raw: fix use-after-free in rawv6_send_hdrinc()

Franck Baur <franck.baur.67@gmail.com>
    net: jme: keep RX MAC clock enabled for WoL

Sven Eckelmann <sven@narfation.org>
    batman-adv: stop originator purge worker before freeing TT

Sven Eckelmann <sven@narfation.org>
    batman-adv: fix skb leak when hard_iface is being released

Sven Eckelmann <sven@narfation.org>
    batman-adv: dat: initialize orig_node of unfilled candidate slots

Kyle Zeng <kylebot@openai.com>
    batman-adv: mcast: validate tracker padding before forwarding

Chengfeng Ye <nicoyip.dev@gmail.com>
    batman-adv: Close OGM aggregation before transmission

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: don't decrement a server-owned zero nlink

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    9p/xen: validate the response size from the backend

Yu Zhang <yuz08559@gmail.com>
    scsi: target: Fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown

Andrew Luebke <andrew.luebke@gmail.com>
    scsi: aic79xx: Fix NULL pointer dereference in device reset

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers

Fourie Zhang <fouriezhang@tencent.com>
    xfrm4: use a full socket for local errors

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Drop the BO reservations outside of job_lock

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Publish the output fence outside of job_lock

Zijing Yin <yzjaurora@gmail.com>
    wifi: cfg80211: fix out-of-bounds read in valid_rule()

Alex Kazinsky <a.kazinsky@ideco.ru>
    wifi: rsi: Skip TX aggregation setup for non-QoS frames

Jason Perlow <jperlow@gmail.com>
    wifi: brcmfmac: map msgbuf RX packet IDs bidirectional

Weigang He <geoffreyhe2@gmail.com>
    wifi: mac80211: reload TDLS header pointer after skb_linearize()

André Draszik <andre.draszik@linaro.org>
    drm/drm_crtc: ensure dma_fence_ops remain valid during device unbind

Devin Wittmayer <lucid_duck@justthetip.ca>
    drm/panic: Fix kmsg screen hang on a long log line

Sabrina Dubroca <sd@queasysnail.net>
    xfrm: espintcp: reorder operations within espintcp_init_sk

Qihang <q.h.hack.winter@gmail.com>
    xfrm: interface: validate the IP header on xmit

Hyungjung Joo <jhj140711@gmail.com>
    net/9p/usbg: clear stale client pointer on close

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: remove bogus context initialization in alloc_requests

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: fix out_req buffer leak in disable_usb9pfs

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: call disable_usb9pfs() from usb9pfs_disable()

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: always reset completion when disconnecting

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: set client to Disconnected on usb9pfs_disable

Michael Grzeschik <mgr@kernel.org>
    net/9p/usbg: also disable endpoints on p9_usbg_close

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p/usbg: Fix use-after-free in disable_usb9pfs()

Zhao Zhang <zzhan461@ucr.edu>
    9p: fix caches_show() out-of-bounds write

Yifei Gao <gyf161023@gmail.com>
    9p/xen: fix refcount leak in p9_xen_response() on wrong tag

Michael Bommarito <michael.bommarito@gmail.com>
    9p/trans_virtio: reject mount tags longer than NAME_MAX at probe

Chengfeng Ye <nicoyip.dev@gmail.com>
    net/9p/usbg: clear stale request context after abort

Chengfeng Ye <nicoyip.dev@gmail.com>
    xfrm: retry inexact policy lookup after node reinsertion

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    net/9p/usbg: fix prefix matching in device lookup

Christian Brauner <brauner@kernel.org>
    ns: don't add init_ipc_ns and init_net without namespace support

Noam D. Eliyahu <noam.d.eliyahu@gmail.com>
    tg3: Invert restart quirk logic to restrict SNP power-down bypass

Zhiling Zou <zhilinz@nebusec.ai>
    ipmr: drop packets with unknown ingress VIF

Ido Schimmel <idosch@nvidia.com>
    ipmr, ip6mr: validate packets injected into the register vif on xmit

Peng Wang <peng_wang@linux.alibaba.com>
    tick/nohz: Reevaluate the tick for kicks flushed outside hardirq

Hungyu Lin <dennylin0707@gmail.com>
    posix-timers: Accept NULL clock_getres() output in stubs

Yingjie Wang <x-professor@outlook.com>
    scsi: handle out-of-range SG_SET_TIMEOUT values

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: bsg: Reject UIC commands with a non-zero result byte

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: bsg: Validate request_len before accessing request

Daeho Jeong <daehojeong@google.com>
    f2fs: don't use truncate_inode_pages_final() on live inodes

Sahaj Chaudhari <sahaj123.sc@gmail.com>
    gpio: pca953x: Preserve wakeup accounting on parent IRQ failure

Henry Martin <bsdhenrymartin@gmail.com>
    rds: fix out-of-bounds conn_path walks via handshake exthdrs

Yun Zhou <yun.zhou@windriver.com>
    net: erspan: set lltx to avoid sch_direct_xmit deadlock

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Add the bucket size to expr_field_str()

Guixin Liu <kanie@linux.alibaba.com>
    cxl/events: Test CME counter expiry with equality, not bitwise AND

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: selftest: Pin module for selftest debugfs file operations

Guangshuo Li <lgs201920130244@gmail.com>
    mfd: ab8500: Fix child device leaks on probe failure

Andrey Misiurov <andrey.misyrov@gmail.com>
    fbdev: core: Initialize modelist in framebuffer_alloc()

Breno Leitao <leitao@debian.org>
    ACPI: APEI: accumulate the queued flag across error sections

Ridong Chen <chenridong@xiaomi.com>
    mm/page_counter: avoid integer overflow in effective_protection()

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mt76: take rcu_read_lock in the USB/SDIO tx completion path

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: timers: Compute an offset-applied CVAL from the current count

Jiayuan Chen <jiayuan.chen@linux.dev>
    mm/memcontrol: fix data-race on reading jiffies_64

Priyank Rathod <rathodpriyank@google.com>
    PCI/AER: Fix memory leak in aer_recover_work_func() when pci_dev is missing

Kazuki Hanai <hnkz.64@gmail.com>
    media: mediatek: jpeg: Avoid context access after job finish

Rupesh Majhi <zoone.rupert@gmail.com>
    iio: pressure: dps310: fix CFG_REG bit definitions

Ridham Khurana <khurana.ridham222@gmail.com>
    hwmon: (lm70) Fix rounding of negative temperatures

Ruoyu Wang <ruoyuw560@gmail.com>
    media: adv748x: Fix endpoint reference leaks on probe failure

Pengpeng Hou <pengpeng@iscas.ac.cn>
    media: require two-byte Cypress type 04 records

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix WB offset and gain register field masking

SJ Park <sj@kernel.org>
    mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once

Eric Sandeen <sandeen@redhat.com>
    devtmpfs: restore mount option reconfiguration on get_tree

Ben Dooks <ben.dooks@codethink.co.uk>
    devtmpfs: make 'devtmpfs_context_ops' static

Kiryl Shutsemau (Meta) <kas@kernel.org>
    mm: page_alloc: make defrag_mode retries follow the promoted order

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: give the sysctl timer limits in milliseconds

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: swap the AX.25 connection of a neighbour under a lock

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: drop the neighbour reference once when a cleared socket is closed

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: report a timed out call to connect()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: hold the socket a received frame is delivered to

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: hold the listener while a Call Request is queued on it

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: only update the BPQ extension flag on circuit set-up frames

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: disconnect sockets under their lock when a device goes down

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: don't send part of a message that cannot be fragmented whole

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: check the window size given by the peer

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: drop a frame received with a TTL of 0

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: keep the selected route when a route of a node is removed

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: return the peer node in the address given by recvmsg()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: don't give the same circuit ID to two sockets

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: give a frame back intact when it cannot be delivered

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: use the more flag of each frame taken from the resequencing queue

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: don't leak frames in nr_route_frame()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: don't convert the maximum number of tries to jiffies

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't let connect() find its own socket when calling the same station

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: let a socket connect again after a failed or ended connection

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: keep the window below 8 when a socket goes back to modulo 8

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: make 16 the smallest maximum_packet_length of a port

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't leave half a message on a connection when fragmenting fails

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: free the copy of an IP packet that ax25_send_frame() turned down

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't test the socket flags of a connection that has no socket

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: put an incoming connection on the listener's queue once it is set up

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: free the old digipeater path of a listed socket under ax25_list_lock

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't copy an uninitialised address to recvmsg()'s caller

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't take a reference on a gone device in ax25_accept()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't build a frame header from an uninitialised digipeater list

Bernard Pidoux <bernard.f6bvp@gmail.com>
    6pack: restart the transmit queue when the interface is opened

Bernard Pidoux <bernard.f6bvp@gmail.com>
    mkiss: restart the transmit queue when the interface is opened

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: free a closed socket when its device goes down

Bernard Pidoux <bernard.f6bvp@gmail.com>
    ax25: don't create a second connection for a link on an incoming SABM

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: don't give the same LCI to two calls placed at the same time

Bernard Pidoux <bernard.f6bvp@gmail.com>
    netrom: ignore a BPQ transport timeout below the sysctl minimum

Bernard Pidoux <bernard.f6bvp@gmail.com>
    rose: arm the neighbour timers with mod_timer()

Bernard Pidoux <bernard.f6bvp@gmail.com>
    bpqether: fix truncated /proc/net/bpqether on partial reads

Bernard Pidoux <bernard.f6bvp@gmail.com>
    bpqether: leave the Ethernet device's queue and counters alone

Bernard Pidoux <bernard.f6bvp@gmail.com>
    mkiss: don't use a tty write error as a byte count

Bernard Pidoux <bernard.f6bvp@gmail.com>
    mkiss: size the frame buffers for worst-case KISS escaping

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Force UVC version for Avermedia GC515

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Add autosuspend quirk for AVerMedia Live Gamer HD 2

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: mac80211: queue frames while off-channel

Denis Pauk <pauk.denis@gmail.com>
    hwmon: (nct6775) Add ASUS X870/W480 to WMI monitoring list

Maximilian Luz <luzmaximilian@gmail.com>
    hwmon: (nct6775) Add ASUS ROG STRIX X870E-H GAMING WIFI7

Yi Cong <yicong@kylinos.cn>
    wifi: mt76: mt792x: fix negative errno truncation in offload capability

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Limit Max_Read_Request_Size to 256 Bytes

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/vmcp: Initialize full session info to zero

Jeff Layton <jlayton@kernel.org>
    nfsd: shorten extack string returned with dodgy listener

Cen Zhang (Microsoft Security FORGE Labs) <cenzhang@linux.microsoft.com>
    ksmbd: fix tree connection use-after-free in smb2_tree_connect()

Rosen Penev <rosenp@gmail.com>
    net: bgmac: enable interrupts only after NAPI is ready

Rosen Penev <rosenp@gmail.com>
    mtd: rawnand: ndfc: use devm_platform_ioremap_resource()

Rosen Penev <rosenp@gmail.com>
    mtd: rawnand: ndfc: fix gcc uninitialized var

Arnd Bergmann <arnd@arndb.de>
    mtd: rawnand: ndfc: add CONFIG_OF dependency

Rosen Penev <rosenp@gmail.com>
    mtd: rawnand: ndfc: use ioread32be/iowrite32be and allow COMPILE_TEST

Eric Biggers <ebiggers@kernel.org>
    raid6: add missing vzeroupper to AVX2 code

Diego Oliva <diego@bynar.io>
    smb: client: reject FIND data areas that run past the received response

Paulo Alcantara <pc@manguebit.org>
    smb: client: reclaim credits for decrypted reads with no matching mid

Darrick J. Wong <djwong@kernel.org>
    xfs: forcibly reset quota timers when upgrading to bigtime during repair

Darrick J. Wong <djwong@kernel.org>
    xfs: reinitialize dquot block if non-first dquot can't load

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: delete session hash entries by pointer match

Liz Fong-Jones <lizf@honeycomb.io>
    writeback: keep cleanup_offline_cgwb()'s scan out of syncs

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Accept requests to retain immutable autonomous selection

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Propagate errors from cross-CPU FFH calls

Christian Loehle <christian.loehle@arm.com>
    ACPI: CPPC: Validate FFH register fields before hardware access

Ping-Ke Shih <pkshih@realtek.com>
    wifi: rtw88: TX report with long timeout for non-PCIE devices

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: bug: update the SAFETY comment for warn_slowpath_fmt() on UML

FUJITA Tomonori <fujita.tomonori@gmail.com>
    rust: bug: pass TAINT_WARN to warn_slowpath_fmt() on UML

SJ Park <sj@kernel.org>
    mm/damon/core: filter out damos address filter-split failed region

SJ Park <sj@kernel.org>
    mm/damon/core: remove unreachable damos charge_{target,addr}_from

SJ Park <sj@kernel.org>
    mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total

SJ Park <sj@kernel.org>
    mm/damon/core: skip applying scheme if region split for quota fails

Eric Biggers <ebiggers@kernel.org>
    raid6: add missing vzeroupper to AVX-512 code

Eric Biggers <ebiggers@kernel.org>
    xor: add missing vzeroupper to AVX code

Eric Biggers <ebiggers@kernel.org>
    fsverity: Explicitly require FMODE_READ to retrieve hashes

Yuansheng Yang <0xbeac@gmail.com>
    io_uring/rsrc: hold uring_lock across index-alloc put_user

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: don't poll a writer for urgent data

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: don't poll a writer for a read side hangup

Shang En Sim <sim@shangen.org>
    io_uring/poll: cancel all matching requests in one pass

Shang En Sim <sim@shangen.org>
    io_uring/cancel: count all requests that a CANCEL_ALL cancels

Shakeel Butt <shakeel.butt@linux.dev>
    io_uring/sqpoll: do the return-to-userspace work in the SQPOLL thread

Shuai Liu <847807867@qq.com>
    io_uring/sqpoll: don't set IO_SQ_THREAD_SHOULD_STOP on thread exit

Jens Axboe <axboe@kernel.dk>
    io_uring/sqpoll: don't attach to a thread that is canceling

Chris Mason <mason@kernel.org>
    io_uring/cancel: drop sqd->lock while SQPOLL waits

Til Kaiser <mail@tk154.de>
    mlxsw: Initialize register query payloads

Janne Grunau <j@jannau.net>
    wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: look up stream size by exact xattr name

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Don't assume exit_reason[31:16] is all-0 in tdx_to_vmx_exit_reason()

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Set bits 31:16 to 0 and use UNDEFINED when synthesizing exit reason

Xiaoyao Li <xiaoyao.li@intel.com>
    KVM: TDX: Stuff exit_reason with UNDEFINED on wait_for_sept_zap return

Shivank Garg <shivankg@amd.com>
    KVM: guest_memfd: take the invalidate lock when unbinding a dying file

Sean Christopherson <seanjc@google.com>
    KVM: Only bind memslot to guest_memfd instance for CREATE operations

Sean Christopherson <seanjc@google.com>
    KVM: Harden and prepare for modifying existing guest_memfd memslots

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Complete a cld upcall when copying its reply fails

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Complete a cld upcall when the daemon closes the pipe

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move the cld upcall message out of the caller's stack frame

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Send a meaningful CB_RECALL_ANY keep count

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Count the delegations held by each client

Mike Snitzer <snitzer@kernel.org>
    NFS/localio: detect a short read or write before the iterator has moved

Jeff Layton <jlayton@kernel.org>
    NFSD: stop registering with rpcbind after a failure in listener_set

Jeff Layton <jlayton@kernel.org>
    SUNRPC: report local rpcbind calls that get no answer

Jeff Layton <jlayton@kernel.org>
    NFSD: report listener creation failures through extack

Jeff Layton <jlayton@kernel.org>
    nfsd: don't offer flexfiles layouts when NFSv3 isn't being served

Christoph Hellwig <hch@lst.de>
    exportfs,nfsd: rework checking for layout-based block device access support

Christoph Hellwig <hch@lst.de>
    exportfs: split out the ops for layout-based block device access

André Almeida <andrealmeid@igalia.com>
    exportfs: Complete kernel-doc for struct export_operations

Sergey Bashirov <sergeybashirov@gmail.com>
    NFSD/blocklayout: Extract extent mapping from proc_layoutget

Chuck Lever <chuck.lever@oracle.com>
    NFSD: map fh_verify() status codes for NFS_ACLv2 replies

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move version-specific ACCESS maps into per-version code

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Replace nfsd_write()'s "stable" argument with "iocb_flags"

Bharath SM <bharathsm@microsoft.com>
    smb: align durable reconnect v2 context to 8 byte boundary

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: bound POSIX lock data area by response length

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: bound the CB_NOTIFY_DEVICEID array count before allocating

Darrick J. Wong <djwong@kernel.org>
    xfs: improve dirent bounds checking in scrub and repair

Darrick J. Wong <djwong@kernel.org>
    xfs: refactor directory data block walking loops in scrub

Darrick J. Wong <djwong@kernel.org>
    xfs: check for buffer overruns when examining local/remote xattr entries

Darrick J. Wong <djwong@kernel.org>
    xfs: break out xattr entry checks into separate functions

Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
    smb: client: validate SMB1 EA list bounds before parsing

Zhaoyang Huang <zhaoyang.huang@unisoc.com>
    mm: remove '!root_reclaim' checking in should_abort_scan()

Paulo Alcantara <pc@manguebit.org>
    smb: client: require stable pages for SMB compression

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: reject short SESSION_SETUP responses

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move some duplicate struct definitions to common/fscc.h

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move list of FileSystemAttributes to common/fscc.h

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb: move some duplicate definitions to common/smb2pdu.h

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move create_durable_rsp_v2 to common/smb2pdu.h

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb: move create_durable_req_v2 to common/smb2pdu.h

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h

Eduard Zateev <hackerowskiy@gmail.com>
    smb: client: hold server info until cifsd exits

Thomas Huth <thuth@redhat.com>
    smb: client: Avoid leaking sensitive data to the heap in connect.c

Jinwang Li <jinwang.li@oss.qualcomm.com>
    Bluetooth: L2CAP: Ignore connection responses with wrong ident

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Only accept connection responses to outstanding requests

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject signalling responses in invalid states

Eric Biggers <ebiggers@kernel.org>
    fsverity: Tell LSMs about signature only after verity is enabled

Eric Biggers <ebiggers@kernel.org>
    crypto: sa2ul - Fix HMAC key preparation

Andrew Stellman <astellman@stellman-greene.com>
    nvmet-rdma: fix out-of-bounds write in nvmet_rdma_map_sgl_inline()

Chris Mason <mason@kernel.org>
    backing-file: always end a queued write

Ashok Raj <ashok.raj@oss.qualcomm.com>
    cxl/features: Ensure that count is set before access to ent[] __counted_by()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: x86: hdmi: fix chmap array missing terminator entry

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: validate the data area in SMB2_read()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.rst    |  97 +--
 Documentation/admin-guide/kernel-parameters.txt    | 109 +++
 Documentation/filesystems/fsverity.rst             |   3 +
 Documentation/filesystems/overlayfs.rst            |   3 +-
 Documentation/filesystems/resctrl.rst              |  87 +-
 Documentation/hwmon/coretemp.rst                   |   3 +
 MAINTAINERS                                        |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/sdei.h                      |   3 +-
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/kernel/entry-common.c                   |  40 +-
 arch/arm64/kernel/machine_kexec_file.c             |   2 +
 arch/arm64/kernel/process.c                        |  17 +
 arch/arm64/kernel/sdei.c                           |  59 +-
 arch/arm64/kernel/topology.c                       |  13 +-
 arch/arm64/kvm/arch_timer.c                        |  27 +-
 arch/arm64/kvm/arm.c                               |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  28 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  11 +-
 arch/arm64/kvm/mmu.c                               |   4 +-
 arch/arm64/kvm/nested.c                            |  10 +
 arch/arm64/kvm/ptdump.c                            |  50 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  10 +
 arch/arm64/kvm/vgic/vgic.c                         |  11 +-
 arch/arm64/mm/mmap.c                               |   4 +-
 arch/arm64/mm/proc.S                               |   8 +
 arch/loongarch/include/asm/hw_breakpoint.h         |   4 +-
 arch/loongarch/include/asm/loongarch.h             |   3 +
 arch/loongarch/include/asm/processor.h             |   1 +
 arch/loongarch/include/asm/switch_to.h             |   2 +-
 arch/loongarch/kernel/hw_breakpoint.c              |  39 +-
 arch/loongarch/kernel/numa.c                       |   8 +-
 arch/m68k/68000/entry.S                            |  24 +-
 arch/m68k/coldfire/entry.S                         |   3 +-
 arch/mips/mm/cex-gen.S                             |  16 +
 arch/mips/pci/ops-mace.c                           |  26 +-
 arch/mips/pci/pci-ip32.c                           |   9 +-
 arch/mips/sgi-ip32/ip32-irq.c                      |  45 +-
 arch/openrisc/kernel/or32_ksyms.c                  |   1 +
 arch/powerpc/net/bpf_jit.h                         |   7 +
 arch/powerpc/net/bpf_jit_comp.c                    |  35 +-
 arch/powerpc/platforms/pseries/iommu.c             |  67 +-
 arch/s390/pci/pci_irq.c                            |  26 +-
 arch/x86/boot/startup/sme.c                        |   2 +-
 arch/x86/include/asm/vmware.h                      |  24 +-
 arch/x86/include/asm/xor_avx.h                     |   4 +
 arch/x86/kernel/acpi/cppc.c                        |  15 +
 arch/x86/kernel/cpu/bugs.c                         |  12 +-
 arch/x86/kernel/cpu/resctrl/internal.h             |   4 +-
 arch/x86/kernel/cpu/resctrl/monitor.c              |   4 +-
 arch/x86/kernel/nmi.c                              |   8 +
 arch/x86/kernel/x86_init.c                         |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  11 +-
 arch/x86/kvm/svm/nested.c                          |   1 +
 arch/x86/kvm/vmx/nested.c                          |   1 +
 arch/x86/kvm/vmx/tdx.c                             |  42 +-
 arch/x86/kvm/x86.c                                 |  33 +-
 arch/x86/mm/tlb.c                                  |  16 +-
 block/blk-iocost.c                                 |   3 +
 block/blk-mq.c                                     |  17 +-
 block/bsg.c                                        |   5 +-
 block/ioctl.c                                      |   4 +-
 drivers/acpi/apei/ghes.c                           |   6 +-
 drivers/acpi/cppc_acpi.c                           |  58 +-
 drivers/acpi/riscv/cppc.c                          |  26 +-
 drivers/ata/Kconfig                                |   7 -
 drivers/ata/Makefile                               |   1 -
 drivers/ata/libata-eh.c                            |   6 +-
 drivers/ata/libata-pmp.c                           |  16 +-
 drivers/ata/libata-scsi.c                          |  25 +
 drivers/ata/libata.h                               |   4 +-
 drivers/ata/sata_inic162x.c                        | 902 ---------------------
 drivers/base/devtmpfs.c                            | 108 ++-
 drivers/block/ublk_drv.c                           |  60 +-
 drivers/block/virtio_blk.c                         |   2 +-
 drivers/bluetooth/btqca.c                          |   3 +-
 drivers/char/hw_random/virtio-rng.c                |   7 +
 drivers/char/tpm/tpm2-cmd.c                        |   3 +-
 drivers/clk/nuvoton/clk-ma35d1.c                   |   7 +-
 drivers/cpufreq/amd-pstate.c                       |  25 +-
 drivers/crypto/omap-sham.c                         |  28 +-
 drivers/crypto/sa2ul.c                             | 119 +--
 drivers/cxl/core/features.c                        |   2 +-
 drivers/cxl/core/mbox.c                            |   8 +-
 drivers/cxl/core/port.c                            |  60 +-
 drivers/dma/qcom/bam_dma.c                         |  10 +-
 drivers/gpio/gpio-pca953x.c                        |   7 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   3 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  11 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  13 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |   5 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   1 -
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |  13 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c             |  41 +-
 .../gpu/drm/amd/amdkfd/kfd_process_queue_manager.c |   3 +-
 .../amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |   3 +
 .../display/dc/link/protocols/link_dp_capability.c |   6 +-
 .../gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c |   7 +
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |  15 +-
 .../drm/amd/display/modules/freesync/freesync.c    |   6 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   2 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  35 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  32 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  38 +-
 drivers/gpu/drm/bridge/nwl-dsi.c                   |  17 +-
 drivers/gpu/drm/display/drm_dp_helper.c            |   3 +-
 drivers/gpu/drm/drm_crtc.c                         |  15 +-
 drivers/gpu/drm/drm_panic.c                        |   7 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |  40 +-
 .../gpu/drm/i915/display/intel_display_device.c    |   5 +-
 drivers/gpu/drm/i915/display/intel_plane.c         |  11 +
 drivers/gpu/drm/i915/display/intel_psr.c           |  96 +--
 drivers/gpu/drm/i915/display/intel_psr_regs.h      |   4 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/loongson/lsdc_gem.c                |  14 +-
 drivers/gpu/drm/loongson/lsdc_plane.c              |   2 +-
 drivers/gpu/drm/loongson/lsdc_ttm.c                |  14 +-
 drivers/gpu/drm/loongson/lsdc_ttm.h                |   2 +-
 drivers/gpu/drm/nouveau/nvkm/core/subdev.c         |   1 +
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |  20 +
 drivers/gpu/drm/v3d/v3d_gem.c                      |   5 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   2 +
 drivers/gpu/drm/vc4/vc4_gem.c                      |  14 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  10 +-
 drivers/gpu/drm/vc4/vc4_hdmi_phy.c                 |   5 +
 drivers/hwmon/aquacomputer_d5next.c                |  58 +-
 drivers/hwmon/asus_wmi_sensors.c                   |  13 +-
 drivers/hwmon/chipcap2.c                           |  53 +-
 drivers/hwmon/coretemp.c                           |  27 +-
 drivers/hwmon/corsair-cpro.c                       |   3 +-
 drivers/hwmon/gpio-fan.c                           |   7 +-
 drivers/hwmon/hp-wmi-sensors.c                     |  29 +-
 drivers/hwmon/lm70.c                               |   8 +-
 drivers/hwmon/lm87.c                               |   7 +-
 drivers/hwmon/nct6683.c                            |   4 +-
 drivers/hwmon/nct6775-platform.c                   |  24 +
 drivers/hwmon/peci/dimmtemp.c                      |  21 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  51 +-
 drivers/hwmon/pmbus/q54sj108a2.c                   |   2 +
 drivers/hwmon/sht4x.c                              |   4 +-
 drivers/hwmon/tmp102.c                             |   8 +-
 drivers/hwmon/tmp108.c                             |   8 +-
 drivers/iio/adc/ad4080.c                           |   3 +-
 drivers/iio/adc/ad7192.c                           |   2 +-
 drivers/iio/dac/mcp4821.c                          |   7 +-
 drivers/iio/light/adux1020.c                       |   4 +-
 drivers/iio/light/apds9160.c                       |   7 +-
 drivers/iio/light/apds9300.c                       |   4 +-
 drivers/iio/light/apds9306.c                       |   3 +-
 drivers/iio/light/apds9960.c                       |   4 +-
 drivers/iio/light/bh1745.c                         |   3 +-
 drivers/iio/light/cm3605.c                         |   4 +-
 drivers/iio/light/gp2ap002.c                       |   4 +-
 drivers/iio/light/isl29028.c                       |  43 +-
 drivers/iio/light/ltr390.c                         |   3 +-
 drivers/iio/light/ltr501.c                         |   7 +-
 drivers/iio/light/opt4060.c                        |   2 +-
 drivers/iio/light/rpr0521.c                        |   5 +-
 drivers/iio/light/si1145.c                         |   4 +-
 drivers/iio/light/st_uvis25_core.c                 |   5 +-
 drivers/iio/light/stk3310.c                        |   5 +-
 drivers/iio/light/tsl2563.c                        |   2 +-
 drivers/iio/light/tsl2772.c                        |   5 +-
 drivers/iio/light/veml6030.c                       |   4 +-
 drivers/iio/light/vl6180.c                         |   2 +-
 drivers/iio/pressure/dps310.c                      |   6 +-
 drivers/iommu/amd/init.c                           |  41 +-
 drivers/iommu/iommufd/io_pagetable.c               |   2 +-
 drivers/iommu/iommufd/iova_bitmap.c                |  18 +-
 drivers/iommu/virtio-iommu.c                       |   6 +-
 drivers/irqchip/irq-renesas-rzv2h.c                |   6 +-
 drivers/media/common/cypress_firmware.c            |   2 +
 drivers/media/i2c/adv748x/adv748x-core.c           |  13 +-
 drivers/media/i2c/imx219.c                         |  88 +-
 drivers/media/i2c/og01a1b.c                        |  97 +--
 drivers/media/i2c/ov5647.c                         |   4 +
 drivers/media/pci/intel/ipu6/ipu6-fw-isys.c        |  88 +-
 drivers/media/pci/intel/ipu6/ipu6-isys-video.c     |   4 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.c           |   6 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.h           |   5 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |   4 +-
 .../media/platform/microchip/microchip-isc-base.c  |  20 +-
 .../media/platform/microchip/microchip-isc-regs.h  |  16 +-
 drivers/media/platform/microchip/microchip-isc.h   |   4 +-
 .../platform/microchip/microchip-sama5d2-isc.c     |  20 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |  20 +-
 drivers/media/platform/qcom/iris/iris_core.h       |   6 +
 drivers/media/platform/qcom/iris/iris_probe.c      |  62 +-
 drivers/media/platform/qcom/iris/iris_vpu_common.c |   2 +-
 drivers/media/platform/rockchip/rga/rga.c          |  69 +-
 drivers/media/platform/rockchip/rga/rga.h          |   7 +-
 drivers/media/rc/redrat3.c                         |  11 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |   2 +
 drivers/media/usb/uvc/uvc_driver.c                 |  20 +
 drivers/mfd/ab8500-core.c                          |  44 +-
 drivers/mfd/twl-core.c                             |  25 +-
 drivers/misc/fastrpc.c                             |  81 +-
 drivers/mtd/nand/raw/Kconfig                       |   3 +-
 drivers/mtd/nand/raw/ndfc.c                        |  41 +-
 drivers/mtd/spi-nor/macronix.c                     |   2 +
 drivers/net/can/dev/netlink.c                      |   4 +-
 drivers/net/can/dev/skb.c                          |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   7 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  33 +
 drivers/net/ethernet/broadcom/bgmac.c              |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  53 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  52 +-
 drivers/net/ethernet/broadcom/tg3.c                |  42 +-
 drivers/net/ethernet/jme.c                         |  37 +-
 drivers/net/ethernet/jme.h                         |   1 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   4 +-
 drivers/net/hamradio/6pack.c                       |   6 +
 drivers/net/hamradio/bpqether.c                    |   8 +-
 drivers/net/hamradio/mkiss.c                       |  70 +-
 drivers/net/ppp/pppoe.c                            |  22 +-
 drivers/net/veth.c                                 |   5 +-
 drivers/net/vxlan/vxlan_core.c                     |  14 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  14 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   7 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt792x_core.c   |  12 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   2 +
 drivers/net/wireless/realtek/rtw88/tx.c            |   9 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |   3 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |  68 +-
 drivers/net/wireless/realtek/rtw88/usb.h           |   5 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |   2 +-
 drivers/nvme/common/keyring.c                      |   1 +
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/host/pr.c                             |   8 +-
 drivers/nvme/host/tcp.c                            | 196 ++++-
 drivers/nvme/target/admin-cmd.c                    |  16 +-
 drivers/nvme/target/configfs.c                     |   4 +-
 drivers/nvme/target/core.c                         |   8 +-
 drivers/nvme/target/nvmet.h                        |   8 +
 drivers/nvme/target/rdma.c                         |   3 +-
 drivers/nvme/target/tcp.c                          |  26 +-
 drivers/nvmem/rockchip-otp.c                       |  24 +-
 drivers/pci/controller/cadence/pcie-cadence-plat.c |  33 +-
 drivers/pci/controller/dwc/pci-imx6.c              |   2 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   2 +
 drivers/pci/controller/dwc/pcie-designware.h       |   1 +
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |  54 ++
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  69 +-
 drivers/pci/pcie/aer.c                             |  23 +-
 drivers/platform/x86/amd/pmf/core.c                |   1 +
 drivers/platform/x86/asus-wmi.c                    |  30 +-
 drivers/platform/x86/intel/int3472/discrete.c      |  53 +-
 drivers/platform/x86/lenovo/Kconfig                |   4 +-
 drivers/platform/x86/lenovo/Makefile               |   2 +-
 .../x86/lenovo/{wmi-capdata01.c => wmi-capdata.c}  | 142 ++--
 .../x86/lenovo/{wmi-capdata01.h => wmi-capdata.h}  |  10 +-
 drivers/platform/x86/lenovo/wmi-other.c            |  11 +-
 drivers/power/supply/ltc2941-battery-gauge.c       |   6 +-
 drivers/ptp/ptp_sysfs.c                            |   6 +-
 drivers/s390/char/vmcp.c                           |   4 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h                 |  26 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   8 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c                 |  20 +-
 drivers/scsi/scsi_bsg.c                            |   6 +-
 drivers/scsi/scsi_ioctl.c                          |  11 +-
 drivers/soc/qcom/pmic_glink_altmode.c              |   4 +-
 drivers/spi/atmel-quadspi.c                        |  34 +-
 drivers/spi/spi-cadence-xspi.c                     | 522 ++++++------
 drivers/target/target_core_device.c                |  18 +-
 drivers/target/target_core_fabric_lib.c            |  10 +
 drivers/target/target_core_tpg.c                   |  10 +-
 drivers/target/target_core_user.c                  |   5 +
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/ufs/core/ufs_bsg.c                         |  13 +
 drivers/ufs/core/ufshcd.c                          |  48 +-
 drivers/vdpa/solidrun/snet_ctrl.c                  |   3 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |  11 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |   3 -
 drivers/vhost/scsi.c                               |   7 +-
 drivers/vhost/vdpa.c                               |   8 +-
 drivers/vhost/vhost.c                              |   3 +-
 drivers/vhost/vringh.c                             |  27 +-
 drivers/vhost/vsock.c                              |  34 +-
 drivers/video/fbdev/core/fb_info.c                 |   1 +
 drivers/video/fbdev/core/fbcon_rotate.c            |   3 +-
 drivers/video/fbdev/nvidia/nvidia.c                |  20 +-
 drivers/video/fbdev/sh_mobile_lcdcfb.c             |  34 +-
 drivers/watchdog/hpwdt.c                           |  24 +-
 drivers/xen/gntdev-dmabuf.c                        |   4 +-
 fs/9p/v9fs.c                                       |  16 +-
 fs/9p/vfs_inode.c                                  |   8 +
 fs/backing-file.c                                  |   5 +-
 fs/btrfs/sysfs.c                                   |   1 +
 fs/buffer.c                                        |  29 -
 fs/ceph/addr.c                                     |   6 +
 fs/ceph/crypto.c                                   |   8 +
 fs/dcache.c                                        |   4 +
 fs/erofs/zdata.c                                   |  11 +-
 fs/exfat/file.c                                    |  18 +-
 fs/ext2/file.c                                     |   3 +-
 fs/ext2/inode.c                                    |  13 +-
 fs/f2fs/checkpoint.c                               |  13 +-
 fs/f2fs/data.c                                     |  25 +-
 fs/f2fs/f2fs.h                                     |   8 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/f2fs/gc.c                                       |   2 +-
 fs/f2fs/node.c                                     |  71 +-
 fs/f2fs/segment.c                                  |   3 +-
 fs/f2fs/super.c                                    |  24 +
 fs/fat/inode.c                                     |   2 +
 fs/fs-writeback.c                                  |  13 +-
 fs/fuse/virtio_fs.c                                |  59 +-
 fs/gfs2/glops.c                                    |  10 +-
 fs/inode.c                                         |  51 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/iomap/direct-io.c                               |  56 +-
 fs/nfs/callback_xdr.c                              |   7 +
 fs/nfs/localio.c                                   |  12 +-
 fs/nfsd/blocklayout.c                              | 125 +--
 fs/nfsd/export.c                                   |   3 +-
 fs/nfsd/nfs2acl.c                                  |  64 +-
 fs/nfsd/nfs3proc.c                                 |  58 +-
 fs/nfsd/nfs3xdr.c                                  |   2 +
 fs/nfsd/nfs4layouts.c                              |  31 +-
 fs/nfsd/nfs4proc.c                                 |  60 +-
 fs/nfsd/nfs4recover.c                              |  49 +-
 fs/nfsd/nfs4state.c                                |  21 +-
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/nfsd/nfsctl.c                                   |  56 +-
 fs/nfsd/nfsproc.c                                  |   2 +-
 fs/nfsd/state.h                                    |   2 +
 fs/nfsd/vfs.c                                      | 108 +--
 fs/nfsd/vfs.h                                      |  21 +-
 fs/nfsd/xdr3.h                                     |   2 +-
 fs/notify/inotify/inotify_fsnotify.c               |   2 +-
 fs/ntfs3/xattr.c                                   |  25 +-
 fs/ocfs2/alloc.c                                   |  20 +-
 fs/ocfs2/cluster/tcp.c                             |   5 +-
 fs/ocfs2/dcache.h                                  |   5 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  70 +-
 fs/ocfs2/dlmglue.c                                 |  34 +-
 fs/ocfs2/filecheck.c                               |   2 +
 fs/ocfs2/journal.c                                 |  15 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/super.c                                   |   3 +
 fs/ocfs2/xattr.c                                   | 120 ++-
 fs/overlayfs/export.c                              |   4 +-
 fs/overlayfs/inode.c                               |   8 +
 fs/overlayfs/namei.c                               |  13 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/overlayfs/super.c                               |  12 +-
 fs/proc/task_mmu.c                                 |   2 +-
 fs/smb/client/cifsglob.h                           |   3 +
 fs/smb/client/cifspdu.h                            | 253 +-----
 fs/smb/client/cifsproto.h                          |   1 +
 fs/smb/client/cifssmb.c                            |  65 +-
 fs/smb/client/connect.c                            |  36 +-
 fs/smb/client/inode.c                              |   8 +-
 fs/smb/client/readdir.c                            |  68 +-
 fs/smb/client/smb2misc.c                           |  15 +
 fs/smb/client/smb2ops.c                            |  14 +-
 fs/smb/client/smb2pdu.c                            |  57 +-
 fs/smb/client/smb2pdu.h                            |  82 --
 fs/smb/client/trace.h                              |   1 +
 fs/smb/common/fscc.h                               | 157 ++++
 fs/smb/common/smb2pdu.h                            | 230 +++++-
 fs/smb/server/mgmt/tree_connect.c                  |   8 +
 fs/smb/server/oplock.c                             |   8 +-
 fs/smb/server/smb2ops.c                            |   6 +-
 fs/smb/server/smb2pdu.c                            | 162 ++--
 fs/smb/server/smb2pdu.h                            |  69 --
 fs/smb/server/smb_common.h                         | 195 +----
 fs/smb/server/smbacl.c                             |   5 +-
 fs/smb/server/vfs.c                                |   6 +-
 fs/smb/server/vfs.h                                |   2 +
 fs/udf/balloc.c                                    |  11 +-
 fs/udf/inode.c                                     |  42 +-
 fs/udf/super.c                                     |  80 +-
 fs/udf/truncate.c                                  |   7 +-
 fs/verity/enable.c                                 |   8 +
 fs/verity/fsverity_private.h                       |   8 +
 fs/verity/measure.c                                |  10 +
 fs/verity/open.c                                   |   9 +
 fs/verity/read_metadata.c                          |  14 +-
 fs/verity/signature.c                              |  55 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |   9 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  14 +-
 fs/xfs/libxfs/xfs_bmap.h                           |  10 +-
 fs/xfs/libxfs/xfs_btree.c                          |   4 +-
 fs/xfs/scrub/attr.c                                | 102 ++-
 fs/xfs/scrub/attr_repair.c                         |  18 +-
 fs/xfs/scrub/dir.c                                 | 110 ++-
 fs/xfs/scrub/dir_repair.c                          | 100 ++-
 fs/xfs/scrub/quota_repair.c                        |  33 +-
 fs/xfs/scrub/xfarray.c                             |  69 +-
 fs/xfs/xfs_aops.c                                  |   2 +-
 fs/xfs/xfs_discard.c                               |  26 +-
 fs/xfs/xfs_export.c                                |   4 +-
 fs/xfs/xfs_ioctl32.c                               |   4 +-
 fs/xfs/xfs_iomap.c                                 |   8 +
 fs/xfs/xfs_pnfs.c                                  |  76 +-
 fs/xfs/xfs_pnfs.h                                  |  11 +-
 include/acpi/cppc_acpi.h                           |   6 +
 include/asm-generic/tlb.h                          |   3 +-
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h     |   3 +-
 include/kvm/arm_arch_timer.h                       |  15 +
 include/linux/backing-dev.h                        |   5 +-
 include/linux/bio.h                                |  15 +
 include/linux/buffer_head.h                        |   3 -
 include/linux/can/can-ml.h                         |   3 +
 include/linux/cgroup.h                             |  65 +-
 include/linux/damon.h                              |   6 +
 include/linux/exportfs.h                           |  22 +-
 include/linux/exportfs_block.h                     |  89 ++
 include/linux/fb.h                                 |   9 +
 include/linux/fs.h                                 |  78 +-
 include/linux/hugetlb.h                            |  24 +-
 include/linux/memcontrol.h                         |  26 +-
 include/linux/memfd.h                              |   9 +
 include/linux/migrate.h                            |   8 +-
 include/linux/mmu_notifier.h                       |   3 +-
 include/linux/nfs4.h                               |   6 +
 include/linux/page_owner.h                         |   7 +-
 include/linux/pagemap.h                            |  11 +
 include/linux/panic.h                              |   3 +-
 include/linux/rculist_nulls.h                      |  59 ++
 include/linux/srcu.h                               |  36 +
 include/linux/sunrpc/clnt.h                        |   3 +-
 include/linux/sunrpc/svc.h                         |   7 +-
 include/linux/writeback.h                          |   4 +
 include/net/espintcp.h                             |   5 +-
 include/net/netns/can.h                            |   2 +-
 include/net/netrom.h                               |  15 +-
 include/net/rose.h                                 |   3 +
 include/net/sctp/sm.h                              |   1 +
 include/sound/hwdep.h                              |   1 +
 include/trace/events/migrate.h                     |   8 +-
 include/uapi/linux/iommufd.h                       |   6 +
 io_uring/cancel.c                                  |  26 +-
 io_uring/poll.c                                    |  62 +-
 io_uring/rsrc.c                                    |  21 +-
 io_uring/sqpoll.c                                  |  26 +-
 ipc/namespace.c                                    |   7 +
 ipc/shm.c                                          |   2 -
 kernel/cgroup/cgroup-internal.h                    |   6 -
 kernel/cgroup/cgroup.c                             |  55 --
 kernel/events/core.c                               |   9 +
 kernel/kexec_handover.c                            |   7 +
 kernel/panic.c                                     |  10 +-
 kernel/sched/ext.c                                 |  14 +-
 kernel/time/posix-stubs.c                          |   4 +-
 kernel/time/posix-timers.c                         |  41 +-
 kernel/time/tick-sched.c                           |  14 +-
 kernel/time/timekeeping.c                          |   5 +
 kernel/trace/trace_events_hist.c                   |   3 +
 lib/cmdline.c                                      |  13 +-
 lib/crypto/Kconfig                                 |   6 +-
 lib/raid6/avx2.c                                   |   6 +
 lib/raid6/avx512.c                                 |   6 +
 lib/raid6/recov_avx2.c                             |   2 +
 lib/raid6/recov_avx512.c                           |   2 +
 lib/tests/cmdline_kunit.c                          | 101 +++
 mm/cma.c                                           |   4 +
 mm/damon/core.c                                    |  68 +-
 mm/damon/sysfs-schemes.c                           |   8 +-
 mm/damon/tests/core-kunit.h                        |  16 +-
 mm/filemap.c                                       |  55 +-
 mm/gup.c                                           |  68 +-
 mm/huge_memory.c                                   |  72 +-
 mm/hugetlb.c                                       | 133 ++-
 mm/hugetlb_vmemmap.c                               |  20 +-
 mm/internal.h                                      |   2 +
 mm/khugepaged.c                                    |  29 +-
 mm/ksm.c                                           |  10 +-
 mm/madvise.c                                       |   9 +
 mm/memcontrol.c                                    | 111 ++-
 mm/memfd.c                                         |  33 +-
 mm/memory-tiers.c                                  |  29 +-
 mm/memory.c                                        |  77 +-
 mm/mempolicy.c                                     |  15 +-
 mm/migrate.c                                       |  17 +-
 mm/mm_init.c                                       |   2 -
 mm/mmu_notifier.c                                  |  24 +-
 mm/mremap.c                                        |  22 +-
 mm/page-writeback.c                                |   8 +-
 mm/page_alloc.c                                    |  71 +-
 mm/page_counter.c                                  |  21 +-
 mm/page_owner.c                                    |   4 +-
 mm/page_vma_mapped.c                               |  22 +-
 mm/shmem.c                                         | 109 ++-
 mm/shmem_quota.c                                   |  28 +-
 mm/swapfile.c                                      |   4 +-
 mm/userfaultfd.c                                   |   5 +-
 mm/vma.c                                           |  65 +-
 mm/vmscan.c                                        |  16 +-
 net/9p/trans_usbg.c                                |  91 ++-
 net/9p/trans_virtio.c                              |   5 +
 net/9p/trans_xen.c                                 |  10 +
 net/ax25/af_ax25.c                                 | 119 ++-
 net/ax25/ax25_ds_timer.c                           |   2 +-
 net/ax25/ax25_in.c                                 |  56 +-
 net/ax25/ax25_ip.c                                 |   9 +-
 net/ax25/ax25_out.c                                |  17 +-
 net/ax25/ax25_std_timer.c                          |   2 +-
 net/ax25/sysctl_net_ax25.c                         |   2 +-
 net/batman-adv/bat_iv_ogm.c                        |   5 +
 net/batman-adv/distributed-arp-table.c             |   1 +
 net/batman-adv/main.c                              |  12 +-
 net/batman-adv/multicast_forw.c                    |   5 +-
 net/batman-adv/tp_meter.c                          |   2 +-
 net/batman-adv/translation-table.c                 | 134 ++-
 net/batman-adv/types.h                             |   8 +-
 net/bluetooth/hci_sync.c                           |  25 +-
 net/bluetooth/l2cap_core.c                         |  47 +-
 net/bluetooth/selftest.c                           |   1 +
 net/bluetooth/smp.c                                |   1 +
 net/can/af_can.c                                   |  53 +-
 net/can/bcm.c                                      |  50 +-
 net/can/gw.c                                       |   7 +-
 net/can/isotp.c                                    | 236 +++---
 net/can/proc.c                                     |  69 +-
 net/can/raw.c                                      | 282 ++++---
 net/core/filter.c                                  |  23 +-
 net/core/net_namespace.c                           |   4 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/cipso_ipv4.c                              |   9 +-
 net/ipv4/inet_connection_sock.c                    |   6 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/inet_timewait_sock.c                      |   4 +-
 net/ipv4/ip_gre.c                                  |   1 +
 net/ipv4/ipmr.c                                    |  28 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp_fastopen.c                            |   2 +-
 net/ipv4/xfrm4_output.c                            |   7 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/datagram.c                                |   4 +
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/ip6_gre.c                                 |   1 +
 net/ipv6/ip6mr.c                                   |   5 +-
 net/ipv6/raw.c                                     |   3 +
 net/l2tp/l2tp_core.c                               |  13 +-
 net/mac80211/tdls.c                                |   3 +-
 net/mac80211/tx.c                                  |  57 +-
 net/mptcp/pm_kernel.c                              |   1 +
 net/mptcp/protocol.c                               |  31 +-
 net/mptcp/protocol.h                               |   4 +-
 net/mptcp/subflow.c                                |  17 +-
 net/mptcp/token.c                                  |  68 +-
 net/mptcp/token_test.c                             |   4 +-
 net/netrom/af_netrom.c                             | 109 ++-
 net/netrom/nr_in.c                                 |  50 +-
 net/netrom/nr_out.c                                |  23 +-
 net/netrom/nr_route.c                              | 100 +--
 net/rds/recv.c                                     |   6 +-
 net/rose/af_rose.c                                 | 130 ++-
 net/rose/rose_in.c                                 |  11 +-
 net/rose/rose_link.c                               |  85 +-
 net/rose/rose_loopback.c                           |   1 +
 net/rose/rose_route.c                              |  67 +-
 net/rose/sysctl_net_rose.c                         |  13 +-
 net/sched/sch_generic.c                            |  41 +-
 net/sched/sch_qfq.c                                |   3 +
 net/sched/sch_taprio.c                             |   5 +
 net/sctp/sm_make_chunk.c                           |  14 +-
 net/sctp/socket.c                                  |  57 +-
 net/smc/smc_rx.c                                   |  39 +-
 net/sunrpc/rpcb_clnt.c                             |  22 +-
 net/sunrpc/svc.c                                   |  42 +-
 net/wireless/reg.c                                 |   3 +
 net/xfrm/espintcp.c                                |  43 +-
 net/xfrm/xfrm_interface_core.c                     |   8 +
 net/xfrm/xfrm_policy.c                             |  11 +-
 rust/kernel/bug.rs                                 |  12 +-
 rust/kernel/cpufreq.rs                             |   4 +-
 sound/core/compress_offload.c                      |  18 +-
 sound/core/control.c                               |  19 +-
 sound/core/hwdep.c                                 |  25 +-
 sound/core/init.c                                  |  23 +-
 sound/core/jack.c                                  |  38 +-
 sound/core/oss/mixer_oss.c                         |  13 +-
 sound/core/oss/pcm_oss.c                           |  21 +-
 sound/core/pcm_native.c                            |  44 +-
 sound/core/rawmidi.c                               |  16 +-
 sound/core/seq/oss/seq_oss.c                       |  21 +-
 sound/core/seq/seq_clientmgr.c                     |  19 +-
 sound/core/sound.c                                 |   9 +-
 sound/core/timer.c                                 |  26 +-
 sound/core/timer_compat.c                          |   1 +
 sound/core/ump_convert.c                           |   2 +-
 sound/hda/codecs/realtek/alc269.c                  | 124 ++-
 sound/hda/codecs/side-codecs/cs35l41_hda.c         |  22 +-
 sound/hda/codecs/side-codecs/tas2781_hda.c         |  27 +-
 sound/pci/cs46xx/dsp_spos.c                        |   2 +
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |   3 +-
 sound/soc/amd/acp-config.c                         |  43 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/hdac_hda.c                        |  25 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |  12 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   6 +-
 sound/soc/qcom/qdsp6/q6prm.c                       |   3 +
 sound/soc/sof/intel/hda-codec.c                    |  23 +-
 sound/soc/stm/stm32_i2s.c                          |  27 +-
 sound/usb/bcd2000/bcd2000.c                        |  20 +-
 sound/usb/caiaq/input.c                            |   2 +
 sound/usb/line6/capture.c                          |  29 +
 sound/usb/midi.c                                   |  64 +-
 sound/usb/misc/ua101.c                             |  29 +-
 sound/usb/usx2y/us122l.c                           |  27 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |   5 +
 sound/usb/usx2y/usb_stream.c                       |   9 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |  43 +-
 sound/x86/intel_hdmi_audio.c                       |   9 +-
 tools/perf/tests/tool_pmu.c                        |  79 ++
 tools/perf/util/evsel.c                            |  30 +-
 tools/perf/util/hwmon_pmu.c                        |   2 +-
 tools/perf/util/python.c                           |   2 +
 tools/perf/util/tool_pmu.c                         |   2 +-
 tools/testing/selftests/landlock/audit_test.c      |   2 +-
 tools/testing/selftests/landlock/net_test.c        |   4 +-
 tools/testing/selftests/landlock/ptrace_test.c     |   2 +-
 tools/testing/selftests/net/fib_nexthops.sh        |  40 +-
 tools/testing/vma/vma_internal.h                   |   2 +
 virt/kvm/guest_memfd.c                             | 125 ++-
 virt/kvm/kvm_main.c                                |  45 +-
 virt/kvm/kvm_mm.h                                  |  18 +-
 645 files changed, 10332 insertions(+), 5997 deletions(-)


