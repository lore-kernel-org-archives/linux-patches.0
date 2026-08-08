Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3CB3CB553
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 11:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786190309; cv=pass; b=bxeyWTVTFRAgV4aponeZumYgsNio0z8RrnluqlltRM70IvxYyXavJVJ7aT58FrGALaYEywb08AGPNyLxUK9dlRNF56JkBqJ3py9XV2cPx4wIEkDePwW/CmRPZhIKiSG7WlvjHP3IDOAnJo2Xa5z9ELgk2s/BlZbwTYqk4W2XBK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786190309; c=relaxed/simple;
	bh=0I05yqIJVobCKPpNehwIbOT5UR4ceGFpLErIALuaidg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KDmpGYG4PyMXp6RkBTMKaeJyTaUyl7pJUC1u+npzgX2l8IR3kjOio08nsZLnDcmV8kXYbzarUU4qgyBcQau4VgUyGwhcu9drvhfDov4WHanEY7IuwMOPbyO2EjNU/g0VH5UKOn0e+uITBF5fi8n8Eo3xRktaiAHlmF60icl3nBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=nAtRXwcZ; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="nAtRXwcZ"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so36643866b.1
        for <patches@lists.linux.dev>; Sat, 08 Aug 2026 04:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786190306; cv=none;
        d=google.com; s=arc-20260327;
        b=U0hYYwTYBxMlpBFpTTEWh3f+8QokK3Gjlr4Gv1oUlGHdY0AzHAoqBR8e1IitMYI1d+
         0azmn+hRFQGm+JclopoxMucZ7+yDPSjA58zopGnvKR5bXWRie4SGppm8+zeTVzKWpzVK
         kWdlR49paGN+2vx7VDBag1FcxWc8s7bbZ9hWjavYc5BjMXWzDSKDypbzToHyodH4d7Nt
         JMuaxIDBA4IRdr8KLK9LPHrdEVccK6jzzMvxCand1y2+2TqofkvwHIsHbApeNDSH3lW0
         blNM6oBqtvzHIfFUNI9eoY7vWbWlQvc2svEWXS9Z+Gvair80A4eP9TVWCCu7Ki7tjQq9
         tNVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wFLOC7eT/c7nh4VUjcAPuBvrszC9BumgNA7gF5Zy1o4=;
        fh=davpnf/SRqUHTojQjNpjt53nUYzyGr5b5cmX3wrDpf8=;
        b=LPM8Fg5AwWQ4qOpiLWQvV65eBimgbQYAcJLBlKQazdpOxgXXaCHhmd5bwjsclUgAUv
         ItkyROpXsVe22bWgPEyQWwmm6qletDQ9ul1Ip/MCe8wOER9/paH3mmQeRMG5wYaKK2QY
         Mkk+byIc9QpjR1cWo57rM+K6tMyKAp2hadkIq+/Y4Jd/FERM0SyfrIJqyO9XcEpAX4FI
         xcnkrapO1xrbAw6i8OP0oaBVyYIibnYDorD6d/66UU/W52dK4/pP+lS9rKgMYOz/IWCy
         X05tRvNe0pJKI5pM5xWIqINSQES3SSbe2NGI3PQIHLJPLIghmyVm9QzOfR3iH+mkoP5B
         wY4Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1786190306; x=1786795106; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wFLOC7eT/c7nh4VUjcAPuBvrszC9BumgNA7gF5Zy1o4=;
        b=nAtRXwcZB6p+nGj5p0pEiw0dMBzXui2fDq6FaWyShDcUYuxcf6an9RQ04MdeVT4OfZ
         4M0NJqXUPks9LrRYGnbmnuPlSS55DqfaBoqMPz4fxKLh1CCcYzDAHUWihs4ywFpx0+DP
         tacFh8fKTpVZOfqTA+xgi/xX1dBcBoo5YDxPduo0aNa2E1VOwIhgShlfNJudFGZI37H2
         95HzxXSTXsipp/xB3eV2zZ9mur+s7py/vjVbIP2doImbZtiNq1D6raxl1dX9fwPBkLOp
         zA1opaEuAMFoFzHGQt+nKFNz/tq3rIB8nFwpKxVXvJavJrEx0cyoZpDONlOuBrXN7g1k
         B17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786190306; x=1786795106;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wFLOC7eT/c7nh4VUjcAPuBvrszC9BumgNA7gF5Zy1o4=;
        b=ja1Eqhk0kYFy2jnWwZrmUV9picO2eOYNrVGWLMxJLGZDH+nPvWGDYNabCNX1fuZ1oe
         Li1E1BtSc9MkbLxbogMSfAHWefDlKcxUJ5i5r/jc9Hjhr98njVZlMDnKKVnsc/g9RK04
         DfdkH2+TrBzetdARPact/DB1/YRbY5S3R/jYpDfb4Ts14+cYBVGYK+EckG6c9khpXstr
         5HmECwRGLL6Ss4vKsdiD0Gtcxgb8/eqBIKf5kHBT/vlDKNX4GgEgGpYT4+bj/ha5rp/U
         rIOESlHEcqRQCJymxGa7aqvuLagIhh+sFCun2PLgUauvRLtfb1pIuWCGiZDkXhRjRL5j
         XA6A==
