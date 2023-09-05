Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71785190
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 00:09:53 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-79545e141c7so39568639f.0
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 17:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1693872592; x=1694477392; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9P2LGDxqic3zb5p3b4NCk0WwMm8b4LssupHDf94x/5U=;
        b=Dw6nCYzijicBx9QTqUp8hfradJ6lztmrC3SxQdxxEoNPvUploneYW2/iirYSY3Im2Q
         bDHddpPCSNTygzwPGiGvK1QG0tVrFsZWIeEDD6B7f0ehycV0HTmrfNz7OCh13PGvfxtl
         BZ7KNGe4zDlITym/gK0528ykbBsHYi86ilc24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693872592; x=1694477392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9P2LGDxqic3zb5p3b4NCk0WwMm8b4LssupHDf94x/5U=;
        b=XNsyRVVNyZzBPAia3nI8svPf5JtpheVi8o37tmkPHSXHKgPxd3APPWIYifbI7LWBVB
         p8IlFoaB/bGRRXBTqDp0cKxJjA/RY6EaSP3mZ6u26o+pzsWzWcp5CwKri9Hjay3OEwse
         bpkPJXFhsuzoNTH98jdOkgR3SUWsBRA3NOElBnIjKpw7JBmpiMV/XJmI4Lq9sPEGauMQ
         tMu0kwWc7AHpRrjuF7cPuQSvL8IFTdvfr0nx6dOXHWPdrDI1z/NlzvpoaoaZEr+gs55F
         NfBChppKLLmfo02OwG8OJAff79l27BDJXGfQ5W7Z6xIt2q9klKOe/UnqJ5qdyuOtX+gI
         k+gg==
X-Gm-Message-State: AOJu0Yym/a/bS1WFDf69+5/KShzW3md2oXbzHoudxTatPzJ84VMmzWLX
	pq09RzHuWKk45DIXFxvpLTrnIx9/TNsfwFx1yKo=
X-Google-Smtp-Source: AGHT+IG5OP+CMJnMlbVJ9GSAMYTUf5tHcERSDViUStlQ+D5MxuDsqKByilHuooczHDAwnMcv0oQjdg==
X-Received: by 2002:a05:6602:168f:b0:792:7c46:3dec with SMTP id s15-20020a056602168f00b007927c463decmr15518481iow.4.1693872592420;
        Mon, 04 Sep 2023 17:09:52 -0700 (PDT)
Received: from localhost (156.190.123.34.bc.googleusercontent.com. [34.123.190.156])
        by smtp.gmail.com with ESMTPSA id j22-20020a02cc76000000b0042bae96eba7sm3693388jaq.7.2023.09.04.17.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 17:09:52 -0700 (PDT)
Date: Tue, 5 Sep 2023 00:09:51 +0000
From: Joel Fernandes <joel@joelfernandes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
Message-ID: <20230905000951.GE1104186@google.com>
References: <20230904182948.594404081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:29:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.

For RCU,
Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>

thanks,

 - Joel

> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 6.5.2-rc1
> 
> Mario Limonciello <mario.limonciello@amd.com>
>     pinctrl: amd: Don't show `Invalid config param` errors
> 
> Marco Felsch <m.felsch@pengutronix.de>
>     usb: typec: tcpci: clear the fault status bit
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix WARNING in mark_buffer_dirty due to discarded buffer reuse
> 
> Brian Foster <bfoster@redhat.com>
>     tracing: Zero the pipe cpumask on alloc to avoid spurious -EBUSY
> 
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>     dt-bindings: sc16is7xx: Add property to change GPIO function
> 
> Badhri Jagan Sridharan <badhri@google.com>
>     tcpm: Avoid soft reset when partner does not support get_status
> 
> Juerg Haefliger <juerg.haefliger@canonical.com>
>     fsi: master-ast-cf: Add MODULE_FIRMWARE macro
> 
> Wang Ming <machel@vivo.com>
>     firmware: stratix10-svc: Fix an NULL vs IS_ERR() bug in probe
> 
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>     serial: sc16is7xx: fix bug when first setting GPIO direction
> 
> Hugo Villeneuve <hvilleneuve@dimonoff.com>
>     serial: sc16is7xx: fix broken port 0 uart init
> 
> Johan Hovold <johan+linaro@kernel.org>
>     serial: qcom-geni: fix opp vote on shutdown
> 
> Sven Eckelmann <sven@narfation.org>
>     wifi: ath11k: Cleanup mac80211 references on failure during tx_complete
> 
> Sven Eckelmann <sven@narfation.org>
>     wifi: ath11k: Don't drop tx_status when peer cannot be found
> 
> Sascha Hauer <s.hauer@pengutronix.de>
>     wifi: rtw88: usb: kill and free rx urbs on probe failure
> 
> Deren Wu <deren.wu@mediatek.com>
>     wifi: mt76: mt7921: fix skb leak by txs missing in AMSDU
> 
> Deren Wu <deren.wu@mediatek.com>
>     wifi: mt76: mt7921: do not support one stream on secondary antenna only
> 
> Nam Cao <namcaov@gmail.com>
>     staging: rtl8712: fix race condition
> 
> Aaron Armstrong Skomra <aaron.skomra@wacom.com>
>     HID: wacom: remove the battery when the EKR is off
> 
> Xu Yang <xu.yang_2@nxp.com>
>     usb: chipidea: imx: improve logic if samsung,picophy-* parameter is 0
> 
> Luke Lu <luke.lu@libre.computer>
>     usb: dwc3: meson-g12a: do post init to fix broken usb after resumption
> 
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Fix init call orders for UAC1
> 
> Slark Xiao <slark_xiao@163.com>
>     USB: serial: option: add FOXCONN T99W368/T99W373 product
> 
> Martin Kohn <m.kohn@welotec.com>
>     USB: serial: option: add Quectel EM05G variant (0x030e)
> 
> Christoph Hellwig <hch@lst.de>
>     modules: only allow symbol_get of EXPORT_SYMBOL_GPL modules
> 
> Christoph Hellwig <hch@lst.de>
>     rtc: ds1685: use EXPORT_SYMBOL_GPL for ds1685_rtc_poweroff
> 
> Christoph Hellwig <hch@lst.de>
>     net: enetc: use EXPORT_SYMBOL_GPL for enetc_phc_index
> 
> Christoph Hellwig <hch@lst.de>
>     mmc: au1xmmc: force non-modular build and remove symbol_get usage
> 
> Arnd Bergmann <arnd@arndb.de>
>     ARM: pxa: remove use of symbol_get()
> 
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: reduce descriptor size if remaining bytes is less than request size
> 
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: replace one-element array with flex-array member in struct smb2_ea_info
> 
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix slub overflow in ksmbd_decode_ntlmssp_auth_blob()
> 
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix wrong DataOffset validation of create context
> 
> Gao Xiang <xiang@kernel.org>
>     erofs: ensure that the post-EOF tails are all zeroed
> 
> Lang Yu <Lang.Yu@amd.com>
>     drm/amdgpu: correct vmhub index in GMC v10/11
> 
> 
> -------------
> 
> Diffstat:
> 
>  .../devicetree/bindings/serial/nxp,sc16is7xx.txt   | 46 ++++++++++++++++++++++
>  Makefile                                           |  4 +-
>  arch/arm/mach-pxa/sharpsl_pm.c                     |  2 -
>  arch/arm/mach-pxa/spitz.c                          | 14 +------
>  arch/mips/alchemy/devboards/db1000.c               |  8 +---
>  arch/mips/alchemy/devboards/db1200.c               | 19 +--------
>  arch/mips/alchemy/devboards/db1300.c               | 10 +----
>  drivers/firmware/stratix10-svc.c                   |  2 +-
>  drivers/fsi/fsi-master-ast-cf.c                    |  1 +
>  drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |  4 +-
>  drivers/gpu/drm/amd/amdgpu/gmc_v11_0.c             |  4 +-
>  drivers/hid/wacom.h                                |  1 +
>  drivers/hid/wacom_sys.c                            | 25 ++++++++++--
>  drivers/hid/wacom_wac.c                            |  1 +
>  drivers/hid/wacom_wac.h                            |  1 +
>  drivers/mmc/host/Kconfig                           |  5 ++-
>  drivers/net/ethernet/freescale/enetc/enetc_ptp.c   |  2 +-
>  drivers/net/wireless/ath/ath11k/dp_tx.c            | 10 ++---
>  .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  7 +++-
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  2 +-
>  drivers/net/wireless/realtek/rtw88/usb.c           |  5 ++-
>  drivers/pinctrl/pinctrl-amd.c                      |  4 +-
>  drivers/rtc/rtc-ds1685.c                           |  2 +-
>  drivers/staging/rtl8712/os_intfs.c                 |  1 +
>  drivers/staging/rtl8712/usb_intf.c                 |  1 -
>  drivers/tty/serial/qcom_geni_serial.c              |  5 +++
>  drivers/tty/serial/sc16is7xx.c                     | 17 +++++++-
>  drivers/usb/chipidea/ci_hdrc_imx.c                 | 10 +++--
>  drivers/usb/chipidea/usbmisc_imx.c                 |  6 ++-
>  drivers/usb/dwc3/dwc3-meson-g12a.c                 |  6 +++
>  drivers/usb/serial/option.c                        |  7 ++++
>  drivers/usb/typec/tcpm/tcpci.c                     |  4 ++
>  drivers/usb/typec/tcpm/tcpm.c                      |  7 ++++
>  fs/erofs/zdata.c                                   |  2 +
>  fs/nilfs2/alloc.c                                  |  3 +-
>  fs/nilfs2/inode.c                                  |  7 +++-
>  fs/smb/server/auth.c                               |  3 ++
>  fs/smb/server/oplock.c                             |  2 +-
>  fs/smb/server/smb2pdu.c                            |  2 +-
>  fs/smb/server/smb2pdu.h                            |  2 +-
>  fs/smb/server/transport_rdma.c                     | 25 ++++++++----
>  include/linux/usb/tcpci.h                          |  1 +
>  kernel/module/main.c                               | 14 +++++--
>  kernel/trace/trace.c                               |  4 +-
>  sound/usb/stream.c                                 | 11 +++++-
>  45 files changed, 220 insertions(+), 99 deletions(-)
> 
> 
