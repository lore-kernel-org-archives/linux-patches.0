Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395EF5326D2;
	Wed, 23 Sep 2026 14:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172474; cv=none; b=I9lfQBYdpsnXfXzre9MizlJmUH/jEcTQ3oPppHzQt1SQiXCEWcJ2vEQmoOIOuSHQis/F2pPExuplb+uX6ogFfM7BIZU6fe/ptBtgU7/CEyPDi5cLqlco7CTe8AZMRC7oVB/uAu2UPLzupMA/7Yj2MqtqFh1m3QaxRJ5EbpadENY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172474; c=relaxed/simple;
	bh=vynCeawvYJ8ayYn4tfJf1eW1vHe+AVK6Ev0MEPp/d9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uWKyCgfOq/4I59+4t6Iz/eGjUoG5FzK7FrCSq/EWO6w0vtUf0fEgYOO5P3J8RKXmq0eKaE3h/Jbx0nIShSlPxI1nNvwiuw0kLa4/y182fTJn7My/7uVr+CJIokjMH99XV/nwv/RuCN62Gk8YrQqvWJZHRROsqjDQZ897zeT4QR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz3rCsdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz3rCsdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901961F0089A;
	Wed, 23 Sep 2026 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172469;
	bh=HoEqObpS36TEKy4kfIUVaOucG5YgyXAAmmgzymTij5k=;
	h=From:To:Cc:Subject:Date;
	b=kz3rCsdHb5tLvW2GC+0UiywGFaSXls0tKiP2hYKEAQhKLRPn1x+sY+zyI15mCMdDe
	 /5yo6JzBfHvDw9/NURJymdgcSGq4YABx8vX81mZnsyo1IDQlMLtsQB8J1oIkZjJvUB
	 njXhIriWxzw5IU5GzZOt/rvAD5au6UaczIRYrMxM=
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
Subject: [PATCH 7.2 000/438] 7.2.8-rc1 review
Date: Wed, 23 Sep 2026 16:00:21 +0200
Message-ID: <20260923140644.756254324@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.8-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.8-rc1
X-KernelTest-Deadline: 2026-09-25T14:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.8 release.
There are 438 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Sep 2026 14:05:46 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.8-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.8-rc1

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix partial normalized name responses

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: restrict BAR0 fallback read to SR-IOV VFs only

Vadim Nikitushkin <bub4z0r@gmail.com>
    drm/ttm: fix swapped-out resources never leaving their bulk_move range

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    ntsync: reject wait ioctls with zero owner

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Fix GPU PCIe link capability reporting

chong li <chongli2@amd.com>
    drm/amdgpu: reduce early full GPU access during SR-IOV init

Arun Easi <aeasi@cisco.com>
    scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU

Karan Tilak Kumar <kartilak@cisco.com>
    scsi: fnic: Bump up version number

Karan Tilak Kumar <kartilak@cisco.com>
    scsi: fnic: Make debug logging protocol independent

Qi Zheng <qi.zheng@linux.dev>
    fs: fix missed removal of super_fs_objects_eligible()

Usama Arif <usama.arif@linux.dev>
    fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix missing iov bounds check in parse_posix_sids()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix missing lower-bound check on DFS referral string offsets

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix server->total_read for compound encrypted PDUs

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix reparse buffer bounds in cifs_query_reparse_point()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix potential OOB read in smb3_enum_snapshots()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()

Frank Sorenson <sorenson@redhat.com>
    smb: client: fix next_buffer UAF and NextCommand bounds in compound PDUs

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix fattr leaking on wsl_to_fattr() failure

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix unaligned access in WSL reparse point parser

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix smbd_connection leak on cifs_get_tcp_session() error

Frank Sorenson <sorenson@redhat.com>
    smb: client: reject short Next offsets in parse_server_interfaces()

Joseph Qi <joseph.qi@linux.alibaba.com>
    smb: client: fix use-after-free of iface in cifs_try_adding_channels()

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix rlist race and missing initialization

April Cardenas <april.cardenas@canonical.com>
    smb/client: send lease break ACKs thru correct session for multiuser mounts

Paulo Alcantara <pc@manguebit.org>
    smb: client: cancel reconnect work in clean_demultiplex_info()

Vladimir Marioukhine <Vladimir.Marioukhine@amd.com>
    drm/amdkfd: implement restore_mqd callbacks for GFX12/12.1

David Francis <David.Francis@amd.com>
    drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc

David Francis <David.Francis@amd.com>
    drm/amdkfd: Avoid integer underflow in EOP ring size calculation.

Mario Limonciello <mario.limonciello@amd.com>
    drm/amdgpu: Skip KFD mapping clear before initialization

Mike Lothian <mike@fireburn.co.uk>
    drm/amdgpu: hold a runtime PM reference for P2P dma-buf attachments

Chengjun Yao <Chengjun.Yao@amd.com>
    drm/amdgpu: fix rmmio iounmap skipped on device removal

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/sched: Fix virtual runtime race

Jonghyuk Kim(MalHyuk) <malhyuk97@gmail.com>
    drm/msm: RCU-free the scheduler-containing ring and VM objects

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/hdmi_phy: fix runtime PM cleanup on probe failure

Saim Shujah <saimzst@gmail.com>
    drm/msm/dpu: clear pending peripheral flush state

Guangshuo Li <lgs201920130244@gmail.com>
    drm/msm/adreno: fix autosuspend cleanup during teardown

Sophie D <patches@scd31.com>
    drm/gud: Ignore damage clips in full update mode

Sajal Gupta <sajal2005gupta@gmail.com>
    drm/gud: fix out-of-bounds write in gud_plane_atomic_check()

Devin Wittmayer <lucid_duck@justthetip.ca>
    wifi: mac80211: refuse to make a monitor active when it has no queue

Ivan Pustogarov <ivan@ipust.net>
    wifi: mac80211: avoid out-of-bounds read for empty PREQ elements

Rik van Riel <riel@surriel.com>
    wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver

Zhao Li <enderaoelyther@gmail.com>
    wifi: mwifiex: validate action frame fixed fields

Linmao Li <lilinmao@kylinos.cn>
    wifi: mwifiex: prevent authentication frame length truncation

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

Fan Wu <fanwu01@zju.edu.cn>
    wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Tianchu Chen <flynnnchen@tencent.com>
    wifi: rsi: fix heap OOB write on key removal

Daehyeon Ko <4ncienth@gmail.com>
    wifi: libipw: reject TKIP frames without a full MIC

Jiangshan Yi <yijiangshan@kylinos.cn>
    wifi: libertas_tf: fix UAF in lbtf_free_adapter()

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: iwlegacy: fix broadcast stations deallocation

Jiangshan Yi <yijiangshan@kylinos.cn>
    wifi: brcmsmac: fix UAF in brcms_free_timer()

Wentao Liang <vulab@iscas.ac.cn>
    watchdog: starfive-wdt: Fix runtime PM leak in starfive_wdt_pm_start()

Wentao Liang <vulab@iscas.ac.cn>
    watchdog: sp5100_tco: Fix pci_dev reference leak in sp5100_tco_init()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: rzv2h: Avoid division by zero

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: rtd119x: Avoid division by zero

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Propagate error code in resume()

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: msc313e: Fix premature reset during timeout update

Tzung-Bi Shih <tzungbi@kernel.org>
    watchdog: digicolor: Avoid division by zero

Li Jun <lijun01@kylinos.cn>
    watchdog: da9063: fix suspend/resume handling of HW_RUNNING watchdog

Thomas Richard (congatec GmbH) <thomas.richard@bootlin.com>
    hwmon: (cgbc-hwmon) Add missing sensors

Thomas Richard (congatec GmbH) <thomas.richard@bootlin.com>
    hwmon: (cgbc-hwmon) Fix current sensors ID lookup

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83793) release probe data through kref

Guangshuo Li <lgs201920130244@gmail.com>
    hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove

Yibo Tan <lhfff@tju.edu.cn>
    hwmon: (pwm-fan) Stop RPM timer before freeing tach data

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/tps53679) Select page 0 for single-page TPS53676

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pmbus/tps53679) Fix TPS53676 phase page decoding

Nuno Sá <nuno.sa@analog.com>
    hwmon: (pmbus/core) increase number of phases and add new mask

