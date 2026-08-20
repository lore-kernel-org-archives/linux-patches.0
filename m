Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEC546C831;
	Thu, 20 Aug 2026 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247855; cv=none; b=N95iSupWz6uArwNt4NU2dI4+Xtgm8fcJemY8Tbf9hiryp4PugNWPgqj2HJi/JNRtHBdEl/1qTidhYQTccIBlm+YLjv1hcwGsjtwIEEcqs6FNfDR/rGd8hqIkfKR1JuZ6gqtrVKr/+40Uk0afI26AI/wJ4t59hC/HgOHrRbpN980=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247855; c=relaxed/simple;
	bh=FZh5n58hv710ydY2cAUjoi5xg0VnFQqE+vF9alERScI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZuREqFmcw77QffGoA6uWp+cs6FSr+TWD07RhcPFGfHU7RcLd0sEFYb6BBQ4opYwc/OOEpnnD0nmqz478wY6KpV+pEIHwYxOBe3Qsa6x4VJVNQQ6mr1L725+CyJsinH5825Tt4U/ZGfbAlSg8AH/E8KeJtENxpWZKOHQlMqK+Bk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g76swlAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g76swlAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179351F000E9;
	Thu, 20 Aug 2026 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247851;
	bh=lLTnPZ7hUxLPrUcpY26k/ZCqv0plFidm/xglmSLhQI4=;
	h=From:To:Cc:Subject:Date;
	b=g76swlAk1bCNWaiUOb7Q7fDnF6uZgapkAI71AppiWvSH+pcbVUWQ5N9RZ74grcWZK
	 nrzeSX5iCdVkNSQqZ6TZZUbfv0BeF/bF+d2CfeJcV0Aq4/HFBbekgXbWxOtm82lJ1/
	 QojL1HuzZloXh9L4sn/6pogyu3EhV1rwYaCK5Uyk=
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
Subject: [PATCH 6.1 000/303] 6.1.184-rc1 review
Date: Thu, 20 Aug 2026 16:52:16 +0200
Message-ID: <20260820145253.200766705@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.184-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.184-rc1
X-KernelTest-Deadline: 2026-08-22T14:53+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.184 release.
There are 303 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.184-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.184-rc1

Zihan Xi <zihanx@nebusec.ai>
    Bluetooth: mgmt: fix pending command UAF in EIR updates

Pauli Virtanen <pav@iki.fi>
    Bluetooth: mgmt: fix locking in unpair_device/disconnect_sync

Pauli Virtanen <pav@iki.fi>
    Bluetooth: hci_sync: call destroy in hci_cmd_sync_run if immediate

Edward Adam Davis <eadavis@qq.com>
    Bluetooth: hci_sock: Prevent race in socket write iter and sock bind

Robert Mader <robert.mader@collabora.com>
    udmabuf: Ensure to perform cache synchronisation in begin_cpu_udmabuf()

Gao Xiang <xiang@kernel.org>
    erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Correct teardown ordering in ucsi_init() error path

Pedro Falcato <pfalcato@suse.de>
    RDMA/siw: Fix the sendmsg byte count in siw_tcp_sendpages

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Fix not using correct handle

Christian Brauner <brauner@kernel.org>
    binfmt_misc: use exe_file_deny_write_access() for the interpreter clone

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/huge_memory: fix huge_zero_pfn race

Baul Lee <baul.lee@xbow.com>
    net/x25: fix use-after-free of the socket by its timers

Siddharth Vadapalli <s-vadapalli@ti.com>
    net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/sched: cls_u32: skip hash tables in u32_bind_class()

Eric Dumazet <edumazet@google.com>
    af_packet: Don't send zero-byte data in tpacket_snd().

Rosen Penev <rosenp@gmail.com>
    ASoC: xilinx: formatter_pcm: pass aud_drv_data to irq handlers

Chuck Lever <cel@kernel.org>
    net/tls: Fail tls_sw_splice_read() after a failed async decrypt

Wei Fang <wei.fang@nxp.com>
    net: packet: fix wrong transport_header when sending VLAN-tagged frame

Eric Dumazet <edumazet@google.com>
    macvlan: inherit needed_headroom and needed_tailroom from lowerdev

Eric Dumazet <edumazet@google.com>
    ipvlan: inherit needed_headroom and needed_tailroom from phy_dev

Florian Westphal <fw@strlen.de>
    netfilter: ipset: let destroy callbacks adjust ext mem size

Florian Westphal <fw@strlen.de>
    netfilter: ipset: fix list type element drift bug

Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
    netfilter: flowtable: publish GC-visible tuple last

Alexey Velichayshiy <a.velichayshiy@ispras.ru>
    netfilter: nf_tables_offload: suppress WARN_ON_ONCE for ENOMEM in abort path

Xiang Mei (Microsoft) <xmei5@asu.edu>
    netfilter: ipset: fix refcount race between list:set GC and swap

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: ccm - Set rfc4309 maxauthsize from child

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Add EL2 virtual timer interrupt for Tegra194

Zihan Xi <zihanx@nebusec.ai>
    netfilter: nf_conntrack: defer invalid log until after unlock

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: sctp: use nf log infrastructure for invalid packets

Hyunjung Ko <hj351016@gmail.com>
    net/sched: act_ct: fix sk_buff leak when the header checks reject a packet

Xin Long <lucien.xin@gmail.com>
    openvswitch: move key and ovs_cb update out of handle_fragments

Xin Long <lucien.xin@gmail.com>
    net: sched: use skb_ip_totlen and iph_totlen

Xin Long <lucien.xin@gmail.com>
    openvswitch: use skb_ip_totlen in conntrack

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: Serialize accesses to the owner and mirror list with separate lock

Sun Jian <sun.jian.kdev@gmail.com>
    veth: fix skb length accounting after XDP frag adjustment

Stanislav Fomichev <sdf@google.com>
    veth: Introduce veth_xdp_buff wrapper for xdp_buff

Lorenzo Stoakes (ARM) <ljs@kernel.org>
    mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF

Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
    drm/amdgpu: move debug_vm handling to amdgpu_cs_parser_fini

Tu Nguyen <tu.nguyen.xg@renesas.com>
    can: rcar_canfd: change the initializing flow for clocks and resets

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_canfd: Extract rcar_canfd_global_{,de}init()

Biju Das <biju.das.jz@bp.renesas.com>
    can: rcar_canfd: Use devm_clk_get_optional() for RAM clk

Geert Uytterhoeven <geert+renesas@glider.be>
    can: rcar_canfd: Invert reset assert order

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix pptable use-after-free

Yang Wang <kevinyang.wang@amd.com>
    drm/amd/pm: fix torn gpu metrics reads

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: gs_usb_receive_bulk_callback(): resubmit URB on skb allocation failure

Jonas Gorski <jonas.gorski@bisdn.de>
    i2c: iproc: reset bus after timeout if START_BUSY is stuck

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: bcm-iproc: remove printout on handled timeouts

Christian Brauner <brauner@kernel.org>
    binfmt_misc: restore write access when removing an entry

