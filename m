Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF97080D;
	Fri,  4 Sep 2026 06:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501980; cv=none; b=qtptriGMU0Xro7n6jsAvBgwK8mHb61+RfYj6h+jpfKlCDhK04a66vCb8cn1sjWw+nwig1GYAFVr8R4OMQY70NMmp/zp56dfRNS5cqgtq5mljc3oNYAcHxgDXEHjTYhKhc9aZqH6EyiTCsVpLjnY34uPfRexepvj/+m6ucjGXdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501980; c=relaxed/simple;
	bh=QPwSOTjSSAInQEu/UUb4DRWvRfdXt06PWnSJV4Sx8CA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pjzjg23mO4i2nIngekHyXmt66VspAPDbIf+Cr00Bdii/M89XVGL0lAftEGL0f9zp9sKDL6d92RAwTWVSg5WoehIGeayU8fDzPksYSZxD+LtQt27ZXWJR0be3KF8OO20dfiuwmX10rFfVkvuBsp3lEvIuZ2LIcrxpyyWBnAr/Sxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIuPsVLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIuPsVLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CD61F00A3D;
	Fri,  4 Sep 2026 06:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501976;
	bh=krdi8glNMAlldM164SiDNdxUqY0Ot/MhyOQ6ZD+m1B0=;
	h=From:To:Cc:Subject:Date;
	b=jIuPsVLAzdUFUAioDgofZQOfdkG4ob6/mfxj5As1I2Wv5Df3ClLpKU6mS2g0nyOKk
	 Zyc3JoaJhgKXtbDnyUgsctzyMkFPuhZmZipaISH9dniemwyF1DLBbcW+XHVtniLrJR
	 d0y7fL2ESBbek4dhsqTYNU3r//tXW2xFX/8Di89I=
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
Subject: [PATCH 6.12 000/403] 6.12.109-rc1 review
Date: Fri,  4 Sep 2026 06:56:43 +0200
Message-ID: <20260904045734.806166532@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.109-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.109-rc1
X-KernelTest-Deadline: 2026-09-06T04:57+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.109 release.
There are 403 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.109-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.109-rc1

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

Dawei Feng <dawei.feng@seu.edu.cn>
    wifi: rtw88: pci: fix resource leak on failed NAPI setup

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    wifi: rtlwifi: rtl8192du: check QoS TID before indexing tids

Stanislaw Gruszka <stf_xl@wp.pl>
    wifi: rtl818x: initialize eeprom_93cx6 struct to zero

Fabio Estevam <festevam@nabladev.com>
    wifi: mwifiex: Detach sync cmd buffer on interrupted wait

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ss - Remove crypto_rng interface

Eric Biggers <ebiggers@kernel.org>
    crypto: sun8i-ce - Remove crypto_rng interface

Fan Wu <fanwu01@zju.edu.cn>
    wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()

Adrian Hunter <adrian.hunter@intel.com>
    i3c: master: Fix potential UAF in i3c_device_uevent()

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

Naman Jain <namjain@linux.microsoft.com>
    PCI: hv: Set irq_retrigger callback for the Hyper-V PCI MSI irqchip

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test

Miguel Ojeda <ojeda@kernel.org>
    rust: rust_is_available: warn for `bindgen` < 0.72.1 && libclang >= 22

Ashish Kalra <ashish.kalra@amd.com>
    x86/sev: Fix broken SNP support with KVM module built-in

Gao Shiyuan <gaoshiyuan@baidu.com>
    iommu/amd: remove return value of amd_iommu_detect

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Fix subbuf resize race with ring buffer readers

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

Abdun Nihaal <nihaal@cse.iitm.ac.in>
    mfd: sm501: Fix potential memory leaks during remove

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
    net: ravb: serialize PTP clock teardown

Xuanqiang Luo <luoxuanqiang@kylinos.cn>
    net: ravb: avoid dereferencing an invalid PTP clock

Ruoyu Wang <ruoyuw560@gmail.com>
    net: openvswitch: fix nf_connlabels leak in ovs_ct_init

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix flow mask use-after-free on flow deletion

Zihan Xi <zihanx@nebusec.ai>
    net: l2tp: do not propagate multicast notification errors

Jorijn van der Graaf <jorijnvdgraaf@catcrafts.net>
    net: ipa: fix stalled modem TX queue after runtime resume

Ahmad Fatoum <a.fatoum@pengutronix.de>
    net: dsa: realtek: use gpiod_set_value_cansleep for reset GPIO

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
    platform/x86: ISST: Return error during profile addition

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate parameter for frequency and priority

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate parameter for core power state

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Validate logical CPU id and clos id

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Use PP level enable mask

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Just allow 2 bits for SST feature enable

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Add a NULL check for sst_inst[]

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

Shameer Kolothum <skolothumtho@nvidia.com>
    iommu/arm-smmu-v3: Manage teardown with devm

Shuai Xue <xueshuai@linux.alibaba.com>
    iommu/sva: Set handle->dev before the SVA handle is visible

Shuai Xue <xueshuai@linux.alibaba.com>
    iommu/amd: Put PCI device after handling PPR faults

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Warn on writes to kernel-exclusive config space regions

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Use file_ns_capable() when checking config space read access

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/proc: Avoid spurious runtime PM wakeup on config space accesses

Farhan Ali <alifm@linux.ibm.com>
    PCI/MSI: Enable memory decoding before restoring MSI-X messages