Muhammad Bilal <meatuni001@gmail.com>
    hwmon: (hp-wmi-sensors) Fix use-after-free in fungible_show()

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

Runyu Xiao <runyu.xiao@seu.edu.cn>
    Input: hp_sdc - shut down kicker timer on module exit

Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
    Input: evdev - zero absinfo before partial copy in EVIOCSABS

Linkai Gong <gonglinkai@kylinos.cn>
    Input: cyttsp5 - clamp the HID report size before memcpy

Alexei Turtanov <9alexei9@gmail.com>
    Input: atkbd - skip deactivate for Xiaomi Redmi Book Pro 16 2026

Alvin Šipraga <alvin.sipraga@analog.com>
    Input: adp5588-keys - cache GPIO state before registering the gpiochip

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Fallback to DT-provided itap delay on DDR50 tuning failure

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Clear ITAPDLY on tuning failure

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Reset command and data lines on failed tuning

Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
    mmc: sdhci_am654: Move tuning_loop to local variable

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

Fan Wu <fanwu01@zju.edu.cn>
    mmc: mmci: Fix use-after-free in busy-timeout work

Fan Wu <fanwu01@zju.edu.cn>
    mmc: hsq: Fix use-after-free in retry work

Zhu Ling <zhuling0805@qq.com>
    mmc: core: Fix OF node reference leak on card add failure

Fan Wu <fanwu01@zju.edu.cn>
    mmc: core: Cancel SDIO IRQ work before freeing host

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: fix NULL-pointer dereference in pwrseq_device_register()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: fix NULL-pointer dereference in pwrseq_unit_new()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    power: sequencing: don't call .post_enable() if pwrseq_unit_enable() failed

Christian Göttsche <cgzones@googlemail.com>
    selinux: always fill AVC decision in avc_has_perm_noaudit()

Karl Mehltretter <kmehltretter@gmail.com>
    selinux: recheck intermediate backing files on mprotect()

Karl Mehltretter <kmehltretter@gmail.com>
    selinux: preserve user SID across nested backing files

Shuhei Takeshita <jyohuku.alterego@gmail.com>
    IB/hfi1: Fix the PIO_CRED credit-return mmap

Shuhei Takeshita <jyohuku.alterego@gmail.com>
    IB/hfi1: Resolve the credit-return buffer through the send context's node

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    IB/mlx4: Fix use-after-free on pkey sysfs registration failure

Guangshuo Li <lgs201920130244@gmail.com>
    i2c: imx: disable autosuspend on remove

Shengzhuo Wei <me@cherr.cc>
    i2c: imx: release DMA channels on probe error

Liu Zhenlong <dragonliu2018@gmail.com>
    i2c: qcom-cci: fix device_node refcount leak in cci_probe()/cci_remove()

Linkai Gong <gonglinkai@kylinos.cn>
    i2c: atr: fix dangling adapter pointer on add failure

Shengzhuo Wei <me@cherr.cc>
    i2c: at91: release DMA channels on remove and probe error

fangqiurong <fangqiurong@kylinos.cn>
    sched_ext: Close the pre-enable ops error claim window

Wanwu Li <liwanwu@kylinos.cn>
    sched_ext: Fix NULL sched deref in kfunc sub-sched error paths

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix tpm2_load_cmd() boundary check

Maoyi Xie <maoyixie.tju@gmail.com>
    keys: translate request_key_auth pid for the reading procfs instance

Cen Zhang <cenzhang@linux.microsoft.com>
    KEYS: encrypted: fix integer overflow of datablob_len

Wenjie Qi <qiwenjie@xiaomi.com>
    mm: filemap: retain mapped dropbehind folios

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vma: correctly unaccount on mmap_prepare() failure

Jiayuan Chen <jiayuan.chen@linux.dev>
    mm/shrinker: fix bogus set_shrinker_bit() with cgroup.memory=nokmem

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/mremap: account mm->locked_vm correctly for MREMAP_DONTUNMAP

Shakeel Butt <shakeel.butt@linux.dev>
    mm/mlock: use the IRQ-safe accessor for NR_MLOCK in __munlock_folio()

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: bypass THP tuneables for huge pfnmap mappings

Nhat Pham <nphamcs@gmail.com>
    mm, swap: fix SWAP_USAGE_OFFLIST_BIT collision with real usage count

Yifei Gao <gyf161023@gmail.com>
    memstick: ms_block: destroy io_queue workqueue on removal

Shakeel Butt <shakeel.butt@linux.dev>
    memcg: avoid charging the root memcg from obj_cgroup_charge_pages()

Théo Lebrun <theo.lebrun@bootlin.com>
    mips: select CONFIG_WEAK_REORDERING_BEYOND_LLSC from CONFIG_EYEQ

Alexey Klimov <alexey.klimov@linaro.org>
    soc: samsung: exynos-pmu: fix use-after-free of interrupt generator node

Zhiling Zou <zhilinz@nebusec.ai>
    xfrm: save input state data before secpath resets

Siwei Zhang <fourdizhang@tencent.com>
    xfrm: use hlist_del_init_rcu for state_cache and state_cache_input

Chengfeng Ye <nicoyip.dev@gmail.com>
    xfrm: serialize state GC with device state flush

Alberto Carboneri <acarboneri@drivesec.com>
    scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: avoid truncating TPACKET_V3 private size

Mark Amirkan <markdamirkan@gmail.com>
    net/packet: clear RX owner on VNET header error

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: hhf: cap hh_flows_limit at change time

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net/sched: act_api: release tail references on DELACTION failure

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: mhi_wwan_mbim: check skb_copy_bits() return value

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: mhi_wwan_mbim: guard against a cyclic NDP chain

Guanglei Zhu <zhugl3@xiaopeng.com>
    net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()

Ahmed Naseef <naseefkm@gmail.com>
    net: phy: mediatek: do not report link and per-speed LED rules together

Mark Amirkan <markdamirkan@gmail.com>
    net: lan743x: fix RX checksum use-after-free

Gris Ge <cnfourt@gmail.com>
    net: ip_tunnel: initialize `options_len` before referencing options

Zhiling Zou <zhilinz@nebusec.ai>
    ipv6: xfrm: use full sockets in local error paths

David Hu <xuehaohu@google.com>
    dma-buf: Split sgl by largest page-aligned chunk

David Hu <xuehaohu@google.com>
    dma-buf: Fix silent overflow for phys vec to sgt

Christian König <christian.koenig@amd.com>
    dma-buf/dma-fence: fix checking signaling bit for timeline and driver name v3

Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
    dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix undefined behaviour in sun6i_dma_tx_status

Christian Lugnberg <christian.lugnberg@soundtrack.io>
    dmaengine: sun6i: fix non-atomic read of DMA position registers

Abdurrahman Hussain <abdurrahman@nexthop.ai>
    gpiolib: of: don't mark hog nodes OF_POPULATED before a chip is found

Michail Tatas <michail.tatas@gmail.com>
    gpiolib: Put fwnode reference on failure

Guanghui Yang <3497809730@qq.com>
    btrfs: clear free space tree creation state on rebuild failure

Anand Jain <asj@kernel.org>
    btrfs: derive f_fsid with dev_t only when temp_fsid is active

Filipe Manana <fdmanana@suse.com>
    btrfs: fix creation of compressed inline extents that don't save space

Hongling Zeng <zenghongling@kylinos.cn>
    btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: keep dst_type with dst when reusing an LE connection

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Serialize local codec list cleanup

Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
    Bluetooth: hci_codec: validate vendor codec count length

Aamir Ahmed <elb12345@hotmail.co.uk>
    Bluetooth: eir: validate service data length before reading UUID

Nicolas Thibert <nithibert@gmail.com>
    Bluetooth: btusb: fix NXP IW610 composite device handling

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix LSE operations on {8,16}-bit types

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_and() mask generation

Mark Rutland <mark.rutland@arm.com>
    arm64: percpu: Fix this_cpu_write() casting

Dinh Nguyen <dinguyen@kernel.org>
    arm64: dts: socfpga: change access permission from 755 to 644

Koichiro Den <den@valinux.co.jp>
    arm64: dts: renesas: r8a779f0: Set UFS lane count

Bradley Morgan <include@grrlz.net>
    arm64: hibernate: pass HVC_SET_VECTORS args to the resume hvc

Thomas Huth <thuth@redhat.com>
    kselftest/arm64: Fix size of thread_data values for pthread_join()

