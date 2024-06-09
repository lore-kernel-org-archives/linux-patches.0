Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009323B79C;
	Sun,  9 Jun 2024 11:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717933296; cv=none; b=Um7TTqeMSuMH8n7qhlIEaBmg2EfcvjTIR9AoT+WQR3JFjKS+LbHwZbmjSPUEnXdBP/fTT9kvWRC1CAkyWXsHKuRx/LEfLXfgwLRhB9sNs4sWK7l3zjc8hWAkh6xl3vWBImusTqqJQtjjxTabMIuR43WbpnqbCq1KAo76FVG8adE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717933296; c=relaxed/simple;
	bh=1X6n9YHDgd98CPB4Wuz9LqizwznO0WD7mNJ60zoiWSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S0bHN+wLANRT62MJQVWnm462uXpkF7KUttu8G8N2spKIf+k8knakgLGqcGDwGwQ4ozFou9LWHPGvXtMPrgMmntgs1srpRWSFHmkeRm7D7nEw1YuKHDisPbGuruVVIZDKhPrNIBAVJOOzxmMeC12rsVD+dxYlR385yVYaaMyCXzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut/CaxDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut/CaxDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FDC2BD10;
	Sun,  9 Jun 2024 11:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717933295;
	bh=1X6n9YHDgd98CPB4Wuz9LqizwznO0WD7mNJ60zoiWSE=;
	h=From:To:Cc:Subject:Date:From;
	b=Ut/CaxDiLUeNFNCbokWzdNrRHIDGJhMoGoSymmjWGfYKEeCly312GIfAMQbadYwPa
	 F8F25iJ2uSxEYdzNfh8tyJ2oak237T1xEV9c1DGKZXHy+QxxuAVODlmaYQ952Bn7bW
	 VUjGrRrd4GQhe2oWIT4ziE+48IYkmAN8GivFfvwU=
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
Subject: [PATCH 6.9 000/368] 6.9.4-rc2 review
Date: Sun,  9 Jun 2024 13:41:29 +0200
Message-ID: <20240609113803.338372290@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.4-rc2
X-KernelTest-Deadline: 2024-06-11T11:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.4 release.
There are 368 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.4-rc2

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel-uncore-freq: Don't present root domain on error

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86/intel/tpmi: Handle error from tpmi_process_info()

Dongli Zhang <dongli.zhang@oracle.com>
    genirq/cpuhotplug, x86/vector: Prevent vector leak during CPU offline

Thomas Gleixner <tglx@linutronix.de>
    x86/topology/intel: Unlock CPUID before evaluating anything

Gerd Hoffmann <kraxel@redhat.com>
    KVM: x86: Don't advertise guest.MAXPHYADDR as host.MAXPHYADDR in CPUID

Bjorn Helgaas <bhelgaas@google.com>
    x86/pci: Skip early E820 check for ECAM region

Thomas Gleixner <tglx@linutronix.de>
    x86/topology: Handle bogus ACPI tables correctly

Hagar Hemdan <hagarhem@amazon.com>
    efi: libstub: only free priv.runtime_map when allocated

Ard Biesheuvel <ardb@kernel.org>
    x86/efistub: Omit physical KASLR when memory reservations exist

Geert Uytterhoeven <geert+renesas@glider.be>
    Revert "drm: Make drivers depends on DRM_DW_HDMI"

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: ump: Fix swapped song position pointer data

Sergey Matyukevich <sergey.matyukevich@syntacore.com>
    riscv: prevent pt_regs corruption for secondary idle threads

Guenter Roeck <linux@roeck-us.net>
    hwmon: (shtc1) Fix property misspelling

Peter Colberg <peter.colberg@intel.com>
    hwmon: (intel-m10-bmc-hwmon) Fix multiplier for N6000 board power sensor

Gerald Loacker <gerald.loacker@wolfvision.net>
    drm/panel: sitronix-st7789v: fix display size for jt240mhqs_hwt_ek_e3 panel

Gerald Loacker <gerald.loacker@wolfvision.net>
    drm/panel: sitronix-st7789v: tweak timing for jt240mhqs_hwt_ek_e3 panel

Gerald Loacker <gerald.loacker@wolfvision.net>
    drm/panel: sitronix-st7789v: fix timing for jt240mhqs_hwt_ek_e3 panel

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/lparcfg: drop error message from guest name lookup

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix yet another spot for system message conversion

Yue Haibing <yuehaibing@huawei.com>
    ipvlan: Dont Use skb->sk in ipvlan_process_v{4,6}_outbound

Shay Agroskin <shayagr@amazon.com>
    net: ena: Fix redundant device NUMA node override

Paul Greenwalt <paul.greenwalt@intel.com>
    ice: fix 200G PHY types to link speed mapping

Tristram Ha <tristram.ha@microchip.com>
    net: dsa: microchip: fix RGMII error in KSZ DSA driver

Alexander Mikhalitsyn <alexander@mihalicyn.com>
    ipv4: correctly iterate over the target netns in inet_dump_ifaddr()

Eric Dumazet <edumazet@google.com>
    net: fix __dst_negative_advice() race

Eric Dumazet <edumazet@google.com>
    inet: introduce dst_rtable() helper

Eric Dumazet <edumazet@google.com>
    ipv6: introduce dst_rt6_info() helper

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Adjust logic in amdgpu_device_partner_bandwidth()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: stm32: Don't warn about spurious interrupts

Miguel Ojeda <ojeda@kernel.org>
    kheaders: use `command -v` to test for existence of `cpio`

Andi Shyti <andi.shyti@linux.intel.com>
    drm/i915/gt: Fix CCS id's calculation for CCS mode setting

Arnd Bergmann <arnd@arndb.de>
    drm/i915/guc: avoid FIELD_PREP warning

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: fix comparison to constant symbols, 'm', 'n'

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: extend minimum interval restriction to entire cycle too

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: make q->picos_per_byte available to fill_sched_entry()

Eric Garver <eric@garver.life>
    netfilter: nft_fib: allow from forward/input without iif selector

Florian Westphal <fw@strlen.de>
    netfilter: tproxy: bail out if IP has been disabled on the device

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: skbuff vlan metadata mangle support

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix start counter for ft1 filter

Christoph Hellwig <hch@lst.de>
    block: stack max_user_sectors

Christoph Hellwig <hch@lst.de>
    sd: also set max_user_sectors when setting max_sectors

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Don't clear bank selection at event -> UMP MIDI2 conversion

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Fix missing bank setup between MIDI1/MIDI2 UMP conversion

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Only use reserved BCS instances for usm migrate exec queue

Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
    drm/xe: Change pcode timeout to 50msec while polling again

Riana Tauro <riana.tauro@intel.com>
    drm/xe: check pcode init status only on root gt of root tile

Rodrigo Vivi <rodrigo.vivi@intel.com>
    drm/xe: Add dbg messages on the suspend resume functions.

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'fail' tests as flaky

Geliang Tang <tanggeliang@kylinos.cn>
    selftests: mptcp: add ms units for tc-netem delay

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: mark 'fastclose' tests as flaky

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: simult flows: mark 'unbalanced' tests as flaky

Jacob Keller <jacob.e.keller@intel.com>
    ice: fix accounting if a VLAN already exists

Alexander Lobakin <aleksander.lobakin@intel.com>
    idpf: don't enable NAPI and interrupts prior to allocating Rx buffers

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: micrel: Fix lan8841_config_intr after getting out of sleep mode

Xiaolei Wang <xiaolei.wang@windriver.com>
    net:fec: Add fec_enet_deinit()

Ido Schimmel <idosch@nvidia.com>
    ipv4: Fix address dump when IPv4 is disabled on an interface

