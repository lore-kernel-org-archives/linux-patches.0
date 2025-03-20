Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6FE1E25EB;
	Thu, 20 Mar 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489952; cv=none; b=NCMHuYurisF6bS+quS+4023DFs3DCm90xyZSRFbmCe/ajNd3IA/JWc1W2j8aNC7rhc2NDQWX/L2+niAycPfpyF+PJW5SKEG0afG5IcbsZ8WIsV/TzfsOhF+oMxBaSrSP2rLG69JoMKOX0JFMayZKc7He8h8phtdPeQ7kiqNZ1yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489952; c=relaxed/simple;
	bh=tOpIOnM/l5Vi9cJESKSgaDYJzJWQYhO6H23DXwwl3Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QidHR1Q5IBoNZa75cG2PGIC99KzwdVYMXii60aZS5/ok0sShiuIX6jFo4iOaE6mmGbm/nMOdfYhkTfrh/p2/CKaUfHNsxmT5+hbS9m0eKo6Wex9+QXJM8e7OXHEpN1+u82edpj8LpeW1XdBW+d6t58QAtc6YwFO2TZHCLJim/cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVXjlEyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVXjlEyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54FEC4CEDD;
	Thu, 20 Mar 2025 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742489952;
	bh=tOpIOnM/l5Vi9cJESKSgaDYJzJWQYhO6H23DXwwl3Ug=;
	h=From:To:Cc:Subject:Date:From;
	b=RVXjlEygMcABK7NORoKPVVIx/4bxHiKPDeXKmJnp0hr433WP+IFJI5bE8Tb+/x1sR
	 x8oXTqYq+tRi6oHanJy/qYoc4owMJ6YDgrgtSHLcLErzkzoDcHTAFnnMrU/IlK2J5o
	 4aKWMBLhBCQedKRuJ3EvHag+/VHEd3AkL0l9f1pQ=
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
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 6.6 000/166] 6.6.84-rc2 review
Date: Thu, 20 Mar 2025 09:57:50 -0700
Message-ID: <20250320165654.807128435@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.84-rc2
X-KernelTest-Deadline: 2025-03-22T16:56+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.84 release.
There are 166 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Mar 2025 16:56:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.84-rc2

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: allow clone callbacks to sleep

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bail out if stateful expression provides no .clone

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: use timestamp to check for set element timeout

Mitchell Levy <levymitchell0@gmail.com>
    rust: lockdep: Remove support for dynamically allocated LockClassKeys

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: Fix a C2HTermReq error message

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: disable Fn key handling on the Omoton KB066

Daniel Wagner <wagi@kernel.org>
    nvme-fc: rely on state transitions to handle connectivity loss

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix corrupted list in hci_chan_del

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: Fix match_session bug preventing session reuse

Steve French <stfrench@microsoft.com>
    smb3: add support for IAKerb

Philipp Stanner <phasta@kernel.org>
    stmmac: loongson: Pass correct arg to PCI function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: sis630: Fix an error handling path in sis630_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali15x3: Fix an error handling path in ali15x3_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    i2c: ali1535: Fix an error handling path in ali1535_probe()

Pali Rohár <pali@kernel.org>
    cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()

Pali Rohár <pali@kernel.org>
    cifs: Validate content of WSL reparse point buffers

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing closetimeo mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing actimeo mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing acdirmax mount option

Murad Masimov <m.masimov@mt-integration.ru>
    cifs: Fix integer overflow while processing acregmax mount option

Tamir Duberstein <tamird@gmail.com>
    scripts: generate_rust_analyzer: add missing macros deps

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: codecs: wm0010: Fix error handling path in wm0010_spi_probe()

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: rt722-sdca: add missing readable registers

Alban Kurti <kurti@invicto.ai>
    rust: init: add missing newline to pr_info! calls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: cs42l43: Fix maximum ADC Volume

Ivan Abramov <i.abramov@mt-integration.ru>
    drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()

