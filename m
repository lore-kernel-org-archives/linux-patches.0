Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337B43FFAB5;
	Thu, 12 Mar 2026 20:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346343; cv=none; b=N05VZy0DAytMIRaQCHUOJFx2wI0rMoaFOX6nfIGAJ6pz73AhYaun2qzWm8CoV00NWEuPaU77wJ19WpEoVkpLrTw3FZ2X0QIJi1RpZcw6AEmUkskaZxFaVYtVIIGsoO9DuPnj5hO+n7mdqsH04x7WFe8Uiq1qizq9rzH/SfxtQtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346343; c=relaxed/simple;
	bh=+JHtm3yVRkPviqjlgQZXhjjTRA8YGdzzOJv3pPnojDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rKdNkXpiPkGTDEl6H51WnToKI6ooxNZmfUBhTRdWfYR83+Rn01XS6b4J3I9jj5bwHcDyfqLRmJF4H/HcMH/EPxjuk15DzHcp8wBY1AoC/Ds5bmfCOvklbn/CNauBqowCsHjAVMNHBDQKE9soHr8yd9bo0g4b7L7HQyx9XztFSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oK0yTuF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oK0yTuF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A84C4CEF7;
	Thu, 12 Mar 2026 20:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346342;
	bh=+JHtm3yVRkPviqjlgQZXhjjTRA8YGdzzOJv3pPnojDI=;
	h=From:To:Cc:Subject:Date:From;
	b=oK0yTuF5ZAkAqYpFobntoabsimsUya5KZWTuvRQIOelOkccIeCU0gVsIe2yC4zGe2
	 IHY0vGY9dTC66GNYkzcAoR7AXCHwiJSGatSj1um0N4/MoHE8PJsU1m3c5fJ0ObVusv
	 S9vTQAIppd4O1dELfUQxUMszzyc5hk3WCTKHVlxA=
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
Subject: [PATCH 6.12 000/265] 6.12.77-rc1 review
Date: Thu, 12 Mar 2026 21:06:27 +0100
Message-ID: <20260312201018.128816016@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.77-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.77-rc1
X-KernelTest-Deadline: 2026-03-14T20:10+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.77 release.
There are 265 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 13 Mar 2026 20:09:29 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.77-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.77-rc1

Guenter Roeck <linux@roeck-us.net>
    ata: libata-eh: Fix detection of deferred qc timeouts

Niklas Cassel <cassel@kernel.org>
    ata: libata: cancel pending work after clearing deferred_qc

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-eh: correctly handle deferred qc timeouts

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-core: fix cancellation of a port deferred qc work

Baokun Li <libaokun1@huawei.com>
    ext4: fix potential null deref in ext4_mb_init()

John Johansen <john.johansen@canonical.com>
    apparmor: fix race between freeing data and fs accessing it

John Johansen <john.johansen@canonical.com>
    apparmor: fix race on rawdata dereference

John Johansen <john.johansen@canonical.com>
    apparmor: fix differential encoding verification

John Johansen <john.johansen@canonical.com>
    apparmor: fix unprivileged local user can do privileged policy management

John Johansen <john.johansen@canonical.com>
    apparmor: Fix double free of ns_name in aa_replace_profiles()

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix missing bounds check on DEFAULT table in verify_dfa()

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix side-effect bug in match_char() macro usage

John Johansen <john.johansen@canonical.com>
    apparmor: fix: limit the number of levels of policy namespaces

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: replace recursive profile removal with iterative approach

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: fix memory leak in verify_header

Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
    apparmor: validate DFA start states are in bounds in unpack_pdb

Victor Nogueira <victor@mojatatu.com>
    net/sched: Only allow act_ct to bind to clsact/ingress qdiscs and shared blocks

Guenter Roeck <linux@roeck-us.net>
    tracing: Add NULL pointer check to trigger_data_free()

Yifan Wu <wuyifan50@huawei.com>
    selftest/arm64: Fix sve2p1_sigill() to hwcap test

Larysa Zaremba <larysa.zaremba@intel.com>
    xdp: produce a warning when calculated tailroom is negative

Larysa Zaremba <larysa.zaremba@intel.com>
    i40e: use xdp.frame_sz as XDP RxQ info frag_size

Larysa Zaremba <larysa.zaremba@intel.com>
    i40e: fix registering XDP RxQ info

Larysa Zaremba <larysa.zaremba@intel.com>
    xsk: introduce helper to determine rxq->frag_size

Larysa Zaremba <larysa.zaremba@intel.com>
    xdp: use modulo operation to calculate XDP frag tailroom

Jamal Hadi Salim <jhs@mojatatu.com>
    net/sched: act_ife: Fix metalist update behavior

Jiayuan Chen <jiayuan.chen@shopee.com>
    net: ipv6: fix panic when IPv4 route references loopback IPv6 nexthop

Fernando Fernandez Mancera <fmancera@suse.de>
    net: vxlan: fix nd_tbl NULL dereference when IPv6 is disabled

Fernando Fernandez Mancera <fmancera@suse.de>
    net: bridge: fix nd_tbl NULL dereference when IPv6 is disabled

Sun Jian <sun.jian.kdev@gmail.com>
    selftests/harness: order TEST_F and XFAIL_ADD constructors