Darshit Shah <darnshah@amazon.de>
    PCI/DPC: Allow DPC on all Downstream Ports when OS controls AER

Max Lee <max.lee@canonical.com>
    PCI/ASPM: Avoid L0s for Realtek RTS525A

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Avoid spurious runtime PM wakeup on config space accesses

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Fix read byte order in pci_read_legacy_io()

Tim Harvey <tharvey@gateworks.com>
    PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]

Ali Tariq <alitariq45892@gmail.com>
    PCI: plda: Fix IRQ domain leaks in the error paths of plda_init_interrupts()

Ali Tariq <alitariq45892@gmail.com>
    PCI: plda: Fix use-after-free of event IRQs during teardown

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

Jianing Li <m13940358460@163.com>
    power: supply: max17040: propagate register read errors

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: ucs1002: fix use-after-free on remove

Maoyi Xie <maoyixie.tju@gmail.com>
    power: supply: twl4030_charger: cancel workers via devm

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: rt9455: quiesce delayed work before teardown

HyeongJun An <sammiee5311@gmail.com>
    power: supply: qcom_battmgr: terminate the strings from firmware

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: lp8788-charger: fix use-after-free on remove

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: lp8727: fix use-after-free in lp8727_release_irq()

Jameson Thies <jthies@google.com>
    power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS

Bryam Vargas <hexlabsecurity@proton.me>
    power: supply: cros_usbpd-charger: bound the EC-reported port count

Fan Wu <fanwu01@zju.edu.cn>
    power: supply: charger-manager: register regulators before exposing sysfs

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

Shuangpeng Bai <shuangpeng.kernel@gmail.com>
    lockd: fix NULL dereference on lockowner allocation failure

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

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Hold cpu_buffer::lock when resizing a subbuf

Vincent Donnefort <vdonnefort@google.com>
    ring-buffer: Free cpu_buffer::free_page with subbuf_order

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

Peixin Xie <peixin.xie@linux.spacemit.com>
    riscv: acpi: Handle LPI architectural context loss flags

Fabio Estevam <festevam@nabladev.com>
    arm64: dts: rockchip: Fix rk3399-roc-pc-plus analog audio

Quentin Schulz <quentin.schulz@cherry.de>
    arm64: dts: rockchip: fix eMMC reset polarity on PX30 Ringneck

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    arm64: dts: qcom: sm6115-pro1x: Correct touchscreen GPIO flags

Chunkai Deng <chunkai.deng@oss.qualcomm.com>
    rpmsg: glink: smem: order FIFO read after availability check

Petr Vaganov <p.vaganov@ideco.ru>
    scsi: core: Fill in DMA padding bytes in scsi_alloc_sgtables()

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: media: tegra-video: vi: fix probe failure on skipped last port

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: media: tegra-video: fix of_node_put() on VIP parse errors

Doruk Tan Ozturk <doruk@0sec.ai>
    wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets

David Lee <david.lee@trailofbits.com>
    udf: reject VAT indexes equal to the entry count

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Validate Read chunk positions before reconstruction

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Use svc_xprt_put to free listener on create failure

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject inline replies that overflow the pull-up buffer

Chuck Lever <chuck.lever@oracle.com>
    svcrdma: Reject connection when transport allocation fails

Chris Mason <clm@meta.com>
    svcrdma: Fix unmatched rn_unregister on failed accept

Chris Mason <clm@meta.com>
    svcrdma: Fix pcl_for_each_segment for empty chunks

Chris Mason <clm@meta.com>
    svcrdma: Fix offset arithmetic in read_chunk_range

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    SUNRPC: wait for in-flight client TLS handshake callback

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Reject krb5 v2 wrap tokens with oversized ec field

Chris Mason <clm@meta.com>
    SUNRPC: reject duplicate CREDS_VALUE options

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

Jiacheng Yu <yujiacheng3@huawei.com>
    params: fix charp corruption on allocation failure

Dave Airlie <airlied@redhat.com>
    nouveau/gem: reserve the bo in the info ioctl around the vma lookup

Harshit Varu <harshitvaru666@gmail.com>
    mptcp: fix uninitialized local_id in syncookie MP_JOIN reconstruction

Qing Ming <a0yami@mailbox.org>
    mpls: reload header after pskb_may_pull()

Coly Li <colyli@fygo.io>
    md: do overflow check for sb->bblog_shift in super_1_load()

Yunye Zhao <yunye.zhao@linux.alibaba.com>
    md/raid10: fix still_degraded being inverted in raid10_sync_request()

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

Max Kellermann <max.kellermann@ionos.com>
    jbd2: check need_resched() when skipping busy checkpoint buffers

Max Kellermann <max.kellermann@ionos.com>
    jbd2: bound shrinker scans by examined checkpoint buffers

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

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    Bluetooth: hci_bcm4377: Ignore reserved PHY in ext adv reports on BCM4378

Alison Schofield <alison.schofield@intel.com>
    cxl/pmem: Format the nvdimm serial number as unsigned decimal

Hui Su <sh_def@163.com>
    cpufreq: schedutil: Fix rate limit overflow

Kuan-Wei Chiu <visitorckw@gmail.com>
    coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior

Bryam Vargas <hexlabsecurity@proton.me>
    dm array: reject an array block whose value size is not the caller's

Bryam Vargas <hexlabsecurity@proton.me>
    dm array: validate array block headers on read

Ilya Krutskih <devsec@tpz.ru>
    dm raid1: reserve space for NUL-terminator in build_constructor_string()