Alban Kurti <kurti@invicto.ai>
    rust: error: add missing newline to pr_warn! calls

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: ops: Consistently treat platform_max as control value

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    mm: split critical region in remap_file_pages() and invoke LSMs in between

Andrii Nakryiko <andrii@kernel.org>
    lib/buildid: Handle memfd_secret() files in build_id_parse()

Benno Lossin <benno.lossin@proton.me>
    rust: init: fix `Zeroable` implementation for `Option<NonNull<T>>` and `Option<KBox<T>>`

Matthew Maurer <mmaurer@google.com>
    rust: Disallow BTF generation with Rust + LTO

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix regression with guest option

Haoxiang Li <haoxiang_li2024@163.com>
    qlcnic: fix memory leak issues in qlcnic_sriov_common.c

Zhenhua Huang <quic_zhenhuah@quicinc.com>
    arm64: mm: Populate vmemmap at the page level if not section aligned

Kent Overstreet <kent.overstreet@linux.dev>
    dm-flakey: Fix memory corruption in optional corrupt_bio_byte feature

Thomas Mizrahi <thomasmizra@gmail.com>
    ASoC: amd: yc: Support mic on another Lenovo ThinkPad E16 Gen 2 model

Varada Pavani <v.pavani@samsung.com>
    clk: samsung: update PLL locktime for PLL142XX used on FSD platform

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: prevent connection release during oplock break notification

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix use-after-free in ksmbd_free_work_struct

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Fix slab-use-after-free on hdcp_work

Alex Hung <alex.hung@amd.com>
    drm/amd/display: Assign normalized_pix_clk when color depth = 14

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd/display: Restore correct backlight brightness after a GPU reset

Leo Li <sunpeng.li@amd.com>
    drm/amd/display: Disable unneeded hpd interrupts during dm_init

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix locking when skipping CSN before topology probing

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/atomic: Filter out redundant DPMS calls

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/cdclk: Do cdclk post plane programming later

Florent Revest <revest@chromium.org>
    x86/microcode/AMD: Fix out-of-bounds on systems with CPU-less NUMA nodes

Johan Hovold <johan@kernel.org>
    USB: serial: option: match on interface class for Telit FN990B

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: fix Telit Cinterion FE990A name

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE990B compositions

Boon Khai Ng <boon.khai.ng@intel.com>
    USB: serial: ftdi_sio: add support for Altera USB Blaster 3

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for more devices

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for several devices

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - add required quirks for missing old boardnames

Werner Sembach <wse@tuxedocomputers.com>
    Input: i8042 - swap old quirk combination with new quirk for NHxxRZQ

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - rename QH controller to Legion Go S

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - add support for TECNO Pocket Go

Antheas Kapenekakis <lkml@antheas.dev>
    Input: xpad - add support for ZOTAC Gaming Zone

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add multiple supported devices

Nilton Perim Neto <niltonperimneto@gmail.com>
    Input: xpad - add 8BitDo SN30 Pro, Hyperkin X91 and Gamesir G7 SE controllers

Jeff LaBundy <jeff@labundy.com>
    Input: iqs7222 - preserve system status register

H. Nikolaus Schaller <hns@goldelico.com>
    Input: ads7846 - fix gpiod allocation

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix error pbuf checking

Jens Axboe <axboe@kernel.dk>
    io_uring: use unpin_user_pages() where appropriate

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring

Jens Axboe <axboe@kernel.dk>
    io_uring/kbuf: vmap pinned buffer ring

Jens Axboe <axboe@kernel.dk>
    io_uring: unify io_pin_pages()

Jens Axboe <axboe@kernel.dk>
    io_uring: use vmap() for ring mapping

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix corner case forgetting to vunmap

Jens Axboe <axboe@kernel.dk>
    io_uring: don't attempt to mmap larger than what the user asks for

Jens Axboe <axboe@kernel.dk>
    io_uring: get rid of remap_pfn_range() for mapping rings/sqes

Jens Axboe <axboe@kernel.dk>
    mm: add nommu variant of vm_insert_pages()

