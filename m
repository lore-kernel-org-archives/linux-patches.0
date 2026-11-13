Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585239;
	b=XD/F2jc2p9AerJL2guvvKLZvfHzk7KCtXUgn918Etq7dWyxRvh34rdQhVzg407cC6sM3
	 IQdudMJ1F/RPF3e4+IKnJl8OOSc+c5Yfttf/U0LcFYt6aO9jA/YxBsuv4W2/kni6Q+0EI
	 fX4J73B8IqQsCHKNcIEV2f2MC4wdvuhwCIfi0BI3ui7zwU7kBsZEPwmeCAxJIctWXm1e6
	 kFVEJh1KtIS0rwxeIqmflYYpPUdAsJQ9NcqafLX7J2TPv/JTmgo6XAp/1GSRyJ731Dq0m
	 ntz6N1PJK/7h+hPjHceV0+8q8QDAHgF96BngmLXIXj8q9L3mmcNKhds9kCCIq5rxsNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:User-Agent:X-stable:X-Patchwork-Hint:X-KernelTest-Patch:
	 X-KernelTest-Tree:X-KernelTest-Branch:X-KernelTest-Patches:
	 X-KernelTest-Version:X-KernelTest-Deadline:Content-Type:
	 Content-Transfer-Encoding;
	bh=kK6h5LSj+yTTrcmz3f/6GjO1DPz7jx3DzN6iy3u8zh4=;
	b=sk7abnUXioe7LXvVzEB13BThqeixsl2FOpCkGHpoRDSrwWOQhsObetlPN41JdJhh8RKd
	 5q3qiGKBkbUluwt9ppw9PG46AzJW+gp13JnyYY6OJb3kni7pVatGYtwqLBGd82EF50E/9
	 gGANkTJcPsDcIpsseo473daspyWR+dZROM6uQcB2BGE8giHYMxuhnAgYhyeocfC/J14X8
	 4Yl4WOCHKTuEU9weXdqio2yAxqramousq5oBrKisy6VtASc3+S2zl5YWst6pAOBRpsviL
	 tzzKA9VWdDt72latbMeYatBgtBH48oifu6YZ8jOEYCCOsRgQohK1DxV86LIpnOA/Vvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+9kMzDA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F67606A331;
	Fri, 13 Nov 2026 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+9kMzDA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3180A1F000C4;
	Fri, 13 Nov 2026 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585238;
	bh=kK6h5LSj+yTTrcmz3f/6GjO1DPz7jx3DzN6iy3u8zh4=;
	h=From:To:Cc:Subject:Date;
	b=I+9kMzDAgxV5hUk6e7p3QM5/+NBGpg6KpvJnydcMvERZPsTVEXsD/YlonA3uqt2Dd
	 Znja8MwSLERZqqo3vsRaHzisvTKE4DaEPzDfskqtkob/DZBVmg8BkfH146ApaiQ74c
	 9mpv+839Pdv1Is9GM1HwV/QzF9uYDTwMA8AicFiE=
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
Subject: [PATCH 6.12 000/670] 6.12.118-rc1 review
Date: Fri, 13 Nov 2026 10:42:44 -0500
Message-ID: <20261113153811.177190860@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.118-rc1
X-KernelTest-Deadline: 2026-11-15T15:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.118 release.
There are 670 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.118-rc1

Johan Hovold <johan+linaro@kernel.org>
    media: qcom: camss: vfe: suppress VFE version log spam

José Miguel Castellanos Valladolid <josstamy@gmail.com>
    ALSA: hda/realtek: Enable mute LEDs on HP OmniBook X Flip 14-fm0xxx

Gianluca Balboni <gianluca.balboni06@gmail.com>
    ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx

Armaan Sandhu <armaan.sandhu0504@gmail.com>
    lib/cmdline: fix get_options() count and overflow with large ranges

Shuvam Pandey <shuvampandey1@gmail.com>
    lib/tests: extend cmdline KUnit with next_arg() tests

Brandon Williams <turbine.bmw@gmail.com>
    power: supply: qcom_battmgr: Notify charger supplies of online changes

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd/pmf: Add AMDI0112 ACPI ID

Myeonghun Pak <mhun512@gmail.com>
    fbdev: nvidia: Release write-combining handle on probe failure

Shixiong Ou <oushixiong@kylinos.cn>
    fbdev: nvidia: Convert to managed PCI and ioremap API

Maurizio Casciano <mauriziocasciano7@gmail.com>
    power: supply: core: Honor supplied-from with CONFIG_OF=y

Sebastian Reichel <sebastian.reichel@collabora.com>
    power: supply: core: get rid of of_node

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: core: use power_supply_for_each_psy()

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: core: introduce power_supply_for_each_psy()

Francesco Orlando <francesco.orlando99@libero.it>
    Input: xpad - add GameSir Nova Lite support

Wentao Liang <vulab@iscas.ac.cn>
    power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()

Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
    ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200

Pauli Virtanen <pav@iki.fi>
    ALSA: usb-audio: add volume quirks for MS LifeChat LX-3000

Cryolitia PukNgae <cryolitia@uniontech.com>
    ALSA: usb-audio: rename QUIRK_FLAG_MIXER_MIN_MUTE to QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: omap-sham - fix crypto engine cleanup

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: omap - add omap_sham_unregister_algs helper

Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
    hwmon: (coretemp) Return -ENODATA for invalid temperature readings

Andrea Parri <parri.andrea@gmail.com>
    iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA

Henrik Enquist <henrik.enquist@gmail.com>
    ALSA: aloop: Don't constrain playback params in notify mode

Takashi Iwai <tiwai@suse.de>
    ALSA: aloop: Use guard() for mutex locks

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: avoid broken uffd merge on mremap

David Carlier <devnexen@gmail.com>
    media: ipu6: Fix firmware config leak on stream start

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: always accept EV_SYN in input_event()

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

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: correctly uncharge accountable VMAs in error path

David Hildenbrand (Arm) <david@kernel.org>
    mm/huge_memory: split huge PUDs when adjusting VMA boundaries

Jianyun Gao <jianyungao89@gmail.com>
    dax: fix wrong error code returned from dax_dedupe_file_range_compare()

Hung-Jui Lin <alex.lin.programmer@gmail.com>
    posix-timers: Report zero remaining time for disarmed SIGEV_NONE timers

Breno Leitao <leitao@debian.org>
    ACPI: APEI: accumulate the queued flag across error sections

Bradley Morgan <brads@mainlining.org>
    panic: restore variable arguments to nmi_panic()

Steve Wahl <steve.wahl@hpe.com>
    watchdog/hpwdt: Refine hpwdt message for UV platform

Nam Cao <namcao@linutronix.de>
    panic: Add vpanic()

Sravan Kumar Gundu <sravankumarlpu@gmail.com>
    kernel/panic.c: format kernel-doc comments

Bradley Morgan <brads@mainlining.org>
    panic: flatten nmi_panic control flow

Jinchao Wang <wangjinchao600@gmail.com>
    panic: use panic_try_start() in nmi_panic()

Adrian Ambrozewicz <aambrozewicz@nvidia.com>
    gpiolib: cdev: don't set GPIOD_FLAG_IS_OUT

Yingjie Wang <1075151112@qq.com>
    nvme-tcp: validate the TLS handshake timeout

Sean Young <sean@mess.org>
    media: serial_ir: Fix race condition where timer can be re-armed

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Don't init & online empty nodes

Chao Yu <chao@kernel.org>
    f2fs: fix to invalidate curseg if change_curseg() fails

Christian Brauner <brauner@kernel.org>
    iomap: don't mark unwritten parts of a folio uptodate

Hitesh Patel <hitesh@ebytelogic.com>
    media: qcom: camss: vfe-17x: Fix write master selection for RDI lines

Depeng Shao <quic_depengs@quicinc.com>
    media: qcom: camss: vfe: Move common code into vfe core

Linmao Li <lilinmao@kylinos.cn>
    PCI: cadence: Store the core controller in platform drvdata

Giorgi Kobakhia <gkobakhi@asu.edu>
    ocfs2: fix array out of bound access in __ocfs2_find_path()

Edward Adam Davis <eadavis@qq.com>
    ocfs2: fix oob in __ocfs2_find_path

Caleb Kan <ckan@cloudflare.com>
    stackdepot: stop preallocating after the final pool

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Fix one-shot limitation for perf hardware breakpoints

Nikolaos Karaolidis <nick@karaolidis.com>
    fs: don't lose inodes that another LRU walker is isolating

Qi Xi <xiqi2@huawei.com>
    mm/page_isolation: fix UBSAN shift-out-of-bounds warning

Longlong Xia <xialonglong@kylinos.cn>
    mm/zswap: publish the initial pool with list_add_rcu()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Restore the codec device type on unbind

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: hdac_hda: Allocate the private data at codec driver bind

Jinmeng Zhou <jinmengzhou22@gmail.com>
    mm/hugetlb: charge folios to the target mm's memcg

Josef Bacik <josef@toxicpanda.com>
    mm/vma: don't leak the commit charge on mmap failure

Joanne Koong <joannelkoong@gmail.com>
    fuse: don't drop destination page cache on a zero byte copy reply

Daniel Phillips <daniel.phillips@amd.com>
    amdkfd: Fix memory availability double accounting of kfd pinned objects

