Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8714C1A239E
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740482214; cv=none; b=o8Q4BWmync5w8PecnxxG1/lwQB6zAZPvgzhYocQwm57LBdKhOCO4t5iIvdIckN4cA0E70gAyaDAfJ83Kt2KecqzsdaCXD4KUNl9v4XyoViQhpZ4wNsPv+B4zcsttI2d71Pp/HOFLFRuaov5+89fsijj97U62eWSWVLKURW9G7fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740482214; c=relaxed/simple;
	bh=nq0EPGLmAEGxwapDdA7JGX7A1kQwUZXc+8FAGQqLWgA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FjpKkGqwtO0V2yMvRfg/0lnz1dofvE9pg0DBtIief0+xgmIivODfqu5uNORofmxQh+nhGtOuNx5nVDx0cnol4Jkym91eTTXpXNW8HxDlx1jdzwpvL5hF/eAk9nJMqEKhaBoWfKDNC3gSwR24Ca1+6gmArYQwyxvWjvPWsCPVuI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=ZOCca7WM; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="ZOCca7WM"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f9b9c0088fso9303608a91.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 03:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1740482212; x=1741087012; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BidLeBZkJUtIcxcRlqcE1G4NM4e2prFwhePG6wNNgOU=;
        b=ZOCca7WMd2T1LDurhhfMsDHEQbpgP+KbwpNBi+Kg+SNlvyEsT5wEUQo4tqT469cmJJ
         4/Srz8pqIgeirGnjyct1lfLr1iCACPYOEjb6z3aly8TKvR7r0mXhUDHRjEgyT6hEqEMG
         cDbeET/O7KBBb1CyqyeYqz6EokHshI8ANkkSvNTiVU+kTI4H+vtJ2ftOTwjGkV3hP9Pw
         cdrpbPaqx5rN3GT7GHaXYYk3gx+oC6D+v++0kFLs8P4WSNwAu97qSraxAXnEg/6xD9Rq
         lHvXzZXFB4r5QuLcb6X5wxCEfttgVKoM0yrpabQgJcMjyfJPlLbWQahbvXaBVygQbSzH
         5Mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740482212; x=1741087012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BidLeBZkJUtIcxcRlqcE1G4NM4e2prFwhePG6wNNgOU=;
        b=oIn+/ZtLpGUWudPnL/N+2x5YBMHviGqWU7aAE7XDuGNMf2SDw+6hYwFzPcigwHpGT8
         +yB0878z7HOYOC6cbrvmZ+x0NM+e/WrsoFAZICuv4pAoeQJ5d8f0V4tpist0ocI+z/F4
         gONwbnVL0ti1889NOCMED39Xs3uFXq1P9RiqIiqBltfm+EIB1hCNYCCdYysNotkhR3St
         ijHjJR2IzoCqTfWRgF/nQsAef3dm2VgiNaupzqX6JDPM7VnsNqvRuAzNep4LMhX5qyJc
         fkrBkmOWHT5UC54QEriiASW+9ehx/SDGQd83PuKgSuy4VMOkiGYw9mvthyZuyXxaOPmR
         gPwA==
X-Forwarded-Encrypted: i=1; AJvYcCXHpKy0pYVV8OikNAJF6tGr5NZsjw9NJBt+sjdqnG1+6R7PI5pxZnfr1G0R4/s6BI6HZceL/i0d@lists.linux.dev
X-Gm-Message-State: AOJu0YwTX3IPyfstgBPFKBBY7+tCbzuK4JMHVGCOzmKWNvM+MHf0Flaw
	4RHC4F370QIK8JSh2BNyyT0upJuYmAyhk9jc3+kKcDdYTkmL8B+032DNl9J9l26cAf8vDGiIB07
	7/rK4skiHf+1uiFv1NaHg8qzy+C6IZDoGMWse7g==
X-Gm-Gg: ASbGnctgbyQ4eSsGG1xQzEFDUZqlgwXwLDEB8PLc5Xo7CMWZEF5DO63jdYmzimyPOX4
	EQaMMdumGAnbM8IHEtkXeD59pvxnekUuU4zEfriEzYJmWoB7kUYA7tSfHR150f6URGG115T8h/g
	+cpYpnbL8=
X-Google-Smtp-Source: AGHT+IE4zNCtApjgCW7IVrMKgxaqKv83HSY9BzzaaRBtqgzD3CudAd5vQ1VyBcJ2Xih314sYh+MeRB44yJsTo17Xs3M=
X-Received: by 2002:a17:90b:3e4e:b0:2f9:d0cd:3403 with SMTP id
 98e67ed59e1d1-2fce7b738ecmr27861132a91.16.1740482211795; Tue, 25 Feb 2025
 03:16:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250225064750.953124108@linuxfoundation.org>
In-Reply-To: <20250225064750.953124108@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 25 Feb 2025 20:16:35 +0900
X-Gm-Features: AWEUYZlymfn4SR6NJFuWVJLjUbbiu8b-EdVKox624pmhyRoWSWfGeNS-etq0fYI
Message-ID: <CAKL4bV4VvXMJgrtWGdBNOWzfn09S6NAaokR0PO=JO_u4E5mtmg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/137] 6.13.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Feb 25, 2025 at 3:55=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.5 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Feb 2025 06:47:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.13.5-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.5-rc2rv-g1a0f764e17e3
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Tue Feb 25 19:28:03 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
