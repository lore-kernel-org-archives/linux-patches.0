Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496543AD501
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781693064; cv=pass; b=joDqngeY981Nk55JEMOnn83OOvvn196oQZKtGH3ETJx00dDaHSYJw44NhO4CgRPcnucSvdllEa7+MnLDEh7q+BfnHs1cTty8Zl7WrOcuvZPhUSMW+2hVYM4ApjhKY9u2PaAFWDVU+JZ6Uamwd2h7nXJ4LbVPHaXzZnUo+hnlBh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781693064; c=relaxed/simple;
	bh=/NxpPjIzg+geXrODdaoCxyqEtoHwKoKr101StU+oJ0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WkTYK1eO6QhmWOi1I9KOac2qLYdsUKKSZoavyxZRSXAqTu0n5F1yQiHTozKCkjDITDpDxE3Oq1RBe1Th3ipiiRnrsKSAWl2sFOzQUnwYL3TtXAiy2iVbu+JV2QSkpwEDchRh9JrfSKOmLV0AfKGCrmJgj2NBq5qA94MHa8Wj7q8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=cHV49bxu; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="cHV49bxu"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1384ebe7a10so1300653c88.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 03:44:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781693061; cv=none;
        d=google.com; s=arc-20240605;
        b=IPJ645u2ViGs+o4P2usbWSEHw90CPIltCMfVbhvYi2AKNDW2UY8i+gPoEKW60X2mB7
         HtkzsA+YDaToLIhBQQkFZvtHZtmDw4G/8yBq9J2FLmJFDXpzujsXEuEN10RzEGkhBCXS
         ux5qB7LQCtPE793ivzZZhiwnVKx6W4wumsQXBmlUQHEMVDY+GZgXcnFsPz11EyT5eVks
         VR78eMtErbiVAzNSs+9O3k6rhX0rdrazJKJPi3etYkt2E7sJZS6mebD4sBYjDJvfn/Bf
         aUB5kEAQhVY0VY6fkJOwkpCy2iCA5jFKWwu31PTqYS9dNngwsbIhU3H/STYpSjJEsn/H
         geRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i9O0NN3TVK+XDaLnZjglwVnb1NmeX9L1ao27QadoHB0=;
        fh=VI5ZAnR6dNSKomHUt+s1+YkUDlUMa8A8Fdn3SGeP4oI=;
        b=HiHfE3EMo4ITBRRxZgZv63Qw34cJ7sTiczirQvuVQJsY6Ewm5jIB3QW334EpaYnyZw
         iJmbROnBKiCRfnotbmzKcoCdU7ZkJYHktpU9zzwJgxj/6f4L5Tjol66nt6ENDs6FOsOC
         d6e0RXg+ENq7dBCLDwhEEuZan0FFrZnKD0wp8rt63IguCWtQKvDk7ZPUbC1H9MCm02Si
         URxs3udHegSynyv8jB6xgp3Z2+h0gPe3DPAmMcOkTyDPq9LOImmTNBmA10wHl55o6AeB
         hoYMDyZSsQFTCfD5PJ7j6NSa+6j0nxvRMQPZEZj5LyH/ynO/uZuFk2MW5SD+YiyEcLmv
         boGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1781693061; x=1782297861; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i9O0NN3TVK+XDaLnZjglwVnb1NmeX9L1ao27QadoHB0=;
        b=cHV49bxuzAQFhqYzuwrPHeF8wkILHsvENI0VFpWoruPyOPkwa+5+U6ClG1IFtnOUpz
         TgqbWR+ki3r79vbp+kqOdXSEbiCF8at/HxrsA93ot2sTG8KO1MZoneDGjU/rQ0re1fjF
         /0T80XKZstI8VOe0YWsKTKsT+3L+n8pcFMQr1tbRDU9jjr3uSuvVXUtCcuZuj2LjQ12O
         IesGKCO4ts23Sya3H5Fi6Sp8YAexlVk03aWD/7rehpD4gg5kuifTAaj7MwzJtPTsReNZ
         P5FVjO0cVCSepZ+YgDJ3X4nFAaJd2QaKP/FwICD9RaMdMK06Wkm51PAnkq2BIZf+h1Su
         vFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781693061; x=1782297861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i9O0NN3TVK+XDaLnZjglwVnb1NmeX9L1ao27QadoHB0=;
        b=lgdxw6IUCaLrMdC/e8C5ErUZ9jN3Jr16Fwvi/5uKQfeWmMB8Le9X+cQytWsNMv96sc
         nK/21fFuFnyuGF17G4xFni8RaK+P+tc+C0IqSUn1rPG3gJgJ83tOmPMpfy6ExnPlzdyj
         55msGovvazBTevKgK5U1S22T4ksAK5NOkkyKIGINlbBtQXtAWT4+FCyUYp+PZgc/QjjL
         uct2l3UQG/mKYhgTo6AJ4u//ZfOgh/LgOWlLtXT3ig1bOve+327crSSf1ALRj47T9V39
         5qY/j26hNNvdSG3KotROIPNBcvuz1PK6YqsNrDz0/0IfZYYK+J9dUl/5AY/7hc4y5EQs
         8HFA==
X-Forwarded-Encrypted: i=1; AFNElJ+bKO2iRBsvz+LeQ4H3zjcRM/zZLLvkM2AvE0rsirazDTGqv0FETc9kn3DDjSlY5d2XaNu6MeMm@lists.linux.dev
X-Gm-Message-State: AOJu0YwPW3ihRGfjN/Df7g2L6MytW9ftIRF3ShjiioJP98+S/DAlaLo4
	LZVLGh/mkwoC90xM/+l/NBCm1TfuXSBcO0sNlozibVMqjwQqZzHeIHl5wDWa9KUCZpkpQRSgPKy
	3OEy3Kwh4FkcTped/SF6QlO7+pTyWr7D+A4aLkrVJ1A==
X-Gm-Gg: Acq92OFmQWTZXlPvEVqc3k0ePpVcOKGivB7kuadOu5khkNOxcYCOzq53txY8F7Jb9JP
	5YBavdAsFha6tRcld0PzuAKtMnIKOJjMRodR12rwvpeB+GpPo+Rs+nCFqtcxsw75kuasd8OfEW3
	I7imok7Q62e1JgntGN+TVOff+/xvMxuC4fJ0PVZq0nTxgCzvr6+nI/jfbFegYIEPh9VthKnO6pb
	KeBQ8pQKtAJkmH+6f/mTmopHYctHuFG4NNN9KM9h1NsYKyqZL+40OwqdOHx9Mhs5pS7myRiLGCJ
	jQF3SFCt
X-Received: by 2002:a05:7023:b0b:b0:137:ee9a:2ad1 with SMTP id
 a92af1059eb24-1398f6f32bemr1208632c88.35.1781693061286; Wed, 17 Jun 2026
 03:44:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260616145523.335696673@linuxfoundation.org>
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 17 Jun 2026 19:44:05 +0900
X-Gm-Features: AVVi8CdY2K1fR7miHU9HYoa5ohvrQsQtDnjjTgBsQWfNlb2XoGbDHsNacHlBrrA
Message-ID: <CAKL4bV5qmt_v3zQZvvFXRs3YpUeZtvFBt+_sko7eAuqcgUZSdw@mail.gmail.com>
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
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

On Wed, Jun 17, 2026 at 12:01=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Linux version 7.1.1-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.1-rc1rv-g281f1e815287
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260430, GNU ld (GNU
Binutils) 2.46.0) #1 SMP PREEMPT_DYNAMIC Wed Jun 17 19:15:41 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