Nikolaos Karaolidis <nick@karaolidis.com>
    fs: rotate inodes whose page cache could not be dropped

Kevin Wang <kevin.wang@amd.com>
    drm/amd/pm: reapply umd profile state after recovery

Lijo Lazar <lijo.lazar@amd.com>
    drm/amd/pm: Revert state if force level fails

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: bq27xxx: Ensure poll work is cancelled on remove

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    power: supply: Use devm_mutex_init()

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: bq27xxx_battery: register power supply with power_supply_register()

Thomas Weißschuh <linux@weissschuh.net>
    power: supply: core: add wakeup source inhibit by power_supply_config

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    tpm: tpm2_probe: propagate transport errors

Maciej Kucharek <qchcio@gmail.com>
    drm/amdgpu: reset SI ASIC on MacBookPros with VRAM at 0

Armin Wolf <W_Armin@gmx.de>
    hwmon: (acpi_power_meter) Fix 18.45 TW bug

Alexey Charkov <alchark@flipper.net>
    nvmem: rockchip-otp: Serialize reads

Rosen Penev <rosenp@gmail.com>
    nvmem: rockchip-otp: alloc clks with main struct

Ming Lei <tom.leiming@gmail.com>
    ublk: mark the io command cancelable before publishing it

Andrew Pam <andrew@fastmailteam.com>
    power: supply: cros_charge-control: restore EC state on resume

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: reject CS chunks too large for kvmalloc()

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use (v)memdup_array_user in amdgpu_cs_pass1

Gregory Price <gourry@gourry.net>
    mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()

Wentao Liang <vulab@iscas.ac.cn>
    xen/gntdev: Fix gntdev_dmabuf ref leak in dmabuf_exp_wait_released()

Yao Yiqi <yaoyiqi3@huawei.com>
    fbcon: Retry rotated font allocation after failure

Marc Zyngier <maz@kernel.org>
    KVM: arm64: vgic: Stop the target vcpu when disabling LPIs

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn

Takashi Iwai <tiwai@suse.de>
    ALSA: emux: Fix UAF of soundfont zones at note-on

Takashi Iwai <tiwai@suse.de>
    ALSA: synth: Use guard() for spin locks

Runyu Xiao <runyu.xiao@seu.edu.cn>
    block: amiflop: synchronize flush timer before track flush

Joanne Koong <joannelkoong@gmail.com>
    fuse: don't launder folios of a bad inode

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

Stanley Jhu <stanleyjhu@google.com>
    scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs

Chao Yu <chao@kernel.org>
    f2fs: fix to use bio_in_atomic() in f2fs_read_end_io()

Tal Zussman <tz2294@columbia.edu>
    block: introduce bio_in_atomic()

Kaixuan Li <kaixuanli0131@gmail.com>
    f2fs: bound the SIT/NAT bitmaps by the checkpoint pack

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix subflow bitfield misuse

Chi Zhiling <chizhiling@kylinos.cn>
    exfat: advance valid_size to EOF for append writes

Elena Sakhnovitch <Elena.Sakhnovitch@amd.com>
    drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950

Apurv Mishra <Apurv.Mishra@amd.com>
    drm/amdkfd: Drop workaround for GC v9.4.3 revID 0

Alex Sierra <alex.sierra@amd.com>
    drm/amd: update mtype flags for gfx 9.5.0

Alex Sierra <alex.sierra@amd.com>
    drm/amd: define gc ip version local variable

Andrea Parri <parri.andrea@gmail.com>
    iomap: don't lose a failed direct I/O bio's error when zeroing the tail

Janne Grunau <j@jannau.net>
    wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload

Runyu Xiao <runyu.xiao@seu.edu.cn>
    IB/hfi1: Shutdown self-rearming timers before freeing

Jiaming Zhang <r772577952@gmail.com>
    nilfs2: force clear dirty state when restoring from the shadow map

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: convert nilfs_page_count_clean_buffers() to take a folio

Matthew Wilcox (Oracle) <willy@infradead.org>
    nilfs2: remove nilfs_writepage

Vladyslav Tymoshchuk <tvlad744@gmail.com>
    ASoC: qcom: q6apm-dai: wrap the position of a full ring to 0

Mikulas Patocka <mpatocka@redhat.com>
    dm-bufio: fix non-working memory limit

Geraldo Nascimento <geraldogabriel@gmail.com>
    PCI: rockchip: Drive at 2.5 GT/s, error other speeds

Martin Fuzzey <martin.fuzzey@flowbird.group>
    serial: sc16is7xx: fix data corruption due to unexpected xon/xoff

Karl Mehltretter <kmehltretter@gmail.com>
    irqchip/atmel-aic[5]: Disable interrupts in the irq_pm_shutdown() callbacks

Luxiao Xu <rakukuip@gmail.com>
    mm/memory: constrain generic_access_phys() to page boundary

Zhiling Zou <roxy520tt@gmail.com>
    mm/page_table_check: skip zero pages

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

Joe Damato <joe@dama.to>
    mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: mpu401: shut down timer before freeing MPU

Tobias Schumacher <ts@linux.ibm.com>
    s390/pci: Add error cleanup in zpci_directed_irq_init()

Andrey Misiurov <andrey.misyrov@gmail.com>
    fbdev: core: Initialize modelist in framebuffer_alloc()

Darrick J. Wong <djwong@kernel.org>
    xfarray: don't crash when sorting if array element crosses a folio

Fan Wu <fanwu01@zju.edu.cn>
    media: rockchip: rga: quiesce IRQ before releasing m2m state

Sven Püschel <s.pueschel@pengutronix.de>
    media: rockchip: rga: use clk_bulk api

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Move IN_GUEST_MODE ahead of state being loaded

David Hildenbrand (Arm) <david@kernel.org>
    mm: disallow ioremap'ing ordinary RAM in generic_access_phys()

Marco Scardovi <scardracs@disroot.org>
    platform/x86: asus-wmi: Serialize WMI method evaluations with a mutex

Ma Ke <make_ruc2021@163.com>
    ALSA: hda: cs35l41: Fix ACPI device reference leak on probe failure

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: cs35l41: Use auto-cleanup for put_device()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    mailbox: altera: shut down RX polling timer on channel teardown

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/hdmi: clamp sad_count in ELD proc write handler

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

Chao Yu <chao@kernel.org>
    f2fs: zone: fix to avoid bio split on sequential zone

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Handle period elapsed calls outside the locks

Takashi Iwai <tiwai@suse.de>
    ALSA: line6: Use guard() for spin locks

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    ata: sata_inic162x: remove dangerous broken driver

Bart Van Assche <bvanassche@acm.org>
    ata: libata: Add an argument to ata_eh_reset()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-eh: Simplify reset operation management

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-eh: Remove ata_do_eh()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-eh: Rename and make ata_set_mode() static

Vincent Donnefort <vdonnefort@google.com>
    KVM: arm64: Fix MMFR0 TGRAN advertisement for pVMs

Wentao Liang <vulab@iscas.ac.cn>
    drm/msm/dsi: Fix VM leak in dsi_tx_buf_alloc_6g()

Jiale Yao <yaojiale02@163.com>
    iio: dac: mcp4821: reject devices without match data

Myeonghun Pak <mhun512@gmail.com>
    ASoC: stm: stm32_i2s: request IRQ after regmap initialization

bui duc phuc <phucduc.bui@gmail.com>
    ASoC: stm: stm32_i2s: Drop redundant error messages

Linmao Li <lilinmao@kylinos.cn>
    media: chips-media: wave5: Handle polling IRQ thread failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: ignore non-fatal signals during synchronous log write wait

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: correct return value kernel-doc descriptions for the rest

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: free interrupt before the clock in error path

Vishnu Santhosh <vishnu.santhosh@oss.qualcomm.com>
    dmaengine: qcom: bam_dma: Defer IRQ trigger type to device tree

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (tmp108) Fix jiffies wraparound in conversion-ready check

Yunpeng Tian <shionthanatos@gmail.com>
    udf: validate the device specification EA before using it

Hungyu Lin <dennylin0707@gmail.com>
    mm/page-writeback: avoid 32-bit overflow in dirty threshold shares

Marek Czernohous <marek@czernohous.de>
    drm/nouveau/pci: use config-space MSI rearm on MCP79/MCP7A (NVAC)

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

Guanglei Zhu <zhugl3@xiaopeng.com>
    apparmor: check accept index + 1 is in bounds

Yeoreum Yun <yeoreum.yun@arm.com>
    coresight/etm4: fix missing disable active config

Zhiling Zou <zhilinz@nebusec.ai>
    ipmr: only copy pktinfo to cache reports

Eric Dumazet <edumazet@google.com>
    ipmr: prevent info-leak in pmr_cache_report()

Weibin Liu <liuwb@xiaopeng.com>
    spi: cadence-xspi: reject SDMA transfers larger than the requested length

Jisheng Zhang <jszhang@kernel.org>
    spi: cadence-xspi: group marvell support code together

Hans Zhang <18255117159@163.com>
    spi: cadence-xspi: Use FIELD_MODIFY()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: cadence-xspi: Replace ACPI specifics by agnostic APIs

Luo Jie <quic_luoj@quicinc.com>
    bitfield: Add FIELD_MODIFY() helper

