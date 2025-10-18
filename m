Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E40284883
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760781380; cv=none; b=Breuagr+pR/66xbqSR9nR8+oNf3JXCNiJQ27nbyToYnWtvI9L8Y29OrHCsfGjtOZeY5ss7yt4ccbls65Sx/DCGyQ0Gjmf5gxmZuNJV1PhO10sIO3ZddtqCDzyLmqkjBulpoYaoJAx4GRBeQ1MV2mOSenCjK9dDXvCYgmvg9NAJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760781380; c=relaxed/simple;
	bh=scF0EL4ZrQ8MG0dfR6wkjGh51GNi7IaZ4FTFjOLlLJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gfImwSsVaknT0OT9pM61R+YTKDezkaX6Z0IP1l7IWZzp2iCgnY7BbRmxtZO/vctfPNHd6HYMYv2DXMhhB2BthPkcF4oefN0MeA0hlFntqY568wsh3ycb1L7Giw/5Z1GQwg34zBBUbYMMWqoSDKRgdac/JrFd6A8gYy87JETfbeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H3oyewWh; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H3oyewWh"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-57bd04f2e84so3351872e87.1
        for <patches@lists.linux.dev>; Sat, 18 Oct 2025 02:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760781377; x=1761386177; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FG8h4x80hiheaVlFkmBnjfZS/77H5VFbiYTB4d4lcjA=;
        b=H3oyewWhlmgPPorSjpkuV/bgNeokUqfctfSp7WIetCFDS1Yfi6Nd3f/rMYYSUjnfa6
         7pQBSFabQ+PX1sMFND+yxb/j/3g27fV8Ztkw4mi+0TJewoiUcJvjSmhO6bh3WjwHGBDT
         zmTs7MMPbI/fARx2SyuC5j5rQeD+PsgkRIfEAGQdCnuusHKrn50nvzKkoRQnaGMWhoc7
         1vXOWlepSazgL5u9oGiF7UDoVfYEgxDo2xpYvJqQhZVrwe9S7DDHUSi9vV/49rxXCDGd
         da5aApdXZr3tFnU8vGeIUdxkR1ZSafum/USk/MOPLEpWUp4907PZDiMTfsEJBGqfU0cH
         oStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760781377; x=1761386177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FG8h4x80hiheaVlFkmBnjfZS/77H5VFbiYTB4d4lcjA=;
        b=MyX2wcb4bdFu+QCwj5W3BGb0OQT0BemYru7WArwIqG8vHrL2cD3qCkUGH73zWvrlaF
         aqkz5MELyEXH+Rg88uNxpP3kvtBCC5hY9AzlHlTts5woB7MJEyhprkaldbyrbPvJoYqe
         jOnwZYFKRkmQCck/OsMg/07RP9pEepysSR6NKc1szywxgNVZOyHS6cKaNav/up9+0uKG
         8P1DHJAkTqqPnJtQWSc/iP9XH0E15mEE5hdoiI0Rvsif6AogGbqw1yEOViF7db5iJFdv
         qN49eXQ+ayyFW/uT9sz6Dc2reB2DgCoS1rERdcpPQY8ak4VHLZMQ165zO+A4BvUlSe+n
         4Oyw==
X-Forwarded-Encrypted: i=1; AJvYcCU1N7QgUb55DMqFWjAfuLjOU6Vson4EixMjRupXbRbe3XUQNYd+WqYZfuf563M/788cQJtcIy2N@lists.linux.dev
X-Gm-Message-State: AOJu0YwwJteJbLgMZ8Zf2mt0DmSsnD0i9ovBCH/BKG9fOVi06Eq4pX9B
	Y+bcqew1Uu+JRQWzTK8OoohRZb2MexpFFmryqS5/SKmb/GGOdE7cxF1yow5mY3YVq+k1J5UTITH
	Irc+nIEoFaebfGlVOn1LnJwSdVeQXsqc=
X-Gm-Gg: ASbGncsZUmx5MLFa15ETkl1qT/nnSnaoOQpVyADaeTRGvu727yva6LhHcJUyr1w85Ja
	wTc4UtdH7aLMaiCrno2cYYg4oZ3eX4mXbZY3ai9K5diLvZb27CGL8WqjfAf5wC2aAYQbtFdV35S
	hKA3Kx9CF+YLgJ7PlLcu8JS+0OgiReaoSx87csI9JFj9smq+1tdsKzMO/38FXV8mlYvYm97FolQ
	EBTorF+Z1V5jOb8kidvGVfHiJ4Nr6jpmXTG+Wj23y89wGfNjT2LSROioF7kERKA5qgUMCk8NkS+
	pYL2WprQxyaY1Dqa
X-Google-Smtp-Source: AGHT+IEKJ5y6YF95e/034EqGxft4V8xi6FgMAhGq8nqr/x73Z61EUK919R7mXNOGbOwgly5qAy/ORYIiCfLVfCja/8Y=
X-Received: by 2002:a05:651c:1989:b0:36d:6d71:4ec5 with SMTP id
 38308e7fff4ca-377978ab84emr21143131fa.17.1760781376848; Sat, 18 Oct 2025
 02:56:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251017145147.138822285@linuxfoundation.org>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Sat, 18 Oct 2025 15:26:05 +0530
X-Gm-Features: AS18NWDmZ6tjsEYEhc3Qxf_b1eBqwCHw2ql60itDmA3aRy_0TfbbrlLraB7y8cM
Message-ID: <CAC-m1rrkfLXrBtvvpZf=dBnx8B2bb7O8zZQ8xx_1mA5LAM88Sg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hii Greg.

On Fri, Oct 17, 2025 at 8:46=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.54-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------


Build and boot tested 6.12.54-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without any
issues.

Build
kernel: 6.12.54-rc1
git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc=
.git
git commit: 6122296b30b695962026ca4d1b434cae639373e0

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards
Dileep Malepu.
