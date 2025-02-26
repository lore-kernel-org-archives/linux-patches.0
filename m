Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E468426BDAF
	for <patches@lists.linux.dev>; Wed, 26 Feb 2025 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740563577; cv=none; b=ZOx2X2giLJImeiiXdckwXtOUwYQtojVXfMWT7rg9vs3i8iCgNZauVyrIZy+9/0dIuKUCk/DeY5Ab0x9k2k16YHTw09l0CSiNHNpIQIG8D2i+BzX3YNz1PbiIpi4yaReI0uiTIUPyWczzYE/ImOPXAk4sm6Kc/jOI6ANILphCBsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740563577; c=relaxed/simple;
	bh=1VN+cDj9AVE7/K0PhmkdZA3pRolPFmf+VkjdGvDNBSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GpVhR48qhLY/MMMYMoGBuPgJQTpp6ql7/axwdrDc8WzmVIHpCL+j1vr6n7TESymhx56g/jtj3XA8t+tLkMxSmwt4CLbK50OnZHt4OOIRprQnDOzgAiR4D4OiPQ6sPCkA76wAQb3TUD9ZdqnhvdsMLZ4y5OiNqc8h94O5cCt+V54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZHmUrg2; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZHmUrg2"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fc4418c0e1so1067232a91.1
        for <patches@lists.linux.dev>; Wed, 26 Feb 2025 01:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740563574; x=1741168374; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xu4L1uFBtB/CS57KwfYhvx54aJlhU2T50skywTrv9bQ=;
        b=IZHmUrg269SyqbsD0q5ujn08gEu/rM/lqXSm1OVOBBnsrDl4tzlvWQe8gvLCeGjr1z
         wdLW2TIAG7DJGKZwx7uSkfFC+Lr5D46LmWERpg61ihAKnR5fOur8yvo+1lgKE9fcPSSP
         1Dx8CmJ5Fq8WqcrOY4owv8Ga6a6rbsttMS0Ocs2YSXqXUbUBlZm3HomP7bKRCagQNjbh
         +/Zlur9UgV0nd0RsYkcYAUwGP3LIdM3pmQ9PlZBOo/NnVIeKAy7hFYX414A3Kw4hqbWp
         /aocRQfjIrUBURE6hG2y5ZFwNS0zP2A2gP118obmJtgcOy5P1YIs+PG1/KRkyTy3Xepm
         I5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740563574; x=1741168374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xu4L1uFBtB/CS57KwfYhvx54aJlhU2T50skywTrv9bQ=;
        b=XkTO6w/fjXD3ed7gCo4S3hqTXFbJRsaxI73xdHhnMF6+wAiBis9AOOfbmHMKbGSieV
         GS+vB/Jm2h06fz/6Ew4rTcOJZjSTaRpMFiRiGbx8TBNFgqgnLb4yQe9r/RPuYVPnvdYq
         qy313t8uApIsTafZ5a1ClurasozAiX7z2J4IWxE0GHZUnwwMqPJtU5qZMxW8pBXb3D2O
         7/jHNBP3gHmAgZnDQnNKnwvHCT6QbQ3V3sX1/ZiAAbXF3ZY8Z7jNczDRUmB2hsl8WwWc
         E4mZ0cH5it7zUG3e7prjn9gw2ZhilFXNRG0dN3XkpMOk2jiLIEDVfRMlEvE1KwB09Yvm
         HXcA==
X-Forwarded-Encrypted: i=1; AJvYcCVGFA67l3B+EsJol9pGJtvAXhduWiAC0LVVOeFrI9iXL6dY7Df56DCmPgS+UVmX5RDaSm8v8gaA@lists.linux.dev
X-Gm-Message-State: AOJu0YxQhdBqnCPcfAFu6zeTgqQPkL2zAg5WeutwfuGWXTMnIRbGq0Ia
	AuoOEFDFax2F1yBKlhQ5hKOIOzIKEDHuBKgd/G2EmPTfBmTIYh7ZSv+DxltHT7aLuY10PwHDZDg
	MySv+/1EDU+ccFzEyj+fw1zZpk1M=