Damien Le Moal <dlemoal@kernel.org>
    null_blk: Fix return value of nullb_device_power_store()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Allow delete from sockmap/sockhash only if update is allowed

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Only restrict 44.1kHz for the ASP

Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
    net: usb: smsc95xx: fix changing LED_SEL bit value updated from EEPROM

Hariprasad Kelam <hkelam@marvell.com>
    Octeontx2-pf: Free send queue buffers incase of leaf to inner

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Read sk->sk_hash under bindlock during bind().

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Annotate data-race around unix_sk(sk)->addr.

Roded Zats <rzats@paloaltonetworks.com>
    enic: Validate length of nl attributes in enic_set_vf_port

Luke D. Jones <luke@ljones.dev>
    ALSA: hda/realtek: Adjust G814JZR to use SPI init for amp

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Remove debugfs at disconnection

Daniel Borkmann <daniel@iogearbox.net>
    netkit: Fix pkt_type override upon netkit pass verdict

Daniel Borkmann <daniel@iogearbox.net>
    netkit: Fix setting mac address in l2 mode

Friedrich Vock <friedrich.vock@gmx.de>
    bpf: Fix potential integer overflow in resolve_btfids

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    dma-buf/sw-sync: don't enable IRQ from sync_print_obj()

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Fix UDP GSO for encapsulated packets

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Use rx_missed_errors instead of rx_dropped for reporting buffer exhaustion

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5e: Fix IPsec tunnel mode offload feature check

Rahul Rameshbabu <rrameshbabu@nvidia.com>
    net/mlx5: Use mlx5_ipsec_rx_status_destroy to correctly delete status rules

Gal Pressman <gal@nvidia.com>
    net/mlx5: Fix MTMP register capability offset in MCAM register

Tariq Toukan <tariqt@nvidia.com>
    net/mlx5: Do not query MPIR on embedded CPU function

Maher Sanalla <msanalla@nvidia.com>
    net/mlx5: Lag, do bond only if slaves agree on roce state

Mathieu Othacehe <m.othacehe@gmail.com>
    net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Enable colorspace property for MST connectors

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix ns enable/disable possible hang

Keith Busch <kbusch@kernel.org>
    nvme-multipath: fix io accounting on failover

Keith Busch <kbusch@kernel.org>
    nvme: fix multipath batched completion accounting

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: handle NUMA_NO_NODE correctly

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: fix node id validation

Fedor Pchelkin <pchelkin@ispras.ru>
    dma-mapping: benchmark: fix up kthread-related error handling

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: stm32: Revert change that enabled controller before asserting CS

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Don't mark message DMA mapped when no transfer in it is

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: restore vlan q-in-q match support

Alexander Maltsev <keltar.gw@gmail.com>
    netfilter: ipset: Add list flush to cancel_gc

Eric Dumazet <edumazet@google.com>
    netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()

Matthew R. Ochs <mochs@nvidia.com>
    tpm_tis_spi: Account for SPI header when allocating TPM SPI xfer buffer

Carlos López <clopez@suse.de>
    tracing/probes: fix error check in parse_btf_field()

David Howells <dhowells@redhat.com>
    cifs: Fix missing set of remote_i_size

David Howells <dhowells@redhat.com>
    cifs: Set zero_point in the copy_file_range() and remap_file_range()

Andrey Konovalov <andreyknvl@gmail.com>
    kasan, fortify: properly rename memintrinsics

David Howells <dhowells@redhat.com>
    netfs: Fix setting of BDP_ASYNC from iocb flags

Yu Kuai <yukuai3@huawei.com>
    null_blk: fix null-ptr-dereference while configuring 'power' and 'submit_queues'

Larysa Zaremba <larysa.zaremba@intel.com>
    idpf: Interpret .set_channels() input differently

Larysa Zaremba <larysa.zaremba@intel.com>
    ice: Interpret .set_channels() input differently

Henry Wang <xin.wang2@amd.com>
    drivers/xen: Improve the late XenStore init protocol

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()

Paolo Abeni <pabeni@redhat.com>
    net: relax socket state check at accept time.

Dae R. Jeong <threeearcat@gmail.com>
    tls: fix missing memory barrier in tls_init

Wei Fang <wei.fang@nxp.com>
    net: fec: avoid lock evasion when reading pps_enable

Jacob Keller <jacob.e.keller@intel.com>
    Revert "ixgbe: Manual AN-37 for troublesome link partners for X550 SFI"

Charlie Jenkins <charlie@rivosinc.com>
    riscv: selftests: Add hwprobe binaries to .gitignore

Matthew Bystrin <dev.mbstr@gmail.com>
    riscv: stacktrace: fixed walk_stackframe()

Frank Li <Frank.Li@nxp.com>
    i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame

Charlie Jenkins <charlie@rivosinc.com>
    riscv: cpufeature: Fix extension subset checking

Charlie Jenkins <charlie@rivosinc.com>
    riscv: cpufeature: Fix thead vector hwcap removal

Jiri Pirko <jiri@resnulli.us>
    virtio: delete vq in vp_find_vqs_msix() when request_irq() fails

David Stevens <stevensd@chromium.org>
    virtio_balloon: Give the balloon its own wakeup source

Horatiu Vultur <horatiu.vultur@microchip.com>
    net: lan966x: Remove ptp traps in case the ptp is not enabled.

Yang Li <yang.lee@linux.alibaba.com>
    rv: Update rv_en(dis)able_monitor doc to match kernel-doc

Jiangfeng Xiao <xiaojiangfeng@huawei.com>
    arm64: asm-bug: Add .align 2 to the end of __BUG_ENTRY

Aaron Conole <aconole@redhat.com>
    openvswitch: Set the skbuff pkt_type for proper pmtud support.

Olga Kornievskaia <kolga@netapp.com>
    pNFS/filelayout: fixup pNfs allocation modes

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix shift-out-of-bounds in dctcp_update_alpha().

Neha Malcom Francis <n-francis@ti.com>
    regulator: tps6594-regulator: Correct multi-phase configuration

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net: use tc rule to filter the na packet

Petr Machata <petrm@nvidia.com>
    selftests: net: Unify code of busywait() and slowwait()

Petr Machata <petrm@nvidia.com>
    selftests: forwarding: Convert log_test() to recognize RET values

Petr Machata <petrm@nvidia.com>
    selftests: forwarding: Have RET track kselftest framework constants

Petr Machata <petrm@nvidia.com>
    selftests: forwarding: Change inappropriate log_test_skip() calls

Hangbin Liu <liuhangbin@gmail.com>
    ipv6: sr: fix memleak in seg6_hmac_init_algo

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Update unix_sk(sk)->oob_skb under sk_receive_queue lock.

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: tps6287x: Force writing VSEL bit

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: pickable ranges: don't always cache vsel

Dan Aloni <dan.aloni@vastdata.com>
    rpcrdma: fix handling for RDMA_CM_EVENT_DEVICE_REMOVAL

Dan Aloni <dan.aloni@vastdata.com>
    sunrpc: fix NFSACL RPC retry on soft mount

Martin Kaiser <martin@kaiser.cx>
    nfs: keep server info for remounts

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Fixup smatch warning for ambiguous return

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Fix wrong loading calibrated data sequence

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2552: Add TX path for capturing AUDIO-OUT data

Ryosuke Yasuoka <ryasuoka@redhat.com>
    nfc: nci: Fix uninit-value in nci_rx_work

Taehee Yoo <ap420073@gmail.com>
    selftests: net: kill smcrouted in the cleanup logic in amt.sh

Andrea Mayer <andrea.mayer@uniroma2.it>
    ipv6: sr: fix missing sk_buff release in seg6_input_core

Florian Fainelli <florian.fainelli@broadcom.com>
    net: Always descend into dsa/ folder with CONFIG_NET_DSA enabled

Masahiro Yamada <masahiroy@kernel.org>
    x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y