Amir Goldstein <amir73il@gmail.com>
    fs: don't block write during exec on pre-content watched files

Amir Goldstein <amir73il@gmail.com>
    fsnotify: opt-in for permission events at file open time

Dawei Feng <dawei.feng@seu.edu.cn>
    ice: fix memory leak in ice_lbtest_prepare_rings()

Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
    ice: fix VF interrupts cleanup

Matt Fleming <mfleming@cloudflare.com>
    veth: convert frag_list skbs before running XDP

Chengfeng Ye <nicoyip.dev@gmail.com>
    net: pktgen: fix proc entry use-after-free

Peter Seiderer <ps.report@gmx.net>
    net: pktgen: fix code style (WARNING: Block comments)

David Carlier <devnexen@gmail.com>
    igc: remove napi_synchronize() in igc_down()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: reject repeated SMB2 NEGOTIATE requests

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: conn lock to serialize smb2 negotiate

Chengfeng Ye <nicoyip.dev@gmail.com>
    Bluetooth: hci_sync: Fix advertising data UAFs

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1

Gustavo A. R. Silva <gustavoars@kernel.org>
    Bluetooth: hci_conn, hci_sync: Use __counted_by() to avoid -Wfamnae warnings

Kees Cook <keescook@chromium.org>
    overflow: Change DEFINE_FLEX to take __counted_by member

Gregory Price <gourry@gourry.net>
    mm/vmstat: fold stranded per-cpu node stats when a node comes online

Zihan Xi <xizh2024@lzu.edu.cn>
    Bluetooth: mgmt: fix UAF in pair command cancellation

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Protect mgmt_pending list with its own lock

Dr. David Alan Gilbert <linux@treblig.org>
    Bluetooth: MGMT: Remove unused mgmt_pending_find_data

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: MGMT: Fix not generating command complete for MGMT_OP_DISCONNECT

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: hci_sync: Introduce hci_cmd_sync_run/hci_cmd_sync_run_once

Michael Bommarito <michael.bommarito@gmail.com>
    erofs: cap LZMA stream pool size

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: maintain cookies of share domain in self-contained list

Gao Xiang <xiang@kernel.org>
    erofs: tidy up internal.h

Kefeng Wang <wangkefeng.wang@huawei.com>
    mm: migrate_device: fix pte_pfn/pte_dirty called on non-present PTE

David Hildenbrand <david@redhat.com>
    mm/migrate_device: page_remove_rmap() -> folio_remove_rmap_pte()

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: validate minimum PDU size for transform requests

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix minimum SMB2 PDU size

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: fix minimum SMB1 PDU size

Namjae Jeon <linkinjeon@kernel.org>
    ksmbd: rename smb2_get_msg to smb_get_msg

ChenXiaoSong <chenxiaosong@kylinos.cn>
    smb/server: rename include guard in smb_common.h

Christian Brauner <brauner@kernel.org>
    super: fix emergency thaw deadlock on frozen block devices

Wentao Guan <guanwentao@uniontech.com>
    ksmbd: restore DACL size on check_add_overflow() to avoid malformed ACL

Haofeng Li <lihaofeng@kylinos.cn>
    ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl

Ferry Meng <mengferry@linux.alibaba.com>
    ksmbd: fix SID memory leak in set_posix_acl_entries_dacl() on overflow

Aldo Ariel Panzardo <qwe.aldo@gmail.com>
    net/sched: serialize qdisc_rtab_list against concurrent get/put

Shiming Cheng <shiming.cheng@mediatek.com>
    net: gro: fix double aggregation of flush-marked skbs

Felix Fietkau <nbd@nbd.name>
    net: move skb_gro_receive_list from udp to core

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix two unsafe bare decodes in decode_lockers()

Chancel Liu <chancel.liu@nxp.com>
    ASoC: fsl_sai: Fix spurious BCLK on resume by clearing BYP

Max Kellermann <max.kellermann@ionos.com>
    ceph: fix hanging __ceph_get_caps() with stale mds_wanted

Xiubo Li <xiubli@redhat.com>
    ceph: rename _to_client() to _to_fs_client()

Xiubo Li <xiubli@redhat.com>
    ceph: pass the mdsc to several helpers

Xiubo Li <xiubli@redhat.com>
    libceph: add doutc and *_client debug macros support

Xiang Mei <xmei5@asu.edu>
    libceph: bound pg_{temp,upmap,upmap_items} length to CEPH_PG_MAX_SIZE

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    libceph: Amend checking to fix `make W=1` build breakage

Max Kellermann <max.kellermann@ionos.com>
    ceph: avoid fs reclaim while using current->journal_info

Zhiling Zou <roxy520tt@gmail.com>
    sctp: avoid auth_enable sysctl UAF during netns teardown

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: userspace: fix use-after-free in get_local_id

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: use addr entry for get_local_id

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: add mptcp_userspace_pm_lookup_addr helper

Geliang Tang <tanggeliang@kylinos.cn>
    mptcp: pm: avoid code duplication to lookup endp

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: access mei_device under device_lock on cleanup

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ALSA: hda: codecs: hdmi: disable keep-alive before audio format change

LiangCheng Wang <zaq14760@gmail.com>
    wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
    wifi: brcmfmac: fix 43752 SDIO FWVID incorrectly labelled as Cypress (CYW)

Fan Wu <fanwu01@zju.edu.cn>
    wifi: brcmfmac: drain bus_reset work on device removal

Daniel Hodges <git@danielhodges.dev>
    wifi: ath6kl: fix use-after-free in aggr_reset_state()

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: imx219: Fix maximum frame length in lines

Jai Luthra <jai.luthra@ideasonboard.com>
    media: i2c: imx219: Rename VTS to FRM_LENGTH

David Plowman <david.plowman@raspberrypi.com>
    media: i2c: imx219: Correct the minimum vblanking value

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: i2c: imx219: Drop IMX219_VTS_* macros

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: check streams[] bounds before overflow

Jani Nikula <jani.nikula@intel.com>
    drm/i915/hdcp: require monotonically increasing seq_num_v

Suraj Kandpal <suraj.kandpal@intel.com>
    drm/i915/hdcp: Move to using intel_display in intel_hdcp

Jani Nikula <jani.nikula@intel.com>
    drm/i915/vrr: require valid min/max vfreq for VRR

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915/vrr: Check HAS_VRR() first in intel_vrr_is_capable()

Timur Kristóf <timur.kristof@gmail.com>
    drm/amdgpu: Respect placement requirements in amdgpu_gtt_mgr functions

Thomas Zimmermann <tzimmermann@suse.de>
    drm/tegra: fbdev: Remove offset into framebuffer memory

Jani Nikula <jani.nikula@intel.com>
    drm/displayid: fix Tiled Display Topology ID size

Andrei Kuchynski <akuchynski@chromium.org>
    usb: typec: ucsi: Fix race condition and ordering in port unregistration

Sergey Senozhatsky <senozhatsky@chromium.org>
    usb: typec: ucsi: split connector lock classes

Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
    usb: typec: ucsi: Only enable supported notifications

