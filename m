Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1C35A3AD;
	Mon,  4 May 2026 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904427; cv=none; b=lDKQtvz/e0lmlL/XYwqGXV5JUTrkvaDQ7YoIvOaVtZxx1TRFu71o5RY3eXkTiShSWOoXDqeEFx4q/VltXY0hIWg6VnQmLR1RhjOhRYAm059GH1VslePHM0HaU27i1ug7XTlIJCXSr0pe9DrK7s797/dK7KQcYQ1V19zv95IVaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904427; c=relaxed/simple;
	bh=6SliBeRHylSROT9AhwbXCdkJAPJbU9o6mwOlycp34ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Tzpr4soo5qzT/x0HGqhDwxWzEHg0smyoNKU1xu21thRXcIIhpyia6iwvdZ3tPx5wZQPowdB5a2X0LMNc08ViwCRWH0tbqstMCQdM3k1i6Ind5DyCZ2GOpMbqmIXgGyUH/Ab0Qu4qJH+O2ofOg0F20vqDAQa00mi4gSmxnTk9HfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtjYZDp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtjYZDp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658A1C2BCB8;
	Mon,  4 May 2026 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904427;
	bh=6SliBeRHylSROT9AhwbXCdkJAPJbU9o6mwOlycp34ro=;
	h=From:To:Cc:Subject:Date:From;
	b=PtjYZDp7bhWy5Gw5bigBeYHvm31DKNI+Xx9To5ABRSxmQpgQY2xBSYGAB9GuDxIMS
	 WzHPCpECX4Y8O3DrV9jjD2mUFBVM22KuSKVHZOJhk2qVOO2URlJXzMjJWH9KjfBscX
	 DZkeEsprdBH8QHTQT112Uy3u19Fkeb7nI6DDhP+U=
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
Subject: [PATCH 6.12 000/215] 6.12.86-rc1 review
Date: Mon,  4 May 2026 15:50:19 +0200
Message-ID: <20260504135130.169210693@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.86-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.12.86-rc1
X-KernelTest-Deadline: 2026-05-06T13:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.12.86 release.
There are 215 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 06 May 2026 13:50:52 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.86-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.12.86-rc1

Kai Ma <k4729.23098@gmail.com>
    netfilter: reject zero shift in nft_bitwise

Andrea Mayer <andrea.mayer@uniroma2.it>
    net: ipv6: fix NOREF dst use in seg6 and rpl lwtunnels

Deepanshu Kartikey <kartikey406@gmail.com>
    ALSA: caiaq: fix usb_dev refcount leak on probe failure

Arjan van de Ven <arjan@linux.intel.com>
    drm/amdgpu: fix zero-size GDS range init on RDNA4

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ipv6: rpl: reserve mac_len headroom when recompressed SRH grows

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxrpc_input_call_event() to only unshare DATA packets

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Don't abort when no input device is available

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Fix potentially leftover ep1_in_urb at error path

Douglas Anderson <dianders@chromium.org>
    driver core: Add kernel-doc for DEV_FLAG_COUNT enum value

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix use-after-free in bond_xmit_broadcast()

Yucheng Lu <kanolyc@gmail.com>
    crypto: authencesn - reject short ahash digests during instance creation

Anthony Yznaga <anthony.yznaga@oracle.com>
    mm: prevent droppable mappings from being locked

Johan Hovold <johan@kernel.org>
    spi: fix resource leaks on device setup failure

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the total number of nodes

Yuan Zhaoming <yuanzm2@lenovo.com>
    net: mctp: fix don't require received header reserved bits to be zero

Zhengchuan Liang <zcliangcn@gmail.com>
    net: bridge: use a stable FDB dst snapshot in RCU readers

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum number of lookups

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Limit the maximum server registration per node

David Howells <dhowells@redhat.com>
    rxrpc: Fix potential UAF after skb_unshare() failure

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: admv1013: fix NULL pointer dereference on str

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: frequency: admv1013: add dev variable

Naman Jain <namjain@linux.microsoft.com>
    block: relax pgmap check in bio_add_page for compatible zone device pages

Long Li <longli@microsoft.com>
    RDMA/mana_ib: Disable RX steering on RSS QP destroy

Oliver Neukum <oneukum@suse.com>
    media: rc: igorplugusb: heed coherency rules

Thorsten Blum <thorsten.blum@linux.dev>
    ALSA: aoa: Skip devices with no codecs in i2sbus_resume()

Oliver Neukum <oneukum@suse.com>
    media: rc: ttusbir: respect DMA coherency rules

