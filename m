Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80098337699;
	Mon, 20 Apr 2026 15:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699893; cv=none; b=rTUPcIZOjWAmtR1lMZkoTj7vuXVtBrAd0lOn/jEW0fl067vf6uneNxjK4V+Hkf3MI6OumrPIJQ6mUm91i+NP97tCEsb1XB2ftqAcmmju27eip7zAtGcTO8Q1eNkemP3Cax++lobpa2iBq55oYGQWy3J+NZmJP6km+aKL73bsue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699893; c=relaxed/simple;
	bh=IZ7pRdy+gwj+I8kPs/+eS9eJC/gqZv5oW8WdymF1aD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XJAH5LIi4FghrJx6uqiKZCLetIQdZs1oMCdW7hK9FRRqkDXvuWW8LVvjWd5fXElVoroH5Vbk8JrEJHLMUQ1RxNGV7oZqCJi1XBpyLnIuzeW5kE99rgudT08nWLvQIxQ6XtGLY9YHI46k1x/fO2qaEom9qXCKHMZ9D8xY4OBrmq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0gFWny7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0gFWny7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3478C19425;
	Mon, 20 Apr 2026 15:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699893;
	bh=IZ7pRdy+gwj+I8kPs/+eS9eJC/gqZv5oW8WdymF1aD8=;
	h=From:To:Cc:Subject:Date:From;
	b=H0gFWny7YvqWgETzcIcuUWCZ/YLVtrPGLG/qszXf4/YDTH3Tk9DrTkKoUhagsk/xb
	 CacW0fFXy5K/o91Ov/5tm4wa0xddsdPm/WL4+p6BPRcRFWPq6PQ6Tov8rclANpKmRI
	 2cOvJhsD+dvVkeuV3ElzmX8fgMp6tDL4D7mcuSO0=
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
Subject: [PATCH 7.0 00/76] 7.0.1-rc1 review
Date: Mon, 20 Apr 2026 17:41:11 +0200
Message-ID: <20260420153910.810034134@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.0.1-rc1
X-KernelTest-Deadline: 2026-04-22T15:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.0.1 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.0.1-rc1

Jianhui Zhou <jianhuizzzzz@gmail.com>
    mm/userfaultfd: fix hugetlb fault mutex hash calculation

Jeongjun Park <aha310510@gmail.com>
    media: hackrf: fix to not free memory after the device is registered in hackrf_probe()

Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
    media: vidtv: fix pass-by-value structs causing MSAN warnings

Deepanshu Kartikey <kartikey406@gmail.com>
    nilfs2: fix NULL i_assoc_inode dereference in nilfs_mdt_save_to_shadow_map

Jeongjun Park <aha310510@gmail.com>
    media: as102: fix to not free memory after the device is registered in as102_usb_probe()

Shardul Bankar <shardul.b@mpiricsoftware.com>
    wireguard: device: use exit_rtnl callback instead of manual rtnl_lock in pre_exit

Mingzhe Zou <mingzhe.zou@easystack.cn>
    bcache: fix cached_dev.sb_bio use-after-free and crash

Berk Cem Goksel <berkcgoksel@gmail.com>
    ALSA: 6fire: fix use-after-free on disconnect

Sanman Pradhan <psanman@juniper.net>
    hwmon: (powerz) Fix use-after-free on USB disconnect

Abhishek Kumar <abhishek_sts8@yahoo.com>
    media: em28xx: fix use-after-free in em28xx_v4l2_open()

Fan Wu <fanwu01@zju.edu.cn>
    media: mediatek: vcodec: fix use-after-free in encoder release path

Ruslan Valiyev <linuxoid@gmail.com>
    media: vidtv: fix nfeeds state corruption on start_streaming failure

Breno Leitao <leitao@debian.org>
    mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()

Ritesh Harjani (IBM) <ritesh.list@gmail.com>
    mm/kasan: fix double free for kasan pXds

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: q6apm: move component registration to unmanaged version

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use scratch field in MMIO fragment to hold small write values

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64/arm64/powerpc: clean up and rename __copy_from_user_flushcache