Wake Liu <wakel@google.com>
    kselftest/harness: Use helper to avoid zero-size memset warning

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: split gc into unlink and reclaim phase

Ovidiu Panait <ovidiu.panait.rb@renesas.com>
    net: stmmac: Fix error handling in VLAN add and delete paths

Jakub Kicinski <kuba@kernel.org>
    nfc: rawsock: cancel tx_work before socket teardown

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: clear NCI_DATA_EXCHANGE before calling completion callback

Jakub Kicinski <kuba@kernel.org>
    nfc: nci: free skb on nci_transceive early error paths

Eric Dumazet <edumazet@google.com>
    net_sched: sch_fq: clear q->band_pkt_count[] in fq_reset()

Ian Ray <ian.ray@gehealthcare.com>
    net: nfc: nci: Fix zero-length proprietary notifications

Koichiro Den <den@valinux.co.jp>
    net: sched: avoid qdisc_reset_all_tx_gt() vs dequeue race for lockless qdiscs

Olivier Sobrie <olivier@sobrie.be>
    hwmon: (max6639) fix inverted polarity

Naresh Solanki <naresh.solanki@9elements.com>
    hwmon: (max6639) : Configure based on DT property

Sungwoo Kim <iam@sung-woo.kim>
    nvme: fix memory allocation in nvme_pr_read_keys()

Stefan Hajnoczi <stefanha@redhat.com>
    nvme: reject invalid pr_read_keys() num_keys values

Shuicheng Lin <shuicheng.lin@intel.com>
    drm/xe/reg_sr: Fix leak on xa_store failure

Charles Haithcock <chaithco@redhat.com>
    i2c: i801: Revert "i2c: i801: replace acpi_lock with I2C bus lock"

Yujie Liu <yujie.liu@intel.com>
    drm/sched: Fix kernel-doc warning for drm_sched_job_done()

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix sleep while atomic on suspend/resume

Yung Chih Su <yuuchihsu@gmail.com>
    net: ipv4: fix ARM64 alignment fault in multipath hash seed

Jakub Kicinski <kuba@kernel.org>
    ipv6: fix NULL pointer deref in ip6_rt_get_dev_rcu()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/client: fix buffer size for smb311_posix_qinfo in SMB311_posix_query_info()

ZhangGuoDong <zhangguodong@kylinos.cn>
    smb/client: fix buffer size for smb311_posix_qinfo in smb2_compound_op()

Lang Xu <xulang@uniontech.com>
    bpf: Fix a UAF issue in bpf_trampoline_link_cgroup_shim

Kohei Enju <kohei@enjuk.jp>
    iavf: fix netdev->max_mtu to respect actual hardware limit

David Thomson <dt@linux-mail.net>
    xen/acpi-processor: fix _CST detection using undersized evaluation buffer

Allison Henderson <achender@kernel.org>
    net/rds: Fix circular locking dependency in rds_tcp_tune

Eric Dumazet <edumazet@google.com>
    indirect_call_wrapper: do not reevaluate function pointer

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: Fix possible oob access in mt76_connac2_mac_write_txwi_80211()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7925: Fix possible oob access in mt7925_mac_write_txwi_80211()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7996: Fix possible oob access in mt7996_mac_write_txwi_80211()

Bart Van Assche <bvanassche@acm.org>
    wifi: wlcore: Fix a locking bug

Bart Van Assche <bvanassche@acm.org>
    wifi: cw1200: Fix locking in error paths

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep_vf: avoid compiler and IQ/OQ reordering

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep_vf: Relocate counter updates before NAPI

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep: avoid compiler and IQ/OQ reordering

Vimlesh Kumar <vimleshk@marvell.com>
    octeon_ep: Relocate counter updates before NAPI

Jiayuan Chen <jiayuan.chen@shopee.com>
    bpf/bonding: reject vlan+srcmac xmit_hash_policy change when XDP is loaded

Mieczyslaw Nalewaj <namiltd@yahoo.com>
    net: dsa: realtek: rtl8365mb: fix rtl8365mb_phy_ocp_write return value

Shuvam Pandey <shuvampandey1@gmail.com>
    kunit: tool: copy caller args in run_kernel to prevent mutation

Alexandre Courbot <acourbot@nvidia.com>
    rust: kunit: fix warning when !CONFIG_PRINTK

Matthew Brost <matthew.brost@intel.com>
    drm/xe: Do not preempt fence signaling CS instructions

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    wifi: rsi: Don't default to -EOPNOTSUPP in rsi_mac80211_config

Alban Bedel <alban.bedel@lht.dlh.de>
    can: mcp251x: fix deadlock in error path of mcp251x_open

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: fix locking for bcm_op runtime updates

Raju Rangoju <Raju.Rangoju@amd.com>
    amd-xgbe: fix MAC_TCR_SS register width for 2.5G and 10M speeds

MD Danish Anwar <danishanwar@ti.com>
    net: ti: icssg-prueth: Fix ping failure after offload mode setup when link speed is not 1G

Jiayuan Chen <jiayuan.chen@shopee.com>
    atm: lec: fix null-ptr-deref in lec_arp_clear_vccs