Shigeru Yoshida <syoshida@redhat.com>
    mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aoa: i2sbus: clear stale prepared state

Takashi Iwai <tiwai@suse.de>
    ALSA: aoa: Use guard() for mutex locks

Usama Arif <usama.arif@linux.dev>
    mm: migrate: requeue destination folio on deferred split queue

David Hildenbrand <david@redhat.com>
    mm/migrate: move movable_ops page handling out of move_to_new_folio()

David Hildenbrand <david@redhat.com>
    mm/migrate: factor out movable_ops page handling into migrate_movable_ops_page()

Daniel Hodges <git@danielhodges.dev>
    wifi: mwifiex: fix use-after-free in mwifiex_adapter_cleanup()

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: fix mt7925u USB WFSYS reset handling

Sean Wang <sean.wang@mediatek.com>
    wifi: mt76: mt792x: describe USB WFSYS reset with a descriptor

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    thermal: core: Fix thermal zone governor cleanup issues

DaeMyung Kang <charsyam@gmail.com>
    ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: replace connection list with hash table

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: use msleep instaed of schedule_timeout_interruptible()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on dcc->discard_cmd_cnt conditionally

Alistair Popple <apopple@nvidia.com>
    lib: test_hmm: evict device pages on file close to avoid use-after-free

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix UAF caused by decrementing sbi->nr_pages[] in f2fs_write_end_io()

Michael Bommarito <michael.bommarito@gmail.com>
    smb: client: validate the whole DACL before rewriting it in cifsacl

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: fix seg6 lwtunnel output redirect for L2 reduced encap mode

Yang Xiuwei <yangxiuwei@kylinos.cn>
    scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails

Keenan Dong <keenanat2000@gmail.com>
    rtmutex: Use waiter::task instead of current in remove_waiter()

Tobias Gaertner <tob.gaertner@me.com>
    ntfs3: fix integer overflow in run_unpack() volume boundary check

Tobias Gaertner <tob.gaertner@me.com>
    ntfs3: add buffer boundary checks to run_unpack()

Steven Rostedt <rostedt@goodmis.org>
    ktest: Fix the month in the name of the failure directory

Chen Zhao <chezhao@nvidia.com>
    IB/core: Fix zero dmac race in neighbor resolution

Max Kellermann <max.kellermann@ionos.com>
    ceph: only d_add() negative dentries when they are unhashed

Junrui Luo <moonafterrain@outlook.com>
    dm mirror: fix integer overflow in create_dirty_log()

Gustavo A. R. Silva <gustavoars@kernel.org>
    crypto: nx - Fix packed layout in struct nx842_crypto_header

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix uninitialized data access on OTP read error

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix error codes in OTP reads

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-tdes - fix DMA sync direction

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    crypto: ccree - fix a memory leak in cc_mac_digest()

Thomas Fourier <fourier.thomas@gmail.com>
    crypto: hisilicon - Fix dma_unmap_single() direction

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-ecc - Release client on allocation failure

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-aes - Fix 3-page memory leak in atmel_aes_buff_cleanup

Eric Biggers <ebiggers@kernel.org>
    crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit

Johan Hovold <johan@kernel.org>
    can: ucan: fix devres lifetime

Qiang Yu <qiang.yu@oss.qualcomm.com>
    bus: mhi: host: pci_generic: Switch to async power up to avoid boot delays

Shuvam Pandey <shuvampandey1@gmail.com>
    Bluetooth: hci_event: fix potential UAF in SSP passkey handlers

Cengiz Can <cengiz.can@canonical.com>
    apparmor: use target task's context in apparmor_getprocattr()

Brian Mak <makb@juniper.net>
    mfd: core: Preserve OF node when ACPI handle is present

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: set version in TGID exit notifications

Zhenzhong Wu <jt26wzz@gmail.com>
    tcp: call sk_data_ready() after listener migration

Yi Cong <yicong@kylinos.cn>
    wifi: rtl8xxxu: fix potential use of uninitialized value

Dave Hansen <dave.hansen@linux.intel.com>
    x86/cpu: Disable FRED when PTI is forced on

Chia-Ming Chang <chiamingc@synology.com>
    inotify: fix watch count leak when fsnotify_add_inode_mark_locked() fails

Aditya Garg <gargaditya08@live.com>
    HID: apple: ensure the keyboard backlight is off if suspending

Arnd Bergmann <arnd@arndb.de>
    check-uapi: link into shared objects