liyouhong <liyouhong@kylinos.cn>
    dm-era: fix shadowed superblock leak on take-snap failure

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    bpf: Harden bloom filter sizing and indexing on 32-bit kernels

Daniel Borkmann <borkmann@iogearbox.net>
    bpf: Disable preemption in __bpf_get_stack

Vineet Gupta <vineet.gupta@linux.dev>
    bpf, x86: Fix per-CPU address resolution into an extended register

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

TanZheng <tanzheng@kylinos.cn>
    ACPI: APEI: GHES: fix ARM section length accounting after header

Nirmoy Das <nirmoyd@nvidia.com>
    ACPI: APEI: Fix ERST timeout unit conversion

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

Guanghui Yang <3497809730@qq.com>
    btrfs: drop recovered reloc root refs on recovery failure

Max Kellermann <max.kellermann@ionos.com>
    ceph: do not repeat ceph_trim_dentries() if no progress possible

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound xattr value length in __build_xattrs()

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound num_export_targets array for mds info v2/v3

Michael Bommarito <michael.bommarito@gmail.com>
    ceph: bound MDSCapAuth path and fs_name decode in handle_session()

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

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent client use-after-free during NFSv4.0 revoked-state cleanup

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Prevent lock owner use-after-free during client teardown

Jeff Layton <jlayton@kernel.org>
    nfsd: revoke copy-notify stateids before dropping their reference

Jeff Layton <jlayton@kernel.org>
    nfsd: reject reclaim LOCK after RECLAIM_COMPLETE

Robbie Ko <robbieko@synology.com>
    nfsd: reject out-of-range useconds in NFSv2 SETATTR/CREATE

Robbie Ko <robbieko@synology.com>
    nfsd: reject out-of-range nseconds in NFSv3 SETATTR and create ops

Jeff Layton <jlayton@kernel.org>
    nfsd: initialize DRC hash table before registering shrinker

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

Jeff Layton <jlayton@kernel.org>
    nfsd: fix reply size estimate for GET_DIR_DELEGATION

Jeff Layton <jlayton@kernel.org>
    nfsd: fix nfsd_file leak on inter-server COPY setup failure

Jeff Layton <jlayton@kernel.org>
    nfsd: fix dentry ref leak on V4ROOT export filehandle lookup

Chris Mason <clm@meta.com>
    nfsd: fix cpntf publish race in nfs4_init_cp_state

Jeff Layton <jlayton@kernel.org>
    nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke

Jeff Layton <jlayton@kernel.org>
    nfsd: drop the stateid, not the stateowner, on seqid_op replay retry

Jeff Layton <jlayton@kernel.org>
    nfsd: defer vfree of compound ops to fix rpc_status UAF

Jeff Layton <jlayton@kernel.org>
    nfsd: clear opcnt on compound arg release to prevent OOB read

Jeff Layton <jlayton@kernel.org>
    nfsd: check client ownership when cancelling a copy-notify stateid

Jeff Layton <jlayton@kernel.org>
    nfsd: block non-SAVEFH ops after FOREIGN PUTFH to prevent NULL deref

Jeff Layton <jlayton@kernel.org>
    nfsd: add missing read barrier to rpc_status_get dumpit seqcount retry

Jeff Layton <jlayton@kernel.org>
    nfsd: add filehandle match check to nfsd4_delegreturn()

Jeff Layton <jlayton@kernel.org>
    nfsd: add fh_want_write() for early-verified SETATTR in nfsd_proc_setattr()

Jeff Layton <jlayton@kernel.org>
    nfsd: validate symlink target length in NFSv4 CREATE

Chris Mason <clm@meta.com>
    nfsd: size fh_verify server sockaddr slot by xpt_locallen

Zhenghang Xiao <kipreyyy@gmail.com>
    nfsd: set SC_STATUS_FREED in nfsd4_drop_revoked_stid for delegations

Chuck Lever <chuck.lever@oracle.com>
    nfsd: sample writeback error cursor before async COPY loop

Jeff Layton <jlayton@kernel.org>
    nfsd: return NFS4ERR_NOTSUPP for unsupported netloc4 types

Chuck Lever <chuck.lever@oracle.com>
    nfsd: Reset write verifier when async COPY writeback fails

Chris Mason <clm@meta.com>
    nfsd: release path refs on follow_down() error

Tim Menninger <tmenninger@everpuredata.com>
    pNFS: Fix EBUSY check in pnfs_layout_need_return

Junrui Luo <moonafterrain@outlook.com>
    NFSv4.1: fix layout segment leak on the pnfs_layout_process() forget path

Chris Mason <clm@meta.com>
    nfsd: guard nfsd_serv deref in nfsd_file_net_dispose

Mike Snitzer <snitzer@kernel.org>
    NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check

Michael Bommarito <michael.bommarito@gmail.com>
    NFSD: restart ssc_expire_umount walk after dropping nfsd_ssc_lock

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix off-by-one in DRC bucket pruning limit

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Encode only the status in NFS-ACL v2 GETACL error replies

Chuck Lever <chuck.lever@oracle.com>
    NFSD: check truncate permission under inode lock

Longlong Xia <xialonglong@kylinos.cn>
    zsmalloc: account for handle size in class lookup

Ibrahim Hashimov <security@auditcode.ai>
    ubifs: fix out-of-bounds read in signature length check