Linus Torvalds <torvalds@linux-foundation.org>
    x86: rename and clean up __copy_from_user_inatomic_nocache()

Linus Torvalds <torvalds@linux-foundation.org>
    x86-64: rename misleadingly named '__copy_user_nocache()' function

Sasha Levin <sashal@kernel.org>
    checkpatch: add support for Assisted-by tag

Matthew Wilcox (Oracle) <willy@infradead.org>
    mm: call ->free_folio() directly in folio_unmap_invalidate()

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Drop WARN on large size for KVM_MEMORY_ENCRYPT_REG_REGION

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Lock all vCPUs when synchronzing VMSAs for SNP launch finish

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Disallow LAUNCH_FINISH if vCPUs are actively being created

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Protect *all* of sev_mem_enc_register_region() with kvm->lock

Sean Christopherson <seanjc@google.com>
    KVM: SEV: Reject attempts to sync VMSA of an already-launched/encrypted vCPU

Sean Christopherson <seanjc@google.com>
    KVM: selftests: Remove duplicate LAUNCH_UPDATE_VMSA call in SEV-ES migrate test

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Remove duplicate resource teardown

Koichiro Den <den@valinux.co.jp>
    PCI: endpoint: pci-epf-vntb: Stop cmd_handler work in epf_ntb_epc_cleanup

ZhengYuan Huang <gality369@gmail.com>
    ocfs2: handle invalid dinode in ocfs2_group_extend

Tejas Bharambe <tejas.bharambe@outlook.com>
    ocfs2: fix use-after-free in ocfs2_fault() when VM_FAULT_RETRY

Joseph Qi <joseph.qi@linux.alibaba.com>
    ocfs2: fix possible deadlock between unlink and dio_end_io_write

Ruslan Valiyev <linuxoid@gmail.com>
    media: vidtv: fix NULL pointer dereference in vidtv_channel_pmt_match_sections

Ryan Roberts <ryan.roberts@arm.com>
    arm64: mm: Handle invalid large leaf mappings correctly

Michał Winiarski <michal.winiarski@intel.com>
    vfio/xe: Reorganize the init to decouple migration from reset

Zhihao Cheng <chengzhihao1@huawei.com>
    dcache: Limit the minimal number of bucket to two

Harin Lee <me@harin.net>
    ALSA: ctxfi: Limit PTP to a single page

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FN990A MBIM composition

Alistair Popple <apopple@nvidia.com>
    selftests/mm: hmm-tests: don't hardcode THP size to 2MB

Junrui Luo <moonafterrain@outlook.com>
    staging: sm750fb: fix division by zero in ps_to_hz()

Johan Hovold <johan@kernel.org>
    wifi: rtw88: fix device leak on probe failure

Tamir Duberstein <tamird@kernel.org>
    scripts: generate_rust_analyzer.py: avoid FD leak

Benjamin Berg <benjamin.berg@intel.com>
    scripts/gdb/symbols: handle module path parameters

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO

Xu Yang <xu.yang_2@nxp.com>
    usb: port: add delay after usb_hub_set_port_power()

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: don't call cdev_init while cdev in use

Dave Carey <carvsdriver@gmail.com>
    USB: cdc-acm: Add quirks for Yoga Book 9 14IAH10 INGENIC touchscreen

Daniel Brát <danek.brat@gmail.com>
    usb: storage: Expand range of matched versions for VL817 quirks entry

Alexey Charkov <alchark@flipper.net>
    usb: typec: fusb302: Switch to threaded IRQ handler

Nathan Rebello <nathan.c.rebello@gmail.com>
    usbip: validate number_of_packets in usbip_pack_ret_submit()

Stefan Metzmacher <metze@samba.org>
    smb: server: avoid double-free in smb_direct_free_sendmsg after smb_direct_flush_send_list()

