Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A218E12A177
	for <patches@lists.linux.dev>; Thu, 23 May 2024 21:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716499550; cv=none; b=DsyD3xD1/nCBZzi/xcP9dg0IRg/9RX6YHsaDMhkKBOfbVFDLtTEn4UlVnh4TqBit8q51j6H0eKMxp7B5kHySUWXv12CKPVqxnPElrw4RAeqhb7QFOpW3hZD/azxJsUjfFIIhXufepqBQhFi5ozxamOjz/dhIyLMEdZl53CxsVSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716499550; c=relaxed/simple;
	bh=mA56a74E5OZmSdOaOCgWbEvISew1H7eTgdBTvcFAbwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aWhH3GSh1Y8tslzkCSBAIh8bz40I8fzn71GxOfyPso0a65f08aPaX1Z0xoXgRFtrWFyIf/np9Q8ZVsW8oFoUHK/SZS1+EEIpkaV9AFQ6IGdT0hx4DAKjI6e/J86le+rIrKG9AmLKug1KK5jFWFZZfjOek0/YI1elMLfbeI2Y+vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=la5lFGs1; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="la5lFGs1"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-68194ee2174so188684a12.3
        for <patches@lists.linux.dev>; Thu, 23 May 2024 14:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1716499548; x=1717104348; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kjzBFWQGRJlE51441adpXea9AFvlQa7Gmc9nBZzhGfo=;
        b=la5lFGs1USCWR3gnty5Jsl7eCl7ofurezboaN80OKgcuwpyiQh2IaMiTZyY02xGE6+
         KuAK66PsE7ydKwBLNhevWEc6yH0Bgl60Bgy5FPE4WEE/8+AkycMP+HCbVvTAvHAKg9o5
         dvJAHKZzfwE02pcxPtRwSqb+0G1CfVjdq+uwIgBHEFf/4KDwkfy47RJi8bxZkheKH2jl
         v+gb6j6lMfwBMN170vDSIA8nGt2Cw19lS77wPgpkemZza+4jSHDrAXdJDX+4dnoi/dhI
         u/3w9dEbJciLzYdbciKFaCgGVVniG6oL/hfUChILTZ17lXLQuMZqkhWnTyeVzTeB5NBr
         wNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716499548; x=1717104348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjzBFWQGRJlE51441adpXea9AFvlQa7Gmc9nBZzhGfo=;
        b=XI/wIq+GFlwoOuKUxw234Dq4/LsNonYDG9KTtzpdRQEiax7Gk9B2yTHtwPlJ4kvMLm
         J8uhlSK1jjJKqga+ySs3XmLEkJzAVx/S58Y1kchY1sRE/J4/+dTqlTLy9wLR7PMjKpIZ
         ZqP5OLp+LBv8wdiBW0ZpD+hhyvEaP1mbN6asrwbz9b0tJ8PXwlRro1Mj6jwbIG4mmUGa
         aMxSSBABMAPjGF8kUFNn5VPQFWhaas2wUVRlCp/YzUApoV0rLiTaDx+xTffOvyMnWT7e
         szCpHB6GG5U6ul8rnKGdqPeTKeKUB5gjM7yqix4Nu9jihA8jJB0zDsVCQOsHl7plB2O7
         hEhw==
X-Forwarded-Encrypted: i=1; AJvYcCUYYwetWPQ5Rl7FA0IVlYdMWc8lR6GPDd+7h7otDAiqGx844PqnDgyILK4EWfwmsHVkFzqs8FIreFIhT8zq46LQecrT4/pYeQ==
X-Gm-Message-State: AOJu0Ywgftd5+caUMkaG7892WZN0BSNBCwGlbTd6DS6pgFnbMT5qL5AU
	jfLhQgzFlyQiassn7OJQ6arfz2gRsE0GQHnHVRZMjnBeW152LPDjeiUa5QP1sYjLmGNXRxhhjYX
	WE5NFjeRu9WEhhtTYKeitcDr6+QkTRckmr6x/Pg==
X-Google-Smtp-Source: AGHT+IEX+DzZqu1f51+157hrrpiCAPisWutwsfM8ZJUQxeRwW/N02+rxbBX6wwe/PUiCT1AAM7TddJlgzw8uQAoAlu8=
X-Received: by 2002:a17:90a:fa92:b0:2bd:efad:88d with SMTP id
 98e67ed59e1d1-2bf5f1077d8mr352514a91.28.1716499547473; Thu, 23 May 2024
 14:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130342.462912131@linuxfoundation.org>
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 24 May 2024 06:25:35 +0900
Message-ID: <CAKL4bV6ip-D-5rOuiZoWPS1w1Oi-Y48TfMtO+qGiVgnu612r9g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Thu, May 23, 2024 at 10:23=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.32-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.32-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Fri May 24 05:32:27 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