Chris Mason <mason@kernel.org>
    mm/shmem: honour F_SEAL_EXEC when an ACL is set

Kyle Zeng <kylebot@openai.com>
    mm/page_vma_mapped: continue past nonmatching huge PMDs

Jiangshan Yi <yijiangshan@kylinos.cn>
    ceph: fix longname buffer overflow in ceph_fname_to_usr()

Ido Schimmel <idosch@nvidia.com>
    ipmr, ip6mr: validate packets injected into the register vif on xmit

Kuniyuki Iwashima <kuniyu@google.com>
    ipmr: Call ipmr_fib_lookup() under RCU.

David Hildenbrand (Arm) <david@kernel.org>
    mm/userfaultfd: only allocate anon_vma in CoW mappings

Josef Bacik <josef@toxicpanda.com>
    mm/hugetlb: unmap the page where the other VMA maps it

Sinan Turunc <enscrpt@pm.me>
    ALSA: usb-audio: Bound packet copies by the PCM buffer size

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: Validate the host vCPU's VM before reading it under pKVM

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Fix bounce buffer overflow

Yuejie Shi <syjcnss@gmail.com>
    fs/ntfs3: validate the EA value length in ntfs_read_ea()

Vaibhav Nagare <vnagare@redhat.com>
    bnxt_en: don't leave an XDP program installed when the open fails

Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
    userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references

Jun Yang <junvyyang@tencent.com>
    sctp: re-point retained control chunks on association migration

David Lee <david.lee@trailofbits.com>
    sctp: hold shkey across socket migration

Seungjin Bae <eeodqql09@gmail.com>
    usb: typec: ucsi: ccg: Validate altmode index in GET_CURRENT_CAM response

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    crypto: ecc - Handle exceptional points in Shamir multiplication

Yifei Gao <gyf161023@gmail.com>
    misc: fastrpc: fix double-free in fastrpc_map_attach() error path

Kumari Pallavi <kumari.pallavi@oss.qualcomm.com>
    misc: fastrpc: Rename phys to dma_addr for clarity

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Establish memslot<=>guest_memfd bindings *after* memslot is ready

Ge Yang <yangge1116@126.com>
    mm/hugetlb: remove unnecessary holding of hugetlb_lock

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/panel: Fix build error on !CONFIG_OF

Runyu Xiao <runyu.xiao@seu.edu.cn>
    hte: tegra194-test: shut down timer before GPIO release

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: ov5647: fix power cleanup on remove

Thomas Zimmermann <tzimmermann@suse.de>
    drm/panic: Do not use un-escaped URL as format string

Sakari Ailus <sakari.ailus@linux.intel.com>
    platform/x86: int3472: Fix uninitialised variable warning

Casey Connolly <casey.connolly@linaro.org>
    drm/panel: ebbg-ft8719: Set prepare_prev_first

Anusha Srivatsa <asrivats@redhat.com>
    panel/ebbg-ft8719: Use refcounted allocation in place of devm_kzalloc()

Anusha Srivatsa <asrivats@redhat.com>
    drm/panel: Add new helpers for refcounted panel allocatons

Sean Young <sean@mess.org>
    media: redrat3: Error path leaves device in transmitting state

Esben Haabendal <esben@geanix.com>
    iio: light: ltr501: Power down chip if request irq fails

Chao Yu <chao@kernel.org>
    f2fs: fix to check continuousness in f2fs_sync_meta_pages() correctly

Sean Young <sean@mess.org>
    media: ene_ir: Ensure teardown is done in the correct order

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: Add TCEs for 16GB pages when RAM is pre-mapped

Christopher Lusk <clusk@northecho.dev>
    m68k: Fix seccomp filtering on ColdFire and 68000

Daniel Palmer <daniel@0x0f.com>
    m68k: Fix task info flags handling for 68000

Guangshuo Li <lgs201920130244@gmail.com>
    media: i2c: og01a1b: power off sensor on remove

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: i2c: og01a1b: Switch from .s_stream to .enable_streams/.disable_streams

Jiaming Zhang <r772577952@gmail.com>
    gfs2: reject invalid inode sizes

Tom Verdonck <tom.verdonck@inspiral.be>
    hwmon: (tmp102) Fix jiffies wraparound in conversion-ready check

Ali Resool Tuama <aliresool567@gmail.com>
    USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE

Nikhil Solanke <nikhilsolanke5@gmail.com>
    usb: core: Add quirk for 255-bytes initial config read

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: restrict OCFS2_INVALID_SLOT suballoc slot to system inodes

Runyu Xiao <runyu.xiao@seu.edu.cn>
    ALSA: usb-audio: Protect Roland control activation

Robin Snyders <robin@snyders.xyz>
    power: supply: qcom_smbx: validate battery float voltage

Casey Connolly <casey.connolly@linaro.org>
    power: supply: pmi8998_charger: rename to qcom_smbx

Fuad Tabba <fuad.tabba@linux.dev>
    KVM: arm64: timers: Compute an offset-applied CVAL from the current count

Danish Khateeb <danishkhateeb03@gmail.com>
    ALSA: timer: Handle userspace-driven timer ioctls from 32-bit tasks

bui duc phuc <phucduc.bui@gmail.com>
    ALSA: core: Clean up file_operations definitions

Jiale Yao <yaojiale02@163.com>
    iio: adc: ad7192: reject devices without match data

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: adc: ad7192: Revert "properly check spi_get_device_match_data()"

Guangshuo Li <lgs201920130244@gmail.com>
    crypto: omap-des - fix crypto engine cleanup

Ryo Takakura <ryotkkr98@gmail.com>
    crypto: omap - convert from tasklet to BH workqueue

Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
    arm64: dts: qcom: ipq9574: Wire up USB3 PHY PIPE clock to GCC

Qi Xi <xiqi2@huawei.com>
    mm/page_isolation: guard compound_order() against racing

David Hildenbrand <david@redhat.com>
    mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix SBGGR10 Bayer pattern

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: fix ISC_PFG_CFG0_BPS macro name typo

Balakrishnan Sambath <balakrishnan.s@microchip.com>
    media: microchip-isc: store the unshifted PFE_CFG0 BPS value

Wei-Lin Chang <weilin.chang@arm.com>
    KVM: arm64: ptdump: Check the page tables aren't freed when accessing

Fabio Cesari <fabio.cesari@gmail.com>
    iio: light: isl29028: fix runtime PM reference leak on error paths

Sean Christopherson <seanjc@google.com>
    KVM: guest_memfd: Split bind() into prepare()+commit() phases

Judith Mendez <jm@ti.com>
    arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT

Anshul Dalal <anshuld@ti.com>
    arm64: dts: ti: k3-am62*: remove SoC dtsi from common dtsi

Andrew Davis <afd@ti.com>
    arm64: dts: ti: k3-am625-sk: Remove M4 mailbox node redefinition

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Manage virtual NTB and PCI bus lifetime

Abel Vesa <abel.vesa@linaro.org>
    soc: qcom: pmic_glink: Fix device access from worker during suspend

Jakub Szczudlo <jakubszczudlo40@gmail.com>
    iio: adc: ti-ads1100: Fix incorrect reading when datarate changed in single mode

Valentin Kindschi <valentin.kindschi@fiveco.ch>
    Bluetooth: hci_sync: pause advertising for the scan address update

Josef Bacik <josef@toxicpanda.com>
    blk-mq: end the request if getting a keyslot fails

Ge Yang <yangge1116@126.com>
    mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb folios

yangge <yangge1116@126.com>
    mm: replace free hugepage folios after migration

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: mips: Disable Octeon SHA code on little-endian kernels

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

Chengfeng Ye <nicoyip.dev@gmail.com>
    batman-adv: Close OGM aggregation before transmission

Sven Eckelmann <sven@narfation.org>
    batman-adv: Limit number of aggregated packets directly

Abhishek Dubey <adubey@linux.ibm.com>
    powerpc/bpf: fix buffer overflow in JIT for large BPF programs

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    iommu/amd: Force device table to maximum size

Samiullah Khawaja <skhawaja@google.com>
    mm/gup: check folio->mapping under folio lock in memfd_pin_folios()

Zhao Gongyi <zhaogongyi@bytedance.com>
    ata: libata-scsi: reject data-in commands with a data-out buffer

Michal Blaszczyk <michalblk@google.com>
    sched_ext: Reset runnable_at when a task leaves its scheduler

Oliver Hartkopp <socketcan@hartkopp.net>
    can: raw, isotp: copy socket options outside of lock_sock()

SJ Park <sj@kernel.org>
    mm/damon/core: move static variable last_nr_regions to damon_ctx

Ido Schimmel <idosch@nvidia.com>
    vxlan: Stop rejecting dynamic FDB entries with a nexthop ID

Ramin Moussavi <ramin.moussavi@yacoub.de>
    microblaze: restore the ABI argument home area below pt_regs (PTO)

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Preserve the interrupted context's exception registers

Kiryl Shutsemau (Meta) <kas@kernel.org>
    arm64: sdei: Run the event handler on the kernel vectors

Hamid Nassiby <hamid.nassiby@nokia.com>
    Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"

Guanglei Zhu <zhugl3@xiaopeng.com>
    ceph: clamp the inline data length in ceph_fill_inline_data()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: protect the receive lists with a per-device lock