Stefan Metzmacher <metze@samba.org>
    smb: client: avoid double-free in smbd_free_send_io() after smbd_send_batch_flush()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: require 3 sub-authorities before reading sub_auth[2]

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ksmbd: validate EaNameLength in smb2_get_ea()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    smb: client: fix OOB reads parsing symlink error response

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    smb: client: fix off-by-8 bounds check in check_wsl_eas()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: renesas_usb3: validate endpoint index in standard request handlers

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: f_phonet: fix skb frags[] overflow in pn_rx_complete()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: f_ncm: validate minimum block_len in ncm_unwrap_ntb()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: fireworks: bound device-supplied status before string array lookup

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ALSA: usx2y: us144mkii: fix NULL deref on missing interface 0

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    bnge: return after auxiliary_device_uninit() in error path

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    drm/vc4: platform_get_irq_byname() returns an int

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    NFC: digital: Bounds check NFC-A cascade depth in SDD response handler

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: usb: cdc-phonet: fix skb frags[] overflow in rx_complete()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: core: clamp report_size in s32ton() to avoid undefined shift

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    HID: alps: fix NULL pointer dereference in alps_raw_event()

Lin YuChen <starpt.official@gmail.com>
    staging: rtl8723bs: initialize le_tmp64 in rtw_BIP_verify()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    i2c: s3c24xx: check the size of the SMBUS message before using it

Samuel Page <sam@bynar.io>
    can: raw: fix ro->uniq use-after-free in raw_rcv()

Borislav Petkov (AMD) <bp@alien8.de>
    x86/CPU: Fix FPDSS on Zen1

Junxi Qian <qjx1298677004@gmail.com>
    nfc: llcp: add missing return after LLCP_CLOSED checks


-------------