Ming Lei <ming.lei@redhat.com>
    block: fix 'kmem_cache of name 'bio-108' already exists'

Frederic Weisbecker <frederic@kernel.org>
    net: Handle napi_schedule() calls from non-interrupt

Thomas Zimmermann <tzimmermann@suse.de>
    drm/nouveau: Do not override forced connector status

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: safety check before fallback

Arnd Bergmann <arnd@arndb.de>
    x86/irq: Define trace events conditionally

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Use better start period for frequency mode

Harry Wentland <harry.wentland@amd.com>
    drm/vkms: Round fixp2int conversion in lerp_u16

Miklos Szeredi <mszeredi@redhat.com>
    fuse: don't truncate cached, mutated symlink

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Set the SDOUT polarity correctly

Hector Martin <marcan@marcan.st>
    ASoC: tas2764: Fix power control mask

Hector Martin <marcan@marcan.st>
    ASoC: tas2770: Fix volume scale

Daniel Wagner <wagi@kernel.org>
    nvme: only allow entering LIVE from CONNECTING state

Yu-Chun Lin <eleanor15x@gmail.com>
    sctp: Fix undefined behavior in left shift operation

Pali Rohár <pali@kernel.org>
    cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes

Hector Martin <marcan@marcan.st>
    apple-nvme: Release power domains when probe fails

Ruozhu Li <david.li@jaguarmicro.com>
    nvmet-rdma: recheck queue state is LIVE in state lock in recv done

Maurizio Lombardi <mlombard@redhat.com>
    nvme-tcp: add basic support for the C2HTermReq PDU

Christopher Lentocha <christopherericlentocha@gmail.com>
    nvme-pci: quirk Acer FA100 for non-uniqueue identifiers

Uday Shankar <ushankar@purestorage.com>
    io-wq: backoff when retrying worker creation

Stephan Gerhold <stephan.gerhold@linaro.org>
    net: wwan: mhi_wwan_mbim: Silence sequence number glitch errors

Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
    ASoC: SOF: amd: Handle IPC replies before FW_BOOT_COMPLETE

Terry Cheong <htcheong@chromium.org>
    ASoC: SOF: Intel: hda: add softdep pre to snd-hda-codec-hdmi module

Vitaly Rodionov <vitalyr@opensource.cirrus.com>
    ASoC: arizona/madera: use fsleep() in up/down DAPM event delays.

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: adjust convert rate limitation

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: don't indicate warning on rsnd_kctrl_accept_runtime()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: rsnd: indicate unsupported clock rate

Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
    ALSA: hda/realtek: Limit mic boost on Positivo ARN50

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: simple-card-utils.c: add missing dlc->of_node

Jiayuan Chen <mrpre@163.com>
    selftests/bpf: Fix invalid flag of recv()

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix slab-use-after-free Read in l2cap_send_cmd

Jan Beulich <jbeulich@suse.com>
    Xen/swiotlb: mark xen_swiotlb_fixup() __init

Daniel Lezcano <daniel.lezcano@linaro.org>
    thermal/cpufreq_cooling: Remove structure member documentation

Peter Oberparleiter <oberpar@linux.ibm.com>
    s390/cio: Fix CHPID "configure" attribute caching

Mark Pearson <mpearson-lenovo@squebb.ca>
    platform/x86: thinkpad_acpi: Support for V9 DYTC platform profiles

Sybil Isabel Dorsett <sybdorsett@proton.me>
    platform/x86: thinkpad_acpi: Fix invalid fan speed on ThinkPad X120e

Jann Horn <jannh@google.com>
    sched: Clarify wake_up_q()'s write to task->wake_q.next

Josh Poimboeuf <jpoimboe@kernel.org>
    objtool: Ignore dangling jump table entries

Alex Henrie <alexhenrie24@gmail.com>
    HID: apple: fix up the F6 key on the Omoton KB066 keyboard

Ievgen Vovk <YevgenVovk@ukr.net>
    HID: hid-apple: Apple Magic Keyboard a3203 USB-C support