Junrui Luo <moonafterrain@outlook.com>
    md/raid5: validate payload size before accessing journal metadata

Chia-Ming Chang <chiamingc@synology.com>
    md/raid5: fix soft lockup in retry_aligned_read()

David (Ming Qiang) Wu <David.Wu3@amd.com>
    amdgpu/jpeg: fix deepsleep register for jpeg 5_0_0 and 5_0_2

Sanjaikumar V S <sanjaikumar.vs@dicortech.com>
    mtd: spi-nor: sst: Fix write enable before AAI sequence

Sohei Koyama <skoyama@ddn.com>
    ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access

Rong Bao <rong.bao@csmantle.top>
    perf annotate: Use jump__delete when freeing LoongArch jumps

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: fix multishot recv missing EOF on wakeup race

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Always intercept VMMCALL when L2 is active

Kevin Cheng <chengkev@google.com>
    KVM: nSVM: Raise #UD if unhandled VMMCALL isn't intercepted by L1

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Add missing consistency check for nCR3 validity

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear tracking of L1->L2 NMI and soft IRQ on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear EVENTINJ fields in vmcb12 on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Clear GIF on nested #VMEXIT(INVALID)

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Always inject a #GP if mapping VMCB12 fails on nested VMRUN

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on nested #VMEXIT

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Ensure AVIC is inhibited when restoring a vCPU to guest mode

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts

Kevin Cheng <chengkev@google.com>
    KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2

Yosry Ahmed <yosry@kernel.org>
    KVM: nSVM: Sync NextRIP to cached vmcb12 after VMRUN of L2

Yosry Ahmed <yosry.ahmed@linux.dev>
    KVM: nSVM: Mark all of vmcb02 dirty when restoring nested state

Sean Christopherson <seanjc@google.com>
    KVM: x86: Defer non-architectural deliver of exception payload to userspace read

Denis M. Karpov <komlomal@gmail.com>
    userfaultfd: allow registration of ranges below mmap_min_addr

SeongJae Park <sj@kernel.org>
    mm/damon/core: use time_in_range_open() for damos quota window start

Johan Hovold <johan@kernel.org>
    rtc: ntxec: fix OF node reference imbalance

Jacqueline Wong <jacqwong@google.com>
    tpm: tpm_tis: stop transmit if retries are exhausted

Jacqueline Wong <jacqwong@google.com>
    tpm: tpm_tis: add error logging for data transfer

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm: Use kfree_sensitive() to free auth session in tpm_dev_release()

Gunnar Kudrjavets <gunnarku@amazon.com>
    tpm: Fix auth session leak in tpm2_get_random() error path

Viorel Suman (OSS) <viorel.suman@oss.nxp.com>
    pwm: imx-tpm: Count the number of enabled channels in probe

Paul Louvel <paul.louvel@bootlin.com>
    crypto: talitos - rename first/last to first_desc/last_desc

Paul Louvel <paul.louvel@bootlin.com>
    crypto: talitos - fix SEC1 32k ahash request limitation

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: google: framebuffer: Do not unregister platform device

Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
    xfs: fix a resource leak in xfs_alloc_buftarg()

Francesco Dolcini <francesco.dolcini@toradex.com>
    arm64: dts: ti: am62-verdin: Enable pullup for eMMC data pins

Shawn Lin <shawn.lin@rock-chips.com>
    mmc: sdhci-of-dwcmshc: Disable clock before DLL configuration

Bin Liu <b-liu@ti.com>
    mmc: block: use single block write in retry

Ryan Roberts <ryan.roberts@arm.com>
    randomize_kstack: Maintain kstack_offset per task

Sanman Pradhan <psanman@juniper.net>
    hwmon: (pt5161l) Fix bugs in pt5161l_read_block_data()

Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
    power: supply: axp288_charger: Do not cancel work before initializing it

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Show CPU vulnerabilites correctly

Arnd Bergmann <arnd@arndb.de>
    tpm: avoid -Wunused-but-set-variable

Nathan Chancellor <nathan@kernel.org>
    extract-cert: Wrap key_pass with '#ifdef USE_PKCS11_ENGINE'

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Prevent potential null-ptr-deref in ceph_handle_auth_reply()

Ruide Cao <caoruide123@gmail.com>
    ipv4: icmp: validate reply type before using icmp_pointers

hkbinbin <hkbinbinbin@gmail.com>
    RDMA/rxe: Validate pad and ICRC before payload_size() in rxe_rcv

Luca Ceresoli <luca.ceresoli@bootlin.com>
    drm/arcpgu: fix device node leak

