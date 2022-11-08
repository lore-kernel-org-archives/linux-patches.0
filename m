Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5C196
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 16:41:59 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id e123so13745562ybh.11
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 08:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JD3PRe74QR2mJ+orp5KCKp7oflDuwpBWOjw8obsvdQc=;
        b=ezAdGSbLm5hnxH9a3UKs0v0CGNhaTm5NwZtDjS9EEqbMnkp1Y2iUV48IxyEfmZ+0Kx
         unxFChxpGKrMIO/AKuVpdPRMAOH4GAvvbcqOl2jUOyIhcD0e+2cXmwK836XVVX2abv2I
         DDn3JnLzfMjf0qZJui350cU5ptyGDxUq2cA1/rnwTac3XS4TbsbX9r7S3lYSoSRJcblK
         divx9A5gGxFXwdlV3pQj0M3zehum+TE28Ws14aurCYj2DL903dBJ6dujNz4nMLYfgKgQ
         8U1AKAlyaWjm/nI2lZlnL6DYCTFMALUWDcKVrQthayTqYPSYWiRh+8HOUpCN4JMHDJGb
         fWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JD3PRe74QR2mJ+orp5KCKp7oflDuwpBWOjw8obsvdQc=;
        b=LLHcc3iQ8kj0Pk1ARlMxgZh8Ef2ywGE6Kp5b7TGEmxBLygE3I1oBj44+UqTRBQ/rn0
         ayIl6LMXs5yyA0KGEz1khl8O0S/nYo9YK6Zr0Xof+mA+U77zuxIh75uBk+LTwHBatdAT
         2sR2X+5vJvHSrVfBGuz6Nv/wvhysArFrAT0qnIIJaQgSMmYuUPAeuF5W3eJioWe2T5NE
         whOMIg9/55H0lgg+rhIcyrM5WpqmYMp+tR4RSIJc4m9iqvBH5u1Bfp2rL1XbnXEDgOOM
         otS6H1jPV+e/DpkSG8zm68I9EvWma70XxIx82hNAC7gIxjpcR0r7hjTbjaezzwzK6w6S
         E8cQ==
X-Gm-Message-State: ACrzQf25HUyWuSdYbTi5HRx7neIZC/bAsaM2Xa4hV9oPqGw7QFwJAKhq
	uk7cXBKxUTeSTaHKkIUBqsh8v7nXFEmhCeTMjRibNQ==
X-Google-Smtp-Source: AMsMyM7b5keHpnrPp6sbB8q5Ph5lxpcIatBUP8MgjCIRGloZ+3MsJQch3obqOYW8dlqcALhXh82dmnZYmZrU003kRTI=
X-Received: by 2002:a05:6902:722:b0:6ca:260e:cc5 with SMTP id
 l2-20020a056902072200b006ca260e0cc5mr57709150ybt.336.1667925718127; Tue, 08
 Nov 2022 08:41:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221108133340.718216105@linuxfoundation.org>
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 8 Nov 2022 22:11:46 +0530
Message-ID: <CA+G9fYtSBS77MiW99t7HGyBPnnpxyu-6L3HUPsA+pXd_fkZRVg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Nov 2022 at 19:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As other reported LKFT also noticed arm64 build failures.

Error: /builds/linux/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25
syntax error
FATAL ERROR: Unable to parse input tree
make[3]: *** [scripts/Makefile.lib:326:
arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-cx.dtb] Error 1
Error: /builds/linux/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi:1296.24-25
syntax error
FATAL ERROR: Unable to parse input tree

URL:
https://builds.tuxbuild.com/2HGddiHMonVVZRsckAWkubW4tdh/

- Naresh