Oliver Hartkopp <socketcan@hartkopp.net>
    can: replace ARPHRD_CAN type checks with can_get_ml_priv()

Marco Ziliani <rylos78@gmail.com>
    ata: libata-pmp: disable the SEMB port on Marvell 88SM9705

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

Erhan Bilgili <erhan.bilgili@gmail.com>
    drm/amdgpu: Report MES ring wait timeouts.

Erhan Bilgili <erhan.bilgili@gmail.com>
    drm/amdgpu: Fix duplicate dependency fence releases

Kylie C <kyliepc@proton.me>
    drm/amd/display: Don't select zero V_TOTAL_MIN/MAX on seamless boot

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

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: keep the CS user fence BO in GTT

Jesse Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: parse CS IBs at the BO offset their VA mapping starts at

Jarkko Sakkinen <jarkko@kernel.org>
    nvme-keyring: Add a missing key_put() call to nvme_tls_key_lookup()

Yitang Yang <yi1tang.yang@gmail.com>
    ublk: add missing DEL_DEV_ASYNC to unprivileged permission check

Yilin Zhang <yilinzhang@moonshot.ai>
    mptcp: do not use Fast Open on MP_JOIN subflows

Daehyeon Ko <4ncienth@gmail.com>
    vhost/vsock: size receive SKBs from declared payload

Alexei Starovoitov <ast@kernel.org>
    net: reject a negative TCP header offset in qdisc_pkt_len_segs_init()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: clamp skb->queue_mapping before indexing the tx queue

Xia Yan <yanxia@cmss.chinamobile.com>
    ipv6: fix device binding after failed datagram connect

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
    xfs: mark the inode preallocated for pNFS write layouts past EOF

Zhe Liu <liuzhe1@kylinos.cn>
    blk-iocost: account flush sequence latency only once

Reid Downing <skibletz@gmail.com>
    xfs: fix wrong compat fields in xfs_ioctl32_bstat_copyin()

Hungyu Lin <dennylin0707@gmail.com>
    block: Return the soft block size for compat BLKBSZGET

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

Yafang Shao <laoar.shao@gmail.com>
    mm/migrate: snapshot the source nid before the misplaced migration

Hungyu Lin <dennylin0707@gmail.com>
    mm/migrate: untag addresses when querying page nodes

Chris Down <chris@chrisdown.name>
    mm: make swapoff interruptible when unusing mms/shmem

Hengyu Liang <hengyul@cs.unc.edu>
    fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls

Samarth Narang <samarth.colleges@gmail.com>
    mm/ksm: keep soft-dirty when merging a page

Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
    mm/page_alloc: mark pages freed by __free_pages_core() as not tagged

Li Zhe <lizhe.67@bytedance.com>
    mm/hugetlb: fix mremap move length truncation

Kyle Zeng <kylebot@openai.com>
    mm/khugepaged: flush deferred unmaps before dropping a failed folio

Mohit Sharma <mohit.sharma@oss.qualcomm.com>
    ASoC: qcom: q6apm: Guard callbacks until probe data is ready

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

Vas Zayarskiy <contact@vasily.cc>
    hwmon: (aquacomputer_d5next) Avoid truncating scaled sensor readings

Guenter Roeck <linux@roeck-us.net>
    hwmon: (coretemp) Check for NULL platform device in hotplug callbacks

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

Lu Yao <yaolu@kylinos.cn>
    drm/i915/gem: Reset err for each fence entry

Jouni Högander <jouni.hogander@intel.com>
    drm/i915/psr: Don't clip plane state destination rectangle

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

Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
    9p: don't decrement a server-owned zero nlink

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    9p/xen: validate the response size from the backend

Andrew Luebke <andrew.luebke@gmail.com>
    scsi: aic79xx: Fix NULL pointer dereference in device reset

Imre Kaloz <kaloz@kernel.org>
    scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()

Maíra Canal <mcanal@igalia.com>
    drm/vc4: Publish the output fence outside of job_lock

Zijing Yin <yzjaurora@gmail.com>
    wifi: cfg80211: fix out-of-bounds read in valid_rule()

Alex Kazinsky <a.kazinsky@ideco.ru>
    wifi: rsi: Skip TX aggregation setup for non-QoS frames

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

Noam D. Eliyahu <noam.d.eliyahu@gmail.com>
    tg3: Invert restart quirk logic to restrict SNP power-down bypass

Zhiling Zou <zhilinz@nebusec.ai>
    ipmr: drop packets with unknown ingress VIF

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

Ruide Cao <caoruide123@gmail.com>
    mptcp: fix MP_CAPABLE token migration when cloning reqsk

Henry Martin <bsdhenrymartin@gmail.com>
    rds: fix out-of-bounds conn_path walks via handshake exthdrs

Yun Zhou <yun.zhou@windriver.com>
    net: erspan: set lltx to avoid sch_direct_xmit deadlock

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    tracing: Add the bucket size to expr_field_str()

Bui Viet Dung <dungvn2345@gmail.com>
    Bluetooth: selftest: Pin module for selftest debugfs file operations

Guangshuo Li <lgs201920130244@gmail.com>
    mfd: ab8500: Fix child device leaks on probe failure

Diego Oliva <diego@bynar.io>
    smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan

Ridong Chen <chenridong@xiaomi.com>
    mm/page_counter: avoid integer overflow in effective_protection()

Jiayuan Chen <jiayuan.chen@linux.dev>
    mm/memcontrol: fix data-race on reading jiffies_64

Benjamin Coddington <ben.coddington@hammerspace.com>
    NFSv4/pnfs: Free the netid when draining a data-server address list

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

Ard Biesheuvel <ardb@kernel.org>
    efi/libstub: arm64: Don't use the platform register x18

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

SJ Park <sj@kernel.org>
    mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total

Marek Vasut <marek.vasut+renesas@mailbox.org>
    PCI: rcar-gen4: Limit Max_Read_Request_Size to 256 Bytes

Frank Li <Frank.Li@nxp.com>
    PCI: Add enable_device() and disable_device() callbacks for bridges

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/vmcp: Initialize full session info to zero

Jeff Layton <jlayton@kernel.org>
    nfsd: shorten extack string returned with dodgy listener

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

Darrick J. Wong <djwong@kernel.org>
    xfs: reduce new btree slack factor if free space is negative

SJ Park <sj@kernel.org>
    mm/damon/core: remove unreachable damos charge_{target,addr}_from

SJ Park <sj@kernel.org>
    mm/damon/core: filter out damos address filter-split failed region

SJ Park <sj@kernel.org>
    mm/damon/paddr: respect folio end for DAMOS actions except STAT

SJ Park <sj@kernel.org>
    mm/damon/core: skip applying scheme if region split for quota fails

Eric Biggers <ebiggers@kernel.org>
    raid6: add missing vzeroupper to AVX2 code

Diego Oliva <diego@bynar.io>
    smb: client: reject FIND data areas that run past the received response

Darrick J. Wong <djwong@kernel.org>
    xfs: reattach dquots after changing inode ids

Darrick J. Wong <djwong@kernel.org>
    xfs: don't try to repair rtsummary if the summary file isn't computed

Darrick J. Wong <djwong@kernel.org>
    xfs: forcibly reset quota timers when upgrading to bigtime during repair

Darrick J. Wong <djwong@kernel.org>
    xfs: reinitialize dquot block if non-first dquot can't load

Darrick J. Wong <djwong@kernel.org>
    xfs: complain loudly when dirtree checker finds broken links

Darrick J. Wong <djwong@kernel.org>
    xfs: don't queue rmap update twice when reaping a fork

Darrick J. Wong <djwong@kernel.org>
    xfs: rescan the AGs if incore delalloc counter is negative

Darrick J. Wong <djwong@kernel.org>
    xfs: mark cow extents bad if there's no rmap mapping for them

Darrick J. Wong <djwong@kernel.org>
    xfs: flag excessive delalloc rt extents as corruption

Qingfang Deng <qingfang.deng@linux.dev>
    pppoe: delete session hash entries by pointer match

Igor Velkov <iav@iav.lv>
    genirq/kexec: Do not take the bus lock of an interrupt chip on the crash path

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

Maciej W. Rozycki <macro@orcam.me.uk>
    PCI: Skip Target Speed quirk on clamped ports with no link

Seiji Nishikawa <snishika@redhat.com>
    nvme-tcp: fix io_work priority inversion when send_mutex is held

Nicolai Buchwitz <nb@tipi-net.de>
    serial: amba-pl011: keep transmitter enabled when disabling RS485

Gael Blivet <gael.blivet@gmail.com>
    ksmbd: look up stream size by exact xattr name

Shivank Garg <shivankg@amd.com>
    KVM: guest_memfd: take the invalidate lock when unbinding a dying file

Keqiang Duan <duankeqiangcym@gmail.com>
    KVM: x86: Clear hardware HLT state when userspace makes a vCPU not-halted

Sean Christopherson <seanjc@google.com>
    KVM: Only bind memslot to guest_memfd instance for CREATE operations

Sean Christopherson <seanjc@google.com>
    KVM: Harden and prepare for modifying existing guest_memfd memslots

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Reject KVM_SET_NESTED_STATE if L1 has EFER.LMA=1 && EFER.LME=0

