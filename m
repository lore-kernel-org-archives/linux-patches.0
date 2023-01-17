Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3D11851
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 04:14:38 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id u19so72422596ejm.8
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 20:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zDKtcvtIFf+y3VGztWmfwnQISP0yBigN3Ccwm/hiUK0=;
        b=54pwdyFuQao0yiFXoRpb3zxlQhCUMcKCmJ2/n3bCVvo8cyajV60H6C5hcnRhJCIDzJ
         2td93sZbOnSa28pLgqAw0/PoCjHhZ4xtPpfUd89yOpY7VySpIlXbVyfQnlpUpGnS03lL
         9nv0rbf0WJJW443a1eZ5EOJ3Zx6S5bjRpQHoZCQ2lA1JPVCITvnlDDsLgmt3wkM6hByF
         scj8fCB+NUWKtsn8cHLKekKJZlSX6FLPkoD7BAX61xYnPheKGaCe7Q3r8Z7Ug6C5UqPC
         ObzUisWGAA97Wr6Fsxt7JgL26PPMtgEpsTN25KkJrjgNGpuL7BDzn4VmGtrOyu6Ihun0
         n0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zDKtcvtIFf+y3VGztWmfwnQISP0yBigN3Ccwm/hiUK0=;
        b=KzyhBtR2Iyd1zHNcQ9g9jsV2d+hVDGBRe8eHaAECteJ5RS3t8AdCdselgiyLo1EfNY
         j5tK6if049kzbCDkDgfq2Dl/kcy15zRwCLfjGvgzd13szWo6/bEaAk3hQ3/0I2Pui2qu
         AGOPk7icoS2D6JDK2RwKDScdkDFMdFRkmOhrgeveRCW32zJ7OE0COjaB/PuXMWiU2Fv8
         tAxVfIYlqb9/72WH5cjtVdrTzogt+1sGGBP4DqhO+UZk925+8U4AiX5wRSRaYhk7nP0n
         i/TwKAsU17zdy5pbC9ws8W5bSvFbQF8akNwX3tMXjKNUKYu7BXKu/1zlTVwryE7zWoiZ
         8OcA==
X-Gm-Message-State: AFqh2krAjMph9Ll5YbELQO1SuJy+s6VRLEGp/rgnvH3WENdGAMTPREBv
	5hLpYeEszkQcKDOuw1oHHCoQaWxkuShcY740bE4dGA==
X-Google-Smtp-Source: AMrXdXtJPZDPoMdGM+6WhpO0nIkoLS5sWjW5h+CYpA1K2txuLO3Ta6YC6FkoDbzeDHsMWYHGV1a7f87eAVCI7B8FbmU=
X-Received: by 2002:a17:907:78d6:b0:872:5a3e:3be4 with SMTP id
 kv22-20020a17090778d600b008725a3e3be4mr72348ejc.649.1673928877030; Mon, 16
 Jan 2023 20:14:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154803.321528435@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 17 Jan 2023 13:14:25 +0900
Message-ID: <CAKL4bV7=cY5qWxtKpuLfKUkXEWd6tgSL2oeWVXPmiwNkrKZdHw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Tue, Jan 17, 2023 at 12:54 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.7-rc1 tested.

x86_64

build successfully completed
boot successfully completed

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
