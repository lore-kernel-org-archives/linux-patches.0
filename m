Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6082727280A;
	Mon, 13 Apr 2026 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096998; cv=none; b=gK+7rBLxkeYU7Ng6cfeO0mMDZt2To19lv1RN/oGIxQmR1q0KUbC6SRTUymVZ9rxrSC3ToeZW5VRR1DeG4n/l17V0XMLs9J60Ajd1xdM2eT6HjaEdpbVaYKKy8vYhC5qtf9bkhkJuJnbSAvXlTYIqVT3nwbxqLYhcU5a7YIRpbNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096998; c=relaxed/simple;
	bh=+3aKiJPHT2LnvWyQbK9bZCPcN/49zOWu8/PGcMlhe1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sCu6GVcv+PY/AV3q+uB+JbIfC3zk6H+auvIrEXGMAlPJ94+7tsI34HXCndU13DKmaxUNMjQquQ0YpfhuSFIDRCXHoNi+45B6gIRFDkC/PIX+WfkAog+vAg8g23brHS6IbwKZQeAsAyA1aHGmMh0ZveULlpopkJMFQwpAWn1QPeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yws9Bzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yws9Bzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C175FC2BCAF;
	Mon, 13 Apr 2026 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096998;
	bh=+3aKiJPHT2LnvWyQbK9bZCPcN/49zOWu8/PGcMlhe1g=;
	h=From:To:Cc:Subject:Date:From;
	b=2Yws9BzcyRAtxC9qMJi9eSk40SpcwQutTEcBv/wm5QbyCMADS6PWawappmvJEmpYH
	 qB6wNjnnOyIhETgmu8Uj2bmfZ8wNzsr2SXlwtkB2Oge6q+fcbypl/r4jJ7Pw8UDbIE
	 ICQdduohKxWhGcN24MScw/vD7czmeT5pClgdlAAg=
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
Subject: [PATCH 6.1 00/55] 6.1.169-rc1 review
Date: Mon, 13 Apr 2026 18:00:34 +0200
Message-ID: <20260413155724.820472494@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.169-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.169-rc1
X-KernelTest-Deadline: 2026-04-15T15:57+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.169 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.169-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.169-rc1

Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
    Revert "PCI: Enable ACS after configuring IOMMU for OF platforms"

David Howells <dhowells@redhat.com>
    rxrpc: Fix key/keyring checks in setsockopt(RXRPC_SECURITY_KEY/KEYRING)

Luxiao Xu <rakukuip@gmail.com>
    rxrpc: fix reference count leak in rxrpc_server_keyring()

Tyllis Xu <livelycarpet87@gmail.com>
    net: stmmac: fix integer underflow in chain mode

Pengpeng Hou <pengpeng@iscas.ac.cn>
    net: qualcomm: qca_uart: report the consumed byte on RX skb allocation failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix NULL-deref on disconnect

Michael Guralnik <michaelgur@nvidia.com>
    net/mlx5: Update the list of the PCI supported devices

Sebastian Brzezinka <sebastian.brzezinka@intel.com>
    drm/i915/gt: fix refcount underflow in intel_engine_park_heartbeat

Haoze Xie <royenheart@gmail.com>
    batman-adv: hold claim backbone gateways by reference

David Carlier <devnexen@gmail.com>
    net: altera-tse: fix skb leak on DMA mapping error in tse_start_xmit()

Muhammad Alifa Ramdhan <ramdhan@starlabs.sg>
    net/tls: fix use-after-free in -EBUSY error path of tls_do_encryption

Borislav Petkov (AMD) <bp@alien8.de>
    EDAC/mc: Fix error path ordering in edac_mc_alloc()

Ruide Cao <caoruide123@gmail.com>
    batman-adv: reject oversized global TT response buffers

Pengpeng Hou <pengpeng@iscas.ac.cn>
    nfc: pn533: allocate rx skb before consuming bytes

Shawn Guo <shawnguo@kernel.org>
    arm64: dts: hisilicon: hi3798cv200: Add missing dma-ranges

Shawn Guo <shawnguo@kernel.org>
    arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity

Thomas Fourier <fourier.thomas@gmail.com>
    wifi: brcmsmac: Fix dma_free_coherent() size

Oleh Konko <security@1seal.org>
    tipc: fix bc_ackers underflow on duplicate GRP_ACK_MSG

Yasuaki Torimaru <yasuakitorimaru@gmail.com>
    xfrm: clear trailing padding in build_polexpire()

Tuan Do <tuan@calif.io>
    netfilter: nft_ct: fix use-after-free in timeout object destroy

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR

Lin.Cao <lincao12@amd.com>
    drm/scheduler: signal scheduled fence when kill job

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    Revert "mptcp: add needs_id for netlink appending addr"

Andrea Mayer <andrea.mayer@uniroma2.it>
    seg6: separate dst_cache for input and output paths in seg6 lwtunnel

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    net: rfkill: prevent unlimited numbers of rfkill events from being created

Johannes Berg <johannes.berg@intel.com>
    net: rfkill: reduce data->mtx scope in rfkill_fop_open

Johannes Berg <johannes.berg@intel.com>
    rfkill: sync before userspace visibility/changes