Wyatt Feng <wf.kernel.dev@gmail.com>
    net: xfrm: reject unrepresentable espintcp transport headers

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of NFSEXP_PNFS in the netlink codepath

Zhiling Zou <zhilinz@nebusec.ai>
    openvswitch: avoid reallocating confirmed conntrack labels

Jeffin Philip <jeffinphilip14@gmail.com>
    RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()

Quanye Yang <quanyeyang@proton.me>
    RDMA/ucma: Serialize join and leave on copy_to_user failure

Hao-Qun Huang <alvinhuang0603@gmail.com>
    spi: virtio: Use the per-transfer bits per word

Itai Handler <itai.handler@gmail.com>
    spi: spi-zynqmp-gqspi: stop the controller on shutdown

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: fsl-qspi: Reprogram the clock rate when the operation frequency changes

Ian Luites <ian@luites.com>
    soundwire: dmi-quirks: Disable ghost Realtek on Asus GX651AX

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    swiotlb: use the adjusted address for the highmem page lookup

Inbal Schussheim <inbal.lipshtat@mail.huji.ac.il>
    tcp: exclude old ACKs from tcp fast path

Chang S. Bae <chang.seok.bae@intel.com>
    x86/microcode/intel: Reject problematic loading on Granite Rapids systems

Chang S. Bae <chang.seok.bae@intel.com>
    x86/build/64: Prevent native builds from generating EGPR use

Lyude Paul <lyude@redhat.com>
    drm/nouveau/gsp/r570: Enable S/R Display workaround in GSP

Lyude Paul <lyude@redhat.com>
    drm/nouveau/gsp/r570: Set GcOff = 0 in fbsr

Lyude Paul <lyude@redhat.com>
    drm/nouveau/gsp: Increase delay for magic sleep in r535_gsp_fini()

Lyude Paul <lyude@redhat.com>
    Revert "nouveau/gsp: fix suspend/resume regression on r570 firmware"

Chunfeng Song <springbreeze@stu.pku.edu.cn>
    rust: net: phy: fix off-by-one bit positions in device status accessors

Thomas Gleixner <tglx@kernel.org>
    signal: Prevent exec() race

Aohan Mei <henrymei@tencent.com>
    rds: ib: use rds_conn_drop() on protocol version mismatch

Thomas Gleixner <tglx@kernel.org>
    posix-cpu-timers: Prevent freeing a timer which is queued on the expiry list

Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
    phy: renesas: rcar-gen3-usb2: Avoid long delay in atomic context

Richard Zhu <hongxing.zhu@nxp.com>
    PCI: imx6: Move clock enable after core reset assertion

Seunguk Shin <seunguk.shin@arm.com>
    fs/dax: check zero or empty entry before converting xarray entry

Hyunwoo Kim <imv4bel@gmail.com>
    exec: Cleanup POSIX timers right after de_thread()

Wentao Liang <vulab@iscas.ac.cn>
    cifs: Fix server use-after-free in cifs_chan_skip_or_disable()

Wentao Liang <vulab@iscas.ac.cn>
    ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()

Niklas Cassel <cassel@kernel.org>
    ata: libahci: clear PxCLBU and PxFBU for AHCI_HFLAG_32BIT_ONLY

Michal Koutný <mkoutny@suse.com>
    cgroup: Avoid iteration of dying tasks with zero refcount

Jiangshan Yi <yijiangshan@kylinos.cn>
    ASoC: codecs: rt712-sdca-dmic: fix uninitialized stream_config->type

Yuho Choi <oss.patchbox@gmail.com>
    ALSA: virtio: reset device before deleting virtqueues

Xiang Mei <xmei5@asu.edu>
    ALSA: usb-audio: Clamp implicit feedback packet count to URB capacity

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix potential UAF after asynchronous card release

David Howells <dhowells@redhat.com>
    9p: Fix v9fs_issue_write() to update i_size and remote_i_size

Jeremy Nyberg <slickstretch3.0@gmail.com>
    Input: xpad - fix PDP Marvel Xbox 360 controller

Roberts Kursitis <roberts.kursitis@azeron.eu>
    Input: xpad - add support for Azeron devices

Erich Sartison <byt.es@mailbox.org>
    Input: xpad - add support for Victrix Pro BFG Controller

Li Jun <lijun01@kylinos.cn>
    watchdog: da9062: fix suspend/resume handling of HW_RUNNING watchdog

James Seo <james@equiv.tech>
    hwmon: (hp-wmi-sensors) Improve raw WMI string handling

Cong Nguyen <congnt264@gmail.com>
    hwmon: (gpio-fan) return IRQ_HANDLED from the shared alarm IRQ handler

hpp.iscas <hppiscas@163.com>
    Input: eeti_ts - publish the OF module alias

Matthew Schwartz <matthew.schwartz@linux.dev>
    x86/fred: Reconstruct the #GP context for rejected INT instructions

Andrea Righi <arighi@nvidia.com>
    sched/core: Avoid false migration warning for proxy donors

Vinay Belgaumkar <vinay.belgaumkar@intel.com>
    perf: Fix null pointer access in is_include_guest_event()

Filipe Manana <fdmanana@suse.com>
    btrfs: check if there is space for chunk item when validating sys chunk array

Filipe Manana <fdmanana@suse.com>
    btrfs: abort transaction on failure to update inode for hole punching and reflinking

Francis Marlou Pacaro <pacaro.francis.marlou.n@gmail.com>
    drm/amd/display: fix MALL hysteresis timer underflow at high refresh rates

Dmitriy Chumachenko <Dmitry.Chumachenko@cyberprotect.ru>
    drm/amdgpu: check ras and obj before dereference

Eric Dumazet <edumazet@google.com>
    net: skbuff: do not leave stale header offsets after pskb_carve()

Dmitriy Okunev <dokunevdmitriy@gmail.com>
    net: mvpp2: prevent buffer overflow in page_pool allocation

James Clark <jjc@jclark.com>
    net: macb: fix ordering around PTP timestamp read

Jinke Han <jinkehan@didiglobal.com>
    x86/kprobes: Fix crash when probing CS CALL instructions

Daniel Zahka <daniel.zahka@gmail.com>
    net: psp: avoid conflicts with skb->decrypted and sk_validate_xmit_skb()

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: preserve real_num_tx_queues on mqprio setup failure

Eric Dumazet <edumazet@google.com>
    net: prevent torn reads in netdev_tc_txq

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: propagate FPE preemption-class mapping errors

Linus Walleij <linusw@kernel.org>
    net: ethernet: cortina: Ack RX overrun interrupt correctly

Eric Dumazet <edumazet@google.com>
    net: lock the socket in sock_gettstamp()

Jakub Kicinski <kuba@kernel.org>
    eth: fbnic: ring the doorbell if a burst ends in a drop

Yige Jiang <yigejiang86@gmail.com>
    net: netsec: fix device_node reference leak on phy_np

Farhad Alemi <farhad.alemi@berkeley.edu>
    net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: pass net_device_path_ctx to dev_fill_forward_path()

Pablo Neira Ayuso <pablo@netfilter.org>
    net: pass dst via net_device_path in dev_fill_forward_path()

Pablo Neira Ayuso <pablo@netfilter.org>
    net: do not advance stack index from dev_fwd_path()

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: codel: bound the dropping loop per dequeue call

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: fix ffs() operator precedence for SoundWire link ID

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: refactor codec config count in SOF SoundWire machine driver

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: sdw_utils: tidyup asoc_sdw_parse_sdw_endpoints()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: sdw_utils: tidyup .count_sidecar

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: bounds-check SoundWire link ID in machine drivers

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs-amp-lib: Prevent NULL pointer if efi variable is zero length

HyeongJun An <sammiee5311@gmail.com>
    ASoC: hdmi-codec: Report a change when the channel status moves

Sasha Levin <sashal@kernel.org>
    ASoC: ux500: Parenthesize MSP_{RX,TX}_CLKPOL_BIT() arguments

Daniel Linjama <daniel@dev.linjama.com>
    btrfs: handle lack of space when cleaning up verity items

Raag Jadav <raag.jadav@intel.com>
    drm/xe/i2c: Disable IRQ on unbind

Peter Zijlstra <peterz@infradead.org>
    futex: Also allocate private hash on vfork()

