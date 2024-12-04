Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5741BBBE3
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733326383; cv=none; b=Iyt5WYZJF4C1beRdE+1bElzHMA6NyjIt5ndtBdikGol5qhDO8T36JtJVR+wB8FaBBzSFLK18Foduh+WodQF+FFEipWn8rqOrRC192iGIhlxZKt1bNv5H4ySpKtvP3W+A9cEBuf2QDZrUrkcfLHqUhkjROcv8btdmpe1X0hZaJgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733326383; c=relaxed/simple;
	bh=WKAlhH29xEF4xdMd6IOvEbZvOJijsedbXkd9Fo94v+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6xeHZ9Tajm00edAUlpSsarJ7adElwt10whLYtq5ut/UAeE5OZggfyHfRG379UH5Tt1jgRaKuz2dPFYZ54xrCXRTB/28XRSRmTvAbQ5wwsRn0cj6RTk43H9jmZ78669zqdLGiLtBC+Bscp6/eS8qS2hpQtbFjh+HOTn3rCu9JDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xANe/lww; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xANe/lww"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5152a869d10so1747155e0c.1
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 07:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733326380; x=1733931180; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4BM7g2tnTxffenD3gAnjnDpzGPqkZZJws6+BF+fZajU=;
        b=xANe/lwwxqRNGPjJ0sSSL3vLi3B7nC/ErqWu1M4NRpW0B5uZ+O0UzF2tszQuzFpZ7s
         wLt+1BlSiBhGdnSxSDLlSzxtu7SqDIb5wMZPH9cd21bhDXaYPJsEMxzmmN6y8Cpr3Ta6
         NtwJ1Jbrmbfqghs4NV1IS+PBODzyqVImnu/+jBUu/0cXwL5u9tczKG64WUhgolXRjFBA
         q7WTPP6qHVHOSmIzmI6FxUWnhQyr7nVcX6nsvhkZwqxONmrzd1ds+D6Nn1baZ6PbIYm3
         CaeY6hTPYjRt9JK4Z/DcbIe22UmGcKW8OK/ZePujLBmQlUCeRP1plllcslw+Kpz4ODZj
         j6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733326380; x=1733931180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4BM7g2tnTxffenD3gAnjnDpzGPqkZZJws6+BF+fZajU=;
        b=tGBYvsbLEFE8ZPorkldrWJRr7Vl68+0Cl5m26TcKRt4Pf3gjJcfxjh2PmhPdXG4+F+
         GFFYSu2RxD3UoMdTv3MWpeBM8SeLYuQ9CL5vje3UUacqkHs/qJ+lJvlE/anjn/xzflNc
         Q82RYbyznVXKXKuQalTCN48a8PcFQ+JRbnd7zUCe55MBt1G+5o+Z4Q0LFOASkUAZNisL
         Ini8bV8oc5eM8zkwpdFOc6ehI7yVSLhGf1rC8HfxHNvcZqmsZUWijCNnABoKHJs0tYCI
         pY39iXhBjaILL2pcQeqO/vHdRVqmUeEMpCC9VoHab1BdcXcq33V3nYdJuRrUwMTVJewI
         a9Pw==
X-Forwarded-Encrypted: i=1; AJvYcCV/aEfRELw/mSvzfUgZtyHWnooo5uO6zfmNL3cgOTbdkwLyasG9tZuAk/5qPM48/fkI+MyidvZB@lists.linux.dev
X-Gm-Message-State: AOJu0YxXs/z3/slKfV3Uw55W2dterfE3WnJm22TP1LbB38pyue3FEm3U
	JxDFHboSam7wb/24UwYEEUPS8A02Ws+3esti9tJwAMgUrYscdedyfNWKom+fwM9QtRI9Vx2u57o
	MlkFdlIWJrK9VKoGhrsE26tARRy3W2EKEuTw5bw==
X-Gm-Gg: ASbGncvqBS1o9wEYCSRHUCGwIKxSEckbUC7ojQzabwv9McPN8EQBErqLeDI67KYLAcg
	s+GXjkgWhy0OjdeRAbXdTTpAOFwNpOig6
X-Google-Smtp-Source: AGHT+IF0RVZVCMdJkXYjBAAcJHezPOoWCH4jS8XQLyQLEPZuJ7e6SomQNYsR4Mx3bJ489e5yJU/yOjgwrrV33kHvO74=
X-Received: by 2002:a05:6122:1d04:b0:515:c769:9d33 with SMTP id
 71dfb90a1353d-515cf784e53mr6510755e0c.9.1733326380385; Wed, 04 Dec 2024
 07:33:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203141923.524658091@linuxfoundation.org> <CA+G9fYtXS+Ze5Y8ddtOjZPiYP1NEDhArQhEJYfS3n5pcLdn9Hw@mail.gmail.com>
In-Reply-To: <CA+G9fYtXS+Ze5Y8ddtOjZPiYP1NEDhArQhEJYfS3n5pcLdn9Hw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 4 Dec 2024 21:02:47 +0530
Message-ID: <CA+G9fYuDAAZkgNK4_0Y=wDcTUzs7=ggbni4iJDAPbD9ocq992g@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Matthias Schiffer <matthias.schiffer@tq-group.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Daniel Vetter <daniel.vetter@ffwll.ch>, noralf@tronnes.org, 
	Sam Ravnborg <sam@ravnborg.org>, simona@ffwll.ch, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Dec 2024 at 19:24, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
>
> On Tue, 3 Dec 2024 at 20:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > ------------------
> > Note, this is the LAST 4.19.y kernel to be released.  After this one, i=
t
> > is end-of-life.  It's been 6 years, everyone should have moved off of i=
t
> > by now.
> > ------------------
> >
> > This is the start of the stable review cycle for the 4.19.325 release.
> > There are 138 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patc=
h-4.19.325-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> Regressions on arm.
>
> The arm builds failed with gcc-12 and clang-19 due to following
> build warnings / errors.
>
> Build log:
> ---------
> drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.c:177:9: error:
> 'DRM_GEM_CMA_DRIVER_OPS' undeclared here (not in a function)
>   177 |         DRM_GEM_CMA_DRIVER_OPS,
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> make[5]: *** [scripts/Makefile.build:303:
> drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_drv.o] Error 1
>

Anders bisected this down to,

# first bad commit:
   [5a8529fd9205b37df58a4fd756498407d956b385]
   drm/fsl-dcu: Use GEM CMA object functions

- Naresh