Kees Cook <keescook@chromium.org>
    ubsan: Restore dependency on ARCH_HAS_UBSAN

Namhyung Kim <namhyung@kernel.org>
    perf/arm-dmc620: Fix lockdep assert in ->event_init()

Roger Pau Monne <roger.pau@citrix.com>
    xen/x86: add extra pages to unpopulated-alloc if available

Matti Vaittinen <mazziesaccount@gmail.com>
    regulator: bd71828: Don't overwrite runtime voltages

Waiman Long <longman@redhat.com>
    blk-cgroup: Properly propagate the iostat update up the hierarchy

Ming Lei <ming.lei@redhat.com>
    blk-cgroup: fix list corruption from reorder of WRITE ->lqueued

Ming Lei <ming.lei@redhat.com>
    blk-cgroup: fix list corruption from resetting io stat

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()

Iulia Tanasescu <iulia.tanasescu@nxp.com>
    Bluetooth: ISO: Handle PA sync when no BIGInfo reports are generated

Mohamed Ahmed <mohamedahmedegypt2001@gmail.com>
    drm/nouveau: use tile_mode and pte_kind for VM_BIND bo allocations

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Drop doubly quirk entry for 103c:8a2e

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: rt715-sdca-sdw: Fix wrong complete waiting in rt715_dev_resume()

Hsin-Te Yuan <yuanhsinte@chromium.org>
    ASoC: mediatek: mt8192: fix register configuration for tdm

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix lifetime of cs_dsp instance

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: hda_component: Initialize shared data during bind callback

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda/cs_dsp_ctl: Use private_free for control cleanup

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Destroy mpidr_data for 'late' vCPU creation

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    KVM: PPC: Book3S HV nestedv2: Fix an error handling path in gs_msg_ops_kvmhv_nestedv2_config_fill_info()

Vaibhav Jain <vaibhav@linux.ibm.com>
    KVM: PPC: Book3S HV nestedv2: Cancel pending DEC exception

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/bpf/32: Fix failing test_bpf tests

Yoann Congal <yoann.congal@smile.fr>
    printk: Fix LOG_CPU_MAX_BUF_SHIFT when BASE_SMALL is enabled

Zhu Yanjun <yanjun.zhu@linux.dev>
    null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()

Shenghao Ding <shenghao-ding@ti.com>
    ASoC: tas2781: Fix a warning reported by robot kernel test

Konrad Dybcio <konrad.dybcio@linaro.org>
    drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails

Zan Dobersek <zdobersek@igalia.com>
    drm/msm/adreno: fix CP cycles stat retrieval on a7xx

Benjamin Gray <bgray@linux.ibm.com>
    selftests/powerpc/dexcr: Add -no-pie to hashchk tests

Vijendar Mukunda <Vijendar.Mukunda@amd.com>
    ASoC: amd: acp: fix for acp platform device creation failure

Sean Anderson <sean.anderson@linux.dev>
    drm: zynqmp_dpsub: Always register bridge

Luca Ceresoli <luca.ceresoli@bootlin.com>
    Revert "drm/bridge: ti-sn65dsi83: Fix enable error path"

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid confusing "transmit timed out" message

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: core: avoid recursive cec_claim_log_addrs

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-api: add locking in cec_release()

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec: cec-adap: always cancel work in cec_transmit_msg_fh

Randy Dunlap <rdunlap@infradead.org>
    media: sunxi: a83-mips-csi2: also select GENERIC_PHY

Li Zhijian <lizhijian@fujitsu.com>
    cxl/region: Fix cxlr_pmem leaks

Alison Schofield <alison.schofield@intel.com>
    cxl/trace: Correct DPA field masks for general_media & dram events

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the declaration of kasan_map_memory

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for get_thread_reg

Tiwei Bie <tiwei.btw@antgroup.com>
    um: Fix the -Wmissing-prototypes warning for __switch_mm

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: debug: Handle cases when fw_lib_prefix is not set, NULL

Shrikanth Hegde <sshegde@linux.ibm.com>
    powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp

Dongliang Mu <mudongliangabcd@gmail.com>
    media: flexcop-usb: fix sanity check of bNumEndpoints

Hans de Goede <hdegoede@redhat.com>
    platform/x86: thinkpad_acpi: Take hotkey_mutex during hotkey_exit()

David E. Box <david.e.box@linux.intel.com>
    tools/arch/x86/intel_sdsi: Fix meter_certificate decoding

David E. Box <david.e.box@linux.intel.com>
    tools/arch/x86/intel_sdsi: Fix meter_show display

David E. Box <david.e.box@linux.intel.com>
    tools/arch/x86/intel_sdsi: Fix maximum meter bundle length

Eugen Hristev <eugen.hristev@collabora.com>
    media: mediatek: vcodec: fix possible unbalanced PM counter

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix buffer size in gfx_v9_4_3_init_ cp_compute_microcode() and rlc_microcode()

Le Ma <le.ma@amd.com>
    drm/amdgpu: init microcode chip name from ip versions

Marek Szyprowski <m.szyprowski@samsung.com>
    Input: cyapa - add missing input core locking to suspend/resume functions

Kees Cook <keescook@chromium.org>
    string: Prepare to merge strcat KUnit tests into string_kunit.c

Kees Cook <keescook@chromium.org>
    string: Prepare to merge strscpy_kunit.c into string_kunit.c

Ivan Orlov <ivan.orlov0322@gmail.com>
    string_kunit: Add test cases for str*cmp functions

Adam Ford <aford173@gmail.com>
    drm/bridge: imx: Fix unmet depenency for PHY_FSL_SAMSUNG_HDMI_PHY

Maxime Ripard <mripard@kernel.org>
    drm: Make drivers depends on DRM_DW_HDMI

Dan Carpenter <dan.carpenter@linaro.org>
    media: stk1160: fix bounds checking in stk1160_copy_video()

Michael Walle <mwalle@kernel.org>
    drm/bridge: tc358775: fix support for jeida-18 and jeida-24

Aleksandr Mishin <amishin@t-argos.ru>
    drm/msm/dpu: Add callback function pointer check before its call

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use variable length array instead of fixed size

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Use 64 bit variable to avoid 32 bit overflow

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Check 'folio' pointer for NULL

Johannes Berg <johannes.berg@intel.com>
    um: vector: fix bpfflash parameter evaluation

Roberto Sassu <roberto.sassu@huawei.com>
    um: Add winch to winch_handlers before registering winch IRQ

Duoming Zhou <duoming@zju.edu.cn>
    um: Fix return value in ubd_init()

Neil Armstrong <neil.armstrong@linaro.org>
    drm/meson: gate px_clk when setting rate

Wojciech Macek <wmacek@chromium.org>
    drm/mediatek: dp: Fix mtk_dp_aux_transfer return value

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Allow configuring multiple active DSC blocks

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dpu: Always flush the slave INTF on the CTL

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/dsi: Print dual-DSI-adjusted pclk instead of original mode pclk

Fabio Estevam <festevam@denx.de>
    media: ov2680: Do not fail if data-lanes property is absent

Fabio Estevam <festevam@denx.de>
    media: ov2680: Allow probing if link-frequencies is absent

Fabio Estevam <festevam@denx.de>
    media: ov2680: Clear the 'ret' variable on success

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: v4l: Don't turn on privacy LED if streamon fails

Jai Luthra <j-luthra@ti.com>
    media: ti: j721e-csi2rx: Fix races while restarting DMA

Fenglin Wu <quic_fenglinw@quicinc.com>
    Input: pm8xxx-vibrator - correct VIB_MAX_LEVELS calculation

Neil Armstrong <neil.armstrong@linaro.org>
    phy: qcom: qmp-combo: fix sm8650 voltage swing table

Uros Bizjak <ubizjak@gmail.com>
    x86/percpu: Use __force to cast from __percpu address space

