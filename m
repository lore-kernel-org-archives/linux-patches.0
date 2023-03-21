Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB0E8BE1
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 10:15:15 +0000 (UTC)
Received: by mail-ed1-f46.google.com with SMTP id y4so57577085edo.2
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 03:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112; t=1679393713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPZLwXOZRcorVd7q1GAEZgbB1jSiFy3d5LtXDMLqkRI=;
        b=cbNkG895Ge9ZG6hIzcUdiWc975KbpPoHxxRn6s0LR6QKaQInX7QA3FicGIE/Ebd/Eh
         dBFnlFDe6jJjlSkw/b7Ss6hWH6f+WWSsYSXyzBegp8OIb3T+ysm/9k2CZUyaqwBXhbPS
         Yw2loxVV2E8v2tlyYlBjeg6CzzIwoBrPR2BjFSo2w08Np7otnklbUN1ttVxQmThEK2ys
         9wQJ00i9bGNMmnuzmVMW2yaoIzeLPIn/2v06cJ5tyU9yhcam4k2k8Nua/U2NDT/LXItu
         AltEuPA2za8JMxSaybK0SaouOeP9FPXoyU/c2+sBh+BOS2uERyiA1dONuzAdE0daGYa4
         0ACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679393713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPZLwXOZRcorVd7q1GAEZgbB1jSiFy3d5LtXDMLqkRI=;
        b=RBTczZzRCQ0fdlZPXU2OG+XSzUP5Fw+ay7lauWQpqO1OMWwu/WvYrdZ/h5+Jz0QUUx
         a4djMyUiDq6nvlfAFI9M/uZ/mB4uidWKxnS62sONMNlXpRks/e3Huv8WN5gmHkNxiTpn
         8lIkpeQ7SI6uwl1jy/GJfMEAaqKEn5fwIyxZH16BLz53lhfw0IEw548TDHSIewLKpnFn
         /ZOBgaVR9X/vPzJyrWidfWoUW8c9h2PdYur/dzufuBtu46iMWILgkg/i3HytmRoGgej1
         8ghAGPrQ9NS7nW//0iQMdYTFOA8aX97718MDPJfZfk8jTj+ogG0fOKeYgVZ8kn6Q3DFy
         6ImA==
X-Gm-Message-State: AO0yUKXynd2PzJvG9qo16cX6YCEB47/MYsiRGD747OiwFbjuugptT0hY
	/0VIiVYR9BBnxW9/3yjWTXuBBrXEieO2+EopqtegZg==
X-Google-Smtp-Source: AK7set/THFJZheYTOTejcWWnHCm6ePuf/4HAQH9Mt/K09wQzWDjcnxlvoDo7Vhr6Cce3pY2xwfRwy5fCgDija2Fier8=
X-Received: by 2002:a17:906:a054:b0:933:2bb9:7c98 with SMTP id
 bg20-20020a170906a05400b009332bb97c98mr1437532ejb.6.1679393713576; Tue, 21
 Mar 2023 03:15:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080705.245176209@linuxfoundation.org>
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 21 Mar 2023 19:15:02 +0900
Message-ID: <CAKL4bV6TDsxGLtKSSWE+je6yK4Y-8v7Q-ymf6OSVW2CzJDNdpQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Mar 21, 2023 at 5:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.21-rc2 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
