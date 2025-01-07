Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F451DE4CA
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 09:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736242593; cv=none; b=EGzr/TdgL7x1vEBs53Mia4lOa6Bq4HegoIPuw1YXT8i/CtQeoHCTOiN0jMLTT0dlFUdTsEV7Pck2iWgfl34v5QWbqTDP1YC3hc1cV54NpcNTT59wQqwtLkfRLB65XpAv9Sj6Qvj0stVejYTQ/BeyDEUerP+edkf1wXpE94TZQvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736242593; c=relaxed/simple;
	bh=alpgiAlxBtoBE9Ge7lfS5hZ8Bujr24SckPiLSzGJii0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W7YRhFChkUO2I582074Zjj+KmRsDJvkqf8fTrxUwuD4ZuSw5xep77qTX7lGbf9G+i4CVzS8gxJwdyJg5TOKT8WItAGH1n3RjHR3pgMrJQlOD1VxQOuG2CZ5Cf7R56pjRikUNUXvjMJDTwBTz1UG5S8MGZRfI+pbOJn83z1tE91U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SuPNkUDX; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SuPNkUDX"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f4448bf96fso17141595a91.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 01:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736242587; x=1736847387; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnkHQ8IMRv7fj7hz0uzdkmj8NaJ61w0Ei15sMFl0PWU=;
        b=SuPNkUDXBuiCmjoLMo9zeg7io9wco1wirW2JLsMeSHn9ieK1fRcDimBgOEV2Wt3BuF
         LMtDvQ32CJVxozMJaCLhflWzRxdgzXpUpa/B+dYiAf5tGuTvTWZ7TRHubujp0P+Uc6lS
         vyQ6EMsrM8dDu0LdxNV1ZdNyABj/PugOhKr9J1NQrzlojk7EdJ64AlBvBDLSiAtgHcHS
         irL6XTAlOPAPCEoCfAnuWK8brw6LG/maBg5FcoUMx6CkkDGIT3IgEBYAOBKKI/r9xFB5
         cp0yGLlexs+sIuvNpmRPlPoA8ei15LKcZb3sRRKtrbVQtMLRTz8YFoZg+nbH08TmmIOo
         VVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736242587; x=1736847387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnkHQ8IMRv7fj7hz0uzdkmj8NaJ61w0Ei15sMFl0PWU=;
        b=xHTyJmdVH1vOBHVCYdfkPDOrnHXSoCMMqd2hmc+LV8EtdrV8UEj5XBo1/wqdMbjcXx
         2BJaMUVKXAQ+q0PAYk4xlKwz0acekbs7vYJeoeY+Pm4jzK7gxJhdJAtsSK/YYUu+LNQP
         ZQVRpomtSSiLBMn+M4JJjrumPfa0T9qmJPb1cBuA8r2yhm1UC2u5VLduNyba3EIw9v8q
         kdmwcTZuNHYXS4tVVJeCBZYarWcZoUqWFYTNpO5EdbiGyajV1n9NgmXpPNrRtLqPZ4xS
         Ch7OUPzxugkG5AKlgMLC9Ni9Wzn3fHenfVauzH5v0wRQTr3zXAMsMMT+KJygfBMHCspk
         fxGA==
X-Forwarded-Encrypted: i=1; AJvYcCXAuFYrLBJzbPtqUtoILn8ywdOi3S1oAFOUG4xRKvROBw+7YPbDdTGWpyVdkkjgCK4r3e7vLSD4@lists.linux.dev
X-Gm-Message-State: AOJu0YwMV6vpFukoDKtjSm+1prbNWyRswmDs4yOyepFZ0gl0FF+14T8q
	w2e/uwni6Wha/ydGRsPv1N81keNtmEXlT+zBeqaI1YcKeUupbzRl49VW/zgUQdnkGiEELtUDzab
	fnIzPEm4NHGp5P/dNAG7AQtJAZ9Q=
X-Gm-Gg: ASbGncv2xuw1ld7bDQDc8AQkpZtqzv0+WbBf0RQmeqWQHFVhk6e5SDyYC2t5pc6oL/g
	0BfCE0jQwAm4TAfgMAirI48miKuX33rMBO6Uu5iGK9l/VhcxFOoM4
