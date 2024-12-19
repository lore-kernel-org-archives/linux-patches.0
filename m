Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466C11B982E
	for <patches@lists.linux.dev>; Thu, 19 Dec 2024 20:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734638612; cv=none; b=lkX26/WaeCHDftRthNvVSUpqEl66fHV1hM9Hk15DMf+goDtcv5epxVdqhYMX620rg6e9wy1Wb3wIRVqfjfgQv1YpyQSBiQNijIKNl7XSRdSm09fycbsZPkFZrMSwQ75KwZOCYDKWVagriezBzOCHSxzBl121ITmP9crhU7fZXQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734638612; c=relaxed/simple;
	bh=es4mzfXu48duN6gKvyUVJk9jgPKBnBNxAn/vb+ir6qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hrI6PXFmlCVrnUrt5Hg4IItd7AYvXCkBCC2m/LON1Jy1eM7PfUwWWgzO+OGP0vCPtazVjElCIPQY5HmQfOPVfaZpqassTtK/HX90FTBPUwSqTiCG0bCnbe62Uj0zcH2XNMho3/baClCkhEVDx2xK54jLI62o2KkIO2FiuHN/Vlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CBDhk8dg; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBDhk8dg"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa69077b93fso166662566b.0
        for <patches@lists.linux.dev>; Thu, 19 Dec 2024 12:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734638604; x=1735243404; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W5iX/uZdz96ABHJxGPNSVQGCiXjChGz8kEeYDcJuNbo=;
        b=CBDhk8dgNgPMyFbGxRCxZYK28pVFTDxuvddq3UWAsWWNPe2Ec4tyDvTDp+Wd7JRZve
         GHbRJ+p3NsVnxL9GbUu36xIEICeZDbsy26tKGVPEa2/dpDCEYCiES2JZvxo6SGBfaPvU
         YAcXK+z3qtwWOEVzTbc5P2Oaj/fiulB+BVzeAKb+VphMM6cveD/x98mnc58MTLckL7vt
         iaDnvhn5485MN73kx9TnFijxfghYfX0HTHVy37VEQeBskCGXukVjINaiEkRZP0go8Caw
         90cjwZ0oSnkGJNL+x4NyvABSJ27pdthIpcAXtuS7WAN5W7YPxh0xb8gw92bR+D/dFAOk
         URTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734638604; x=1735243404;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5iX/uZdz96ABHJxGPNSVQGCiXjChGz8kEeYDcJuNbo=;
        b=wW+QNxxRgrkK9bdYg4Jp89fg8DYMbKA1NAM+XAQO7LaXymfQtEEl/SYZzPZ5Tc8sii
         NmJXh4Zpwbpc+iAmqoibTA+py1dfO+wg+rueBfES1bArO3hoCLCKLhGkbBiBpE13D3YI
         daFKNiT11fRl83fKkrUTNxtFjJvKubdiokv6C08iAM75y4XYAlci7+bMCPC1wSHRuVLg
         UD+2AEbXnTj4azlDtbKw/+in2h54q0+OnjWBUvtgpE6fSMShjJyQr5cFi1I8IwE10PDV
         fB8XoxVIOdW9ht053Do+xwbzXATIZ8IDzaP7/lzPWSw1qgqhrq9HxiL00P6zP+3/FI7G
         SvFQ==
X-Gm-Message-State: AOJu0YwBBc97jc1bwLr/A2SjyPH8NT+YWtYSpwMtw40JU9Ezu/Q4Dq4S
	qeWSWV5BhFiUnGLj+7LpFm7ebETIAYLibRQei6ft004e5g0o+rNX
X-Gm-Gg: ASbGncv9FS2zaBXswKXqpoJPvyQm0NsZ5eNdLXjDFdlQ7DEzeRqf9Feeivj36bQv6zY
	BZRju7ua5ytTQAPwW7otU36Gtgh+dmGqvtjcFKQjXKa7bLLEANvBoKD1rZ+Qs85zMThiOOckzL5
	+o/gby0W67yH+cN3glZULVgYc5mNv3PONS9PDiI1KjZuE5/Vc11q/67pwCs1vcWGHU5xyGBanlg
	MEFeLf+FXZqw3YtG5LkYYavFOYTZNML0Hq1XtudisWZ850CQG3WHopoSJzTZ70Xwc33h9hkhgTV
	OkSWKCytyafBHl/jSeBXB42GY7pBb15oma3Fbi9i
X-Google-Smtp-Source: AGHT+IHOu73Uuj65e+ik3m7anCAaoRGfTFjH8e3uFQdLF1KC3VnELB5mMRbUuDvFscwaL3WDJDrtRQ==
X-Received: by 2002:a17:907:1c07:b0:aa6:81dc:6635 with SMTP id a640c23a62f3a-aac3342c511mr7356666b.18.1734638603377;
        Thu, 19 Dec 2024 12:03:23 -0800 (PST)
Received: from [192.168.50.7] (host-87-18-133-168.retail.telecomitalia.it. [87.18.133.168])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f073333sm95993166b.203.2024.12.19.12.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 12:03:21 -0800 (PST)
Message-ID: <931a928a-3d65-493c-85d5-b5aa0130b6cb@gmail.com>
Date: Thu, 19 Dec 2024 21:03:18 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241107063342.964868073@linuxfoundation.org>
Content-Language: en-US
From: Luca Stefani <luca.stefani.ge1@gmail.com>
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 07/11/24 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
>      Linux 4.19.323-rc2
> 
> Jeongjun Park <aha310510@gmail.com>
>      vt: prevent kernel-infoleak in con_font_get()
> 
> Jeongjun Park <aha310510@gmail.com>
>      mm: shmem: fix data-race in shmem_getattr()
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: fix kernel bug due to missing clearing of checked flag
> 
> Edward Adam Davis <eadavis@qq.com>
>      ocfs2: pass u64 to ocfs2_truncate_inline maybe overflow
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: fix potential deadlock with newly created symlinks
> 
> Ville Syrjälä <ville.syrjala@linux.intel.com>
>      wifi: iwlegacy: Clear stale interrupts before resuming device
> 
> Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
>      wifi: ath10k: Fix memory leak in management tx
> 
> Felix Fietkau <nbd@nbd.name>
>      wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Revert "driver core: Fix uevent_show() vs driver detach race"
> 
> Faisal Hassan <quic_faisalh@quicinc.com>
>      xhci: Fix Link TRB DMA in command ring stopped completion event
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      usb: phy: Fix API devm_usb_put_phy() can not release the phy
> 
> Zongmin Zhou <zhouzongmin@kylinos.cn>
>      usbip: tools: Fix detach_port() invalid port error path
> 
> Dimitri Sivanich <sivanich@hpe.com>
>      misc: sgi-gru: Don't disable preemption in GRU driver
> 
> Daniel Palmer <daniel@0x0f.com>
>      net: amd: mvme147: Fix probe banner message
> 
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>      firmware: arm_sdei: Fix the input parameter of cpuhp_remove_state()
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>      netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
> 
> Benoît Monin <benoit.monin@gmx.fr>
>      net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension
> 
> Xin Long <lucien.xin@gmail.com>
>      net: support ip generic csum processing in skb_csum_hwoffload_help
> 
> Byeonguk Jeong <jungbu2855@gmail.com>
>      bpf: Fix out-of-bounds write in trie_get_next_key()
> 
> Pedro Tammela <pctammela@mojatatu.com>
>      net/sched: stop qdisc_tree_reduce_backlog on TC_H_ROOT
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>      gtp: allow -1 to be specified as file description from userspace
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      gtp: simplify error handling code in 'gtp_encap_enable()'
> 
> Wander Lairson Costa <wander@redhat.com>
>      igb: Disable threaded IRQ for igb_msix_other
> 
> Felix Fietkau <nbd@nbd.name>
>      wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys
> 
> Xiu Jianfeng <xiujianfeng@huawei.com>
>      cgroup: Fix potential overflow issue when checking max_depth
> 
> Selvarasu Ganesan <selvarasu.g@samsung.com>
>      usb: dwc3: core: Stop processing of pending events if controller is halted
> 
> Yu Chen <chenyu56@huawei.com>
>      usb: dwc3: Add splitdisable quirk for Hisilicon Kirin Soc
> 
> Marek Szyprowski <m.szyprowski@samsung.com>
>      usb: dwc3: remove generic PHY calibrate() calls
> 
> Sabrina Dubroca <sd@queasysnail.net>
>      xfrm: validate new SA's prefixlen using SA family when sel.family is unset
> 
> junhua huang <huang.junhua@zte.com.cn>
>      arm64/uprobes: change the uprobe_opcode_t typedef to fix the sparse warning
> 
> Paul Moore <paul@paul-moore.com>
>      selinux: improve error checking in sel_write_load()
> 
> Haiyang Zhang <haiyangz@microsoft.com>
>      hv_netvsc: Fix VF namespace also in synthetic NIC NETDEV_REGISTER event
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: fix kernel bug due to missing clearing of buffer delay flag
> 
> Shubham Panwar <shubiisp8@gmail.com>
>      ACPI: button: Add DMI quirk for Samsung Galaxy Book2 to fix initial lid detection issue
> 
> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Guard against bad data for ATIF ACPI method
> 
> Kailang Yang <kailang@realtek.com>
>      ALSA: hda/realtek: Update default depop procedure
> 
> Jinjie Ruan <ruanjinjie@huawei.com>
>      posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()
> 
> Oliver Neukum <oneukum@suse.com>
>      net: usb: usbnet: fix name regression
> 
> Biju Das <biju.das@bp.renesas.com>
>      dt-bindings: power: Add r8a774b1 SYSC power domain definitions
> 
> Wang Hai <wanghai38@huawei.com>
>      be2net: fix potential memory leak in be_xmit()
> 
> Wang Hai <wanghai38@huawei.com>
>      net/sun3_82586: fix potential memory leak in sun3_82586_send_packet()
> 
> Dave Kleikamp <dave.kleikamp@oracle.com>
>      jfs: Fix sanity check in dbMount
> 
> Gianfranco Trad <gianf.trad@gmail.com>
>      udf: fix uninit-value use in udf_get_fileshortad
> 
> Nico Boehr <nrb@linux.ibm.com>
>      KVM: s390: gaccess: Check if guest address is in memslot
> 
> Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      KVM: s390: gaccess: Cleanup access to guest pages
> 
> Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      KVM: s390: gaccess: Refactor access address range check
> 
> Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>      KVM: s390: gaccess: Refactor gpa and length calculation
> 
> Mark Rutland <mark.rutland@arm.com>
>      arm64: probes: Fix uprobes for big-endian kernels
> 
> junhua huang <huang.junhua@zte.com.cn>
>      arm64:uprobe fix the uprobe SWBP_INSN in big-endian
> 
> Ye Bin <yebin10@huawei.com>
>      Bluetooth: bnep: fix wild-memory-access in proto_unregister
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      usb: typec: altmode should keep reference to parent
> 
> Wang Hai <wanghai38@huawei.com>
>      net: systemport: fix potential memory leak in bcm_sysport_xmit()
> 
> Wang Hai <wanghai38@huawei.com>
>      net: ethernet: aeroflex: fix potential memory leak in greth_start_xmit_gbit()
> 
> Sabrina Dubroca <sd@queasysnail.net>
>      macsec: don't increment counters for an unrelated SA
> 
> Jonathan Marek <jonathan@marek.ca>
>      drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
> 
> Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>      RDMA/bnxt_re: Return more meaningful error
> 
> Anumula Murali Mohan Reddy <anumula@chelsio.com>
>      RDMA/cxgb4: Fix RDMA_CM_EVENT_UNREACHABLE error for iWARP
> 
> Saravanan Vajravel <saravanan.vajravel@broadcom.com>
>      RDMA/bnxt_re: Fix incorrect AVID type in WQE structure
> 
> Andrey Skvortsov <andrej.skvortzov@gmail.com>
>      clk: Fix slab-out-of-bounds error in devm_clk_release()
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      clk: Fix pointer casting to prevent oops in devm_clk_release()
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: propagate directory read errors from nilfs_find_entry()
> 
> Zhang Rui <rui.zhang@intel.com>
>      x86/apic: Always explicitly disarm TSC-deadline timer
> 
> Takashi Iwai <tiwai@suse.de>
>      parport: Proper fix for array out-of-bounds access
> 
> Daniele Palmas <dnlplm@gmail.com>
>      USB: serial: option: add Telit FN920C04 MBIM compositions
> 
> Benjamin B. Frost <benjamin@geanix.com>
>      USB: serial: option: add support for Quectel EG916Q-GL
> 
> Mathias Nyman <mathias.nyman@linux.intel.com>
>      xhci: Fix incorrect stream context type macro
> 
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>      Bluetooth: btusb: Fix regression with fake CSR controllers 0a12:0001
> 
> Aaron Thompson <dev@aaront.org>
>      Bluetooth: Remove debugfs directory on module init failure
> 
> Emil Gedenryd <emil.gedenryd@axis.com>
>      iio: light: opt3001: add missing full-scale range value
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      iio: hid-sensors: Fix an error handling path in _hid_sensor_set_report_latency()
> 
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>      iio: adc: ti-ads8688: add missing select IIO_(TRIGGERED_)BUFFER in Kconfig
> 
> Javier Carrasco <javier.carrasco.cruz@gmail.com>
>      iio: dac: stm32-dac-core: add missing select REGMAP_MMIO in Kconfig
> 
> Nikolay Kuratov <kniv@yandex-team.ru>
>      drm/vmwgfx: Handle surface check failure correctly
> 
> Jim Mattson <jmattson@google.com>
>      x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
> 
> Michael Mueller <mimu@linux.ibm.com>
>      KVM: s390: Change virtual to physical address access in diag 0x258 handler
> 
> Thomas Weißschuh <thomas.weissschuh@linutronix.de>
>      s390/sclp_vt220: Convert newlines to CRLF instead of LFCR
> 
> Joseph Huang <Joseph.Huang@garmin.com>
>      net: dsa: mv88e6xxx: Fix out-of-bound access
> 
> Breno Leitao <leitao@debian.org>
>      KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
> 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>      fat: fix uninitialized variable
> 
> WangYuli <wangyuli@uniontech.com>
>      PCI: Add function 0 DMA alias quirk for Glenfly Arise chip
> 
> Mark Rutland <mark.rutland@arm.com>
>      arm64: probes: Fix simulate_ldr*_literal()
> 
> Mark Rutland <mark.rutland@arm.com>
>      arm64: probes: Remove broken LDR (literal) uprobe support
> 
> Jinjie Ruan <ruanjinjie@huawei.com>
>      posix-clock: Fix missing timespec64 check in pc_clock_settime()
> 
> Anastasia Kovaleva <a.kovaleva@yadro.com>
>      net: Fix an unsafe loop on the list
> 
> Icenowy Zheng <uwu@icenowy.me>
>      usb: storage: ignore bogus device raised by JieLi BR21 USB sound chip
> 
> Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
>      usb: xhci: Fix problem with xhci resume from suspend
> 
> Oliver Neukum <oneukum@suse.com>
>      Revert "usb: yurex: Replace snprintf() with the safer scnprintf() variant"
> 
> Wade Wang <wade.wang@hp.com>
>      HID: plantronics: Workaround for an unexcepted opposite volume key
> 
> Oliver Neukum <oneukum@suse.com>
>      CDC-NCM: avoid overflow in sanity checking
> 
> j.nixdorf@avm.de <j.nixdorf@avm.de>
>      net: ipv6: ensure we call ipv6_mc_down() at most once
> 
> Eric Dumazet <edumazet@google.com>
>      ppp: fix ppp_async_encode() illegal access
> 
> Rosen Penev <rosenp@gmail.com>
>      net: ibm: emac: mal: fix wrong goto
> 
> Mohamed Khalfella <mkhalfella@purestorage.com>
>      igb: Do not bring the device up after non-fatal error
> 
> Billy Tsai <billy_tsai@aspeedtech.com>
>      gpio: aspeed: Use devm_clk api to manage clock source
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      clk: Provide new devm_clk helpers for prepared and enabled clocks
> 
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      clk: generalize devm_clk_get() a bit
> 
> Phil Edworthy <phil.edworthy@renesas.com>
>      clk: Add (devm_)clk_get_optional() functions
> 
> Billy Tsai <billy_tsai@aspeedtech.com>
>      gpio: aspeed: Add the flush write to ensure the write complete.
> 
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>      Bluetooth: RFCOMM: FIX possible deadlock in rfcomm_sk_state_change
> 
> Andy Roulin <aroulin@nvidia.com>
>      netfilter: br_netfilter: fix panic with metadata_dst skb
> 
> Neal Cardwell <ncardwell@google.com>
>      tcp: fix tcp_enter_recovery() to zero retrans_stamp when it's safe
> 
> Dan Carpenter <dan.carpenter@linaro.org>
>      SUNRPC: Fix integer overflow in decode_rc_list()
> 
> Chuck Lever <chuck.lever@oracle.com>
>      NFS: Remove print_overflow_msg()
> 
> Andrey Shumilin <shum.sdl@nppct.ru>
>      fbdev: sisfb: Fix strbuf array overflow
> 
> Zijun Hu <quic_zijuhu@quicinc.com>
>      driver core: bus: Return -EIO instead of 0 when show/store invalid bus attribute
> 
> Zhu Jun <zhujun2@cmss.chinamobile.com>
>      tools/iio: Add memory allocation failure check for trigger_name
> 
> Xu Yang <xu.yang_2@nxp.com>
>      usb: chipidea: udc: enable suspend interrupt after usb reset
> 
> Yunke Cao <yunkec@chromium.org>
>      media: videobuf2-core: clear memory related fields in __vb2_plane_dmabuf_put()
> 
> Alex Williamson <alex.williamson@redhat.com>
>      PCI: Mark Creative Labs EMU20k2 INTx masking as broken
> 
> Hans de Goede <hdegoede@redhat.com>
>      i2c: i801: Use a different adapter-name for IDF adapters
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      clk: bcm: bcm53573: fix OF node leak in init
> 
> Daniel Jordan <daniel.m.jordan@oracle.com>
>      ktest.pl: Avoid false positives with grub2 skip regex
> 
> Thomas Richter <tmricht@linux.ibm.com>
>      s390/cpum_sf: Remove WARN_ON_ONCE statements
> 
> Wojciech Gładysz <wojciech.gladysz@infogain.com>
>      ext4: nested locking for xattr inode
> 
> Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>      s390/mm: Add cond_resched() to cmm_alloc/free_pages()
> 
> Heiko Carstens <hca@linux.ibm.com>
>      s390/facility: Disable compile time optimization for decompressor code
> 
> Tao Chen <chen.dylane@gmail.com>
>      bpf: Check percpu map value size first
> 
> Mathias Krause <minipli@grsecurity.net>
>      Input: synaptics-rmi4 - fix UAF of IRQ domain on driver removal
> 
> Michael S. Tsirkin <mst@redhat.com>
>      virtio_console: fix misc probe bugs
> 
> Rob Clark <robdclark@chromium.org>
>      drm/crtc: fix uninitialized variable use even harder
> 
> Sean Paul <seanpaul@chromium.org>
>      drm: Move drm_mode_setcrtc() local re-init to failure path
> 
> Steven Rostedt (Google) <rostedt@goodmis.org>
>      tracing: Remove precision vsnprintf() check from print event
> 
> Linus Walleij <linus.walleij@linaro.org>
>      net: ethernet: cortina: Drop TSO support
> 
> zhanchengbin <zhanchengbin1@huawei.com>
>      ext4: fix inode tree inconsistency caused by ENOMEM
> 
> Armin Wolf <W_Armin@gmx.de>
>      ACPI: battery: Fix possible crash when unregistering a battery hook
> 
> Armin Wolf <W_Armin@gmx.de>
>      ACPI: battery: Simplify battery hook locking
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      rtc: at91sam9: fix OF node leak in probe() error path
> 
> Alexandre Belloni <alexandre.belloni@bootlin.com>
>      rtc: at91sam9: drop platform_data support
> 
> NeilBrown <neilb@suse.de>
>      nfsd: fix delegation_blocked() to block correctly for at least 30 seconds
> 
> Arnd Bergmann <arnd@arndb.de>
>      nfsd: use ktime_get_seconds() for timestamps
> 
> Oleg Nesterov <oleg@redhat.com>
>      uprobes: fix kernel info leak via "[uprobes]" vma
> 
> Mark Rutland <mark.rutland@arm.com>
>      arm64: errata: Expand speculative SSBS workaround once more
> 
> Mark Rutland <mark.rutland@arm.com>
>      arm64: cputype: Add Neoverse-N3 definitions
> 
> Anshuman Khandual <anshuman.khandual@arm.com>
>      arm64: Add Cortex-715 CPU part definition
> 
> Baokun Li <libaokun1@huawei.com>
>      ext4: update orig_path in ext4_find_extent()
> 
> Baokun Li <libaokun1@huawei.com>
>      ext4: fix slab-use-after-free in ext4_split_extent_at()
> 
> Theodore Ts'o <tytso@mit.edu>
>      ext4: avoid ext4_error()'s caused by ENOMEM in the truncate path
> 
> Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
>      gpio: davinci: fix lazy disable
> 
> Filipe Manana <fdmanana@suse.com>
>      btrfs: wait for fixup workers before stopping cleaner kthread during umount
> 
> Nuno Sa <nuno.sa@analog.com>
>      Input: adp5589-keys - fix adp5589_gpio_get_value()
> 
> Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>      tomoyo: fallback to realpath if symlink's pathname does not exist
> 
> Barnabás Czémán <barnabas.czeman@mainlining.org>
>      iio: magnetometer: ak8975: Fix reading for ak099xx sensors
> 
> Zheng Wang <zyytlz.wz@163.com>
>      media: venus: fix use after free bug in venus_remove due to race condition
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>      media: uapi/linux/cec.h: cec_msg_set_reply_to: zero flags
> 
> Sebastian Reichel <sebastian.reichel@collabora.com>
>      clk: rockchip: fix error for unknown clocks
> 
> Chun-Yi Lee <joeyli.kernel@gmail.com>
>      aoe: fix the potential use-after-free problem in more places
> 
> Jisheng Zhang <jszhang@kernel.org>
>      riscv: define ILLEGAL_POINTER_VALUE for 64bit
> 
> Lizhi Xu <lizhi.xu@windriver.com>
>      ocfs2: fix possible null-ptr-deref in ocfs2_set_buffer_uptodate
> 
> Julian Sun <sunjunchao2870@gmail.com>
>      ocfs2: fix null-ptr-deref when journal load failed.
> 
> Lizhi Xu <lizhi.xu@windriver.com>
>      ocfs2: remove unreasonable unlock in ocfs2_read_blocks
> 
> Joseph Qi <joseph.qi@linux.alibaba.com>
>      ocfs2: cancel dqi_sync_work before freeing oinfo
> 
> Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
>      ocfs2: reserve space for inline xattr before attaching reflink tree
> 
> Joseph Qi <joseph.qi@linux.alibaba.com>
>      ocfs2: fix uninit-value in ocfs2_get_block()
> 
> Heming Zhao <heming.zhao@suse.com>
>      ocfs2: fix the la space leak when unmounting an ocfs2 volume
> 
> Baokun Li <libaokun1@huawei.com>
>      jbd2: stop waiting for space when jbd2_cleanup_journal_tail() returns error
> 
> Andrew Jones <ajones@ventanamicro.com>
>      of/irq: Support #msi-cells=<0> in of_msi_get_domain
> 
No idea why this change got picked for stable but it's breaking 
downstream (QCOM) kernels, the requirement of this commit mentioned in 
the commit msg is missing in linux 4.19.y as a whole.