Cen Zhang <zzzccc427@gmail.com>
    usb: gadget: f_tcm: synchronize delayed set_alt with teardown

Vitor Soares <vitor.soares@toradex.com>
    drm/bridge: cdns-dsi: Replace deprecated UNIVERSAL_DEV_PM_OPS()

Guangshuo Li <lgs201920130244@gmail.com>
    usb: musb: omap2430: Do not put borrowed of_node in probe

Johan Hovold <johan@kernel.org>
    usb: musb: omap2430: clean up probe error handling

Venkatesh Srinivas <venkateshs@chromium.org>
    KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN

David Matlack <dmatlack@google.com>
    KVM: Introduce vcpu->wants_to_run

Alex Williamson <alex.williamson@nvidia.com>
    vfio/pci: Fix racy bitfields and tighten struct layout

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: HCI: Remove HCI_AMP support

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    Bluetooth: Remove usage of the deprecated ida_simple_xx() API

Reinette Chatre <reinette.chatre@intel.com>
    fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list

Peng Fan <peng.fan@nxp.com>
    pmdomain: imx: Fix i.MX8MP power notifier

Bryam Vargas <hexlabsecurity@proton.me>
    ata: libata-core: Reject an invalid concurrent positioning ranges count

Dawei Feng <dawei.feng@seu.edu.cn>
    octeontx2-pf: fix SQB pointer leak on init failure

Haoxiang Li <haoxiang_li2024@163.com>
    net: ipa: fix SMEM state handle leaks in SMP2P init

Crystal Wood <crwood@redhat.com>
    tracing/osnoise: Call synchronize_rcu() when unregistering

Uladzislau Rezki (Sony) <urezki@gmail.com>
    tracing: Rename kvfree_rcu() to kvfree_rcu_mightsleep()

Théo Lebrun <theo.lebrun@bootlin.com>
    net: macb: drop in-flight Tx SKBs on close

Wentao Liang <vulab@iscas.ac.cn>
    ipmi: fix refcount leak in i_ipmi_request()

Breno Leitao <leitao@debian.org>
    bootconfig: fix NULL-pointer arithmetic in xbc_snprint_cmdline()

Breno Leitao <leitao@debian.org>
    bootconfig: move xbc_snprint_cmdline() to lib/bootconfig.c

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    bootconfig: do not put quotes on cmdline items unless necessary

Sabrina Dubroca <sd@queasysnail.net>
    espintcp: use sk_msg_free_partial to fix partial send

David Howells <dhowells@redhat.com>
    tcp_bpf, smc, tls, espintcp, siw: Reduce MSG_SENDPAGE_NOTLAST usage

David Howells <dhowells@redhat.com>
    siw: Inline do_tcp_sendpages()

David Howells <dhowells@redhat.com>
    espintcp: Inline do_tcp_sendpages()

David Howells <dhowells@redhat.com>
    tcp_bpf: Inline do_tcp_sendpages as it's now a wrapper around tcp_sendmsg

Bryam Vargas <hexlabsecurity@proton.me>
    net/sched: sch_taprio: Replace direct dequeue call with peek and qdisc_dequeue_peeked

Vladimir Oltean <vladimir.oltean@nxp.com>
    net/sched: taprio: avoid calling child->ops->dequeue(child) twice

Junrui Luo <moonafterrain@outlook.com>
    octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    gpio: mt7621: avoid corruption of shared interrupt trigger state

Runyu Xiao <runyu.xiao@seu.edu.cn>
    gpio: tegra: do not call pinctrl for GPIO direction

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    treewide: rename pinctrl_gpio_direction_input_new()

Maoyi Xie <maoyixie.tju@gmail.com>
    net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink

Zihan Xi <xizh2024@lzu.edu.cn>
    net/sched: act_ct: preserve tc_skb_cb across defragmentation

Dexuan Cui <decui@microsoft.com>
    net: mana: Validate the packet length reported by the NIC

Thomas Gleixner <tglx@kernel.org>
    locking/rt: Fix the incorrect RCU protection in rt_spin_unlock()

Guangshuo Li <lgs201920130244@gmail.com>
    mmc: vub300: fix use-after-free on probe failure

Johan Hovold <johan@kernel.org>
    mmc: vub300: rename probe error labels

Johan Hovold <johan@kernel.org>
    mmc: vub300: fix use-after-free on disconnect

Maoyi Xie <maoyixie.tju@gmail.com>
    wifi: libertas_tf: fix use-after-free in lbtf_free_adapter()

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: ims-pcu - fix firmware leak in async update

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    firmware_loader: introduce __free() cleanup hanler

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: make error counter atomic

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: don't increment hash_offset twice

Heinz Mauelshagen <heinzm@redhat.com>
    dm: remove unnecessary braces from single statement blocks

Heinz Mauelshagen <heinzm@redhat.com>
    dm: add missing empty lines

Heinz Mauelshagen <heinzm@redhat.com>
    dm crypt: correct 'foo*' to 'foo *'

Heinz Mauelshagen <heinzm@redhat.com>
    dm: fix trailing statements

Mikulas Patocka <mpatocka@redhat.com>
    dm-verity: avoid double increment of &use_bh_wq_enabled

Souvik Banerjee <souvik@amlalabs.com>
    ovl: use linked upper dentry in copy-up tmpfile

Jann Horn <jannh@google.com>
    bpf,fork: wipe ->bpf_storage before bailouts that access it

Vincent Jardin <vjardin@free.fr>
    i2c: imx: fix locked bus on SMBus block-read of 0 (atomic)

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    i2c: imx: separate atomic, dma and non-dma use case

Michael Bommarito <michael.bommarito@gmail.com>
    thunderbolt: Prevent XDomain delayed work use-after-free on disconnect

Yiyang Chen <cyyzero16@gmail.com>
    taskstats: retain dead thread stats in TGID queries

Oleg Nesterov <oleg@redhat.com>
    taskstats: fill_stats_for_tgid: use for_each_thread()

Maoyi Xie <maoyixie.tju@gmail.com>
    net: thunderbolt: Fix frags[] overflow by bounding frame_count

Florian Fuchs <fuchsfl@gmail.com>
    mtd: maps: vmu-flash: fix fault in unaligned fixup

Breno Leitao <leitao@debian.org>
    9p: skip nlink update in cacheless mode to fix WARN_ON

Muchun Song <muchun.song@linux.dev>
    mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/vmemmap/devdax: fix kernel crash when probing devdax devices

Mike Rapoport (IBM) <rppt@kernel.org>
    mm: move most of core MM initialization to mm/mm_init.c

Michael Bommarito <michael.bommarito@gmail.com>
    ntfs3: validate split-point offset in indx_insert_into_buffer

Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
    fs/ntfs3: Undo critial modificatins to keep directory consistency

Fernando Fernandez Mancera <fmancera@suse.de>
    netfilter: nft_objref: validate objref and objrefmap expressions

Yue Haibing <yuehaibing@huawei.com>
    netfilter: nf_tables: Remove unused nft_reduce_is_readonly()