Daniel Brackenbury <daniel.brackenbury@gmail.com>
    HID: topre: Fix n-key rollover on Realforce R3S TKL boards

Alexander Stein <alexander.stein@ew.tq-group.com>
    usb: phy: generic: Use proper helper for property detection

Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
    HID: ignore non-functional sensor in HP 5MP Camera

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Send clock sync message immediately after reset

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: fix the length of MNG_SYNC_FW_CLOCK in doorbell

Brahmajit Das <brahmajit.xyz@gmail.com>
    vboxsf: fix building with GCC 15

Eric W. Biederman <ebiederm@xmission.com>
    alpha/elf: Fix misc/setarch test of util-linux by removing 32bit support

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix noisy when tree connecting to DFS interlink targets

Gannon Kolding <gannon.kolding@gmail.com>
    ACPI: resource: IRQ override for Eluktronics MECH-17

Magnus Lindholm <linmag7@gmail.com>
    scsi: qla1280: Fix kernel oops when debug level > 2

Seunghui Lee <sh043.lee@samsung.com>
    scsi: ufs: core: Fix error return with query response

Rik van Riel <riel@surriel.com>
    scsi: core: Use GFP_NOIO to avoid circular locking dependency

Dmitry Kandybka <d.kandybka@gmail.com>
    platform/x86/intel: pmc: fix ltr decode in pmc_core_ltr_show()

Christian Loehle <christian.loehle@arm.com>
    sched/debug: Provide slice length for fair tasks

Chengen Du <chengen.du@canonical.com>
    iscsi_ibft: Fix UBSAN shift-out-of-bounds warning in ibft_attr_show_nic()

Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
    powercap: call put_device() on an error path in powercap_register_control_type()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    hrtimers: Mark is_migration_base() with __always_inline

Daniel Wagner <wagi@kernel.org>
    nvme-fc: do not ignore connectivity loss during connecting

Daniel Wagner <wagi@kernel.org>
    nvme-fc: go straight to connecting state when initializing

Carolina Jubran <cjubran@nvidia.com>
    net/mlx5e: Prevent bridge link show failure for non-eswitch-allowed devices

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5: Bridge, fix the crash caused by LAG state check

Shay Drory <shayd@nvidia.com>
    net/mlx5: Lag, Check shared fdb before creating MultiPort E-Switch

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: remove misbehaving actions length check

Guillaume Nault <gnault@redhat.com>
    gre: Fix IPv6 link-local address generation.

Alexey Kashavkin <akashavkin@gmail.com>
    netfilter: nft_exthdr: fix offset with ipv4_find_option()

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: Prevent creation of classes with TC_H_ROOT

Dan Carpenter <dan.carpenter@linaro.org>
    ipvs: prevent integer overflow in do_ip_vs_get_ctl()

Kohei Enju <enjuk@amazon.com>
    netfilter: nf_conncount: Fully initialize struct nf_conncount_tuple in insert_tree()

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix incorrect MAC address setting to receive NS messages

Amit Cohen <amcohen@nvidia.com>
    net: switchdev: Convert blocking notification chain to a raw one

Taehee Yoo <ap420073@gmail.com>
    eth: bnxt: do not update checksum in bnxt_xdp_build_skb()

Wentao Liang <vulab@iscas.ac.cn>
    net/mlx5: handle errors in mlx5_chains_create_table()

Michael Kelley <mhklinux@outlook.com>
    Drivers: hv: vmbus: Don't release fb_mmio resource in vmbus_free_mmio()

Michael Kelley <mhklinux@outlook.com>
    drm/hyperv: Fix address space leak when Hyper-V DRM device is removed

Breno Leitao <leitao@debian.org>
    netpoll: hold rcu read lock in __netpoll_send_skb()

Matt Johnston <matt@codeconstruct.com.au>
    net: mctp i2c: Copy headers if cloned

Joseph Huang <Joseph.Huang@garmin.com>
    net: dsa: mv88e6xxx: Verify after ATU Load ops