Krzysztof Wilczyński <kwilczynski@kernel.org>
    PCI/sysfs: Fix out-of-bounds read in pci_write_legacy_io()

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

Huang Wei <huangwei@kylinos.cn>
    usb: typec: ucsi: use UCSI_TIMEOUT_MS for sync command completion

Xu Yang <xu.yang_2@nxp.com>
    usb: typec: tcpci: pass correct rx_type to tcpm_pd_receive()

Johan Hovold <johan@kernel.org>
    USB: phy: fsl-usb: fix missing static keywords

Fan Wu <fanwu01@zju.edu.cn>
    usb: gadget: at91_udc: drain polled-VBUS timer/work before udc is freed

Francesco Lavra <flavra@baylibre.com>
    usb: dwc2: gadget: Exit partial power down state when changing USB pull-up

Hao-Qun Huang <alvinhuang0603@gmail.com>
    staging: greybus: hid: fix SET_REPORT return value

Karl Mehltretter <kmehltretter@gmail.com>
    serial: imx: serialize imx_uart_ports[] lifetime

Hans Verkuil <hverkuil+cisco@kernel.org>
    Revert "media: v4l2-dev: fix error handling in __video_register_device()"

James Kim <james010kim@gmail.com>
    rapidio: mport_cdev: fix use-after-free in dma_req_free()

Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
    powerpc/powermac: fix OF node refcount

Bryam Vargas <hexlabsecurity@proton.me>
    misc: nsm: bound the device-reported response length

Xu Yang <xu.yang_2@nxp.com>
    device property: fix infinite loop in fwnode_for_each_child_node()

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    cdx: Fix double free when sysfs file creation fails

Hui Su <sh_def@163.com>
    tracing: Fix use-after-free with same-name named triggers

Deepanshu Kartikey <kartikey406@gmail.com>
    tracing: Fix use-after-free in trace_pipe read on sub-buffer order change

Vincent Donnefort <vdonnefort@google.com>
    tracing: Fix logged instance name on creation failure

Hui Su <sh_def@163.com>
    tracing: Fix crash passing ERR_PTR to kthread_stop()

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    tracing/user_events: Clear copied tracing state before fork duplication

Sanman Pradhan <psanman@juniper.net>
    hwtracing: hisi_ptt: Propagate DMA reset timeout in trace_start()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/tdx: Fix zero-extension for 32-bit port I/O

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/insn-eval: Move assign_register() out of KVM as insn_assign_reg()

Kiryl Shutsemau (Meta) <kas@kernel.org>
    x86/tdx: Fix off-by-one in port I/O handling

Joy H.J. Lee <rkr0k0r@gmail.com>
    tools/compiler: match glibc 2.42 definition of __attribute_const__

Johannes Weiner <hannes@cmpxchg.org>
    mm: mempolicy: fix automatic numa balancing for shmem

Guopeng Zhang <zhangguopeng@kylinos.cn>
    mm: memcg: stop reclaim when a limit update is superseded

Hao Jia <jiahao1@lixiang.com>
    mm/zswap: fix global shrinker when memory cgroup is disabled

Breno Leitao <leitao@debian.org>
    mm/vmscan: report RCU-tasks quiescent states in shrink_lruvec()

Dev Jain <dev.jain@arm.com>
    mm/page_vma_mapped: use huge_ptep_get() for hugetlb

Ye Liu <ye.liu@linux.dev>
    mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()

Dev Jain <dev.jain@arm.com>
    mm/migrate: use huge_ptep_get() in remove_migration_pte()

Breno Leitao <leitao@debian.org>
    mm/migrate: report RCU-tasks quiescent states in migrate_pages_batch()

Breno Leitao <leitao@debian.org>
    mm/kmemleak: avoid soft lockup when scanning task stacks

Jordan R Abrahams-Whitehead <ajordanr@google.com>
    include/linux/list.h: mark list_add and __list_add as __always_inline

Hyunwoo Kim <imv4bel@gmail.com>
    apparmor: fix out-of-bounds write when null terminating a label vec

Jann Horn <jannh@google.com>
    apparmor: fix cred UAF caused by begin_current_label_crit_section()

Gary Guo <gary@garyguo.net>
    rust: cfi: disable function merging if CFI is enabled

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    timers/itimer: Zero-init old itimerval before copy to userspace

Gaurav Batra <gbatra@linux.ibm.com>
    powerpc/pseries/iommu: switch to Default DMA window during kdump

Baokun Li <libaokun@linux.alibaba.com>
    fs: fix user path of nested backing files

Felix Yan <felixonmars@archlinux.org>
    clocksource/drivers/timer-sun4i: Advertise a real minimum delta

Matt Turner <mattst88@gmail.com>
    alpha: don't leak hardware-fabricated FP exception bits to user space

Matt Turner <mattst88@gmail.com>
    alpha: fix ieee_swcr_to_fpcr setting FPCR_DNOD unconditionally

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amd/display: Avoid NULL dereference in dc_dmub_srv error paths

Zilin Guan <zilin@seu.edu.cn>
    wifi: ath11k: fix memory leaks in beacon template setup

Zilin Guan <zilin@seu.edu.cn>
    wifi: mt76: Fix memory leak after mt76_connac_mcu_alloc_sta_req()

Zide Chen <zide.chen@intel.com>
    perf/x86/intel/uncore: Fix die ID init and look up bugs

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Avoid divide by zero by initializing dummy pitch to 1

