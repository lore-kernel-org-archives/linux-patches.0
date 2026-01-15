Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA853191DE
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505792; cv=pass; b=C93lSJPhVubae1k4Jt99K8FK8B7RQ3VNj/FyKPu+yVUS8O1WpEC0ICtKs9rcvz9atcNyVqbCeZKtnMT893+mvO9R70lWwof23zVKTIs7+3J54/FhELIYVGP+HMVo2REU72JAnKCJci1IyAsKt26CZUGgQzbcLMt5D3wCQvIW8yA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505792; c=relaxed/simple;
	bh=XiQU9ZDChgsS39EIlNdur2gjWovxszQJ1rlo/pmMEjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SjTcTfUfLWEwOpOmoR4MAmcS7scjYPtLbxZiz5OJrxrrJGMUMmBwW0YUG2OSv5+d8WQv3PaCr74GMlHzQjGZunNi51t5bhLPjTM1txkG9MJ4n6iZCy1KOJnDTXoDiVH2a40vx9x51vvl18edtfM4RSZOqDkTztjeVOwlV5k6qik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=JcBDku2d; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="JcBDku2d"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64baaa754c6so1965203a12.3
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 11:36:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768505790; cv=none;
        d=google.com; s=arc-20240605;
        b=dPyo9D9WyoKSN/oyqjP8qVqJxn4B3X1lfW1ucmD/NlzCZZj/UBOAWh18q6vS0iby/4
         tgjfF4RGkLnF1SpHZ9/0Hx9uphyKqcYoAcWi+37adiAP8ALtZJW52q+/KR5ZQWkRNPDI
         IBBfpB3RVDHK+DJixkX3WJ+HFGO1PXuVORnMFolzGEQ5E3dgREXgsn2I9M0HMhP66qZr
         tBLH4mdfp9oB6p4sqh37s4P7b48f6llaVMfZ8Sg8SMONWzZoJGGZwAvxn6bWt2z+yc2s
         KNrwVvnxaXp/NSIeDy+YkWwiOq8/fgffVF+g23Kb5UfftWjQr4EVPzKl/o+lJQjxGHYn
         NBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OA8pnSGpkBBg2tyKEwAg8tDi7u8iC/ssDeQrqAUXOSw=;
        fh=/S/vStHW85nBlpBjuI9rZDW9IgjO8Rjai8/bBBmwnqo=;
        b=llGbmEyU8AtCcEZ+g5B+VYmyyKhfhUc4r8ftihvqMAhogWoD3uRAT8v1GsI92Lckp5
         dXYDxTohrqpGqyU7QnAFQK7Qm3fpmKEshwpmfaXOGydQ5//wRnI1lcgbp8biC73ANfRZ
         5KyjuueY1PLcQYh8aEm2x7MFLq/F5uubCj/H+Q+kCZxvQXpllgHj32cZUh0uRDblsGuz
         yp7uLzuDZQmaNA2vFMsMFnbiDUIQeGnpmRatVI2wzDLAEJjx5imSPq64iwAc0YKDz+7o
         iaZyEouKvM1eZ93MH+n2NPvBbz0r9nRhCSLdKOgDx5pgilG8yPvyjS7WC6FPVR3HEP3X
         sOBA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1768505790; x=1769110590; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OA8pnSGpkBBg2tyKEwAg8tDi7u8iC/ssDeQrqAUXOSw=;
        b=JcBDku2deCtYTf7PlawGB8oiOppyzD90UhXNcELNkbCMpgUt9s0T2l8ZQGJToulDE2
         C5xD8oCo6s/YpJXs284RQlabtM7UFqGfwDroYz0TYje+GkJqeOD1/woKNGQgOmHvkUc6
         6vxsGepDiQ8A/wzXbAmtiIlJeaEvwgEWNNJ5QeHTGRJxDDgeyhDdLapILkcLNVTtDLmu
         HqjUiwONRIV3442uaPzncVmcof294OPwG14zU1T1BrXX8YBnvI2shE14KRTgAZoILEyH
         1EJbh+xUMPrsKhNk6kNHYfUdVWw9A6WAmgimtEYLK7Uz/bF/PDCVSyK7G3mRSmR67haw
         TTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505790; x=1769110590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OA8pnSGpkBBg2tyKEwAg8tDi7u8iC/ssDeQrqAUXOSw=;
        b=l73ymUWkv3LrTLNk9ZfNKLxS9BwKO4hZLOREBSz3eKSIxATC7gpuJfyJQf5Nu0aJiv
         b1rZ/hzcIdpumfxyRqXItWKtarghoGHIry2ryk92L7UNnpuj+TFjRBqs7J/X5+s2DnXs
         ScNXXinJWouMhz6PvxlmDBQnhAleWAqHWHmlDmDnQwvSdmi2fjHQ3fHFrUYuA8xl0sy+
         lbh9Q/Z/8xVgsuaQHK0gMQPzBgaUhfeEuqkqzNsNnaLHIPE2PX4n/ohvPMfZg9vNJEDf
         nhLmJL0ajoYlGGdgIp2AJp+qzP+4IoBAYprWSVbS+poYmMoYo+7EzYvRVWssREELhLh2
         RCIg==
X-Forwarded-Encrypted: i=1; AJvYcCX4rK2yjqGxRwqkd8Q/lXmOT7mO1PBy3uSt7MCeRzb9C8KY/BN8wtRkFILD1i+XsHrAsj0/bqli@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3PAN6ZD2u6upWW8j0sBeUHrGmN7FdLNKpGx4zowk5dr7StU8l
	5P3gbPZGQSeNZ9YLJtHXcJ0bqAcKUaEg4outZsd1cGq3C9HQyKvvlHSP5bUp8PPHM7mKy8+z0+8
	vh/u8vyNAnSL+DWoGK1kv9b1cxUlTwNdm++r8VavAPscvRNZsDXi1CTIQOfqe8Q9J1MmYZwdzr+
	EDLV55R+mnzaDOfBFtPNsVt3giPAmk
X-Gm-Gg: AY/fxX7GLOJn/Anc6As8v7F39GQtpT+sadd2X7JVKmXy4E/tuPxdY80yv0yYCN5nxMk
	WYA65hVQyQO55XEOKAsqTcLKdZvDQhH0u7a1sApzmjmoHdqK9zDjPkgHwDNlur8lMo9TScrMmpP
	v76oB9YA8BhxANvDO9YCcG7O758huXaKRtPxx7ANZG17NX1ARBF4TpvfyqUfnOFEHYoLNYxhW1K
	BnNhb6PDf4J6MbpEJknrg/UKToAi1kgDCb+ym6n6BHTAcL+sVYENZe6SrLlDzWyoNAxbf3MrwWj
	S/N35Ccu+1pkB20uyQh3+Tl9WtORR93TeBwvfxc=
X-Received: by 2002:a05:6402:1ec2:b0:650:891f:1c07 with SMTP id
 4fb4d7f45d1cf-654526ca179mr489861a12.14.1768505789730; Thu, 15 Jan 2026
 11:36:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164143.482647486@linuxfoundation.org>
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 15 Jan 2026 14:36:18 -0500
X-Gm-Features: AZwV_Qg9AMTX8q9-yVkwdpHe9DJ202wYjtxwKtFQxf_veZlFvCQoozqtWFMtgrc
Message-ID: <CAMC4fz+yyCbgLbgQZpP2swkqeROjaz-xyqyPf+DBtWOLGzieOA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
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
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Thu, Jan 15, 2026 at 12:11=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

6.1.161-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