Needed changes:
e42ee61017f58 of: Let of_for_each_phandle fallback to non-negative 
cell_count
59e9fcf8772bd of: restore old handling of cells_name=NULL in 
of_*_phandle_with_args()

Picking these 2 changes fixes it and brings back the old expected behavior.

Luca.

> Helge Deller <deller@kernel.org>
>      parisc: Fix 64-bit userspace syscall path
> 
> Luis Henriques (SUSE) <luis.henriques@linux.dev>
>      ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
> 
> Baokun Li <libaokun1@huawei.com>
>      ext4: fix double brelse() the buffer of the extents path
> 
> Baokun Li <libaokun1@huawei.com>
>      ext4: aovid use-after-free in ext4_ext_insert_extent()
> 
> Luis Henriques (SUSE) <luis.henriques@linux.dev>
>      ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()
> 
> Baokun Li <libaokun1@huawei.com>
>      ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
> 
> Edward Adam Davis <eadavis@qq.com>
>      ext4: no need to continue when the number of entries is 1
> 
> Jaroslav Kysela <perex@perex.cz>
>      ALSA: core: add isascii() check to card ID generator
> 
> Helge Deller <deller@gmx.de>
>      parisc: Fix itlb miss handler for 64-bit programs
> 
> Luo Gengkun <luogengkun@huaweicloud.com>
>      perf/core: Fix small negative period being ignored
> 
> Jinjie Ruan <ruanjinjie@huawei.com>
>      spi: bcm63xx: Fix module autoloading
> 
> Robert Hancock <robert.hancock@calian.com>
>      i2c: xiic: Wait for TX empty to avoid missed TX NAKs
> 
> Christophe Leroy <christophe.leroy@csgroup.eu>
>      selftests: vDSO: fix vDSO symbols lookup for powerpc64
> 
> Yifei Liu <yifei.l.liu@oracle.com>
>      selftests: breakpoints: use remaining time to check if suspend succeed
> 
> Ben Dooks <ben.dooks@codethink.co.uk>
>      spi: s3c64xx: fix timeout counters in flush_fifo
> 
> Artem Sadovnikov <ancowi69@gmail.com>
>      ext4: fix i_data_sem unlock order in ext4_ind_migrate()
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      ext4: ext4_search_dir should return a proper error
> 
> Geert Uytterhoeven <geert+renesas@glider.be>
>      of/irq: Refer to actual buffer size in of_irq_parse_one()
> 
> Geert Uytterhoeven <geert+renesas@glider.be>
>      drm/radeon/r100: Handle unknown family in r100_cp_init_microcode()
> 
> Kees Cook <kees@kernel.org>
>      scsi: aacraid: Rearrange order of struct aac_srb_unit
> 
> Matthew Brost <matthew.brost@intel.com>
>      drm/printer: Allow NULL data in devcoredump printer
> 
> Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
>      drm/amd/display: Fix index out of bounds in degamma hardware format translation
> 
> Alex Hung <alex.hung@amd.com>
>      drm/amd/display: Check stream before comparing them
> 
> Zhao Mengmeng <zhaomengmeng@kylinos.cn>
>      jfs: Fix uninit-value access of new_ea in ea_buffer
> 
> Edward Adam Davis <eadavis@qq.com>
>      jfs: check if leafidx greater than num leaves per dmap tree
> 
> Edward Adam Davis <eadavis@qq.com>
>      jfs: Fix uaf in dbFreeBits
> 
> Remington Brasga <rbrasga@uci.edu>
>      jfs: UBSAN: shift-out-of-bounds in dbFindBits
> 
> Damien Le Moal <dlemoal@kernel.org>
>      ata: sata_sil: Rename sil_blacklist to sil_quirks
> 
> Andrew Davis <afd@ti.com>
>      power: reset: brcmstb: Do not go into infinite loop if reset fails
> 
> Kaixin Wang <kxwang23@m.fudan.edu.cn>
>      fbdev: pxafb: Fix possible use after free in pxafb_task()
> 
> Takashi Iwai <tiwai@suse.de>
>      ALSA: hdsp: Break infinite MIDI input flush loop
> 
> Takashi Iwai <tiwai@suse.de>
>      ALSA: asihpi: Fix potential OOB array access
> 
> Thomas Gleixner <tglx@linutronix.de>
>      signal: Replace BUG_ON()s
> 
> Gustavo A. R. Silva <gustavoars@kernel.org>
>      wifi: mwifiex: Fix memcpy() field-spanning write warning in mwifiex_cmd_802_11_scan_ext()
> 
> Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
>      ACPICA: iasl: handle empty connection_node
> 
> Jason Xing <kernelxing@tencent.com>
>      tcp: avoid reusing FIN_WAIT2 when trying to find port in connect() process
> 
> Ido Schimmel <idosch@nvidia.com>
>      ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>      ipv4: Check !in_dev earlier for ioctl(SIOCSIFADDR).
> 
> Simon Horman <horms@kernel.org>
>      net: mvpp2: Increase size of queue_name buffer
> 
> Simon Horman <horms@kernel.org>
>      tipc: guard against string buffer overrun
> 
> Pei Xiao <xiaopei01@kylinos.cn>
>      ACPICA: check null return of ACPI_ALLOCATE_ZEROED() in acpi_db_convert_to_package()
> 
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>      ACPI: EC: Do not release locks during operation region accesses
> 
> Armin Wolf <W_Armin@gmx.de>
>      ACPICA: Fix memory leak if acpi_ps_get_next_field() fails
> 
> Armin Wolf <W_Armin@gmx.de>
>      ACPICA: Fix memory leak if acpi_ps_get_next_namepath() fails
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      net: hisilicon: hns_mdio: fix OF node leak in probe()
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      net: hisilicon: hns_dsaf_mac: fix OF node leak in hns_mac_get_info()
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      net: hisilicon: hip04: fix OF node leak in probe()
> 
> Toke Høiland-Jørgensen <toke@redhat.com>
>      wifi: ath9k_htc: Use __skb_set_length() for resetting urb before resubmit
> 
> Dmitry Kandybka <d.kandybka@gmail.com>
>      wifi: ath9k: fix possible integer overflow in ath9k_get_et_stats()
> 
> Jann Horn <jannh@google.com>
>      f2fs: Require FMODE_WRITE for atomic write ioctls
> 
> Takashi Iwai <tiwai@suse.de>
>      ALSA: hda/conexant: Fix conflicting quirk for System76 Pangolin
> 
> Takashi Iwai <tiwai@suse.de>
>      ALSA: hda/generic: Unconditionally prefer preferred_dacs pairs
> 
> Xin Long <lucien.xin@gmail.com>
>      sctp: set sk_state back to CLOSED if autobind fails in sctp_listen_start
> 
> Anton Danilov <littlesmilingcloud@gmail.com>
>      ipv4: ip_gre: Fix drops of small packets in ipgre_xmit
> 
> Eric Dumazet <edumazet@google.com>
>      net: add more sanity checks to qdisc_pkt_len_init()
> 
> Eric Dumazet <edumazet@google.com>
>      net: avoid potential underflow in qdisc_pkt_len_init() with UFO
> 
> Aleksander Jan Bajkowski <olek2@wp.pl>
>      net: ethernet: lantiq_etop: fix memory disclosure
> 
> Prashant Malani <pmalani@chromium.org>
>      r8152: Factor out OOB link list waits
> 
> Eric Dumazet <edumazet@google.com>
>      netfilter: nf_tables: prevent nf_skb_duplicated corruption
> 
> Phil Sutter <phil@nwl.cc>
>      netfilter: uapi: NFTA_FLOWTABLE_HOOK is NLA_NESTED
> 
> Xiubo Li <xiubli@redhat.com>
>      ceph: remove the incorrect Fw reference check when dirtying pages
> 
> Stefan Wahren <wahrenst@gmx.net>
>      mailbox: bcm2835: Fix timeout during suspend mode
> 
> Liao Chen <liaochen4@huawei.com>
>      mailbox: rockchip: fix a typo in module autoloading
> 
> Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>      usb: yurex: Fix inconsistent locking bug in yurex_read()
> 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>      i2c: isch: Add missed 'else'
> 
> Tommy Huang <tommy_huang@aspeedtech.com>
>      i2c: aspeed: Update the stop sw state when the bus recovery occurs
> 
> Ma Ke <make24@iscas.ac.cn>
>      pps: add an error check in parport_attach
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      pps: remove usage of the deprecated ida_simple_xx() API
> 
> Oliver Neukum <oneukum@suse.com>
>      USB: misc: yurex: fix race between read and write
> 
> Lee Jones <lee@kernel.org>
>      usb: yurex: Replace snprintf() with the safer scnprintf() variant
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soc: versatile: realview: fix soc_dev leak during device remove
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soc: versatile: realview: fix memory leak during device remove
> 
> Sean Anderson <sean.anderson@linux.dev>
>      PCI: xilinx-nwl: Fix off-by-one in INTx IRQ handler
> 
> Thomas Gleixner <tglx@linutronix.de>
>      PCI: xilinx-nwl: Use irq_data_get_irq_chip_data()
> 
> Li Lingfeng <lilingfeng3@huawei.com>
>      nfs: fix memory leak in error path of nfs4_do_reclaim
> 
> Mickaël Salaün <mic@digikod.net>
>      fs: Fix file_set_fowner LSM hook inconsistencies
> 
> Julian Sun <sunjunchao2870@gmail.com>
>      vfs: fix race between evice_inodes() and find_inode()&iput()
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      f2fs: avoid potential int overflow in sanity_check_area_boundary()
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      f2fs: prevent possible int overflow in dir_block_index()
> 
> Thomas Weißschuh <linux@weissschuh.net>
>      ACPI: sysfs: validate return type of _STR method
> 
> Mikhail Lobanov <m.lobanov@rosalinux.ru>
>      drbd: Add NULL check for net_conf to prevent dereference in state validation
> 
> Qiu-ji Chen <chenqiuji666@gmail.com>
>      drbd: Fix atomicity violation in drbd_uuid_set_bm()
> 
> Florian Fainelli <florian.fainelli@broadcom.com>
>      tty: rp2: Fix reset with non forgiving PCIe host bridges
> 
> Jann Horn <jannh@google.com>
>      firmware_loader: Block path traversal
> 
> Oliver Neukum <oneukum@suse.com>
>      USB: misc: cypress_cy7c63: check for short transfer
> 
> Oliver Neukum <oneukum@suse.com>
>      USB: appledisplay: close race between probe and completion handler
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soc: versatile: integrator: fix OF node leak in probe() error path
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>      Remove *.orig pattern from .gitignore
> 
> Hailey Mothershead <hailmo@amazon.com>
>      crypto: aead,cipher - zeroize key buffer after use
> 
> Simon Horman <horms@kernel.org>
>      netfilter: ctnetlink: compile ctnetlink_label_size with CONFIG_NF_CONNTRACK_EVENTS
> 
> Youssef Samir <quic_yabdulra@quicinc.com>
>      net: qrtr: Update packets cloning when broadcasting
> 
> Josh Hunt <johunt@akamai.com>
>      tcp: check skb is non-NULL in tcp_rto_delta_us()
> 
> Eric Dumazet <edumazet@google.com>
>      tcp: introduce tcp_skb_timestamp_us() helper
> 
> Kaixin Wang <kxwang23@m.fudan.edu.cn>
>      net: seeq: Fix use after free vulnerability in ether3 Driver Due to Race Condition
> 
> Eric Dumazet <edumazet@google.com>
>      netfilter: nf_reject_ipv6: fix nf_reject_ip6_tcphdr_put()
> 
> Suzuki K Poulose <suzuki.poulose@arm.com>
>      coresight: tmc: sg: Do not leak sg_table
> 
> Chao Yu <chao@kernel.org>
>      f2fs: reduce expensive checkpoint trigger frequency
> 
> Chao Yu <chao@kernel.org>
>      f2fs: remove unneeded check condition in __f2fs_setxattr()
> 
> Chao Yu <chao@kernel.org>
>      f2fs: fix to update i_ctime in __f2fs_setxattr()
> 
> Yonggil Song <yonggil.song@samsung.com>
>      f2fs: fix typo
> 
> Chao Yu <yuchao0@huawei.com>
>      f2fs: enhance to update i_mode and acl atomically in f2fs_setattr()
> 
> Guoqing Jiang <guoqing.jiang@linux.dev>
>      nfsd: call cache_put if xdr_reserve_space returns NULL
> 
> Jinjie Ruan <ruanjinjie@huawei.com>
>      ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
> 
> Mikhail Lobanov <m.lobanov@rosalinux.ru>
>      RDMA/cxgb4: Added NULL check for lookup_atid
> 
> Wang Jianzheng <wangjianzheng@vivo.com>
>      pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function
> 
> David Lechner <dlechner@baylibre.com>
>      clk: ti: dra7-atl: Fix leak of of_nodes
> 
> Yang Yingliang <yangyingliang@huawei.com>
>      pinctrl: single: fix missing error code in pcs_probe()
> 
> Zhu Yanjun <yanjun.zhu@linux.dev>
>      RDMA/iwcm: Fix WARNING:at_kernel/workqueue.c:#check_flush_dependency
> 
> Sean Anderson <sean.anderson@linux.dev>
>      PCI: xilinx-nwl: Fix register misspelling
> 
> Junlin Li <make24@iscas.ac.cn>
>      drivers: media: dvb-frontends/rtl2830: fix an out-of-bounds write error
> 
> Junlin Li <make24@iscas.ac.cn>
>      drivers: media: dvb-frontends/rtl2832: fix an out-of-bounds write error
> 
> Jonas Karlman <jonas@kwiboo.se>
>      clk: rockchip: Set parent rate for DCLK_VOP clock on RK3228
> 
> Ian Rogers <irogers@google.com>
>      perf time-utils: Fix 32-bit nsec parsing
> 
> Yang Jihong <yangjihong@bytedance.com>
>      perf sched timehist: Fixed timestamp error when unable to confirm event sched_in time
> 
> Yang Jihong <yangjihong@bytedance.com>
>      perf sched timehist: Fix missing free of session in perf_sched__timehist()
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: fix potential oob read in nilfs_btree_check_delete()
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: determine empty node blocks as corrupted
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>      nilfs2: fix potential null-ptr-deref in nilfs_btree_insert()
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      ext4: avoid OOB when system.data xattr changes underneath the filesystem
> 
> Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
>      ext4: return error on ext4_find_inline_entry
> 
> Kemeng Shi <shikemeng@huaweicloud.com>
>      ext4: avoid negative min_clusters in find_group_orlov()
> 
> Jiawei Ye <jiawei.ye@foxmail.com>
>      smackfs: Use rcu_assign_pointer() to ensure safe assignment in smk_set_cipso
> 
> yangerkun <yangerkun@huawei.com>
>      ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard
> 
> Mauricio Faria de Oliveira <mfo@canonical.com>
>      jbd2: introduce/export functions jbd2_journal_submit|finish_inode_data_buffers()
> 
> Chen Yu <yu.c.chen@intel.com>
>      kthread: fix task state in kthread worker if being frozen
> 
> Rob Clark <robdclark@chromium.org>
>      kthread: add kthread_work tracepoints
> 
> Lasse Collin <lasse.collin@tukaani.org>
>      xz: cleanup CRC32 edits from 2018
> 
> Tony Ambardar <tony.ambardar@gmail.com>
>      selftests/bpf: Fix error compiling test_lru_map.c
> 
> Juergen Gross <jgross@suse.com>
>      xen/swiotlb: add alignment check for dma buffers
> 
> Juergen Gross <jgross@suse.com>
>      xen/swiotlb: simplify range_straddles_page_boundary()
> 
> Juergen Gross <jgross@suse.com>
>      xen: use correct end address of kernel for conflict checking
> 
> Sherry Yang <sherry.yang@oracle.com>
>      drm/msm: fix %s null argument error
> 
> Wolfram Sang <wsa+renesas@sang-engineering.com>
>      ipmi: docs: don't advertise deprecated sysfs entries
> 
> Vladimir Lypak <vladimir.lypak@gmail.com>
>      drm/msm/a5xx: fix races in preemption evaluation stage
> 
> Vladimir Lypak <vladimir.lypak@gmail.com>
>      drm/msm/a5xx: properly clear preemption records on resume
> 
> Jeongjun Park <aha310510@gmail.com>
>      jfs: fix out-of-bounds in dbNextAG() and diAlloc()
> 
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>      drm/radeon/evergreen_cs: fix int overflow errors in cs track offsets
> 
> Alex Bee <knaerzche@gmail.com>
>      drm/rockchip: vop: Allow 4096px width scaling
> 
> Alex Deucher <alexander.deucher@amd.com>
>      drm/radeon: properly handle vbios fake edid sizing
> 
> Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
>      drm/radeon: Replace one-element array with flexible-array member
> 
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu: properly handle vbios fake edid sizing
> 
> Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
>      drm/amdgpu: Replace one-element array with flexible-array member
> 
> Matteo Croce <mcroce@redhat.com>
>      drm/amd: fix typo
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      drm/stm: Fix an error handling path in stm_drm_platform_probe()
> 
> Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>      fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
> 
> Artur Weber <aweber.kernel@gmail.com>
>      power: supply: max17042_battery: Fix SOC threshold calc w/ no current sense
> 
> Yuntao Liu <liuyuntao12@huawei.com>
>      hwmon: (ntc_thermistor) fix module autoloading
> 
> Mirsad Todorovac <mtodorovac69@gmail.com>
>      mtd: slram: insert break after errors in parsing the map
> 
> Guenter Roeck <linux@roeck-us.net>
>      hwmon: (max16065) Fix overflows seen when writing limits
> 
> Ankit Agrawal <agrawal.ag.ankit@gmail.com>
>      clocksource/drivers/qcom: Add missing iounmap() on errors in msm_dt_timer_init()
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      reset: berlin: fix OF node leak in probe() error path
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      ARM: versatile: fix OF node leak in CPUs prepare
> 
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>      spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
> 
> Ma Ke <make24@iscas.ac.cn>
>      spi: ppc4xx: handle irq_of_parse_and_map() errors
> 
> Yu Kuai <yukuai3@huawei.com>
>      block, bfq: don't break merge chain in bfq_split_bfqq()
> 
> Yu Kuai <yukuai3@huawei.com>
>      block, bfq: choose the last bfqq from merge chain in bfq_setup_cooperator()
> 
> Yu Kuai <yukuai3@huawei.com>
>      block, bfq: fix possible UAF for bfqq->bic with merge chain
> 
> Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
>      Bluetooth: btusb: Fix not handling ZPL/short-transfer
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>      can: bcm: Clear bo->bcm_proc_read after remove_proc_entry().
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: mac80211: use two-phase skb reclamation in ieee80211_do_stop()
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: cfg80211: fix two more possible UBSAN-detected off-by-one errors
> 
> Dmitry Antipov <dmantipov@yandex.ru>
>      wifi: cfg80211: fix UBSAN noise in cfg80211_wext_siwscan()
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>      netfilter: nf_tables: elements with timeout below CONFIG_HZ never expire
> 
> Toke Høiland-Jørgensen <toke@redhat.com>
>      wifi: ath9k: Remove error checks when creating debugfs entries
> 
> Minjie Du <duminjie@vivo.com>
>      wifi: ath9k: fix parameter check in ath9k_init_debug()
> 
> Aleksandr Mishin <amishin@t-argos.ru>
>      ACPI: PMIC: Remove unneeded check in tps68470_pmic_opregion_probe()
> 
> Junhao Xie <bigfoot@classfun.cn>
>      USB: serial: pl2303: add device id for Macrosilicon MS3020
> 
> Hagar Hemdan <hagarhem@amazon.com>
>      gpio: prevent potential speculation leaks in gpio_device_get_desc()
> 
> Ferry Meng <mengferry@linux.alibaba.com>
>      ocfs2: strict bound check before memcmp in ocfs2_xattr_find_entry()
> 
> Ferry Meng <mengferry@linux.alibaba.com>
>      ocfs2: add bounds checking to ocfs2_xattr_find_entry()
> 
> Michael Kelley <mhklinux@outlook.com>
>      x86/hyperv: Set X86_FEATURE_TSC_KNOWN_FREQ when Hyper-V provides frequency
> 
> Liao Chen <liaochen4@huawei.com>
>      spi: bcm63xx: Enable module autoloading
> 
> Liao Chen <liaochen4@huawei.com>
>      ASoC: tda7419: fix module autoloading
> 
> Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>      wifi: iwlwifi: mvm: don't wait for tx queues if firmware is dead
> 
> Daniel Gabay <daniel.gabay@intel.com>
>      wifi: iwlwifi: mvm: fix iwl_mvm_max_scan_ie_fw_cmd_room()
> 
> Jacky Chou <jacky_chou@aspeedtech.com>
>      net: ftgmac100: Ensure tx descriptor updates are visible
> 
> Mike Rapoport <rppt@kernel.org>
>      microblaze: don't treat zero reserved memory regions as error
> 
> Thomas Blocher <thomas.blocher@ek-dev.de>
>      pinctrl: at91: make it work with current gpiolib
> 
> Hongbo Li <lihongbo22@huawei.com>
>      ASoC: allow module autoloading for table db1200_pids
> 
> Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
>      selftests/kcmp: remove call to ksft_set_plan()
> 
> Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
>      selftests/vm: remove call to ksft_set_plan()
> 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>      soundwire: stream: Revert "soundwire: stream: fix programming slave ports for non-continous port maps"
> 
> Sean Anderson <sean.anderson@linux.dev>
>      net: dpaa: Pad packets to ETH_ZLEN
> 
> Jacky Chou <jacky_chou@aspeedtech.com>
>      net: ftgmac100: Enable TX interrupt to avoid TX timeout
> 
> Eran Ben Elisha <eranbe@mellanox.com>
>      net/mlx5: Update the list of the PCI supported devices
> 
> Quentin Schulz <quentin.schulz@cherry.de>
>      arm64: dts: rockchip: override BIOS_DISABLE signal via GPIO hog on RK3399 Puma
> 
> Anders Roxell <anders.roxell@linaro.org>
>      scripts: kconfig: merge_config: config files: add a trailing newline
> 
> Pawel Dembicki <paweldembicki@gmail.com>
>      net: phy: vitesse: repair vsc73xx autonegotiation
> 
> Moon Yeounsu <yyyynoom@gmail.com>
>      net: ethernet: use ip_hdrlen() instead of bit shift
> 
> Foster Snowhill <forst@pen.gy>
>      usbnet: ipheth: fix carrier detection in modes 1 and 4
> 
> Aleksandr Mishin <amishin@t-argos.ru>
>      staging: iio: frequency: ad9834: Validate frequency parameter value
> 
> Beniamin Bia <biabeniamin@gmail.com>
>      staging: iio: frequency: ad9833: Load clock using clock framework
> 
> Beniamin Bia <biabeniamin@gmail.com>
>      staging: iio: frequency: ad9833: Get frequency value statically
> 
> 
> -------------
> 
> Diffstat:
> 
>   .gitignore                                         |   1 -
>   Documentation/IPMI.txt                             |   2 +-
>   Documentation/arm64/silicon-errata.txt             |   2 +
>   Documentation/driver-model/devres.txt              |   1 +
>   Makefile                                           |   4 +-
>   arch/arm/mach-realview/platsmp-dt.c                |   1 +
>   arch/arm64/Kconfig                                 |   2 +
>   arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi      |  23 +-
>   arch/arm64/include/asm/cputype.h                   |   4 +
>   arch/arm64/include/asm/uprobes.h                   |  12 +-
>   arch/arm64/kernel/cpu_errata.c                     |   2 +
>   arch/arm64/kernel/probes/decode-insn.c             |  16 +-
>   arch/arm64/kernel/probes/simulate-insn.c           |  18 +-
>   arch/arm64/kernel/probes/uprobes.c                 |   4 +-
>   arch/microblaze/mm/init.c                          |   5 -
>   arch/parisc/kernel/entry.S                         |   6 +-
>   arch/parisc/kernel/syscall.S                       |  14 +-
>   arch/riscv/Kconfig                                 |   5 +
>   arch/s390/include/asm/facility.h                   |   6 +-
>   arch/s390/kernel/perf_cpum_sf.c                    |  12 +-
>   arch/s390/kvm/diag.c                               |   2 +-
>   arch/s390/kvm/gaccess.c                            | 162 +++++---
>   arch/s390/kvm/gaccess.h                            |  14 +-
>   arch/s390/mm/cmm.c                                 |  18 +-
>   arch/x86/include/asm/cpufeatures.h                 |   3 +-
>   arch/x86/kernel/apic/apic.c                        |  14 +-
>   arch/x86/kernel/cpu/mshyperv.c                     |   1 +
>   arch/x86/xen/setup.c                               |   2 +-
>   block/bfq-iosched.c                                |  13 +-
>   crypto/aead.c                                      |   3 +-
>   crypto/cipher.c                                    |   3 +-
>   drivers/acpi/acpica/dbconvert.c                    |   2 +
>   drivers/acpi/acpica/exprep.c                       |   3 +
>   drivers/acpi/acpica/psargs.c                       |  47 +++
>   drivers/acpi/battery.c                             |  28 +-
>   drivers/acpi/button.c                              |  11 +
>   drivers/acpi/device_sysfs.c                        |   5 +-
>   drivers/acpi/ec.c                                  |  55 ++-
>   drivers/acpi/pmic/tps68470_pmic.c                  |   6 +-
>   drivers/ata/sata_sil.c                             |  12 +-
>   drivers/base/bus.c                                 |   6 +-
>   drivers/base/core.c                                |  13 +-
>   drivers/base/firmware_loader/main.c                |  30 ++
>   drivers/base/module.c                              |   4 -
>   drivers/block/aoe/aoecmd.c                         |  13 +-
>   drivers/block/drbd/drbd_main.c                     |   8 +-
>   drivers/block/drbd/drbd_state.c                    |   2 +-
>   drivers/bluetooth/btusb.c                          |  10 +-
>   drivers/char/virtio_console.c                      |  18 +-
>   drivers/clk/bcm/clk-bcm53573-ilp.c                 |   2 +-
>   drivers/clk/clk-devres.c                           | 115 +++++-
>   drivers/clk/rockchip/clk-rk3228.c                  |   2 +-
>   drivers/clk/rockchip/clk.c                         |   3 +-
>   drivers/clk/ti/clk-dra7-atl.c                      |   1 +
>   drivers/clocksource/timer-qcom.c                   |   7 +-
>   drivers/firmware/arm_sdei.c                        |   2 +-
>   drivers/gpio/gpio-aspeed.c                         |   4 +-
>   drivers/gpio/gpio-davinci.c                        |   8 +-
>   drivers/gpio/gpiolib.c                             |   3 +-
>   drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c           |  15 +-
>   drivers/gpu/drm/amd/amdgpu/atombios_encoders.c     |  26 +-
>   drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   2 +
>   .../gpu/drm/amd/display/dc/dcn10/dcn10_cm_common.c |   2 +
>   drivers/gpu/drm/amd/include/atombios.h             |   4 +-
>   drivers/gpu/drm/drm_crtc.c                         |  17 +-
>   drivers/gpu/drm/drm_print.c                        |  13 +-
>   drivers/gpu/drm/msm/adreno/a5xx_gpu.h              |   1 +
>   drivers/gpu/drm/msm/adreno/a5xx_preempt.c          |  26 +-
>   drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c           |   2 +-
>   drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +-
>   drivers/gpu/drm/radeon/atombios.h                  |   2 +-
>   drivers/gpu/drm/radeon/evergreen_cs.c              |  62 +--
>   drivers/gpu/drm/radeon/r100.c                      |  70 ++--
>   drivers/gpu/drm/radeon/radeon_atombios.c           |  26 +-
>   drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   4 +-
>   drivers/gpu/drm/stm/drv.c                          |   4 +-
>   drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   1 +
>   drivers/hid/hid-ids.h                              |   2 +
>   drivers/hid/hid-plantronics.c                      |  23 ++
>   drivers/hwmon/max16065.c                           |   5 +-
>   drivers/hwmon/ntc_thermistor.c                     |   1 +
>   drivers/hwtracing/coresight/coresight-tmc-etr.c    |   2 +-
>   drivers/i2c/busses/i2c-aspeed.c                    |  16 +-
>   drivers/i2c/busses/i2c-i801.c                      |   9 +-
>   drivers/i2c/busses/i2c-isch.c                      |   3 +-
>   drivers/i2c/busses/i2c-xiic.c                      |  19 +-
>   drivers/iio/adc/Kconfig                            |   2 +
>   .../iio/common/hid-sensors/hid-sensor-trigger.c    |   2 +-
>   drivers/iio/dac/Kconfig                            |   1 +
>   drivers/iio/light/opt3001.c                        |   4 +
>   drivers/iio/magnetometer/ak8975.c                  |  32 +-
>   drivers/infiniband/core/iwcm.c                     |   2 +-
>   drivers/infiniband/hw/bnxt_re/qplib_fp.h           |   2 +-
>   drivers/infiniband/hw/bnxt_re/qplib_rcfw.c         |   2 +-
>   drivers/infiniband/hw/cxgb4/cm.c                   |  14 +-
>   drivers/input/keyboard/adp5589-keys.c              |  13 +-
>   drivers/input/rmi4/rmi_driver.c                    |   6 +-
>   drivers/mailbox/bcm2835-mailbox.c                  |   3 +-
>   drivers/mailbox/rockchip-mailbox.c                 |   2 +-
>   drivers/media/common/videobuf2/videobuf2-core.c    |   8 +-
>   drivers/media/dvb-frontends/rtl2830.c              |   2 +-
>   drivers/media/dvb-frontends/rtl2832.c              |   2 +-
>   drivers/media/platform/qcom/venus/core.c           |   1 +
>   drivers/misc/sgi-gru/grukservices.c                |   2 -
>   drivers/misc/sgi-gru/grumain.c                     |   4 -
>   drivers/misc/sgi-gru/grutlbpurge.c                 |   2 -
>   drivers/mtd/devices/slram.c                        |   2 +
>   drivers/net/dsa/mv88e6xxx/global1_atu.c            |   3 +-
>   drivers/net/ethernet/aeroflex/greth.c              |   3 +-
>   drivers/net/ethernet/amd/mvme147.c                 |   7 +-
>   drivers/net/ethernet/broadcom/bcmsysport.c         |   1 +
>   drivers/net/ethernet/cortina/gemini.c              |  15 +-
>   drivers/net/ethernet/emulex/benet/be_main.c        |  10 +-
>   drivers/net/ethernet/faraday/ftgmac100.c           |  26 +-
>   drivers/net/ethernet/faraday/ftgmac100.h           |   2 +-
>   drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   9 +-
>   drivers/net/ethernet/hisilicon/hip04_eth.c         |   1 +
>   drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   1 +
>   drivers/net/ethernet/hisilicon/hns_mdio.c          |   1 +
>   drivers/net/ethernet/i825xx/sun3_82586.c           |   1 +
>   drivers/net/ethernet/ibm/emac/mal.c                |   2 +-
>   drivers/net/ethernet/intel/igb/igb_main.c          |   6 +-
>   drivers/net/ethernet/jme.c                         |  10 +-
>   drivers/net/ethernet/lantiq_etop.c                 |   4 +-
>   drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |   2 +-
>   drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +
>   drivers/net/ethernet/seeq/ether3.c                 |   2 +
>   drivers/net/gtp.c                                  |  27 +-
>   drivers/net/hyperv/netvsc_drv.c                    |  30 ++
>   drivers/net/macsec.c                               |  18 -
>   drivers/net/phy/vitesse.c                          |  14 -
>   drivers/net/ppp/ppp_async.c                        |   2 +-
>   drivers/net/usb/cdc_ncm.c                          |   8 +-
>   drivers/net/usb/ipheth.c                           |   5 +-
>   drivers/net/usb/r8152.c                            |  73 +---
>   drivers/net/usb/usbnet.c                           |   3 +-
>   drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   7 +-
>   drivers/net/wireless/ath/ath10k/wmi.c              |   2 +
>   drivers/net/wireless/ath/ath9k/debug.c             |   6 +-
>   drivers/net/wireless/ath/ath9k/hif_usb.c           |   6 +-
>   drivers/net/wireless/ath/ath9k/htc_drv_debug.c     |   2 -
>   drivers/net/wireless/intel/iwlegacy/common.c       |   2 +
>   drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   9 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   8 +-
>   drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
>   drivers/net/wireless/marvell/mwifiex/scan.c        |   3 +-
>   drivers/ntb/hw/intel/ntb_hw_gen1.c                 |   2 +-
>   drivers/of/irq.c                                   |  38 +-
>   drivers/parport/procfs.c                           |  22 +-
>   drivers/pci/controller/pcie-xilinx-nwl.c           |  24 +-
>   drivers/pci/quirks.c                               |   6 +
>   drivers/pinctrl/mvebu/pinctrl-dove.c               |  42 +-
>   drivers/pinctrl/pinctrl-at91.c                     |   5 +-
>   drivers/pinctrl/pinctrl-single.c                   |   3 +-
>   drivers/power/reset/brcmstb-reboot.c               |   3 -
>   drivers/power/supply/max17042_battery.c            |   5 +-
>   drivers/pps/clients/pps_parport.c                  |  14 +-
>   drivers/reset/reset-berlin.c                       |   3 +-
>   drivers/rtc/Kconfig                                |   2 +-
>   drivers/rtc/rtc-at91sam9.c                         |  45 +-
>   drivers/s390/char/sclp_vt220.c                     |   4 +-
>   drivers/scsi/aacraid/aacraid.h                     |   2 +-
>   drivers/soc/versatile/soc-integrator.c             |   1 +
>   drivers/soc/versatile/soc-realview.c               |  20 +-
>   drivers/soundwire/stream.c                         |   8 +-
>   drivers/spi/spi-bcm63xx.c                          |   2 +
>   drivers/spi/spi-ppc4xx.c                           |   7 +-
>   drivers/spi/spi-s3c64xx.c                          |   4 +-
>   drivers/staging/iio/frequency/ad9834.c             |  54 +--
>   drivers/staging/iio/frequency/ad9834.h             |  28 --
>   drivers/tty/serial/rp2.c                           |   2 +-
>   drivers/tty/vt/vt.c                                |   2 +-
>   drivers/usb/chipidea/udc.c                         |   8 +-
>   drivers/usb/dwc3/core.c                            |  49 ++-
>   drivers/usb/dwc3/core.h                            |  11 +-
>   drivers/usb/dwc3/gadget.c                          |  11 -
>   drivers/usb/host/xhci-pci.c                        |   5 +
>   drivers/usb/host/xhci-ring.c                       |  16 +-
>   drivers/usb/host/xhci.h                            |   2 +-
>   drivers/usb/misc/appledisplay.c                    |  15 +-
>   drivers/usb/misc/cypress_cy7c63.c                  |   4 +
>   drivers/usb/misc/yurex.c                           |   5 +-
>   drivers/usb/phy/phy.c                              |   2 +-
>   drivers/usb/serial/option.c                        |   8 +
>   drivers/usb/serial/pl2303.c                        |   1 +
>   drivers/usb/serial/pl2303.h                        |   4 +
>   drivers/usb/storage/unusual_devs.h                 |  11 +
>   drivers/usb/typec/class.c                          |   3 +
>   drivers/video/fbdev/hpfb.c                         |   1 +
>   drivers/video/fbdev/pxafb.c                        |   1 +
>   drivers/video/fbdev/sis/sis_main.c                 |   2 +-
>   drivers/xen/swiotlb-xen.c                          |  40 +-
>   fs/btrfs/disk-io.c                                 |  11 +
>   fs/ceph/addr.c                                     |   1 -
>   fs/ext4/ext4.h                                     |   1 +
>   fs/ext4/extents.c                                  |  70 +++-
>   fs/ext4/ialloc.c                                   |   2 +
>   fs/ext4/inline.c                                   |  35 +-
>   fs/ext4/inode.c                                    |  11 +-
>   fs/ext4/mballoc.c                                  |  10 +-
>   fs/ext4/migrate.c                                  |   2 +-
>   fs/ext4/move_extent.c                              |   1 -
>   fs/ext4/namei.c                                    |  14 +-
>   fs/ext4/xattr.c                                    |   4 +-
>   fs/f2fs/acl.c                                      |  23 +-
>   fs/f2fs/dir.c                                      |   3 +-
>   fs/f2fs/f2fs.h                                     |   4 +-
>   fs/f2fs/file.c                                     |  24 +-
>   fs/f2fs/super.c                                    |   4 +-
>   fs/f2fs/xattr.c                                    |  29 +-
>   fs/fat/namei_vfat.c                                |   2 +-
>   fs/fcntl.c                                         |  14 +-
>   fs/inode.c                                         |   4 +
>   fs/jbd2/checkpoint.c                               |  14 +-
>   fs/jbd2/commit.c                                   |  36 +-
>   fs/jbd2/journal.c                                  |   2 +
>   fs/jfs/jfs_discard.c                               |  11 +-
>   fs/jfs/jfs_dmap.c                                  |  11 +-
>   fs/jfs/jfs_imap.c                                  |   2 +-
>   fs/jfs/xattr.c                                     |   2 +
>   fs/lockd/clnt4xdr.c                                |  14 -
>   fs/lockd/clntxdr.c                                 |  14 -
>   fs/nfs/callback_xdr.c                              |  61 ++-
>   fs/nfs/nfs2xdr.c                                   |  84 ++--
>   fs/nfs/nfs3xdr.c                                   | 163 +++-----
>   fs/nfs/nfs42xdr.c                                  |  21 +-
>   fs/nfs/nfs4state.c                                 |   1 +
>   fs/nfs/nfs4xdr.c                                   | 451 ++++++---------------
>   fs/nfsd/nfs4callback.c                             |  13 -
>   fs/nfsd/nfs4idmap.c                                |  13 +-
>   fs/nfsd/nfs4state.c                                |  15 +-
>   fs/nilfs2/btree.c                                  |  12 +-
>   fs/nilfs2/dir.c                                    |  50 +--
>   fs/nilfs2/namei.c                                  |  42 +-
>   fs/nilfs2/nilfs.h                                  |   2 +-
>   fs/nilfs2/page.c                                   |   7 +-
>   fs/ocfs2/aops.c                                    |   5 +-
>   fs/ocfs2/buffer_head_io.c                          |   4 +-
>   fs/ocfs2/file.c                                    |   8 +
>   fs/ocfs2/journal.c                                 |   7 +-
>   fs/ocfs2/localalloc.c                              |  19 +
>   fs/ocfs2/quota_local.c                             |   8 +-
>   fs/ocfs2/refcounttree.c                            |  26 +-
>   fs/ocfs2/xattr.c                                   |  38 +-
>   fs/udf/inode.c                                     |   9 +-
>   include/drm/drm_print.h                            |  54 ++-
>   include/dt-bindings/power/r8a774b1-sysc.h          |  26 ++
>   include/linux/clk.h                                | 145 +++++++
>   include/linux/jbd2.h                               |   4 +
>   include/linux/pci_ids.h                            |   2 +
>   include/net/sock.h                                 |   2 +
>   include/net/tcp.h                                  |  27 +-
>   include/trace/events/f2fs.h                        |   3 +-
>   include/trace/events/sched.h                       |  84 ++++
>   include/uapi/linux/cec.h                           |   6 +-
>   include/uapi/linux/netfilter/nf_tables.h           |   2 +-
>   kernel/bpf/arraymap.c                              |   3 +
>   kernel/bpf/hashtab.c                               |   3 +
>   kernel/bpf/lpm_trie.c                              |   2 +-
>   kernel/cgroup/cgroup.c                             |   4 +-
>   kernel/events/core.c                               |   6 +-
>   kernel/events/uprobes.c                            |   2 +-
>   kernel/kthread.c                                   |  19 +-
>   kernel/signal.c                                    |  11 +-
>   kernel/time/posix-clock.c                          |   3 +
>   kernel/trace/trace_output.c                        |   6 +-
>   lib/xz/xz_crc32.c                                  |   2 +-
>   lib/xz/xz_private.h                                |   4 -
>   mm/shmem.c                                         |   2 +
>   net/bluetooth/af_bluetooth.c                       |   1 +
>   net/bluetooth/bnep/core.c                          |   3 +-
>   net/bluetooth/rfcomm/sock.c                        |   2 -
>   net/bridge/br_netfilter_hooks.c                    |   5 +
>   net/can/bcm.c                                      |   4 +-
>   net/core/dev.c                                     |  29 +-
>   net/ipv4/devinet.c                                 |   6 +-
>   net/ipv4/fib_frontend.c                            |   2 +-
>   net/ipv4/ip_gre.c                                  |   6 +-
>   net/ipv4/netfilter/nf_dup_ipv4.c                   |   7 +-
>   net/ipv4/tcp_input.c                               |  24 +-
>   net/ipv4/tcp_ipv4.c                                |   5 +-
>   net/ipv4/tcp_output.c                              |   2 +-
>   net/ipv4/tcp_rate.c                                |  17 +-
>   net/ipv4/tcp_recovery.c                            |   5 +-
>   net/ipv6/addrconf.c                                |   8 +-
>   net/ipv6/netfilter/nf_dup_ipv6.c                   |   7 +-
>   net/ipv6/netfilter/nf_reject_ipv6.c                |  14 +-
>   net/mac80211/cfg.c                                 |   3 +-
>   net/mac80211/iface.c                               |  17 +-
>   net/mac80211/key.c                                 |  42 +-
>   net/netfilter/nf_conntrack_netlink.c               |   7 +-
>   net/netfilter/nf_tables_api.c                      |   2 +-
>   net/netfilter/nft_payload.c                        |   3 +
>   net/netlink/af_netlink.c                           |   3 +-
>   net/qrtr/qrtr.c                                    |   2 +-
>   net/sched/sch_api.c                                |   2 +-
>   net/sctp/socket.c                                  |   4 +-
>   net/tipc/bearer.c                                  |   8 +-
>   net/wireless/nl80211.c                             |   3 +-
>   net/wireless/scan.c                                |   6 +-
>   net/wireless/sme.c                                 |   3 +-
>   net/xfrm/xfrm_user.c                               |   6 +-
>   scripts/kconfig/merge_config.sh                    |   2 +
>   security/selinux/selinuxfs.c                       |  31 +-
>   security/smack/smackfs.c                           |   2 +-
>   security/tomoyo/domain.c                           |   9 +-
>   sound/core/init.c                                  |  14 +-
>   sound/pci/asihpi/hpimsgx.c                         |   2 +-
>   sound/pci/hda/hda_generic.c                        |   4 +-
>   sound/pci/hda/patch_conexant.c                     |  24 +-
>   sound/pci/hda/patch_realtek.c                      |  38 +-
>   sound/pci/rme9652/hdsp.c                           |   6 +-
>   sound/pci/rme9652/hdspm.c                          |   6 +-
>   sound/soc/au1x/db1200.c                            |   1 +
>   sound/soc/codecs/tda7419.c                         |   1 +
>   tools/iio/iio_generic_buffer.c                     |   4 +
>   tools/perf/builtin-sched.c                         |   8 +-
>   tools/perf/util/time-utils.c                       |   4 +-
>   tools/testing/ktest/ktest.pl                       |   2 +-
>   tools/testing/selftests/bpf/test_lru_map.c         |   3 +-
>   .../breakpoints/step_after_suspend_test.c          |   5 +-
>   tools/testing/selftests/kcmp/kcmp_test.c           |   1 -
>   tools/testing/selftests/vDSO/parse_vdso.c          |   3 +-
>   tools/testing/selftests/vm/compaction_test.c       |   2 -
>   tools/usb/usbip/src/usbip_detach.c                 |   1 +
>   virt/kvm/kvm_main.c                                |   5 +-
>   326 files changed, 2647 insertions(+), 1789 deletions(-)
> 
> 
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A915C2ED;
> 	Thu,  7 Nov 2024 08:38:05 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
> ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1730968688; cv=none; b=nnXTSwMdndwO1ai9WQrCa5YRKbb/Jviuwgp0OBrsILxRixfqAblWzKGRG4oxqok9AuVBa9cabTgD2jdDoLwjla6jUJA6TYw7j1S6VyYnOFmY4uMwyBwthUG4dz/pWKv2hgxcARrRfMdtzIU6sx388y0KELCTalGq2iLz1mPGrJc=
> ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1730968688; c=relaxed/simple;
> 	bh=5K9RBw/syKo/ToA0mTS9h7O9ZvRiBwpEZbv4gIcFtbU=;
> 	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
> 	 To:Cc:Content-Type; b=uOHmyzkDXlIUCFwAWJ8EbeFdw+7g9OrytIFHmkOZJkyqmFoLNIjxzgKBUSBiPnmWh57jp1SwLTCEVRUFPXjnNBv41tAZwPuxoN2hOnm+4cnt031FtuT2ZhdSQLJoeTR7f+J10oQ5zZgzzO5Tv4CSXJQqv4W8q4++E/U/ppMbYZ0=
> ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.170
> Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
> Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
> Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e30eca40dedso660773276.3;
>          Thu, 07 Nov 2024 00:38:05 -0800 (PST)
> X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>          d=1e100.net; s=20230601; t=1730968684; x=1731573484;
>          h=content-transfer-encoding:cc:to:subject:message-id:date:from
>           :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
>           :subject:date:message-id:reply-to;
>          bh=5qIkpxX8mie6S98MLU//bN6Dn5DgRJ3nz9AaO+MRWEA=;
>          b=TSigyAEcQMrRkAKRc61iKelsmqofoSXq3TU/O0KksqXMtjlB/GqFlpc/YRd8Sit7Pz
>           //8tyL93hjtntoLbTYDJQEOcWqrVSUYJyRcMu/xckLIx+jAAsZWTfeRv2Gg1qdzEk0wi
>           NfMyjHNAsejoXm6UU6S71xwfj7uqvPAmQfZG+NhTgQiOT/WbJlJIOYgw55Gt//GB3q15
>           F3w99jWgDeO3RjsqJIl92PxinyzKGwPwctwZX4lNYSEBReS1Ks8kJdUiQ/0gFzZfB5w+
>           7257k5n27SZbjlwEn9ZbPvxy080TxMJyQyQ2hQEHPOzX9pPTT5NR1XzKQAfrgvtDASom
>           7FTQ==
> X-Forwarded-Encrypted: i=1; AJvYcCWiEej7tA95R1Fkc8mz4GIVp54lQ3NpW+6T/rhL0GIHrjrdM429tXUEKr4OQqEGG/cXm85hBqv1nquUEDQ=@vger.kernel.org
> X-Gm-Message-State: AOJu0YzA9yT2GHbpsMn36vaGbQlENQEhchlqpF7q62AjXJVS+Bc/To/C
> 	v7xjpwMTK6EVEiGA9CTRVJ5pdk0MUB4SBlNdyBeFz+6HYm14PJOpV8pHgp9P
> X-Google-Smtp-Source: AGHT+IG2olxERWCpX331xNjCDkE9qS3jern++gAIXhaBDRTMTteLQ2i5oXbyIVmOHyUJmt4WC//tyQ==
> X-Received: by 2002:a05:6902:70d:b0:e33:1717:ebb0 with SMTP id 3f1490d57ef6-e331717ece6mr17128311276.52.1730968684555;
>          Thu, 07 Nov 2024 00:38:04 -0800 (PST)
> Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
>          by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336f1ed085sm181566276.52.2024.11.07.00.38.03
>          (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
>          Thu, 07 Nov 2024 00:38:03 -0800 (PST)
> Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6ea5003deccso7200567b3.0;
>          Thu, 07 Nov 2024 00:38:03 -0800 (PST)
> X-Forwarded-Encrypted: i=1; AJvYcCWuy3jN5F6lECvKsBVCpLmdav89zPtqq+gYG0hSpcmxrTLiDHlLBDnIcgRyQJLdWoZWmz/Ii9WeoJy2mG0=@vger.kernel.org
> X-Received: by 2002:a05:690c:6f8e:b0:685:3ca1:b9d8 with SMTP id
>   00721157ae682-6ea64bdd307mr238656597b3.30.1730968683252; Thu, 07 Nov 2024
>   00:38:03 -0800 (PST)
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> References: <20241107063342.964868073@linuxfoundation.org>
> In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Thu, 7 Nov 2024 09:37:51 +0100
> X-Gmail-Original-Message-ID: <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
> Message-ID: <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org, patches@lists.linux.dev,
> 	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
> 	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
> 	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
> 	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
> 	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
> 	broonie@kernel.org
> Content-Type: text/plain; charset="UTF-8"
> Content-Transfer-Encoding: quoted-printable
> 
> Hi Greg,
> 
> On Thu, Nov 7, 2024 at 7:47=E2=80=AFAM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> This is the start of the stable review cycle for the 4.19.323 release.
>> There are 349 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
>> Anything received after that time might be too late.
> 
>> Biju Das <biju.das@bp.renesas.com>
>>      dt-bindings: power: Add r8a774b1 SYSC power domain definitions
> 
> Same question as yesterday: why is this being backported (to multiple
> stable trees)? It is (only a small subset of) new hardware support.
> 
>> Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")
> 
> This is completely unrelated?
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
> .org
> 
> In personal conversations with technical people, I call myself a hacker. Bu=
> t
> when I'm talking to journalists I just say "programmer" or something like t=
> hat.
>                                  -- Linus Torvalds
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B77C1D3644;
> 	Thu,  7 Nov 2024 09:07:01 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
> ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1730970423; cv=none; b=aMOtWA/vwUDI4xZ4JGVT2s8nrw1dbUZZ6pU/58v78suY2zD9n8XNakRMg+8QCLFMX7bJSV9w56qygxsGMGWXGBPwavgazFqYS+Umihx2stvzfjXVdpCsQeRZkeZ84djPfQ3ozbCYtDzkHFkx/yRuwAFf7tbShG+eCycfegwkvGE=
> ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1730970423; c=relaxed/simple;
> 	bh=7/gT3e2vF+8UozxHJgGUXtyS5R6CJXcTb7xN5x7/23w=;
> 	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
> 	 Content-Type:Content-Disposition:In-Reply-To; b=c9uErVL1QN3lmmfB5nFGegdlD1TVqynhThpOdeV+WkQ9WxMQUwpRwjqQTCHnyN4UA6EZ1ePRRE3HP1eRPDcOwk7h1owPqrrZJqes+xTGuOGLQII8EwlLLRuCie2DaLv0SUg/RkPvtiNI/+waEAyb05hyTtkXcBhzFqRmEfBGrvc=
> ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBf2jHxi; arc=none smtp.client-ip=10.30.226.201
> Authentication-Results: smtp.subspace.kernel.org;
> 	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBf2jHxi"
> Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38E7C4CECC;
> 	Thu,  7 Nov 2024 09:07:00 +0000 (UTC)
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
> 	s=korg; t=1730970421;
> 	bh=7/gT3e2vF+8UozxHJgGUXtyS5R6CJXcTb7xN5x7/23w=;
> 	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
> 	b=BBf2jHxifnL7H1g+Vm7TeOEdKsqy1LobDuvow7xQ7UngAz4pnuCG7WCGlZfIoXtvi
> 	 wFBrHMWP3bjhuYfwFKE3k7/rqFSyfdfa8C1lfoBhHC43esCAAJC47PsI4E6dyD168J
> 	 IXi42o19MKbEIGCASO1iCOS6daVhzyY0KLjw7I/M=
> Date: Thu, 7 Nov 2024 10:06:41 +0100
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> To: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org, patches@lists.linux.dev,
> 	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
> 	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
> 	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
> 	jonathanh@nvidia.com, f.fainelli@gmail.com,
> 	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
> 	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> Message-ID: <2024110723-bonus-glacier-710e@gregkh>
> References: <20241107063342.964868073@linuxfoundation.org>
>   <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Disposition: inline
> Content-Transfer-Encoding: 8bit
> In-Reply-To: <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
> 
> On Thu, Nov 07, 2024 at 09:37:51AM +0100, Geert Uytterhoeven wrote:
>> Hi Greg,
>>
>> On Thu, Nov 7, 2024 at 7:47 AM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> This is the start of the stable review cycle for the 4.19.323 release.
>>> There are 349 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
>>> Anything received after that time might be too late.
>>
>>> Biju Das <biju.das@bp.renesas.com>
>>>      dt-bindings: power: Add r8a774b1 SYSC power domain definitions
>>
>> Same question as yesterday: why is this being backported (to multiple
>> stable trees)? It is (only a small subset of) new hardware support.
>>
>>> Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")
>>
>> This is completely unrelated?
> 
> Yes, sorry, was getting to build breaks first, then dropping stuff like
> this, it's now gone.
> 
> greg k-h
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CFC1F4FAC;
> 	Thu,  7 Nov 2024 11:26:24 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
> ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1730978786; cv=none; b=PckmaCO0u7bNxwbADf1tdlgXaCSQ4AKBRmT+ZC8LQgHT9piytHjY4KEDdmfk2Wm8ISDXhM96pr8vy66cq/i5sa3lURVVXh/vqP7JbeiGZMzkz0HC02joSi24pIqHFftxTmZbQfZBA2nyihT68tU4VcljBtHeM4Nwvqsvd2JVVmk=
> ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1730978786; c=relaxed/simple;
> 	bh=AP1r37wh364kl0yFfqEBPH7GMuovIDo94kuiuFkNLT0=;
> 	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
> 	 Content-Type:Content-Disposition:In-Reply-To; b=OClrlxtYfDiPbJKiZkhguHFmCIUvXB7F5u3yZrYxtswv3KtkICqSAg+q5h82kYpf7OH0pjFL9c+I+RfJdC9apP16l/xlekKq5MzyaxqnwJzJKn0JDbtX0lzqC5DX4i+O3KNsX4E9v1wWQm7hjQdH7NkksqcMzUNxRnx8FBKzT+8=
> ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
> Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
> Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
> Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
> 	id 4F05A1C00A0; Thu,  7 Nov 2024 12:26:22 +0100 (CET)
> Date: Thu, 7 Nov 2024 12:26:21 +0100
> From: Pavel Machek <pavel@denx.de>
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org, patches@lists.linux.dev,
> 	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
> 	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
> 	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
> 	jonathanh@nvidia.com, f.fainelli@gmail.com,
> 	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
> 	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> Message-ID: <Zyyj3ehH8w1zPWlw@duo.ucw.cz>
> References: <20241107063342.964868073@linuxfoundation.org>
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> Content-Type: multipart/signed; micalg=pgp-sha1;
> 	protocol="application/pgp-signature"; boundary="9glvebqAqshtow0q"
> Content-Disposition: inline
> In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
> 
> 
> --9glvebqAqshtow0q
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
> 
> Hi!
> 
>> This is the start of the stable review cycle for the 4.19.323 release.
>> There are 349 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
> 4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> Best regards,
>                                                                  Pavel
> --=20
> DENX Software Engineering GmbH,        Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> 
> --9glvebqAqshtow0q
> Content-Type: application/pgp-signature; name="signature.asc"
> 
> -----BEGIN PGP SIGNATURE-----
> 
> iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZyyj3QAKCRAw5/Bqldv6
> 8mkiAJ4/cuaKxQtZCIQeJ/fGFaZOIMr5wQCfVa0sFZyPUL7+JqNVgmn2/YREMeo=
> =hsRZ
> -----END PGP SIGNATURE-----
> 
> --9glvebqAqshtow0q--
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA961A0700;
> 	Thu,  7 Nov 2024 13:42:12 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
> ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1730986934; cv=fail; b=YSLPiOmUFhgPE3a4HsBx7BXkjBegNs485q+6WQsH1nDjTo2SZnVUIDiMlPzigTNdkQDEIMOHSTROf0uoTnMy03KljI26kykTQw8Et78uO8OblRsvBBWmfvP5lmMruuyd7zsCnzTgl1zdnghKWejJBv5gc4uZ1SITemXTY7LBnzY=
> ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1730986934; c=relaxed/simple;
> 	bh=tp9WVShPB11dpIuRkhZfdZ01J71CqP2Tmd7i+Iep9tA=;
> 	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
> 	 MIME-Version:Message-ID:Date; b=u8eGPqy65d+YgXjUFdaa45+jHkq5Am/GttQudbMPezTZed9WoP6ZJX/lSz/j8HyzE0MUyCNc/X9569qDuGxv0yLe1iWPHQGIy7bFq4BIcc4q8z5MNvENS85ZjvgYaQflNCXgZSNYw5v+935ioLzLCLspGKEJBJQgG7ZPs6+1jOg=
> ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qoE6BrM3; arc=fail smtp.client-ip=40.107.94.77
> Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
> Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
> Authentication-Results: smtp.subspace.kernel.org;
> 	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qoE6BrM3"
> ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
>   b=tv8X9jsptWx9KEtDIrOGzwRWaRO1XyjgIyw2vES1GGso/JeKk+wTsk4nijvsHvtyvnlkG4UCWy+jvw+4FkpPv3CAjmpZpMeH/01EWBCt185e5CtYsSECYhtJ70iZJuPsq+8yrKGGTct53czphnLVq5jHtrgFYUg/0OSchTCXXCKG1Mi6Yjy0kNJS5qMZugi6eWrUO0l7LVsVNHlGkMA09HkBlpla/wz40WiY/+S7kTccRBgqy6HKfemfI1jHGJsNgLJdK3b8wawv/PRCJk4V+W2V5mRF8xEkMTM5+0X2XEujwEMMgBkclSo40Kn4sTiUYp3rUs3mOuYW8xkZhjG9Ww==
> ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
>   s=arcselector10001;
>   h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
>   bh=B3zuJJXlBxHV9Q3Kxkdkhy/oLJOE0TpXw81Zx1hcA+E=;
>   b=yiT6xbOKSAGFaKyufSPUGkCEDcC9jpXHGNtDZu9sTDeqHVWAXwJYn7jdvYAYkiuuoJackLd0CMp8gzCtWCkZ+3g7VEIfw4NVV5+2Jz6uVn00umjvo2XehR57FV+VArNW27CtXByFUNjb9D7wE6GJRL2VJWNz5iKPrBlJWeocjbFCzv821j43jq1oiSCN9hSrCaV2NgraaJkUE0mkno1Z6G1I721eC/tjU56WiH4HG7vpkwTkaJayUXGY1KEB/15q1T9pX9unbHRDhh7sVOyyZHHYFJtiXuCxBGfDPyr8xeFGJO27yaRVyvthN9LEFlgDSItwMJPfhE2ZyCd09McTmg==
> ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
>   216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
>   smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
>   header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
>   s=selector2;
>   h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
>   bh=B3zuJJXlBxHV9Q3Kxkdkhy/oLJOE0TpXw81Zx1hcA+E=;
>   b=qoE6BrM3VObxMkRGmAGNLN771PKb2UKrLaVkiZ/Sn64ilvD+6v9JqqXghS0f0tIb/qTeqtVK/h7s/iUAz174MenMotrwEbkr1BLZCNZvmED0klOeWBF/SYMx7+PahnUZDsDGqpszjyMcRA5RGK8molm6gBtvUb03HZ37xsWOu25NXDWiNd6fXja3tYE47i2ZaoaRTOpBjcP2+cE+1jD8RQRjJV2LxTklvMN0IXL/yT+uSkLBrSuKO7ffEXSYQbJuF+5y5jykiTdQCqu1Ez3BAe99YrHZB1qe4lEu1Ya9XnAggc/fykPy+TbnP+HVs7p7NJSn45VdG/mgTpMCLCn5ZA==
> Received: from SJ0PR03CA0384.namprd03.prod.outlook.com (2603:10b6:a03:3a1::29)
>   by CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with
>   Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Thu, 7 Nov
>   2024 13:42:09 +0000
> Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
>   (2603:10b6:a03:3a1:cafe::78) by SJ0PR03CA0384.outlook.office365.com
>   (2603:10b6:a03:3a1::29) with Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
>   Transport; Thu, 7 Nov 2024 13:42:09 +0000
> X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
>   smtp.mailfrom=nvidia.com; dkim=none (message not signed)
>   header.d=none;dmarc=pass action=none header.from=nvidia.com;
> Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
>   216.228.117.161 as permitted sender) receiver=protection.outlook.com;
>   client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
> Received: from mail.nvidia.com (216.228.117.161) by
>   SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
>   SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
>   15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:42:09 +0000
> Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
>   (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
>   05:41:57 -0800
> Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
>   (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
>   05:41:57 -0800
> Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
>   (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
>   Transport; Thu, 7 Nov 2024 05:41:56 -0800
> From: Jon Hunter <jonathanh@nvidia.com>
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> 	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
> 	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
> 	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
> 	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
> 	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
> 	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
> 	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
> References: <20241107063342.964868073@linuxfoundation.org>
> X-NVConfidentiality: public
> Content-Type: text/plain; charset="utf-8"
> Content-Transfer-Encoding: 7bit
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> Message-ID: <4f582cfd-b2c9-4947-97ed-e725d48cf630@rnnvmail201.nvidia.com>
> Date: Thu, 7 Nov 2024 05:41:56 -0800
> X-NV-OnPremToCloud: ExternallySecured
> X-EOPAttributedMessage: 0
> X-MS-PublicTrafficType: Email
> X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|CH2PR12MB4070:EE_
> X-MS-Office365-Filtering-Correlation-Id: a9ecf29c-aab9-48ad-3ed9-08dcff31fa12
> X-MS-Exchange-SenderADCheck: 1
> X-MS-Exchange-AntiSpam-Relay: 0
> X-Microsoft-Antispam:
> 	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
> X-Microsoft-Antispam-Message-Info:
> 	=?utf-8?B?VTFYR1R1RHhhRFVmYnkxYk44Nzl0aERIdUNCSXE4bm5UdVF4OHVQbjNIY3hN?=
>   =?utf-8?B?end2TnlBaEJVbDN0TTFQcVNMMmpOc21wcGpQc0dwU3UwY3JKSEFvUllIdWJt?=
>   =?utf-8?B?b2tqMWlCSTVGK0xSY3M3dzRpZ3Rlanh5MVpCUDM1NGoveXNGOXAvMjlwQ3JW?=
>   =?utf-8?B?a21BVWE5RDlvckNVc0tqVEl5ZDBKTTl5SWNTZHRRbXY2YytVVGVpaUJ3VGZq?=
>   =?utf-8?B?clVKQzhyNkVIZmJzZFVvRmVFNTBmZDlYSzk0NmVGSmRUYW1PSEFTVWpHbERK?=
>   =?utf-8?B?WTgyTitnZHozTHZJenJNUVkvd0o2MHdwSmtQWGcxZUV5ajdTODUzbi9uKzJq?=
>   =?utf-8?B?T3FsZWFqdlh4U1VyQ0h5YVIxak5KZlB6NDhINjNFNjZBcEFYOXNOejRuTzlR?=
>   =?utf-8?B?UjdkbDR0VFE5WW1HcjVrVlhwRDdTZFh4RU04RE4ycW1TMEJxOXEwd21DTmxv?=
>   =?utf-8?B?d3EzdHBzNEhORElnQm50MnluOGt2UStXYXpuRWtVQUowWmx0MTBUeVhmWkEx?=
>   =?utf-8?B?WWFoUGxDbzdKL29KOE5HN2xYNEEzL2NoclV6bGNwekdqMVgvam1QUFFCbThC?=
>   =?utf-8?B?aDV6cnRWSVJxZTIydlppM2RWd2VKQ1hhaHBoZVFiNitHRzZVZGR5TVUwZmtT?=
>   =?utf-8?B?Y0JaZlVoL1h4VHYxYzJMVzlsSVN6Qys1ZXdkT0llV3A3RnRZSmlEem9BQ3Bv?=
>   =?utf-8?B?M2k0L1hyOHZ5a25xdXlDRkJURVBuNmdzaFpBK0lxTForTTY3aUk5S21xYUNz?=
>   =?utf-8?B?Yi93NFZFaGF1WmowbVA4bHNiWlErbFAveFhQSitpd1B3SWVJV1Bobk5XSDdr?=
>   =?utf-8?B?MWpMK0w1dGFBaStwVEdtRmEvWldkQ3lWOXJUYmRpNGh4SVZiT3NPK2FJcTEy?=
>   =?utf-8?B?MFArTDhjQnJ4V2RJaTkyOW5YbFJla0FxTDlxRFozVXIyd2pJcXRpNFZFWXZX?=
>   =?utf-8?B?MmJCTHVld2wxejRIanEraHVBV2EwOWRpbHNnWG9KZkZCbm9qV0xvelpFWVhn?=
>   =?utf-8?B?SkxZaGZsaWJmU3psK21PeExvRHdFZDJjVXhDWFkzSXk4Zms0SGJhU25GM2F2?=
>   =?utf-8?B?NVpJc0lEdXRPcW1uR3JmYk9ydTVaNG1MWXNQaVJ4amw1MWxCaHptdjZNajVE?=
>   =?utf-8?B?ekM4cmZ3RnJJM0UxYy9ETDRrcTZPTDh3eE8ybDg3MzBNTGZHSlpDNWl1NEZa?=
>   =?utf-8?B?d1JkYzllc1huZFFxVy9Pb2pxcFFjd3V4T1YrRFRvNDFtalN1WS8wdmRHOTM0?=
>   =?utf-8?B?TGdCYk5sMDYrUTIwYk96SXFOa29ObnpER1R2c0ovdVA1WklwWkxGUllIdVc4?=
>   =?utf-8?B?TXZNSy8zYWMwakcvTEJoOGdUdDN0ekpxZllWaGY4eFVTUmcxM3hDYXRmNS9N?=
>   =?utf-8?B?cmVJZmRrWVR6aWVWcHh2dGpYempEYTVNVVdLSi9sKytTWklYVDdHN0pzbEdN?=
>   =?utf-8?B?RnpRTEhXTTZWK2Q4bXlzMlZpWVZjOFFkU3pXZkphdkFFVmREaGE0TkJ0N3R1?=
>   =?utf-8?B?NVBKS0I5KzdkNkxEejVsZkJYeXU0MUZibThndlhMblBYUzhaVHBENGQvRWt5?=
>   =?utf-8?B?WEcrcnFNZmI5WktockRnMUpxYmR4aXY1eHRnMnhyVlZtMktpeDd2cTBXc21u?=
>   =?utf-8?B?UWpjRGJDVUVuVzhIUzVoSXZlT29WN1NqemIxL2tIdkh4UzRreVh6ZXVhWWNI?=
>   =?utf-8?B?V080OGV6ZlY2UzlGSjJlZS9EQ3ZQTjlFOTVUbUdhMk1rUHlyRENkVUZMU1VG?=
>   =?utf-8?B?NGJBL2tCbHc1elJScXE2N2M4ZDFUelZZNnVxamU4cCt2bEJRaDhOTkRQWldm?=
>   =?utf-8?B?bXF3V1JOTzNDUjNNcDArNnZGenBDOHhTM1JDU2pIOURkaFcraDJtaUhwd1JH?=
>   =?utf-8?B?TDVqLzY5NVNST1Z2VW0rc0N3eUFGUmMyZTNKbmEvWTM0aHc9PQ==?=
> X-Forefront-Antispam-Report:
> 	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
> X-OriginatorOrg: Nvidia.com
> X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:42:09.3435
>   (UTC)
> X-MS-Exchange-CrossTenant-Network-Message-Id: a9ecf29c-aab9-48ad-3ed9-08dcff31fa12
> X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
> X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
> X-MS-Exchange-CrossTenant-AuthSource:
> 	SJ5PEPF000001CC.namprd05.prod.outlook.com
> X-MS-Exchange-CrossTenant-AuthAs: Anonymous
> X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
> X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070
> 
> On Thu, 07 Nov 2024 07:46:55 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.323 release.
>> There are 349 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v4.19:
>      10 builds:	10 pass, 0 fail
>      20 boots:	20 pass, 0 fail
>      37 tests:	37 pass, 0 fail
> 
> Linux version:	4.19.323-rc2-g9e8e2cfe2de9
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Jon
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0327D1E0DE0
> 	for <linux-kernel@vger.kernel.org>; Fri,  8 Nov 2024 09:22:22 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
> ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1731057744; cv=none; b=WiqmoHIuL3BO7gObJzS/wv1tQfwljDEvsaR/bP1F4viCF+4s5YQGHjcw9RcMnE3PxtgyBRBTGe/LjystJy7mJpGWPFDBBOXKCEXbWPMW614qXVMkRpJTNS6t5BlofUR2avSI6MBpyv98qSnH/X9LrCariK++YUbmtZmHg089C4I=
> ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1731057744; c=relaxed/simple;
> 	bh=mToIfgerRVyMr4NQEYxCA3VbBeobwYg494v9mWCYPwY=;
> 	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
> 	 To:Cc:Content-Type; b=IoVcIIX0zm5A/0T5RxapyeWBDrjakVIJOcjzWxyBp2jowNQ8R6WmtU+DO/QJUD1ioiOO23nHm1qgYUYoyCOUGZXv28QbfjMXyy833flG2FVl/AsQjPt/bsyYFq1cxBxkiAWeOwZqb0UMKjMhoaM+OcHuZVPq17uqXZvXSg4zX/g=
> ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FgYh+mWB; arc=none smtp.client-ip=209.85.222.50
> Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
> Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
> Authentication-Results: smtp.subspace.kernel.org;
> 	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FgYh+mWB"
> Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-84fcb49691fso807855241.3
>          for <linux-kernel@vger.kernel.org>; Fri, 08 Nov 2024 01:22:22 -0800 (PST)
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>          d=linaro.org; s=google; t=1731057742; x=1731662542; darn=vger.kernel.org;
>          h=content-transfer-encoding:cc:to:subject:message-id:date:from
>           :in-reply-to:references:mime-version:from:to:cc:subject:date
>           :message-id:reply-to;
>          bh=tC21RYuyoliwxkob9Q53u4Vn3W7koImw4VYvvt4XkW0=;
>          b=FgYh+mWByVHbJY48icieCCd5KZfhMjdLF8Qzn3Hs/akWwNJtvyEihYnTGzkK3ZzOda
>           KKEThVIKB7qk1yBhjArAmyXcEVFcDuecfhnS2/7SUvNPw4a6x2taBDMpCYdj+8kHWChf
>           g/V/9zy4fJcbTJtuTJfoFxtl1K/Cl/FdkCP1Hue+0WWWdtXOtreR1EaZpNsxyfdStBUx
>           scVDEuUuCtH1fmYz3vgJ4PPmiO75yhhZxzi79AumfLt8HTdaZX+x2RUY6/OZQzTj6Fb5
>           8KfPXcAOJ98dRSACJ+HbAr8S3C3mI+kqcRIlfe+pfeUPrrmljvqXMdMPvDmrxHaSkjY7
>           u78Q==
> X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>          d=1e100.net; s=20230601; t=1731057742; x=1731662542;
>          h=content-transfer-encoding:cc:to:subject:message-id:date:from
>           :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
>           :subject:date:message-id:reply-to;
>          bh=tC21RYuyoliwxkob9Q53u4Vn3W7koImw4VYvvt4XkW0=;
>          b=QRcJNPVZ3tA58xMrKQb2iFc0p3S/YIDUEZ4KsxCHdk9dPiJ4D3mG5e+BKGUMulzYrr
>           s7o/82aH7H2ZfsuoB1cSCMQAgoc5Opk9rucY24S3r76G9FcYzN289mBNe6VOuZ3+pbqB
>           BiiqofXmHT8iYCP2F5wDyV341ufaEYcZ8Zb7sMxLkW56llqKRCvAqhq1zHdKVKoKhmzf
>           6vwi2foHDxkoAHYtzApsr3Q4dzRNNr/dJdFGtbSjPURm7zHs65j095mOjm/EdjiJ6std
>           6yVN1gn8ZeU/ecypsO9fA86EMtUss+aGi9QpfvzLKqbepzJ64E9NvnhkYA69xbv/Jy6z
>           uJ5g==
> X-Forwarded-Encrypted: i=1; AJvYcCXyxPX06sYL/gZ5wQ5qvGFyS17bQ0iiKduhKGM1A1aeKsymvep9i3bExp2ZRMupT4WI8xhyRVbrHRnRXNI=@vger.kernel.org
> X-Gm-Message-State: AOJu0YzGZgSNrDfXT8sTQry2pW2WRId6WFez7cUbPh9I2PJhaKPOiW5C
> 	GXdMYo2paLIYHoAXC9s41mB9NIUwncDEj6v8uDAFh+xfHAQVARh526QWVmFvcV5RddhYgCGaECB
> 	ty7WSqQqQyb0j1c6uEDlgu1abhZ1iRECasa1+FAOevjtXZNmN5yQ0ag==
> X-Google-Smtp-Source: AGHT+IESWzjH3DKo0FBP1C+K3PcYQOQo9jEzNKav6p3scDXxymE33J8RVLPJwgXLoK94kbQxLatI16b3kt5EXgeRGNo=
> X-Received: by 2002:a05:6102:945:b0:4a5:b5db:ec5e with SMTP id
>   ada2fe7eead31-4aae16714b4mr2278576137.27.1731057741902; Fri, 08 Nov 2024
>   01:22:21 -0800 (PST)
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> References: <20241107063342.964868073@linuxfoundation.org>
> In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
> From: Naresh Kamboju <naresh.kamboju@linaro.org>
> Date: Fri, 8 Nov 2024 09:22:09 +0000
> Message-ID: <CA+G9fYs8jLY9t=u+rBJ8e18LbpB10ortb6q8j0r8yRPw6-J=JA@mail.gmail.com>
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org, patches@lists.linux.dev,
> 	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
> 	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
> 	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
> 	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
> 	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
> 	broonie@kernel.org
> Content-Type: text/plain; charset="UTF-8"
> Content-Transfer-Encoding: quoted-printable
> 
> On Thu, 7 Nov 2024 at 06:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.323 release.
>> There are 349 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
> 4.19.323-rc2.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
> -rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> -----
> As other reported the following build warnings were noticed.
> 
> fs/udf/inode.c:2175:7: warning: comparison of distinct pointer types
> ('typeof (sizeof(struct allocExtDesc)) *' (aka 'unsigned int *') and
> 'typeof (&alen)' (aka 'int *')) [-Wcompare-distinct-pointer-types]
>   2175 |                 if (check_add_overflow(sizeof(struct allocExtDesc),
>        |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   2176 |
> le32_to_cpu(header->lengthAllocDescs), &alen))
>        |
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/overflow.h:61:15: note: expanded from macro 'check_add_overfl=
> ow'
>     61 |         (void) (&__a =3D=3D __d);                   \
>        |                 ~~~~ ^  ~~~
> 1 warning generated.
> 
> Links:
>   - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oVnF1lNXvgGOE2tM=
> mzH9cSJwwP/
> 
> ## Build
> * kernel: 4.19.323-rc2
> * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
> rc.git
> * git commit: 9e8e2cfe2de91cde6ce1f79021b5115f44355ce8
> * git describe: v4.19.322-350-g9e8e2cfe2de9
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
> .322-350-g9e8e2cfe2de9
> 
> ## Test Regressions (compared to v4.19.321-96-g00a71bfa9b89)
> 
> ## Metric Regressions (compared to v4.19.321-96-g00a71bfa9b89)
> 
> ## Test Fixes (compared to v4.19.321-96-g00a71bfa9b89)
> 
> ## Metric Fixes (compared to v4.19.321-96-g00a71bfa9b89)
> 
> ## Test result summary
> total: 24015, pass: 18823, fail: 189, skip: 4969, xfail: 34
> 
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 102 total, 96 passed, 6 failed
> * arm64: 27 total, 22 passed, 5 failed
> * i386: 15 total, 12 passed, 3 failed
> * mips: 20 total, 20 passed, 0 failed
> * parisc: 3 total, 0 passed, 3 failed
> * powerpc: 24 total, 24 passed, 0 failed
> * s390: 6 total, 6 passed, 0 failed
> * sh: 10 total, 10 passed, 0 failed
> * sparc: 6 total, 6 passed, 0 failed
> * x86_64: 23 total, 17 passed, 6 failed
> 
> ## Test suites summary
> * boot
> * kunit
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-crypto
> * ltp-cve
> * ltp-fcntl-locktests
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-smoke
> * ltp-syscalls
> * ltp-tracing
> * rcutorture
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A0A1F4282;
> 	Fri,  8 Nov 2024 14:45:06 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
> ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1731077107; cv=pass; b=TaLoneon5+V1RaYk5h86cTY1MIcvi0RWEIaEMzMG2sW6F5sf7jYe1V6ti5WM1N6hEq7vaUDlL3+s9o7VMQp32IRZpqwnP/LK5Z+tLG5riXHeGYYWv3RWTBz3Hps//xitJA3Ga7vWNqUt3ZhQ4650kFG4b0hqvpgvZvCLfIH32pw=
> ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1731077107; c=relaxed/simple;
> 	bh=lka3oxz9Nlj3/TqIW4WVf83DK1G9I6z7Tp1uXduOtVE=;
> 	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
> 	 In-Reply-To:Content-Type; b=eJmTHB/BJFJr/n9XM2Luue270FMMjnkIV8JWTqpE223REY2xu0KW4+lLwWsEwkVQfSX9GzPavs7GWWWhqZqnhXnusZki2MqTJ+JzGI1GKp6/UHeeTCxbFjtkKbC/x/iBfcdC7p2Id4AhEvmT24zA8HUudQYH8WF9MYapfhJgiQ8=
> ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b=lMUQverF; arc=pass smtp.client-ip=136.143.188.112
> Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
> Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
> Authentication-Results: smtp.subspace.kernel.org;
> 	dkim=pass (1024-bit key) header.d=collabora.com header.i=Usama.Anjum@collabora.com header.b="lMUQverF"
> ARC-Seal: i=1; a=rsa-sha256; t=1731077071; cv=none;
> 	d=zohomail.com; s=zohoarc;
> 	b=NviDWdui4ee3ult97bgAnFRhQgfYYEeuYBWUt7EElQnmJoBXH/e1+lokWPx/VRtkXJ75SFyawq3NhcSmvCUJIDX5lmMfZhy8WsHFMkoqRKbYQJdoZLUTxdhaCmB0KB1T7jcRYHTNQpVeh6jREmagAy0XCgSLbjeTiD3UbJCVSQE=
> ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc;
> 	t=1731077071; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To;
> 	bh=XCnH6deLfboQrpW3gEnHz4iRKn5o2NnBckl5up00v2c=;
> 	b=Y7iPUbPYXDW2xSR3wx6U4khTF7t2K8wEFy0XTA1bTW4H77a8KmLRGraxclBUWpcMLLjYX17KsMdmcGslJXL2vWBdiHweXvMziA5Tm5lyyYXWAsGVk+vQqGzpR9XUpYw8p91UqJTC+synIOwrHqEbrNc5betsHLndSlxZSIbei2o=
> ARC-Authentication-Results: i=1; mx.zohomail.com;
> 	dkim=pass  header.i=collabora.com;
> 	spf=pass  smtp.mailfrom=Usama.Anjum@collabora.com;
> 	dmarc=pass header.from=<Usama.Anjum@collabora.com>
> DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1731077071;
> 	s=zohomail; d=collabora.com; i=Usama.Anjum@collabora.com;
> 	h=Message-ID:Date:Date:MIME-Version:Cc:Cc:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
> 	bh=XCnH6deLfboQrpW3gEnHz4iRKn5o2NnBckl5up00v2c=;
> 	b=lMUQverF+if3l3Xpu5JPTP5T3QmCLe3eQ0uy6XwfTZBWjn9p3jY3Ri4RkHvoXuhd
> 	JiHp6/1dv5ga5pqudOTmCIGjqKLLtGACWslc2Q7zkgz3iVrPvGgFuvQpleANSbVzM0C
> 	WvNccnEoPOlXRvVa+fF+ejONQH7EqmhO+kYDRWmQ=
> Received: by mx.zohomail.com with SMTPS id 1731077070236399.41461573256777;
> 	Fri, 8 Nov 2024 06:44:30 -0800 (PST)
> Message-ID: <5f13a752-e553-49ad-81ab-ca1dac56cf43@collabora.com>
> Date: Fri, 8 Nov 2024 19:44:18 +0500
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> User-Agent: Mozilla Thunderbird
> Cc: Usama.Anjum@collabora.com, patches@lists.linux.dev,
>   linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
>   akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
>   patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
>   jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
>   srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
>   broonie@kernel.org
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
> References: <20241107063342.964868073@linuxfoundation.org>
> Content-Language: en-US
> From: Muhammad Usama Anjum <Usama.Anjum@collabora.com>
> In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 7bit
> X-ZohoMailClient: External
> 
> On 11/7/24 11:46 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.323 release.
>> There are 349 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
> Hi,
> 
> Please find the KernelCI report below :-
> 
> 
> OVERVIEW
> 
>      Builds: 22 passed, 0 failed
> 
>      Boot tests: 34 passed, 0 failed
> 
>      CI systems: maestro
> 
> REVISION
> 
>      Commit
>          name:
>          hash: 9e8e2cfe2de91cde6ce1f79021b5115f44355ce8
>      Checked out from
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> 
> BUILDS
> 
>      No new build failures found
> 
> BOOT TESTS
> 
>      No new boot failures found
> 
> See complete and up-to-date report at:
> https://kcidb.kernelci.org/d/revision/revision?orgId=1&var-datasource=edquppk2ghfcwc&var-git_commit_hash=9e8e2cfe2de91cde6ce1f79021b5115f44355ce8&var-patchset_hash=&var-origin=maestro&var-build_architecture=$__all&var-build_config_name=$__all&var-test_path=boot&from=now-100y&to=now&timezone=browser
> 
> Tested-by: kernelci.org bot <bot@kernelci.org>
> 
> Thanks,
> KernelCI team
> 
>  From mboxrd@z Thu Jan  1 00:00:00 1970
> Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
> 	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
> 	(No client certificate requested)
> 	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CE8149C69;
> 	Sat,  9 Nov 2024 16:05:03 +0000 (UTC)
> Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
> ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
> 	t=1731168305; cv=fail; b=b/M5U15fkp4c4wvxUz0Qpu/t0z1Z7ONddBpIsq+UHbuW8170flXa5xlY2yrMjuc8PGimHNNttazPM4xxAvR7nCkrGiiR2NsM9Uqxe6GmmZCv9e80ikA6h+A1oRjP/iJ3D2vbhE30LTPvvqSqwOgL85CiSjDsQADcy1ucs7o1uGU=
> ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
> 	s=arc-20240116; t=1731168305; c=relaxed/simple;
> 	bh=4j63zVZJi4DKBOdlMVtlpR3w9iyAeUmWr0G8tHoQrt4=;
> 	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
> 	 Content-Type:MIME-Version; b=Ld9nbRlc6LVWde6eSnCHX733q9wOCWwGezQjIhl20Ic0ZpC5uegXHLXgE5Tmg03NccgeoKCjrw7KoooUMmYyRiq7O5Qj5bNxC7oiqHi8sZMqaIZwjw05dGAUab+nsSFjLCRNjjwFlSVUZlOna4b/tCUM1wvDd/7K3jsHK39ycO0=
> ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C7T278Wb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dLgvGCUY; arc=fail smtp.client-ip=205.220.177.32
> Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
> Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
> Authentication-Results: smtp.subspace.kernel.org;
> 	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C7T278Wb";
> 	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dLgvGCUY"
> Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
> 	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9Drmea014620;
> 	Sat, 9 Nov 2024 16:04:28 GMT
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
> 	:content-transfer-encoding:content-type:date:from:in-reply-to
> 	:message-id:mime-version:references:subject:to; s=
> 	corp-2023-11-20; bh=iuUPy1t/yVvizspiUuXZWaW951/PM2dpGIWh2ou8iqM=; b=
> 	C7T278WbZWN91TWp8vXOXa+5unZ0Dm6yo5Shr3o6qu0yTUgtqAT3rlrRzMO0X21z
> 	9+Q3ihaw9XVDonSkYGrPwniW4DsufsePcL14hxwJfSVCOiSZP45SZmQ2FJ5u8lUL
> 	Wl09pHUkDxYDxmI9XaV44UPF9jMlULBX58OMhIcQGJ+kNLqEuma9DK9hEGVjdnRp
> 	YXTWweTe7NlCxqb2GcomMFmPZAxfgoY5wB/Te7qUN5IgwbRBjZ3HndJ4/Qs8Ilx0
> 	iVZNwvyzVuGGY+bdrIVzf0+GWRpT5f/8B/o3D3aYVFWq5dEHMUpLP3DxZw4B5/HY
> 	vldHAroLITUFwbDTIeR3Sg==
> Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
> 	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k20bwh-1
> 	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
> 	Sat, 09 Nov 2024 16:04:28 +0000 (GMT)
> Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
> 	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A9F3tS4034312;
> 	Sat, 9 Nov 2024 16:04:27 GMT
> Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
> 	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65mqps-1
> 	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
> 	Sat, 09 Nov 2024 16:04:27 +0000
> ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
>   b=aPdOOkhXl7gicAEHYrUpLrKw/4kf5+CM1W6TTrzQjPgjQHIbJEWQ7no+owHVXLowE1I7STdGIrtuPKnFQo1t0EjBCV4e1NPey5W+WFUOqKdnXXfkvh2hy+SYh2P1go7QDWcDRiDm0Lo5HKQBCLLC1PAZDigxChLpHJaARj8kQztCZYT+ltVLmZ2/z1xI3zxn/gLEUAJA1abjaal6vGWSA6of/TBjJoMX6OuoMk2TzCCICRyYgFQiq/HTZPz748YHNHV6LNBslod3kyKKmHnQtRq7RUvOuSI0VyvI4QCnO1wEs8rT8YRuN8yp0pQmNQYANKrekM70ef6NTTGLFwF23Q==
> ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
>   s=arcselector10001;
>   h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
>   bh=iuUPy1t/yVvizspiUuXZWaW951/PM2dpGIWh2ou8iqM=;
>   b=ttwUGXtHO+3P/NCHNxpOibjq1LmgH792L7oghV8FxqrkCqx1UqordiX+eEpwK2lBr99vyaCqMpgi/N7IlyExVyLUMKIxN7pBUN40jwZwVwVdlrz01NYjXa13AonVkPPlQs+dnsd+VjMQh+BqeX0EGCeWcOCrgaA3CH3ItxwJbUzKnS1eVIvRpb+kzbzgqoqckJIapZzTnOH3EguZSk9nNJXCTmsnzVjwU8Mv2RYN8LsAKVU69yY2z0cezjX5JAHs20Dfn02jqDkTvKgisPGsX4hzrdSW1w+WObmOEKzeAL/hSzWKh/8cCB+Yjc9bZLzUyXpz0rEvR9Q5heaDVJaMpA==
> ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
>   smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
>   dkim=pass header.d=oracle.com; arc=none
> DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
>   d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
>   h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
>   bh=iuUPy1t/yVvizspiUuXZWaW951/PM2dpGIWh2ou8iqM=;
>   b=dLgvGCUYQ1zgUKI1RKpFRKGy4Hd0uYl51yXplg/fYuWbEnvY1ZJzsfYBomnEuVHWiu0eqhk3+brL0U8x9Avci271ojwmC8E4qdpnYry/c4K3yXZE8UB9F9SPa6L6SSOmlRgN4DhtudIZseQ0SBQlKtOzjwKeJ/lAecP8Eu/gIUc=
> Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
>   by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
>   Microsoft SMTP Server (version=TLS1_2,
>   cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Sat, 9 Nov
>   2024 16:04:25 +0000
> Received: from DM4PR10MB6886.namprd10.prod.outlook.com
>   ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
>   ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8137.022; Sat, 9 Nov 2024
>   16:04:25 +0000
> Message-ID: <e0e8be47-470b-4e13-a152-be795aa92907@oracle.com>
> Date: Sat, 9 Nov 2024 21:34:11 +0530
> User-Agent: Mozilla Thunderbird
> Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
> Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
>          torvalds@linux-foundation.org, akpm@linux-foundation.org,
>          linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
>          lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
>          f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
>          rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com,
>          broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
>          Darren Kenny <darren.kenny@oracle.com>
> References: <20241107063342.964868073@linuxfoundation.org>
> Content-Language: en-US
> From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
> Content-Type: text/plain; charset=UTF-8; format=flowed
> Content-Transfer-Encoding: 7bit
> X-ClientProxiedBy: SG2PR06CA0225.apcprd06.prod.outlook.com
>   (2603:1096:4:68::33) To DM4PR10MB6886.namprd10.prod.outlook.com
>   (2603:10b6:8:102::10)
> Precedence: bulk
> X-Mailing-List: linux-kernel@vger.kernel.org
> List-Id: <linux-kernel.vger.kernel.org>
> List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
> List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
> MIME-Version: 1.0
> X-MS-PublicTrafficType: Email
> X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|BLAPR10MB5042:EE_
> X-MS-Office365-Filtering-Correlation-Id: 99ec7dcb-d863-41e4-9cda-08dd00d82e65
> X-MS-Exchange-SenderADCheck: 1
> X-MS-Exchange-AntiSpam-Relay: 0
> X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
> X-Microsoft-Antispam-Message-Info:
> 	=?utf-8?B?ZnBkcW04aFcweXoxMU1wMjRpT01URzhaNGVFTUlFSkhZNW5RUy9zVGovVUU4?=
>   =?utf-8?B?TmxOQ0VqZGljOG5sYjR3YXFwd0lxRlBmWjZrLzA5NFlYZ3luYlVXUXd6WDla?=
>   =?utf-8?B?d3RHM0Q4RGI3ZHNCNVlxSTNoSFFZYjIwYTl0QTVKZ1ZsNjg2QkFmcWlyd1FT?=
>   =?utf-8?B?OVQ0RFE3MlJrakpQOHpMODRmcXVqNDRhVDZ4bkk3SGorZGpaZDhPemFaaldn?=
>   =?utf-8?B?OWlBditVdDNqNEdqeWYzeERLc3JJTmJqYzVtSExkdUpYbFZTQUxWQkFYdCt0?=
>   =?utf-8?B?ZEZXdytrTHFZSVJ1WmJwd0k3cGh1VzRsZFpja3JlOW5xazUwRER6UXV6TnBy?=
>   =?utf-8?B?MmdlYjRHNnFZUFBKMUkrN2RYdnh2T1VJSEdwd1pjdDNtUXRZeUVsNElzK051?=
>   =?utf-8?B?SDFaR2JqTHRxR2NSL0FBcGNxK2RDVnRDUHJjQVhUdSsvenhCZGdjM1pFOGln?=
>   =?utf-8?B?by8yb3FlNWhySDA2a0hsc1d1QlByTjU0WjIyQS9Jb2w5VlRrdkMzem5kclBj?=
>   =?utf-8?B?b2RMSEYwbG8xQzUwR3gzeXgzbVFFMWRHYWpWRG1GSUhJc01nalFKWlh4aDNy?=
>   =?utf-8?B?V0ZxYWJLcXI4Y2tCQVF3ZVlOSXNDUlRLVU4xSDJpVm1tQ0FBZkZOd3YvZkhM?=
>   =?utf-8?B?Z0dTbGdsUmtLZEhxczJpckNza3d3eVQ0czlFeDM1VG15cDhxMkpqcU1uSENP?=
>   =?utf-8?B?WmdsYUFCK2pQMHZla3MyM2lQeFA0clBIMnhSemVoMkIrMkRMaWRjR21uTTNF?=
>   =?utf-8?B?UG5ySnZzVEVaTHFpc2tFMjg5dnRKc0sxY2ZxdCtXZkJleVlkMEJTMzliOElJ?=
>   =?utf-8?B?dERNTWVuc2ZEZWExWlh4ZWhCaWEzU3EwTWhwZzcwNG83d0RIV3M0NU9zUVp5?=
>   =?utf-8?B?YUZ0MHdLQ2FJek1LN0RrKytIVHVPQVhEcENWOE5acldnNkltWUpmSkVWYnF3?=
>   =?utf-8?B?RjBIME5CektvSnYvWHpSNnJmeDFOanRORnVIUXdsVXR2OXMzSEdBQzZQYzEw?=
>   =?utf-8?B?THp3SzQxL3ZHZ05Fb0R2TERxNXI3OEVwWjZSTDhmOGl1NUVHbTNGbDdKNmIy?=
>   =?utf-8?B?YzBxZnVKcGJzRTB0dEJNbTBrWmdBclVXMDc1bXUzZlExK0hnbTYxVVBRY3Uw?=
>   =?utf-8?B?VEd3MXJDS2hIUjJjVC9paWtrUEhFWktZOWFQMkFqWmllTEFsME9OeXlnYzVk?=
>   =?utf-8?B?aXpSRFRCd3h1clp1NlBkZWN4K2NnZzVVMWFpRXdkbUNBWnBjOTk2SWoxQ1V3?=
>   =?utf-8?B?blRncVNOYXZxRUZ5Z3BndExKSmpKSEVjMCs0OURrM3pFelJUL0JMWXNLWmtr?=
>   =?utf-8?B?dzZOU0dVejVCMUJLMVdBZUhMSk93Q1B1ZHlmS1Z5dUwvRXhQZzBJcjA5UVBR?=
>   =?utf-8?B?S0hhaHdISHVHUVJrK0VzcFdNeFFwRWtRejg1Y3o1ZERBd0puOUhvNXZRUFIw?=
>   =?utf-8?B?OGhkdUphWlhyaGlyMC9pYjlJd2UxSjBpN3VWOEZnbTZWU3pRWkVYbnI5Vmlm?=
>   =?utf-8?B?VHRRNGdwRU9PdzNaZm9KelViU2lMNmF5NWpWWXUrYTVqTlNHZEpOclFjWTlX?=
>   =?utf-8?B?dndiUlpJYUdzRy84OVIwTnk0cmZSY3lUYm5nTVVjbE9RQ29tcGNaM3FEOHVO?=
>   =?utf-8?B?SGFCZlUrdnRscGUwUGg1c0F3a253Z2JYYi9jYlJtMUdOV05BNkZqbEFaZzdD?=
>   =?utf-8?B?ZHpobnRGUm42bkN0QThSVTIrL0VNLzZacXZ5Qy96MGViZ0RoMWVST1RGMFp1?=
>   =?utf-8?Q?xjeUlOyogEVZ1EQ8rDV0JZdY/VS8ysuT/irZuDX?=
> X-Forefront-Antispam-Report:
> 	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
> X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
> X-MS-Exchange-AntiSpam-MessageData-0:
> 	=?utf-8?B?RjVmM0hhTXRUeUpsQzZLZjlRMFBwQlZKaHQ1UjdTckJyU1VWQitGQzVPWG5C?=
>   =?utf-8?B?OTNEZUl3WjRYb1lqaVlsQkszZ3J2VmdFSXdFRUlKMnNNOWVPYi9NUk1rTzRX?=
>   =?utf-8?B?TWVPUFZ3K2x0K2ZSbEhvZHBQdjJwZ0RtUzVvVWZZSHp2Z0tmSGNMekVvVUpw?=
>   =?utf-8?B?a3hwaTY2a1cvQjFTQUpKMG43VUpVZkxpczNhYUs0ZE5lb0t0bGd5WEp6Sk5V?=
>   =?utf-8?B?Q1pKWkVPQ055T1NtdFZzbi9TK0drZ21OOTFSUmhISzl6dVcvcUFFWWpSWmI2?=
>   =?utf-8?B?WWhOMzNwWi9PUTl6VkFIcVBMcGVvODB6T1dwSjY2ZTI2Ny9xS2k1OFZSMjd5?=
>   =?utf-8?B?TnRwc1pFTVZ3bDJXUm5pa04wb2xFNHo5VjBrbC91aDV0RkVXcWk1bGVjbk5o?=
>   =?utf-8?B?NDlManJkME5YeTgxNDR5d01LOHV3T2c1LzJqank5NlNtNWxqTjBEUGFCbm5v?=
>   =?utf-8?B?MldaQWloNXVZYUt0ZE1Hc1I1SkVITFdnSXNQdDZKTk9OMWpqbVgzMG4rKzhl?=
>   =?utf-8?B?bWlnVzg1ZFI3Sys0Q1J3MUNBK0d3czl4eDM2RUJObU5zN0IvTHZaNmNwaUNI?=
>   =?utf-8?B?ZmdIbDNKRjJCVW1NWFBEVDF1bVQ1OTJSZFV5LzBjTjd3czlRajRUTFo4NU9z?=
>   =?utf-8?B?SUlqSnJlbStDNnpHYWZiRm9ONitjK1dYNmhFVzRLdEJZODlKbVRZOVpXUDlR?=
>   =?utf-8?B?dmZUcFd1Q1dNWkFYRHM3cFk2SzNWNmxjNU1nSktTZ2R1Vys1WVkrRXQ2RENs?=
>   =?utf-8?B?L2JrVzEyNm9WMi9UUnNSblN6b2JEdThrbkEyekJOM1lFUS81M0p3cVp6dnNF?=
>   =?utf-8?B?RkFFUDN2ZmtmMlVrcjBBTjVoeXRqNmRla2R2ZmtEbi9yS0FSSmJIUHJUYVpM?=
>   =?utf-8?B?YjRyTGt2THA0UGt6VGZQWHBucWl0bnRTYTBPY2NEaWJnd29ZUGtZOWVjTEZO?=
>   =?utf-8?B?ejJ0amF2MjMyVnhEeXBPOGwySGZpcng5SExFWjJOcW9NckMyZyswTTZYRWlM?=
>   =?utf-8?B?MEVGWVhIUHdkZVpnd2tldUFEc3VUY3dYZUIwRCtSalgvcGV1MGVaNFRla0hJ?=
>   =?utf-8?B?NGpaaytoL09oMFNTKzg3cTN2M3ZyOERTQ05XdDFpUkZxc0I3bVFYYitmZVJQ?=
>   =?utf-8?B?cURLMHBnOFhrTXcxdUZVSmQwQ0hoemJqVE8wYTNENTJiK285T3VzMWs4NVJz?=
>   =?utf-8?B?VExHWERFVnJIMUp4cVlKaUdjalozTDBjY3BrS1h2NE1oL00vM2kvdkRaenJP?=
>   =?utf-8?B?NmVmQjFDMkdHTEVuWmlIT3BiVHk3VHBaTUYxUWJ5UHhUcm8rWUdNd0o2QlBm?=
>   =?utf-8?B?eGZkVjVXcXhYb3BFMWtBMVZaTXM0NFZUWmZqUUQvakNtMVFQbkt0OHh6NjhV?=
>   =?utf-8?B?alFDWVhRMTFrN2QwczZEUHlNSzBGc0pCN2RXUVgvMmNGNTQzaTFMSi9NMkpL?=
>   =?utf-8?B?YnV4VEdjd2d4azh4eVhsSjZUdEo3ZVphL3lLalVMdjMvUGlmbTR0UXVvSXlm?=
>   =?utf-8?B?cDl2WlU1dTBZV3pubTUrbVNQdXFmODl6UFNzSldFWHJBUDFtM09YYkJrcFJU?=
>   =?utf-8?B?UHJnT2FUdCt3WVZrOEhVQUhCd0k3THFnbXlneTArTXNGeHBSaTMxcFRZeHJP?=
>   =?utf-8?B?SGtlMzNFWUVyT1ZPdGQzdzg0V3VvLyt6akl4cHV4aEZvUG1kTDJlRlpCZkdT?=
>   =?utf-8?B?K29rNGxSZmYvcmRib3JZeDRyenJKbVJGbzlTVnFmdEE3aWtXaUs3WEdDVHpB?=
>   =?utf-8?B?U3M4ZlJsdktQTUtxTFp0ckhNMnVVeDlGYXcyRzRVQ2pXVVNGNWFZWmIzVC94?=
>   =?utf-8?B?Y3daUE5pZEVkd2VUenBaaTFQelF0VTM4RnZpdlNobnU0cjdKcWczUlNFdlh5?=
>   =?utf-8?B?WjNLSFRRT2VVd2VOVmRxbHg3NnVDN0lVRFlpSnM4TEhkQTFlVFdJQjNxaExU?=
>   =?utf-8?B?QjRxTHRLWlZhY1Y4bkM4QUgxNlNOQUlBcFlVNkVoZElQNFN1M2R5cTdqQnd5?=
>   =?utf-8?B?TXRCR2IwQzBGUWhJWkQzajVRMlRqMWRCWitFelZuOEVEWHYvMmVyek1OaXRl?=
>   =?utf-8?B?cm52QUxKT3p5NnF4SkpHYkVINjZkSnI5VkdGbjdMUzRDY1huNy9qVjhKakVq?=
>   =?utf-8?B?dTMwckJEcytacjlOZVNpNDhtSnowcWxUTE1wbWxYTVlWUFpnTytZaWIxRTdy?=
>   =?utf-8?Q?X4AzP/Lh7Ca10Ra2QtpAyXE=3D?=
> X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
> X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
> 	7RqsaGL1Jt+GqdW+0YKBm7OCxC4h/WceRG7pa/pKwzamfV3vEl/VLnyhyLxKz0MTQb0X2qdZHXHt1mxcSNAzleO4y6VVlH+yI7tqGToWaIjMEq4cWGQ1jhRF//8vyEjFHMvSEnjVik5JfnwS9fKn19IezECmp2jDCi+hCwI36yIuOwtcnPYTo8RuXaKMBa+UBkUUGhiAYRAhEADliPSyCbAZMpYqed1nk9xd584/rXFYM+PS0wZ2t0a28qgsgt3aO1HEKVm1HDMwi4SbJgOdcFpsgwA2O/hYtVBaLQXI4qPiZhXxS/MATpdDW6bD8mDp972ZeHwC7ijenLyibC3s7aqXwXqjrPWs8eugEdVqsbF21yI9gqEtNQz+M7M2D6LK+8kg3q0A9yjxsvC3B8p+OuPm4Q2vZ2+X6MnpA5I0WhsTFWEEdu7CzMONvW0U5f3XQI842bD/joZYtCaCSc8432NwuAf72rb6nxLwMKhoupNRS/z4+yCCpWJ2UFb3l0Anslht5e6Umw8CuO+iSh3uwuEJe7g+MXYbFGIfXC0x0P5Cb5yQiXjNNQnuq0ihRaTvSpoyf4Yh+3qC/3MlF5V8EHRQYfmjzgS8JDs5Kf/YyZM=
> X-OriginatorOrg: oracle.com
> X-MS-Exchange-CrossTenant-Network-Message-Id: 99ec7dcb-d863-41e4-9cda-08dd00d82e65
> X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
> X-MS-Exchange-CrossTenant-AuthAs: Internal
> X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 16:04:25.1638
>   (UTC)
> X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
> X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
> X-MS-Exchange-CrossTenant-MailboxType: HOSTED
> X-MS-Exchange-CrossTenant-UserPrincipalName: 4A6CTWA84iQJs2DMHbjL4MumPACvIJmdMiVyTke5n0bhA5XZ4U97AFOOKKjfeb9UgEe5Hu0HS2PbGzS9nuWcesxf/RfGOy7HKANv+8gT3tJLLJuX5vQObRm/MsU9Dqzr
> X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
> X-Proofpoint-Virus-Version: vendor=baseguard
>   engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
>   definitions=2024-11-09_15,2024-11-08_01,2024-09-30_01
> X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
>   adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
>   mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
>   engine=8.12.0-2409260000 definitions=main-2411090138
> X-Proofpoint-ORIG-GUID: Vbwy3Qz7gyCLRBrvnJcKD6N5aToF0J2b
> X-Proofpoint-GUID: Vbwy3Qz7gyCLRBrvnJcKD6N5aToF0J2b
> 
> Hi Greg,
> 
> On 07/11/24 12:16, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.323 release.
>> There are 349 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
>> Anything received after that time might be too late.
> 
> No problems seen on x86_64 and aarch64 with our testing.
> 
> Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> 
> Thanks,
> Harshit
> 
> 