Bo Liu <liubo03@inspur.com>
    rfkill: Use sysfs_emit() to instead of sprintf()

Michael Zimmermann <sigmaepsilon92@gmail.com>
    usb: gadget: f_hid: move list and spinlock inits from bind to alloc

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: EC: Evaluate _REG outside the EC scope more carefully

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Add a depth argument to acpi_execute_reg_methods()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "ACPI: EC: Evaluate orphan _REG under EC device"

Kuen-Han Tsai <khtsai@google.com>
    usb: gadget: u_ether: Fix race between gether_disconnect and eth_stop

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

Ricardo Ribalda <ribalda@chromium.org>
    media: uvcvideo: Use heuristic to find stream entity

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Rewrite TLB uniquification for the hidden bit feature

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: mm: Suppress TLB uniquification on EHINV hardware

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Always record SEGBITS in cpu_data.vmbits

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: uinput - take event lock when submitting FF request "event"

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    Input: uinput - fix circular locking dependency with ff-core

Jiayuan Chen <jiayuan.chen@linux.dev>
    mptcp: fix slab-use-after-free in __inet_lookup_established

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    xfrm_user: fix info leak in build_report()

Johan Hovold <johan@kernel.org>
    wifi: rt2x00usb: fix devres lifetime

Eric Biggers <ebiggers@kernel.org>
    lib/crypto: chacha: Zeroize permuted_state before it leaves scope


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../boot/dts/hisilicon/hi3798cv200-poplar.dts      |   2 +-
 arch/arm64/boot/dts/hisilicon/hi3798cv200.dtsi     |   1 +
 arch/mips/include/asm/cpu-features.h               |   1 -
 arch/mips/include/asm/cpu-info.h                   |   2 -
 arch/mips/include/asm/mipsregs.h                   |   2 +
 arch/mips/kernel/cpu-probe.c                       |  13 +-
 arch/mips/kernel/cpu-r3k-probe.c                   |   2 +
 arch/mips/mm/tlb-r4k.c                             | 285 +++++++++++++++++----
 drivers/acpi/acpica/acevents.h                     |   6 +-
 drivers/acpi/acpica/evregion.c                     |  12 +-
 drivers/acpi/acpica/evxfregn.c                     |  64 +----
 drivers/acpi/ec.c                                  |  14 +-
 drivers/acpi/internal.h                            |   1 +
 drivers/acpi/scan.c                                |   2 +
 drivers/edac/edac_mc.c                             |   6 +-
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c   |  26 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |   1 +
 drivers/input/misc/uinput.c                        |  35 ++-
 drivers/media/usb/uvc/uvc_driver.c                 |  88 +++++--
 drivers/media/usb/uvc/uvcvideo.h                   |   2 +
 drivers/mmc/host/vub300.c                          |   2 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 drivers/net/ethernet/qualcomm/qca_uart.c           |   2 +-
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |  11 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/dma.c |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   2 +-
 drivers/nfc/pn533/uart.c                           |  11 +-
 drivers/pci/pci-driver.c                           |   8 -
 drivers/pci/pci.c                                  |  10 +-
 drivers/pci/pci.h                                  |   1 -
 drivers/usb/gadget/function/f_hid.c                |  11 +-
 drivers/usb/gadget/function/u_ether.c              |   8 +-
 include/acpi/acpixf.h                              |   5 +-
 include/net/netfilter/nf_conntrack_timeout.h       |   1 +
 lib/crypto/chacha.c                                |   4 +
 net/batman-adv/bridge_loop_avoidance.c             |  27 +-
 net/batman-adv/translation-table.c                 |   9 +-
 net/ipv6/seg6_iptunnel.c                           |  41 ++-
 net/mptcp/pm_netlink.c                             |  24 +-
 net/mptcp/protocol.c                               |   2 +
 net/mptcp/protocol.h                               |   1 +
 net/mptcp/subflow.c                                |  15 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/netfilter/nft_set_pipapo.c                     |  20 +-
 net/rfkill/core.c                                  |  84 ++++--
 net/rxrpc/af_rxrpc.c                               |   6 -
 net/rxrpc/key.c                                    |   2 +-
 net/rxrpc/server_key.c                             |   3 +
 net/tipc/group.c                                   |   6 +-
 net/tls/tls_sw.c                                   |  10 +
 net/xfrm/xfrm_user.c                               |   3 +
 security/apparmor/apparmorfs.c                     | 228 ++++++++++-------
 security/apparmor/include/label.h                  |  16 +-
 security/apparmor/include/lib.h                    |  12 +
 security/apparmor/include/match.h                  |   1 +
 security/apparmor/include/policy.h                 |  13 +-
 security/apparmor/include/policy_ns.h              |   2 +
 security/apparmor/include/policy_unpack.h          |  83 +++---
 security/apparmor/label.c                          |  12 +-
 security/apparmor/match.c                          |  58 +++--
 security/apparmor/policy.c                         |  82 +++++-
 security/apparmor/policy_ns.c                      |   2 +
 security/apparmor/policy_unpack.c                  |  74 ++++--
 65 files changed, 989 insertions(+), 498 deletions(-)