Jeremy Sowden <jeremy@azazel.net>
    netfilter: bitwise: rename some boolean operation functions

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: drop unused 3rd argument from validate callback ops

Florian Westphal <fw@strlen.de>
    netfilter: nf_tables: pass context structure to nft_parse_register_load

Wasim Nazir <wasim.nazir@oss.qualcomm.com>
    remoteproc: qcom: Fix leak when custom dump_segments addition fails

Yogesh Lal <quic_ylal@quicinc.com>
    remoteproc: qcom: pas: Adjust the phys addr wrt the mem region

Mukesh Ojha <quic_mojha@quicinc.com>
    remoteproc: qcom: fix sparse warnings

Mukesh Ojha <quic_mojha@quicinc.com>
    remoteproc: qcom: replace kstrdup with kstrndup

Tristan Madani <tristan@talencesecurity.com>
    selinux: avoid sk_socket dereference in selinux_sctp_bind_connect()

Casey Schaufler <casey@schaufler-ca.com>
    lsm: infrastructure management of the sock security

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack_sip: validate skb_dst() before accessing it

Florian Westphal <fw@strlen.de>
    netfilter: nf_conntrack_sip: remove net variable shadowing

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: don't leak bad clone into future transaction

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: move cloning of match info to insert/removal path

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: merge deactivate helper into caller

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: prepare walk function for on-demand clone

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: make pipapo_clone helper return NULL

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: move prove_locking helper around

Florian Westphal <fw@strlen.de>
    netfilter: nft_set_pipapo: use GFP_KERNEL for insertions

Sumanth Korikkar <sumanthk@linux.ibm.com>
    s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: merge source files for CPU Measurement counter facility

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: remove in-kernel counting facility interface

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: move stccm_avail()

Thomas Richter <tmricht@linux.ibm.com>
    s390/cpum_cf: move cpum_cf_ctrset_size()

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8192: Check runtime resume during probe

Tang Bin <tangbin@cmss.chinamobile.com>
    ASoC: mediatek: mt8192-afe-pcm: Simplify probe() with local dev variable

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: Use common mtk_afe_pcm_platform with common probe cb

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: mt8192-afe-pcm: Simplify with dev_err_probe()

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: mt8192-afe-pcm: Convert to devm_pm_runtime_enable()

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-control: Fix heap overflow in bytes_ext put/get

Cássio Gabriel <cassiogabrielcontato@gmail.com>
    ASoC: mediatek: mt8183: Check runtime resume during probe

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-vf: clear stale mailbox IRQ state before request_irq()

Runyu Xiao <runyu.xiao@seu.edu.cn>
    octeontx2-pf: clear stale mailbox IRQ state before request_irq()

Subbaraya Sundeep <sbhatta@marvell.com>
    octeontx2: Annotate mmio regions as __iomem

Wentao Liang <vulab@iscas.ac.cn>
    mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum: On port enslavement to a LAG, join upper's bridges

Jason Wang <jasowang@redhat.com>
    VDUSE: avoid leaking information to userspace

Eugenio Pérez <eperezma@redhat.com>
    vduse: take out allocations from vduse_dev_alloc_coherent

Eugenio Pérez <eperezma@redhat.com>
    vduse: remove unused vaddr parameter of vduse_domain_free_coherent

Sheng Zhao <sheng.zhao@bytedance.com>
    vduse: Use fixed 4KB bounce pages for non-4KB page size

Li Xiasong <lixiasong1@huawei.com>
    tipc: restrict socket queue dumps in enqueue tracepoints

Jiacheng Yu <yujiacheng3@huawei.com>
    fbcon: Use correct type for vc_resize() return value

Thomas Zimmermann <tzimmermann@suse.de>
    fbcon: Rename struct fbcon_ops to struct fbcon_par

Li Daming <d4n.for.sec@gmail.com>
    rxrpc: serialize kernel accept preallocation with socket teardown

Tapio Reijonen <tapio.reijonen@vaisala.com>
    serial: max310x: implement gpio_chip::get_direction()

Hugo Villeneuve <hvilleneuve@dimonoff.com>
    serial: max310x: replace bare use of 'unsigned' with 'unsigned int' (checkpatch)

Xu Rao <raoxu@uniontech.com>
    ALSA: hda: Fix cached processing coefficient verbs

Zhang Heng <zhangheng@kylinos.cn>
    ALSA: hda: conexant: Remove mic bias threshold override

Ricardo Robaina <rrobaina@redhat.com>
    audit: fix recursive locking deadlock in audit_dupe_exe()

Ricardo Robaina <rrobaina@redhat.com>
    audit: use 'unsigned int' instead of 'unsigned'

Jeff Layton <jlayton@kernel.org>
    audit: widen ino fields to u64

NeilBrown <neil@brown.name>
    VFS/audit: introduce kern_path_parent() for audit

Bryam Vargas <hexlabsecurity@proton.me>
    Input: mms114 - reject an oversized device packet size

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: mms114 - fix touch indexing for MMS134S and MMS136

Haoxiang Li <haoxiang_li2024@163.com>
    i2c: davinci: Unregister cpufreq notifier on probe failure

Sebastian Alba Vives <sebasjosue84@gmail.com>
    fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()

Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
    dma-buf/udmabuf: skip redundant cpu sync to fix cacheline EEXIST warning

Jason Gunthorpe <jgg@ziepe.ca>
    udmabuf: Do not create malformed scatterlists

Weinan Liu <wnliu@google.com>
    iommu/amd: Don't split flush for amd_iommu_domain_flush_all()

Matt Bobrowski <mattbobrowski@google.com>
    bpf: Reject BPF_MAP_TYPE_INODE_STORAGE creation if BPF LSM is uninitialized

Pedro Falcato <pfalcato@suse.de>
    mm: do file ownership checks with the proper mount idmap

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Don't use PGD entries for the linear mapping

Xiang Mei <xmei5@asu.edu>
    net: bonding: fix use-after-free in bond_xmit_broadcast()

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Provide pgtable_l5_enabled on rv32

Christoph Hellwig <hch@lst.de>
    xfs: check v5 superblock features early

Long Li <leo.lilong@huawei.com>
    xfs: don't swallow dquot recovery verification errors

Long Li <leo.lilong@huawei.com>
    xfs: fix ilock leak on error in xfs_dq_get_next_id

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Fix UVD decode image min size calculation

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Implement insert_end for VCE 3

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Reject UVD message with dimensions above 4096

Candice Li <candice.li@amd.com>
    drm/amdgpu: validate GEM_CREATE domain combinations

David Rosca <david.rosca@amd.com>
    drm/amdgpu: Reject UVD message with invalid number of h265 refs

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Fix out of bounds check on CCW array

Eric Farman <farman@linux.ibm.com>
    s390/vfio_ccw: Ensure index for read/write regions are within range

Guangshuo Li <lgs201920130244@gmail.com>
    drm/radeon: fix autosuspend cleanup during teardown

Pei Xiao <xiaopei01@kylinos.cn>
    mmc: atmel-mci: Fix use-after-free in atmci_remove due to race condition

