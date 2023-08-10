Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB66A1E1DA
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 18:20:52 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-68706d67ed9so926024b3a.2
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691691652; x=1692296452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a92NBeJNU7kmNJxtb6OxiUYppen1ETPcAG+MO1xgGG8=;
        b=Yfn3GdIvCwu2oEr/UdGSalfoJE76m9VGVWRUPpvJWnMx4rafovziTfk+ZFJ3xu6rIh
         /YuUMm6n0YNcztvyDek/olgJAfjTMwfss5mycHlsNUq4t5RBCssIg50ZtAO/yv7kvEHb
         0fqPDOV9LdJhufu2nExnkrUjMa/fhSS8OgrO4EeDUENbENeQwBb1mZQnG8IncbjYffnE
         fSpRCBsk5G478/eI+M1xCmC2UKD4rFtFgBC7hG3lRblDlmn75hOu2ESLkn/k2wxdP+fm
         hP4wt+q4NA13fea/zBz1AN+4G79PnOf8kPuyCASnelWWU/ADVHfXVk3fQHAK66MAJ7FH
         Q7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691691652; x=1692296452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a92NBeJNU7kmNJxtb6OxiUYppen1ETPcAG+MO1xgGG8=;
        b=RXJbPdVRf6kULAVUFMeyNeC077i58uBESfTxKe99FZiyyO6JMDMhBZ5hni6wxDWeon
         tnKaI7ASb1JZZpKpwYV/uOqU+sDJIb+kS8Gw7lBxqA/CgN5jtJQwLwD5hj+vw+tI0fLv
         /JXgM89X4/dflLNqtClNlclWe5fCAST29bU5Tj+tr/JHnxP5mkhWSpllDTydZgyLl/EX
         T9OiWBq94J+VJtSY91GS3OUci5H7f7NRZgmLbU7rpL9xuw2+Dh/x9xGLczP6WGWv6h//
         mHMXeqOMysqZFdW8wmyUU2THv9u67fFQYBnT8ojLOBO7IfgoieZVhcLcLY0MMycH3i1O
         U5zg==
X-Gm-Message-State: AOJu0Yw/gVE3G1eW4NGgoGsQYugGGEt9KUt1eDix3rN420MOqsIecBFS
	B1XyEapcgzuR7wp2RshkrRJBHMC8nHN1yBL6G7uTAA==
X-Google-Smtp-Source: AGHT+IF/11sgXt4jPq8ZgakJoFsFCLSUEZHUnWjift/2DZe4VQ1NGIh/RCBkVITu8qUtWOSUuQQypF/G7+VleZ6kXgg=
X-Received: by 2002:a05:6a00:130b:b0:686:2668:796f with SMTP id
 j11-20020a056a00130b00b006862668796fmr3808106pfu.32.1691691652250; Thu, 10
 Aug 2023 11:20:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103642.552405807@linuxfoundation.org>
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 10 Aug 2023 12:20:40 -0600
Message-ID: <CAEUSe7-etoOT0ox2byNnKwmLaFQAE4j5dWnO2G2T_JuRHgr_3g@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/204] 4.14.322-rc1 review
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

On Wed, 9 Aug 2023 at 05:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 4.14.322 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.322-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
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
>     Linux 4.14.322-rc1
[...]
> Lyude Paul <lyude@redhat.com>
>     drm/edid: Fix uninitialized variable in drm_cvt_modes()
[...]

Two new warnings are introduced on x86_64 with GCC-8 (defconfig):

  drivers/gpu/drm/drm_edid.o: warning: objtool:
drm_mode_std.isra.30()+0x98: return with modified stack frame
  drivers/gpu/drm/drm_edid.o: warning: objtool:
drm_mode_std.isra.30()+0x0: stack state mismatch: cfa1=3D7+104 cfa2=3D7+8

Bisection points to the quoted commit ("drm/edid: Fix uninitialized
variable in drm_cvt_modes()"), 991fcb77f490 upstream.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