Marek Vasut <marex@nabladev.com>
    net: ks8851: Avoid excess softirq scheduling

Breno Leitao <leitao@debian.org>
    netconsole: avoid out-of-bounds access on empty string in trim_newline()

Marek Vasut <marex@nabladev.com>
    net: ks8851: Reinstate disabling of BHs around IRQ handler

Ruijie Li <ruijieli51@gmail.com>
    net/smc: avoid early lgr access in smc_clc_wait_msg

Jiawen Wu <jiawenwu@trustnetic.com>
    net: txgbe: fix firmware version check

Ao Zhou <draw51280@163.com>
    net: rds: fix MR cleanup on copy error

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Free the node during ctrl_cmd_bye()

Robert Marko <robert.marko@sartura.hr>
    arm64: dts: marvell: uDPU: add ethernet aliases

Yiyang Chen <cyyzero16@gmail.com>
    tools/accounting: handle truncated taskstats netlink messages

David Howells <dhowells@redhat.com>
    rxrpc: Fix re-decryption of RESPONSE packets

David Howells <dhowells@redhat.com>
    rxrpc: Fix rxkad crypto unalignment handling

David Howells <dhowells@redhat.com>
    rxrpc: Fix memory leaks in rxkad_verify_response()

Jonathan Santos <Jonathan.Santos@analog.com>
    iio: adc: ad7768-1: fix one-shot mode data acquisition

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: pcmtest: Fix resource leaks in module init error paths

Guangshuo Li <lgs201920130244@gmail.com>
    ALSA: pcmtest: fix reference leak on failed device registration

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: 6fire: Fix input volume change detection

Takashi Iwai <tiwai@suse.de>
    ALSA: caiaq: Handle probe errors properly

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: caiaq: Fix control_put() result and cache rollback

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Fix potential data race at fasync handling

Jens Axboe <axboe@kernel.dk>
    io_uring/poll: ensure EPOLL_ONESHOT is propagated for EPOLL_URING_WAKE

Longxuan Yu <ylong030@ucr.edu>
    io_uring/poll: fix signed comparison in io_poll_get_ownership()

David Lechner <dlechner@baylibre.com>
    iio: adc: ti-ads7950: use iio_push_to_buffers_with_ts_unaligned()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/timeout: check unused sqe fields

Damien Le Moal <dlemoal@kernel.org>
    block: fix zone write plugs refcount handling in disk_zone_wplug_schedule_bio_work()

Dawei Feng <dawei.feng@seu.edu.cn>
    rbd: fix null-ptr-deref when device_add_disk() fails

Mickaël Salaün <mic@digikod.net>
    selftests/landlock: Fix format warning for __u64 in net_test

Simon Liebold <simonlie@amazon.de>
    selftests/mqueue: Fix incorrectly named file

Joseph Salisbury <joseph.salisbury@oracle.com>
    sched: Use u64 for bandwidth ratio calculations

Ben Levinsky <ben.levinsky@amd.com>
    remoteproc: xlnx: Only access buffer information if IPI is buffered

Helge Deller <deller@gmx.de>
    parisc: _llseek syscall is only available for 32-bit userspace

Robert Beckett <bob.beckett@collabora.com>
    nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set

Robert Beckett <bob.beckett@collabora.com>
    nvme-pci: add NVME_QUIRK_DISABLE_WRITE_ZEROES for Kingston OM3SGP4

James Kim <james010kim@gmail.com>
    mtd: docg3: fix use-after-free in docg3_release()

Marek Vasut <marex@nabladev.com>
    mfd: stpmic1: Attempt system shutdown twice in case PMIC is confused

Josh Hunt <johunt@akamai.com>
    md/raid10: fix deadlock with check operation and nowait requests

Zhang Yi <yi.zhang@huawei.com>
    jbd2: fix deadlock in jbd2_journal_cancel_revoke()

Gao Xiang <xiang@kernel.org>
    erofs: fix the out-of-bounds nameoff handling for trailing dirents

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: seq_oss: return full count for successful SEQ_FULLSIZE writes

Harin Lee <me@harin.net>
    ALSA: ctxfi: Add fallback to default RSR for S/PDIF

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: aoa: i2sbus: fix OF node lifetime handling

Vasiliy Kovalev <kovalev@altlinux.org>
    ext2: reject inodes with zero i_nlink and valid mode in ext2_iget()

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    net: qrtr: ns: Fix use-after-free in driver remove()

Chen Ni <nichen@iscas.ac.cn>
    media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()

