Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30731E04B2;
	Wed,  6 Nov 2024 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899167; cv=none; b=HIYS6gy4V07aS5CTAm5u8X56bzOdxfBUNGX9cSRMvQ/PxRexWVh5LnNKsNrD0sURR/EHVuIIx1EHrb6jIG8BbfiJNdaLr9+bjBRN9n3QBUsAKMwWXSXM5NG3GMEgbdXOI6nA7wWKiSG1pYdfu8wMIUfdudqAMVlSTXVNGK1dpWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899167; c=relaxed/simple;
	bh=UcaWGER/H9Mo0lL7NOWT5Qk+c2J1oavPFlCQcTUealY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N6n65Msnmh0WrYVqcLBrntmRdVNIlIQ0LlWvZOByfMm8QvCEUnhRCjkqc2Cw9uXzSS5bDSGiwcgjwTSfXIMAYV79FWZJiaEthr0ItdzDatueUAMIVOrm2SNPU2rTxYBp5qBh+cRpiSGIBYy1eknjhK3sMsUXj8Bl5l7OVFIPXV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4HlGf1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4HlGf1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CD0C4CED3;
	Wed,  6 Nov 2024 13:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899167;
	bh=UcaWGER/H9Mo0lL7NOWT5Qk+c2J1oavPFlCQcTUealY=;
	h=From:To:Cc:Subject:Date:From;
	b=u4HlGf1UsI4edRyq7QrAIK43/Ca/5SocHMlwGtr7wjkcPTo+MGSo2R0AQmZssidAR
	 DoisxiK7BomkOwOFLjUAB4izr/9SVHxZ9dWRAAGlCuSc5rGclyoQQZXU+YejVxn39E
	 FydDxciFdPN5ll1YTolBJeA3tK6d7h1iRnOIjWFQ=
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
	hagar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 5.15 00/73] 5.15.171-rc1 review
Date: Wed,  6 Nov 2024 13:05:04 +0100
Message-ID: <20241106120259.955073160@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.171-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.171-rc1
X-KernelTest-Deadline: 2024-11-08T12:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.171 release.
There are 73 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.171-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.171-rc1

Johannes Berg <johannes.berg@intel.com>
    mac80211: always have ieee80211_sta_restart()

Jeongjun Park <aha310510@gmail.com>
    vt: prevent kernel-infoleak in con_font_get()

Rob Clark <robdclark@chromium.org>
    drm/i915: Fix potential context UAFs

Jason-JH.Lin <jason-jh.lin@mediatek.com>
    Revert "drm/mipi-dsi: Set the fwnode for mipi_dsi_device"

Jeongjun Park <aha310510@gmail.com>
    mm: shmem: fix data-race in shmem_getattr()

Johannes Berg <johannes.berg@intel.com>
    wifi: iwlwifi: mvm: fix 6 GHz scan construction

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix kernel bug due to missing clearing of checked flag

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Use code segment selector for VERW operand

Edward Adam Davis <eadavis@qq.com>
    ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow

Matt Fleming <mfleming@cloudflare.com>
    mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: explicitly define what alloc flags deplete min reserves

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: explicitly record high-order atomic allocations in alloc_flags

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: treat RT tasks similar to __GFP_HIGH

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: rename ALLOC_HIGH to ALLOC_MIN_RESERVE

Mel Gorman <mgorman@techsingularity.net>
    mm/page_alloc: split out buddy removal code from rmqueue into separate helper

Wonhyuk Yang <vvghjk1234@gmail.com>
    mm/page_alloc: fix tracepoint mm_page_alloc_zone_locked()

Eric Dumazet <edumazet@google.com>
    mm/page_alloc: call check_new_pages() while zone spinlock is not held

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove duplicated GET_RM

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    riscv: Remove unused GENERATING_ASM_OFFSETS

WangYuli <wangyuli@uniontech.com>
    riscv: Use '%u' to format the output of 'cpu'

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: efi: Set NX compat flag in PE/COFF header

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: vdso: Prevent the compiler from inserting calls to memset()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix potential deadlock with newly created symlinks

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    iio: light: veml6030: fix microlux value calculation

Zicheng Qu <quzicheng@huawei.com>
    iio: adc: ad7124: fix division by zero in ad7124_set_channel_odr()

Zicheng Qu <quzicheng@huawei.com>
    staging: iio: frequency: ad9832: fix division by zero in ad9832_calc_freqreg()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    wifi: iwlegacy: Clear stale interrupts before resuming device

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    wifi: ath10k: Fix memory leak in management tx

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "driver core: Fix uevent_show() vs driver detach race"

