Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC41C23EAB4
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 23:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770679971; cv=pass; b=qFOs/pVnZSILIT0TFEx3+hob5P5x33hqBwS+GNLbWURLe1uNeEf/2MeydvyaIiZ31XaY92pXgX+OJ6gJ4HYsue/fB1NiFuPiaVnHqO+K5s92pdwNgBBeCmSSzO3bDSs/jC8o04hZ9LpWnG5flFr2ChFSvLgvO67LJDciIRpAgoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770679971; c=relaxed/simple;
	bh=vSYIQM7cYfwv6Tzh8xu3FGMrbUKt0D7Wa7VzoYij/Og=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fqc9DyllFe0BcbCHCmZXBJyfWxOqAupETd3tR6EiqTOb9ANbf6NBtsul0idlTqirJLI8e6fGEhER5/jLWQAb2oQ2lmV8gQufpTtSbNuSX1y8LGUmt3PyRf2RNiYDuoD8rxm7SOaO0o/GLrkRv+6FUO2/kUy8P6DXV49r0Ki+czg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=GWM3+AlS; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="GWM3+AlS"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12721cd256bso1306977c88.1
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 15:32:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770679968; cv=none;
        d=google.com; s=arc-20240605;
        b=kX2sCc2ejGqEKr2Y+Aq+A5yuAOLBojYm4srHLQbDym64N6NElpC9ojQcmUhQdAnp1O
         SAGSEsBWzWSPk4LT8QRme7wrOzkmPVKsJwDbDzINfPwDK2ky9JIm/EnVnhxw64Anq4AX
         nbFUR0VcyZPTevw4/VqkNfPZCBIUANvpF0uc6ph3eB5l4OeYx+4w5OUHMAMixa83XhGa
         s8A/i+YrcJSyB0VaoTqcIcuM0FDFLwvemnJkV9TSkLdTB0WZPojjfQh2LjObYOCVblaP
         F9xvJTVcZyEh6UNpeTCC0PNz8yYBVumltfit/kdIR2jHQEB2OzUxMcof7j25OProXqTw
         boOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/J4gYTV7arTSFYSrrW6JyFKLOVhsF68XhJ7osYlmqyw=;
        fh=hjYH8SGfX6AZINzR/CcmxnUtHzJY46dacvv8LLLSxP0=;
        b=fOH8YqnDwxsnTTOk515gpl6A3dpMRz4KGrCM9vXIh2e6sXW9cMSIY1CeKRpMRltqY5
         yCnSpWHo7PI5DVLQQ+U+x37y4fAtRiCTSiUbyV287ChsWyq6xaw2ZxyG5k3BIvz5XABs
         ctFb69zj2BxVLr8gUHg6drYhW/+76vNQsyoPFvlLT8bAG0Scs10PiE9sKiJ5vWQUitNj
         +HE9sFIPRqiWX9YquUwsAN990AXI45lBRTBSxL0/YNC4hcR/DvUymLPvDwZn5i8z/dIo
         XEpJkK0mAZ3fruFk8wPrzMZUosiyaGNYSCFOEn6KcqTKyQucpS4nsIyzFslzMH4zjow0
         eTiQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1770679968; x=1771284768; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/J4gYTV7arTSFYSrrW6JyFKLOVhsF68XhJ7osYlmqyw=;
        b=GWM3+AlSuKSudPcIQw0JdVFM+Umrlqu24ZU7pR1mYYQJRd4oHCfme5dRA94JMR1vnY
         SpfNSIAhkr5Fw1BkXMvqyZlHvjGVjOOFxaj10Ey08o/wPTyRYqFThixp3UVtCdnJLPKT
         KL5ULhocjaXtPslGsUdFYxGJeu0eD6oHwvZkCtucHwguMREI1AjdJ2gwUMOXMCfvlMAd
         Z/8V93aLSiuUuKMNilPuEKgyQo+juTmvwxil6tJPrNX4etth1fyVTvgdaDAUR60ATnTp
         eIeKXrNRtVzVIFrmqELdxFlG0RBOv8zhbASCAWSQBtCdyEcBMWWiafZOK/3Ftt+98aoc
         psfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770679968; x=1771284768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/J4gYTV7arTSFYSrrW6JyFKLOVhsF68XhJ7osYlmqyw=;
        b=fEgmD13ybCmQytoIeF3SDZRxxJGeaSzKa14wX30CUYVkK/cCSyXkXpcrFm9Ck2QQ3p
         dIp0wphY+DIkheCZmTwuIUEZxoin6/0WxcYC2/p4R4id+GxzlUXM/f1omIdk58e1c9HC
         RQ87bUlOCcn4tIOzdpogvJtnS2B5+vY8ZCeaVWQEutOhlHM/4izO44xKK/pK0xby0cWi
         6U9Fd/PAK+4IB479HfziGh1zRbOPNvyQXcXDJIC1QBMDSVQdZU9hKo7EvCMP9TmVluYg
         P0tB7s5K/RUgSoHe5XIPgQ/bHdNmX9sIDHNpMpBwtgA2IhKHeIFHs3nztaAAHe7TOe1B
         g6Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXO69oMkgdRmmT9bHplLUt0ipsLaFH0YHAgGTO97eH1YUriF2FGDu07fX7QO3ulxpU+AraeqwDJ@lists.linux.dev
X-Gm-Message-State: AOJu0YyUnekZ768i4uNIhnKYhjJH9ujulsUbDUPLRr5ymC0DudpN95sM
	Nr1vEq1GuexPI3RwvuJJAIETc4fGGGNG4xDjellNOJyaBEsujiyvODLloLLqFpKF4/42Zo4w9vP
	2Kfu99+3ht39k2KONYcmyqbp7d38zXUqXlvNwfs31vg==
X-Gm-Gg: AZuq6aI5pDoGVvHw/2h/gaZrToTdK7BfhPveOB+BUvJ7ZWDK7yxXXzHGYwaFZpfsaE9
	QW0GY/m3zi3O8OxoQHuDufkHMHqiwgznImz8gJlYZhDrPPqcGioV2Z3WBh/hcKlwu/i76d1/T3Z
	rjSwv/pDLR4AZ4V51u3p/IN7mgViobbPCZCDGXeHfCS2R0kt/73JNuLOUOhbTOUtPoFVDupfiCF
	hsPGM6uoYmyZ3g0Yaf6qaAOmumRGC/5BzAkK6pNITIB5hga/aEgt0vZCtRjF8L91A0aNW31
X-Received: by 2002:a05:7022:f9e:b0:11b:9386:8267 with SMTP id
 a92af1059eb24-127040052d0mr4515280c88.44.1770679967711; Mon, 09 Feb 2026
 15:32:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142320.474120190@linuxfoundation.org>
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 10 Feb 2026 08:32:31 +0900
X-Gm-Features: AZwV_QjN4AF0sCIZTLO-vwWQ0AcVu_xbPrug3on0w4-b3rradmuPmuS0RXhAfCE
Message-ID: <CAKL4bV78xBr_VrqWj0TuXQLJ-JAN_C-VofQskufiZgv69JdbMQ@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
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

On Mon, Feb 9, 2026 at 11:26=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.10-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.10-rc1rv-g0aa40b8da17f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260103, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Tue Feb 10 07:52:43 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