Uros Bizjak <ubizjak@gmail.com>
    x86/percpu: Unify arch_raw_cpu_ptr() defines

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Fix ITAPDLY for HS400 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add ITAPDLYSEL in sdhci_j721e_4bit_set_clock

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add OTAP/ITAP delay enable

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Write ITAPDLY for DDR52 timing

Judith Mendez <jm@ti.com>
    mmc: sdhci_am654: Add tuning algorithm for delay chain

Karel Balej <balejk@matfyz.cz>
    Input: ioc3kbd - add device table

Arnd Bergmann <arnd@arndb.de>
    Input: ims-pcu - fix printf string overflow

Devyn Liu <liudingyuan@huawei.com>
    gpiolib: acpi: Fix failed in acpi_gpiochip_find() by adding parent node match

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    mailbox: mtk-cmdq: Fix pm_runtime_get_sync() warning in mbox shutdown

Tao Su <tao1.su@linux.intel.com>
    selftests/harness: use 1024 in place of LINE_MAX

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: correctly use ocfs2_find_next_zero_bit()

Tao Su <tao1.su@linux.intel.com>
    Revert "selftests/harness: remove use of LINE_MAX"

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    dt-bindings: PCI: rockchip,rk3399-pcie: Add missing maxItems to ep-gpios

Sven Schnelle <svens@linux.ibm.com>
    s390/boot: Remove alt_stfle_fac_list from decompressor

Harald Freudenberger <freude@linux.ibm.com>
    s390/ap: Fix bind complete udev event sent after each AP bus scan

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of nvme dump block

Alexander Egorenkov <egorenar@linux.ibm.com>
    s390/ipl: Fix incorrect initialization of len fields in nvme reipl block

Heiko Carstens <hca@linux.ibm.com>
    s390/stackstrace: Detect vdso stack frames

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: Introduce and use struct stack_frame_vdso_wrapper

Heiko Carstens <hca@linux.ibm.com>
    s390/stacktrace: Improve detection of invalid instruction pointers

Heiko Carstens <hca@linux.ibm.com>
    s390/stacktrace: Skip first user stack frame

Heiko Carstens <hca@linux.ibm.com>
    s390/stacktrace: Merge perf_callchain_user() and arch_stack_walk_user()

Sven Schnelle <svens@linux.ibm.com>
    s390/ftrace: Use unwinder instead of __builtin_return_address()

Heiko Carstens <hca@linux.ibm.com>
    s390/vdso: Use standard stack frame layout

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Create .build-id links for unstripped vdso files

Jens Remus <jremus@linux.ibm.com>
    s390/vdso: Generate unwind information for C modules

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Fix callchain parse error with kernel tracepoint events again

Ian Rogers <irogers@google.com>
    perf pmu: Count sys and cpuid JSON events separately

Ian Rogers <irogers@google.com>
    perf pmu: Assume sysfs events are always the same case

Ian Rogers <irogers@google.com>
    perf tools: Add/use PMU reverse lookup from config to name

Ian Rogers <irogers@google.com>
    perf tools: Use pmus to describe type from attribute

Ian Rogers <irogers@google.com>
    perf stat: Don't display metric header for non-leader uncore events

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Fix segfault on sample histogram

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: fotg210: Add missing kernel doc description

Chao Yu <chao@kernel.org>
    f2fs: fix to add missing iput() in gc_data_segment()

Dan Carpenter <dan.carpenter@linaro.org>
    backlight: mp3309c: Fix signedness bug in mp3309c_parse_fwnode()

Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
    perf daemon: Fix file leak in daemon_session__control

Ian Rogers <irogers@google.com>
    libsubcmd: Fix parse-options memory leak

Wolfram Sang <wsa+renesas@sang-engineering.com>
    serial: sh-sci: protect invalidating RXDMA on shutdown

Hou Tao <houtao1@huawei.com>
    fuse: clear FR_SENT when re-adding requests into pending list

Hou Tao <houtao1@huawei.com>
    fuse: set FR_PENDING atomically in fuse_resend()

Chao Yu <chao@kernel.org>
    f2fs: compress: don't allow unaligned truncation on released compress inode

Chao Yu <chao@kernel.org>
    f2fs: fix to release node block count in error path of f2fs_new_node_page()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock

Chao Yu <chao@kernel.org>
    f2fs: compress: fix error path of inc_valid_block_count()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to update i_compr_blocks correctly

James Clark <james.clark@arm.com>
    perf symbols: Fix ownership of string in dso__load_vmlinux()

James Clark <james.clark@arm.com>
    perf symbols: Update kcore map before merging in remaining symbols

James Clark <james.clark@arm.com>
    perf symbols: Remove map from list before updating addresses

James Clark <james.clark@arm.com>
    perf dwarf-aux: Fix build with HAVE_DWARF_CFI_SUPPORT

Namhyung Kim <namhyung@kernel.org>
    perf dwarf-aux: Add die_collect_vars()

Ian Rogers <irogers@google.com>
    perf thread: Fixes to thread__new() related to initializing comm

Ian Rogers <irogers@google.com>
    perf report: Avoid SEGV in report__setup_sample_type()

Ian Rogers <irogers@google.com>
    perf ui browser: Avoid SEGV on title

Wu Bo <bo.wu@vivo.com>
    f2fs: fix block migration when section is not aligned to pow2

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_LOCATE_DSM with PCI Firmware r3.3

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    PCI/EDR: Align EDR_PORT_DPC_ENABLE_DSM with PCI Firmware r3.3

Markus Elfring <elfring@users.sourceforge.net>
    spmi: pmic-arb: Replace three IS_ERR() calls by null pointer checks in spmi_pmic_arb_probe()

Randy Dunlap <rdunlap@infradead.org>
    extcon: max8997: select IRQ_DOMAIN instead of depending on it

Ian Rogers <irogers@google.com>
    perf annotate: Fix memory leak in annotated_source

Ian Rogers <irogers@google.com>
    perf ui browser: Don't save pointer to stack memory

He Zhe <zhe.he@windriver.com>
    perf bench internals inject-build-id: Fix trap divide when collecting just one DSO

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: synquacer: Fix an error handling path in synquacer_i2c_probe()

Sai Pavan Boddu <sai.pavan.boddu@amd.com>
    i2c: cadence: Avoid fifo clear after start

Huai-Yuan Liu <qq810974084@gmail.com>
    ppdev: Add an error check in register_device

Dan Carpenter <dan.carpenter@linaro.org>
    stm class: Fix a double free in stm_register_device()

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Clear uac pointer when freed.

Chris Wulff <Chris.Wulff@biamp.com>
    usb: gadget: u_audio: Fix race condition use of controls after free during gadget unbind.

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Avoid unnecessary destruction of file_ida

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    dt-bindings: phy: qcom,usb-snps-femto-v2: use correct fallback for sc8180x

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: fix msm899[68] power-domains

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    dt-bindings: phy: qcom,sc8280xp-qmp-pcie-phy: fix x1e80100-gen3x2 schema

Chen Ni <nichen@iscas.ac.cn>
    watchdog: sa1100: Fix PTR_ERR_OR_ZERO() vs NULL check in sa1100dog_probe()

Matti Vaittinen <mazziesaccount@gmail.com>
    watchdog: bd9576: Drop "always-running" property

Duoming Zhou <duoming@zju.edu.cn>
    watchdog: cpu5wdt.c: Fix use-after-free bug caused by cpu5wdt_trigger

Marius Cristea <marius.cristea@microchip.com>
    iio: adc: PAC1934: fix accessing out of bounds array index

Danila Tikhonov <danila@jiaxyga.com>
    pinctrl: qcom: pinctrl-sm7150: Fix sdc1 and ufs special pins regs