Diffstat:

 Documentation/admin-guide/mm/damon/lru_sort.rst    |  4 ++
 Documentation/admin-guide/mm/damon/reclaim.rst     |  4 ++
 Makefile                                           |  4 +-
 arch/arm64/include/asm/pgtable-prot.h              |  2 +
 arch/arm64/include/asm/pgtable.h                   |  9 ++-
 arch/arm64/include/asm/uaccess.h                   |  2 +-
 arch/arm64/mm/mmu.c                                |  4 ++
 arch/arm64/mm/pageattr.c                           | 50 +++++++------
 arch/arm64/mm/trans_pgd.c                          | 42 ++---------
 arch/powerpc/include/asm/uaccess.h                 |  3 +-
 arch/powerpc/lib/pmem.c                            | 11 +--
 arch/x86/include/asm/msr-index.h                   |  3 +
 arch/x86/include/asm/uaccess.h                     |  2 +-
 arch/x86/include/asm/uaccess_32.h                  |  8 +--
 arch/x86/include/asm/uaccess_64.h                  | 16 +++--
 arch/x86/kernel/cpu/amd.c                          |  3 +
 arch/x86/kvm/svm/sev.c                             | 46 ++++++++----
 arch/x86/kvm/x86.c                                 | 14 +++-
 arch/x86/lib/copy_user_uncached_64.S               |  6 +-
 arch/x86/lib/usercopy_32.c                         |  9 +--
 arch/x86/lib/usercopy_64.c                         | 12 ++--
 drivers/gpu/drm/i915/i915_gem.c                    |  2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c                    |  2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     | 14 ++--
 drivers/hid/hid-alps.c                             |  3 +
 drivers/hid/hid-core.c                             |  3 +
 drivers/hwmon/powerz.c                             |  8 ++-
 drivers/i2c/busses/i2c-s3c2410.c                   |  7 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |  8 +--
 drivers/md/bcache/super.c                          |  7 ++
 .../mediatek/vcodec/encoder/mtk_vcodec_enc_drv.c   |  9 +++
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |  4 +-
 drivers/media/test-drivers/vidtv/vidtv_channel.c   |  4 ++
 drivers/media/test-drivers/vidtv/vidtv_mux.c       |  4 +-
 drivers/media/test-drivers/vidtv/vidtv_ts.c        | 48 ++++++-------
 drivers/media/test-drivers/vidtv/vidtv_ts.h        |  4 +-
 drivers/media/usb/as102/as102_usb_drv.c            |  2 +
 drivers/media/usb/em28xx/em28xx-video.c            | 14 ++--
 drivers/media/usb/hackrf/hackrf.c                  |  7 +-
 drivers/net/ethernet/broadcom/bnge/bnge_auxr.c     |  1 +
 drivers/net/usb/cdc-phonet.c                       |  7 +-
 drivers/net/wireguard/device.c                     |  8 +--
 drivers/net/wireless/realtek/rtw88/usb.c           |  3 +-
 drivers/ntb/ntb_transport.c                        |  7 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c      | 20 +-----
 drivers/staging/rtl8723bs/core/rtw_security.c      |  2 +-
 drivers/staging/sm750fb/sm750.c                    |  3 +
 drivers/usb/class/cdc-acm.c                        | 53 ++++++++++++--
 drivers/usb/core/port.c                            |  1 +
 drivers/usb/gadget/function/f_hid.c                | 15 ++--
 drivers/usb/gadget/function/f_ncm.c                |  4 +-
 drivers/usb/gadget/function/f_phonet.c             |  9 +++
 drivers/usb/gadget/udc/renesas_usb3.c              |  7 +-
 drivers/usb/serial/option.c                        |  2 +
 drivers/usb/storage/unusual_devs.h                 |  7 +-
 drivers/usb/typec/tcpm/fusb302.c                   |  5 +-
 drivers/usb/usbip/usbip_common.c                   | 12 ++++
 drivers/vfio/pci/xe/main.c                         | 43 ++++++-----
 drivers/video/fbdev/tdfxfb.c                       |  3 +
 drivers/video/fbdev/udlfb.c                        |  3 +
 fs/dcache.c                                        |  4 +-
 fs/nilfs2/dat.c                                    |  3 +
 fs/ocfs2/aops.c                                    |  3 +-
 fs/ocfs2/mmap.c                                    |  7 +-
 fs/ocfs2/ocfs2_trace.h                             | 10 ++-
 fs/ocfs2/resize.c                                  | 10 ++-
 fs/smb/client/smb2file.c                           | 20 +++---
 fs/smb/client/smb2inode.c                          |  2 +-
 fs/smb/client/smbdirect.c                          |  8 +++
 fs/smb/server/connection.c                         |  1 +
 fs/smb/server/smb2pdu.c                            |  7 +-
 fs/smb/server/smbacl.c                             |  3 +-
 fs/smb/server/transport_rdma.c                     |  8 ++-
 include/linux/hugetlb.h                            | 17 +++++
 include/linux/kvm_host.h                           | 10 ++-
 include/linux/uaccess.h                            | 11 ++-
 lib/iov_iter.c                                     |  4 +-
 mm/backing-dev.c                                   |  5 +-
 mm/filemap.c                                       |  3 +-
 mm/internal.h                                      |  1 -
 mm/kasan/init.c                                    |  8 +--
 mm/truncate.c                                      |  6 +-
 mm/userfaultfd.c                                   |  2 +-
 net/can/raw.c                                      | 11 ++-
 net/nfc/digital_technology.c                       |  6 ++
 net/nfc/llcp_core.c                                |  2 +
 scripts/checkpatch.pl                              | 10 +++
 scripts/gdb/linux/symbols.py                       |  2 +-
 scripts/generate_rust_analyzer.py                  |  3 +-
 sound/firewire/fireworks/fireworks_command.c       |  5 +-
 sound/pci/ctxfi/ctvmem.h                           |  2 +-
 sound/soc/qcom/qdsp6/q6apm.c                       | 14 +++-
 sound/usb/6fire/chip.c                             | 17 +++--
 sound/usb/usx2y/us144mkii.c                        |  6 +-
 tools/objtool/check.c                              |  2 +-
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  |  2 -
 tools/testing/selftests/mm/hmm-tests.c             | 83 +++++-----------------
 97 files changed, 579 insertions(+), 358 deletions(-)