Haibo Chen <haibo.chen@nxp.com>
    mmc: sdhci: make tuning_err a signed int

Myeonghun Pak <mhun512@gmail.com>
    mmc: sdhci: unmap the bounce buffer before device release

Zhan Xusheng <zhanxusheng1024@gmail.com>
    mmc: omap_hsmmc: fix busy_timeout overflow in ns conversion on 32-bit

Kefu Chai <k.chai@proxmox.com>
    libceph: tolerate addrvecs with multiple entries of the same type

Yiming Zhu <zhuyiming@kuaishou.com>
    ceph: fix MDS random selection readiness predicate

Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
    libceph: Avoid using invalid osd indices from primary_temp

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: sur40 - fix V4L error path cleanup

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: sur40 - fix input device registration ordering

Ali Ahmet Memis <ali@iusegentoo.com>
    openrisc: signal: do not restore privileged SR bits on sigreturn

Josh Poimboeuf <jpoimboe@kernel.org>
    ftrace: Fix off-by-one fentry site disable in ftrace_free_mem()

Pavitra Jha <jhapavitra98@gmail.com>
    libceph: fix multiple unsafe decodes in decode_locker()

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: qce - fix error path in devm_qce_register_algs

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - propagate F54 worker errors to V4L2 queue

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - block s_input when F54 queue is busy

Bryam Vargas <hexlabsecurity@proton.me>
    Input: synaptics-rmi4 - bound the F54 report size to the allocated buffer

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - zero report size on F54 work error

George Wilson <gcwilson@linux.ibm.com>
    powerpc/pseries: lparcfg - fix kbuf[] underflow

Pengpeng Hou <pengpeng@iscas.ac.cn>
    Input: iforce - validate input packet lengths

Zhefu Zhang <a723356@gmail.com>
    Input: atkbd - skip deactivate for Xiaomi Book Pro 14's internal keyboard

Linmao Li <lilinmao@kylinos.cn>
    Input: psxpad-spi - set driver data before use

Richard Davies <richard@arachsys.com>
    Input: focaltech - fix array out-of-bounds in focaltech_process_rel_packet

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: synaptics-rmi4 - fix F55 transmitter electrode count typo

George Wilson <gcwilson@linux.ibm.com>
    powerpc/pseries: pci - logic bug

Dawid Wróbel <me@dawidwrobel.com>
    ASoC: codecs: lpass-wsa-macro: Fix enum kcontrol accesses

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: cs35l41: sort the register default table

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: cs4265: sort the register default table

Hidayath Khan <hidayath@linux.ibm.com>
    s390/qeth: validate user buffer length in SNMP and ARP query ioctls

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    mptcp: options: reset DSS fields in case of unexpected size

Gang Yan <yangang@kylinos.cn>
    selftests: mptcp: join: mark tests with data corruption as failed

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: do not cancel a policy conversion that never started

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: reject a class permission count below its inherited common

Bryam Vargas <hexlabsecurity@proton.me>
    selinux: require every boolean value to be defined

Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
    ipvs: separate destination availability state

Zhan Xusheng <zhanxusheng@xiaomi.com>
    fscrypt: use the mount idmap for the owner check in fscrypt_ioctl_set_policy()

Chao Yu <chao@kernel.org>
    f2fs: fix UAF issue in f2fs_merge_page_bio()

Matthew Rosato <mjrosato@linux.ibm.com>
    KVM: s390: pci: Fix aisb calculation

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix resource leak on IRQ registration failure

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix missing error codes and memory unaccounting

Farhan Ali <alifm@linux.ibm.com>
    KVM: s390: pci: Fix memory accounting for pinned/unpinned pages

Jason Gunthorpe <jgg@ziepe.ca>
    kernel/user: Allow user_struct::locked_vm to be usable for iommufd