Guenter Roeck <linux@roeck-us.net>
    dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler

Nikhil P. Rao <nikhil.rao@amd.com>
    xsk: Fix zero-copy AF_XDP fragment drop

Nikhil P. Rao <nikhil.rao@amd.com>
    xsk: Fix fragment node deletion to prevent buffer leak

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: s/free_list_node/list_node/

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    xsk: Get rid of xdp_buff_xsk::xskb_list_node

Chintan Vankar <c-vankar@ti.com>
    net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry handling in ALE table

Francesco Lavra <flavra@baylibre.com>
    drm/solomon: Fix page start when updating rectangle in page addressing mode

Vitaly Lifshits <vitaly.lifshits@intel.com>
    e1000e: clear DPG_EN after reset to avoid autonomous power-gating

Thomas Gleixner <tglx@kernel.org>
    i40e: Fix preempt count leak in napi poll tracepoint

Brian Vazquez <brianvv@google.com>
    idpf: change IRQ naming to match netdev and ethtool queue numbering

Bart Van Assche <bvanassche@acm.org>
    hwmon: (it87) Check the it87_lock() return value

Felix Gu <ustc.gu@gmail.com>
    pinctrl: cirrus: cs42l43: Fix double-put in cs42l43_pin_probe()

Ian Ray <ian.ray@gehealthcare.com>
    HID: multitouch: new class MT_CLS_EGALAX_P80H84

Brian Howard <blhoward2@gmail.com>
    HID: multitouch: add quirks for Lenovo Yoga Book 9i

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: add device ID for Apple Touch Bar

Kerem Karabay <kekrby@gmail.com>
    HID: multitouch: Get the contact ID from HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar

Jonathan Teh <jonathan.teh@outlook.com>
    platform/x86: thinkpad_acpi: Fix errors reading battery thresholds

Florian Eckert <fe@dev.tdt.de>
    pinctrl: equilibrium: fix warning trace on load

Florian Eckert <fe@dev.tdt.de>
    pinctrl: equilibrium: rename irq_chip function callbacks

Hao Yu <haoyufine@gmail.com>
    hwmon: (aht10) Fix initialization commands for AHT20

Akhilesh Patil <akhilesh@ee.iitb.ac.in>
    hwmon: (aht10) Add support for dht20

Ming Lei <ming.lei@redhat.com>
    nvme: fix admin queue leak on controller reset

Nathan Chancellor <nathan@kernel.org>
    ACPI: APEI: GHES: Disable KASAN instrumentation when compile testing with clang < 18

Qu Wenruo <wqu@suse.com>
    btrfs: always fallback to buffered write if the inode requires checksum

Huacai Chen <chenhuacai@kernel.org>
    net: stmmac: dwmac-loongson: Set clk_csr_i to 100-150MHz

Thomas Weißschuh <thomas.weissschuh@linutronix.de>
    ARM: clean up the memset64() C wrapper

Al Viro <viro@zeniv.linux.org.uk>
    xattr: switch to CLASS(fd)

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: join: check removing signal+subflow endp

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: more stable simult_flows tests

Junxiao Bi <junxiao.bi@oracle.com>
    scsi: core: Fix refcount leak for tagset_refcnt

Thorsten Blum <thorsten.blum@linux.dev>
    smb: client: Don't log plaintext credentials in cifs_set_cifscreds

Paulo Alcantara <pc@manguebit.org>
    smb: client: fix broken multichannel with krb5+signing

Henrique Carvalho <henrique.carvalho@suse.com>
    smb: client: fix cifs_pick_channel when channels are equally loaded

Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
    drbd: fix null-pointer dereference on local read error

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix "LOGIC BUG" in drbd_al_begin_io_nonblock()

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: check metadata block offset is within range

Prithvi Tambewagh <activprithvi@gmail.com>
    scsi: target: Fix recursive locking in __configfs_open_file()

Qing Wang <wangqing7171@gmail.com>
    tracing: Fix WARN_ON in tracing_buffers_mmap_close

Kuniyuki Iwashima <kuniyu@google.com>
    nfsd: Fix cred ref leak in nfsd_nl_threads_set_doit().

Davide Caratti <dcaratti@redhat.com>
    net/sched: ets: fix divide by zero in the offload path

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/irdma: Fix kernel stack leak in irdma_create_user_ah()

Jason Gunthorpe <jgg@ziepe.ca>
    IB/mthca: Add missed mthca_unmap_user_db() for mthca_create_srq()

Vahagn Vardanian <vahagn@redrays.io>
    wifi: mac80211: fix NULL pointer dereference in mesh_rx_csa_frame()

Ariel Silver <arielsilver77@gmail.com>
    wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration

Daniil Dulov <d.dulov@aladdin.ru>
    wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()

Johannes Berg <johannes.berg@intel.com>
    wifi: radiotap: reject radiotap with unknown bits

Jun Seo <jun.seo.93@proton.me>
    ALSA: usb-audio: Use correct version for UAC3 header validation

Kurt Borja <kuurtb@gmail.com>
    platform/x86: dell-wmi: Add audio/mic mute key codes