Nemesa Garg <nemesa.garg@intel.com>
    Revert "drm/i915/display: Clear SEL_FETCH_PLANE_CTL on plane disable"

Shivaprasad G Bhat <sbhat@linux.ibm.com>
    powerpc/iommu: Fix the overflow validation in iommu_tce_check_ioba

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix secure device page leak on uv_page_in() failure

Amit Machhiwal <amachhiw@linux.ibm.com>
    KVM: PPC: Book3S HV: fix use-after-free in kvmhv_emulate_tlbie_all_lpid()

Eric Dumazet <edumazet@google.com>
    netlink: do not free nlk->groups while lockless readers can use it

Nikolay Aleksandrov <razor@blackwall.org>
    net: bridge: vlan: fix bugs caused by switchdev deletion errors

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: do not overwrite phc_index when no PTP clock is registered

Eric Dumazet <edumazet@google.com>
    drop_monitor: fix out-of-bounds write in reset_per_cpu_data()

Eric Dumazet <edumazet@google.com>
    drop_monitor: use raw_cpu_ptr() in tracepoint probes

Eric Dumazet <edumazet@google.com>
    drop_monitor: use timer_shutdown_sync() to prevent timer rearming during teardown

Eric Dumazet <edumazet@google.com>
    drop_monitor: synchronize tracepoint unregistration on error path

Eric Dumazet <edumazet@google.com>
    pppoatm: ensure a writable skb header and linear data

Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
    net: stmmac: fix TSO header length truncation

Kuniyuki Iwashima <kuniyu@google.com>
    af_unix: Unify scc_index when finalising SCC in __unix_walk_scc().

Juan Perdomo <jcperdomo100@gmail.com>
    Bluetooth: RFCOMM: avoid socket lock inversion in listener cleanup

Sai Teja Aluvala <aluvala.sai.teja@intel.com>
    Bluetooth: btintel_pcie: fix off-by-one bounds check in RX submit

Tzung-Bi Shih <tzungbi@kernel.org>
    Bluetooth: btmtksdio: Fix PM runtime reference leak in shutdown

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtksdio, btmtkuart: validate WMT event length before struct access

Chris Lu <chris.lu@mediatek.com>
    Bluetooth: btmtk: fix wrong status for short WMT FUNC_CTRL events

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: set BT_LISTEN before requesting a BIG sync

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: ISO: Fix parent socket leak in iso_conn_ready()

Ibrahim Abdelkader <iabdelka@qti.qualcomm.com>
    Bluetooth: hci_qca: Do not write to the serial port after it is closed

Radek Podgorny <radek@podgorny.cz>
    Bluetooth: put the peer's on-air address on air when we cannot resolve

Weiming Shi <bestswngs@gmail.com>
    Bluetooth: coredump: Quiesce dump work on unregister

Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
    Bluetooth: btintel_pcie: validate TX skb length in send_sync

ThangNN99 <ngocthang2710.1999@gmail.com>
    Bluetooth: hci_core: Fix queuing tx_work after workqueue is drained

Baineng Shou <shoubaineng@gmail.com>
    dmaengine: mmp_pdma: fix wrong sg length in mmp_pdma_prep_slave_sg()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: keep compound responses on query info errors

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix partial file information responses

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: return buffer overflow for partial filesystem info

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

Kuniyuki Iwashima <kuniyu@google.com>
    sysctl: Check range in proc_dointvec_ms_jiffies_minmax

Nicolai Buchwitz <nb@tipi-net.de>
    net: bcmgenet: restore the hardware filters on open

Daniel Golle <daniel@makrotopia.org>
    net: dsa: mxl862xx: disable the stats poll on teardown

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: set IPSKB_L3SLAVE from IP6SKB_L3SLAVE on IPIP decapsulation

Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
    drm/msm/dsi: round the byte clock rate after reparenting to the PHY PLL

Filipe Manana <fdmanana@suse.com>
    btrfs: tree-checker: print dev extent offset in error message

Nicolas Escande <nico.escande@gmail.com>
    wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()

Slavin Liu <bolin.liu@seu.edu.cn>
    ALSA: hda: trace PCM open only after assigning a stream

Karl Mehltretter <kmehltretter@gmail.com>
    drm/vc4: Use managed KMS polling to fix UAF on unbind

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/shrinker: Take a runtime PM ref before shrinking non-system memory

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/shrinker: Return the freed page count through a parameter

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/mmio_gem: Revoke drm_vma_node on xe_mmio_gem destroy

Ilia Levi <ilia.levi@intel.com>
    drm/xe/mmio_gem: use write-back mapping for dummy page

Ilia Levi <ilia.levi@intel.com>
    drm/xe/mmio_gem: forbid VMA split

Zihan Xi <zihanx@nebusec.ai>
    wifi: virt_wifi: don't transfer operstate before register

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: follow SMB2 session expiration semantics

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: extend procfs server statistics

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix malformed procfs status output

Xiang Mei <xmei5@asu.edu>
    ALSA: 6fire: fix OOB write from device-reported iso length

Takashi Iwai <tiwai@suse.de>
    ALSA: usb: 6fire: Avoid embedded URBs

Runyu Xiao <runyu.xiao@seu.edu.cn>
    gpio: virtuser: skip free_irq when no IRQ is installed

Ulises Mendez Martinez <umendez@google.com>
    objtool: Validate disassembler headers in libopcodes probe

Karl Mehltretter <kmehltretter@gmail.com>
    Input: trackpoint - fix the inertia attribute name in the ABI document

Gabor Juhos <j4g8y7@gmail.com>
    spi: spi-qpic-snand: avoid writing QPIC_EBI2_ECC_BUF_CFG register

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Add codec_ch_mask to snd_soc_dai_link_ch_map

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: Rename snd_soc_dai_link_ch_map.ch_mask to cpu_ch_mask

William Bright <william.bright@imd-tec.com>
    drm/msm/dp: fix link bandwidth check when wide bus is enabled

Jesse Casco <jesse.casco@gmail.com>
    drm/msm/dp: skip PUSH_IDLE when the link was never enabled

Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
    ALSA: pcm: set timer->private_data before registering the PCM timer

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    phy: mediatek: phy-mtk-hdmi-mt8195: Fix TMDS clk bit ratio setting

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    phy: mediatek: phy-mtk-hdmi-mt8195: Fix PLL calc divisor overflow

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: ignore interrupted inode reads as corruption

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: propagate folio errors

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: protect runlist updates with the runlist lock

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: account for MFT records added during allocation

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: repack $MFT/$ATTRIBUTE LIST

Namjae Jeon <linkinjeon@kernel.org>
    ntfs: use dynamic MFT tail reservation

Takashi Iwai <tiwai@suse.de>
    ALSA: bcd2000: Fix race between rawmidi and disconnect

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Skip default parms when resumed in neightbl_dump_info().

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Don't render blackhole_netdev via RTM_GETNEIGHTBL.

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Enforce min/max to NDTPA_INTERVAL_PROBE_TIME_MS.

Kuniyuki Iwashima <kuniyu@google.com>
    neighbour: Add missing RCU annotation for neightbl_dump_info().

Karl Mehltretter <kmehltretter@gmail.com>
    keys: fix lost wakeup when reaping a dead key type

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    smb: client: validate absolute native symlink targets before NT fixups

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    drm: Fix drm_pending_vblank_event leak in error path for out_fence_ptr

Catalin Marinas <catalin.marinas@arm.com>
    arm64: mte: Fix PTRACE_{PEEK,POKE}MTETAGS error documentation

Breno Leitao <leitao@debian.org>
    arm64: hibernate: clone only the linear map that exists at runtime

Shouping Wang <allen.wang@hj-micro.com>
    perf/arm-cmn: Fix wp_dev_sel2 setting for multi-DTM configurations

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: flowtable: hold reference on ct until flow is released

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_nat: unregister and release hooks on error

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nf_tables: fix device name and prefix match in hook lookup

Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
    netfilter: nft_nat: fully initialise new_addr in netmap setup

Karl Mehltretter <kmehltretter@gmail.com>
    dma-buf: Make DMABUF_DEBUG default to y on DEBUG_KERNEL kernels

Karl Mehltretter <kmehltretter@gmail.com>
    drm/msm/adreno: Fix the skip_gpu parameter description

Karl Mehltretter <kmehltretter@gmail.com>
    drm/msm: Fix the separate_gpu_kms parameter description

