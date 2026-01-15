Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1B9320A1A
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 20:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768507215; cv=none; b=qT+d3XlEnqpOhG/ehtgvI7W5+dJztU84uMYnMfg3sy0NyRmeZMOhdvQH57XI5ADMp9kQDKFB2R13b7nalitcFaLRkrPuan5wIEj+o8xYfrO1GkwdwvH7oTKpWIuPJAGiYelAmQ1YMVlXTwx/nGAyLorCHZq+B6iJotDsTMYZRpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768507215; c=relaxed/simple;
	bh=VMIsD1egwo1cLTvv+6DvzP3o6Rv+S11pibHNd8YKHgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m0rWa20U8/zOpfLxipp1tc4xcFOUdTqJgl0880AG8Rev/w3SD9b7gT+kZ2kO31019gTnEgXtLZWKEOsaGh73ixj5T0kkdEahp7D50rKcZCL4UHJTPIf2Q6/AQDESGyjuAIiFH/eBy1AA38aaDTHGbNnVTbbwwsT99gmbm7u2RiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=DPsR9f3z; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="DPsR9f3z"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7927261a3acso13797077b3.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 12:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1768507213; x=1769112013; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5v/2b9hS4lqAYWxqpA0HCoJBnyBMfO3blrngfEhtmM=;
        b=DPsR9f3zRDPtkWSEAVCp+j/fE+DwHQJs49dWhDnJhCI9ehCN276OkA1a0rIaTN8E3c
         a9DRdCDFYOrVSkmV3mz9NmkgEeYFHXpClno8DatpzvR+p5jfijV8meJ7CThTeiqdSlPC
         7AzyVvZxdctRNcvrOTzFa6sjl8+FHpN6/3dZtNzimKGcU/sRlSGEGFbuQe1Lh2RdmWIC
         JPVM5+plws7wSXTDlDz8YjPKGBHWNBxq9PcVxhRyj92sUatVNcriwU/mTwIEXwyElQFc
         VvwEKOnN9OsvAY35Be7LMoEekDjLDM6pmMdDuBNilFFLIAjkk7/RBYvG+1zxOCduBd2H
         SpHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768507213; x=1769112013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f5v/2b9hS4lqAYWxqpA0HCoJBnyBMfO3blrngfEhtmM=;
        b=DQW/a6NshHgCAeU61EHTV6jQVl8KED53UgDIdq0VRxWajXeuHymzYS9PVNxW4qQyiy
         nSh5OcBm6Er32iAC9mbYBqWNy5gvtbBLdfanAk4nihcl6gmcZjrW1R48q500S4AFOHOQ
         nWt4P3owBiomLoAH5eLzP6u7nYb/L7yUJFLxRlv/GYovPiTYAOrMMSyrt59Y+pyv4vID
         su7qLJJ350cZW06WgNXb1o47QUh9fPFk77TUnSin5b0ysbiPNF7LUC94Gh4NPtFqkOvN
         /lGobdBrLB81jGWMMpugDr311wZEKvOe1cY1cOTDQN10PRh2WPFyCjH1MfqM0VEyx9J3
         vp1A==
X-Forwarded-Encrypted: i=1; AJvYcCX/21UZwvHnIR3P6v1Ai5kr21cuYAwEniT0hVmmgSr8PPYDgfCBOWENIWRihXs/KYXqevu1A9Fa@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxkr+Yy0veHozDwtQIdcWre6faYOSbUCZiJ8VYE83JuGD1JBNQ
	wUwp6Ok/myE/fkSqp7xlSrT1B0tNQjsBQvKIQ6eHXrMb56QIi6VuDrxAERLGWsBpM6vuGq+6maU
	/wz2YKw7dihNHsp5jaViWaDQIlgk7/8fCF3e8FHf4ypmLGq3l9UfkRNo6R53Jesmvy9Cv860heo
	c+XmuCZtfpshR/+JLvTxBWaytNwiO7
X-Gm-Gg: AY/fxX44LylyR+kNQDba2hpQ7tpR39+EEtVrddCMQGq1BR23xfskmNhrNMahsueyK+U
	rGtwY7SsCu8a0VW1FdDyNy5OvCMOrZGkDF1j57iYKD2SuJzFo0hmyDLwJI0PgDYvoHZQS5WxEMJ
	aNgFssoJ5JFf7+8Osn6RqsLBxJuhyKoq/aPSiygPBoJBmPZRzSHPeE8tVDiYIR5mFhY+fQ5F6Yv
	tNP1B5nE7wh5Sz0CR9fSmHGL3TRS2ATCfROza4In8Ylu7Fj6VnD+8F1qdHqGXDeQL1iQ8WrDioL
	Bjdwt3dj/gx7t6Lvp2m8Rhi2rCnu
X-Received: by 2002:a05:690c:90:b0:786:70d6:96ae with SMTP id
 00721157ae682-793c67f6f84mr2729987b3.37.1768507213288; Thu, 15 Jan 2026
 12:00:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115164202.305475649@linuxfoundation.org>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Thu, 15 Jan 2026 15:00:01 -0500
X-Gm-Features: AZwV_Qg_JnrAlcMrroGYpyFHUDmG0eBuJ3RQfdnuXDZ_Nb9Tpz25ZcFdbDTC_qE
Message-ID: <CAMC4fzJqyDb=yQvSdUxDPr3PxP0PjMT5_-m_YPuVT9enSjZMeA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
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

On Thu, Jan 15, 2026 at 11:53=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

6.18.6-rc1 built and run on my x86_64 test system (AMD Ryzen 9 9900X,
System76 thelio-mira-r4-n3). No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