Basavaraj Natikar <Basavaraj.Natikar@amd.com>
    xhci: Use pm_runtime_get to prevent RPM on unsupported systems

Faisal Hassan <quic_faisalh@quicinc.com>
    xhci: Fix Link TRB DMA in command ring stopped completion event

Javier Carrasco <javier.carrasco.cruz@gmail.com>
    usb: typec: fix unreleased fwnode_handle in typec_port_register_altmodes()

Zijun Hu <quic_zijuhu@quicinc.com>
    usb: phy: Fix API devm_usb_put_phy() can not release the phy

Zongmin Zhou <zhouzongmin@kylinos.cn>
    usbip: tools: Fix detach_port() invalid port error path

Dimitri Sivanich <sivanich@hpe.com>
    misc: sgi-gru: Don't disable preemption in GRU driver

Dai Ngo <dai.ngo@oracle.com>
    NFS: remove revoked delegation from server's delegation list

Daniel Palmer <daniel@0x0f.com>
    net: amd: mvme147: Fix probe banner message

Benjamin Marzinski <bmarzins@redhat.com>
    scsi: scsi_transport_fc: Allow setting rport state to current state

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Additional check in ni_clear()

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix possible deadlock in mi_read

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Fix warning possible deadlock in ntfs_set_state

Andrew Ballance <andrewjballance@gmail.com>
    fs/ntfs3: Check if more than chunk-size bytes are written

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: CPPC: Make rmw_lock a raw_spin_lock

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: sanitize offset and length before calling skb_checksum()

Benoît Monin <benoit.monin@gmx.fr>
    net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension

Dong Chenchen <dongchenchen2@huawei.com>
    netfilter: Fix use-after-free in get_info()

Byeonguk Jeong <jungbu2855@gmail.com>
    bpf: Fix out-of-bounds write in trie_get_next_key()

Zichen Xie <zichenxie0106@gmail.com>
    netdevsim: Add trailing zero to terminate the string in nsim_nexthop_bucket_activity_write()

Pedro Tammela <pctammela@mojatatu.com>
    net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT

Pablo Neira Ayuso <pablo@netfilter.org>
    gtp: allow -1 to be specified as file description from userspace

Ido Schimmel <idosch@nvidia.com>
    ipv4: ip_tunnel: Fix suspicious RCU usage warning in ip_tunnel_init_flow()

Wander Lairson Costa <wander@redhat.com>
    igb: Disable threaded IRQ for igb_msix_other

Furong Xu <0x1207@gmail.com>
    net: stmmac: TSO: Fix unbalanced DMA map/unmap for non-paged SKB data

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()

Daniel Gabay <daniel.gabay@intel.com>
    wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    wifi: iwlwifi: mvm: disconnect station vifs if recovery failed

Youghandhar Chintala <youghand@codeaurora.org>
    mac80211: Add support to trigger sta disconnect on hardware restart

Johannes Berg <johannes.berg@intel.com>
    mac80211: do drv_reconfig_complete() before restarting all

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: synchronize the qp-handle table array

Patrisious Haddad <phaddad@nvidia.com>
    RDMA/mlx5: Round max_rd_atomic/max_dest_rd_atomic up instead of down

Leon Romanovsky <leon@kernel.org>
    RDMA/cxgb4: Dump vendor specific QP details

Geert Uytterhoeven <geert@linux-m68k.org>
    wifi: brcm80211: BRCM_TRACING should depend on TRACING

Felix Fietkau <nbd@nbd.name>
    wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys

Geert Uytterhoeven <geert@linux-m68k.org>
    mac80211: MAC80211_MESSAGE_TRACING should depend on TRACING

Xiu Jianfeng <xiujianfeng@huawei.com>
    cgroup: Fix potential overflow issue when checking max_depth

Koba Ko <kobak@nvidia.com>
    ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM handler and context

Sudeep Holla <sudeep.holla@arm.com>
    ACPI: PRM: Change handler_addr type to void pointer

Aubrey Li <aubrey.li@intel.com>
    ACPI: PRM: Remove unnecessary blank lines

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: fix user-after-free from session log off

Donet Tom <donettom@linux.ibm.com>
    selftests/mm: fix incorrect buffer->mirror size in hmm2 double_map test


-------------

