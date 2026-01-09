Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E553635CB8E
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767967525; cv=none; b=NPbctJngZh5x+ZLfswBy3EqrpOE8CPPcqjDBskfZsp4vkL0pDkuSQjlf1hxeyMRSfxWQQ5kABSNBPwehr9SfFeWyJbrHE3qZQD7BoZc9IMXDFjJu4Vi17m2JBEsCWE/DdSqyxBkCJ4ltf7feAzYDLE3vdcf4UB7mVIlqmrMOkMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767967525; c=relaxed/simple;
	bh=wx4vAWq4HWRPnv+paI/7ZmkP7FxxJlu+civ+LVmv6WY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bVBvUB9NvqSB8rLnrGloptMazea9CI3b6/vhiVMcMiVg+tRb4qK/x6WOdUcR9p3xt4eBHa4ZZLqe3S/8EUvA1CH76+dlFai5KbZyoMsDrKJ2AiBkz3S5QDW8CtopLjuISUR39/Rr+sj1HMtEUB1NHvBvwnjOrYSom6XUMr1Zm78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=AiwDZs1j; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="AiwDZs1j"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65089cebdb4so5052084a12.0
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 06:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1767967522; x=1768572322; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHeZsUsxb8pqM5+6KSuIQpRYBszdo4M9nQezvPEaXNg=;
        b=AiwDZs1jNeBZg7VSbWS0Ed6BpgoVDzmn42y/iWhQU7YXFZhmN99DpDfXK0SXuV2HCb
         o1p+JThiZ32jWpqqlYux8JglDf97ON+8lwULVCtuMHOQOlzM6VzimK0J/1DMk/Le6ffs
         syNtH7IhcY277c0IZuas2UPBFxO17czy6xQH8Pm3trMQw0HZjy60lm8PEH1JWAiY7o9u
         WPGgnDKlJq3HvFFBPDpzWPzAlmrrWPDZ4iycJajUxpTTUC3RgkzfzyFC12dUrHxz2wtk
         SyFAu+CdWybzP52zyfP9Fr4BipxZn8Ke2eN9zCGAW1i0k3GkQDRJuH6sCZqjoqwWVgjz
         uqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767967522; x=1768572322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zHeZsUsxb8pqM5+6KSuIQpRYBszdo4M9nQezvPEaXNg=;
        b=m7hKNHEwaB3JZYqFJ5hFUhk9POm5SS+X/mjnFFTcTonYUKzvTSDIPsDngdYxNcrmd0
         gaS3srcLOIJZWPc12ju6jdRB8EH9AGXuXMVIQNWTnXnmhEDETLlh4RCO8Tki3HTElXkl
         AbpeU8/S96yGhHBcKTxCW9wlE5P8hw4UetT7T0xXliQJeG6DhnvtH+v9p6zhCd4HGw41
         eOwry7SaxaulyzTu8u1+pucqffC2jg9sw9PyM2aWEwkemDqKmV+hUFyOJ5WVFAW1g9aS
         D/CkR4bQt9X/ol6e35MKn6XGiUGnWtkgESJ325Q7d7HYdFsYwEwQ6vVIGYJpWKG1C3Mk
         F3Rw==
X-Forwarded-Encrypted: i=1; AJvYcCVhnjSVSuAod+RPRx82jHZO6JCVSNWjX9X4RsN/PEXvA03D7neQOBuEEPxG2Hf9To/DID10c+p1@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+iNgNImJgOa9dHajgTAYNBsemGD9tH6QS0M6Mr1saCM2Nz8x2
	UWY7GGHSHC+mwKB6h7uypIp8eTHHFZj6K2yqmQ+i/9bCgkBtWefgIEUU56Sa89qKRtyw+PABarm
	7eoYgbdwJj3TGvDeNM0FgCNvglmjciCNH8X7zheybvHLsGm1lYAZp3M7XFnn17eidC5S0IligL+
	LjE+t2gO0pNCuBFO4ciz7q07Ot7uh6
X-Gm-Gg: AY/fxX6qeyoTNQv539PWlyQi2hUUo+KKTndnGVblgfpZAv5twDGg4CoktWfTQ7VkGxj
	BK7skPjZdURChoU8eKpVf/MZXyXfRvC8rHNKi0Qv4ZnvrzTSeyw9nDSfrVD9fjjCfvn0rasUIYx
	BXd/mBfeu1b3vpLq2PMVYWqUQCveNiEoaprUNx0K7Z4kDH3e6AvvZl1OKEXl/t/b9lb8IW3alqs
	OIqxlMAcTeihbkxeHjJiqD1zzEKV3HOvhclzGd7FtFJIgmraKT1thwzA7jpvLZcCICVKNZrViHV
	iFoXl9WG7G+3bINgDelSwNt3s86Fopnkto3aRqs=
X-Google-Smtp-Source: AGHT+IEI/djWWBT7/VsY+1PsEGYxbDvWFPBavsKV+H+zDI4yBu1Iz0hEh9i74ky3XJTniZbaXUHwa96Js+M6bQXbP+4=
X-Received: by 2002:aa7:c705:0:b0:64c:69e6:ad64 with SMTP id
 4fb4d7f45d1cf-65097e5a118mr6730160a12.24.1767967522257; Fri, 09 Jan 2026
 06:05:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260109111951.415522519@linuxfoundation.org>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Fri, 9 Jan 2026 09:05:09 -0500
X-Gm-Features: AQt7F2pf1Gj_cPAF-AJJHCZlCWO36ykXfYS6WUbDLNq5yrZvTtLi49NZBVKYFk8
Message-ID: <CAMC4fzJhT4Mwao3=9TbAm=rWP=zfGJcFTsmAFCK=p3UoqGQTcQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
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
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.1-sladew)

On Fri, Jan 9, 2026 at 6:45=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.

6.12.65-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
