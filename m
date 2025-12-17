Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792C838257B
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985358; cv=none; b=H/qFYIy7By/msdRc8gWoiP9OEkUF+kZIiv57Jix25W0LxSyair07UOJ7a4QUxyk9bsYVwS47eORgfno6xrqLlwLoFD2s69F32svn1DVd12i1EFMICUPNueua9GaqA7PA3G8+OUMetWy4CYcyItqLvslZZhfTjVxuNRmAweD8lW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985358; c=relaxed/simple;
	bh=tELgiPFUr7EKhpczx0utp4JjfB5cbUqERxMtj+15m8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jYazj3U9G5VeeleUo3jV11gxrfacz135fp1zhwlo3MJBZ0n22k2sO71kSSZ8F9OvKOFnV+Ixwxr8/9yHw3gQUrVYHO0BF/vdhisJkcUlydo5tNxnENoANk0gNPydkq6J3N7zpdT2WcyzGZhpZOQvHQvfEhnCb3mLpt7BIKhAYcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=VpNlFARX; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="VpNlFARX"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-888bd3bd639so7355506d6.1
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 07:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1765985354; x=1766590154; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p7X6PVsXMUSqSNI5/s5CVcqmMOVizvbh7cL73ZOmZ7k=;
        b=VpNlFARX8RK9KnVfD2r3xc/KRYR4phZBD+co+k61k4vsRg631zCqg4KFqP50MlzG0P
         1tX/fHFB6XY5wagO0yYWcMO/8qf1tun0DS/KFqkEqQwUn7WFD8TdCwzagL0Hc7doFCZN
         ckKIShBtyEpz4H+TRlyDQFXXkFHhy4XRmrtKOkjf9UvCSWrOoHq7ceCRX03jARoaXR9c
         tNmb0RpfgEZKwfz4K3FZwimar+Q6o9rEsHBy9adu1ARjTc/kOCBpR5ZQMcMKXIfMJ96b
         iG24IRf5dieBBdo/FW9RfYo8y83PhRy1BG9k3mkxHgZ8viFlTFgqPP8M6WaBewVO7JTA
         9uTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765985354; x=1766590154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p7X6PVsXMUSqSNI5/s5CVcqmMOVizvbh7cL73ZOmZ7k=;
        b=gQx8+fWxTUnUg069GbDADO+6O41mjJ7GaG4BiAWrWzWelmZh+YNH4UbYgPOkdk/D4h
         RptcmjyCtIL4Nw6Hh6/oes7PIfOfhHWQf8n9WgdqnscMR2FbfVWPgy4XNsfXRZwUPYMl
         zgONQ60GPPpDpLCA7KPJIm03n/lR9Z1b/tl4FfooJTT3+XexzQFydiJSLMW96EdRwhUp
         1X0UAWgS8h+SsEhbELLfAf96waqP8NPewxccB1c4xu/5lCfIlMZrCWMidAKM8Yj4b4C3
         DmeeFSoYgpQ88VI3vHHuMN29tLW/dBt+3OgJ0HlXp13yxoGFlBIz+2rHEQr+GLyrwqus
         Mjaw==
X-Forwarded-Encrypted: i=1; AJvYcCU8iUbVmj9UBkwC6IaVzjKxNVyQ21ih7aDIUQ8IOBv/b6+An6meIkWPR6UxE4v4NBCoZcv33ck1@lists.linux.dev
X-Gm-Message-State: AOJu0YzcaQK/OeknVWEzxaHLQ6yTZiifRTrOJH71h+3gAb38x9X8sWuf
	uQu91j3cROMqdQLLWnHNvyIwPwVpMh0/HSVWRGzaBr/BZC6V/DZf8LXDE3dtcEzoXdak/EyPBhM
	oS1g2ejct6sf+wAp/QHcEUHkCyVdbdbWiy+clN0ch5w==
X-Gm-Gg: AY/fxX6VA71iZS25j13lKCQtqv7i+y5iK82XszK0Zc9pmAGiAdnran1fT2QRyvFOzr4
	9pUt4YEhCzccVhN8bMh2xdRH6X97qlIUVE1u01n3yV6YpUcZPE94WrPI3YGy+8yfKd6lBYGKraX
	2XW9PvagbcYY72IA8EteTZCGs1SQ/5jOl9LOZotWPyfXW86Qv1hGWayW6pInIkUb+TLGirPWo+/
	wvT2OGOYvadg+mX9pyXTgZexgmqPePdG5dcD+HXAGajKoBCoOG50upFj8Z/X4twcLXI36H1
X-Google-Smtp-Source: AGHT+IGMlM80JHHmEZKn0/ZepTrbMYUWWGVgnvyInQZ9HfxUP0BsVl2Hull3yJ5jz7mvq40YAEcuXWLZqjZJdNZ1fVg=
X-Received: by 2002:ad4:5d4e:0:b0:888:7b01:2839 with SMTP id
 6a1803df08f44-8887f241108mr283244046d6.16.1765985354309; Wed, 17 Dec 2025
 07:29:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111320.896758933@linuxfoundation.org>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 17 Dec 2025 10:29:03 -0500
X-Gm-Features: AQt7F2o43WldDPgtwceYT2msiy8JqwvgErFzIzdQTa9ZMBPHuiN1N4vAb_f0Dwk
Message-ID: <CAOBMUvjkKTCcrE8hKkGvcX0AbGg2Sz3EzAeAtOW0VOx_2HUs0g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 6:18=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.63-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