Thorsten Blum <thorsten.blum@linux.dev>
    platform/x86: dell-wmi-sysman: Don't hex dump plaintext password data

Mike Rapoport (Microsoft) <rppt@kernel.org>
    x86/efi: defer freeing of boot services memory

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: Add HID_CLAIMED_INPUT guards in raw_event callbacks missing them

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: usb: f81604: handle bulk write errors properly

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: usb: f81604: handle short interrupt urb messages properly

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: usb: etas_es58x: correctly anchor the urb in the read bulk callback

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: ucan: Fix infinite loop from zero-length messages

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: usb: f81604: correctly anchor the urb in the read bulk callback

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    can: ems_usb: ems_usb_read_bulk_callback(): check the proper length of a message

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: pegasus: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: kalmia: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: kaweth: validate USB endpoints

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    nfc: pn533: properly drop the usb interface reference on disconnect

Jens Axboe <axboe@kernel.dk>
    media: dvb-core: fix wrong reinitialization of ringbuffer on reopen

Christian Brauner <brauner@kernel.org>
    namespace: fix proc mount iteration

Jann Horn <jannh@google.com>
    eventpoll: Fix integer overflow in ep_loop_check_proc()

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: arcnet: com20020-pci: fix support for 2.5Mbit cards

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314

Lewis Mason <mason8110@gmail.com>
    ALSA: hda/realtek: Add quirk for Samsung Galaxy Book3 Pro 360 (NP965QFG)

Eric Naim <dnaim@cachyos.org>
    ALSA: hda/realtek: Add quirk for Gigabyte G5 KF5 (2023)

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Remove some extern variables in source files

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Handle percpu handler address for ORC unwinder

Tiezhu Yang <yangtiezhu@loongson.cn>
    LoongArch: Remove unnecessary checks for ORC unwinder

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    LoongArch/orc: Use RCU in all users of __module_address().

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: add chann_lock to protect ksmbd_chann_list xarray

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: check return value of xa_store() in krb5_authenticate

Gui-Dong Han <hanguidong02@gmail.com>
    hwmon: (max16065) Use READ/WRITE_ONCE to avoid compiler optimization induced race

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Add quirk for HP ZBook Studio G4

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fix hang on amdgpu unload by using pci_dev_is_disconnected()

Thomas Richard (TI) <thomas.richard@bootlin.com>
    usb: cdns3: fix role switching during resume

Théo Lebrun <theo.lebrun@bootlin.com>
    usb: cdns3: call cdns_power_is_lost() only once in cdns_resume()

Hongyu Xie <xiehongyu1@kylinos.cn>
    usb: cdns3: remove redundant if branch

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fixup last alloc pointer after extent removal for RAID0/10

Miquel Sabaté Solà <mssola@mssola.com>
    btrfs: define the AUTO_KFREE/AUTO_KVFREE helper macros

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fix stripe width calculation

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fixup last alloc pointer after extent removal for DUP

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: fixup last alloc pointer after extent removal for RAID1

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: zoned: fix alloc_offset calculation for partly conventional block groups

Sun YangKai <sunk67188@gmail.com>
    btrfs: fix periodic reclaim condition

Filipe Manana <fdmanana@suse.com>
    btrfs: fix reclaimed bytes accounting after automatic block group reclaim

Filipe Manana <fdmanana@suse.com>
    btrfs: get used bytes while holding lock at btrfs_reclaim_bgs_work()

David Sterba <dsterba@suse.com>
    btrfs: drop unused parameter fs_info from do_reclaim_sweep()

Breno Leitao <leitao@debian.org>
    uprobes: Fix incorrect lockdep condition in filter_chain()

Andrii Nakryiko <andrii@kernel.org>
    uprobes: switch to RCU Tasks Trace flavor for better performance

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: use ctx->lock to protect struct vidi_context member variables related to memory alloc/free

Wentao Liang <vulab@iscas.ac.cn>
    drm/exynos/vidi: Remove redundant error handling in vidi_get_modes()

Jeongjun Park <aha310510@gmail.com>
    drm/exynos: vidi: fix to avoid directly dereferencing user pointer

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    of/kexec: refactor ima_get_kexec_buffer() to use ima_validate_range()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    ima: verify the previous kernel's IMA buffer lies in addressable RAM

Steven Chen <chenste@linux.microsoft.com>
    ima: kexec: define functions to copy IMA log at soft boot

Steven Chen <chenste@linux.microsoft.com>
    kexec: define functions to map and unmap segments

Steven Chen <chenste@linux.microsoft.com>
    ima: define and call ima_alloc_kexec_file_buf()

Steven Chen <chenste@linux.microsoft.com>
    ima: rename variable the seq_file "file" to "ima_kexec_file"

Breno Leitao <leitao@debian.org>
    ima: kexec: silence RCU list traversal warning

Johan Hovold <johan@kernel.org>
    clk: tegra: tegra124-emc: fix device leak on set_rate()

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Fix rk3588 PCIe range mappings

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Fix rk356x PCIe range mappings

Jinhui Guo <guojinhui.liam@bytedance.com>
    iommu/vt-d: Skip dev-iotlb flush for inaccessible PCIe device without scalable mode

Minseong Kim <ii4gsp@gmail.com>
    Input: synaptics_i2c - guard polling restart in resume