Jiri Pirko <jiri@resnulli.us>
    net/mlx5: Fill out devlink dev info only for PFs

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Revert "Bluetooth: hci_core: Fix sleeping function called from invalid context"

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_event: Fix enabling passive scanning

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: cfg80211: cancel wiphy_work before freeing wiphy

Jun Yang <juny24602@gmail.com>
    sched: address a potential NULL pointer dereference in the GRED scheduler.

Nicklas Bo Jensen <njensen@akamai.com>
    netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around

Grzegorz Nitka <grzegorz.nitka@intel.com>
    ice: fix memory leak in aRFS after reset

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.

Artur Weber <aweber.kernel@gmail.com>
    pinctrl: bcm281xx: Fix incorrect regmap max_registers value

Michael Kelley <mhklinux@outlook.com>
    fbdev: hyperv_fb: iounmap() the correct memory when removing a device

Xueming Feng <kuro@kuroa.me>
    tcp: fix forever orphan socket caused by tcp_abort

Eric Dumazet <edumazet@google.com>
    tcp: fix races in tcp_abort()

Wander Lairson Costa <wander.lairson@gmail.com>
    bpf: Use raw_spinlock_t in ringbuf

Felix Moessbauer <felix.moessbauer@siemens.com>
    hrtimer: Use and report correct timerslack values for realtime tasks

Liu Shixin <liushixin2@huawei.com>
    zram: fix NULL pointer in comp_algorithm_show()

Oleg Nesterov <oleg@redhat.com>
    sched/isolation: Prevent boot crash when the boot CPU is nohz_full

David Woodhouse <dwmw@amazon.co.uk>
    clockevents/drivers/i8253: Fix stop sequence for timer 0


-------------