David Laight <david.laight.linux@gmail.com>
    x86/div64: Fix addition of large constants in mul_u64_add_u64_div_u64()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    RDMA/siw: Bound fragmented header copies by the remaining length

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Keep EQ resources alive while IRQ is registered

Leon Romanovsky <leon@kernel.org>
    RDMA/efa: Keep admin queues alive while IRQ is registered

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA

Sascha Hauer <s.hauer@pengutronix.de>
    dmaengine: pxa: fix double counting of the hw descriptors

Alex Bereza <alex@bereza.email>
    dmaengine: xilinx_dma: Fix hardware buffer descriptor reuse order

Karl Mehltretter <kmehltretter@gmail.com>
    scsi: qla2xxx: Fix the ql2xfc2target parameter description

Karl Mehltretter <kmehltretter@gmail.com>
    scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn parameter descriptions

Meijing Zhao <zhaomeijing@lixiang.com>
    mm: memblock: show all region flags in debugfs

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: set up the TX info early to fix failure paths

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: release the channel if start fails

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: mesh: reset the CSA state when leaving

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

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't allow injecting frames wider than the chanctx

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: get the wiphy out of a dying network namespace

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: unlist vifs when their netdev is unregistered

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: undo netns switch if renaming the wiphy fails

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: restore netns_immutable on failures

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: only operate on TDLS peers in the TDLS code

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset the LED state when ifup fails

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: reset state when starting AP fails

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: abort chanswitch when leaving a mesh

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: suppress chanctx warning for debugfs reset

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't offload TC setup on AP_VLAN interfaces

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't warn when an IBSS has no channel to scan

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: don't start a ROC while scanning

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix NAN regulatory enforcement

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: ibss: ref BSS entry for joined event

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't filter by BSS type when removing stale entries

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: only group hidden BSSes with beacon entries

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't free driver-owned scan requests

Shivank Garg <shivankg@amd.com>
    dmaengine: wait for RCU readers before releasing dma_device

Shivank Garg <shivankg@amd.com>
    dmaengine: fix use-after-free in dma_chan_put() and dma_release_channel()

Shivank Garg <shivankg@amd.com>
    dmaengine: Fix device kref underflow in dma_chan_put()

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    dma-mapping: don't trace the DMA address when the allocation fails

Donggeun Yoo <donggeunyoo.kernel@gmail.com>
    dma-coherent: report a failed reserved memory assignment

Orgad Shaneh <orgads@gmail.com>
    MIPS: Octeon: apply USB FDT fixups also when USB is modular

Julian Braha <julianbraha@gmail.com>
    mips: econet: fix unmet dependencies for ECONET

Bard Liao <yung-chuan.liao@linux.intel.com>
    soundwire: cadence_master: wait and cancel cdns->work before clock stop

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: check IP header size in cfg80211_classify8021d()

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: don't get the radio mask for netdev-less wdevs

Carolina Jubran <cjubran@nvidia.com>
    IB/IPoIB: Avoid restoring OPER_UP after multicast flush

Shmulik Cohen <anuk909@gmail.com>
    wifi: libipw: reject too-short association responses

Shmulik Cohen <anuk909@gmail.com>
    wifi: libipw: reject too-short beacon and probe responses

Bogdan Nicolae <bogdan.nicolae@gmail.com>
    wifi: brcmfmac: cyw: pass PMKID to firmware if present

Peng Hao <flyingpenghao@gmail.com>
    wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path

Mariano Baragiola <mbaragiola@linux.com>
    wifi: virt_wifi: free skb when disconnected

Lachlan Hodges <lachlan.hodges@morsemicro.com>
    wifi: mac80211: include TIM bitmap control for buffered S1G mcast traffic

Ruoyu Wang <ruoyuw560@gmail.com>
    dmaengine: sprd: Fix runtime PM reference leak in probe

Troy Mitchell <troy.mitchell@linux.spacemit.com>
    dmaengine: mmp_pdma: fix wrong extended DRCMR base for SpacemiT K3

Quanye Yang <quanyeyang@proton.me>
    RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted

Jacob Moroni <jmoroni@google.com>
    RDMA/irdma: Enforce local fence for IB_WR_REG_MR

Cheng Xu <chengyou@linux.alibaba.com>
    RDMA/erdma: Use IRQ-safe XArray helpers for QP and CQ tables

Li RongQing <lirongqing@baidu.com>
    RDMA/mad: Fix receive buffer leak when PKey enforcement fails

Li RongQing <lirongqing@baidu.com>
    RDMA/uverbs: Fix potential leak of resources->collection in flow_resources_alloc()

Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
    RDMA/bnxt_re: Avoid exposing umdbr to userspace

Ryan Mehri <ryan.mehri1@gmail.com>
    RDMA/rtrs: guard against null kobj name

Linkai Gong <gonglinkai@kylinos.cn>
    RDMA/bnxt_re: check create_singlethread_workqueue() in DCB setup

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/isert: wait for deferred control PDU completions before releasing the connection

Yehyeong Lee <yhlee@isslab.korea.ac.kr>
    IB/iser: reject a remote invalidation of an unregistered direction

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g087: Switch GBETH TX queue scheduling to WRR

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g077: Switch GBETH TX queue scheduling to WRR

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g047: Switch GBETH TX queue scheduling to WRR

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g056: Switch GBETH TX queue scheduling to WRR

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    arm64: dts: renesas: r9a09g057: Switch GBETH TX queue scheduling to WRR

Biju Das <biju.das.jz@bp.renesas.com>
    power: sequencing: Fix build issue with COMPILE_TEST

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/uverbs: Fix mmap_lock/disassociation_lock circular dependency

Krystian Kaniewski <krystianmkaniewski@gmail.com>
    RDMA/core: Reject unregistering netdevs in ib_get_eth_speed

Or Har-Toov <ohartoov@nvidia.com>
    RDMA/mlx5: Remove warn on missing representor in query_port_speed

Michael Bommarito <michael.bommarito@gmail.com>
    RDMA/rxe: insert mcg into mcg_tree only after rxe_mcast_add() succeeds

Weiming Shi <bestswngs@gmail.com>
    RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths

Xixin Liu <liuxixin@kylinos.cn>
    clk: scpi: register scpi-cpufreq once and clear on failure

Xixin Liu <liuxixin@kylinos.cn>
    clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate

Xixin Liu <liuxixin@kylinos.cn>
    firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS

Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
    xfrm: hold net_device reference under RCU in bundle creation

Gang Yan <yangang@kylinos.cn>
    RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access

Norbert Szetei <norbert@doyensec.com>
    RDMA/rxe: validate access flags before swapping the MR's PD

Guoqing Jiang <guoqing.jiang@linux.dev>
    RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept

Pengpeng Hou <pengpeng@iscas.ac.cn>
    ARM: socfpga: select the PL310 erratum 753970 workaround

Lucas Tanure <tanure@linux.com>
    arm64: dts: amlogic: t7: fix the pin groups of the vsync PWM

Lucas Tanure <tanure@linux.com>
    arm64: dts: amlogic: t7: khadas-vim4: add the PWM-driven supplies

Lucas Tanure <tanure@linux.com>
    arm64: dts: amlogic: t7: fix the pin groups of two PWM outputs

Lucas Tanure <tanure@linux.com>
    arm64: dts: amlogic: t7: khadas-vim4: allow the SD card to be power cycled

Lucas Tanure <tanure@linux.com>
    arm64: dts: amlogic: t7: use the real UART pclk

Maher Azzouzi <maherazz04@gmail.com>
    esp: downgrade zerocopy managed frags before mutating skb frags

Eric Dumazet <edumazet@google.com>
    xfrm: add missing rcu_read_lock(), skb_dst_force() and dev_hold() for xfrm_trans_reinject()

Kyle Zeng <kylebot@openai.com>
    xfrm: fix compat ALLOCSPI request use-after-free

Henry Martin <bsdhenrymartin@gmail.com>
    xfrm: iptfs: fix runt reassembly panic from short inner tot_len

Aleksandr Nogikh <nogikh@google.com>
    xfrm: add missing RCU read lock in xfrm_send_migrate_state()

Roshan Kumar <roshaen09@gmail.com>
    xfrm: iptfs: fix stack OOB read in iptfs_skb_reset_frag_walk()

Jens Axboe <axboe@kernel.dk>
    sunvdc: fix -EIO issue due to lack of retries