X-Gm-Gg: ASbGncuK44n7FBvyBlRrATP9z/WYl2ez/QZiDGUTryl+Hw3vVVCAte3XbTCcKmg2g71
	MxILf2omkYb5yzUaqrZ/F9RVICmzVb4w32Xhj4Cc7P5Buni7XqvfpiY0lyQ5vWDj3zQ/TXdGkhk
	0yyypiIQIe95Ya1cG5ujqpOA==
X-Google-Smtp-Source: AGHT+IEF+SBEUuPY36tWbwVDm1Yu7M4Z1dy+R+gXmT602atEQ5psK9nNShhS2VwrhxT8L0HOGhQ25ME8er4xW9SMMow=
X-Received: by 2002:a17:90b:56cd:b0:2fa:22a2:26a3 with SMTP id
 98e67ed59e1d1-2fce7ae91d9mr34516810a91.6.1740563573932; Wed, 26 Feb 2025
 01:52:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250225064750.953124108@linuxfoundation.org>
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 26 Feb 2025 10:52:41 +0100
X-Gm-Features: AWEUYZlFqTU1yDSXlvYyDkiw6p2xlUGeQmzaBxbCRS2Y8CB-KQQwdM7IvShWviY
Message-ID: <CADo9pHiZNzhT2iQtgMjOrwWVA3OvJVdj9cJseNFReGDRuJq4kA@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
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

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den tis 25 feb. 2025 kl 08:03 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
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
>     Linux 6.13.5-rc2
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu: bump version for RV/PCO compute fix
>
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/gfx9: manually control gfxoff for CS on RV
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: pse-pd: Fix deadlock in current limit functions
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Fix using ret variable in tracing_set_tracer()
>
> Arnd Bergmann <arnd@arndb.de>
>     drm: select DRM_KMS_HELPER from DRM_GEM_SHMEM_HELPER
>
> Steven Rostedt <rostedt@goodmis.org>
>     ftrace: Do not add duplicate entries in subops manager ops
>
> Steven Rostedt <rostedt@goodmis.org>
>     ftrace: Fix accounting of adding subops to a manager ops
>
> Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>     ftrace: Correct preemption accounting for function tracing.
>
> Komal Bajaj <quic_kbajaj@quicinc.com>
>     EDAC/qcom: Correct interrupt enable register configuration
>
> Haoxiang Li <haoxiang_li2024@163.com>
>     smb: client: Add check for next_buffer in receive_encrypted_standard(=
)
>
> Marc Zyngier <maz@kernel.org>
>     irqchip/gic-v3: Fix rk3399 workaround when secure interrupts are enab=
led
>
> Kan Liang <kan.liang@linux.intel.com>
>     perf/x86/intel: Fix event constraints for LNC
>
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>     mtd: rawnand: cadence: fix incorrect device in dma_unmap_single
>
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>     mtd: rawnand: cadence: use dma_map_resource for sdma address
>
> Niravkumar L Rabara <niravkumar.l.rabara@intel.com>
>     mtd: rawnand: cadence: fix error code in cadence_nand_init()
>
> Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
>     mtd: spi-nor: sst: Fix SST write failure
>
> Ricardo Ca=C3=B1uelo Navarro <rcn@igalia.com>
>     mm,madvise,hugetlb: check for 0-length range after end address adjust=
ment
>
> Christian Brauner <brauner@kernel.org>
>     acct: block access to kernel internal filesystems
>
> Christian Brauner <brauner@kernel.org>
>     acct: perform last write from workqueue
>
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: pcm: Clear the susbstream pointer to NULL on close
>
> John Veness <john-linux@pelago.org.uk>
>     ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED
>
> Wentao Liang <vulab@iscas.ac.cn>
>     ALSA: hda: Add error check for snd_ctl_rename_id() in snd_hda_create_=
dig_out_ctls()
>
> Nikita Zhandarovich <n.zhandarovich@fintech.ru>
>     ASoC: fsl_micfil: Enable default case in micfil_set_quality()
>
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: stream-ipc: Check for cstream nullity in sof_ipc_msg_data(=
)
>
> Joshua Washington <joshwash@google.com>
>     gve: set xdp redirect target only when it is available
>
> Haoxiang Li <haoxiang_li2024@163.com>
>     nfp: bpf: Add check for nfp_app_ctrl_msg_alloc()
>
> Hyeonggon Yoo <42.hyeyoo@gmail.com>
>     mm/zswap: fix inconsistency when zswap_store_page() fails
>
> Paulo Alcantara <pc@manguebit.com>
>     smb: client: fix chmod(2) regression with ATTR_READONLY
>
> Pavel Begunkov <asml.silence@gmail.com>
>     lib/iov_iter: fix import_iovec_ubuf iovec management
>
> Darrick J. Wong <djwong@kernel.org>
>     xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=3Dn
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/boot: Fix ESSA detection
>
> Haoxiang Li <haoxiang_li2024@163.com>
>     soc: loongson: loongson2_guts: Add check for devm_kstrdup()
>
> Johan Korsnes <johan.korsnes@remarkable.no>
>     gpio: vf610: add locking to gpio direction functions
>
> Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
>     arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck
>
> Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
>     arm64: dts: rockchip: Move uart5 pin configuration to px30 ringneck S=
oM
>
> Alexander Shiyan <eagle.alexander923@gmail.com>
>     arm64: dts: rockchip: Fix broken tsadc pinctrl names for rk3588
>
> Tianling Shen <cnsztl@gmail.com>
>     arm64: dts: rockchip: change eth phy mode to rgmii-id for orangepi r1=
 plus lts