David Howells <dhowells@redhat.com>
    afs: Fix afs to abort the rxrpc call on send error

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Map flex file layout IDs through the request's user namespace

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Complete a cld upcall when copying its reply fails

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Complete a cld upcall when the daemon closes the pipe

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Move the cld upcall message out of the caller's stack frame

Jeff Layton <jlayton@kernel.org>
    nfsd: clear CALLBACK_RUNNING on failed delegation recall queue

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Send a meaningful CB_RECALL_ANY keep count

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Count the delegations held by each client

Jeff Layton <jlayton@kernel.org>
    nfsd: defer setting NFSD4_CALLBACK_RUNNING in deleg_reaper

Jeff Layton <jlayton@kernel.org>
    nfsd: eliminate cl_ra_cblist and NFSD4_CLIENT_CB_RECALL_ANY

Jeff Layton <jlayton@kernel.org>
    nfsd: prevent callback tasks running concurrently

Jeff Layton <jlayton@kernel.org>
    NFSD: stop registering with rpcbind after a failure in listener_set

Jeff Layton <jlayton@kernel.org>
    SUNRPC: report local rpcbind calls that get no answer

Jeff Layton <jlayton@kernel.org>
    NFSD: report listener creation failures through extack

Jeff Layton <jlayton@kernel.org>
    nfsd: don't offer flexfiles layouts when NFSv3 isn't being served

Chuck Lever <chuck.lever@oracle.com>
    NFSD: map fh_verify() status codes for NFS_ACLv2 replies

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
    smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2

Eduard Zateev <hackerowskiy@gmail.com>
    smb: client: hold server info until cifsd exits

Jinwang Li <jinwang.li@oss.qualcomm.com>
    Bluetooth: L2CAP: Ignore connection responses with wrong ident

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Only accept connection responses to outstanding requests

Siwei Zhang <oss@fourdim.xyz>
    Bluetooth: L2CAP: Reject signalling responses in invalid states

Eric Biggers <ebiggers@kernel.org>
    fsverity: Tell LSMs about signature only after verity is enabled

Yongjian Wang <echoowall@gmail.com>
    Revert "net: advertise TCP MSS from the configured MTU, not the learned PMTU"

Andrew Stellman <astellman@stellman-greene.com>
    nvmet-rdma: fix out-of-bounds write in nvmet_rdma_map_sgl_inline()

Kamil Sawicki <user148783812897@gmail.com>
    net: limit priority VLAN untag depth

Chris Mason <mason@kernel.org>
    backing-file: always end a queued write

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: x86: hdmi: fix chmap array missing terminator entry

David Howells <dhowells@redhat.com>
    rxrpc: Fix update of call->tx_pending without holding lock

