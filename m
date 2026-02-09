Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B4528725B;
	Mon,  9 Feb 2026 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648709; cv=none; b=Sh5jEOk9gxD9BNb0Zky7FSc21wEK7+WFMPYcGUebCTXfZITKutFVibktlWr6lKXaz/X82+VDEq+zG/QRhr9m82+yOLdiRDtDovXqZ+04p2OXPyoYE7yV8p5crJqwShFfFWJQ0LYkVd2YZ0g0dhG2HO6W5Iua1pNAgkMrggx3GGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648709; c=relaxed/simple;
	bh=484PVM5OLVqm9LPc0d1xoXwbSw6zuIs+cMSBn4CbJ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qfYCjoE1bFOZUJH9RvzOBnBEYjaVkSilt7vfYHZNoq4E1U1VfGn66f3+Q697hQnsSQHJH+WdiCIXp9vood+hrHghakVVRueaTkfEVJphjrqlo78f/wqRDAiHpJhMLh7dMNXlG6IwcTB1UMTrihNzJdF36JsxUtLJmdWsQwVUXcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft/eeiI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft/eeiI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF0EC116C6;
	Mon,  9 Feb 2026 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648709;
	bh=484PVM5OLVqm9LPc0d1xoXwbSw6zuIs+cMSBn4CbJ/k=;
	h=From:To:Cc:Subject:Date:From;
	b=Ft/eeiI5g6t6fnhfk+oh1HDjXSjl9+V3OWSRfOaNUqWwOGs8653/Y4SBDO9wd4+Gw
	 AdVmUib1+m/0s4FgyWJ4+4cTCJhnrYqCxndteXCGMPXmDHPdrV/ybbPLgc9yOXDJQS
	 H+oE9R8pVzovsezGeNHson+vyREJ+FiMTRQEBNbo=
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
Subject: [PATCH 5.10 00/41] 5.10.250-rc1 review
Date: Mon,  9 Feb 2026 15:24:21 +0100
Message-ID: <20260209142256.797267956@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.250-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.250-rc1
X-KernelTest-Deadline: 2026-02-11T14:22+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.250 release.
There are 41 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.250-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.250-rc1

Varun Prakash <varun@chelsio.com>
    nvmet-tcp: pass iov_len instead of sg->length to bvec_set_page()

Max Yuan <maxyuan@google.com>
    gve: Correct ethtool rx_dropped calculation

Steven Rostedt <rostedt@goodmis.org>
    tracing: Fix ftrace event field alignments

Debarghya Kundu <debarghyak@google.com>
    gve: Fix stats report corruption on queue count change

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix swapped arrays in PSS output

Chris Bainbridge <chris.bainbridge@gmail.com>
    ASoC: amd: fix memory leak in acp3x pdm dma ops

YunJe Shin <yjshin0438@gmail.com>
    nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    nvmet-tcp: don't map pages which can't come from HIGHMEM

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix regression in data_digest calculation

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: fix memory leak when performing a controller reset

Maurizio Lombardi <mlombard@redhat.com>
    nvmet-tcp: add an helper to free the cmd buffers

Arnd Bergmann <arnd@arndb.de>
    hwmon: (occ) Mark occ_init_attribute() as __printf

Daniel Hodges <hodgesd@meta.com>
    tipc: use kfree_sensitive() for session key material

Eric Dumazet <edumazet@google.com>
    macvlan: fix error recovery in macvlan_common_newlink()

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Fix off-by-one error in PF setup_nic_devices() cleanup

Zilin Guan <zilin@seu.edu.cn>
    net: liquidio: Initialize netdev pointer before queue setup

Kaushlendra Kumar <kaushlendra.kumar@intel.com>
    platform/x86: intel_telemetry: Fix PSS event register mask

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: toshiba_haps: Fix memory leaks in add/remove routines

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    wifi: mac80211: don't increment crypto_tx_tailroom_needed_cnt twice

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()

Maurizio Lombardi <mlombard@redhat.com>
    scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()

Veerendranath Jakkam <veerendranath.jakkam@oss.qualcomm.com>
    wifi: cfg80211: Fix bitrate calculation overflow for HE rates

Dimitrios Katsaros <patcherwork@gmail.com>
    ASoC: tlv320adcx140: Propagate error codes during probe

