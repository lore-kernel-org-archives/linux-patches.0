Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF363A4F49
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 18:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774983273; cv=pass; b=kP3UTLT1V3nXVhvPh+apJF/TOg7FgZWPGpEpnpip+p0Una6GS3h8E6Q+qDXdVxcOjz5OGPpFbelQcP3EMGImKlLdc5pxm889tnacRE2pC6r6NIG1fQ74ETToJsVsaRYno0AD3bJsmkQYoPjrT9bvYb1HfR99/Ts/JysYZJm1HEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774983273; c=relaxed/simple;
	bh=uhzoRXxX78P/5kx2Ju13EGTvDLo7lvJcJD3Pm6rkk8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FelDJJGf5ms/TI4ixsMt5MEQHqyXYJET03jlXYVbFO0kfqOXBW0HG42UFYMOzz3nWd0DyNwtiqw1ro5ykb+MSyJ/g7c2/Nemk2pwcdsaHTpW5y42O9LFbz4zwlWJPi85Eo0ILxrvvSRQ8yla7agWoxIcMf+e1w4z3bL9g8DzfdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X3qC7oPP; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3qC7oPP"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a2a5236811so4933925e87.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 11:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774983270; cv=none;
        d=google.com; s=arc-20240605;
        b=TYmWkJfOs9cdkRPiFwkMkCoJ1lYv3N/C0yHhOnY4kISH+JGxFXtdSBHmmdflO2DypG
         Pp+Q1zL7uLb31F6yrUoMsTH6cofGrKNDfLNCGww3fGcfXJJcWfoAlIW+zPg0pwJDqjfO
         S1CRjLLT8KmEp2WTz9V3SYKZA49SBXAoBBq+c2jGzfeHs4OXGdDhXH0cXx+95ef+jG+I
         ASBC69eWN1FDYJPAEwumsbk5voPsnPOFN+VZckX+aEi2la7DE3zG+55doGidu3f1Nafr
         4QIJX3jo+/BK4iOErOHU3vsdLJHvSEC2dgpySgeZfvGz44WDCn0F+HDLdeNXhbbQLelK
         9Q9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PelUNYlHA4etBcKLJ5LMDyufODvPTjPf2fovxktMXIU=;
        fh=V0G5h8bA/1+D33Lgv/+8CAeOMacyW6wyRD1Vx1dKq9U=;
        b=PqQ4txDdIbn1EI+zMec0G7Z6IK79CmNHjsxSpKq1tF/1sOgoRsR8QQjJbHQc4ub9cF
         RH6ljYnkXJNmf/nQ7YbigLGQOVUiSB/zzFP1FnqLRgQqb47mv1ss7UbFiAUNwS5sCLER
         3YYgoDcmEK2h/xsZxyb0E5zf8rA61+xQqOYUO3UdOjQLkHmw3UScFXzgY+kKrpp7Y8dk
         1BdOeHJHibK1ys9XOo5D81Ts5PjAUrwh9FlPcVHFwHHvDOP/9UhVRLijMaHbS0zDGapo
         6MCF4RtyCqtSEMEdSguUOc0kdeUElYSR3ZJB/n1JBFy2yeyHIFFRgeHwvUYSHGiphHtk
         bkeg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774983270; x=1775588070; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PelUNYlHA4etBcKLJ5LMDyufODvPTjPf2fovxktMXIU=;
        b=X3qC7oPPLXM3jRUC1pP9zoWQ71gHogpg3eBLP0J90mFMV4f4rif6wpU4jakoGjybrr
         K00Xog5obvNtvcVuqXpubb1Ddf8wAe2mBpPwfAPbQqmDFtrsT4T4vpNocW30N+1Tyik1
         kQLDixUgDnnJ5wnDaSjL+B+qInZ61We94dIFyvnRB+0R4MGCehPn4OSW/SKrBWrLY73L
         SzCZ5/YUqz8SQNIbJt/K7kspmBifKXP9ojkjDbGIugInHU4ZFYsEv+Ww9tbPHOUyh8Qk
         3PTUUsb6KDieqSfaXXv8AiPyp4ksbrXMTTU3qc20JeklL73kjNeA/9FGMlH7D8rF5EpY
         PE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774983270; x=1775588070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PelUNYlHA4etBcKLJ5LMDyufODvPTjPf2fovxktMXIU=;
        b=iQe7fwdZidfPAkqvUCb2tID33GFxNXQ9n+5CYrXscHU/yaMGtwYFpV0L3URN9pFLtY
         njP45LPf1SumPLnefx69U2P5igNZpSrnI/t2IbZ2GM6f8LzMxXexH93ZeGFfmdmlR8cl
         nhbnXlNMbEOBSiFmC5pGNv1xswecMV0jgMhCAGh1cjk7+vX0mBUqLedh1dyp1eYQe+5g
         7mYzeI97gShlEfyJoYJxlKpT2jBqsAZnrvS942Z9AHLuXR162ck31CcegtYaEfGJeI/u
         NHUX944HlovYYHUq7nWKhFc8VMK+ZwQXzvmzkQGHCIy0PyVPhyKtDf2MhIJoDak5Melx
         aIlg==
X-Forwarded-Encrypted: i=1; AJvYcCXaEDJDohKDnmPlajt5wosD3/p3onAbzVhPAMZumddafIjgyraZtis3DT5O5iRimuX2HWBTjDf8@lists.linux.dev
X-Gm-Message-State: AOJu0YwJuttXAaBisWhDrsmt3O5MJb39Od8AEkNHu/Jqafe8gaZQ5+eL
	EJBOi3/U1gtFJRGBTqZxj51UhnlVGl5jMqLLdWHmZarSj+AqgH9hJllscpV9WzBmR01KBmufnB3
	whygXx+3DKNjtqd0Akbzv2jljtIIW+6k=
X-Gm-Gg: ATEYQzyu7iLmYDYXB8mE2YaRwbyYl/g7zqqfDYlR+Ar9NZ6qDUmSC5BsdLNgVIgXEYA
	wpHngSVWurwU6iZ1ZQ7SS+7nfMhJuqSATUFeUGMSiyocP3Ip1R2wv9+OJtZEXCt44ZfJ+fzkuy5
	ZafbNf/9WHE4+rFkLGenNGFBfa9kBzAYfQrG/CnKDY0SRXSayRk0jpzEFhZyzvLIVGoXfMt14jl
	WV6GJnskNQ/FKyWmeX038s+YShsaZ5WLHJ96vcu2CnYiAVsDzQIOLzqivsmCym0rfgPmQDIYCD6
	URkVJW5oex6fDe7eHb/WTece0KOUOESH515vX8JCiA==
X-Received: by 2002:a05:6512:308b:b0:5a1:351f:8650 with SMTP id
 2adb3069b0e04-5a2c1eec64fmr165899e87.8.1774983269524; Tue, 31 Mar 2026
 11:54:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260331161753.468533260@linuxfoundation.org>
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 1 Apr 2026 00:24:16 +0530
X-Gm-Features: AQROBzBNIKLKEZtwNjxuWXV3qWqroAIDJd6GWuT8KNKRw9dfUwXw5HuACN9i8HY
Message-ID: <CAC-m1roDY60qEnS1ciy_93yE_BBKNy1w5=kdgO8h1kW-T1X1_w@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/309] 6.18.21-rc1 review
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

On Tue, Mar 31, 2026 at 10:33=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.21 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Build and Boot Report for 6.18.21-rc1

Build and boot testing was performed on version 6.18.21-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.18.21-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 489a397a6e94bf636650e210b0ed749a3cdf1e9f

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