Rafał Miłecki <rafal@milecki.pl>
    dt-bindings: pinctrl: mediatek: mt7622: fix array properties

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    VMCI: Fix an error handling path in vmci_guest_probe_device()

Duoming Zhou <duoming@zju.edu.cn>
    PCI: of_property: Return error for int_map allocation failure

Miklos Szeredi <mszeredi@redhat.com>
    ovl: remove upper umask handling from ovl_create_upper()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    leds: pwm: Disable PWM when going to suspend

Niklas Neronin <niklas.neronin@linux.intel.com>
    usb: xhci: check if 'requested segments' exceeds ERST capacity

Ramona Gradinariu <ramona.bolboaca13@gmail.com>
    docs: iio: adis16475: fix device files tables

Samuel Holland <samuel.holland@sifive.com>
    riscv: Flush the instruction cache during SMP bringup

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix unassigned instruction op (discovered by MemorySanitizer)

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Wait for Link Training==0 before starting Link retrain

Paul Barker <paul.barker.ct@bp.renesas.com>
    pinctrl: renesas: rzg2l: Limit 2.5V power supply to Ethernet interfaces

Michal Simek <michal.simek@amd.com>
    microblaze: Remove early printk call from cpuinfo-static.c

Michal Simek <michal.simek@amd.com>
    microblaze: Remove gcc flag for non existing early_printk.c file

Matthew Wilcox (Oracle) <willy@infradead.org>
    udf: Convert udf_expand_file_adinicb() to use a folio

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: renesas: r8a779h0: Fix IRQ suffixes

Marco Pagani <marpagan@redhat.com>
    fpga: region: add owner module and take its refcount

Ye Bin <yebin10@huawei.com>
    vfio/pci: fix potential memory leak in vfio_intx_enable()

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix access to resource selector registers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Safe access for TRCQCLTR

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not save/restore Data trace control registers

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Do not hardcode IOMEM access for register restore

Nuno Sa <nuno.sa@analog.com>
    iio: adc: adi-axi-adc: only error out in major version mismatch

Thomas Haemmerle <thomas.haemmerle@leica-geosystems.com>
    iio: pressure: dps310: support negative temperature values

James Clark <james.clark@arm.com>
    perf test shell arm_coresight: Increase buffer size for Coresight basic tests

Ian Rogers <irogers@google.com>
    perf docs: Document bpf event modifier

Namhyung Kim <namhyung@kernel.org>
    perf dwarf-aux: Check pointer offset when checking variables

Anshuman Khandual <anshuman.khandual@arm.com>
    coresight: etm4x: Fix unbalanced pm_runtime_enable()

Hannah Peuckmann <hannah.peuckmann@canonical.com>
    riscv: dts: starfive: visionfive 2: Remove non-existing I2S hardware

Hannah Peuckmann <hannah.peuckmann@canonical.com>
    riscv: dts: starfive: visionfive 2: Remove non-existing TDM hardware

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: stm32: Fixing err code to not indicate success

Daeho Jeong <daehojeong@google.com>
    f2fs: write missing last sum blk of file pinning section

Chao Yu <chao@kernel.org>
    f2fs: fix to check pinfile flag in f2fs_move_file_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to relocate check condition in f2fs_fallocate()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()

Ian Rogers <irogers@google.com>
    perf bench uprobe: Remove lib64 from libc.so.6 binary path

Geert Uytterhoeven <geert+renesas@glider.be>
    dt-bindings: PCI: rcar-pci-host: Add missing IOMMU properties

Adrian Hunter <adrian.hunter@intel.com>
    perf record: Fix debug message placement for test consumption

James Clark <james.clark@arm.com>
    perf map: Remove kernel map before updating start and end addresses

James Clark <james.clark@arm.com>
    perf tests: Apply attributes to all events in object code reading test

James Clark <james.clark@arm.com>
    perf tests: Make "test data symbol" more robust on Neoverse N1

Xianwei Zhao <xianwei.zhao@amlogic.com>
    arm64: dts: meson: fix S4 power-controller node

Konrad Dybcio <konrad.dybcio@linaro.org>
    interconnect: qcom: qcm2290: Fix mas_snoc_bimc QoS port assignment

Arnd Bergmann <arnd@arndb.de>
    module: don't ignore sysfs_create_link() failures

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: sc16is7xx: add proper sched.h include for sched_set_fifo()

Vidya Sagar <vidyas@nvidia.com>
    PCI: tegra194: Fix probe path for Endpoint mode

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    PCI: dwc: ep: Fix DBI access failure for drivers requiring refclk from host

Arnd Bergmann <arnd@arndb.de>
    greybus: arche-ctrl: move device table to its right location

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Fix bitwise types

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Update uart_driver_registered on driver removal

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    serial: max3100: Lock port->lock when calling uart_handle_cts_change()

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Fix annotation_calc_lines() to pass correct address to get_srcline()

Arnd Bergmann <arnd@arndb.de>
    firmware: dmi-id: add a release callback function

Chen Ni <nichen@iscas.ac.cn>
    dmaengine: idma64: Add check for dma_set_max_seg_size

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: fix invalid PDI offset

Thomas Richter <tmricht@linux.ibm.com>
    perf stat: Do not fail on metrics on s390 z/VM systems

Thomas Richter <tmricht@linux.ibm.com>
    perf report: Fix PAI counter names for s390 virtual machines

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: simplify partner's PD caps registration

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: always register a link to USB PD device

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    usb: typec: ucsi: allow non-partner GET_PDOS for Qualcomm devices

Yang Jihong <yangjihong@bytedance.com>
    perf sched timehist: Fix -g/--call-graph option failure

Namhyung Kim <namhyung@kernel.org>
    perf annotate: Get rid of duplicate --group option item

Randy Dunlap <rdunlap@infradead.org>
    counter: linux/counter.h: fix Excess kernel-doc description warning

Marco Pagani <marpagan@redhat.com>
    fpga: bridge: add owner module and take its refcount

Marco Pagani <marpagan@redhat.com>
    fpga: manager: add owner module and take its refcount

Chao Yu <chao@kernel.org>
    f2fs: fix to wait on page writeback in __clone_blkaddrs()

Chao Yu <chao@kernel.org>
    f2fs: multidev: fix to recognize valid zero block address

Tengfei Fan <quic_tengfan@quicinc.com>
    dt-bindings: pinctrl: qcom: update functions to match with driver

Rui Miguel Silva <rmfrfs@gmail.com>
    greybus: lights: check return of get_channel_from_mode

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: core: Leave private pointer NULL when no private data supplied

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf probe: Add missing libgen.h header needed for using basename()

Ian Rogers <irogers@google.com>
    perf test: Use a single fd for the child process out/err

Ian Rogers <irogers@google.com>
    perf record: Delete session after stopping sideband thread

Ethan Adams <j.ethan.adams@gmail.com>
    perf build: Fix out of tree build related to installation of sysreg-defs


-------------