Abdifatah Suruur <suruurism@gmail.com>
    smb: client: validate the data area in SMB2_read()


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  10 +
 Documentation/filesystems/fsverity.rst             |   3 +
 Documentation/filesystems/overlayfs.rst            |   3 +-
 Documentation/hwmon/coretemp.rst                   |   3 +
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/ipq9574.dtsi              |   2 +-
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts           |   8 +
 arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi     | 304 +++++++
 arch/arm64/boot/dts/ti/k3-am625-sk.dts             | 308 +------
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi     |   8 -
 arch/arm64/include/asm/sdei.h                      |   3 +-
 arch/arm64/include/asm/suspend.h                   |   2 +-
 arch/arm64/kernel/entry-common.c                   |  40 +-
 arch/arm64/kernel/machine_kexec_file.c             |   2 +
 arch/arm64/kernel/sdei.c                           |  59 +-
 arch/arm64/kernel/topology.c                       |  13 +-
 arch/arm64/kvm/arch_timer.c                        |  16 +-
 arch/arm64/kvm/arm.c                               |  17 +-
 arch/arm64/kvm/hyp/exception.c                     |   5 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |  28 +
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |   3 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   2 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  42 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |   9 +
 arch/arm64/kvm/hyp/vhe/switch.c                    |   3 +-
 arch/arm64/kvm/ptdump.c                            |  50 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  10 +
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
 arch/microblaze/include/asm/entry.h                |  13 +
 arch/microblaze/include/asm/processor.h            |   2 +-
 arch/microblaze/kernel/entry.S                     | 329 ++++----
 arch/microblaze/kernel/hw_exception_handler.S      |   5 +
 arch/microblaze/kernel/process.c                   |   5 +-
 arch/mips/crypto/Kconfig                           |   6 +-
 arch/mips/mm/cex-gen.S                             |  16 +
 arch/mips/pci/ops-mace.c                           |  26 +-
 arch/mips/pci/pci-ip32.c                           |   9 +-
 arch/mips/sgi-ip32/ip32-irq.c                      |  45 +-
 arch/openrisc/kernel/or32_ksyms.c                  |   1 +
 arch/powerpc/net/bpf_jit.h                         |   7 +
 arch/powerpc/net/bpf_jit_comp.c                    |  35 +-
 arch/powerpc/platforms/pseries/iommu.c             |  67 +-
 arch/s390/pci/pci_irq.c                            |  26 +-
 arch/x86/include/asm/cpufeatures.h                 |   5 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   7 +
 arch/x86/include/asm/vmware.h                      |  24 +-
 arch/x86/include/asm/xor_avx.h                     |   4 +
 arch/x86/kernel/acpi/cppc.c                        |  15 +
 arch/x86/kernel/cpu/amd.c                          |   6 +
 arch/x86/kernel/nmi.c                              |   8 +
 arch/x86/kernel/x86_init.c                         |   2 +-
 arch/x86/kvm/mmu/mmu.c                             |  10 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |  11 +-
 arch/x86/kvm/svm/nested.c                          |   1 +
 arch/x86/kvm/vmx/main.c                            |   1 +
 arch/x86/kvm/vmx/nested.c                          |   1 +
 arch/x86/kvm/vmx/vmx.c                             |   2 +-
 arch/x86/kvm/vmx/x86_ops.h                         |   1 +
 arch/x86/kvm/x86.c                                 |  46 +-
 arch/x86/mm/mem_encrypt_identity.c                 |   2 +-
 block/blk-iocost.c                                 |   3 +
 block/blk-mq.c                                     |  14 +-
 block/bsg.c                                        |   5 +-
 block/ioctl.c                                      |   4 +-
 crypto/ecc.c                                       |  33 +-
 crypto/testmgr.c                                   |  10 +-
 crypto/testmgr.h                                   | 339 +++++++-
 drivers/acpi/apei/ghes.c                           |   6 +-
 drivers/acpi/cppc_acpi.c                           |  58 +-
 drivers/acpi/riscv/cppc.c                          |  26 +-
 drivers/ata/Kconfig                                |   7 -
 drivers/ata/Makefile                               |   1 -
 drivers/ata/ahci.c                                 |   6 +-
 drivers/ata/ahci_da850.c                           |   6 +-
 drivers/ata/ahci_dm816.c                           |   2 +-
 drivers/ata/ahci_imx.c                             |  13 +-
 drivers/ata/ahci_qoriq.c                           |   4 +-
 drivers/ata/ahci_xgene.c                           |   8 +-
 drivers/ata/ata_piix.c                             |   4 +-
 drivers/ata/libahci.c                              |  10 +-
 drivers/ata/libata-core.c                          |   4 +-
 drivers/ata/libata-eh.c                            |  80 +-
 drivers/ata/libata-pmp.c                           |  40 +-
 drivers/ata/libata-sata.c                          |   2 +-
 drivers/ata/libata-scsi.c                          |  25 +
 drivers/ata/libata-sff.c                           |  18 +-
 drivers/ata/libata.h                               |  11 +-
 drivers/ata/pata_acpi.c                            |   2 +-
 drivers/ata/pata_ali.c                             |  10 +-
 drivers/ata/pata_amd.c                             |   4 +-
 drivers/ata/pata_artop.c                           |   4 +-
 drivers/ata/pata_atiixp.c                          |   2 +-
 drivers/ata/pata_efar.c                            |   2 +-
 drivers/ata/pata_ep93xx.c                          |   4 +-
 drivers/ata/pata_hpt366.c                          |   2 +-
 drivers/ata/pata_hpt37x.c                          |   4 +-
 drivers/ata/pata_hpt3x2n.c                         |   2 +-
 drivers/ata/pata_icside.c                          |   2 +-
 drivers/ata/pata_it8213.c                          |   2 +-
 drivers/ata/pata_jmicron.c                         |   2 +-
 drivers/ata/pata_marvell.c                         |   2 +-
 drivers/ata/pata_mpiix.c                           |   2 +-
 drivers/ata/pata_ns87410.c                         |   2 +-
 drivers/ata/pata_octeon_cf.c                       |   2 +-
 drivers/ata/pata_oldpiix.c                         |   2 +-
 drivers/ata/pata_opti.c                            |   2 +-
 drivers/ata/pata_optidma.c                         |   2 +-
 drivers/ata/pata_parport/pata_parport.c            |   4 +-
 drivers/ata/pata_pdc2027x.c                        |   2 +-
 drivers/ata/pata_rdc.c                             |   2 +-
 drivers/ata/pata_sis.c                             |   2 +-
 drivers/ata/pata_sl82c105.c                        |   2 +-
 drivers/ata/pata_triflex.c                         |   2 +-
 drivers/ata/pata_via.c                             |   2 +-
 drivers/ata/pdc_adma.c                             |   2 +-
 drivers/ata/sata_dwc_460ex.c                       |   2 +-
 drivers/ata/sata_fsl.c                             |   6 +-
 drivers/ata/sata_highbank.c                        |   2 +-
 drivers/ata/sata_inic162x.c                        | 902 ---------------------
 drivers/ata/sata_mv.c                              |  10 +-
 drivers/ata/sata_nv.c                              |   2 +-
 drivers/ata/sata_promise.c                         |   4 +-
 drivers/ata/sata_qstor.c                           |   4 +-
 drivers/ata/sata_rcar.c                            |   2 +-
 drivers/ata/sata_sil24.c                           |   8 +-
 drivers/ata/sata_svw.c                             |   4 +-
 drivers/ata/sata_sx4.c                             |   2 +-
 drivers/ata/sata_uli.c                             |   2 +-
 drivers/ata/sata_via.c                             |   4 +-
 drivers/block/amiflop.c                            |  69 +-
 drivers/block/ublk_drv.c                           |  17 +-
 drivers/char/hw_random/virtio-rng.c                |   7 +
 drivers/char/tpm/tpm2-cmd.c                        |   3 +-
 drivers/clk/nuvoton/clk-ma35d1.c                   |   7 +-
 drivers/cpufreq/amd-pstate.c                       |  23 +-
 drivers/crypto/omap-aes.c                          |  15 +-
 drivers/crypto/omap-aes.h                          |   2 +-
 drivers/crypto/omap-des.c                          |  19 +-
 drivers/crypto/omap-sham.c                         |  43 +-
 drivers/dma/qcom/bam_dma.c                         |  10 +-
 drivers/firmware/efi/libstub/Makefile              |   2 +-
 drivers/gpio/gpio-pca953x.c                        |   7 +-
 drivers/gpio/gpiolib-cdev.c                        |   5 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  14 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  52 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  14 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |  14 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c           |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c        |   1 -
 drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |  46 +-
 drivers/gpu/drm/amd/amdgpu/ih_v6_0.c               |  13 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c             |   4 +-
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c             |  41 +-
 drivers/gpu/drm/amd/amdgpu/si.c                    |  10 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   5 -
 drivers/gpu/drm/amd/amdkfd/kfd_queue.c             |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c               |  20 +-
 .../amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |   3 +
 .../display/dc/link/protocols/link_dp_capability.c |   6 +-
 .../gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c |   7 +
 .../amd/display/dc/resource/dcn32/dcn32_resource.c |  15 +-
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |   2 +
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                | 143 +++-
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |   1 +
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |  33 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  87 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   2 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  34 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  31 +-
 .../gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c   |  38 +-
 drivers/gpu/drm/bridge/nwl-dsi.c                   |  17 +-
 drivers/gpu/drm/drm_crtc.c                         |  15 +-
 drivers/gpu/drm/drm_panel.c                        |  25 +
 drivers/gpu/drm/drm_panic.c                        |  10 +-
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c           |  40 +-
 drivers/gpu/drm/i915/display/intel_psr.c           |  20 +-
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   2 +-
 drivers/gpu/drm/loongson/lsdc_gem.c                |  14 +-
 drivers/gpu/drm/loongson/lsdc_plane.c              |   2 +-
 drivers/gpu/drm/loongson/lsdc_ttm.c                |  14 +-
 drivers/gpu/drm/loongson/lsdc_ttm.h                |   2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +
 drivers/gpu/drm/nouveau/include/nvkm/subdev/pci.h  |   1 +
 drivers/gpu/drm/nouveau/nvkm/core/subdev.c         |   1 +
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |   2 +-
 .../gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c    |  20 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/Kbuild     |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pci/mcp79.c    |  36 +
 drivers/gpu/drm/panel/panel-ebbg-ft8719.c          |  11 +-
 drivers/gpu/drm/v3d/v3d_sched.c                    |   2 +
 drivers/gpu/drm/vc4/vc4_gem.c                      |  10 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |  10 +-
 drivers/hte/hte-tegra194-test.c                    |   2 +-
 drivers/hwmon/acpi_power_meter.c                   |  10 +-
 drivers/hwmon/aquacomputer_d5next.c                |  58 +-
 drivers/hwmon/asus_wmi_sensors.c                   |  13 +-
 drivers/hwmon/chipcap2.c                           |  53 +-
 drivers/hwmon/coretemp.c                           |  27 +-
 drivers/hwmon/corsair-cpro.c                       |   3 +-
 drivers/hwmon/hp-wmi-sensors.c                     |  29 +-
 drivers/hwmon/lm70.c                               |   8 +-
 drivers/hwmon/lm87.c                               |   7 +-
 drivers/hwmon/nct6683.c                            |   4 +-
 drivers/hwmon/nct6775-platform.c                   |  24 +
 drivers/hwmon/peci/dimmtemp.c                      |  21 +-
 drivers/hwmon/pmbus/pmbus_core.c                   |  51 +-
 drivers/hwmon/pmbus/q54sj108a2.c                   |   2 +
 drivers/hwmon/tmp102.c                             |   8 +-
 drivers/hwmon/tmp108.c                             |   8 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   3 +
 drivers/iio/adc/ad7192.c                           |   2 +-
 drivers/iio/adc/ti-ads1100.c                       | 121 ++-
 drivers/iio/dac/mcp4821.c                          |   7 +-
 drivers/iio/light/isl29028.c                       |  23 +-
 drivers/iio/light/ltr501.c                         |   2 +-
 drivers/iio/pressure/dps310.c                      |   6 +-
 drivers/infiniband/hw/hfi1/chip.c                  |   4 +-
 drivers/input/input.c                              |   4 +-
 drivers/input/joystick/xpad.c                      |   1 +
 drivers/iommu/amd/init.c                           |  37 +-
 drivers/iommu/iommufd/io_pagetable.c               |   2 +-
 drivers/iommu/iommufd/iova_bitmap.c                |  19 +-
 drivers/iommu/virtio-iommu.c                       |   6 +-
 drivers/irqchip/irq-atmel-aic.c                    |   5 +-
 drivers/irqchip/irq-atmel-aic5.c                   |   5 +-
 drivers/mailbox/mailbox-altera.c                   |   2 +-
 drivers/md/dm-bufio.c                              |  41 +-
 drivers/media/common/cypress_firmware.c            |   2 +
 drivers/media/i2c/adv748x/adv748x-core.c           |  13 +-
 drivers/media/i2c/og01a1b.c                        |  97 +--
 drivers/media/i2c/ov5647.c                         |   4 +
 drivers/media/pci/intel/ipu6/ipu6-fw-isys.c        |  29 +-
 .../media/platform/chips-media/wave5/wave5-vpu.c   |   7 +
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |   4 +-
 .../media/platform/microchip/microchip-isc-base.c  |  20 +-
 .../media/platform/microchip/microchip-isc-regs.h  |  16 +-
 drivers/media/platform/microchip/microchip-isc.h   |   4 +-
 .../platform/microchip/microchip-sama5d2-isc.c     |  20 +-
 .../platform/microchip/microchip-sama7g5-isc.c     |  20 +-
 drivers/media/platform/qcom/camss/camss-vfe-17x.c  | 153 +---
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  |   9 -
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c  |  11 -
 drivers/media/platform/qcom/camss/camss-vfe-4-8.c  |  11 -
 drivers/media/platform/qcom/camss/camss-vfe-480.c  | 276 +------
 drivers/media/platform/qcom/camss/camss-vfe.c      | 268 ++++++
 drivers/media/platform/qcom/camss/camss-vfe.h      |  58 +-
 drivers/media/platform/rockchip/rga/rga.c          |  69 +-
 drivers/media/platform/rockchip/rga/rga.h          |   7 +-
 drivers/media/rc/ene_ir.c                          |   4 +-
 drivers/media/rc/redrat3.c                         |  11 +-
 drivers/media/rc/serial_ir.c                       |   2 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |   2 +
 drivers/media/usb/uvc/uvc_driver.c                 |  20 +
 drivers/mfd/ab8500-core.c                          |  44 +-
 drivers/mfd/twl-core.c                             |  25 +-
 drivers/misc/fastrpc.c                             |  81 +-
 drivers/mtd/nand/raw/Kconfig                       |   3 +-
 drivers/mtd/nand/raw/ndfc.c                        |  41 +-
 drivers/net/can/dev/netlink.c                      |   4 +-
 drivers/net/can/dev/skb.c                          |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   7 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  33 +
 drivers/net/ethernet/broadcom/bgmac.c              |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  54 +-
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
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  14 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   1 +
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
 drivers/nvme/host/tcp.c                            | 207 ++++-
 drivers/nvme/target/admin-cmd.c                    |   9 +
 drivers/nvme/target/configfs.c                     |   4 +-
 drivers/nvme/target/rdma.c                         |   3 +-
 drivers/nvmem/rockchip-otp.c                       |  24 +-
 drivers/pci/controller/cadence/pcie-cadence-plat.c |  33 +-
 drivers/pci/controller/dwc/pcie-designware.c       |   2 +
 drivers/pci/controller/dwc/pcie-designware.h       |   1 +
 drivers/pci/controller/dwc/pcie-rcar-gen4.c        |  54 ++
 drivers/pci/controller/pcie-rockchip.c             |  14 +-
 drivers/pci/controller/pcie-rockchip.h             |   3 -
 drivers/pci/endpoint/functions/pci-epf-vntb.c      |  69 +-
 drivers/pci/pci.c                                  |  36 +-
 drivers/pci/quirks.c                               |   8 +-
 drivers/platform/x86/amd/pmf/core.c                |   1 +
 drivers/platform/x86/asus-wmi.c                    |  30 +-
 drivers/platform/x86/intel/int3472/discrete.c      |  18 +-
 drivers/power/supply/Makefile                      |   2 +-
 drivers/power/supply/bq27xxx_battery.c             |  24 +-
 drivers/power/supply/cros_charge-control.c         |  29 +-
 drivers/power/supply/ltc2941-battery-gauge.c       |   6 +-
 drivers/power/supply/mt6370-charger.c              |  11 +-
 drivers/power/supply/power_supply_core.c           | 166 ++--
 drivers/power/supply/qcom_battmgr.c                |  26 +-
 .../supply/{qcom_pmi8998_charger.c => qcom_smbx.c} | 209 +++--
 drivers/power/supply/rt9467-charger.c              |  33 +-
 drivers/ptp/ptp_sysfs.c                            |   6 +-
 drivers/s390/char/vmcp.c                           |   4 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h                 |  26 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   8 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c                 |  20 +-
 drivers/scsi/libsas/sas_ata.c                      |   4 +-
 drivers/scsi/scsi_bsg.c                            |   6 +-
 drivers/scsi/scsi_ioctl.c                          |  11 +-
 drivers/soc/qcom/pmic_glink_altmode.c              |   4 +-
 drivers/spi/spi-cadence-xspi.c                     | 522 ++++++------
 drivers/target/target_core_fabric_lib.c            |  10 +
 drivers/target/target_core_user.c                  |   5 +
 drivers/tty/serial/amba-pl011.c                    |  15 +-
 drivers/tty/serial/sc16is7xx.c                     |  14 +-
 drivers/ufs/core/ufs_bsg.c                         |  13 +
 drivers/ufs/core/ufshcd.c                          |  48 +-
 drivers/usb/core/config.c                          |  32 +-
 drivers/usb/core/quirks.c                          |   7 +
 drivers/usb/host/xhci-ring.c                       |   9 +-
 drivers/usb/typec/ucsi/ucsi_ccg.c                  |  21 +-
 drivers/vdpa/solidrun/snet_ctrl.c                  |   3 +-
 drivers/vdpa/vdpa_user/iova_domain.c               |  11 +-
 drivers/vhost/vdpa.c                               |   8 +-
 drivers/vhost/vringh.c                             |  27 +-
 drivers/vhost/vsock.c                              |  34 +-
 drivers/video/fbdev/core/fb_info.c                 |   1 +
 drivers/video/fbdev/core/fbcon_rotate.c            |   3 +-
 drivers/video/fbdev/nvidia/nvidia.c                |  20 +-
 drivers/watchdog/hpwdt.c                           |  24 +-
 drivers/xen/gntdev-dmabuf.c                        |   4 +-
 fs/9p/v9fs.c                                       |  16 +-
 fs/9p/vfs_inode.c                                  |   8 +
 fs/afs/rxrpc.c                                     |  49 +-
 fs/backing-file.c                                  |   5 +-
 fs/btrfs/sysfs.c                                   |   1 +
 fs/ceph/addr.c                                     |   6 +
 fs/ceph/crypto.c                                   |   8 +
 fs/dax.c                                           |   2 +-
 fs/erofs/zdata.c                                   |  11 +-
 fs/exfat/file.c                                    |  18 +-
 fs/ext2/file.c                                     |   3 +-
 fs/ext2/inode.c                                    |  13 +-
 fs/f2fs/checkpoint.c                               |   9 +-
 fs/f2fs/data.c                                     |  20 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/f2fs/node.c                                     |  55 +-
 fs/f2fs/segment.c                                  |   3 +-
 fs/f2fs/super.c                                    |  24 +
 fs/fat/inode.c                                     |   2 +
 fs/fs-writeback.c                                  |   8 +
 fs/fuse/file.c                                     |  12 +-
 fs/fuse/virtio_fs.c                                |  59 +-
 fs/gfs2/glops.c                                    |  10 +-
 fs/inode.c                                         |  15 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/iomap/direct-io.c                               |  15 +-
 fs/nfs/callback_xdr.c                              |   7 +
 fs/nfs/filelayout/filelayoutdev.c                  |  17 +-
 fs/nfs/flexfilelayout/flexfilelayoutdev.c          |  17 +-
 fs/nfs/pnfs.h                                      |   1 +
 fs/nfs/pnfs_nfs.c                                  |  21 +-
 fs/nfsd/blocklayout.c                              |   4 +-
 fs/nfsd/flexfilelayout.c                           |  24 +-
 fs/nfsd/flexfilelayoutxdr.c                        |   4 +-
 fs/nfsd/flexfilelayoutxdr.h                        |   5 +-
 fs/nfsd/nfs2acl.c                                  |  18 +
 fs/nfsd/nfs4callback.c                             |   2 +
 fs/nfsd/nfs4layouts.c                              |  14 +-
 fs/nfsd/nfs4proc.c                                 |   4 +-
 fs/nfsd/nfs4recover.c                              |  49 +-
 fs/nfsd/nfs4state.c                                |  53 +-
 fs/nfsd/nfsctl.c                                   |  56 +-
 fs/nfsd/pnfs.h                                     |   4 +-
 fs/nfsd/state.h                                    |  13 +-
 fs/nilfs2/dir.c                                    |   2 +-
 fs/nilfs2/gcinode.c                                |  24 +-
 fs/nilfs2/inode.c                                  |  49 +-
 fs/nilfs2/ioctl.c                                  |   2 +-
 fs/nilfs2/mdt.c                                    |   6 +-
 fs/nilfs2/page.c                                   |  54 +-
 fs/nilfs2/page.h                                   |   8 +-
 fs/nilfs2/recovery.c                               |  32 +-
 fs/nilfs2/segbuf.c                                 |  12 +-
 fs/nilfs2/segment.c                                |  54 +-
 fs/nilfs2/the_nilfs.c                              |  12 +-
 fs/notify/inotify/inotify_fsnotify.c               |   2 +-
 fs/ntfs3/xattr.c                                   |  25 +-
 fs/ocfs2/alloc.c                                   |  18 +-
 fs/ocfs2/cluster/tcp.c                             |   5 +-
 fs/ocfs2/dcache.h                                  |   5 +-
 fs/ocfs2/dlm/dlmmaster.c                           |  70 +-
 fs/ocfs2/dlmglue.c                                 |  34 +-
 fs/ocfs2/filecheck.c                               |   2 +
 fs/ocfs2/inode.c                                   |  37 +-
 fs/ocfs2/journal.c                                 |  15 +-
 fs/ocfs2/journal.h                                 |   1 +
 fs/ocfs2/super.c                                   |   3 +
 fs/ocfs2/xattr.c                                   | 120 ++-
 fs/overlayfs/export.c                              |   4 +-
 fs/overlayfs/namei.c                               |  13 +-
 fs/overlayfs/overlayfs.h                           |   2 +-
 fs/proc/task_mmu.c                                 |   2 +-
 fs/smb/client/cifsglob.h                           |   2 +
 fs/smb/client/cifssmb.c                            |  59 +-
 fs/smb/client/connect.c                            |  33 +-
 fs/smb/client/inode.c                              |   4 +-
 fs/smb/client/readdir.c                            |  66 +-
 fs/smb/client/smb2misc.c                           |  15 +
 fs/smb/client/smb2pdu.c                            |  41 +-
 fs/smb/server/smb2pdu.c                            |  28 +-
 fs/smb/server/smbacl.c                             |   5 +-
 fs/smb/server/vfs.c                                |   4 +-
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
 fs/xfs/libxfs/xfs_btree.c                          |   4 +-
 fs/xfs/scrub/attr.c                                | 102 ++-
 fs/xfs/scrub/attr_repair.c                         |  18 +-
 fs/xfs/scrub/cow_repair.c                          |  66 +-
 fs/xfs/scrub/dir.c                                 | 110 ++-
 fs/xfs/scrub/dir_repair.c                          | 100 ++-
 fs/xfs/scrub/dirtree.c                             |   4 +-
 fs/xfs/scrub/fscounters.c                          |  24 +-
 fs/xfs/scrub/inode_repair.c                        | 132 ++-
 fs/xfs/scrub/newbt.c                               |   2 +-
 fs/xfs/scrub/quota_repair.c                        |  33 +-
 fs/xfs/scrub/reap.c                                |   4 +-
 fs/xfs/scrub/rtsummary.c                           |   9 +-
 fs/xfs/scrub/rtsummary.h                           |   1 +
 fs/xfs/scrub/rtsummary_repair.c                    |   2 +-
 fs/xfs/scrub/xfarray.c                             |  22 +-
 fs/xfs/xfs_discard.c                               |  26 +-
 fs/xfs/xfs_ioctl32.c                               |   4 +-
 fs/xfs/xfs_iomap.c                                 |   8 +
 fs/xfs/xfs_pnfs.c                                  |  51 +-
 include/acpi/cppc_acpi.h                           |   6 +
 include/asm-generic/tlb.h                          |   3 +-
 include/drm/drm_panel.h                            |  22 +
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h     |   3 +-
 include/kvm/arm_arch_timer.h                       |  15 +
 include/linux/bio.h                                |  15 +
 include/linux/bitfield.h                           |  21 +-
 include/linux/can/can-ml.h                         |   3 +
 include/linux/damon.h                              |   6 +
 include/linux/hugetlb.h                            |  22 +-
 include/linux/libata.h                             |  26 +-
 include/linux/memcontrol.h                         |  10 +
 include/linux/memfd.h                              |   9 +
 include/linux/mm.h                                 |   6 +-
 include/linux/mmu_notifier.h                       |   3 +-
 include/linux/panic.h                              |   6 +-
 include/linux/pci.h                                |   2 +
 include/linux/power_supply.h                       |   4 +-
 include/linux/srcu.h                               |  36 +
 include/linux/sunrpc/clnt.h                        |   3 +-
 include/linux/sunrpc/svc.h                         |   7 +-
 include/linux/usb/quirks.h                         |   3 +
 include/net/espintcp.h                             |   5 +-
 include/net/ip.h                                   |  25 -
 include/net/ip6_route.h                            |  37 -
 include/net/netns/can.h                            |   2 +-
 include/net/netrom.h                               |  15 +-
 include/net/rose.h                                 |   3 +
 include/net/sctp/sm.h                              |   1 +
 include/sound/hwdep.h                              |   1 +
 include/trace/events/rxrpc.h                       |   2 +-
 include/uapi/linux/iommufd.h                       |   6 +
 io_uring/cancel.c                                  |   3 +-
 io_uring/io_uring.c                                |  23 +-
 io_uring/poll.c                                    |  77 +-
 io_uring/rsrc.c                                    |  21 +-
 io_uring/sqpoll.c                                  |  26 +-
 kernel/events/core.c                               |   9 +
 kernel/irq/internals.h                             |   1 +
 kernel/irq/kexec.c                                 |   2 +-
 kernel/irq/manage.c                                |  49 +-
 kernel/panic.c                                     |  41 +-
 kernel/sched/ext.c                                 |  14 +-
 kernel/time/posix-stubs.c                          |   4 +-
 kernel/time/posix-timers.c                         |  22 +-
 kernel/time/tick-sched.c                           |  14 +-
 kernel/trace/trace_events_hist.c                   |   3 +
 lib/cmdline.c                                      |  13 +-
 lib/cmdline_kunit.c                                | 101 +++
 lib/raid6/avx2.c                                   |   6 +
 lib/raid6/avx512.c                                 |   6 +
 lib/raid6/recov_avx2.c                             |   2 +
 lib/raid6/recov_avx512.c                           |   2 +
 lib/stackdepot.c                                   |   2 +-
 mm/damon/core.c                                    |  64 +-
 mm/damon/paddr.c                                   |   6 +-
 mm/damon/tests/core-kunit.h                        |  11 +-
 mm/filemap.c                                       |  55 +-
 mm/gup.c                                           |  36 +-
 mm/huge_memory.c                                   |  70 +-
 mm/hugetlb.c                                       | 117 ++-
 mm/khugepaged.c                                    |  10 +-
 mm/ksm.c                                           |  10 +-
 mm/madvise.c                                       |   9 +
 mm/memcontrol.c                                    |  84 +-
 mm/memfd.c                                         |   2 +
 mm/memory.c                                        |  45 +-
 mm/mempolicy.c                                     |  15 +-
 mm/migrate.c                                       |   5 +-
 mm/mm_init.c                                       |   2 -
 mm/mmap.c                                          |  11 +-
 mm/mmu_notifier.c                                  |  24 +-
 mm/mremap.c                                        |  15 +
 mm/page-writeback.c                                |  12 +-
 mm/page_alloc.c                                    |  25 +-
 mm/page_counter.c                                  |  21 +-
 mm/page_isolation.c                                |  40 +-
 mm/page_owner.c                                    |   2 +-
 mm/page_table_check.c                              |   6 +-
 mm/page_vma_mapped.c                               |  22 +-
 mm/shmem.c                                         |  87 +-
 mm/shmem_quota.c                                   |  28 +-
 mm/swapfile.c                                      |   4 +-
 mm/userfaultfd.c                                   |  11 +-
 mm/vma.c                                           |   5 +-
 mm/vmscan.c                                        |  16 +-
 mm/zswap.c                                         |   2 +-
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
 net/batman-adv/bat_iv_ogm.c                        |   9 +
 net/batman-adv/distributed-arp-table.c             |   1 +
 net/batman-adv/main.c                              |  12 +-
 net/batman-adv/main.h                              |   3 -
 net/batman-adv/multicast_forw.c                    |   5 +-
 net/batman-adv/tp_meter.c                          |   2 +-
 net/batman-adv/translation-table.c                 | 145 ++--
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
 net/can/raw.c                                      | 132 ++-
 net/core/dev.c                                     |  10 +-
 net/core/filter.c                                  |  23 +-
 net/core/sock.c                                    |   6 +-
 net/ipv4/cipso_ipv4.c                              |   9 +-
 net/ipv4/inet_connection_sock.c                    |   6 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/inet_timewait_sock.c                      |   4 +-
 net/ipv4/ip_gre.c                                  |   1 +
 net/ipv4/ipmr.c                                    |  31 +-
 net/ipv4/route.c                                   |   4 +-
 net/ipv4/syncookies.c                              |   2 +-
 net/ipv4/tcp_fastopen.c                            |   2 +-
 net/ipv6/addrconf.c                                |   3 +-
 net/ipv6/datagram.c                                |   4 +
 net/ipv6/inet6_hashtables.c                        |   2 +-
 net/ipv6/ip6_gre.c                                 |   1 +
 net/ipv6/ip6mr.c                                   |   5 +-
 net/ipv6/raw.c                                     |   3 +
 net/ipv6/route.c                                   |   2 +-
 net/l2tp/l2tp_core.c                               |  13 +-
 net/mac80211/tdls.c                                |   3 +-
 net/mac80211/tx.c                                  |  57 +-
 net/mptcp/pm_kernel.c                              |   1 +
 net/mptcp/protocol.c                               |  31 +-
 net/mptcp/protocol.h                               |  10 +-
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
 net/rxrpc/sendmsg.c                                |  59 +-
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
 security/apparmor/policy_unpack.c                  |  19 +-
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
 sound/drivers/aloop.c                              | 103 +--
 sound/drivers/mpu401/mpu401_uart.c                 |   8 +-
 sound/pci/cs46xx/dsp_spos.c                        |   2 +
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |   3 +-
 sound/pci/hda/cs35l41_hda.c                        |  22 +-
 sound/pci/hda/hda_eld.c                            |   6 +-
 sound/pci/hda/patch_hdmi.c                         |   3 +-
 sound/pci/hda/patch_realtek.c                      |  10 +-
 sound/soc/amd/acp-config.c                         |  43 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/hdac_hda.c                        |  25 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |  12 +-
 sound/soc/qcom/qdsp6/q6apm.c                       |   6 +-
 sound/soc/qcom/qdsp6/q6prm.c                       |   3 +
 sound/soc/sof/intel/hda-codec.c                    |  23 +-
 sound/soc/stm/stm32_i2s.c                          |  27 +-
 sound/synth/emux/emux_effect.c                     |  29 +-
 sound/synth/emux/emux_synth.c                      |  57 +-
 sound/synth/emux/soundfont.c                       |  70 +-
 sound/usb/bcd2000/bcd2000.c                        |  20 +-
 sound/usb/caiaq/input.c                            |   2 +
 sound/usb/line6/capture.c                          |  58 +-
 sound/usb/line6/capture.h                          |   2 +-
 sound/usb/line6/driver.c                           |  29 +-
 sound/usb/line6/midi.c                             |  10 +-
 sound/usb/line6/pcm.c                              |  27 +-
 sound/usb/line6/playback.c                         |  31 +-
 sound/usb/midi.c                                   |  22 +-
 sound/usb/mixer.c                                  |   8 +
 sound/usb/mixer_quirks.c                           |   7 +-
 sound/usb/pcm.c                                    |  20 +-
 sound/usb/quirks.c                                 |  24 +-
 sound/usb/usbaudio.h                               |   4 +-
 sound/usb/usx2y/us122l.c                           |  27 +-
 sound/usb/usx2y/usX2Yhwdep.c                       |   5 +
 sound/usb/usx2y/usb_stream.c                       |   9 +-
 sound/usb/usx2y/usbusx2yaudio.c                    |  43 +-
 sound/x86/intel_hdmi_audio.c                       |   9 +-
 tools/arch/x86/include/asm/cpufeatures.h           |   5 +
 tools/testing/selftests/net/fib_nexthops.sh        |  40 +-
 tools/testing/vma/vma_internal.h                   |   2 +
 virt/kvm/guest_memfd.c                             | 123 ++-
 virt/kvm/kvm_main.c                                |  45 +-
 virt/kvm/kvm_mm.h                                  |  18 +-
 707 files changed, 10867 insertions(+), 6128 deletions(-)