Josh Law <objecting@objecting.org>
    lib/ts_kmp: fix integer overflow in pattern length calculation

Daniel Hodges <git@danielhodges.dev>
    PCI: epf-mhi: Return 0, not remaining timeout, when eDMA ops complete

Rong Zhang <i@rong.moe>
    Revert "ALSA: usb: Increase volume range that triggers a warning"

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-ntb: Remove duplicate resource teardown

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: atmel-sha204a - Fix OTP sysfs read and error handling

Fan Wu <fanwu01@zju.edu.cn>
    media: mtk-jpeg: fix use-after-free in release path due to uncancelled work

Luxiao Xu <rakukuip@gmail.com>
    net: strparser: fix skb_head leak in strp_abort_strp()

Zhengchuan Liang <zcliangcn@gmail.com>
    net: caif: clear client service pointer on teardown

Ziqing Chen <chenziqing@xiaomi.com>
    ALSA: control: Validate buf_len before strnlen() in snd_ctl_elem_init_enum_names()

Ming Qian <ming.qian@oss.nxp.com>
    media: amphion: Fix race between m2m job_abort and device_run

Sanman Pradhan <psanman@juniper.net>
    hwmon: (powerz) Fix missing usb_kill_urb() on signal interrupt

Wentao Liang <vulab@iscas.ac.cn>
    of: unittest: fix use-after-free in testdrv_probe()

Wentao Liang <vulab@iscas.ac.cn>
    of: unittest: fix use-after-free in of_unittest_changeset()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix handling of MAY_BACKLOG requests

Jinjiang Tu <tujinjiang@huawei.com>
    mm/memory_hotplug: fix hwpoisoned large folio handling in do_migrate_range()

Johan Hovold <johan@kernel.org>
    spi: ch341: fix memory leaks on probe failures

Johan Hovold <johan@kernel.org>
    spi: imx: fix use-after-free on unbind

Michael Bommarito <michael.bommarito@gmail.com>
    um: drivers: call kernel_strrchr() explicitly in cow_user.c

Prasanna Kumar T S M <ptsm@linux.microsoft.com>
    vfio/cdx: Fix NULL pointer dereference in interrupt trigger path

Alex Williamson <alex.williamson@nvidia.com>
    vfio/cdx: Serialize VFIO_DEVICE_SET_IRQS with a per-device mutex

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: rtw88: check for PCI upstream bridge existence

Sergey Senozhatsky <senozhatsky@chromium.org>
    zram: do not forget to endio for partial discard requests

Heming Zhao <heming.zhao@suse.com>
    ocfs2: split transactions in dio completion to avoid credit exhaustion

Douglas Anderson <dianders@chromium.org>
    device property: Make modifications of fwnode "flags" thread safe

Jesse.Zhang <Jesse.Zhang@amd.com>
    drm/amdgpu: Limit BO list entry count to prevent resource exhaustion

Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
    drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array

Miguel Ojeda <ojeda@kernel.org>
    rust: init: fix `clippy::undocumented_unsafe_blocks` warnings

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Remove comment for reorder_work

Herbert Xu <herbert@gondor.apana.org.au>
    padata: Fix pd UAF once and for all

Anshuman Khandual <anshuman.khandual@arm.com>
    arm64/mm: Enable batched TLB flush in unmap_hotplug_range()

Thomas Zimmermann <tzimmermann@suse.de>
    firmware: google: framebuffer: Do not mark framebuffer as busy

Miguel Ojeda <ojeda@kernel.org>
    kbuild: rust: allow `clippy::uninlined_format_args`

David Carlier <devnexen@gmail.com>
    drm/nouveau: fix nvkm_device leak on aperture removal failure

Douglas Anderson <dianders@chromium.org>
    driver core: Don't let a device probe until it's ready

Tyllis Xu <livelycarpet87@gmail.com>
    ibmasm: fix heap over-read in ibmasm_send_i2o_message()

Tyllis Xu <livelycarpet87@gmail.com>
    ibmasm: fix OOB reads in command_file_write due to missing size checks

Tyllis Xu <livelycarpet87@gmail.com>
    misc: ibmasm: fix OOB MMIO read in ibmasm_handle_mouse_interrupt()

Weigang He <geoffreyhe2@gmail.com>
    greybus: gb-beagleplay: fix sleep in atomic context in hdlc_tx_frames()