X-Google-Smtp-Source: AGHT+IFmpvAP2oXHXQ5bnjYGFkot2NUwwD2Zbx4VfKgosM012hd/EdG/BLXadCPJUHtPG78YlVTaJrykQ+/aWMaQbDI=
X-Received: by 2002:a17:90a:d448:b0:2f4:43ce:dcea with SMTP id
 98e67ed59e1d1-2f452ee5e95mr82805018a91.25.1736242587039; Tue, 07 Jan 2025
 01:36:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151141.738050441@linuxfoundation.org>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 7 Jan 2025 10:36:14 +0100
Message-ID: <CADo9pHg0KX1yYNyqx6KQ7-P7HM5YAwe--ZVpAQTvv6ipKv_2cA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Works as it should

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den m=C3=A5n 6 jan. 2025 kl 16:34 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.12.9-rc1
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: don't always assume copied data in mptcp_cleanup_rbuf()
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: fix recvbuffer adjust on sleeping rcvmsg
>
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: fix TCP options overflow.
>
> Liu Shixin <liushixin2@huawei.com>
>     mm: hugetlb: independent PMD page table shared count
>
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>     mm: reinstate ability to map write-sealed memfd mappings read-only
>
> Seiji Nishikawa <snishika@redhat.com>
>     mm: vmscan: account for free pages to prevent infinite Loop in thrott=
le_direct_reclaim()
>
> Alessandro Carminati <acarmina@redhat.com>
>     mm/kmemleak: fix sleeping function called from invalid context at pri=
nt message
>
> Yafang Shao <laoar.shao@gmail.com>
>     mm/readahead: fix large folio support in async readahead
>
> Joshua Washington <joshwash@google.com>
>     gve: trigger RX NAPI instead of TX NAPI in gve_xsk_wakeup
>
> Joshua Washington <joshwash@google.com>
>     gve: guard XDP xmit NDO on existence of xdp queues
>
> Joshua Washington <joshwash@google.com>
>     gve: fix XDP allocation path in edge cases
>
> Joshua Washington <joshwash@google.com>
>     gve: guard XSK operations on the existence of queues
>
> Joshua Washington <joshwash@google.com>
>     gve: clean XDP queues in gve_tx_stop_ring_gqi
>
> Joshua Washington <joshwash@google.com>
>     gve: process XSK TX descriptors as part of RX NAPI
>
> David Hildenbrand <david@redhat.com>
>     fs/proc/task_mmu: fix pagemap flags with PMD THP entries on 32bit
>
> Baolin Wang <baolin.wang@linux.alibaba.com>
>     mm: shmem: fix incorrect index alignment for within_size policy
>
> Baolin Wang <baolin.wang@linux.alibaba.com>
>     mm: shmem: fix the update of 'shmem_falloc->nr_unswapped'
>
> SeongJae Park <sj@kernel.org>
>     mm/damon/core: fix new damon_target objects leaks on damon_commit_tar=
gets()
>
> SeongJae Park <sj@kernel.org>
>     mm/damon/core: fix ignored quota goals and filters of newly committed=
 schemes