>
> David Hildenbrand <david@redhat.com>
>     mm/migrate_device: don't add folio to be freed to LRU in migrate_devi=
ce_finalize()
>
> Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
>     drop_monitor: fix incorrect initialization order
>
> Sumit Garg <sumit.garg@linaro.org>
>     tee: optee: Fix supplicant wait loop
>
> Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>     gpiolib: protect gpio_chip with SRCU in array_info paths in multi get=
/set
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring: prevent opcode speculation
>
> Pavel Begunkov <asml.silence@gmail.com>
>     io_uring/rw: forbid multishot async reads
>
> Imre Deak <imre.deak@intel.com>
>     drm/i915/dsi: Use TRANS_DDI_FUNC_CTL's own port width macro
>
> Krzysztof Karas <krzysztof.karas@intel.com>
>     drm/i915/gt: Use spin_lock_irqsave() in interruptible context
>
> Imre Deak <imre.deak@intel.com>
>     drm/i915/ddi: Fix HDMI port width programming in DDI_BUF_CTL
>
> Imre Deak <imre.deak@intel.com>
>     drm/i915/dp: Fix error handling during 128b/132b link training
>
> Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>     drm/i915: Make sure all planes in use by the joiner have their crtc i=
ncluded
>
> Jessica Zhang <quic_jesszhan@quicinc.com>
>     drm/msm/dpu: Disable dither in phys encoder cleanup
>
> Abhinav Kumar <quic_abhinavk@quicinc.com>
>     drm/msm/dp: account for widebus and yuv420 during mode validation
>
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>     drm: panel: jd9365da-h3: fix reset signal polarity
>
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>     sched: Compact RSEQ concurrency IDs with reduced threads and affinity
>
> Artur Rojek <contact@artur-rojek.eu>
>     irqchip/jcore-aic, clocksource/drivers/jcore: Fix jcore-pit interrupt=
 request
