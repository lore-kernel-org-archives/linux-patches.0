Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6DC20CA8
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 19:28:57 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-5654051b27fso998305a12.0
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 12:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691695736; x=1692300536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LKXLnqK7mLXxFGBNP/mSfzDoE34EJtJtYOY6V+pFjw=;
        b=Vy6MwqMZHUwHzHqu0oLi2djO4Byo74KF00zJZc2rlHedIwBNKf7hKh+pgYZHUrYT6f
         AUrlAPL8z4N6upJx3SS+DHBwUZUS9nyI3KHqGXxX6TlCHbPFHr7/9S0yjBC2BKfgapCJ
         g9C4r68KWgVvAdtG0eWOTFph4rzQY39GNXXaV8M/Yf6pvvBqIdZr/tL6pX7TZbpVYqK5
         utTy5umNZEYo6b7W/QfDzeKmBIeffFbM47UaZWsRcIFObQ9HJLHz8/aMFDY2O0J3XW27
         9UpZaD4oDu0nWJWRvYCIzIjL0+Ls2gx+8fjpye3KmhXwCxXid+tPBWhlgFxhBIvkf/JT
         hHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691695736; x=1692300536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7LKXLnqK7mLXxFGBNP/mSfzDoE34EJtJtYOY6V+pFjw=;
        b=X2M5ceMylylRiRj5rg+/ujywi3QJlhlIK1oQ90b2gZu7Q1LDFy/R3XcgK2xDXBdJqu
         zADNu9/WbAkRuoR0WKJqpWMc1p9waq1lBdVV3uwUZH/MhoL0XmGHZJif794u8rcqfUfZ
         txr7HvC7ey7Tl6QTJrxCgLdTxD6x5F/hWleTBeLVXne0+sHL3veEX/lqh/TsriJjbSnI
         cHfIJwpV0iSm/gWkhvpprzRcJa5JP718S7eDXua8ZmcfzlWPQZuVx5vTFYi1P7B/c1QC
         a5P7wCkntWTDICVKVtALVoyu/OemhpUaLif43PkF5kxMoTp1JlTu9PvH6o5TVVKKh89q
         X9Qg==
X-Gm-Message-State: AOJu0YzTAjewnfSGGBCggv8eg64K/B6WczifgXlXHc7elmXwMPRJCMFd
	Hd4RtFidsAhh2YXGf/fXUYdN4hgpRUfhUnmkB4rR0w==
X-Google-Smtp-Source: AGHT+IG/BAgOkHm5XQDhsD/Oh//+tZl07HXSnzMaYEHIcpqsC6utQkylOcfF3gzZbCmB+Xpb14oXDYXxa7SPcDUJumM=
X-Received: by 2002:a05:6a21:2789:b0:13b:c4a8:1a68 with SMTP id
 rn9-20020a056a21278900b0013bc4a81a68mr3584038pzb.34.1691695736491; Thu, 10
 Aug 2023 12:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103658.104386911@linuxfoundation.org>
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 10 Aug 2023 13:28:44 -0600
Message-ID: <CAEUSe787p3uDD9Q0wq=Y=PY0-wLxbYY8oY6T24dhm+qgK1MjNw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/323] 4.19.291-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, lyude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Wed, 9 Aug 2023 at 05:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 4.19.291 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.291-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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
>     Linux 4.19.291-rc1
[...]
> Lyude Paul <lyude@redhat.com>
>     drm/edid: Fix uninitialized variable in drm_cvt_modes()
[...]

Two new warnings are introduced on x86_64 with GCC-8 (defconfig):

-----8<-----
drivers/gpu/drm/drm_edid.o: warning: objtool:
drm_mode_std.isra.34()+0xbc: return with modified stack frame
drivers/gpu/drm/drm_edid.o: warning: objtool:
drm_mode_std.isra.34()+0x0: stack state mismatch: cfa1=3D7+112 cfa2=3D7+8
----->8-----

Bisection points to the quoted commit ("drm/edid: Fix uninitialized
variable in drm_cvt_modes()"), 991fcb77f490 upstream. Reverting makes
the warnings disappear.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