Marco Crivellari <marco.crivellari@suse.com>
    Input: synaptics_i2c - replace use of system_wq with system_dfl_wq

Marco Crivellari <marco.crivellari@suse.com>
    workqueue: Add system_percpu_wq and system_dfl_wq

Jan Kara <jack@suse.cz>
    ext4: always allocate blocks only from groups inode can use

Baokun Li <libaokun1@huawei.com>
    ext4: implement linear-like traversal across order xarrays

Baokun Li <libaokun1@huawei.com>
    ext4: refactor choose group to scan group

Baokun Li <libaokun1@huawei.com>
    ext4: convert free groups order lists to xarrays

Baokun Li <libaokun1@huawei.com>
    ext4: factor out ext4_mb_scan_group()

Baokun Li <libaokun1@huawei.com>
    ext4: factor out ext4_mb_might_prefetch()

Baokun Li <libaokun1@huawei.com>
    ext4: factor out __ext4_mb_scan_group()

Baokun Li <libaokun1@huawei.com>
    ext4: add ext4_try_lock_group() to skip busy groups

Joonwon Kang <joonwonkang@google.com>
    mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()

Anup Patel <apatel@ventanamicro.com>
    mailbox: Allow controller specific mapping using fwnode

Peng Fan <peng.fan@nxp.com>
    mailbox: Use guard/scoped_guard for con_mutex

Peng Fan <peng.fan@nxp.com>
    mailbox: Use dev_err when there is error

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: remove unused header files

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: sort headers alphabetically

Tudor Ambarus <tudor.ambarus@linaro.org>
    mailbox: don't protect of_parse_phandle_with_args with con_mutex

Zhang Yi <yi.zhang@huawei.com>
    ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O

Yang Erkun <yangerkun@huawei.com>
    ext4: correct the comments place for EXT4_EXT_MAY_ZEROOUT

Johan Hovold <johan@kernel.org>
    drm/tegra: dsi: fix device leak on probe

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: avoid Non-NCQ command starvation

Damien Le Moal <dlemoal@kernel.org>
    ata: libata: Introduce ata_port_eh_scheduled()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata: Remove ATA_DFLAG_ZAC device flag

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Remove struct ata_scsi_args

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Document all VPD page inquiry actors

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Refactor ata_scsiop_maint_in()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Refactor ata_scsiop_read_cap()

Damien Le Moal <dlemoal@kernel.org>
    ata: libata-scsi: Refactor ata_scsi_simulate()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block()

Ricardo Ribalda <ribalda@chromium.org>
    media: dw9714: Fix powerup sequence

Matthias Fend <matthias.fend@emfend.at>
    media: dw9714: add support for powerdown pin

Matthias Fend <matthias.fend@emfend.at>
    media: dw9714: move power sequences to dedicated functions

Zilin Guan <zilin@seu.edu.cn>
    media: tegra-video: Fix memory leak in __tegra_channel_try_format()

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    PCI: Use resource_set_range() that correctly sets ->end

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    resource: Add resource set range and size helpers

Niklas Cassel <cassel@kernel.org>
    Revert "PCI: qcom: Don't wait for link if we can detect Link Up"

Krishna chaitanya chundru <quic_krichai@quicinc.com>
    PCI: qcom: Don't wait for link if we can detect Link Up

Niklas Cassel <cassel@kernel.org>
    Revert "PCI: dw-rockchip: Don't wait for link since we can detect Link Up"

Niklas Cassel <cassel@kernel.org>
    PCI: dw-rockchip: Don't wait for link since we can detect Link Up

Johan Hovold <johan@kernel.org>
    memory: mtk-smi: fix device leak on larb probe

Johan Hovold <johan@kernel.org>
    memory: mtk-smi: fix device leaks on common probe

Yazen Ghannam <yazen.ghannam@amd.com>
    x86/acpi/boot: Correct acpi_is_processor_usable() check again

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Correct PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 value

Kohei Enju <kohei@enjuk.jp>
    bpf: Fix stack-out-of-bounds write in devmap

Fuad Tabba <tabba@google.com>
    bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing

Mark Harmstone <mark@harmstone.com>
    btrfs: fix compat mask in error messages in btrfs_check_features()

Mark Harmstone <mark@harmstone.com>
    btrfs: print correct subvol num if active swapfile prevents deletion

Mark Harmstone <mark@harmstone.com>
    btrfs: fix warning in scrub_verify_one_metadata()

Mark Harmstone <mark@harmstone.com>
    btrfs: fix objectid value in error message in check_extent_data_ref()

Mark Harmstone <mark@harmstone.com>
    btrfs: fix incorrect key offset in error message in check_dev_extent_item()

Richard Fitzgerald <rf@opensource.cirrus.com>
    ALSA: hda: cs35l56: Fix signedness error in cs35l56_hda_posture_put()

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ALSA: pci: hda: use snd_kcontrol_chip()

Bart Van Assche <bvanassche@acm.org>
    drm/amdgpu: Fix locking bugs in error paths

Thorsten Blum <thorsten.blum@linux.dev>
    drm/amdgpu: Replace kzalloc + copy_from_user with memdup_user

