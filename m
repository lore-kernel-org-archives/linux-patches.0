Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019853168EB
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 19:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505638; cv=none; b=l9AMLkWhPn8ZOCPIEh+jWOZl8zqDgJerp0pyO4CMvQBnlPgpMAXpk6XUO4NvsT1cqBAQ36MpMcjPT+cg2bcCfbMSzGuLzTgq6My/dSIY+cn8quemjCcxTqeWoKCzwJzKJ1EDLQ0UfvIVH1oLcUjHyp/b2l1bCVeGy3NfVShr/pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505638; c=relaxed/simple;
	bh=TfAIki2k3fkfeWZQkIksj+3Uz8mlvUNdUj5K0Ie8HBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E10uVLQJNCM1vSSIdWoQd98LkCUty0Jw+fO4L4nUfdkRqeYdBZa7EVvhBJSaKFy6z4aZBdgMsprN1fAZEmszHW2yGFSV3VcUq8hG/EmGYvK1gUz3XfdnpH6G5TfwkSptx/flrzUC2KjQZ7BxdspDAKzdgerqjDIPe7Zjn3kcUR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=GeiMzNdI; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="GeiMzNdI"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65089cebdb4so2102662a12.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 11:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1768505635; x=1769110435; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vX2VqowVk2rXc5DYzGPI3ZG/fdC9NOPvbdRsZKJoVN4=;
        b=GeiMzNdIkjeimNg/NZCKewiE66m9dpQq6kaedykczwbz1DYh8aJC1In0FsL6cA4Vxh
         +xwhrCV4IRVvJ+FKFdSxBjnlTxyi0l0qneMnDKizXZMS9LGSb5IvR0JAxW1dnN6RdjXs
         2v9+NxRkSx6oeXOCEgLLABloJt1fhVc61yukgmMjRqOB5dVwu+d0uqVnqOkZODZW0RvM
         qRUZxP2T0fIdLk0g6PD9ZYeVHLQyLwk6tU6N9aQ25mjXrq21D0ORr45gmGs/ZfkT7Wtx
         VAkmtISzspyPxyIRYoq0LdxTvusKRUt9W+t6jsgcxEtBxyswaPYVWs/tT2jX3zGl8BKY
         AflA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505635; x=1769110435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vX2VqowVk2rXc5DYzGPI3ZG/fdC9NOPvbdRsZKJoVN4=;
        b=bfoZX9FvYuGh9e5I/gqrWHjBO1loOlIbnbmJzS5IG7p/GlbRndXQKKeocJq9057Izc
         TZs7Ix4k+r0+YEyZQevJEeT8uqdmVgpBGTlUgBZwY0PaPGgZJJpelvxKX2SG6lRiotkW
         Gy1UvomZhc2Vfwh5ULiCRYd9/ajsFaY7GZo87OquXmWg77/hSXsvvlwiP2bfnlDLUOEQ
         iZc0+WnILeeU2lH7qtlQH5EHLrQtxFey5xPklTFnd2cvYBv/rSAy7wZAQmWqZOaOqZZa
         SVsdU35IjVeC2kwqhK/iNx26+cAoFXa/poTPbg5ZL8Gjs9nI95bPOoolEzxD/K8/CMJK
         nqJA==
X-Forwarded-Encrypted: i=1; AJvYcCUz279R8MizR1uc9KOZ6zb1nW0anZp3h2k07RSK4ju6Rq2e74gkUZlJuUiWMqh8FqkhTWTYbMjd@lists.linux.dev
X-Gm-Message-State: AOJu0YzGHX5ggGEueRSGRl/bYBo/oT4cEbXWE+kR7K6wmrBiZZIIF1/Y
	SOoJHrSmKw2jqp8UFZ2JZeRI5KaluO8/cdypVoBt2dY7YZmIZgqroJw1IXuPxVOYEss/M8d2QbP
	H2kz9NuyzK49aCzrOqn3dfah1VFK4wdxPoXDZat5Iy3sxHMkMXW8GdzoZUcBXtDafVjPgkAeNr4
	3v1ICQdWzznMhM0X/dWTtBV80TIyeN
X-Gm-Gg: AY/fxX4PNXBlv1mskMn78laG+Lx24pJCpr50yNPY5WaTxLDtXZGZz+JlPqlgaC2RCxF
	vjcHKk1rkYzuz9Bya7H2Pv9xqRQ6grfAItL7YTNpsxnVQMksKdf2BO3l68AoBX7uUjKGd+sCwtp
	Yidy4N7AfL9tvhZPY4+z+ifmiySVAMJSDAiwxKxoOfg/Ovcf7DNLwu2ZjdR+fmvLXVfI5avA9kU
	mgeYEgbixv4r/aCW9ybXymAOBbYjPtSMiA6xI9VDo3y5G/gVfAFCs3NAWcXQKvs9ZWdVa3QVwr0
	geSe8czBWwSF0KlcI+czTh1r0u0U
X-Received: by 2002:a05:6402:3547:b0:64c:9e19:9831 with SMTP id
 4fb4d7f45d1cf-654ba1c92e9mr163966a12.12.1768505635288; Thu, 15 Jan 2026
 11:33:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164246.225995385@linuxfoundation.org>
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 15 Jan 2026 14:33:44 -0500
X-Gm-Features: AZwV_Qinxb9tW8FAaAE_f5qam0Gp_E60BDJeWgMkZi0WL4oFCCYn6aUoPDRuXdc
Message-ID: <CAMC4fzJPjrv9L7B+PptArKpw4omUgMKw6-0JEXLd0_-Oe83AEg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/554] 5.15.198-rc1 review
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

On Thu, Jan 15, 2026 at 12:14=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 554 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

5.15.198-rc1 built and run on my x86_64 test system (AMD Ryzen 9
9900X, System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
