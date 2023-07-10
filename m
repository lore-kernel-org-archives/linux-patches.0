Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170F7154B1
	for <patches@lists.linux.dev>; Mon, 10 Jul 2023 23:14:22 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4fa16c6a85cso7681651e87.3
        for <patches@lists.linux.dev>; Mon, 10 Jul 2023 16:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1689030861; x=1691622861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIA0vS9CGVZu/dKUtt1DEeTq+za3hXZ7GjZyvjklTUs=;
        b=wbebkbLh9K+s7RqRbnPjkJnBGX5Q2tQ8wr1xPosokwNjTydGAOTVas0VGA6zyRvd8W
         WPyz+AzJVi309tna+AIGoxvDbPTKSBqHQhlDFTkuO0K7N/LXJ+6lBIA4a0/d9bQl4L5V
         2u5aXF3lCrjW8ZVuffdH+voZjPSyNhDf7YA8Pn5PaW98cNENUYJDCXNaPPMiOVE/owwg
         T1Q5RnfMgUW/9WFfuhI7SWR1RJxpKbsAkgkD+QTqkZ4KScpOELTy7xA1xbGH3aMYFxFE
         WthVHtgBB+4NQP+RVltsVo14IXrQLyjuhWpqF0JjkiE+VOTMeGhWn182IwNCWlc1KsVT
         Xn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689030861; x=1691622861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIA0vS9CGVZu/dKUtt1DEeTq+za3hXZ7GjZyvjklTUs=;
        b=Fp20jD2zwj0xfe54myo1378SMhwg2XtdrfJ0AjXjI0Ct0gPI5rR7INnwjxxITyUDJs
         XL0HdWG/wzPJeWI1ZfpcvPwGdJH3XdtnRoUihftFUu0heq5HE6MFnZm+/ra3/DGalPtI
         ZJOjgmupuOyGTcgk0v8vdbfyTuPk8WxQ4wp6BH5WUg7RV7/0h3OVrwiIMw8GcpRMG3lK
         fm7fGx8gbvEsNAyIO86KwVHb8ixlBA+CNjwkDr+Pq+J+T7hNTAw8ab2QQ/auhhHfi0yz
         T7Y956JVwbVxwMmy7tfNLtVycncACajuwHfulkxvQ7bIklXkyi1JEYNtetX78XH+T/TW
         ScbQ==
X-Gm-Message-State: ABy/qLYOKxuAU6PVjZiRGcE6phl5yqa9lFuh4jfiPeBARXAc8r00mwKt
	GatrFWRhv7XypPb5WPlplfOEfDzgN5mnDPeZTJ0/Gg==
X-Google-Smtp-Source: APBJJlEcIKfj6d06z0ZSWaBeY8VonHC9pf+QP0h3+s903O5LXh6RbAYPuokBP+PaRwBXogdljmL9fsDD46SWpNIEctM=
X-Received: by 2002:a19:e006:0:b0:4f8:6bbe:8a0b with SMTP id
 x6-20020a19e006000000b004f86bbe8a0bmr10101748lfg.16.1689030860745; Mon, 10
 Jul 2023 16:14:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230709203826.141774942@linuxfoundation.org>
In-Reply-To: <20230709203826.141774942@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 11 Jul 2023 08:14:09 +0900
Message-ID: <CAKL4bV7eHZerKW5F2_Zx_fEpmotZ3YvGYht1H1Evro6M5CBHxA@mail.gmail.com>
Subject: Re: [PATCH 6.4 0/6] 6.4.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, Jul 10, 2023 at 5:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.3 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jul 2023 20:38:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.4.3-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.4.3-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