Diffstat:

 Makefile                                          |   4 +-
 arch/riscv/kernel/asm-offsets.c                   |   2 -
 arch/riscv/kernel/cpu-hotplug.c                   |   2 +-
 arch/riscv/kernel/efi-header.S                    |   2 +-
 arch/riscv/kernel/traps_misaligned.c              |   2 -
 arch/riscv/kernel/vdso/Makefile                   |   1 +
 arch/x86/include/asm/nospec-branch.h              |  11 +-
 drivers/acpi/cppc_acpi.c                          |   9 +-
 drivers/acpi/prmt.c                               |  33 ++--
 drivers/base/core.c                               |  13 +-
 drivers/base/module.c                             |   4 -
 drivers/firmware/arm_sdei.c                       |   2 +-
 drivers/gpu/drm/drm_mipi_dsi.c                    |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c       |  24 ++-
 drivers/iio/adc/ad7124.c                          |   2 +-
 drivers/iio/light/veml6030.c                      |   2 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c          |   4 +
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c        |  13 +-
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h        |   2 +
 drivers/infiniband/hw/cxgb4/provider.c            |   1 +
 drivers/infiniband/hw/mlx5/qp.c                   |   4 +-
 drivers/misc/sgi-gru/grukservices.c               |   2 -
 drivers/misc/sgi-gru/grumain.c                    |   4 -
 drivers/misc/sgi-gru/grutlbpurge.c                |   2 -
 drivers/net/ethernet/amd/mvme147.c                |   7 +-
 drivers/net/ethernet/intel/igb/igb_main.c         |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  22 ++-
 drivers/net/gtp.c                                 |  22 +--
 drivers/net/netdevsim/fib.c                       |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c         |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c             |   2 +
 drivers/net/wireless/broadcom/brcm80211/Kconfig   |   1 +
 drivers/net/wireless/intel/iwlegacy/common.c      |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  22 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     |   3 +-
 drivers/scsi/scsi_transport_fc.c                  |   4 +-
 drivers/staging/iio/frequency/ad9832.c            |   7 +-
 drivers/tty/vt/vt.c                               |   2 +-
 drivers/usb/host/xhci-pci.c                       |   6 +-
 drivers/usb/host/xhci-ring.c                      |  16 +-
 drivers/usb/phy/phy.c                             |   2 +-
 drivers/usb/typec/class.c                         |   1 +
 fs/ksmbd/mgmt/user_session.c                      |  26 ++-
 fs/ksmbd/mgmt/user_session.h                      |   4 +
 fs/ksmbd/server.c                                 |   2 +
 fs/ksmbd/smb2pdu.c                                |   8 +-
 fs/nfs/delegation.c                               |   5 +
 fs/nilfs2/namei.c                                 |   3 +
 fs/nilfs2/page.c                                  |   1 +
 fs/ntfs3/frecord.c                                |   4 +-
 fs/ntfs3/lznt.c                                   |   3 +
 fs/ntfs3/namei.c                                  |   2 +-
 fs/ntfs3/ntfs_fs.h                                |   2 +-
 fs/ocfs2/file.c                                   |   8 +
 include/acpi/cppc_acpi.h                          |   2 +-
 include/net/ip_tunnels.h                          |   2 +-
 include/net/mac80211.h                            |  10 ++
 include/trace/events/kmem.h                       |  14 +-
 kernel/bpf/lpm_trie.c                             |   2 +-
 kernel/cgroup/cgroup.c                            |   4 +-
 mm/internal.h                                     |  13 +-
 mm/page_alloc.c                                   | 185 +++++++++++++---------
 mm/shmem.c                                        |   2 +
 net/core/dev.c                                    |   4 +
 net/mac80211/Kconfig                              |   2 +-
 net/mac80211/cfg.c                                |   3 +-
 net/mac80211/ieee80211_i.h                        |   3 +
 net/mac80211/key.c                                |  42 +++--
 net/mac80211/mlme.c                               |  14 +-
 net/mac80211/util.c                               |  45 ++++--
 net/netfilter/nft_payload.c                       |   3 +
 net/netfilter/x_tables.c                          |   2 +-
 net/sched/sch_api.c                               |   2 +-
 sound/soc/codecs/cs42l51.c                        |   7 +-
 tools/testing/selftests/vm/hmm-tests.c            |   2 +-
 tools/usb/usbip/src/usbip_detach.c                |   1 +
 76 files changed, 481 insertions(+), 230 deletions(-)