>
> Aaron Kling <webgeek1234@gmail.com>
>     drm/nouveau/pmu: Fix gp10b firmware guard
>
> Yan Zhai <yan@cloudflare.com>
>     bpf: skip non exist keys in generic_map_lookup_batch
>
> Caleb Sander Mateos <csander@purestorage.com>
>     nvme/ioctl: add missing space in err message
>
> Caleb Sander Mateos <csander@purestorage.com>
>     nvme-tcp: fix connect failure on receiving partial ICResp PDU
>
> Damien Le Moal <dlemoal@kernel.org>
>     nvme: tcp: Fix compilation warning with W=3D1
>
> Hannes Reinecke <hare@kernel.org>
>     nvmet: Fix crash when a namespace is disabled
>
> Lucas De Marchi <lucas.demarchi@intel.com>
>     drm/xe: Fix error handling in xe_irq_install()
>
> Ilia Levi <ilia.levi@intel.com>
>     drm/xe/irq: Separate MSI and MSI-X flows
>
> Ilia Levi <ilia.levi@intel.com>
>     drm/xe: Make irq enabled flag atomic
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     drm/msm/dsi/phy: Do not overwite PHY_CMN_CLK_CFG1 when choosing bitcl=
k source
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     drm/msm/dsi/phy: Protect PHY_CMN_CLK_CFG1 against clock driver
>
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>     drm/msm/dsi/phy: Protect PHY_CMN_CLK_CFG0 updated from driver side
>
> Marijn Suijten <marijn.suijten@somainline.org>
>     drm/msm/dpu: Don't leak bits_per_component into random DSC_ENC fields
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: enable DPU_WB_INPUT_CTRL for DPU 5.x
>
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>     drm/msm/dpu: skip watchdog timer programming through TOP on >=3D SM84=
50
>
> Rob Clark <robdclark@chromium.org>
>     drm/msm: Avoid rounding up to one jiffy
>
> David Hildenbrand <david@redhat.com>
>     nouveau/svm: fix missing folio unlock + put after make_device_exclusi=
ve_range()
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     platform: cznic: CZNIC_PLATFORMS should depend on ARCH_MVEBU
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     firmware: imx: IMX_SCMI_MISC_DRV should depend on ARCH_MXC
>
> Bart Van Assche <bvanassche@acm.org>
>     md/raid*: Fix the set_queue_limits implementations
>
> Peng Fan <peng.fan@nxp.com>
>     firmware: arm_scmi: imx: Correct tx size of scmi_imx_misc_ctrl_set
>
> Patrick Wildt <patrick@blueri.se>
>     arm64: dts: rockchip: adjust SMMU interrupt type on rk3588
>
> Alan Maguire <alan.maguire@oracle.com>
>     bpf: Fix softlockup in arena_map_free on 64k page kernel
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     net: Add rx_skb of kfree_skb to raw_tp_null_args[].
>
> Chris Morgan <macromorgan@hotmail.com>
>     power: supply: axp20x_battery: Fix fault handling for AXP717
>
> Andrey Vatoropin <a.vatoropin@crpt.ru>
>     power: supply: da9150-fg: fix potential overflow
>
> Andy Yan <andyshrk@163.com>
>     arm64: dts: rockchip: Fix lcdpwr_en pin for Cool Pi GenBook
>
> Heiko Stuebner <heiko@sntech.de>
>     arm64: dts: rockchip: fix fixed-regulator renames on rk3399-gru devic=
es
>
> Abel Wu <wuyun.abel@bytedance.com>
>     bpf: Fix deadlock when freeing cgroup storage
>
> Jiayuan Chen <mrpre@163.com>
>     bpf: Disable non stream socket for strparser
>
> Andrii Nakryiko <andrii@kernel.org>
>     bpf: avoid holding freeze_mutex during mmap operation
>
> Andrii Nakryiko <andrii@kernel.org>
>     bpf: unify VM_WRITE vs VM_MAYWRITE use in BPF map mmaping logic
>
> Shigeru Yoshida <syoshida@redhat.com>
>     bpf, test_run: Fix use-after-free issue in eth_skb_pkt_type()
>
> Gary Guo <gary@garyguo.net>
>     rust: cleanup unnecessary casts
>
> Gary Guo <gary@garyguo.net>
>     rust: map `long` to `isize` and `char` to `u8`
>
> Miguel Ojeda <ojeda@kernel.org>
>     rust: finish using custom FFI integer types
>
> Paolo Abeni <pabeni@redhat.com>
>     net: allow small head cache usage with large MAX_SKB_FRAGS values
>
> Sabrina Dubroca <sd@queasysnail.net>
>     tcp: drop secpath at the same time as we currently drop dst
>
> Nick Hu <nick.hu@sifive.com>
>     net: axienet: Set mac_managed_pm
>
> Breno Leitao <leitao@debian.org>
>     arp: switch to dev_getbyhwaddr() in arp_req_set_public()
>
> Breno Leitao <leitao@debian.org>
>     net: Add non-RCU dev_getbyhwaddr() helper
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     flow_dissector: Fix port range key handling in BPF conversion
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     flow_dissector: Fix handling of mixed port and port-range keys
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     geneve: Suppress list corruption splat in geneve_destroy_tunnels().
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     gtp: Suppress list corruption splat in gtp_net_exit_batch_rtnl().
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: pse-pd: pd692x0: Fix power limit retrieval
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: pse-pd: Use power limit at driver side instead of current limit
>
> Kory Maincent <kory.maincent@bootlin.com>
>     net: pse-pd: Avoid setting max_uA in regulator constraints
>
> Jakub Kicinski <kuba@kernel.org>
>     tcp: adjust rcvq_space after updating scaling ratio
>
> Michal Luczaj <mhal@rbox.co>
>     vsock/bpf: Warn on socket without transport
>
> Michal Luczaj <mhal@rbox.co>
>     sockmap, vsock: For connectible sockets allow only connected
>
> Nick Child <nnac123@linux.ibm.com>
>     ibmvnic: Don't reference skb after sending to VIOS
>
> Julian Ruess <julianr@linux.ibm.com>
>     s390/ism: add release function for struct device
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: seq: Drop UMP events when no UMP-conversion is set
>
> Pierre Riteau <pierre@stackhpc.com>
>     net/sched: cls_api: fix error handling causing NULL dereference
>
> Vitaly Rodionov <vitalyr@opensource.cirrus.com>
>     ALSA: hda/cirrus: Correct the full scale volume set logic
>
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     geneve: Fix use-after-free in geneve_find_dev().
>
> Junnan Wu <junnan01.wu@samsung.com>
>     vsock/virtio: fix variables initialization during resuming
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: imx-audmix: remove cpu_mclk which is from cpu dai device
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/code-patching: Fix KASAN hit by not flagging text patching ar=
ea as VM_ALLOC
>
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda/realtek: Fixup ALC225 depop procedure
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inli=
ne
>
> Christophe Leroy <christophe.leroy@csgroup.eu>
>     powerpc/code-patching: Disable KASAN report during patching via tempo=
rary mm
>
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: ipc4-topology: Harden loops for looking up ALH copiers
>
> John Keeping <jkeeping@inmusicbrands.com>
>     ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]
>
> Jill Donahue <jilliandonahue58@gmail.com>
>     USB: gadget: f_midi: f_midi_complete to call queue_work
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Have the error of __tracing_resize_ring_buffer() passed to u=
ser
>
> Steven Rostedt <rostedt@goodmis.org>
>     tracing: Switch trace.c code over to use guard()
>
> Lancelot SIX <lancelot.six@amd.com>
>     drm/amdkfd: Ensure consistent barrier state saved in gfx12 trap handl=
er
>
> Jay Cornwall <jay.cornwall@amd.com>
>     drm/amdkfd: Move gfx12 trap handler to separate file
>
> Takashi Iwai <tiwai@suse.de>
>     PCI: Restore original INTX_DISABLE bit by pcim_intx()
>
> Philipp Stanner <pstanner@redhat.com>
>     PCI: Remove devres from pci_intx()
>
> Philipp Stanner <pstanner@redhat.com>
>     PCI: Export pci_intx_unmanaged() and pcim_intx()
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     serial: sh-sci: Increment the runtime usage counter for the earlycon =
device
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     serial: sh-sci: Clean sci_ports[0] after at earlycon exit
>
> Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
>     serial: sh-sci: Move runtime PM enable to sci_probe_single()
>
> Zijun Hu <quic_zijuhu@quicinc.com>
>     Bluetooth: qca: Fix poor RF performance for WCN6855
>
> Cheng Jiang <quic_chejiang@quicinc.com>
>     Bluetooth: qca: Update firmware-name to support board specific nvm
>
> loanchen <lo-an.chen@amd.com>
>     drm/amd/display: Correct register address in dcn35
>
> Charlene Liu <Charlene.Liu@amd.com>
>     drm/amd/display: update dcn351 used clock offset
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: fix double accounting race when extent_writepage_io() failed
>
> Qu Wenruo <wqu@suse.com>
>     btrfs: fix double accounting race when btrfs_run_delalloc_range() fai=
led
>
> David Sterba <dsterba@suse.com>
>     btrfs: use btrfs_inode in extent_writepage()
>
> John Starks <jostarks@microsoft.com>
>     Drivers: hv: vmbus: Log on missing offers if any
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |    4 +-
>  .../boot/dts/rockchip/px30-ringneck-haikou.dts     |    1 -
>  arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi    |    6 +
>  .../dts/rockchip/rk3328-orangepi-r1-plus-lts.dts   |    3 +-
>  .../boot/dts/rockchip/rk3328-orangepi-r1-plus.dts  |    1 +
>  .../boot/dts/rockchip/rk3328-orangepi-r1-plus.dtsi |    1 -
>  .../boot/dts/rockchip/rk3399-gru-chromebook.dtsi   |    8 +-
>  .../boot/dts/rockchip/rk3399-gru-scarlet.dtsi      |    6 +-
>  arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi       |   22 +-
>  arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   22 +-
>  .../dts/rockchip/rk3588-coolpi-cm5-genbook.dts     |    4 +-
>  arch/powerpc/include/asm/book3s/64/hash-4k.h       |   12 +-
>  arch/powerpc/lib/code-patching.c                   |    4 +-
>  arch/s390/boot/startup.c                           |    2 +-
>  arch/x86/events/intel/core.c                       |   20 +-
>  arch/x86/events/intel/ds.c                         |    2 +-
>  drivers/bluetooth/btqca.c                          |  118 +-
>  drivers/clocksource/jcore-pit.c                    |   15 +-
>  drivers/edac/qcom_edac.c                           |    4 +-
>  .../firmware/arm_scmi/vendors/imx/imx-sm-misc.c    |    4 +-
>  drivers/firmware/imx/Kconfig                       |    1 +
>  drivers/gpio/gpio-vf610.c                          |    4 +
>  drivers/gpio/gpiolib.c                             |   48 +-
>  drivers/gpio/gpiolib.h                             |    4 +-
>  drivers/gpu/drm/Kconfig                            |    3 +
>  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |    3 +-
>  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   32 +-
>  drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     |    3 +-
>  .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm |  202 +---
>  .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm | 1130 ++++++++++++++=
++++++
>  drivers/gpu/drm/amd/display/dc/clk_mgr/Makefile    |    2 +-
>  drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c   |    5 +-
>  .../amd/display/dc/clk_mgr/dcn35/dcn351_clk_mgr.c  |  140 +++
>  .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c   |  130 ++-
>  .../amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.h   |    4 +
>  .../drm/amd/display/dc/inc/hw/clk_mgr_internal.h   |   59 +
>  drivers/gpu/drm/drm_panic_qr.rs                    |    2 +-
>  drivers/gpu/drm/i915/display/icl_dsi.c             |    4 +-
>  drivers/gpu/drm/i915/display/intel_ddi.c           |    2 +-
>  drivers/gpu/drm/i915/display/intel_display.c       |   18 +
>  .../gpu/drm/i915/display/intel_dp_link_training.c  |   15 +-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c  |    4 +-
>  drivers/gpu/drm/i915/i915_reg.h                    |    2 +-
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h |    2 +-
>  .../drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h    |    2 +-
>  .../gpu/drm/msm/disp/dpu1/catalog/dpu_5_4_sm6125.h |    2 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c        |    3 +
>  drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dsc.c         |    3 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_hw_top.c         |    2 +-
>  drivers/gpu/drm/msm/dp/dp_display.c                |   11 +-
>  drivers/gpu/drm/msm/dp/dp_drm.c                    |    5 +-
>  drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c          |   53 +-
>  drivers/gpu/drm/msm/msm_drv.h                      |   11 +-
>  .../gpu/drm/msm/registers/display/dsi_phy_7nm.xml  |   11 +-
>  drivers/gpu/drm/nouveau/nouveau_svm.c              |    9 +-
>  drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c    |    2 +-
>  drivers/gpu/drm/panel/panel-jadard-jd9365da-h3.c   |    8 +-
>  drivers/gpu/drm/xe/display/ext/i915_irq.c          |   13 +-
>  drivers/gpu/drm/xe/xe_device.c                     |    4 +-
>  drivers/gpu/drm/xe/xe_device.h                     |    3 +-
>  drivers/gpu/drm/xe/xe_device_types.h               |    8 +-
>  drivers/gpu/drm/xe/xe_irq.c                        |  298 ++++--
>  drivers/gpu/drm/xe/xe_irq.h                        |    3 +
>  drivers/hv/vmbus_drv.c                             |   17 +
>  drivers/irqchip/irq-gic-v3.c                       |   49 +-
>  drivers/irqchip/irq-jcore-aic.c                    |    2 +-
>  drivers/md/raid0.c                                 |    4 +-
>  drivers/md/raid1.c                                 |    4 +-
>  drivers/md/raid10.c                                |    4 +-
>  drivers/mtd/nand/raw/cadence-nand-controller.c     |   42 +-
>  drivers/mtd/spi-nor/sst.c                          |    2 +-
>  drivers/net/ethernet/google/gve/gve.h              |   10 +
>  drivers/net/ethernet/google/gve/gve_main.c         |    6 +-
>  drivers/net/ethernet/ibm/ibmvnic.c                 |    4 +-
>  drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      |    2 +
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    1 +
>  drivers/net/geneve.c                               |   16 +-
>  drivers/net/gtp.c                                  |    5 -
>  drivers/net/pse-pd/pd692x0.c                       |   45 +-
>  drivers/net/pse-pd/pse_core.c                      |   98 +-
>  drivers/nvme/host/ioctl.c                          |    3 +-
>  drivers/nvme/host/tcp.c                            |    7 +-
>  drivers/nvme/target/core.c                         |   40 +-
>  drivers/pci/devres.c                               |   58 +-
>  drivers/pci/pci.c                                  |   16 +-
>  drivers/platform/cznic/Kconfig                     |    1 +
>  drivers/power/supply/axp20x_battery.c              |   31 +-
>  drivers/power/supply/da9150-fg.c                   |    4 +-
>  drivers/s390/net/ism_drv.c                         |   14 +-
>  drivers/soc/loongson/loongson2_guts.c              |    5 +-
>  drivers/tee/optee/supp.c                           |   35 +-
>  drivers/tty/serial/sh-sci.c                        |   68 +-
>  drivers/usb/gadget/function/f_midi.c               |    2 +-
>  fs/btrfs/extent_io.c                               |  102 +-
>  fs/btrfs/inode.c                                   |    3 +-
>  fs/smb/client/inode.c                              |    4 +-
>  fs/smb/client/smb2ops.c                            |    4 +
>  fs/xfs/scrub/common.h                              |    5 -
>  fs/xfs/scrub/repair.h                              |   11 +-
>  fs/xfs/scrub/scrub.c                               |   12 +
>  include/linux/mm_types.h                           |    7 +-
>  include/linux/netdevice.h                          |    2 +
>  include/linux/pci.h                                |    1 +
>  include/linux/pse-pd/pse.h                         |   16 +-
>  include/net/gro.h                                  |    3 +
>  include/net/tcp.h                                  |   14 +
>  io_uring/io_uring.c                                |    2 +
>  io_uring/rw.c                                      |   13 +-
>  kernel/acct.c                                      |  134 ++-
>  kernel/bpf/arena.c                                 |    2 +-
>  kernel/bpf/bpf_cgrp_storage.c                      |    2 +-
>  kernel/bpf/btf.c                                   |    2 +
>  kernel/bpf/ringbuf.c                               |    4 -
>  kernel/bpf/syscall.c                               |   43 +-
>  kernel/sched/sched.h                               |   25 +-
>  kernel/trace/ftrace.c                              |   36 +-
>  kernel/trace/trace.c                               |  277 ++---
>  kernel/trace/trace_functions.c                     |    6 +-
>  lib/iov_iter.c                                     |    3 +-
>  mm/madvise.c                                       |   11 +-
>  mm/migrate_device.c                                |   13 +-
>  mm/zswap.c                                         |   35 +-
>  net/bpf/test_run.c                                 |    5 +-
>  net/core/dev.c                                     |   37 +-
>  net/core/drop_monitor.c                            |   39 +-
>  net/core/flow_dissector.c                          |   49 +-
>  net/core/gro.c                                     |    3 -
>  net/core/skbuff.c                                  |   10 +-
>  net/core/sock_map.c                                |    8 +-
>  net/ipv4/arp.c                                     |    2 +-
>  net/ipv4/tcp_fastopen.c                            |    4 +-
>  net/ipv4/tcp_input.c                               |   20 +-
>  net/ipv4/tcp_ipv4.c                                |    2 +-
>  net/sched/cls_api.c                                |    2 +-
>  net/vmw_vsock/af_vsock.c                           |    3 +
>  net/vmw_vsock/virtio_transport.c                   |   10 +-
>  net/vmw_vsock/vsock_bpf.c                          |    2 +-
>  rust/ffi.rs                                        |   37 +-
>  rust/kernel/device.rs                              |    4 +-
>  rust/kernel/error.rs                               |    5 +-
>  rust/kernel/firmware.rs                            |    2 +-
>  rust/kernel/miscdevice.rs                          |   12 +-
>  rust/kernel/print.rs                               |    4 +-
>  rust/kernel/security.rs                            |    2 +-
>  rust/kernel/seq_file.rs                            |    2 +-
>  rust/kernel/str.rs                                 |    6 +-
>  rust/kernel/uaccess.rs                             |   27 +-
>  samples/rust/rust_print_main.rs                    |    2 +-
>  sound/core/seq/seq_clientmgr.c                     |   12 +-
>  sound/pci/hda/hda_codec.c                          |    4 +-
>  sound/pci/hda/patch_conexant.c                     |    1 +
>  sound/pci/hda/patch_cs8409-tables.c                |    6 +-
>  sound/pci/hda/patch_cs8409.c                       |   20 +-
>  sound/pci/hda/patch_cs8409.h                       |    5 +-
>  sound/pci/hda/patch_realtek.c                      |    1 +
>  sound/soc/fsl/fsl_micfil.c                         |    2 +
>  sound/soc/fsl/imx-audmix.c                         |   31 -
>  sound/soc/rockchip/rockchip_i2s_tdm.c              |    4 +-
>  sound/soc/sof/ipc4-topology.c                      |   12 +-
>  sound/soc/sof/pcm.c                                |    2 +
>  sound/soc/sof/stream-ipc.c                         |    6 +-
>  161 files changed, 3032 insertions(+), 1289 deletions(-)
>
>
>