Diffstat:

 .../devicetree/bindings/pci/rcar-pci-host.yaml     |   3 +
 .../bindings/pci/rockchip,rk3399-pcie.yaml         |   1 +
 .../bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml   |   1 -
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |  16 +-
 .../bindings/phy/qcom,usb-snps-femto-v2.yaml       |   4 +-
 .../bindings/pinctrl/mediatek,mt7622-pinctrl.yaml  |  92 ++++-----
 .../bindings/pinctrl/qcom,sm4450-tlmm.yaml         |  52 ++---
 Documentation/driver-api/fpga/fpga-bridge.rst      |   7 +-
 Documentation/driver-api/fpga/fpga-mgr.rst         |  34 ++--
 Documentation/driver-api/fpga/fpga-region.rst      |  13 +-
 Documentation/iio/adis16475.rst                    |   8 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi          |  13 +-
 arch/arm64/include/asm/asm-bug.h                   |   1 +
 arch/arm64/kvm/arm.c                               |  52 ++++-
 arch/loongarch/include/asm/perf_event.h            |   3 +-
 arch/microblaze/kernel/Makefile                    |   1 -
 arch/microblaze/kernel/cpu/cpuinfo-static.c        |   2 +-
 arch/powerpc/include/asm/hvcall.h                  |   2 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   4 +
 arch/powerpc/kvm/book3s_hv.c                       |   2 +-
 arch/powerpc/kvm/book3s_hv_nestedv2.c              |   4 +-
 arch/powerpc/net/bpf_jit_comp32.c                  | 137 +++++++++++---
 arch/powerpc/platforms/pseries/lpar.c              |   6 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |  10 +-
 .../dts/starfive/jh7110-starfive-visionfive-2.dtsi |  98 ----------
 arch/riscv/include/asm/sbi.h                       |   2 +
 arch/riscv/kernel/cpu.c                            |  40 +++-
 arch/riscv/kernel/cpu_ops_sbi.c                    |   2 +-
 arch/riscv/kernel/cpu_ops_spinwait.c               |   3 +-
 arch/riscv/kernel/cpufeature.c                     |  10 +-
 arch/riscv/kernel/smpboot.c                        |   7 +-
 arch/riscv/kernel/stacktrace.c                     |  20 +-
 arch/s390/boot/startup.c                           |   1 -
 arch/s390/include/asm/ftrace.h                     |   8 +-
 arch/s390/include/asm/processor.h                  |   1 +
 arch/s390/include/asm/stacktrace.h                 |  12 ++
 arch/s390/kernel/Makefile                          |   2 +
 arch/s390/kernel/asm-offsets.c                     |   5 +
 arch/s390/kernel/ipl.c                             |  10 +-
 arch/s390/kernel/perf_event.c                      |  34 +---
 arch/s390/kernel/setup.c                           |   2 +-
 arch/s390/kernel/stacktrace.c                      | 108 +++++++++--
 arch/s390/kernel/vdso.c                            |  13 +-
 arch/s390/kernel/vdso32/Makefile                   |   4 +-
 arch/s390/kernel/vdso64/Makefile                   |   4 +-
 arch/s390/kernel/vdso64/vdso_user_wrapper.S        |  19 +-
 arch/um/drivers/line.c                             |  14 +-
 arch/um/drivers/ubd_kern.c                         |   4 +-
 arch/um/drivers/vector_kern.c                      |   2 +-
 arch/um/include/asm/kasan.h                        |   1 -
 arch/um/include/asm/mmu.h                          |   2 -
 arch/um/include/asm/processor-generic.h            |   1 -
 arch/um/include/shared/kern_util.h                 |   2 +
 arch/um/include/shared/skas/mm_id.h                |   2 +
 arch/um/os-Linux/mem.c                             |   1 +
 arch/x86/Kconfig.debug                             |   5 +-
 arch/x86/include/asm/percpu.h                      |  42 ++---
 arch/x86/kernel/apic/vector.c                      |   9 +-
 arch/x86/kernel/cpu/common.c                       |   3 +-
 arch/x86/kernel/cpu/cpu.h                          |   2 +
 arch/x86/kernel/cpu/intel.c                        |  25 ++-
 arch/x86/kernel/cpu/topology.c                     |  55 +++++-
 arch/x86/kvm/cpuid.c                               |  21 +--
 arch/x86/pci/mmconfig-shared.c                     |  40 ++--
 arch/x86/um/shared/sysdep/archsetjmp.h             |   7 +
 arch/x86/xen/enlighten.c                           |  33 ++++
 block/blk-cgroup.c                                 |  87 ++++++---
 block/blk-settings.c                               |   2 +
 drivers/base/base.h                                |   9 +-
 drivers/base/bus.c                                 |   9 +-
 drivers/base/module.c                              |  42 +++--
 drivers/block/null_blk/main.c                      |  42 +++--
 drivers/char/ppdev.c                               |  15 +-
 drivers/char/tpm/tpm_tis_spi_main.c                |   3 +-
 drivers/cxl/core/region.c                          |   1 +
 drivers/cxl/core/trace.h                           |   4 +-
 drivers/dma-buf/sync_debug.c                       |   4 +-
 drivers/dma/idma64.c                               |   4 +-
 drivers/dma/idxd/cdev.c                            |   1 -
 drivers/extcon/Kconfig                             |   3 +-
 drivers/firmware/dmi-id.c                          |   7 +-
 drivers/firmware/efi/libstub/fdt.c                 |   4 +-
 drivers/firmware/efi/libstub/x86-stub.c            |  28 ++-
 drivers/fpga/fpga-bridge.c                         |  57 +++---
 drivers/fpga/fpga-mgr.c                            |  82 ++++----
 drivers/fpga/fpga-region.c                         |  24 ++-
 drivers/gpio/gpiolib-acpi.c                        |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  19 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |   8 +-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |   3 +
 drivers/gpu/drm/bridge/imx/Kconfig                 |   4 +-
 drivers/gpu/drm/bridge/tc358775.c                  |  21 +--
 drivers/gpu/drm/bridge/ti-sn65dsi83.c              |   1 -
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   6 +
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c        |   2 +-
 drivers/gpu/drm/i915/gt/intel_gt_types.h           |   8 +
 drivers/gpu/drm/i915/gt/uc/abi/guc_klvs_abi.h      |   6 +-
 drivers/gpu/drm/mediatek/mtk_dp.c                  |   2 +-
 drivers/gpu/drm/meson/meson_dw_mipi_dsi.c          |   7 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   7 +-
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c   |   3 -
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c         |   9 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_interrupts.c  |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  10 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |   3 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  44 ++---
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c     |  16 +-
 drivers/gpu/drm/xe/xe_device.c                     |  21 ++-
 drivers/gpu/drm/xe/xe_migrate.c                    |  12 +-
 drivers/gpu/drm/xe/xe_pcode.c                      | 117 +++++++-----
 drivers/gpu/drm/xe/xe_pcode.h                      |   6 +-
 drivers/gpu/drm/xe/xe_pm.c                         |  36 ++--
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c                |   7 +-
 drivers/hwmon/intel-m10-bmc-hwmon.c                |   2 +-
 drivers/hwmon/shtc1.c                              |   2 +-
 drivers/hwtracing/coresight/coresight-etm4x-core.c |  29 +--
 drivers/hwtracing/coresight/coresight-etm4x.h      |  31 +--
 drivers/hwtracing/stm/core.c                       |  11 +-
 drivers/i2c/busses/i2c-cadence.c                   |   1 +
 drivers/i2c/busses/i2c-synquacer.c                 |  18 +-
 drivers/i3c/master/svc-i3c-master.c                |   2 +-
 drivers/iio/adc/adi-axi-adc.c                      |   4 +-
 drivers/iio/adc/pac1934.c                          |   9 +
 drivers/iio/adc/stm32-adc.c                        |   1 +
 drivers/iio/industrialio-core.c                    |   6 +-
 drivers/iio/pressure/dps310.c                      |  11 +-
 drivers/infiniband/core/addr.c                     |  12 +-
 drivers/input/misc/ims-pcu.c                       |   4 +-
 drivers/input/misc/pm8xxx-vibrator.c               |   7 +-
 drivers/input/mouse/cyapa.c                        |  12 +-
 drivers/input/serio/ioc3kbd.c                      |   7 +
 drivers/interconnect/qcom/qcm2290.c                |   2 +-
 drivers/leds/leds-pwm.c                            |   8 +-
 drivers/mailbox/mtk-cmdq-mailbox.c                 |   2 +-
 drivers/media/cec/core/cec-adap.c                  |  24 ++-
 drivers/media/cec/core/cec-api.c                   |   5 +-
 drivers/media/i2c/ov2680.c                         |  13 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_pm.c    |   4 +-
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_pm.h    |   2 +-
 .../platform/mediatek/vcodec/encoder/venc_drv_if.c |   5 +-
 .../platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig    |   1 +
 .../media/platform/ti/j721e-csi2rx/j721e-csi2rx.c  |   5 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   2 +-
 drivers/media/usb/stk1160/stk1160-video.c          |  20 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |  22 ++-
 drivers/misc/vmw_vmci/vmci_guest.c                 |  10 +-
 drivers/mmc/host/sdhci_am654.c                     | 168 +++++++++++++----
 drivers/net/Makefile                               |   4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   2 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |  11 --
 drivers/net/ethernet/cisco/enic/enic_main.c        |  12 ++
 drivers/net/ethernet/freescale/fec_main.c          |  10 +
 drivers/net/ethernet/freescale/fec_ptp.c           |  14 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  10 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  19 +-
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c  |  11 +-
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c     |  21 +--
 drivers/net/ethernet/intel/idpf/idpf_lib.c         |   1 +
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |  12 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h        |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |  56 +-----
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c   |   4 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   8 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   3 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/sd.c   |  12 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   2 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   6 +-
 drivers/net/ethernet/ti/icssg/icssg_classifier.c   |   2 +-
 drivers/net/ipvlan/ipvlan_core.c                   |   4 +-
 drivers/net/netkit.c                               |  30 ++-
 drivers/net/phy/micrel.c                           |  11 +-
 drivers/net/usb/smsc95xx.c                         |  11 +-
 drivers/net/vrf.c                                  |   4 +-
 drivers/net/vxlan/vxlan_core.c                     |   2 +-
 drivers/nvme/host/core.c                           |  17 +-
 drivers/nvme/host/multipath.c                      |   3 +-
 drivers/nvme/host/nvme.h                           |   1 +
 drivers/nvme/target/configfs.c                     |   8 +
 drivers/pci/controller/dwc/pcie-designware-ep.c    | 120 +++++++-----
 drivers/pci/controller/dwc/pcie-tegra194.c         |   3 +
 drivers/pci/of_property.c                          |   2 +
 drivers/pci/pci.c                                  |   2 +-
 drivers/pci/pcie/edr.c                             |  28 +--
 drivers/perf/arm_dmc620_pmu.c                      |   9 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          |  54 +++++-
 drivers/pinctrl/qcom/pinctrl-sm7150.c              |  20 +-
 drivers/pinctrl/renesas/pfc-r8a779h0.c             |  24 +--
 drivers/pinctrl/renesas/pinctrl-rzg2l.c            |   2 +
 drivers/platform/x86/intel/tpmi.c                  |   7 +-
 .../intel/uncore-frequency/uncore-frequency-tpmi.c |   7 +
 drivers/platform/x86/thinkpad_acpi.c               |   5 +-
 drivers/regulator/bd71828-regulator.c              |  58 +-----
 drivers/regulator/helpers.c                        |  43 +++--
 drivers/regulator/tps6287x-regulator.c             |   1 +
 drivers/regulator/tps6594-regulator.c              |  16 +-
 drivers/s390/crypto/ap_bus.c                       |   8 +-
 drivers/s390/net/qeth_core.h                       |   9 +-
 drivers/scsi/sd.c                                  |   4 +-
 drivers/soundwire/cadence_master.c                 |   2 +-
 drivers/spi/spi-stm32.c                            |  16 +-
 drivers/spi/spi.c                                  |   4 +
 drivers/spmi/spmi-pmic-arb.c                       |  12 +-
 drivers/staging/greybus/arche-apb-ctrl.c           |   1 +
 drivers/staging/greybus/arche-platform.c           |   9 +-
 drivers/staging/greybus/light.c                    |   8 +-
 drivers/tty/serial/max3100.c                       |  22 ++-
 drivers/tty/serial/sc16is7xx.c                     |   2 +-
 drivers/tty/serial/sh-sci.c                        |   5 +
 drivers/usb/fotg210/fotg210-core.c                 |   1 +
 drivers/usb/gadget/function/u_audio.c              |  21 ++-
 drivers/usb/host/xhci-mem.c                        |  22 +--
 drivers/usb/host/xhci.h                            |   6 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  21 +--
 drivers/vfio/pci/vfio_pci_intrs.c                  |   4 +-
 drivers/video/backlight/mp3309c.c                  |   3 +-
 drivers/virtio/virtio_balloon.c                    |  13 +-
 drivers/virtio/virtio_pci_common.c                 |   4 +-
 drivers/watchdog/bd9576_wdt.c                      |  12 +-
 drivers/watchdog/cpu5wdt.c                         |   2 +-
 drivers/watchdog/sa1100_wdt.c                      |   5 +-
 drivers/xen/xenbus/xenbus_probe.c                  |  36 ++--
 fs/f2fs/data.c                                     |  19 +-
 fs/f2fs/f2fs.h                                     |  15 +-
 fs/f2fs/file.c                                     |  92 +++++----
 fs/f2fs/gc.c                                       |   9 +-
 fs/f2fs/node.c                                     |   2 +-
 fs/f2fs/segment.c                                  |   2 +
 fs/fuse/dev.c                                      |   3 +-
 fs/netfs/buffered_write.c                          |   2 +-
 fs/nfs/filelayout/filelayout.c                     |   4 +-
 fs/nfs/fs_context.c                                |   9 +-
 fs/nfs/nfs4state.c                                 |  12 +-
 fs/ntfs3/fslog.c                                   |   3 +-
 fs/ntfs3/inode.c                                   |  17 +-
 fs/ntfs3/ntfs.h                                    |   2 +-
 fs/ocfs2/localalloc.c                              |  19 +-
 fs/ocfs2/reservations.c                            |   2 +-
 fs/ocfs2/suballoc.c                                |   6 +-
 fs/overlayfs/dir.c                                 |   3 -
 fs/smb/client/cifsfs.c                             |  12 +-
 fs/smb/client/smb2ops.c                            |   1 +
 fs/udf/inode.c                                     |  27 +--
 include/linux/counter.h                            |   1 -
 include/linux/etherdevice.h                        |   8 +
 include/linux/fortify-string.h                     |  22 ++-
 include/linux/fpga/fpga-bridge.h                   |  10 +-
 include/linux/fpga/fpga-mgr.h                      |  26 ++-
 include/linux/fpga/fpga-region.h                   |  13 +-
 include/linux/mlx5/mlx5_ifc.h                      |   4 +-
 include/linux/regulator/driver.h                   |   3 +
 include/linux/skbuff.h                             |   9 -
 include/media/cec.h                                |   1 +
 include/net/bluetooth/hci_core.h                   |   3 +-
 include/net/dst_ops.h                              |   2 +-
 include/net/ip.h                                   |   4 +-
 include/net/ip6_fib.h                              |   6 +-
 include/net/ip6_route.h                            |  11 +-
 include/net/route.h                                |  11 ++
 include/net/sock.h                                 |  13 +-
 include/sound/tas2781-dsp.h                        |   7 +-
 include/uapi/drm/nouveau_drm.h                     |   7 +
 init/Kconfig                                       |   4 +-
 kernel/bpf/verifier.c                              |  10 +-
 kernel/dma/map_benchmark.c                         |  22 ++-
 kernel/gen_kheaders.sh                             |   7 +-
 kernel/irq/cpuhotplug.c                            |  16 +-
 kernel/trace/rv/rv.c                               |   2 +
 kernel/trace/trace_probe.c                         |   4 +
 lib/Kconfig.ubsan                                  |   1 +
 lib/strcat_kunit.c                                 |  12 +-
 lib/string_kunit.c                                 | 155 +++++++++++++++
 lib/strscpy_kunit.c                                |  51 ++---
 net/atm/clip.c                                     |   2 +-
 net/bluetooth/6lowpan.c                            |   2 +-
 net/bluetooth/hci_event.c                          |  60 +++---
 net/bluetooth/iso.c                                |  94 ++++-----
 net/core/dst_cache.c                               |   4 +-
 net/core/filter.c                                  |   5 +-
 net/ethernet/eth.c                                 |   4 +-
 net/ipv4/af_inet.c                                 |   6 +-
 net/ipv4/devinet.c                                 |   7 +-
 net/ipv4/icmp.c                                    |  26 +--
 net/ipv4/ip_input.c                                |   2 +-
 net/ipv4/ip_output.c                               |   8 +-
 net/ipv4/ip_tunnel.c                               |   2 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +
 net/ipv4/route.c                                   |  46 ++---
 net/ipv4/tcp_dctcp.c                               |  13 +-
 net/ipv4/udp.c                                     |   2 +-
 net/ipv4/xfrm4_policy.c                            |   2 +-
 net/ipv6/icmp.c                                    |   8 +-
 net/ipv6/ila/ila_lwt.c                             |   4 +-
 net/ipv6/ip6_output.c                              |  18 +-
 net/ipv6/ip6mr.c                                   |   2 +-
 net/ipv6/ndisc.c                                   |   2 +-
 net/ipv6/ping.c                                    |   2 +-
 net/ipv6/raw.c                                     |   4 +-
 net/ipv6/route.c                                   |  57 +++---
 net/ipv6/seg6_hmac.c                               |  42 +++--
 net/ipv6/seg6_iptunnel.c                           |  11 +-
 net/ipv6/tcp_ipv6.c                                |   4 +-
 net/ipv6/udp.c                                     |  11 +-
 net/ipv6/xfrm6_policy.c                            |   2 +-
 net/l2tp/l2tp_ip.c                                 |   2 +-
 net/l2tp/l2tp_ip6.c                                |   2 +-
 net/mpls/mpls_iptunnel.c                           |   4 +-
 net/netfilter/ipset/ip_set_list_set.c              |   3 +
 net/netfilter/ipvs/ip_vs_xmit.c                    |  16 +-
 net/netfilter/nf_flow_table_core.c                 |   8 +-
 net/netfilter/nf_flow_table_ip.c                   |   8 +-
 net/netfilter/nfnetlink_queue.c                    |   2 +
 net/netfilter/nft_fib.c                            |   8 +-
 net/netfilter/nft_payload.c                        |  95 +++++++---
 net/netfilter/nft_rt.c                             |   4 +-
 net/nfc/nci/core.c                                 |  18 +-
 net/openvswitch/actions.c                          |   6 +
 net/sched/sch_taprio.c                             |  14 +-
 net/sctp/ipv6.c                                    |   2 +-
 net/sctp/protocol.c                                |   4 +-
 net/sunrpc/clnt.c                                  |   1 +
 net/sunrpc/xprtrdma/verbs.c                        |   6 +-
 net/tipc/udp_media.c                               |   2 +-
 net/tls/tls_main.c                                 |  10 +-
 net/unix/af_unix.c                                 |  47 +++--
 net/xfrm/xfrm_policy.c                             |  14 +-
 scripts/Makefile.vdsoinst                          |   2 +-
 scripts/kconfig/symbol.c                           |   6 +-
 sound/core/init.c                                  |   9 +-
 sound/core/jack.c                                  |  21 ++-
 sound/core/seq/seq_ump_convert.c                   |  46 ++++-
 sound/pci/hda/cs35l56_hda.c                        |   8 +-
 sound/pci/hda/hda_component.c                      |  16 +-
 sound/pci/hda/hda_component.h                      |   7 +-
 sound/pci/hda/hda_cs_dsp_ctl.c                     |  47 +++--
 sound/pci/hda/patch_realtek.c                      |   5 +-
 sound/soc/amd/acp/acp-legacy-common.c              |  98 ++++++++--
 sound/soc/amd/acp/acp-pci.c                        |   9 +-
 sound/soc/amd/acp/amd.h                            |  10 +-
 sound/soc/amd/acp/chip_offset_byte.h               |   1 +
 sound/soc/codecs/cs42l43.c                         |   5 +-
 sound/soc/codecs/rt715-sdca-sdw.c                  |   4 +-
 sound/soc/codecs/tas2552.c                         |  15 +-
 sound/soc/codecs/tas2781-fmwlib.c                  | 109 +++--------
 sound/soc/codecs/tas2781-i2c.c                     |   4 +-
 sound/soc/mediatek/mt8192/mt8192-dai-tdm.c         |   4 +-
 sound/soc/sof/debug.c                              |  23 ++-
 tools/arch/x86/intel_sdsi/intel_sdsi.c             |  48 +++--
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/lib/subcmd/parse-options.c                   |   8 +-
 tools/perf/Documentation/perf-list.txt             |   1 +
 tools/perf/Makefile.perf                           |   7 +-
 tools/perf/bench/inject-buildid.c                  |   2 +-
 tools/perf/bench/uprobe.c                          |   2 +-
 tools/perf/builtin-annotate.c                      |   2 -
 tools/perf/builtin-daemon.c                        |   4 +-
 tools/perf/builtin-record.c                        |   8 +-
 tools/perf/builtin-report.c                        |   2 +-
 tools/perf/builtin-sched.c                         |   7 +-
 .../pmu-events/arch/s390/cf_z16/transaction.json   |  28 +--
 tools/perf/pmu-events/arch/s390/mapfile.csv        |   2 +-
 tools/perf/tests/builtin-test.c                    |  37 +---
 tools/perf/tests/code-reading.c                    |  10 +-
 tools/perf/tests/shell/test_arm_coresight.sh       |   2 +-
 tools/perf/tests/workloads/datasym.c               |  16 ++
 tools/perf/ui/browser.c                            |   6 +-
 tools/perf/ui/browser.h                            |   2 +-
 tools/perf/util/annotate.c                         |  19 +-
 tools/perf/util/dwarf-aux.c                        | 210 ++++++++++++++-------
 tools/perf/util/dwarf-aux.h                        |  17 ++
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   2 +
 tools/perf/util/intel-pt.c                         |   2 +
 tools/perf/util/machine.c                          |   2 +-
 tools/perf/util/perf_event_attr_fprintf.c          |  26 ++-
 tools/perf/util/pmu.c                              | 119 +++++++++---
 tools/perf/util/pmu.h                              |   7 +-
 tools/perf/util/probe-event.c                      |   1 +
 tools/perf/util/python.c                           |  10 +
 tools/perf/util/stat-display.c                     |   3 +
 tools/perf/util/symbol.c                           |  49 +++--
 tools/perf/util/thread.c                           |  14 +-
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh       |   2 +-
 .../drivers/net/mlxsw/spectrum-2/resource_scale.sh |   1 -
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |   1 -
 tools/testing/selftests/kselftest_harness.h        |  11 +-
 tools/testing/selftests/mm/mdwe_test.c             |   1 -
 tools/testing/selftests/net/amt.sh                 |   8 +-
 .../selftests/net/arp_ndisc_untracked_subnets.sh   |  53 ++----
 .../selftests/net/forwarding/ethtool_rmon.sh       |   4 +-
 tools/testing/selftests/net/forwarding/lib.sh      | 186 +++++++++---------
 .../net/forwarding/router_mpath_nh_lib.sh          |   2 +-
 tools/testing/selftests/net/lib.sh                 | 113 ++++++++++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  16 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  10 +-
 tools/testing/selftests/powerpc/dexcr/Makefile     |   2 +-
 tools/testing/selftests/riscv/hwprobe/.gitignore   |   2 +
 .../tc-testing/tc-tests/qdiscs/taprio.json         |  44 +++++
 402 files changed, 4033 insertions(+), 2429 deletions(-)