X-Forwarded-Encrypted: i=1; AHgh+RrSJkhw7PaMMrrxAWNZcCIZBo804eB3U0dHCJZRSEGdL98Vwe3bwyIDpc6Z+v1Nk+Eww7cH6snK@lists.linux.dev
X-Gm-Message-State: AOJu0YwqqoMBcHgmAc+cwes6T4lAstyJhmeYNV86dNOZEwKIxMBjSGuw
	PSJQPmhzI3A71UdSVJ62cfEkJXIpeEOtMsEv0MgV8ggSRKNv9Cw+t/4fdXbdZWhVCFExBdOp8Xm
	U4W+aaj+L5VyXEr8Nz06JlseiEkc4FF152GphKaMpVw==
X-Gm-Gg: AR+sD11IpmNRrvWzg8U/PMWEnHw818JN6wGyRrC6K2IbxPTUbr1UMZ75JFkvg5Rqs9+
	OP+YjSAlVY4TlsFgCtO24o8HOqG2dYQtTDmDSFsu2J3PfmkoFv+V2z7AR0QuXaWXAIxbFphagsK
	6nrGcDCh0nSH7mJPloAI3E1u+uxUbQi41QqQ/3GOOxVokfKnWfu7zRrBKhDteiYXm1B2SGkDRVc
	a+dleS4fSRfVfK8BPbEzwfxYTh73S/5HCrrR2D+PWpoSP/Gn3ewxN+VRnF2C2dx+JQuKrBjCB4p
	PiymP/q+hgTdx4TVHVKcDm7n0GNKU47FdHUgv9uCe9jd9FT59NJTP4Z+IJjOFzPJHFYwiUnOpZf
	HbOiAGraODCIP
X-Received: by 2002:a17:907:9623:b0:c12:e178:9e68 with SMTP id
 a640c23a62f3a-c2073364351mr755553266b.19.1786190305489; Sat, 08 Aug 2026
 04:58:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807143428.008222056@linuxfoundation.org>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 8 Aug 2026 20:58:08 +0900
X-Gm-Features: AUfX_mzpwqkgBW1n_k6fWbBqYsVTji7LrFJ3wK3z4zxHOxmeZUH-tab1NrDfySE
Message-ID: <CAKL4bV597kbF3OgUxkYESiao8BksS_RYH_HhCPq5tRy0_1AeRQ@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Aug 8, 2026 at 2:15=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.1.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.8-rc1rv-g91bb55d1d234
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260728, GNU ld (GNU
Binutils) 2.47) #1 SMP PREEMPT_DYNAMIC Sat Aug  8 20:30:10 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