Pengpeng Hou <pengpeng@iscas.ac.cn>
    greybus: gb-beagleplay: bound bootloader receive buffering

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    leds: qcom-lpg: Check for array overflow when selecting the high resolution

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/nouveau: fix u32 overflow in pushbuf reloc bounds check

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    LoongArch: Add spectre boundry for syscall dispatch table

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Evaluate packsize caps at the right place

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: core: allow ci_irq_handler() handle both ID and VBUS change

Xu Yang <xu.yang_2@nxp.com>
    usb: chipidea: otg: not wait vbus drop if use role_switch

Michal Pecio <michal.pecio@gmail.com>
    usb: xhci: Make usb_host_endpoint.hcpriv survive endpoint_disable()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: Avoid false E-MU sample-rate notifications

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES


-------------

Diffstat:

 Makefile                                           |   5 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi  |   5 +
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi         |  20 +-
 arch/arm64/crypto/aes-modes.S                      |   4 +-
 arch/arm64/mm/mmu.c                                |  36 ++-
 arch/loongarch/kernel/cpu-probe.c                  |   7 +
 arch/loongarch/kernel/syscall.c                    |   3 +-
 arch/parisc/kernel/syscalls/syscall.tbl            |   2 +-
 arch/um/drivers/cow_user.c                         |   8 +-
 arch/x86/kvm/hyperv.h                              |   8 -
 arch/x86/kvm/svm/hyperv.h                          |   9 +-
 arch/x86/kvm/svm/nested.c                          |  55 ++--
 arch/x86/kvm/svm/svm.c                             |  32 +-
 arch/x86/kvm/svm/svm.h                             |   1 +
 arch/x86/kvm/x86.c                                 |  62 ++--
 arch/x86/mm/pti.c                                  |   5 +
 block/bio-integrity.c                              |   2 +
 block/bio.c                                        |  14 +-
 block/blk-zoned.c                                  |  12 +-
 block/blk.h                                        |  19 ++
 certs/extract-cert.c                               |   6 +-
 crypto/authencesn.c                                |   5 +
 crypto/pcrypt.c                                    |   7 +-
 drivers/base/core.c                                |  39 ++-
 drivers/base/dd.c                                  |  20 ++
 drivers/block/rbd.c                                |   6 +-
 drivers/block/zram/zram_drv.c                      |   3 +-
 drivers/bus/imx-weim.c                             |   2 +-
 drivers/bus/mhi/host/pci_generic.c                 |   2 +-
 drivers/char/tpm/tpm-chip.c                        |   2 +-
 drivers/char/tpm/tpm2-cmd.c                        |   6 +-
 drivers/char/tpm/tpm_tis_core.c                    |  11 +-
 drivers/crypto/atmel-aes.c                         |   2 +-
 drivers/crypto/atmel-ecc.c                         |   1 +
 drivers/crypto/atmel-i2c.c                         |   4 +-
 drivers/crypto/atmel-sha204a.c                     |  37 ++-
 drivers/crypto/atmel-tdes.c                        |   8 +-
 drivers/crypto/ccree/cc_hash.c                     |   1 +
 drivers/crypto/hisilicon/sec/sec_algs.c            |   2 +-
 drivers/crypto/nx/nx-842.h                         |   4 +-
 drivers/crypto/talitos.c                           | 340 +++++++++++++--------
 drivers/firmware/google/framebuffer-coreboot.c     |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |  43 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c           |  52 +++-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   2 +-
 drivers/gpu/drm/tiny/arcpgu.c                      |   3 +-
 drivers/greybus/gb-beagleplay.c                    | 112 ++++++-
 drivers/hid/hid-apple.c                            |   2 +
 drivers/hwmon/powerz.c                             |  11 +-
 drivers/hwmon/pt5161l.c                            |   4 +-
 drivers/i2c/i2c-core-of.c                          |   2 +-
 drivers/iio/adc/ad7768-1.c                         |   9 +-
 drivers/iio/adc/ti-ads7950.c                       |  11 +-
 drivers/iio/frequency/admv1013.c                   |  90 +++---
 drivers/infiniband/core/addr.c                     |   3 +
 drivers/infiniband/hw/mana/qp.c                    |  15 +
 drivers/infiniband/sw/rxe/rxe_recv.c               |   3 +-
 drivers/leds/rgb/leds-qcom-lpg.c                   |   7 +-
 drivers/md/dm-raid1.c                              |   6 +-
 drivers/md/raid10.c                                |   4 +-
 drivers/md/raid5-cache.c                           |  48 ++-
 drivers/md/raid5.c                                 |   8 +-
 drivers/media/i2c/imx219.c                         |   3 +
 drivers/media/platform/amphion/vpu_v4l2.c          |   9 +-
 .../media/platform/mediatek/jpeg/mtk_jpeg_core.c   |   1 +
 drivers/media/rc/igorplugusb.c                     |  16 +-
 drivers/media/rc/ttusbir.c                         |  13 +-
 drivers/mfd/mfd-core.c                             |  12 +-
 drivers/mfd/stpmic1.c                              |  20 +-
 drivers/misc/ibmasm/ibmasmfs.c                     |   7 +
 drivers/misc/ibmasm/lowlevel.c                     |  12 +-
 drivers/misc/ibmasm/remote.c                       |   5 +
 drivers/mmc/core/block.c                           |  12 +-
 drivers/mmc/core/queue.h                           |   3 +
 drivers/mmc/host/sdhci-of-dwcmshc.c                |  19 +-
 drivers/mtd/devices/docg3.c                        |   3 +-
 drivers/mtd/spi-nor/sst.c                          |  13 +
 drivers/net/bonding/bond_main.c                    |  12 +-
 drivers/net/can/usb/ucan.c                         |   2 +-
 drivers/net/ethernet/micrel/ks8851.h               |   6 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |  69 ++---
 drivers/net/ethernet/micrel/ks8851_par.c           |  15 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |  11 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  11 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   3 +-
 drivers/net/netconsole.c                           |   2 +
 drivers/net/phy/mdio_bus.c                         |   4 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |   2 +-
 drivers/net/wireless/mediatek/mt76/mt792x_regs.h   |   4 +
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |  51 +++-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  28 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   3 +-
 drivers/nvme/host/core.c                           |   2 +-
 drivers/nvme/host/pci.c                            |   2 +
 drivers/of/base.c                                  |   2 +-
 drivers/of/dynamic.c                               |   2 +-
 drivers/of/platform.c                              |   2 +-
 drivers/of/unittest.c                              |   4 +-
 drivers/pci/endpoint/functions/pci-epf-mhi.c       |   4 +
 drivers/pci/endpoint/functions/pci-epf-ntb.c       |  56 +---
 drivers/power/supply/axp288_charger.c              |  19 +-
 drivers/pwm/pwm-imx-tpm.c                          |   9 +-
 drivers/remoteproc/xlnx_r5_remoteproc.c            |  20 +-
 drivers/rtc/rtc-ntxec.c                            |   2 +-
 drivers/scsi/sd.c                                  |   1 +
 drivers/spi/spi-ch341.c                            |  36 ++-
 drivers/spi/spi-imx.c                              |   4 +
 drivers/spi/spi.c                                  |  63 ++--
 drivers/thermal/thermal_core.c                     |   7 +-
 drivers/usb/chipidea/core.c                        |  45 +--
 drivers/usb/chipidea/otg.c                         |   7 +-
 drivers/usb/host/xhci.c                            |   1 -
 drivers/vfio/cdx/intr.c                            |  13 +-
 drivers/vfio/cdx/main.c                            |  19 ++
 drivers/vfio/cdx/private.h                         |   3 +
 fs/ceph/dir.c                                      |   6 +-
 fs/erofs/dir.c                                     |  28 +-
 fs/ext2/inode.c                                    |  14 +-
 fs/ext4/xattr.c                                    |   6 +-
 fs/f2fs/data.c                                     |   4 +-
 fs/f2fs/f2fs.h                                     |   2 +-
 fs/f2fs/segment.c                                  |   6 +-
 fs/f2fs/super.c                                    |  11 +-
 fs/jbd2/revoke.c                                   |   8 +-
 fs/notify/inotify/inotify_user.c                   |   1 +
 fs/ntfs3/run.c                                     |  18 +-
 fs/ocfs2/aops.c                                    |  74 +++--
 fs/smb/client/cifsacl.c                            | 116 +++++--
 fs/smb/server/connection.c                         |  28 +-
 fs/smb/server/connection.h                         |   6 +-
 fs/smb/server/smb2pdu.c                            |   4 +-
 fs/smb/server/transport_rdma.c                     |   5 +
 fs/smb/server/transport_tcp.c                      |  25 +-
 fs/userfaultfd.c                                   |   2 -
 fs/xfs/xfs_buf.c                                   |   1 +
 include/linux/device.h                             |  45 +++
 include/linux/fwnode.h                             |  44 ++-
 include/linux/hugetlb_inline.h                     |   4 +-
 include/linux/padata.h                             |   4 -
 include/linux/randomize_kstack.h                   |  26 +-
 include/linux/sched.h                              |   4 +
 include/linux/tpm_eventlog.h                       |   9 +-
 include/linux/usb.h                                |   3 +-
 include/net/mana/mana.h                            |   1 +
 include/net/mctp.h                                 |   3 +
 include/trace/events/rxrpc.h                       |   6 +-
 init/main.c                                        |   1 -
 io_uring/poll.c                                    |  15 +-
 io_uring/timeout.c                                 |   4 +
 kernel/fork.c                                      |   2 +
 kernel/locking/rtmutex.c                           |  13 +-
 kernel/padata.c                                    | 136 +++------
 kernel/sched/core.c                                |   2 +-
 kernel/sched/rt.c                                  |   2 +-
 kernel/sched/sched.h                               |   2 +-
 kernel/taskstats.c                                 |   1 +
 lib/test_hmm.c                                     |  86 +++---
 lib/ts_kmp.c                                       |  18 +-
 mm/damon/core.c                                    |   3 +-
 mm/internal.h                                      |  10 +
 mm/memory_hotplug.c                                |  10 +-
 mm/migrate.c                                       | 152 +++++----
 mm/mlock.c                                         |  10 +-
 mm/mmap.c                                          |   4 +-
 mm/zsmalloc.c                                      |   1 +
 net/bluetooth/hci_event.c                          |  18 +-
 net/bridge/br_arp_nd_proxy.c                       |   8 +-
 net/bridge/br_fdb.c                                |  28 +-
 net/caif/cfsrvl.c                                  |  14 +-
 net/ceph/auth.c                                    |   2 +-
 net/ipv4/icmp.c                                    |   5 +-
 net/ipv4/inet_connection_sock.c                    |   3 +
 net/ipv6/exthdrs.c                                 |   9 +-
 net/ipv6/rpl_iptunnel.c                            |   9 +
 net/ipv6/seg6_iptunnel.c                           |  12 +-
 net/mctp/route.c                                   |   8 +-
 net/netfilter/nft_bitwise.c                        |   3 +-
 net/qrtr/ns.c                                      |  86 +++++-
 net/rds/rdma.c                                     |   4 -
 net/rxrpc/ar-internal.h                            |   1 -
 net/rxrpc/call_event.c                             |  25 +-
 net/rxrpc/conn_event.c                             |  14 +-
 net/rxrpc/io_thread.c                              |  24 +-
 net/rxrpc/rxkad.c                                  | 112 +++----
 net/rxrpc/skbuff.c                                 |   9 -
 net/smc/smc_clc.c                                  |   4 +-
 net/strparser/strparser.c                          |   8 +
 rust/kernel/init/macros.rs                         |   7 +-
 scripts/check-uapi.sh                              |   7 +-
 security/apparmor/lsm.c                            |  16 +-
 sound/aoa/codecs/onyx.c                            | 104 ++-----
 sound/aoa/codecs/tas.c                             | 113 +++----
 sound/aoa/core/gpio-feature.c                      |  20 +-
 sound/aoa/core/gpio-pmf.c                          |  26 +-
 sound/aoa/soundbus/i2sbus/core.c                   |  12 +-
 sound/aoa/soundbus/i2sbus/pcm.c                    | 143 ++++-----
 sound/core/control.c                               |   4 +
 sound/core/misc.c                                  |  13 +-
 sound/core/seq/oss/seq_oss_rw.c                    |   6 +-
 sound/drivers/pcmtest.c                            |  19 +-
 sound/pci/ctxfi/ctatc.c                            |   3 +-
 sound/usb/6fire/control.c                          |  10 +-
 sound/usb/caiaq/control.c                          |  52 +++-
 sound/usb/caiaq/device.c                           |  35 ++-
 sound/usb/caiaq/input.c                            |   2 +-
 sound/usb/endpoint.c                               |   6 +-
 sound/usb/format.c                                 |   2 +-
 sound/usb/mixer.c                                  |   7 +-
 sound/usb/mixer_quirks.c                           |  12 +-
 tools/accounting/getdelays.c                       |  41 ++-
 tools/accounting/procacct.c                        |  40 ++-
 tools/perf/arch/loongarch/annotate/instructions.c  |   1 +
 tools/perf/util/disasm.c                           |   1 +
 tools/testing/ktest/ktest.pl                       |   2 +-
 tools/testing/selftests/landlock/net_test.c        |   2 +-
 .../testing/selftests/mqueue/{setting => settings} |   0
 218 files changed, 2506 insertions(+), 1555 deletions(-)


