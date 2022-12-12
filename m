Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2088746F
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 22:10:59 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id h10so9161882qvq.7
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 14:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W3fdnCIdYn0lJ4Mxo5yFAqKtt9U4L6f/X7A6g14xg8A=;
        b=WBE3mdrauA1fH2/P8EvrnWRt/RzNEL9q5gVfL193jYozk1EP0hH//vDL/LNtnPvYRF
         4W3RU+5pCzo1eKIn9JrYHA6g3cZKMcTxYY+JTLVhII51tHssqWYlkogLQenKeK6lmUOj
         65vES31846yd+TrWo1wmisWja15UWlcWjBm9mRkgioggJcbfm1nHeBZbumma2LNV0/U/
         ATPUIxMJjUKuvTUBX0FIIz5sgQ8k346FjETh4gUSZPbiC5IPcCoHZtU51LkyJIxlbpA5
         0y3g+aqvWHPiAL9E+GJGWaOtR44SLvnN7NDoNXyzHbHYcbp7qr9oO3Tp3dJ4WcdvyF8J
         8sEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3fdnCIdYn0lJ4Mxo5yFAqKtt9U4L6f/X7A6g14xg8A=;
        b=suznNLs+CadTWE6KoRIW3leheTjbYnNKpLjd7Yx+foddBn1Pv6sEASUuHozfUCuxJC
         f1fu6/0p2HxuYwHXSQlZSUmJSewDeRHt1qXZHnBK0+xc4GP0x5ULXVfUObiDTXscZiWl
         eInCiLA7HMLKlQunzqwJ1/NDW/xq+n3QY8Ph7sTE3cqtCkd1zrkH4A/Vc9mCzW7+X66A
         a5fXYyK4g9ryo4EMZwkoCbx+ChPluwxFWBLd7Iezg3XMqqVUQwKn3pWsLe//kcJ2+VUv
         3fWSbdqkendsvLwicDvQfm7nx5G3p8P1xVYsCcQKRD7uBdoe/ZkM0rQbx+2/8TQQoGTV
         JlDA==
X-Gm-Message-State: ANoB5pmxCLTX3Mhe0dt+TDR+ohbazXHWRaUoU5vKyssn9M6JpGFCbido
	3O/Pm+Vy50F781HzF7Tx/8s=
X-Google-Smtp-Source: AA0mqf6LocvbuaTbqVkLPJ10p9RI6uMqXaM8vyeDgq/Ge1dPWQPM3UXW/fbz9MTvMks2tNgA6v8GIA==
X-Received: by 2002:ad4:4bc2:0:b0:4bb:859f:b217 with SMTP id l2-20020ad44bc2000000b004bb859fb217mr23604024qvw.47.1670883058788;
        Mon, 12 Dec 2022 14:10:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dt38-20020a05620a47a600b006b9c9b7db8bsm6458167qkb.82.2022.12.12.14.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:10:58 -0800 (PST)
Message-ID: <60723e86-dc4c-7506-2231-decc6e1bd29e@gmail.com>
Date: Mon, 12 Dec 2022 14:10:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130909.943483205@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 05:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.336-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
>      Linux 4.9.336-rc1
> 
> Dan Carpenter <error27@gmail.com>
>      net: mvneta: Fix an out of bounds check
> 
> Yang Yingliang <yangyingliang@huawei.com>
>      net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()
> 
> Juergen Gross <jgross@suse.com>
>      xen/netback: fix build warning
> 
> Zhang Changzhong <zhangchangzhong@huawei.com>
>      ethernet: aeroflex: fix potential skb leak in greth_init_rings()
> 
> YueHaibing <yuehaibing@huawei.com>
>      tipc: Fix potential OOB in tipc_link_proto_rcv()
> 
> Liu Jian <liujian56@huawei.com>
>      net: hisilicon: Fix potential use-after-free in hix5hd2_rx()
> 
> Liu Jian <liujian56@huawei.com>
>      net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
> 
> Kees Cook <keescook@chromium.org>
>      NFC: nci: Bounds check struct nfc_target arrays
> 
> Dan Carpenter <error27@gmail.com>
>      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
> 
> Valentina Goncharenko <goncharenko.vp@ispras.ru>
>      net: encx24j600: Fix invalid logic in reading of MISTAT register
> 
> Valentina Goncharenko <goncharenko.vp@ispras.ru>
>      net: encx24j600: Add parentheses to fix precedence
> 
> Wei Yongjun <weiyongjun1@huawei.com>
>      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()
> 
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
> 
> Akihiko Odaki <akihiko.odaki@daynix.com>
>      igb: Allocate MSI-X vector when testing
> 
> Akihiko Odaki <akihiko.odaki@daynix.com>
>      e1000e: Fix TX dispatch condition
> 
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>      gpio: amd8111: Fix PCI device reference count leak
> 
> Ziyang Xuan <william.xuanziyang@huawei.com>
>      ieee802154: cc2520: Fix error return code in cc2520_hw_init()
> 
> ZhangPeng <zhangpeng362@huawei.com>
>      HID: core: fix shift-out-of-bounds in hid_report_raw_event
> 
> Anastasia Belova <abelova@astralinux.ru>
>      HID: hid-lg4ff: Add check for empty lbuf
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>      media: v4l2-dv-timings.c: fix too strict blanking sanity checks
> 
> Adrian Hunter <adrian.hunter@intel.com>
>      mmc: sdhci: Fix voltage switch delay
> 
> Masahiro Yamada <yamada.masahiro@socionext.com>
>      mmc: sdhci: use FIELD_GET for preset value bit masks
> 
> Connor Shu <Connor.Shu@ibm.com>
>      rcutorture: Automatically create initrd directory
> 
> Juergen Gross <jgross@suse.com>
>      xen/netback: don't call kfree_skb() with interrupts disabled
> 
> Juergen Gross <jgross@suse.com>
>      xen/netback: do some code cleanup
> 
> Ross Lagerwall <ross.lagerwall@citrix.com>
>      xen/netback: Ensure protocol headers don't fall in the non-linear area
> 
> Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
>      ASoC: soc-pcm: Add NULL check in BE reparenting
> 
> Kees Cook <keescook@chromium.org>
>      ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event
> 
> Tomislav Novak <tnovak@fb.com>
>      ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels
> 
> Johan Jonker <jbx6244@gmail.com>
>      ARM: dts: rockchip: fix ir-receiver node names
> 
> Sebastian Reichel <sebastian.reichel@collabora.com>
>      arm: dts: rockchip: fix node name for hym8563 rtc
> 
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

