Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE81FC1
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 02:56:20 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 136so102176ybn.1
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 18:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rP2+Jr5cCTgUgZIDbWfHwE1FyBQ/Lf8AXckAnS2jra0=;
        b=EzzrOhTxBDbDaxs7dGUwbenYwvFccr15alZMWpuSgRVRoAaetPTeFIxUauCEVFJZJ9
         omClbrHbMNYAxXYboKPlmR10uz6pAo5AAAop6qfFsS47lYtKDJuZFs2nkX7/ZVnxdEiy
         Gy3ES7u/+glZ/nJJa63v9+PWmsN++p7r/fAnRq0vtpl0ox0vMtYQ6LqsRLZxZ9WNKOXu
         MfHhkyeUVlakcJoYTHIX3g/N5q8dBnwZ6Rj0dV6nOo5krbBwznVGfsQ+YncIjon13GtU
         TGPB53PsRZww2w9tWWkCiOyoi3Py/9RCoKKTatQlarPtRxd0k6QeEbLlAud7yL1t341F
         i1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rP2+Jr5cCTgUgZIDbWfHwE1FyBQ/Lf8AXckAnS2jra0=;
        b=aztFzHtrLV+Ha28uxRtX3eWv5qGYREK1j1numX798FMW9HDryL8v91TkqoJikg4xIX
         hDVKWLeeVt2jQBiTs+TuvdjhYkx4MDKxVRzM1VQUvpaJEkhYTRcryvFcSAm3SIJSRdYx
         cSBSr19CxQGitatTgYcsC0729F6pRS8XkXnSWZI2ogcmFSZaSUhhYLBjSDZuz7t/9KPh
         w9CVRRMAlFezlZ5TBZWZySwYs1pe6hddSOrVNWJ+5R9UPA5uom8sOvFI3CRo2WzRzw4K
         CnWyeJwC4finQhFTlU6AYEhZZau2UfBM5tksFz4DlU76yB38A8R2CCfnmht1nYmnT/yH
         EybQ==
X-Gm-Message-State: ANoB5plT8iekSzyIrbzdqe5zHbcfRafvOtTJYFSRHKhNFzFMsAsngS6b
	UM7avgIy3DMw/BSezEgDvvxFCwzNs/h/+wVgwKMT7g==
X-Google-Smtp-Source: AA0mqf6AkXBuybM4qk3embnuafmgJAFwRTok3oIxxM6wWRkifndj8+BKwTpRZln+M1qIv68ERvmhpQNDGq7XphGcw8I=
X-Received: by 2002:a25:900c:0:b0:6c4:8a9:e4d2 with SMTP id
 s12-20020a25900c000000b006c408a9e4d2mr15389222ybl.164.1668480979228; Mon, 14
 Nov 2022 18:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124448.729235104@linuxfoundation.org>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Nov 2022 08:26:08 +0530
Message-ID: <CA+G9fYvdqK23zAa+=-x29Hq7BGVd2pN1_1XOp5U1X-GUWM4MAA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, 
	Zhengchao Shao <shaozhengchao@huawei.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Nov 2022 at 18:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As others reported,
arm: allmodconfig  failed [1] due to following warnings / errors.

drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
drivers/net/ethernet/mediatek/mtk_star_emac.c:980:22: error: 'struct
mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
  980 |  napi_disable(&priv->rx_napi);
      |                      ^~~~~~~
      |                      napi
drivers/net/ethernet/mediatek/mtk_star_emac.c:981:22: error: 'struct
mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
  981 |  napi_disable(&priv->tx_napi);
      |                      ^~~~~~~
      |                      napi


---
net: ethernet: mtk-star-emac: disable napi when connect and start PHY
failed in mtk_star_enable()
[ Upstream commit b0c09c7f08c2467b2089bdf4adb2fbbc2464f4a8 ]


[1] https://builds.tuxbuild.com/2HXmwUDUvmWI1Uc7zsdXNcsTqW1/

--
Linaro LKFT
https://lkft.linaro.org