Günther Noack <gnoack@google.com>
    selftests/landlock: Add audit test for whiteout object creation

Günther Noack <gnoack@google.com>
    selftests/landlock: Add tests for whiteout object creation

Günther Noack <gnoack@google.com>
    selftests/landlock: Use an actual chardev for MAKE_CHAR audit test


-------------

Diffstat:

 .../ABI/testing/sysfs-devices-platform-trackpoint  |   2 +-
 .../arch/arm64/memory-tagging-extension.rst        |   5 +-
 Documentation/hwmon/cgbc-hwmon.rst                 |  42 +-
 Documentation/netlink/specs/rt-neigh.yaml          |   3 +
 Documentation/networking/ip-sysctl.rst             |   4 +-
 Makefile                                           |   4 +-
 arch/arm/mach-socfpga/Kconfig                      |   2 +-
 .../boot/dts/altera/socfpga_stratix10_socdk.dtsi   |   0
 .../dts/altera/socfpga_stratix10_socdk_emmc.dts    |   0
 .../boot/dts/amlogic/amlogic-t7-a311d2-an400.dts   |   2 +-
 .../dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts  | 113 +++-
 arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi        |  44 +-
 arch/arm64/boot/dts/renesas/r8a779f0.dtsi          |   1 +
 arch/arm64/boot/dts/renesas/r9a09g047.dtsi         |  10 +
 arch/arm64/boot/dts/renesas/r9a09g056.dtsi         |  10 +
 arch/arm64/boot/dts/renesas/r9a09g057.dtsi         |  10 +
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi         |  27 +
 arch/arm64/boot/dts/renesas/r9a09g087.dtsi         |  27 +
 arch/arm64/include/asm/percpu.h                    |  20 +-
 arch/arm64/kernel/hibernate-asm.S                  |   2 +
 arch/arm64/kernel/hibernate.c                      |   4 +-
 arch/arm64/kernel/mte.c                            |   2 +-
 arch/mips/Kconfig                                  |   4 +-
 arch/mips/cavium-octeon/octeon-platform.c          |   4 +-
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |   2 +
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   5 +-
 arch/x86/Kconfig.cpu                               |  11 +
 arch/x86/Makefile                                  |   5 +
 arch/x86/entry/entry_fred.c                        |  11 +-
 arch/x86/include/asm/div64.h                       |   2 +-
 arch/x86/include/asm/text-patching.h               |   4 +-
 arch/x86/kernel/alternative.c                      |   6 +-
 arch/x86/kernel/cpu/microcode/intel.c              |  26 +
 arch/x86/kernel/kprobes/core.c                     |   5 +-
 drivers/ata/libahci.c                              |  15 +-
 drivers/ata/libahci_platform.c                     |   2 +-
 drivers/block/sunvdc.c                             |   9 +-
 drivers/bluetooth/btintel_pcie.c                   |   8 +-
 drivers/bluetooth/btmtk.c                          |   7 +-
 drivers/bluetooth/btmtksdio.c                      |  24 +-
 drivers/bluetooth/btmtkuart.c                      |  20 +-
 drivers/bluetooth/btusb.c                          |  17 +
 drivers/bluetooth/hci_qca.c                        |  14 +-
 drivers/clk/clk-scpi.c                             |   8 +-
 drivers/dma-buf/Kconfig                            |   2 +-
 drivers/dma-buf/dma-buf-mapping.c                  |  31 +-
 drivers/dma-buf/dma-fence.c                        |  14 +-
 drivers/dma/dmaengine.c                            |  10 +-
 drivers/dma/mmp_pdma.c                             |   5 +-
 drivers/dma/pxa_dma.c                              |   3 +-
 drivers/dma/sprd-dma.c                             |   3 +-
 drivers/dma/sun6i-dma.c                            |   9 +-
 drivers/dma/ti/k3-udma-glue.c                      |   5 +-
 drivers/dma/xilinx/xilinx_dma.c                    |  26 +-
 drivers/firmware/arm_scpi.c                        |   4 +-
 drivers/gpio/gpio-virtuser.c                       |   3 +-
 drivers/gpio/gpiolib-of.c                          |   6 +-
 drivers/gpio/gpiolib-shared.c                      |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c         |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         | 145 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        |  43 +-
 drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c              |   7 +-
 drivers/gpu/drm/amd/amdgpu/nbio_v7_9.c             |   2 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   7 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c   |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c   |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12.c   |  61 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v12_1.c |  70 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c    |   6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c    |   5 +-
 .../drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c    |  13 +-
 drivers/gpu/drm/drm_atomic_uapi.c                  |  13 +-
 drivers/gpu/drm/gud/gud_pipe.c                     |   7 +-
 drivers/gpu/drm/i915/display/intel_cursor.c        |  15 +-
 drivers/gpu/drm/i915/display/skl_universal_plane.c |  15 +-
 drivers/gpu/drm/msm/adreno/adreno_device.c         |   2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c            |   2 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |   1 +
 drivers/gpu/drm/msm/dp/dp_display.c                |  21 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  36 +-
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c                |   8 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   2 +-
 drivers/gpu/drm/msm/msm_gem.h                      |   3 +
 drivers/gpu/drm/msm/msm_gem_vma.c                  |   2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.c               |   2 +-
 drivers/gpu/drm/msm/msm_ringbuffer.h               |   1 +
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/fbsr.c |   2 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/gsp.c  |   8 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/fbsr.c |   8 +-
 .../gpu/drm/nouveau/nvkm/subdev/gsp/rm/r570/gsp.c  |   3 +-
 .../drm/nouveau/nvkm/subdev/gsp/rm/r570/nvrm/gsp.h |   8 +
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/rm.h    |   2 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |   8 +-
 drivers/gpu/drm/scheduler/sched_rq.c               |  20 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   2 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |   2 +-
 drivers/gpu/drm/xe/xe_i2c.c                        |   3 +
 drivers/gpu/drm/xe/xe_mmio_gem.c                   |  33 +-
 drivers/gpu/drm/xe/xe_mmio_gem.h                   |   2 +-
 drivers/gpu/drm/xe/xe_shrinker.c                   | 124 ++--
 drivers/hwmon/cgbc-hwmon.c                         | 129 ++--
 drivers/hwmon/gpio-fan.c                           |   4 +-
 drivers/hwmon/hp-wmi-sensors.c                     |  32 +-
 drivers/hwmon/pmbus/pmbus.h                        |   3 +-
 drivers/hwmon/pmbus/tps53679.c                     |  11 +-
 drivers/hwmon/pwm-fan.c                            |  13 +-
 drivers/hwmon/w83791d.c                            |   1 +
 drivers/hwmon/w83793.c                             |   4 +-
 drivers/i2c/busses/i2c-at91-core.c                 |   3 +
 drivers/i2c/busses/i2c-at91-master.c               |  12 +-
 drivers/i2c/busses/i2c-at91.h                      |   1 +
 drivers/i2c/busses/i2c-imx.c                       |   3 +
 drivers/i2c/busses/i2c-qcom-cci.c                  |  20 +-
 drivers/i2c/i2c-atr.c                              |   1 +
 drivers/infiniband/core/iwpm_util.c                |   9 +-
 drivers/infiniband/core/mad.c                      |   3 +-
 drivers/infiniband/core/rdma_core.c                |   1 -
 drivers/infiniband/core/ucma.c                     |   7 +-
 drivers/infiniband/core/uverbs_flow.c              |   1 +
 drivers/infiniband/core/uverbs_main.c              |  25 +-
 drivers/infiniband/core/verbs.c                    |  12 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  10 +-
 drivers/infiniband/hw/bnxt_re/uapi.c               |   6 +-
 drivers/infiniband/hw/efa/efa_com.c                |   7 +-
 drivers/infiniband/hw/efa/efa_com.h                |   1 +
 drivers/infiniband/hw/efa/efa_main.c               |  35 +-
 drivers/infiniband/hw/erdma/erdma_main.c           |   4 +-
 drivers/infiniband/hw/erdma/erdma_verbs.c          |  18 +-
 drivers/infiniband/hw/hfi1/file_ops.c              |  23 +-
 drivers/infiniband/hw/irdma/verbs.c                |   2 +-
 drivers/infiniband/hw/mlx4/sysfs.c                 |   4 +
 drivers/infiniband/hw/mlx5/main.c                  |   7 +-
 drivers/infiniband/sw/rxe/rxe_mcast.c              |  50 +-
 drivers/infiniband/sw/rxe/rxe_mr.c                 |   3 +-
 drivers/infiniband/sw/rxe/rxe_odp.c                |  16 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c              |  13 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   7 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h               |   7 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  12 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |  16 +-
 drivers/infiniband/ulp/iser/iser_initiator.c       |  16 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  22 +
 drivers/infiniband/ulp/isert/ib_isert.h            |   2 +
 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h       |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   8 +
 drivers/infiniband/ulp/rtrs/rtrs-clt.h             |   2 +
 drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h       |   2 +-
 drivers/input/evdev.c                              |   2 +
 drivers/input/input-compat.c                       |   2 +
 drivers/input/joystick/xpad.c                      |  10 +-
 drivers/input/keyboard/adp5588-keys.c              |  12 +-
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/misc/soc_button_array.c              |  16 +-
 drivers/input/mouse/synaptics.c                    |   8 +
 drivers/input/rmi4/rmi_driver.c                    |  13 +
 drivers/input/rmi4/rmi_smbus.c                     |  10 +-
 drivers/input/serio/hp_sdc.c                       |   2 +-
 drivers/input/serio/i8042-acpipnpio.h              |   7 +
 drivers/input/touchscreen/cyttsp5.c                |   1 +
 drivers/input/touchscreen/eeti_ts.c                |   1 +
 drivers/memstick/core/ms_block.c                   |   2 +
 drivers/misc/ntsync.c                              |   3 +
 drivers/mmc/core/bus.c                             |   2 +-
 drivers/mmc/core/host.c                            |   1 +
 drivers/mmc/core/sdio_uart.c                       |   3 +
 drivers/mmc/host/mmc_hsq.c                         |   8 +-
 drivers/mmc/host/mmc_spi.c                         |   1 +
 drivers/mmc/host/mmci.c                            |   3 +
 drivers/mmc/host/mxcmmc.c                          |   4 +
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |   5 +
 drivers/mmc/host/sdhci-of-aspeed.c                 |   5 +-
 drivers/mmc/host/sdhci_am654.c                     |  43 +-
 drivers/mmc/host/sh_mmcif.c                        |   3 +-
 drivers/net/dsa/mxl862xx/mxl862xx.c                |  23 +-
 drivers/net/ethernet/airoha/airoha_ppe.c           |  17 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  19 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |   9 +
 drivers/net/ethernet/cortina/gemini.c              |   2 +-
 drivers/net/ethernet/intel/igc/igc_tsn.c           |   6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   7 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   3 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c       |  42 +-
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.h       |   9 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   2 +-
 drivers/net/ethernet/sfc/falcon/tx.c               |   8 +-
 drivers/net/ethernet/sfc/siena/tx.c                |   8 +-
 drivers/net/ethernet/socionext/netsec.c            |   2 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   2 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_fpe.c   |  14 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  99 ++-
 drivers/net/fddi/skfp/skfddi.c                     |   3 +-
 drivers/net/phy/mediatek/mtk-phy-lib.c             |  27 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  25 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |   5 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   4 +
 .../wireless/intel/ipw2x00/libipw_crypto_tkip.c    |  12 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   6 +
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 +-
 drivers/net/wireless/intersil/p54/eeprom.c         |  22 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  12 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  54 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |  10 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  14 +
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   9 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   2 -
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  39 +-
 drivers/net/wireless/virtual/virt_wifi.c           |   4 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |  28 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c                |   4 +
 drivers/pci/controller/dwc/pci-imx6.c              |  12 +-
 drivers/perf/arm-cmn.c                             |  10 +-
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.c         |   4 +-
 drivers/phy/mediatek/phy-mtk-hdmi-mt8195.h         |   3 +
 drivers/phy/renesas/phy-rcar-gen3-usb2.c           | 310 +++++++--
 drivers/power/sequencing/Kconfig                   |   3 +-
 drivers/power/sequencing/core.c                    |  11 +-
 drivers/scsi/fnic/fdls_disc.c                      | 726 +++++++++++----------
 drivers/scsi/fnic/fip.c                            | 117 ++--
 drivers/scsi/fnic/fip.h                            |   2 +-
 drivers/scsi/fnic/fnic.h                           |  68 +-
 drivers/scsi/fnic/fnic_fcs.c                       | 126 ++--
 drivers/scsi/fnic/fnic_isr.c                       |  41 +-
 drivers/scsi/fnic/fnic_main.c                      |  89 ++-
 drivers/scsi/fnic/fnic_scsi.c                      | 210 +++---
 drivers/scsi/pm8001/pm8001_init.c                  |   6 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   2 +-
 drivers/scsi/scsi.c                                |  24 +-
 drivers/soc/samsung/exynos-pmu.c                   |   7 +-
 drivers/soundwire/cadence_master.c                 |   7 +
 drivers/soundwire/dmi-quirks.c                     |   7 +
 drivers/spi/spi-fsl-qspi.c                         |   5 +-
 drivers/spi/spi-qpic-snand.c                       |   4 -
 drivers/spi/spi-virtio.c                           |   2 +-
 drivers/spi/spi-zynqmp-gqspi.c                     |  34 +
 drivers/watchdog/da9062_wdt.c                      |   4 +-
 drivers/watchdog/da9063_wdt.c                      |   4 +-
 drivers/watchdog/digicolor_wdt.c                   |  13 +-
 drivers/watchdog/msc313e_wdt.c                     |  16 +-
 drivers/watchdog/rtd119x_wdt.c                     |   7 +-
 drivers/watchdog/rzv2h_wdt.c                       |   7 +-
 drivers/watchdog/sp5100_tco.c                      |   6 +-
 drivers/watchdog/starfive-wdt.c                    |   2 +-
 fs/9p/vfs_addr.c                                   |  28 +-
 fs/btrfs/dev-replace.c                             |   1 +
 fs/btrfs/disk-io.c                                 |   4 +
 fs/btrfs/file.c                                    |   4 +-
 fs/btrfs/free-space-tree.c                         |  14 +-
 fs/btrfs/inode.c                                   |  18 +-
 fs/btrfs/super.c                                   |   8 +-
 fs/btrfs/tree-checker.c                            |   2 +-
 fs/btrfs/verity.c                                  |  18 +-
 fs/dax.c                                           |   9 +-
 fs/exec.c                                          |  29 +-
 fs/nfsd/export.c                                   |   3 +-
 fs/ntfs/attrib.c                                   | 259 ++++++--
 fs/ntfs/attrib.h                                   |   9 +
 fs/ntfs/attrlist.c                                 | 224 ++++++-
 fs/ntfs/attrlist.h                                 |   2 +
 fs/ntfs/compress.c                                 |   2 +-
 fs/ntfs/file.c                                     |   3 +-
 fs/ntfs/inode.c                                    |  35 +-
 fs/ntfs/mft.c                                      | 445 ++++++++++---
 fs/ntfs/mft.h                                      |   2 +-
 fs/ntfs/namei.c                                    |   2 +-
 fs/ntfs/super.c                                    |  12 +-
 fs/ntfs/volume.h                                   |  12 +-
 fs/smb/client/cifssmb.c                            |   2 +-
 fs/smb/client/connect.c                            |   9 +
 fs/smb/client/file.c                               |   4 +-
 fs/smb/client/misc.c                               |  12 +-
 fs/smb/client/reparse.c                            |  58 +-
 fs/smb/client/reparse.h                            |   7 +-
 fs/smb/client/sess.c                               | 104 +--
 fs/smb/client/smb2inode.c                          |  11 +
 fs/smb/client/smb2ops.c                            |  51 +-
 fs/smb/client/smb2pdu.c                            |  13 +-
 fs/smb/client/trace.h                              |   1 +
 fs/smb/server/connection.c                         |  84 ++-
 fs/smb/server/connection.h                         |   3 +
 fs/smb/server/mgmt/user_session.c                  | 199 ++++--
 fs/smb/server/mgmt/user_session.h                  |   8 +-
 fs/smb/server/misc.h                               |   7 +-
 fs/smb/server/proc.c                               | 159 ++++-
 fs/smb/server/server.c                             |   9 +-
 fs/smb/server/smb2pdu.c                            | 126 ++--
 fs/smb/server/smb2pdu.h                            |   3 +-
 fs/smb/server/smb_common.h                         |   2 +-
 fs/smb/server/stats.h                              |  58 +-
 fs/smb/server/vfs_cache.c                          |  26 +-
 fs/smb/server/vfs_cache.h                          |   1 +
 fs/super.c                                         |   1 +
 include/keys/request_key_auth-type.h               |   2 +-
 include/linux/dma-fence.h                          |   6 +
 include/linux/ieee80211-mesh.h                     |   4 +-
 include/linux/netdevice.h                          |  13 +-
 include/net/bluetooth/coredump.h                   |   2 +
 include/net/codel.h                                |   5 +
 include/net/codel_impl.h                           |  16 +-
 include/net/mac80211.h                             |   5 +-
 include/net/sock.h                                 |   2 +
 include/rdma/uverbs_types.h                        |   2 -
 include/sound/soc.h                                |   3 +-
 include/sound/soc_sdw_utils.h                      |  31 +-
 include/trace/events/dma.h                         |   2 +-
 include/uapi/rdma/bnxt_re-abi.h                    |   2 +-
 kernel/cgroup/cgroup.c                             |   7 +-
 kernel/dma/coherent.c                              |   3 +-
 kernel/dma/swiotlb.c                               |   4 +-
 kernel/events/core.c                               |   4 +
 kernel/exit.c                                      |  11 +-
 kernel/fork.c                                      |   4 +-
 kernel/sched/core.c                                |   9 +-
 kernel/sched/ext/ext.c                             |  27 +-
 kernel/sched/ext/idle.c                            |  11 +-
 kernel/signal.c                                    | 117 +++-
 kernel/time/jiffies.c                              |   2 +-
 kernel/time/posix-cpu-timers.c                     |  40 +-
 mm/filemap.c                                       |   2 +-
 mm/huge_memory.c                                   |  86 ++-
 mm/memblock.c                                      |  18 +-
 mm/memcontrol.c                                    |   2 +-
 mm/mlock.c                                         |   2 +-
 mm/mremap.c                                        |   9 +-
 mm/shrinker.c                                      |   2 +
 mm/swapfile.c                                      |   2 +-
 mm/vma.c                                           |   6 +-
 net/atm/pppoatm.c                                  |  42 +-
 net/bluetooth/coredump.c                           |  65 +-
 net/bluetooth/eir.c                                |  10 +-
 net/bluetooth/hci_codec.c                          |  36 +-
 net/bluetooth/hci_conn.c                           |  21 +
 net/bluetooth/hci_core.c                           |  18 +-
 net/bluetooth/hci_sync.c                           |   2 +
 net/bluetooth/iso.c                                |  53 +-
 net/bluetooth/rfcomm/sock.c                        |  13 +-
 net/bridge/br_mst.c                                |  20 +-
 net/bridge/br_vlan.c                               |  31 +-
 net/core/dev.c                                     | 110 +++-
 net/core/drop_monitor.c                            |  18 +-
 net/core/neighbour.c                               |  35 +-
 net/core/skbuff.c                                  |  32 +-
 net/core/sock.c                                    |  16 +-
 net/ipv4/esp4.c                                    |   6 +
 net/ipv4/icmp.c                                    |  17 +-
 net/ipv4/ip_tunnel_core.c                          |  16 +-
 net/ipv4/sysctl_net_ipv4.c                         |   4 +-
 net/ipv4/tcp_input.c                               |   3 +-
 net/ipv4/tcp_ulp.c                                 |   4 +
 net/ipv6/esp6.c                                    |   6 +
 net/ipv6/seg6_local.c                              |   3 +
 net/ipv6/tcp_ipv6.c                                |   3 +-
 net/ipv6/xfrm6_output.c                            |  10 +-
 net/mac80211/cfg.c                                 |  18 +-
 net/mac80211/debugfs.c                             |   2 +-
 net/mac80211/debugfs_netdev.c                      |   9 +
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/iface.c                               |  39 +-
 net/mac80211/main.c                                |   4 +
 net/mac80211/mesh.c                                |  34 +-
 net/mac80211/offchannel.c                          |   7 +
 net/mac80211/pm.c                                  |   8 +-
 net/mac80211/scan.c                                |   2 +-
 net/mac80211/tdls.c                                |  40 +-
 net/mac80211/tx.c                                  | 107 +--
 net/netfilter/nf_flow_table_core.c                 |  12 +-
 net/netfilter/nf_flow_table_path.c                 |   7 +-
 net/netfilter/nf_nat_core.c                        |  46 +-
 net/netfilter/nf_tables_api.c                      |  22 +-
 net/netfilter/nft_nat.c                            |   2 +-
 net/netlink/af_netlink.c                           |  42 +-
 net/netlink/diag.c                                 |  18 +-
 net/openvswitch/conntrack.c                        |   2 +-
 net/packet/af_packet.c                             |   4 +-
 net/packet/internal.h                              |   2 +-
 net/psp/psp_sock.c                                 |   4 +
 net/rds/ib_cm.c                                    |   2 +-
 net/sched/act_api.c                                |  11 +-
 net/sched/sch_hhf.c                                |   9 +-
 net/sched/sch_mqprio.c                             |   4 +-
 net/sched/sch_mqprio_lib.c                         |   7 +-
 net/sched/sch_taprio.c                             |  26 +-
 net/unix/garbage.c                                 |  17 +-
 net/wireless/core.c                                | 150 +++--
 net/wireless/core.h                                |  16 +-
 net/wireless/ibss.c                                |  38 +-
 net/wireless/rdev-ops.h                            |   3 +
 net/wireless/reg.c                                 |   2 +-
 net/wireless/scan.c                                |  43 +-
 net/wireless/util.c                                |  38 +-
 net/xfrm/espintcp.c                                |   6 +-
 net/xfrm/xfrm_input.c                              |  22 +-
 net/xfrm/xfrm_iptfs.c                              |  12 +-
 net/xfrm/xfrm_policy.c                             |  20 +-
 net/xfrm/xfrm_state.c                              |   9 +-
 net/xfrm/xfrm_user.c                               |  18 +-
 rust/kernel/net/phy.rs                             |  38 +-
 scripts/generate_rust_target.rs                    |   5 +
 security/keys/encrypted-keys/encrypted.c           |  20 +-
 security/keys/gc.c                                 |   4 +-
 security/keys/request_key_auth.c                   |  12 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  12 +-
 security/selinux/avc.c                             |   5 +-
 security/selinux/hooks.c                           | 158 ++++-
 security/selinux/include/objsec.h                  |  10 +-
 sound/core/init.c                                  |   3 +-
 sound/core/pcm_timer.c                             |   7 +-
 sound/hda/common/controller.c                      |   2 +-
 sound/soc/amd/acp/acp-sdw-legacy-mach.c            |  16 +-
 sound/soc/amd/acp/acp-sdw-sof-mach.c               |  21 +-
 sound/soc/codecs/cs-amp-lib.c                      |   2 +
 sound/soc/codecs/hdmi-codec.c                      |   6 +-
 sound/soc/codecs/rt712-sdca-dmic.c                 |  14 +-
 sound/soc/intel/boards/sof_sdw.c                   |   2 +-
 sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c       |   4 +-
 sound/soc/sdw_utils/soc_sdw_utils.c                |   9 +-
 sound/soc/soc-pcm.c                                |  18 +-
 sound/soc/ux500/ux500_msp_i2s.h                    |   4 +-
 sound/usb/6fire/comm.c                             |  42 +-
 sound/usb/6fire/comm.h                             |   2 +-
 sound/usb/6fire/midi.c                             |  43 +-
 sound/usb/6fire/midi.h                             |   2 +-
 sound/usb/6fire/pcm.c                              | 138 ++--
 sound/usb/6fire/pcm.h                              |   5 +-
 sound/usb/bcd2000/bcd2000.c                        |  33 +-
 sound/usb/card.h                                   |   1 +
 sound/usb/endpoint.c                               |  12 +-
 sound/virtio/virtio_card.c                         |   4 +-
 tools/objtool/Makefile                             |   8 +-
 .../selftests/arm64/mte/check_gcr_el1_cswitch.c    |   2 +-
 tools/testing/selftests/landlock/fs_test.c         | 197 +++++-
 442 files changed, 6831 insertions(+), 2723 deletions(-)


