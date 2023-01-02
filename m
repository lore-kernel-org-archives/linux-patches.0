Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8183208
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 23:14:40 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d3so30844813plr.10
        for <patches@lists.linux.dev>; Mon, 02 Jan 2023 15:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yY1/fILcvpRKU0bivqO7pZp67LzV2ztHWexSOMGIEMA=;
        b=TCRnubnPXGHQLhXQlKNrDr/X2lJwe0KUUl8A8CkpznfvxckOmJDG5eAUFg48aSiMSJ
         YssUAUVY6FBfgbpCoZqRobxlaOtmnscYOR0FLoLlZgykZzMD7IOWTQjPqXiW13erE6gT
         RD7JB+qoAASDKQb9mA3vDEG4RGwdZA1EHQuTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yY1/fILcvpRKU0bivqO7pZp67LzV2ztHWexSOMGIEMA=;
        b=ER4iiDU2OGhK0C0FVsrgpJ/sB1xDkVZqiMXBA2i0a4LI7olF0X6YkBhBreCMDG6hrA
         A7eDYPhctbStMMJ4vXfm4SNLr+16yn6azleSV0807QWXpQAiumY2aN+Wf1CIYnhmlQ+X
         0dBkTcUf9tXywwIKSV1HozhF2p64daxwOpgC64yP2TGMvdNmcPCyd02MMfBepLE/4xfH
         t2ilyVLfnHwIfsB+CQGpsus38DMVpUiB8+unO5k+4mbggkbPMXzSPVTs6yO6W+RseBDN
         AUEnP0J59ohp672paQAo5hzy77cWhvGvHNMSxh/25dx+iQ1t8MtLXqbHVpnARTrlxcB4
         v/BA==
X-Gm-Message-State: AFqh2kqKWS65f/pji/aZmZhV5IhnfKcoX8VghW/tNUq7ubvbLlKfPbTr
	gqZyutmM2164ve5WaLBELO/e5Q==
X-Google-Smtp-Source: AMrXdXtoAYcG8xDuM42hw4tVM/z8D/1RnpRghd3d33P7z8/RaL1+pkP0JK9AATFXvQhQePTOBpj0mg==
X-Received: by 2002:a05:6a20:e61b:b0:af:7ed7:d370 with SMTP id my27-20020a056a20e61b00b000af7ed7d370mr49572017pzb.43.1672701280240;
        Mon, 02 Jan 2023 15:14:40 -0800 (PST)
Received: from 911e562c0830 (lma3293270.lnk.telstra.net. [60.231.90.117])
        by smtp.gmail.com with ESMTPSA id n25-20020a6563d9000000b00477bfac06b7sm17516769pgv.34.2023.01.02.15.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 15:14:38 -0800 (PST)
Date: Mon, 2 Jan 2023 23:14:24 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <20230102231424.GA8@911e562c0830>
References: <20230102110551.509937186@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.3-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