Kery Qi <qikeyu2017@gmail.com>
    ASoC: davinci-evm: Fix reference leak in davinci_evm_probe

Baochen Qiang <baochen.qiang@oss.qualcomm.com>
    wifi: mac80211: collect station statistics earlier when disconnect

Wupeng Ma <mawupeng1@huawei.com>
    ring-buffer: Avoid softlockup in ring_buffer_resize() during memory free

Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
    HID: Apply quirk HID_QUIRK_ALWAYS_POLL to Edifier QR30 (2d99:a101)

Chris Chiu <chris.chiu@canonical.com>
    HID: quirks: Add another Chicony HP 5MP Cameras to hid_ignore_list

Ruslan Krupitsa <krupitsarus@outlook.com>
    ALSA: hda/realtek: add HP Laptop 15s-eq1xxx mute LED quirk

Zhang Lixu <lixu.zhang@intel.com>
    HID: intel-ish-hid: Reset enum_devices_done before enumeration

DaytonCL <artem749507@gmail.com>
    HID: multitouch: add MT_QUIRK_STICKY_FINGERS to MT_CLS_VTL

shechenglong <shechenglong@xfusion.com>
    block,bfq: fix aux stat accumulation destination

Ethan Nelson-Moore <enelsonmoore@gmail.com>
    net: usb: sr9700: support devices with virtual driver CD

Peter Åstrand <astrand@lysator.liu.se>
    wifi: wlcore: ensure skb headroom before skb_push

Moon Hee Lee <moonhee.lee.ca@gmail.com>
    wifi: mac80211: ocb: skip rx_no_sta when interface is not joined

Carlos Llamas <cmllamas@google.com>
    binderfs: fix ida_alloc_max() upper bound

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX

Sean Christopherson <seanjc@google.com>
    KVM: Don't clobber irqfd routing type when deassigning irqfd

Thomas Weissschuh <thomas.weissschuh@linutronix.de>
    ARM: 9468/1: fix memset64() on big-endian

Ilya Dryomov <idryomov@gmail.com>
    rbd: check for EOD after exclusive lock is ensured to be held


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/include/asm/string.h                      |   5 +-
 block/bfq-cgroup.c                                 |   2 +-
 drivers/android/binderfs.c                         |   8 +-
 drivers/block/rbd.c                                |  33 ++++---
 drivers/hid/hid-ids.h                              |   4 +
 drivers/hid/hid-multitouch.c                       |   1 +
 drivers/hid/hid-quirks.c                           |   2 +
 drivers/hid/intel-ish-hid/ishtp-hid-client.c       |   1 +
 drivers/hwmon/occ/common.c                         |   1 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  39 ++++----
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |   4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  46 ++++++----
 drivers/net/ethernet/google/gve/gve_main.c         |   4 +-
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/usb/sr9700.c                           |   5 ++
 drivers/net/wireless/ti/wlcore/tx.c                |   5 ++
 drivers/nvme/target/tcp.c                          | 100 ++++++++++-----------
 drivers/platform/x86/intel_telemetry_debugfs.c     |   4 +-
 drivers/platform/x86/intel_telemetry_pltdrv.c      |   2 +-
 drivers/platform/x86/toshiba_haps.c                |   2 +-
 drivers/target/iscsi/iscsi_target_util.c           |  10 ++-
 kernel/trace/ring_buffer.c                         |   2 +
 kernel/trace/trace.h                               |   7 +-
 kernel/trace/trace_entries.h                       |  14 +--
 kernel/trace/trace_export.c                        |  21 +++--
 net/mac80211/key.c                                 |   3 +-
 net/mac80211/ocb.c                                 |   3 +
 net/mac80211/sta_info.c                            |   7 +-
 net/netfilter/nft_set_pipapo.c                     |   8 ++
 net/tipc/crypto.c                                  |   4 +-
 net/wireless/util.c                                |   8 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/amd/renoir/acp3x-pdm-dma.c               |   2 +
 sound/soc/codecs/tlv320adcx140.c                   |   3 +
 sound/soc/ti/davinci-evm.c                         |  39 ++++++--
 virt/kvm/eventfd.c                                 |  34 +++----
 37 files changed, 272 insertions(+), 171 deletions(-)