Ming Lei <tom.leiming@gmail.com>
    block: mark GFP_NOIO around sysfs ->store()

Chao Yu <chao@kernel.org>
    f2fs: fix potential deadloop in prepare_compress_overwrite()

Yang Erkun <yangerkun@huawei.com>
    md: make rdev_addable usable for rcu mode

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Mask the bd_cnt field in the TX BD properly


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-bus-nvdimm         |   3 +-
 Makefile                                           |   7 +-
 arch/alpha/include/uapi/asm/fpu.h                  |   8 +-
 arch/alpha/kernel/pci-sysfs.c                      |   6 +-
 arch/alpha/kernel/sys_marvel.c                     |  25 ++-
 arch/alpha/kernel/traps.c                          |   6 +-
 arch/alpha/math-emu/math.c                         |  88 +++++++-
 arch/arm/Kconfig                                   |   2 +-
 arch/arm64/boot/dts/qcom/sm6115-fxtec-pro1x.dts    |   2 +-
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |   2 +-
 .../arm64/boot/dts/rockchip/rk3399-roc-pc-plus.dts |  12 ++
 arch/arm64/kernel/compat_alignment.c               |   4 +-
 arch/openrisc/kernel/entry.S                       |  43 +++-
 arch/powerpc/kernel/pci-common.c                   |   9 +-
 arch/powerpc/platforms/powermac/low_i2c.c          |   2 +-
 arch/powerpc/platforms/pseries/iommu.c             |  23 ++-
 arch/riscv/include/asm/acpi.h                      |  19 ++
 arch/s390/kernel/perf_cpum_cf.c                    | 221 ++++++++++++++-------
 arch/x86/coco/tdx/tdx.c                            |  10 +-
 arch/x86/events/intel/uncore.c                     |   1 +
 arch/x86/events/intel/uncore_snbep.c               |  13 +-
 arch/x86/include/asm/insn-eval.h                   |  36 ++++
 arch/x86/include/asm/sev.h                         |   2 +
 arch/x86/kvm/emulate.c                             |  26 +--
 arch/x86/net/bpf_jit_comp.c                        |   2 +-
 arch/x86/virt/svm/sev.c                            |  21 +-
 block/blk-sysfs.c                                  |   3 +
 block/genhd.c                                      |   1 +
 drivers/acpi/apei/erst.c                           |   2 +-
 drivers/acpi/apei/ghes.c                           |   2 +-
 drivers/acpi/pfr_update.c                          |  45 +++--
 drivers/ata/libata-scsi.c                          |  28 +--
 drivers/auxdisplay/charlcd.c                       |  21 +-
 drivers/base/arch_numa.c                           |  12 ++
 drivers/base/property.c                            |  19 +-
 drivers/bluetooth/btusb.c                          |   6 +
 drivers/bluetooth/hci_bcm.c                        |   1 +
 drivers/bluetooth/hci_bcm4377.c                    |   1 +
 drivers/bluetooth/hci_h5.c                         |   4 +-
 drivers/bluetooth/hci_intel.c                      |   1 +
 drivers/bluetooth/hci_ldisc.c                      |   2 +-
 drivers/bluetooth/hci_serdev.c                     |   2 +-
 drivers/cdx/cdx.c                                  |   7 +-
 drivers/char/ipmi/ipmb_dev_int.c                   |   5 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   1 +
 drivers/char/tpm/tpm_i2c_nuvoton.c                 |   6 +-
 drivers/clocksource/timer-sun4i.c                  |   2 +-
 drivers/crypto/allwinner/Kconfig                   |  16 --
 drivers/crypto/allwinner/sun8i-ce/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  57 ------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c  | 159 ---------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  29 ---
 drivers/crypto/allwinner/sun8i-ss/Makefile         |   1 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |  39 ----
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  | 177 -----------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h       |  23 ---
 drivers/cxl/core/pmem.c                            |  10 +-
 drivers/cxl/cxl.h                                  |   3 +-
 drivers/cxl/pmem.c                                 |   2 +-
 drivers/fpga/altera-cvp.c                          |  10 +-
 drivers/fpga/stratix10-soc.c                       |  21 +-
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c       |  10 +-
 .../amd/display/dc/dml2/dml2_translation_helper.c  |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  11 +-
 drivers/hid/hid-mcp2221.c                          |   9 +
 drivers/hid/hid-picolcd_debugfs.c                  |   9 +
 drivers/hid/hid-roccat.c                           |  13 +-
 drivers/hid/hid-sensor-custom.c                    |   9 +-
 drivers/hid/hid-sensor-hub.c                       |  46 +++--
 drivers/hsi/controllers/omap_ssi_core.c            |   6 +
 drivers/hwmon/max6621.c                            |   8 +-
 .../hwtracing/coresight/coresight-etm3x-sysfs.c    |  15 +-
 drivers/hwtracing/ptt/hisi_ptt.c                   |  20 +-
 drivers/i3c/master.c                               |  12 +-
 drivers/i3c/master/svc-i3c-master.c                |  10 +-
 drivers/infiniband/core/ucma.c                     |   5 +-
 drivers/infiniband/hw/cxgb4/device.c               |   6 +
 drivers/interconnect/core.c                        |   7 +-
 drivers/iommu/amd/init.c                           |  36 +++-
 drivers/iommu/amd/ppr.c                            |   3 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  56 ++++--
 drivers/iommu/intel/dmar.c                         |  15 +-
 drivers/iommu/intel/iommu.c                        |   8 +-
 drivers/iommu/intel/iommu.h                        |   2 +
 drivers/iommu/iommu-sva.c                          |   2 +-
 drivers/mailbox/qcom-ipcc.c                        |  17 +-
 drivers/md/dm-era-target.c                         |   5 +
 drivers/md/dm-log-userspace-base.c                 |   1 +
 drivers/md/dm-stats.c                              |   6 +-
 drivers/md/dm-switch.c                             |   2 +-
 drivers/md/md.c                                    |  15 +-
 drivers/md/persistent-data/dm-array.c              |  53 ++++-
 drivers/md/raid10.c                                |   2 +-
 drivers/media/cec/platform/stm32/stm32-cec.c       |   3 +-
 drivers/media/test-drivers/vicodec/vicodec-core.c  |   4 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/mfd/sm501.c                                |   2 +
 drivers/misc/nsm.c                                 |   2 +-
 drivers/mmc/host/via-sdmmc.c                       |   8 +-
 drivers/net/dsa/realtek/rtl83xx.c                  |   4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   3 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   4 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |   8 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   1 +
 drivers/net/ethernet/renesas/ravb.h                |   3 +
 drivers/net/ethernet/renesas/ravb_main.c           |   9 +-
 drivers/net/ethernet/renesas/ravb_ptp.c            |  44 +++-
 drivers/net/ipa/ipa_modem.c                        |  18 +-
 drivers/net/ntb_netdev.c                           |  11 +-
 drivers/net/slip/slip.c                            |  11 +-
 drivers/net/thunderbolt/main.c                     |  12 ++
 drivers/net/tun.c                                  |  21 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/wireless/ath/ath11k/mac.c              |  28 ++-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   5 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   3 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  12 ++
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   5 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   2 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  19 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/sw.c    |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/trx.c   |   3 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   4 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   1 +
 drivers/ntb/ntb_transport.c                        |  38 ++--
 drivers/nvdimm/label.c                             |   2 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/fc.c                             |   2 +-
 drivers/nvme/host/pci.c                            |   1 +
 drivers/nvme/host/tcp.c                            |  45 ++++-
 drivers/of/base.c                                  |   2 +-
 drivers/pci/controller/dwc/pci-meson.c             |   2 +-
 drivers/pci/controller/pci-hyperv.c                |   1 +
 drivers/pci/controller/plda/pcie-plda-host.c       |  52 ++++-
 drivers/pci/msi/msi.c                              |  10 +
 drivers/pci/pci-sysfs.c                            |  42 +++-
 drivers/pci/pcie/portdrv.c                         |   2 +-
 drivers/pci/proc.c                                 |  16 +-
 drivers/pci/quirks.c                               |   9 +-
 drivers/platform/chrome/cros_ec_sensorhub_ring.c   |  19 +-
 .../x86/dell/dell-wmi-sysman/biosattr-interface.c  |   1 -
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c       |  18 +-
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.h       |   8 +
 .../platform/x86/hp/hp-bioscfg/enum-attributes.c   |  15 +-
 .../platform/x86/hp/hp-bioscfg/int-attributes.c    |   6 +-
 .../x86/hp/hp-bioscfg/order-list-attributes.c      |  14 +-
 .../x86/hp/hp-bioscfg/passwdobj-attributes.c       |  14 +-
 .../platform/x86/hp/hp-bioscfg/spmobj-attributes.c |   4 +-
 .../platform/x86/hp/hp-bioscfg/string-attributes.c |   6 +-
 drivers/platform/x86/intel/ishtp_eclite.c          |   5 +-
 .../x86/intel/speed_select_if/isst_tpmi_core.c     |  77 ++++++-
 drivers/power/supply/bq24257_charger.c             |  16 +-
 drivers/power/supply/bq256xx_charger.c             |  29 +--
 drivers/power/supply/bq25890_charger.c             |  12 ++
 drivers/power/supply/charger-manager.c             |  54 +++--
 drivers/power/supply/cros_usbpd-charger.c          |  17 +-
 drivers/power/supply/lp8727_charger.c              |   4 +-
 drivers/power/supply/lp8788-charger.c              |   2 +-
 drivers/power/supply/max17040_battery.c            |  32 ++-
 drivers/power/supply/qcom_battmgr.c                |   2 +-
 drivers/power/supply/rt9455_charger.c              |  21 +-
 drivers/power/supply/twl4030_charger.c             |  12 +-
 drivers/power/supply/ucs1002_power.c               |   6 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |  10 +-
 drivers/regulator/as3722-regulator.c               |   1 -
 drivers/regulator/max8998.c                        |   1 -
 drivers/regulator/qcom-refgen-regulator.c          |   4 +-
 drivers/remoteproc/mtk_scp.c                       |   9 +-
 drivers/rpmsg/qcom_glink_smem.c                    |   7 +
 drivers/s390/block/dasd.c                          |   6 +-
 drivers/s390/block/dasd_eckd.c                     |  40 +++-
 drivers/s390/block/dasd_erp.c                      |   3 +
 drivers/scsi/scsi_lib.c                            |   2 +
 drivers/staging/greybus/hid.c                      |   2 +-
 drivers/staging/media/tegra-video/vi.c             |   9 +-
 drivers/staging/media/tegra-video/vip.c            |  10 +-
 drivers/tty/serial/imx.c                           |  20 +-
 drivers/usb/dwc2/gadget.c                          |  11 +-
 drivers/usb/gadget/function/f_fs.c                 |  14 +-
 drivers/usb/gadget/function/f_midi2.c              |   2 +
 drivers/usb/gadget/function/f_tcm.c                |  23 ++-
 drivers/usb/gadget/function/f_uvc.c                |   7 +-
 drivers/usb/gadget/function/u_audio.c              |  24 ++-
 drivers/usb/gadget/udc/at91_udc.c                  |  20 +-
 drivers/usb/gadget/udc/snps_udc_plat.c             |   5 +-
 drivers/usb/phy/phy-fsl-usb.c                      |  52 ++---
 drivers/usb/phy/phy-fsl-usb.h                      |   6 +-
 drivers/usb/typec/tcpm/tcpci.c                     |  12 +-
 drivers/usb/typec/ucsi/ucsi.c                      |   3 +-
 .../fbdev/omap2/omapfb/displays/panel-dsi-cm.c     |   4 +-
 drivers/video/fbdev/pvr2fb.c                       |   4 +-
 drivers/video/fbdev/ssd1307fb.c                    |  72 ++++++-
 drivers/video/fbdev/uvesafb.c                      |   2 +
 drivers/video/sticore.c                            |  22 +-
 drivers/w1/slaves/w1_ds28e17.c                     |   8 +
 fs/backing-file.c                                  |   2 +-
 fs/btrfs/relocation.c                              |  31 ++-
 fs/ceph/caps.c                                     |  11 +-
 fs/ceph/dir.c                                      |  10 +-
 fs/ceph/export.c                                   |  26 ++-
 fs/ceph/mds_client.c                               |   8 +-
 fs/ceph/mdsmap.c                                   |  11 +-
 fs/ceph/xattr.c                                    |   1 +
 fs/ecryptfs/crypto.c                               |   2 +-
 fs/ecryptfs/ecryptfs_kernel.h                      |   3 +-
 fs/ecryptfs/keystore.c                             |  45 ++++-
 fs/ecryptfs/messaging.c                            |  11 +-
 fs/ecryptfs/miscdev.c                              |   5 +-
 fs/ecryptfs/super.c                                |   7 +
 fs/efivarfs/super.c                                |  30 ++-
 fs/f2fs/compress.c                                 |   1 +
 fs/f2fs/data.c                                     |  10 +-
 fs/fat/misc.c                                      |   4 +
 fs/jbd2/checkpoint.c                               |  28 +--
 fs/lockd/clntproc.c                                |   3 +
 fs/lockd/svcsubs.c                                 |  53 ++---
 fs/nfs/pnfs.c                                      |   3 +-
 fs/nfsd/filecache.c                                |  15 +-
 fs/nfsd/flexfilelayoutxdr.c                        |  20 +-
 fs/nfsd/nfs2acl.c                                  |  52 ++---
 fs/nfsd/nfs3acl.c                                  |  17 +-
 fs/nfsd/nfs3proc.c                                 |  40 ++++
 fs/nfsd/nfs4layouts.c                              |  12 +-
 fs/nfsd/nfs4proc.c                                 |  51 +++--
 fs/nfsd/nfs4state.c                                | 215 +++++++++++++++-----
 fs/nfsd/nfs4xdr.c                                  |  22 +-
 fs/nfsd/nfscache.c                                 |   6 +-
 fs/nfsd/nfsctl.c                                   |  11 +-
 fs/nfsd/nfsfh.c                                    |  12 +-
 fs/nfsd/nfsproc.c                                  |   7 +
 fs/nfsd/nfssvc.c                                   |   4 +-
 fs/nfsd/nfsxdr.c                                   |  32 ++-
 fs/nfsd/trace.h                                    |   4 +-
 fs/nfsd/vfs.c                                      |  34 ++--
 fs/nilfs2/bmap.c                                   |   2 +-
 fs/nilfs2/bmap.h                                   |   2 +-
 fs/nilfs2/btree.c                                  |  39 +++-
 fs/nilfs2/direct.c                                 |   4 +-
 fs/ntfs3/frecord.c                                 |   9 +
 fs/ntfs3/fslog.c                                   |  34 ++++
 fs/ocfs2/cluster/heartbeat.c                       | 150 +++++++++++---
 fs/ocfs2/cluster/nodemanager.c                     |   6 +
 fs/ocfs2/cluster/nodemanager.h                     |   1 +
 fs/ocfs2/dir.c                                     |   2 +-
 fs/ocfs2/dlm/dlmmaster.c                           |   6 +
 fs/ocfs2/dlm/dlmrecovery.c                         |   9 +
 fs/ocfs2/refcounttree.c                            |  47 +++--
 fs/ocfs2/xattr.c                                   |   5 +-
 fs/orangefs/devorangefs-req.c                      |   1 +
 fs/orangefs/orangefs-debugfs.c                     |   1 +
 fs/smb/client/cifsfs.c                             |  15 +-
 fs/smb/client/dfs_cache.c                          |  33 ++-
 fs/smb/client/smb1ops.c                            |   2 +-
 fs/smb/client/smb2file.c                           |   5 +-
 fs/tracefs/event_inode.c                           |   7 +-
 fs/ubifs/auth.c                                    |   2 +-
 fs/udf/inode.c                                     |   2 +-
 fs/udf/partition.c                                 |   2 +-
 include/linux/amd-iommu.h                          |   4 +-
 include/linux/list.h                               |  15 +-
 include/linux/sunrpc/svc_rdma_pcl.h                |   2 +-
 include/linux/usb/tcpci.h                          |   1 +
 include/net/ip_tunnels.h                           |  11 +-
 include/net/sctp/structs.h                         |   2 +-
 kernel/auditfilter.c                               |   6 +-
 kernel/bpf/bloom_filter.c                          |  19 +-
 kernel/bpf/stackmap.c                              |   3 +
 kernel/params.c                                    |  14 +-
 kernel/sched/cpufreq_schedutil.c                   |  15 +-
 kernel/signal.c                                    |   4 +
 kernel/taskstats.c                                 |   3 +-
 kernel/time/itimer.c                               |   2 +-
 kernel/time/timer.c                                |   1 +
 kernel/trace/ring_buffer.c                         | 170 ++++++++++------
 kernel/trace/trace.c                               |   6 +-
 kernel/trace/trace_events.c                        |   2 +
 kernel/trace/trace_events_hist.c                   |   4 +-
 kernel/trace/trace_events_user.c                   |   3 +
 lib/ucs2_string.c                                  |   2 +-
 lib/xarray.c                                       |   3 +
 mm/kasan/quarantine.c                              |   7 +-
 mm/kmemleak.c                                      |  51 +++--
 mm/memcontrol.c                                    |   6 +
 mm/mempolicy.c                                     |  21 +-
 mm/migrate.c                                       |   8 +-
 mm/page_owner.c                                    |  10 +-
 mm/page_vma_mapped.c                               |   8 +-
 mm/vmscan.c                                        |   2 +-
 mm/zsmalloc.c                                      |  11 +-
 mm/zswap.c                                         |  13 +-
 net/bluetooth/eir.c                                |   3 +-
 net/bluetooth/hci_conn.c                           |   3 +-
 net/bluetooth/hci_core.c                           |   2 +-
 net/bluetooth/hci_event.c                          |   7 +-
 net/bluetooth/hci_sync.c                           |   2 +
 net/bluetooth/iso.c                                |   8 +
 net/bluetooth/rfcomm/core.c                        |   8 +-
 net/ceph/osd_client.c                              |  30 +++
 net/ceph/osdmap.c                                  |   2 +
 net/core/skbuff.c                                  |   5 +-
 net/core/xdp.c                                     |   4 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv4/ipip.c                                    |   2 +-
 net/ipv6/ip6_gre.c                                 |  14 +-
 net/ipv6/ip6_tunnel.c                              |  22 +-
 net/ipv6/route.c                                   |   2 +-
 net/ipv6/seg6_local.c                              |   9 +
 net/ipv6/sit.c                                     |   2 +-
 net/iucv/af_iucv.c                                 |   2 +
 net/l2tp/l2tp_netlink.c                            |  16 +-
 net/mpls/af_mpls.c                                 |   2 +
 net/mptcp/syncookies.c                             |   1 +
 net/openvswitch/conntrack.c                        |   8 +-
 net/openvswitch/datapath.c                         |  50 ++---
 net/sched/sch_generic.c                            |   2 +-
 net/sctp/inqueue.c                                 |   7 +-
 net/sctp/sm_sideeffect.c                           |   4 +
 net/sctp/stream.c                                  |  48 +++--
 net/smc/af_smc.c                                   |   3 +-
 net/smc/smc_core.c                                 |  27 +--
 net/smc/smc_rx.c                                   |  11 +-
 net/smc/smc_tx.h                                   |   6 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   6 +-
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  13 +-
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   6 -
 net/sunrpc/auth_gss/gss_rpc_upcall.h               |   1 -
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   6 +
 net/sunrpc/auth_gss/svcauth_gss.c                  |   8 +-
 net/sunrpc/cache.c                                 |   7 +-
 net/sunrpc/sunrpc_syms.c                           |   1 +
 net/sunrpc/svc.c                                   |  74 ++++++-
 net/sunrpc/xdr.c                                   |   2 +-
 net/sunrpc/xprtrdma/ib_client.c                    |  24 ++-
 net/sunrpc/xprtrdma/svc_rdma_rw.c                  |  47 ++++-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c              |  47 +++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  52 +++--
 net/sunrpc/xprtsock.c                              |  12 +-
 net/vmw_vsock/virtio_transport.c                   |   2 +-
 scripts/rust_is_available.sh                       |  14 ++
 scripts/rust_is_available_bindgen_libclang_22.h    |   5 +
 scripts/rust_is_available_test.py                  |  30 ++-
 security/apparmor/include/cred.h                   |   6 +-
 security/apparmor/include/label.h                  |   6 +-
 security/apparmor/include/task.h                   |  15 +-
 security/apparmor/task.c                           |  27 +++
 security/smack/smack_lsm.c                         |   2 +-
 sound/core/ump_convert.c                           |   1 +
 sound/drivers/aloop.c                              |   6 +
 sound/drivers/mpu401/mpu401.c                      |   6 +
 sound/drivers/mts64.c                              |   6 +
 sound/drivers/portman2x4.c                         |   6 +
 sound/drivers/serial-u16550.c                      |   6 +
 sound/drivers/virmidi.c                            |   6 +
 sound/pci/pcxhr/pcxhr.c                            |  14 +-
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/usb/6fire/comm.c                             |   9 +-
 sound/usb/bcd2000/bcd2000.c                        |  11 +-
 tools/include/linux/compiler.h                     |   2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c       |   2 -
 366 files changed, 3709 insertions(+), 1854 deletions(-)


