Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7A190
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 00:08:56 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7950fac19f2so73709139f.3
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 17:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1693872535; x=1694477335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EQqMhAwi/RdaSGvDrgUuJLU0jKCvJkEspCqkuPr5nKA=;
        b=GZGHsKpP4U+jJ1a7MsFUaSYf+CA/dgiS9e1x5HuhjWT4eV7wC9Y46eESAxd2Evmven
         8/ApjDNBH4WiSLhuE4bOqXq2QfJ4kBM25apY0A6Mutq1eP1rnT7cg0wJ5TSPHYlEIivT
         EfNa9pFXYpF0FC4dEFwm3N4pKW1Jua6it2fbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693872535; x=1694477335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQqMhAwi/RdaSGvDrgUuJLU0jKCvJkEspCqkuPr5nKA=;
        b=WwKT/YR7TtEyEYv1CkQS4cu0Tfm0LWb9F5E7eCnAN5rWfWe4Xzh4CcTSJyNiRRJwwf
         WhF0wqJWXxOEZrMw1SbY7fyCL6j6lbzUP4DyHbuMAfkuGCwVd6qOFD5gftSW0UpHyhf3
         1I7rafJKzO4nXQ1ijRKbkndux/znTRDTGYiWz565gkW8lC3mqp0MuHQ+neDvJTOM++Kt
         nb6l0fZQcQ9AWWQLGLon0v+dk7bIq/ja+I2LnBU7Enb7xtGYbfLwEpjeol7DzhXOyjBk
         t/CquqNhE09QiME6YsXoYLAtbo8yx9vzrwwC0yNBQCy0jmkZj3UkEjJbLnHmtoDp9lu2
         spWg==
X-Gm-Message-State: AOJu0Yx3gJMC3q9l9Tuv2hGlsPsc2NkiBQGPbtvMZhFjTGwi4gC/pkV5
	A7n29sRep3hBj5e0DECy9PqY1Q==
X-Google-Smtp-Source: AGHT+IFqdKdGGJQNWwi1QUO/ohPr8jARQ1XBShyjBnL2Y/AelhuFxiuYiNh+3GP0Oy/AG1K0OpFfxQ==
X-Received: by 2002:a05:6602:160b:b0:792:792e:6619 with SMTP id x11-20020a056602160b00b00792792e6619mr17604153iow.2.1693872535495;
        Mon, 04 Sep 2023 17:08:55 -0700 (PDT)
Received: from localhost (156.190.123.34.bc.googleusercontent.com. [34.123.190.156])
        by smtp.gmail.com with ESMTPSA id k20-20020a02c654000000b0043321a50c29sm3686994jan.93.2023.09.04.17.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 17:08:55 -0700 (PDT)
Date: Tue, 5 Sep 2023 00:08:54 +0000
From: Joel Fernandes <joel@joelfernandes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.15 00/28] 5.15.131-rc1 review
Message-ID: <20230905000854.GB1104186@google.com>
References: <20230904182945.178705038@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:30:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.131 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
>     Linux 5.15.131-rc1
> 
> Marco Felsch <m.felsch@pengutronix.de>
>     usb: typec: tcpci: clear the fault status bit
> 
> Xin Ji <xji@analogixsemi.com>
>     usb: typec: tcpci: move tcpci.h to include/linux/usb/
> 
> Mario Limonciello <mario.limonciello@amd.com>
>     pinctrl: amd: Don't show `Invalid config param` errors
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix WARNING in mark_buffer_dirty due to discarded buffer reuse
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix general protection fault in nilfs_lookup_dirty_data_buffers()
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
> Deren Wu <deren.wu@mediatek.com>
>     wifi: mt76: mt7921: do not support one stream on secondary antenna only
> 
> Zheng Wang <zyytlz.wz@163.com>
>     Bluetooth: btsdio: fix use after free bug in btsdio_remove due to race condition
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
>     ksmbd: replace one-element array with flex-array member in struct smb2_ea_info
> 
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: fix wrong DataOffset validation of create context
> 
> Gao Xiang <hsiangkao@linux.alibaba.com>
>     erofs: ensure that the post-EOF tails are all zeroed
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                           |  4 ++--
>  arch/arm/mach-pxa/sharpsl_pm.c                     |  2 --
>  arch/arm/mach-pxa/spitz.c                          | 14 +-----------
>  arch/mips/alchemy/devboards/db1000.c               |  8 +------
>  arch/mips/alchemy/devboards/db1200.c               | 19 ++--------------
>  arch/mips/alchemy/devboards/db1300.c               | 10 +--------
>  drivers/bluetooth/btsdio.c                         |  1 +
>  drivers/firmware/stratix10-svc.c                   |  2 +-
>  drivers/fsi/fsi-master-ast-cf.c                    |  1 +
>  drivers/hid/wacom.h                                |  1 +
>  drivers/hid/wacom_sys.c                            | 25 ++++++++++++++++++----
>  drivers/hid/wacom_wac.c                            |  1 +
>  drivers/hid/wacom_wac.h                            |  1 +
>  drivers/mmc/host/Kconfig                           |  5 +++--
>  drivers/net/ethernet/freescale/enetc/enetc_ptp.c   |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  2 +-
>  drivers/pinctrl/pinctrl-amd.c                      |  4 ++--
>  drivers/rtc/rtc-ds1685.c                           |  2 +-
>  drivers/staging/rtl8712/os_intfs.c                 |  1 +
>  drivers/staging/rtl8712/usb_intf.c                 |  1 -
>  drivers/tty/serial/qcom_geni_serial.c              |  5 +++++
>  drivers/tty/serial/sc16is7xx.c                     | 17 ++++++++++++++-
>  drivers/usb/chipidea/ci_hdrc_imx.c                 | 10 +++++----
>  drivers/usb/chipidea/usbmisc_imx.c                 |  6 ++++--
>  drivers/usb/dwc3/dwc3-meson-g12a.c                 |  6 ++++++
>  drivers/usb/serial/option.c                        |  7 ++++++
>  drivers/usb/typec/tcpm/tcpci.c                     |  7 ++++--
>  drivers/usb/typec/tcpm/tcpci_maxim.c               |  3 +--
>  drivers/usb/typec/tcpm/tcpci_mt6360.c              |  3 +--
>  drivers/usb/typec/tcpm/tcpci_rt1711h.c             |  2 +-
>  drivers/usb/typec/tcpm/tcpm.c                      |  7 ++++++
>  fs/erofs/zdata.c                                   |  2 ++
>  fs/ksmbd/oplock.c                                  |  2 +-
>  fs/ksmbd/smb2pdu.c                                 |  2 +-
>  fs/ksmbd/smb2pdu.h                                 |  2 +-
>  fs/nilfs2/alloc.c                                  |  3 ++-
>  fs/nilfs2/inode.c                                  |  7 ++++--
>  fs/nilfs2/segment.c                                |  5 +++++
>  .../usb/typec/tcpm => include/linux/usb}/tcpci.h   |  2 ++
>  kernel/module.c                                    | 14 +++++++++---
>  sound/usb/stream.c                                 | 11 +++++++++-
>  41 files changed, 142 insertions(+), 87 deletions(-)
> 
> 