Bart Van Assche <bvanassche@acm.org>
    drm/amdgpu: Unlock a mutex before destroying it

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry

Niklas Cassel <cassel@kernel.org>
    PCI: dwc: ep: Use align addr function for dw_pcie_ep_raise_{msi,msix}_irq()

Damien Le Moal <dlemoal@kernel.org>
    PCI: dwc: endpoint: Implement the pci_epc_ops::align_addr() operation

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Introduce pci_epc_mem_map()/unmap()

Damien Le Moal <dlemoal@kernel.org>
    PCI: endpoint: Introduce pci_epc_function_is_valid()

Heiko Carstens <hca@linux.ibm.com>
    s390/vtime: Fix virtual timer forwarding

Heiko Carstens <hca@linux.ibm.com>
    s390/idle: Fix cpu idle exit cpu time accounting

Peter Zijlstra <peterz@infradead.org>
    perf: Fix __perf_event_overflow() vs perf_remove_from_context() race

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use inclusive terms

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Cap the packet size pre-calculations

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: core: Move link recovery for hibern8 exit failure to wl_resume

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Fix incorrect use of cpuset_update_tasks_cpumask() in update_cpumasks_hier()

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq: Clarify rseq registration rseq_size bound check comment

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix lag clamp

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Fix EEVDF entity placement bug causing scheduling lag

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/fred: Correct speculative safety in fred_extint()

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Fix DSP filter control array handling

Geoffrey D. Bennett <g@b4.vu>
    ALSA: scarlett2: Fix redeclaration of loop variable

Salomon Dushimirimana <salomondush@google.com>
    scsi: pm8001: Fix use-after-free in pm8001_queue_command()

Mathias Krause <minipli@grsecurity.net>
    scsi: lpfc: Properly set WC for DPP mapping

Nam Cao <namcao@linutronix.de>
    irqchip/sifive-plic: Fix frozen interrupt due to affinity setting

Fuad Tabba <tabba@google.com>
    KVM: arm64: Hide S1POE from guests when not supported by the host

Oliver Upton <oliver.upton@linux.dev>
    KVM: arm64: Advertise support for FEAT_SCTLR2

Felix Gu <ustc.gu@gmail.com>
    drm/logicvc: Fix device node reference leak in logicvc_drm_config_parse()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Return the correct value in vmw_translate_ptr functions

Brad Spengler <brad.spengler@opensrcsec.com>
    drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release


-------------