>
> Siddharth Vadapalli <s-vadapalli@ti.com>
>     net: ethernet: ti: am65-cpsw: default to round-robin for host port re=
ceive
>
> Zilin Guan <zilin@seu.edu.cn>
>     fgraph: Add READ_ONCE() when accessing fgraph_array[]
>
> Kees Cook <kees@kernel.org>
>     wifi: iwlwifi: mvm: Fix __counted_by usage in cfg80211_wowlan_nd_*
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     drm: adv7511: Fix use-after-free in adv7533_attach_dsi()
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     dt-bindings: display: adi,adv7533: Drop single lane support
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     drm: adv7511: Drop dsi single lane support
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring/rw: fix downgraded mshot read
>
> Nikolay Kuratov <kniv@yandex-team.ru>
>     net/sctp: Prevent autoclose integer overflow in sctp_association_init=
()
>
> Henry Huang <henry.hj@antgroup.com>
>     sched_ext: initialize kit->cursor.flags
>
> Pascal Hambourg <pascal@plouf.fr.eu.org>
>     sky2: Add device ID 11ab:4373 for Marvell 88E8075
>
> Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
>     workqueue: Do not warn when cancelling WQ_MEM_RECLAIM work from !WQ_M=
EM_RECLAIM worker
>
> Evgenii Shatokhin <e.shatokhin@yadro.com>
>     pinctrl: mcp23s08: Fix sleeping in atomic context due to regmap locki=
ng
>
> Dan Carpenter <dan.carpenter@linaro.org>
>     RDMA/uverbs: Prevent integer overflow issue
>
> Tejun Heo <tj@kernel.org>
>     sched_ext: Fix invalid irq restore in scx_ops_bypass()
>
> Kuan-Wei Chiu <visitorckw@gmail.com>
>     scripts/sorttable: fix orc_sort_cmp() to maintain symmetry and transi=
tivity
>
> Nikolaus Voss <nv@vosn.de>
>     clk: clk-imx8mp-audiomix: fix function signature
>
> Yang Erkun <yangerkun@huawei.com>
>     maple_tree: reload mas before the second call for mas_empty_area
>
> Arnd Bergmann <arnd@arndb.de>
>     kcov: mark in_softirq_really() as __always_inline
>
> Dennis Lam <dennis.lamerice@gmail.com>
>     ocfs2: fix slab-use-after-free due to dangling pointer dqi_priv
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: oss: Fix races at processing SysEx messages
>
> Daniel Schaefer <dhs@frame.work>
>     ALSA hda/realtek: Add quirk for Framework F111:000C
>
> Nirmoy Das <nirmoy.das@intel.com>
>     drm/xe: Wait for migration job before unmapping pages
>
> Nirmoy Das <nirmoy.das@intel.com>
>     drm/xe: Use non-interruptible wait when moving BO to system
>
> Kohei Enju <enjuk@amazon.com>
>     ftrace: Fix function profiler's filtering functionality
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Check UMP support for midi_version change
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/kbuf: use pre-committed buffer address for non-pollable file
>
> Mark Zhang <markzhang@nvidia.com>
>     RDMA/mlx5: Enable multiplane mode only when it is supported
>
> Takashi Iwai <tiwai@suse.de>
>     Revert "ALSA: ump: Don't enumeration invalid groups for legacy rawmid=
i"
>
> Thomas Wei=C3=9Fschuh <linux@weissschuh.net>
>     kbuild: pacman-pkg: provide versioned linux-api-headers package
>
> Masahiro Yamada <masahiroy@kernel.org>
>     modpost: fix the missed iteration for the max bit in do_input()
>
> Mostafa Saleh <smostafa@google.com>
>     scripts/mksysmap: Fix escape chars '$'
>
> Maksim Kiselev <bigunclemax@gmail.com>
>     clk: thead: Fix TH1520 emmc and shdci clock rate
>
> Eduard Zingerman <eddyz87@gmail.com>
>     bpf: consider that tail calls invalidate packet pointers
>
> Eduard Zingerman <eddyz87@gmail.com>
>     bpf: refactor bpf_helper_changes_pkt_data to use helper number
>
> Leon Romanovsky <leon@kernel.org>
>     ARC: build: Try to guess GCC variant of cross compiler
>
> Uros Bizjak <ubizjak@gmail.com>
>     irqchip/gic: Correct declaration of *percpu_base pointer in union gic=
_base
>
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>     Bluetooth: hci_core: Fix sleeping function called from invalid contex=
t
>
> Daniele Palmas <dnlplm@gmail.com>
>     net: usb: qmi_wwan: add Telit FE910C04 compositions
>
> Enzo Matsumiya <ematsumiya@suse.de>
>     smb: client: destroy cfid_put_wq on module exit
>
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: set ATTR_CTIME flags when setting mtime
>
> Hobin Woo <hobin.woo@samsung.com>
>     ksmbd: retry iterate_dir in smb2_query_dir
>
> Anton Protopopov <aspsk@isovalent.com>
>     bpf: fix potential error return
>
> Hardevsinh Palaniya <hardevsinh.palaniya@siliconsignals.io>
>     ARC: bpf: Correct conditional check in 'check_jmp_32'
>
> Paul E. McKenney <paulmck@kernel.org>
>     ARC: build: Use __force to suppress per-CPU cmpxchg warnings
>
> Vineet Gupta <vgupta@kernel.org>
>     ARC: build: disallow invalid PAE40 + 4K page config
>
> Stephen Gordon <gordoste@iinet.net.au>
>     ASoC: audio-graph-card: Call of_node_put() on correct node
>
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>     spi: spi-cadence-qspi: Disable STIG mode for Altera SoCFPGA.
>
> Adrian Ratiu <adrian.ratiu@collabora.com>
>     sound: usb: format: don't warn that raw DSD is unsupported
>
> Adrian Ratiu <adrian.ratiu@collabora.com>
>     sound: usb: enable DSD output for ddHiFi TC44C
>
> Vasiliy Kovalev <kovalev@altlinux.org>
>     ALSA: hda/realtek: Add new alc2xx-fixup-headset-mic model
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/ca0132: Use standard HD-audio quirk matching helpers
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: flush delalloc workers queue before stopping cleaner kthread d=
uring unmount
>
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>     btrfs: handle bio_split() errors
>
> Vasiliy Kovalev <kovalev@altlinux.org>
>     ALSA: hda/realtek - Add support for ASUS Zen AIO 27 Z272SD_A272SD aud=
io
>
> Simon Trimmer <simont@opensource.cirrus.com>
>     ALSA: hda: cs35l56: Remove calls to cs35l56_force_sync_asp1_registers=
_from_cache()
>
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdkfd: Correct the migration DMA map direction
>
> Victor Zhao <Victor.Zhao@amd.com>
>     drm/amdgpu: use sjt mec fw on gfx943 for sriov
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: mac80211: wake the queues in case of failure in resume
>
> Aditya Kumar Singh <quic_adisi@quicinc.com>
>     wifi: cfg80211: clear link ID from bitmap during link delete after cl=
ean up
>
> Issam Hamdi <ih@simonwunderlich.de>
>     wifi: mac80211: fix mbss changed flags corruption on 32 bit systems
>
> Kan Liang <kan.liang@linux.intel.com>
>     perf/x86/intel: Add Arrow Lake U support
>
> Filipe Manana <fdmanana@suse.com>
>     btrfs: allow swap activation to be interruptible
>
> Meghana Malladi <m-malladi@ti.com>
>     net: ti: icssg-prueth: Fix clearing of IEP_CMP_CFG registers during i=
ep_init
>
> MD Danish Anwar <danishanwar@ti.com>
>     net: ti: icssg-prueth: Fix firmware load sequence.
>
> Eric Dumazet <edumazet@google.com>
>     ila: serialize calls to nf_register_net_hooks()
>
> Eric Dumazet <edumazet@google.com>
>     af_packet: fix vlan_get_protocol_dgram() vs MSG_PEEK
>
> Eric Dumazet <edumazet@google.com>
>     af_packet: fix vlan_get_tci() vs MSG_PEEK
>
> Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>     net: wwan: iosm: Properly check for valid exec stage in ipc_mmio_init=
()
>
> Eric Dumazet <edumazet@google.com>
>     net: restrict SO_REUSEPORT to inet sockets
>
> Willem de Bruijn <willemb@google.com>
>     net: reenable NETIF_F_IPV6_CSUM offload for BIG TCP packets
>
> Liang Jie <liangjie@lixiang.com>
>     net: sfc: Correct key_len for efx_tc_ct_zone_ht_params
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring/net: always initialize kmsg->msg.msg_inq upfront
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     RDMA/bnxt_re: Fix error recovery sequence
>
> Li Zhijian <lizhijian@fujitsu.com>
>     RDMA/rtrs: Ensure 'ib_sge list' is accessible
>
> Jinjian Song <jinjian.song@fibocom.com>
>     net: wwan: t7xx: Fix FSM command timeout issue
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     net: mv643xx_eth: fix an OF node reference leak
>
> Vitalii Mordan <mordan@ispras.ru>
>     eth: bcmsysport: fix call balance of priv->clk handling routines
>
> Tanya Agarwal <tanyaagarwal25699@gmail.com>
>     ALSA: usb-audio: US16x08: Initialize array before use
>
> Leo Stone <leocstone@gmail.com>
>     nvmet: Don't overflow subsysnqn
>
> Antonio Pastor <antonio.pastor@gmail.com>
>     net: llc: reset skb->transport_header
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_set_hash: unaligned atomic read on struct nft_set_ext
>
> Su Hui <suhui@nfschina.com>
>     workqueue: add printf attribute to __alloc_workqueue()
>
> Rodrigo Vivi <rodrigo.vivi@intel.com>
>     drm/i915/dg1: Fix power gate sequence.
>
> Suraj Kandpal <suraj.kandpal@intel.com>
>     drm/i915/cx0_phy: Fix C10 pll programming sequence
>
> Zhu Yanjun <yanjun.zhu@linux.dev>
>     RDMA/rxe: Remove the direct link to net_device
>
> Jianbo Liu <jianbol@nvidia.com>
>     net/mlx5e: Keep netdev when leave switchdev for devlink set legacy on=
ly
>
> Jianbo Liu <jianbol@nvidia.com>
>     net/mlx5e: Skip restore TC rules for vport rep without loaded flag
>
> Dragos Tatulea <dtatulea@nvidia.com>
>     net/mlx5e: macsec: Maintain TX SA from encoding_sa
>
> Shahar Shitrit <shshitrit@nvidia.com>
>     net/mlx5: DR, select MSIX vector 0 for completion queue creation
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: pse-pd: tps23881: Fix power on/off issue
>
> Ilya Shchipletsov <rabbelkin@mail.ru>
>     netrom: check buffer length before accessing it
>
> Xiao Liang <shaw.leon@gmail.com>
>     net: Fix netns for ip_tunnel_init_flow()
>
> Wang Liang <wangliang74@huawei.com>
>     net: fix memory leak in tcp_conn_request()
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     net: stmmac: restructure the error path of stmmac_probe_config_dt()
>
> Lucas De Marchi <lucas.demarchi@intel.com>
>     drm/xe: Fix fault on fd close after unbind
>
> Michal Wajdeczko <michal.wajdeczko@intel.com>
>     drm/xe/pf: Use correct function to check LMEM provisioning
>
> John Harrison <John.C.Harrison@Intel.com>
>     drm/xe: Revert some changes that break a mesa debug tool
>
> Chengchang Tang <tangchengchang@huawei.com>
>     RDMA/hns: Fix missing flush CQE for DWQE
>
> Chengchang Tang <tangchengchang@huawei.com>
>     RDMA/hns: Fix warning storm caused by invalid input in IO path
>
> Chengchang Tang <tangchengchang@huawei.com>
>     RDMA/hns: Fix accessing invalid dip_ctx during destroying QP
>
> wenglianfa <wenglianfa@huawei.com>
>     RDMA/hns: Fix mapping error of zero-hop WQE buffer
>
> Jakub Kicinski <kuba@kernel.org>
>     netdev-genl: avoid empty messages in napi get
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     selftests: net: local_termination: require mausezahn
>
> Tristram Ha <tristram.ha@microchip.com>
>     net: dsa: microchip: Fix LAN937X set_ageing_time function
>
> Tristram Ha <tristram.ha@microchip.com>
>     net: dsa: microchip: Fix KSZ9477 set_ageing_time function
>
> Stefan Ekenberg <stefan.ekenberg@axis.com>
>     drm/bridge: adv7511_audio: Update Audio InfoFrame properly
>
> Wei Fang <wei.fang@nxp.com>
>     net: phy: micrel: Dynamically control external clock of KSZ PHY
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Fix the locking while accessing the QP table
>
> Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
>     RDMA/bnxt_re: Fix MSN table size for variable wqe mode
>
> Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
>     RDMA/bnxt_re: Add send queue size check for variable wqe
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     RDMA/bnxt_re: Disable use of reserved wqes
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Fix max_qp_wrs reported
>
> Bernard Metzler <bmt@zurich.ibm.com>
>     RDMA/siw: Remove direct link to net_device
>
> Chiara Meiohas <cmeiohas@nvidia.com>
>     RDMA/nldev: Set error code in rdma_nl_notify_event
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     RDMA/bnxt_re: Fix reporting hw_ver in query_device
>
> Saravanan Vajravel <saravanan.vajravel@broadcom.com>
>     RDMA/bnxt_re: Add check for path mtu in modify_qp
>
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>     RDMA/bnxt_re: Fix the check for 9060 condition
>
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     wifi: iwlwifi: fix CRF name for Bz
>
> Robert Beckett <bob.beckett@collabora.com>
>     nvme-pci: 512 byte aligned dma pool segment quirk
>
> Anumula Murali Mohan Reddy <anumula@chelsio.com>
>     RDMA/core: Fix ENODEV error for iWARP test over vlan
>
> Kashyap Desai <kashyap.desai@broadcom.com>
>     RDMA/bnxt_re: Avoid sending the modify QP workaround for latest adapt=
ers
>
> Selvin Xavier <selvin.xavier@broadcom.com>
>     RDMA/bnxt_re: Avoid initializing the software queue for user queues
>
> Kashyap Desai <kashyap.desai@broadcom.com>
>     RDMA/bnxt_re: Fix max SGEs for the Work Request
>
> Patrisious Haddad <phaddad@nvidia.com>
>     RDMA/mlx5: Enforce same type port association for multiport RoCE
>
> guanjing <guanjing@cmss.chinamobile.com>
>     sched_ext: fix application of sizeof to pointer
>
> Leon Romanovsky <leon@kernel.org>
>     RDMA/bnxt_re: Remove always true dattr validity check
>
> Christoph Hellwig <hch@lst.de>
>     btrfs: use bio_is_zone_append() in the completion handler
>
> Christoph Hellwig <hch@lst.de>
>     block: lift bio_is_zone_append to bio.h
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Have process_string() also allow arrays
>
> Lucas Stach <l.stach@pengutronix.de>
>     pmdomain: core: add dummy release function to genpd device
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     pmdomain: imx: gpcv2: fix an OF node reference leak in imx_gpcv2_prob=
e()
>
> Eric Biggers <ebiggers@google.com>
>     mmc: sdhci-msm: fix crypto key eviction
>
> Thi=C3=A9baud Weksteen <tweek@google.com>
>     selinux: ignore unknown extended permissions
>
> Mingcong Bai <jeffbai@aosc.io>
>     platform/x86: hp-wmi: mark 8A15 board for timed OMEN thermal profile
>
> Vishnu Sankar <vishnuocv@gmail.com>
>     platform/x86: thinkpad-acpi: Add support for hotkey 0x1401
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu: fix backport of commit 73dae652dcac
>
> Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
>     platform/x86: mlx-platform: call pci_dev_put() to balance the refcoun=
t
>
>
> -------------
>
> Diffstat:
>
>  .../admin-guide/laptops/thinkpad-acpi.rst          |  10 +-
>  .../bindings/display/bridge/adi,adv7533.yaml       |   2 +-
>  Makefile                                           |   4 +-
>  arch/arc/Kconfig                                   |   4 +-
>  arch/arc/Makefile                                  |   2 +-
>  arch/arc/include/asm/cmpxchg.h                     |   2 +-
>  arch/arc/net/bpf_jit_arcv2.c                       |   2 +-
>  arch/x86/events/intel/core.c                       |   1 +
>  block/blk.h                                        |   9 -
>  drivers/clk/imx/clk-imx8mp-audiomix.c              |   3 +-
>  drivers/clk/thead/clk-th1520-ap.c                  |  13 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   6 +-
>  drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c            |  10 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |   4 +-
>  drivers/gpu/drm/bridge/adv7511/adv7511_audio.c     |  14 +-
>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |  10 +-
>  drivers/gpu/drm/bridge/adv7511/adv7533.c           |   4 +-
>  drivers/gpu/drm/i915/display/intel_cx0_phy.c       |  12 +-
>  drivers/gpu/drm/i915/gt/intel_rc6.c                |   2 +-
>  drivers/gpu/drm/xe/xe_bo.c                         |  12 +-
>  drivers/gpu/drm/xe/xe_devcoredump.c                |  15 +-
>  drivers/gpu/drm/xe/xe_exec_queue.c                 |   9 +
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c         |   2 +-
>  drivers/infiniband/core/cma.c                      |  16 ++
>  drivers/infiniband/core/nldev.c                    |   2 +-
>  drivers/infiniband/core/uverbs_cmd.c               |  16 +-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c           |  34 +--
>  drivers/infiniband/hw/bnxt_re/main.c               |   8 +-
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  65 +++--
>  drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   3 +-
>  drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   5 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c           |  18 +-
>  drivers/infiniband/hw/hns/hns_roce_hem.c           |  43 +++-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  11 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c            |   5 -
>  drivers/infiniband/hw/mlx5/main.c                  |   8 +-
>  drivers/infiniband/sw/rxe/rxe.c                    |  23 +-
>  drivers/infiniband/sw/rxe/rxe.h                    |   3 +-
>  drivers/infiniband/sw/rxe/rxe_mcast.c              |  22 +-
>  drivers/infiniband/sw/rxe/rxe_net.c                |  24 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.c              |  26 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.h              |  11 +-
>  drivers/infiniband/sw/siw/siw.h                    |   7 +-
>  drivers/infiniband/sw/siw/siw_cm.c                 |  27 +-
>  drivers/infiniband/sw/siw/siw_main.c               |  15 +-
>  drivers/infiniband/sw/siw/siw_verbs.c              |  35 ++-
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c             |   2 +-
>  drivers/irqchip/irq-gic.c                          |   2 +-
>  drivers/mmc/host/sdhci-msm.c                       |  16 +-
>  drivers/net/dsa/microchip/ksz9477.c                |  47 +++-
>  drivers/net/dsa/microchip/ksz9477_reg.h            |   4 +-
>  drivers/net/dsa/microchip/lan937x_main.c           |  62 ++++-
>  drivers/net/dsa/microchip/lan937x_reg.h            |   9 +-
>  drivers/net/ethernet/broadcom/bcmsysport.c         |  21 +-
>  drivers/net/ethernet/google/gve/gve.h              |   1 +
>  drivers/net/ethernet/google/gve/gve_main.c         |  63 +++--
>  drivers/net/ethernet/google/gve/gve_tx.c           |  46 ++--
>  drivers/net/ethernet/marvell/mv643xx_eth.c         |  14 +-
>  drivers/net/ethernet/marvell/sky2.c                |   1 +
>  .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   4 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  15 ++
>  .../net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c |   6 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +
>  .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   5 +-
>  .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   4 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   3 +-
>  drivers/net/ethernet/sfc/tc_conntrack.c            |   2 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  43 ++--
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   2 +-
>  drivers/net/ethernet/ti/icssg/icss_iep.c           |   8 +
>  drivers/net/ethernet/ti/icssg/icssg_common.c       |  25 --
>  drivers/net/ethernet/ti/icssg/icssg_config.c       |  41 ++-
>  drivers/net/ethernet/ti/icssg/icssg_config.h       |   1 +
>  drivers/net/ethernet/ti/icssg/icssg_prueth.c       | 281 ++++++++++++++-=
------
>  drivers/net/ethernet/ti/icssg/icssg_prueth.h       |   5 +-
>  drivers/net/ethernet/ti/icssg/icssg_prueth_sr1.c   |  24 +-
>  drivers/net/phy/micrel.c                           | 114 ++++++++-
>  drivers/net/pse-pd/tps23881.c                      |  16 +-
>  drivers/net/usb/qmi_wwan.c                         |   3 +
>  drivers/net/wireless/intel/iwlwifi/cfg/bz.c        |   1 +
>  drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   1 +
>  drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  14 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  41 ++-
>  drivers/net/wwan/iosm/iosm_ipc_mmio.c              |   2 +-
>  drivers/net/wwan/t7xx/t7xx_state_monitor.c         |  26 +-
>  drivers/net/wwan/t7xx/t7xx_state_monitor.h         |   5 +-
>  drivers/nvme/host/nvme.h                           |   5 +
>  drivers/nvme/host/pci.c                            |   9 +-
>  drivers/nvme/target/configfs.c                     |  11 +-
>  drivers/pinctrl/pinctrl-mcp23s08.c                 |   6 +
>  drivers/platform/x86/hp/hp-wmi.c                   |   4 +-
>  drivers/platform/x86/mlx-platform.c                |   2 +
>  drivers/platform/x86/thinkpad_acpi.c               |   4 +-
>  drivers/pmdomain/core.c                            |   6 +
>  drivers/pmdomain/imx/gpcv2.c                       |   4 +-
>  drivers/spi/spi-cadence-quadspi.c                  |  10 +-
>  fs/btrfs/bio.c                                     |  23 +-
>  fs/btrfs/disk-io.c                                 |   9 +
>  fs/btrfs/inode.c                                   |   5 +
>  fs/ocfs2/quota_global.c                            |   2 +-
>  fs/ocfs2/quota_local.c                             |   1 +
>  fs/proc/task_mmu.c                                 |   2 +-
>  fs/smb/client/cifsfs.c                             |   1 +
>  fs/smb/server/smb2pdu.c                            |  22 +-
>  fs/smb/server/vfs.h                                |   1 +
>  include/linux/bio.h                                |  17 ++
>  include/linux/filter.h                             |   2 +-
>  include/linux/if_vlan.h                            |  16 +-
>  include/linux/memfd.h                              |  14 +
>  include/linux/mlx5/driver.h                        |   7 +
>  include/linux/mlx5/mlx5_ifc.h                      |   4 +-
>  include/linux/mm.h                                 |  57 +++--
>  include/linux/mm_types.h                           |  30 +++
>  include/net/bluetooth/hci_core.h                   | 108 +++++---
>  include/net/netfilter/nf_tables.h                  |   7 +-
>  include/sound/cs35l56.h                            |   6 -
>  io_uring/kbuf.c                                    |   4 +-
>  io_uring/net.c                                     |   1 +
>  io_uring/rw.c                                      |   2 +
>  kernel/bpf/core.c                                  |   8 +-
>  kernel/bpf/verifier.c                              |   2 +-
>  kernel/kcov.c                                      |   2 +-
>  kernel/sched/ext.c                                 |   4 +-
>  kernel/trace/fgraph.c                              |   2 +-
>  kernel/trace/ftrace.c                              |   8 +-
>  kernel/trace/trace_events.c                        |  12 +
>  kernel/workqueue.c                                 |  23 +-
>  lib/maple_tree.c                                   |   1 +
>  mm/damon/core.c                                    |  10 +-
>  mm/hugetlb.c                                       |  16 +-
>  mm/kmemleak.c                                      |   2 +-
>  mm/memfd.c                                         |   2 +-
>  mm/mmap.c                                          |   4 +
>  mm/readahead.c                                     |   6 +-
>  mm/shmem.c                                         |   7 +-
>  mm/vmscan.c                                        |   9 +-
>  net/bluetooth/hci_core.c                           |  10 +-
>  net/bluetooth/iso.c                                |   6 +
>  net/bluetooth/l2cap_core.c                         |  12 +-
>  net/bluetooth/rfcomm/core.c                        |   6 +
>  net/bluetooth/sco.c                                |  12 +-
>  net/core/dev.c                                     |   4 +-
>  net/core/filter.c                                  |  63 +++--
>  net/core/netdev-genl.c                             |   6 +-
>  net/core/sock.c                                    |   5 +-
>  net/ipv4/ip_tunnel.c                               |   6 +-
>  net/ipv4/tcp_input.c                               |   1 +
>  net/ipv6/ila/ila_xlat.c                            |  16 +-
>  net/llc/llc_input.c                                |   2 +-
>  net/mac80211/cfg.c                                 |   8 +-
>  net/mac80211/mesh.c                                |   6 +-
>  net/mac80211/util.c                                |   3 +
>  net/mptcp/options.c                                |   7 +
>  net/mptcp/protocol.c                               |  22 +-
>  net/netrom/nr_route.c                              |   6 +
>  net/packet/af_packet.c                             |  28 +-
>  net/sctp/associola.c                               |   3 +-
>  net/wireless/util.c                                |   3 +-
>  scripts/mksysmap                                   |   4 +-
>  scripts/mod/file2alias.c                           |   2 +-
>  scripts/package/PKGBUILD                           |   2 +-
>  scripts/sorttable.h                                |   5 +-
>  security/selinux/ss/services.c                     |   8 +-
>  sound/core/seq/oss/seq_oss_synth.c                 |   2 +
>  sound/core/seq/seq_clientmgr.c                     |  14 +-
>  sound/core/ump.c                                   |   2 +-
>  sound/pci/hda/cs35l56_hda.c                        |   8 -
>  sound/pci/hda/patch_ca0132.c                       |  37 +--
>  sound/pci/hda/patch_realtek.c                      |  24 ++
>  sound/soc/generic/audio-graph-card2.c              |   2 +-
>  sound/usb/format.c                                 |   7 +-
>  sound/usb/mixer_us16x08.c                          |   2 +-
>  sound/usb/quirks.c                                 |   2 +
>  tools/sched_ext/scx_central.c                      |   2 +-
>  tools/testing/selftests/bpf/progs/tc_bpf2bpf.c     |   2 +
>  .../selftests/net/forwarding/local_termination.sh  |   1 -
>  177 files changed, 1698 insertions(+), 764 deletions(-)
>
>
>