Diffstat:

 Documentation/timers/no_hz.rst                     |   7 +-
 Makefile                                           |   4 +-
 arch/alpha/include/asm/elf.h                       |   6 +-
 arch/alpha/include/asm/pgtable.h                   |   2 +-
 arch/alpha/include/asm/processor.h                 |   8 +-
 arch/alpha/kernel/osf_sys.c                        |  11 +-
 arch/arm64/mm/mmu.c                                |   5 +-
 arch/x86/events/intel/core.c                       |  85 +++++++
 arch/x86/kernel/cpu/microcode/amd.c                |   2 +-
 arch/x86/kernel/cpu/mshyperv.c                     |  11 -
 arch/x86/kernel/irq.c                              |   2 +
 block/bio.c                                        |   2 +-
 drivers/acpi/resource.c                            |   6 +
 drivers/block/zram/zram_drv.c                      |   4 +-
 drivers/clk/samsung/clk-pll.c                      |   7 +-
 drivers/clocksource/i8253.c                        |  36 ++-
 drivers/firmware/iscsi_ibft.c                      |   5 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  10 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |   1 +
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  |  64 ++++--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   7 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |  40 ++--
 drivers/gpu/drm/drm_atomic_uapi.c                  |   4 +
 drivers/gpu/drm/drm_connector.c                    |   4 +
 drivers/gpu/drm/gma500/mid_bios.c                  |   5 +
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c            |   2 +
 drivers/gpu/drm/i915/display/intel_display.c       |   5 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c        |   1 -
 drivers/gpu/drm/vkms/vkms_composer.c               |   2 +-
 drivers/hid/Kconfig                                |   3 +-
 drivers/hid/hid-apple.c                            |  13 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-topre.c                            |   7 +
 drivers/hid/intel-ish-hid/ipc/ipc.c                |  15 +-
 drivers/hid/intel-ish-hid/ishtp/ishtp-dev.h        |   2 +
 drivers/hv/vmbus_drv.c                             |  13 ++
 drivers/i2c/busses/i2c-ali1535.c                   |  12 +-
 drivers/i2c/busses/i2c-ali15x3.c                   |  12 +-
 drivers/i2c/busses/i2c-sis630.c                    |  12 +-
 drivers/input/joystick/xpad.c                      |  39 +++-
 drivers/input/misc/iqs7222.c                       |  50 ++--
 drivers/input/serio/i8042-acpipnpio.h              | 111 +++++----
 drivers/input/touchscreen/ads7846.c                |   2 +-
 drivers/md/dm-flakey.c                             |   2 +-
 drivers/net/bonding/bond_options.c                 |  55 ++++-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  59 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  11 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   3 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   3 +
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |   3 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   5 +
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   7 +-
 drivers/net/mctp/mctp-i2c.c                        |   5 +
 drivers/net/wwan/mhi_wwan_mbim.c                   |   2 +-
 drivers/nvme/host/apple.c                          |   2 +
 drivers/nvme/host/core.c                           |   2 -
 drivers/nvme/host/fc.c                             |  59 +----
 drivers/nvme/host/pci.c                            |   2 +
 drivers/nvme/host/tcp.c                            |  43 ++++
 drivers/nvme/target/rdma.c                         |  33 ++-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |   2 +-
 drivers/platform/x86/intel/pmc/core.c              |   4 +-
 drivers/platform/x86/thinkpad_acpi.c               |  50 ++--
 drivers/powercap/powercap_sys.c                    |   3 +-
 drivers/s390/cio/chp.c                             |   3 +-
 drivers/scsi/qla1280.c                             |   2 +-
 drivers/scsi/scsi_scan.c                           |   2 +-
 drivers/thermal/cpufreq_cooling.c                  |   2 -
 drivers/ufs/core/ufshcd.c                          |   7 +-
 drivers/usb/phy/phy-generic.c                      |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  14 ++
 drivers/usb/serial/ftdi_sio_ids.h                  |  13 ++
 drivers/usb/serial/option.c                        |  48 ++--
 drivers/video/fbdev/hyperv_fb.c                    |   2 +-
 drivers/xen/swiotlb-xen.c                          |   2 +-
 fs/fuse/dir.c                                      |   2 +-
 fs/namei.c                                         |  24 +-
 fs/proc/base.c                                     |   9 +-
 fs/select.c                                        |  11 +-
 fs/smb/client/asn1.c                               |   2 +
 fs/smb/client/cifs_spnego.c                        |   4 +-
 fs/smb/client/cifsglob.h                           |   4 +
 fs/smb/client/connect.c                            |  16 +-
 fs/smb/client/fs_context.c                         |  18 +-
 fs/smb/client/inode.c                              |  13 ++
 fs/smb/client/reparse.c                            |  10 +-
 fs/smb/client/sess.c                               |   3 +-
 fs/smb/client/smb2pdu.c                            |   4 +-
 fs/smb/common/smbfsctl.h                           |   3 +
 fs/smb/server/connection.c                         |  20 ++
 fs/smb/server/connection.h                         |   2 +
 fs/smb/server/ksmbd_work.c                         |   3 -
 fs/smb/server/ksmbd_work.h                         |   1 -
 fs/smb/server/oplock.c                             |  43 ++--
 fs/smb/server/oplock.h                             |   1 -
 fs/smb/server/server.c                             |  14 +-
 fs/vboxsf/super.c                                  |   3 +-
 include/linux/fs.h                                 |   2 +
 include/linux/i8253.h                              |   1 -
 include/linux/io_uring_types.h                     |   3 -
 include/linux/nvme-tcp.h                           |   2 +
 include/net/bluetooth/hci_core.h                   | 108 ++++-----
 include/net/bluetooth/l2cap.h                      |   3 +-
 include/net/netfilter/nf_tables.h                  |  20 +-
 include/sound/soc.h                                |   5 +-
 init/Kconfig                                       |   2 +-
 io_uring/io-wq.c                                   |  23 +-
 io_uring/io_uring.c                                | 252 +++++++++++++++------
 io_uring/io_uring.h                                |   8 +-
 io_uring/kbuf.c                                    | 173 ++++----------
 io_uring/kbuf.h                                    |   3 +-
 io_uring/rsrc.c                                    |  39 ----
 kernel/bpf/ringbuf.c                               |  12 +-
 kernel/sched/core.c                                |  13 +-
 kernel/sched/debug.c                               |   2 +
 kernel/sys.c                                       |   2 +
 kernel/time/hrtimer.c                              |  40 ++--
 lib/buildid.c                                      |   5 +
 mm/mmap.c                                          |  69 ++++--
 mm/nommu.c                                         |   7 +
 net/bluetooth/hci_core.c                           |  10 +-
 net/bluetooth/hci_event.c                          |  37 +--
 net/bluetooth/iso.c                                |   6 -
 net/bluetooth/l2cap_core.c                         | 181 +++++++--------
 net/bluetooth/l2cap_sock.c                         |  15 +-
 net/bluetooth/rfcomm/core.c                        |   6 -
 net/bluetooth/sco.c                                |  12 +-
 net/core/dev.c                                     |   2 +-
 net/core/netpoll.c                                 |   9 +-
 net/ipv4/tcp.c                                     |  20 +-
 net/ipv6/addrconf.c                                |  15 +-
 net/mptcp/protocol.h                               |   2 +
 net/netfilter/ipvs/ip_vs_ctl.c                     |   8 +-
 net/netfilter/nf_conncount.c                       |   6 +-
 net/netfilter/nf_tables_api.c                      |  25 +-
 net/netfilter/nft_connlimit.c                      |   4 +-
 net/netfilter/nft_counter.c                        |   4 +-
 net/netfilter/nft_ct.c                             |   6 +-
 net/netfilter/nft_dynset.c                         |   2 +-
 net/netfilter/nft_exthdr.c                         |  10 +-
 net/netfilter/nft_last.c                           |   4 +-
 net/netfilter/nft_limit.c                          |  14 +-
 net/netfilter/nft_quota.c                          |   4 +-
 net/netfilter/nft_set_hash.c                       |   8 +-
 net/netfilter/nft_set_pipapo.c                     |  18 +-
 net/netfilter/nft_set_rbtree.c                     |  11 +-
 net/openvswitch/flow_netlink.c                     |  15 +-
 net/sched/sch_api.c                                |   6 +
 net/sched/sch_gred.c                               |   3 +-
 net/sctp/stream.c                                  |   2 +-
 net/switchdev/switchdev.c                          |  25 +-
 net/wireless/core.c                                |   7 +
 rust/kernel/error.rs                               |   2 +-
 rust/kernel/init.rs                                |  23 +-
 rust/kernel/init/macros.rs                         |   6 +-
 rust/kernel/sync.rs                                |  10 +-
 scripts/generate_rust_analyzer.py                  |  30 ++-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/arizona.c                         |  14 +-
 sound/soc/codecs/cs42l43.c                         |   2 +-
 sound/soc/codecs/madera.c                          |  10 +-
 sound/soc/codecs/rt722-sdca-sdw.c                  |   4 +
 sound/soc/codecs/tas2764.c                         |  10 +-
 sound/soc/codecs/tas2764.h                         |   8 +-
 sound/soc/codecs/tas2770.c                         |   2 +-
 sound/soc/codecs/wm0010.c                          |  13 +-
 sound/soc/codecs/wm5110.c                          |   8 +-
 sound/soc/generic/simple-card-utils.c              |   1 +
 sound/soc/sh/rcar/core.c                           |  14 --
 sound/soc/sh/rcar/rsnd.h                           |   1 -
 sound/soc/sh/rcar/src.c                            | 116 ++++++++--
 sound/soc/sh/rcar/ssi.c                            |   3 +-
 sound/soc/soc-ops.c                                |  15 +-
 sound/soc/sof/amd/acp-ipc.c                        |  23 +-
 sound/soc/sof/intel/hda-codec.c                    |   1 +
 tools/objtool/check.c                              |   9 +
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   6 +-
 186 files changed, 1804 insertions(+), 1167 deletions(-)