Diffstat:

 Documentation/hwmon/aht10.rst                      |  10 +-
 Makefile                                           |   4 +-
 arch/Kconfig                                       |   1 +
 arch/arm/include/asm/string.h                      |  14 +-
 arch/arm64/boot/dts/rockchip/rk3568.dtsi           |   4 +-
 arch/arm64/boot/dts/rockchip/rk356x.dtsi           |   2 +-
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   4 +-
 arch/arm64/boot/dts/rockchip/rk3588-extra.dtsi     |   6 +-
 arch/arm64/kvm/sys_regs.c                          |  10 +-
 arch/arm64/net/bpf_jit_comp.c                      |   2 +-
 arch/loongarch/include/asm/setup.h                 |   3 +
 arch/loongarch/kernel/unwind_orc.c                 |  32 +-
 arch/loongarch/kernel/unwind_prologue.c            |   4 -
 arch/loongarch/mm/tlb.c                            |   1 -
 arch/s390/include/asm/idle.h                       |   1 +
 arch/s390/kernel/idle.c                            |  13 +-
 arch/s390/kernel/irq.c                             |  10 +-
 arch/s390/kernel/vtime.c                           |  18 +-
 arch/x86/entry/entry_fred.c                        |   5 +-
 arch/x86/include/asm/efi.h                         |   2 +-
 arch/x86/kernel/acpi/boot.c                        |  12 +-
 arch/x86/kernel/cpu/topology.c                     |  15 -
 arch/x86/kvm/x86.c                                 |   3 +-
 arch/x86/platform/efi/efi.c                        |   2 +-
 arch/x86/platform/efi/quirks.c                     |  55 +-
 drivers/acpi/apei/Makefile                         |   4 +
 drivers/ata/libata-core.c                          |  18 +-
 drivers/ata/libata-eh.c                            |  31 +-
 drivers/ata/libata-scsi.c                          | 546 +++++++++++-----
 drivers/ata/libata.h                               |  14 +
 drivers/block/drbd/drbd_actlog.c                   |  53 +-
 drivers/block/drbd/drbd_interval.h                 |   5 +-
 drivers/block/drbd/drbd_req.c                      |   3 +-
 drivers/clk/tegra/clk-tegra124-emc.c               |   2 +-
 drivers/firmware/efi/mokvar-table.c                |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c         |  32 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c           |  61 +-
 drivers/gpu/drm/logicvc/logicvc_drm.c              |   4 +-
 drivers/gpu/drm/scheduler/sched_main.c             |   1 +
 drivers/gpu/drm/solomon/ssd130x.c                  |   6 +-
 drivers/gpu/drm/tegra/dsi.c                        |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c            |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c         |   9 +-
 drivers/gpu/drm/xe/xe_reg_sr.c                     |   4 +-
 drivers/gpu/drm/xe/xe_ring_ops.c                   |   9 +
 drivers/hid/Kconfig                                |   1 +
 drivers/hid/hid-cmedia.c                           |   2 +-
 drivers/hid/hid-creative-sb0540.c                  |   2 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-multitouch.c                       | 116 +++-
 drivers/hid/hid-zydacron.c                         |   2 +-
 drivers/hwmon/Kconfig                              |   6 +-
 drivers/hwmon/aht10.c                              |  21 +-
 drivers/hwmon/it87.c                               |   5 +-
 drivers/hwmon/max16065.c                           |  26 +-
 drivers/hwmon/max6639.c                            |  83 ++-
 drivers/i2c/busses/i2c-i801.c                      |  14 +-
 drivers/infiniband/hw/irdma/verbs.c                |   2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |   5 +-
 drivers/input/mouse/synaptics_i2c.c                |  13 +-
 drivers/iommu/intel/pasid.c                        |   8 +
 drivers/irqchip/irq-sifive-plic.c                  |   7 +-
 drivers/mailbox/mailbox.c                          | 132 ++--
 drivers/media/dvb-core/dmxdev.c                    |   4 +-
 drivers/media/i2c/Kconfig                          |   2 +-
 drivers/media/i2c/dw9714.c                         |  56 +-
 drivers/memory/mtk-smi.c                           |   3 +
 drivers/net/arcnet/com20020-pci.c                  |  16 +-
 drivers/net/bonding/bond_main.c                    |   9 +-
 drivers/net/bonding/bond_options.c                 |   2 +
 drivers/net/can/spi/mcp251x.c                      |  15 +-
 drivers/net/can/usb/ems_usb.c                      |   7 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   8 +-
 drivers/net/can/usb/f81604.c                       |  45 +-
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c                |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  10 -
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          |   1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   3 -
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |   3 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   9 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  41 +-
 drivers/net/ethernet/intel/i40e/i40e_trace.h       |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   5 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  17 +-
 drivers/net/ethernet/intel/idpf/idpf_txrx.c        |   2 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  48 +-
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |  27 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_main.c  |  50 +-
 .../ethernet/marvell/octeon_ep_vf/octep_vf_rx.c    |  28 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  15 +-
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  18 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |   9 +-
 drivers/net/ethernet/ti/icssg/icssg_prueth.c       |   8 +
 drivers/net/usb/kalmia.c                           |   7 +
 drivers/net/usb/kaweth.c                           |  13 +
 drivers/net/usb/pegasus.c                          |  13 +-
 drivers/net/vxlan/vxlan_core.c                     |   5 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   1 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   2 +-
 drivers/net/wireless/st/cw1200/pm.c                |   2 +
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/nfc/pn533/usb.c                            |   1 +
 drivers/nvme/host/core.c                           |   7 +
 drivers/nvme/host/pr.c                             |  10 +-
 drivers/of/kexec.c                                 |  15 +-
 drivers/pci/controller/dwc/pcie-designware-ep.c    |  38 +-
 drivers/pci/endpoint/pci-epc-core.c                | 182 ++++--
 drivers/pci/probe.c                                |   6 +-
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c           |   5 +-
 drivers/pinctrl/pinctrl-equilibrium.c              |  31 +-
 drivers/platform/x86/dell/dell-wmi-base.c          |   6 +
 .../dell/dell-wmi-sysman/passwordattr-interface.c  |   1 -
 drivers/platform/x86/thinkpad_acpi.c               |   6 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/lpfc/lpfc_sli.c                       |  36 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   3 +
 drivers/scsi/pm8001/pm8001_sas.c                   |   5 +-
 drivers/scsi/scsi_scan.c                           |   1 +
 drivers/staging/media/tegra-video/vi.c             |  13 +-
 drivers/target/target_core_configfs.c              |  15 +-
 drivers/ufs/core/ufshcd.c                          |  18 +-
 drivers/usb/cdns3/core.c                           |  11 +-
 drivers/xen/xen-acpi-processor.c                   |   7 +-
 fs/btrfs/block-group.c                             |  43 +-
 fs/btrfs/direct-io.c                               |  16 +
 fs/btrfs/disk-io.c                                 |   6 +-
 fs/btrfs/inode.c                                   |   2 +-
 fs/btrfs/misc.h                                    |   7 +
 fs/btrfs/scrub.c                                   |   2 +-
 fs/btrfs/space-info.c                              |  22 +-
 fs/btrfs/tree-checker.c                            |   4 +-
 fs/btrfs/zoned.c                                   | 271 +++++++-
 fs/eventpoll.c                                     |   5 +-
 fs/ext4/ext4.h                                     |  43 +-
 fs/ext4/extents.c                                  |  20 +-
 fs/ext4/mballoc-test.c                             |   4 -
 fs/ext4/mballoc.c                                  | 718 ++++++++++++---------
 fs/ext4/mballoc.h                                  |   9 +-
 fs/namespace.c                                     |  20 +-
 fs/nfsd/nfsctl.c                                   |   2 +-
 fs/smb/client/connect.c                            |   1 -
 fs/smb/client/smb2inode.c                          |   4 +-
 fs/smb/client/smb2pdu.c                            |  24 +-
 fs/smb/client/transport.c                          |  21 +-
 fs/smb/server/mgmt/user_session.c                  |   5 +
 fs/smb/server/mgmt/user_session.h                  |   1 +
 fs/smb/server/smb2pdu.c                            |  21 +-
 fs/squashfs/cache.c                                |   3 +
 fs/xattr.c                                         |  35 +-
 include/linux/ima.h                                |   4 +
 include/linux/indirect_call_wrapper.h              |  18 +-
 include/linux/ioport.h                             |  32 +
 include/linux/kexec.h                              |   6 +
 include/linux/libata.h                             |   4 +-
 include/linux/mailbox_client.h                     |   2 +-
 include/linux/mailbox_controller.h                 |   9 +-
 include/linux/pci-epc.h                            |  38 ++
 include/linux/platform_data/max6639.h              |  15 -
 include/linux/ring_buffer.h                        |   1 +
 include/linux/sched.h                              |   1 +
 include/linux/workqueue.h                          |   8 +-
 include/net/act_api.h                              |   1 +
 include/net/bonding.h                              |   1 +
 include/net/ip_fib.h                               |   2 +-
 include/net/netfilter/nf_tables.h                  |   5 +
 include/net/sch_generic.h                          |  10 +
 include/net/tc_act/tc_ife.h                        |   4 +-
 include/net/xdp_sock_drv.h                         |  24 +-
 include/net/xsk_buff_pool.h                        |   3 +-
 include/uapi/linux/pci_regs.h                      |   2 +-
 kernel/bpf/devmap.c                                |  22 +-
 kernel/bpf/trampoline.c                            |   4 +-
 kernel/cgroup/cpuset.c                             |   2 +-
 kernel/events/core.c                               |  42 +-
 kernel/events/uprobes.c                            |  38 +-
 kernel/kexec_core.c                                |  54 ++
 kernel/rseq.c                                      |   5 +-
 kernel/sched/fair.c                                | 184 ++----
 kernel/trace/ring_buffer.c                         |  21 +
 kernel/trace/trace.c                               |  13 +
 kernel/trace/trace_events_trigger.c                |   3 +
 kernel/workqueue.c                                 |  13 +-
 net/atm/lec.c                                      |  26 +-
 net/bridge/br_device.c                             |   2 +-
 net/bridge/br_input.c                              |   2 +-
 net/can/bcm.c                                      |   1 +
 net/core/filter.c                                  |   6 +-
 net/ipv4/sysctl_net_ipv4.c                         |   5 +-
 net/ipv6/route.c                                   |  11 +-
 net/mac80211/mesh.c                                |   3 +
 net/mac80211/mlme.c                                |   3 +
 net/netfilter/nf_tables_api.c                      |   5 -
 net/netfilter/nft_set_pipapo.c                     |  51 +-
 net/netfilter/nft_set_pipapo.h                     |   2 +
 net/nfc/nci/core.c                                 |  21 +-
 net/nfc/nci/data.c                                 |  12 +-
 net/nfc/rawsock.c                                  |  11 +
 net/rds/tcp.c                                      |  14 +-
 net/sched/act_ct.c                                 |   6 +
 net/sched/act_ife.c                                |  93 ++-
 net/sched/cls_api.c                                |   7 +
 net/sched/sch_ets.c                                |  12 +-
 net/sched/sch_fq.c                                 |   1 +
 net/wireless/core.c                                |   1 +
 net/wireless/radiotap.c                            |   4 +-
 net/xdp/xsk.c                                      |  30 +-
 net/xdp/xsk_buff_pool.c                            |  15 +-
 rust/kernel/kunit.rs                               |   8 +
 security/apparmor/apparmorfs.c                     | 225 ++++---
 security/apparmor/include/label.h                  |  16 +-
 security/apparmor/include/lib.h                    |  12 +
 security/apparmor/include/match.h                  |   1 +
 security/apparmor/include/policy.h                 |  10 +-
 security/apparmor/include/policy_ns.h              |   2 +
 security/apparmor/include/policy_unpack.h          |  83 ++-
 security/apparmor/label.c                          |  12 +-
 security/apparmor/match.c                          |  58 +-
 security/apparmor/policy.c                         |  77 ++-
 security/apparmor/policy_ns.c                      |   2 +
 security/apparmor/policy_unpack.c                  |  65 +-
 security/integrity/ima/ima_kexec.c                 | 148 ++++-
 sound/pci/hda/cs35l56_hda.c                        |  14 +-
 sound/pci/hda/patch_conexant.c                     |  11 +
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/usb/endpoint.c                               |   9 +-
 sound/usb/mixer_scarlett2.c                        |  14 +-
 sound/usb/quirks.c                                 |   2 +-
 sound/usb/validate.c                               |   2 +-
 tools/testing/kunit/kunit_kernel.py                |   6 +-
 tools/testing/kunit/kunit_tool_test.py             |  26 +
 tools/testing/selftests/arm64/abi/hwcap.c          |   4 +-
 tools/testing/selftests/kselftest_harness.h        |  15 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  13 +
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  11 +-
 243 files changed, 3739 insertions(+), 1793 deletions(-)