Chao Shi <coshi036@gmail.com>
    block: stop the timeout timer when releasing a never added disk


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |   2 +
 arch/arm64/kvm/arm.c                               |   2 +-
 arch/mips/kvm/mips.c                               |   2 +-
 arch/openrisc/include/asm/processor.h              |   2 +
 arch/openrisc/kernel/signal.c                      |   5 +-
 arch/powerpc/kvm/powerpc.c                         |   2 +-
 arch/powerpc/platforms/pseries/lparcfg.c           |   2 +-
 arch/powerpc/platforms/pseries/pci.c               |   2 +-
 arch/riscv/include/asm/pgtable-32.h                |   3 +
 arch/riscv/include/asm/pgtable.h                   |   1 -
 arch/riscv/kvm/vcpu.c                              |   2 +-
 arch/riscv/mm/init.c                               |  11 +-
 arch/s390/include/asm/cpu_mcf.h                    | 112 ------
 arch/s390/kernel/Makefile                          |   2 +-
 arch/s390/kernel/perf_cpum_cf.c                    | 272 ++++++++++++-
 arch/s390/kernel/perf_cpum_cf_common.c             | 233 ------------
 arch/s390/kernel/perf_pai_ext.c                    |   2 +-
 arch/s390/kvm/kvm-s390.c                           |   2 +-
 arch/s390/kvm/pci.c                                |  86 +++--
 arch/s390/kvm/pci.h                                |   2 +
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  12 +-
 arch/x86/kvm/lapic.c                               |   2 +-
 arch/x86/kvm/svm/sev.c                             |  34 +-
 arch/x86/kvm/svm/svm.h                             |   1 +
 arch/x86/kvm/x86.c                                 |   4 +-
 block/genhd.c                                      |  12 +-
 crypto/ccm.c                                       |   2 +-
 drivers/ata/libata-core.c                          |  18 +
 drivers/ata/libata-scsi.c                          |   2 -
 drivers/ata/libata.h                               |   9 +
 drivers/bluetooth/btmrvl_main.c                    |   9 -
 drivers/bluetooth/btrsi.c                          |   1 -
 drivers/bluetooth/btsdio.c                         |   8 -
 drivers/bluetooth/btusb.c                          |   5 -
 drivers/bluetooth/hci_ldisc.c                      |   6 -
 drivers/bluetooth/hci_serdev.c                     |   5 -
 drivers/bluetooth/hci_uart.h                       |   1 -
 drivers/bluetooth/hci_vhci.c                       |  10 +-
 drivers/bluetooth/virtio_bt.c                      |   2 -
 drivers/char/ipmi/ipmi_msghandler.c                |   8 +
 drivers/crypto/qce/core.c                          |   2 +-
 drivers/dma-buf/udmabuf.c                          |  21 +-
 drivers/fpga/dfl-afu-main.c                        |   3 +
 drivers/gpio/gpio-mt7621.c                         |   2 +
 drivers/gpio/gpio-mvebu.c                          |   4 +-
 drivers/gpio/gpio-pxa.c                            |   4 +-
 drivers/gpio/gpio-tegra.c                          |  18 +-
 drivers/gpio/gpio-vf610.c                          |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  21 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_gtt_mgr.c        |  30 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |  11 +-
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c              |  26 +-
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |  27 +-
 drivers/gpu/drm/amd/pm/amdgpu_pm.c                 |  16 +-
 drivers/gpu/drm/amd/pm/inc/amdgpu_dpm.h            |   6 +-
 drivers/gpu/drm/bridge/cdns-dsi.c                  |  11 +-
 drivers/gpu/drm/drm_connector.c                    |  12 +-
 drivers/gpu/drm/i915/display/intel_display_core.h  |   3 +
 drivers/gpu/drm/i915/display/intel_hdcp.c          |  22 +-
 drivers/gpu/drm/i915/display/intel_vrr.c           |  10 +-
 drivers/gpu/drm/i915/i915_driver.c                 |   3 +
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 +
 drivers/gpu/drm/tegra/fb.c                         |   8 +-
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  11 +-
 drivers/i2c/busses/i2c-davinci.c                   |   4 +-
 drivers/i2c/busses/i2c-imx.c                       | 126 +++++--
 drivers/infiniband/sw/siw/siw_qp_tx.c              |  17 +-
 drivers/input/joystick/iforce/iforce-packets.c     |  11 +-
 drivers/input/joystick/iforce/iforce-usb.c         |   3 +
 drivers/input/joystick/psxpad-spi.c                |   1 +
 drivers/input/keyboard/atkbd.c                     |   8 +
 drivers/input/misc/ims-pcu.c                       |   5 +-
 drivers/input/mouse/focaltech.c                    |   2 +-
 drivers/input/rmi4/rmi_f54.c                       |  43 ++-
 drivers/input/rmi4/rmi_f55.c                       |   4 +-
 drivers/input/touchscreen/mms114.c                 |  21 +-
 drivers/input/touchscreen/sur40.c                  |  23 +-
 drivers/iommu/amd/iommu.c                          |   3 +-
 drivers/md/dm-bufio.c                              |   9 +
 drivers/md/dm-cache-metadata.c                     |   6 +
 drivers/md/dm-cache-policy-internal.h              |   3 +
 drivers/md/dm-cache-policy-smq.c                   |   2 +
 drivers/md/dm-cache-target.c                       |  12 +-
 drivers/md/dm-crypt.c                              |  20 +-
 drivers/md/dm-era-target.c                         |  10 +-
 drivers/md/dm-flakey.c                             |   4 +-
 drivers/md/dm-integrity.c                          | 182 +++++----
 drivers/md/dm-io.c                                 |  25 +-
 drivers/md/dm-ioctl.c                              |  18 +-
 drivers/md/dm-kcopyd.c                             |   2 +
 drivers/md/dm-log.c                                |   6 +
 drivers/md/dm-mpath.c                              |   3 +
 drivers/md/dm-rq.c                                 |   2 +
 drivers/md/dm-snap-persistent.c                    |  23 +-
 drivers/md/dm-snap.c                               |  10 +-
 drivers/md/dm-stats.c                              |  24 +-
 drivers/md/dm-stripe.c                             |  10 +-
 drivers/md/dm-sysfs.c                              |   1 +
 drivers/md/dm-table.c                              |   3 +-
 drivers/md/dm-thin-metadata.c                      |   5 +-
 drivers/md/dm-thin.c                               |   5 +
 drivers/md/dm-verity-target.c                      |  24 +-
 drivers/md/dm-verity.h                             |   2 +-
 drivers/md/dm-writecache.c                         |  54 ++-
 drivers/md/persistent-data/dm-array.c              |   4 +
 drivers/md/persistent-data/dm-bitset.c             |   1 +
 drivers/md/persistent-data/dm-block-manager.c      |   7 +-
 drivers/md/persistent-data/dm-btree-internal.h     |   1 +
 drivers/md/persistent-data/dm-btree-remove.c       |   5 +
 drivers/md/persistent-data/dm-btree-spine.c        |   6 +-
 drivers/md/persistent-data/dm-btree.c              |  10 +
 drivers/md/persistent-data/dm-space-map-common.c   |   6 +
 drivers/md/persistent-data/dm-space-map-disk.c     |  12 +-
 drivers/md/persistent-data/dm-space-map-metadata.c |   3 +
 .../md/persistent-data/dm-transaction-manager.c    |   1 +
 drivers/media/i2c/imx219.c                         |  47 +--
 drivers/misc/mei/bus.c                             |  16 +-
 drivers/mmc/host/atmel-mci.c                       |   2 +
 drivers/mmc/host/omap_hsmmc.c                      |   2 +-
 drivers/mmc/host/sdhci.c                           |  16 +
 drivers/mmc/host/sdhci.h                           |   2 +-
 drivers/mmc/host/vub300.c                          |  36 +-
 drivers/mtd/maps/vmu-flash.c                       |   8 +-
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/can/rcar/rcar_canfd.c                  | 177 +++++----
 drivers/net/can/usb/gs_usb.c                       |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |  22 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  10 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  27 ++
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  21 ++
 drivers/net/ethernet/intel/igc/igc_main.c          |   1 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  14 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |   9 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  14 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  13 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  92 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  13 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +
 drivers/net/ipa/ipa_smp2p.c                        |  30 +-
 drivers/net/ipvlan/ipvlan_main.c                   |   4 +
 drivers/net/macvlan.c                              |   4 +
 drivers/net/thunderbolt.c                          |   8 +-
 drivers/net/veth.c                                 |  78 ++--
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  16 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  45 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/pinctrl/cirrus/pinctrl-lochnagar.c         |   2 +-
 drivers/pinctrl/core.c                             |  15 +-
 drivers/pinctrl/intel/pinctrl-cherryview.c         |   4 +-
 drivers/pinctrl/intel/pinctrl-intel.c              |   4 +-
 drivers/pinctrl/intel/pinctrl-lynxpoint.c          |   4 +-
 drivers/pinctrl/mediatek/pinctrl-moore.c           |   4 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c      |   4 +-
 drivers/pinctrl/mediatek/pinctrl-paris.c           |   4 +-
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c          |   4 +-
 drivers/pinctrl/pinctrl-as3722.c                   |   4 +-
 drivers/pinctrl/pinctrl-axp209.c                   |   2 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |  11 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |   4 +-
 drivers/pinctrl/pinctrl-rk805.c                    |   4 +-
 drivers/pinctrl/pinctrl-st.c                       |   4 +-
 drivers/pinctrl/renesas/gpio.c                     |   4 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |   4 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |   4 +-
 drivers/remoteproc/qcom_common.c                   |  31 +-
 drivers/remoteproc/qcom_common.h                   |   5 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |  20 +-
 drivers/s390/cio/vfio_ccw_async.c                  |  16 +
 drivers/s390/cio/vfio_ccw_chp.c                    |  15 +
 drivers/s390/cio/vfio_ccw_cp.c                     |  17 +-
 drivers/s390/cio/vfio_ccw_ops.c                    |   7 +-
 drivers/s390/net/qeth_core_main.c                  |   3 +
 drivers/s390/net/qeth_l3_main.c                    |   5 +
 drivers/soc/imx/imx8m-blk-ctrl.c                   |  27 +-
 drivers/thunderbolt/xdomain.c                      |  40 +-
 drivers/tty/serial/max310x.c                       |  20 +-
 drivers/usb/gadget/function/f_tcm.c                | 192 ++++++++--
 drivers/usb/gadget/function/tcm.h                  |  13 +
 drivers/usb/musb/omap2430.c                        |  25 +-
 drivers/usb/typec/ucsi/ucsi.c                      |  95 +++--
 drivers/usb/typec/ucsi/ucsi.h                      |   1 +
 drivers/vdpa/vdpa_user/iova_domain.c               | 161 +++++---
 drivers/vdpa/vdpa_user/iova_domain.h               |  13 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  16 +-
 drivers/video/fbdev/core/bitblit.c                 | 122 +++---
 drivers/video/fbdev/core/fbcon.c                   | 420 ++++++++++-----------
 drivers/video/fbdev/core/fbcon.h                   |   6 +-
 drivers/video/fbdev/core/fbcon_ccw.c               | 148 ++++----
 drivers/video/fbdev/core/fbcon_cw.c                | 148 ++++----
 drivers/video/fbdev/core/fbcon_rotate.c            |  44 +--
 drivers/video/fbdev/core/fbcon_rotate.h            |   6 +-
 drivers/video/fbdev/core/fbcon_ud.c                | 164 ++++----
 drivers/video/fbdev/core/softcursor.c              |  18 +-
 drivers/video/fbdev/core/tileblit.c                |  28 +-
 fs/9p/vfs_inode.c                                  |   9 +
 fs/binfmt_elf.c                                    |   4 +-
 fs/binfmt_elf_fdpic.c                              |   4 +-
 fs/binfmt_misc.c                                   |  14 +-
 fs/ceph/addr.c                                     |  20 +-
 fs/ceph/cache.c                                    |   2 +-
 fs/ceph/caps.c                                     |  70 ++--
 fs/ceph/debugfs.c                                  |   4 +-
 fs/ceph/dir.c                                      |  24 +-
 fs/ceph/export.c                                   |  10 +-
 fs/ceph/file.c                                     |  35 +-
 fs/ceph/inode.c                                    |  14 +-
 fs/ceph/ioctl.c                                    |   8 +-
 fs/ceph/mds_client.c                               |  51 ++-
 fs/ceph/mds_client.h                               |   5 +-
 fs/ceph/mdsmap.c                                   |   5 +-
 fs/ceph/snap.c                                     |  18 +-
 fs/ceph/super.c                                    |  22 +-
 fs/ceph/super.h                                    |  13 +-
 fs/ceph/xattr.c                                    |  12 +-
 fs/crypto/policy.c                                 |   2 +-
 fs/erofs/Kconfig                                   |  15 +
 fs/erofs/decompressor_lzma.c                       |   3 +-
 fs/erofs/fscache.c                                 |  44 +--
 fs/erofs/internal.h                                |  87 ++---
 fs/exec.c                                          |   6 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/namei.c                                         |  43 +++
 fs/ntfs3/index.c                                   |  44 ++-
 fs/overlayfs/copy_up.c                             |  12 +-
 fs/smb/server/auth.c                               |   4 +-
 fs/smb/server/connection.c                         |  23 +-
 fs/smb/server/connection.h                         |   5 +
 fs/smb/server/oplock.c                             |   8 +-
 fs/smb/server/smb2pdu.c                            |  78 ++--
 fs/smb/server/smb2pdu.h                            |   9 -
 fs/smb/server/smb_common.c                         |  43 ++-
 fs/smb/server/smb_common.h                         |  15 +-
 fs/smb/server/smbacl.c                             |  27 +-
 fs/super.c                                         |  19 +-
 fs/xfs/libxfs/xfs_sb.c                             |   4 +-
 fs/xfs/xfs_dquot.c                                 |   3 +-
 fs/xfs/xfs_dquot_item_recover.c                    |   2 +-
 include/drm/drm_connector.h                        |   6 +-
 include/drm/drm_displayid.h                        |   2 +-
 include/linux/audit.h                              |   6 +-
 include/linux/audit_arch.h                         |  12 +-
 include/linux/bootconfig.h                         |   3 +
 include/linux/bpf_lsm.h                            |   4 +
 include/linux/ceph/ceph_debug.h                    |  38 ++
 include/linux/ceph/mdsmap.h                        |   5 +-
 include/linux/firmware.h                           |   3 +
 include/linux/fs.h                                 |  33 ++
 include/linux/kvm_host.h                           |   1 +
 include/linux/lsm_hooks.h                          |   1 +
 include/linux/mm.h                                 |  12 +
 include/linux/mmc/sdio_ids.h                       |   2 +-
 include/linux/namei.h                              |   1 +
 include/linux/overflow.h                           |  68 ++++
 include/linux/pinctrl/consumer.h                   |  13 +-
 include/linux/sched/user.h                         |   2 +-
 include/linux/thunderbolt.h                        |   3 +
 include/linux/vfio_pci_core.h                      |  13 +-
 include/net/bluetooth/hci.h                        | 114 ------
 include/net/bluetooth/hci_core.h                   |  48 +--
 include/net/bluetooth/hci_sync.h                   |   4 +
 include/net/gro.h                                  |   1 +
 include/net/ip_vs.h                                |   7 +
 include/net/netfilter/nf_tables.h                  |  11 +-
 include/net/netfilter/nft_fib.h                    |   4 +-
 include/net/netfilter/nft_meta.h                   |   3 +-
 include/net/netfilter/nft_reject.h                 |   3 +-
 include/uapi/linux/ip_vs.h                         |   6 -
 include/uapi/linux/netfilter/nf_tables.h           |  10 +-
 include/uapi/linux/virtio_bt.h                     |   1 -
 init/main.c                                        |  39 --
 kernel/audit.c                                     |   2 +-
 kernel/audit.h                                     |  32 +-
 kernel/audit_fsnotify.c                            |  39 +-
 kernel/audit_tree.c                                |   2 +-
 kernel/audit_watch.c                               |  42 ++-
 kernel/auditfilter.c                               |  17 +-
 kernel/auditsc.c                                   |   6 +-
 kernel/bpf/bpf_inode_storage.c                     |   9 +
 kernel/fork.c                                      |  20 +-
 kernel/locking/spinlock_rt.c                       |  27 +-
 kernel/taskstats.c                                 |  67 ++--
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/trace_osnoise.c                       |   4 +-
 kernel/trace/trace_probe.c                         |   2 +-
 kernel/user.c                                      |   1 +
 lib/bootconfig.c                                   |  65 ++++
 lib/compat_audit.c                                 |  12 +-
 mm/huge_memory.c                                   |  49 ++-
 mm/internal.h                                      |   4 +
 mm/madvise.c                                       |   3 +-
 mm/migrate_device.c                                |  42 ++-
 mm/mincore.c                                       |   3 +-
 mm/mm_init.c                                       | 150 ++++++++
 mm/page_alloc.c                                    | 160 +-------
 mm/pagewalk.c                                      |  10 +
 mm/sparse-vmemmap.c                                |   3 +-
 mm/vmalloc.c                                       |  75 +++-
 net/bluetooth/hci_conn.c                           |  24 +-
 net/bluetooth/hci_core.c                           | 145 ++-----
 net/bluetooth/hci_event.c                          | 150 +-------
 net/bluetooth/hci_sock.c                           |  11 +-
 net/bluetooth/hci_sync.c                           | 373 +++++++++---------
 net/bluetooth/l2cap_core.c                         |  21 +-
 net/bluetooth/mgmt.c                               | 367 +++++++++---------
 net/bluetooth/mgmt_util.c                          |  49 +--
 net/bluetooth/mgmt_util.h                          |   8 +-
 net/bridge/netfilter/nft_reject_bridge.c           |   3 +-
 net/ceph/cls_lock_client.c                         |  21 +-
 net/ceph/decode.c                                  |  18 +-
 net/ceph/osdmap.c                                  |   9 +-
 net/core/gro.c                                     |  31 ++
 net/core/pktgen.c                                  |  43 ++-
 net/ipv4/netfilter/nft_dup_ipv4.c                  |   4 +-
 net/ipv4/tcp_bpf.c                                 |  21 +-
 net/ipv4/udp_offload.c                             |  29 --
 net/ipv6/ip6_tunnel.c                              |   3 +
 net/ipv6/netfilter/nft_dup_ipv6.c                  |   4 +-
 net/mptcp/options.c                                |   8 +-
 net/mptcp/pm.c                                     |   9 +-
 net/mptcp/pm_netlink.c                             |  29 +-
 net/mptcp/pm_userspace.c                           |  87 +++--
 net/mptcp/protocol.h                               |   6 +-
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |  19 +-
 net/netfilter/ipset/ip_set_list_set.c              |  10 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   6 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   4 +-
 net/netfilter/ipvs/ip_vs_dh.c                      |   4 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |   8 +-
 net/netfilter/nf_conntrack_proto.c                 |   6 +
 net/netfilter/nf_conntrack_proto_sctp.c            |  48 +--
 net/netfilter/nf_conntrack_proto_tcp.c             | 132 ++++---
 net/netfilter/nf_conntrack_sip.c                   |  10 +-
 net/netfilter/nf_flow_table_core.c                 |   7 +-
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/netfilter/nf_tables_offload.c                  |   2 +-
 net/netfilter/nft_bitwise.c                        |  38 +-
 net/netfilter/nft_byteorder.c                      |   2 +-
 net/netfilter/nft_cmp.c                            |   6 +-
 net/netfilter/nft_compat.c                         |   6 +-
 net/netfilter/nft_ct.c                             |   2 +-
 net/netfilter/nft_dup_netdev.c                     |   2 +-
 net/netfilter/nft_dynset.c                         |   4 +-
 net/netfilter/nft_exthdr.c                         |   2 +-
 net/netfilter/nft_fib.c                            |   3 +-
 net/netfilter/nft_flow_offload.c                   |   3 +-
 net/netfilter/nft_fwd_netdev.c                     |   9 +-
 net/netfilter/nft_hash.c                           |   2 +-
 net/netfilter/nft_immediate.c                      |   3 +-
 net/netfilter/nft_lookup.c                         |   5 +-
 net/netfilter/nft_masq.c                           |   7 +-
 net/netfilter/nft_meta.c                           |   8 +-
 net/netfilter/nft_nat.c                            |  11 +-
 net/netfilter/nft_objref.c                         |  41 +-
 net/netfilter/nft_osf.c                            |   3 +-
 net/netfilter/nft_payload.c                        |   2 +-
 net/netfilter/nft_queue.c                          |   5 +-
 net/netfilter/nft_range.c                          |   2 +-
 net/netfilter/nft_redir.c                          |   7 +-
 net/netfilter/nft_reject.c                         |   3 +-
 net/netfilter/nft_reject_inet.c                    |   3 +-
 net/netfilter/nft_reject_netdev.c                  |   3 +-
 net/netfilter/nft_rt.c                             |   3 +-
 net/netfilter/nft_set_pipapo.c                     | 259 ++++++++-----
 net/netfilter/nft_set_pipapo.h                     |   8 +
 net/netfilter/nft_socket.c                         |   3 +-
 net/netfilter/nft_synproxy.c                       |   3 +-
 net/netfilter/nft_tproxy.c                         |   7 +-
 net/netfilter/nft_xfrm.c                           |   3 +-
 net/openvswitch/conntrack.c                        |  39 +-
 net/packet/af_packet.c                             |   7 +-
 net/rxrpc/call_accept.c                            |  27 +-
 net/sched/act_ct.c                                 |  41 +-
 net/sched/cls_u32.c                                |   3 +
 net/sched/sch_api.c                                |  24 +-
 net/sched/sch_cake.c                               |   2 +-
 net/sched/sch_taprio.c                             |  12 +-
 net/sctp/protocol.c                                |  20 +-
 net/sctp/sysctl.c                                  |   9 +-
 net/smc/smc_tx.c                                   |   6 +-
 net/tipc/socket.c                                  |   6 +-
 net/tls/tls_device.c                               |   4 +-
 net/tls/tls_sw.c                                   |   5 +
 net/x25/af_x25.c                                   |   4 +-
 net/x25/x25_timer.c                                |  25 +-
 net/xfrm/espintcp.c                                |  42 +--
 security/apparmor/include/net.h                    |   6 +-
 security/apparmor/lsm.c                            |  38 +-
 security/apparmor/net.c                            |   2 +-
 security/bpf/hooks.c                               |   3 +
 security/security.c                                |  47 ++-
 security/selinux/hooks.c                           |  95 +++--
 security/selinux/include/objsec.h                  |   5 +
 security/selinux/netlabel.c                        |  23 +-
 security/selinux/ss/policydb.c                     |  31 ++
 security/selinux/ss/services.c                     |   4 +-
 security/smack/smack.h                             |   5 +
 security/smack/smack_lsm.c                         |  70 ++--
 security/smack/smack_netfilter.c                   |   4 +-
 sound/hda/hdac_regmap.c                            |   4 +-
 sound/pci/hda/patch_conexant.c                     |   3 -
 sound/pci/hda/patch_hdmi.c                         |  48 ++-
 sound/soc/codecs/cs35l41-lib.c                     |   2 +-
 sound/soc/codecs/cs4265.c                          |   4 +-
 sound/soc/codecs/lpass-wsa-macro.c                 |   8 +-
 sound/soc/fsl/fsl_sai.c                            |  29 +-
 sound/soc/mediatek/mt8183/mt8183-afe-pcm.c         |  12 +-
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c         | 118 +++---
 sound/soc/sof/ipc3-control.c                       |  34 +-
 sound/soc/xilinx/xlnx_formatter_pcm.c              |  10 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   4 +-
 virt/kvm/kvm_main.c                                |   3 +
 424 files changed, 5764 insertions(+), 4185 deletions(-)


