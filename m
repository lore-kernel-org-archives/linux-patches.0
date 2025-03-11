Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F15235BFB
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741697464; cv=none; b=sztAnbCoKsqjw7/VG4YRXnuDqlwnVhcE51OlbIISHdwsnWmZFCTNcHuKv9F9Y8DQ4H1BvsTGmOcD8kbDg19FxH3yKpDxC7zT/kVr8qCiWtOOEB6UeOi4BRu81ET8PMRHhjrBwWyaXO4FIaIAJsZWt1QRaI2B2c6gQh+6yc5Gb3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741697464; c=relaxed/simple;
	bh=+TAU5vCBRg1301biu5ak8wIgH0pgOx3eRwTmb9b6WP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RS8w4uzJBX+P9uONK/0cQRIG6bhoE/rNeZBf4+9o0rbVGUuOTjZv1PfuKALMVYcgRSIWn5xBKQMoeygbb+TUb68HPcSCkLGqhmthwAPSuBdEe8k4VBhcQAW5qiEibSeVTseTqzW57bNfK/YjR1/DKx+3yymHXDQPOpHssXFiv5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=falhX/e2; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="falhX/e2"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-300fefb8e06so1868470a91.0
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 05:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1741697461; x=1742302261; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cM6S/I+r/Ly1JBEFG+Hw1zWZq5rloLNf5UiOb6Ru1Lo=;
        b=falhX/e2vlwGER9tGYeS+bWP60YGGjrPrxDoPtQraAWnITQFE0VkCrtu8akNF7JSx5
         CNxKcoEsFUqQ09HICcHS91Tu91855tq/yX6JF+MKTrJMpL6L+XVmw1s7hY3jjiqBgNSU
         Db/FegB2yRlG5VvDxlSaThf4ECOTAbSAohOZ4ekYYEWp/pnDvWlsQrbqFKcVOFNIHZq+
         n+YpdDChVXK1lNKDLtve68Kc5v9g7L850oRkwIW9catsfOtj5c+phXWHBa6HS8QWQQi6
         VGNPlgw70Xlql2ysLs8t7jFofjWa/K0URBoAu1HKkEscK7FyNade+dmwmjVcClu9zkXD
         K/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741697461; x=1742302261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cM6S/I+r/Ly1JBEFG+Hw1zWZq5rloLNf5UiOb6Ru1Lo=;
        b=RU/GdxWJ6i6RW+mZN500VgK3K0VuhMv8JZvwMnqgXWJLkuGys1sbzwI+j745jxTVZb
         QxlX93F5GIlfCX//EDF6NDGkZoqTwXP5A2t4DuDlD4ku5zYwnlgWDy116X4G39lHzvGv
         PZ7XAs6nNIHx2LUgj6JQ7/wFNfDkmQcEqHGcOdlW8lDxRvrZQKsKdcyTaxcpAbgyIp9j
         +00FrNGb1jkQite4fCVeOtjilv019s4qgOd4N7EupVdl+bLDwzY4wiN5OVFPN2/fPLHY
         Mj5UB4MWwAmiqLjb9or6NYNVFuPsnKH/VNJleumdL7OwXHGWyLh63ft6KrAGZx7kJYEF
         V3Bw==
X-Forwarded-Encrypted: i=1; AJvYcCV4p52dk9xPdBePB8RMh/Q53rACFv4MIHD5dvfbbSzKx58aZujcQIMdrD4IwlIURnK9zhzgaURz@lists.linux.dev
X-Gm-Message-State: AOJu0Yw296JMIY4DIzwpkd5lSR+QbHxdYui5oOQlr8SICHakesXAHUJC
	OjnyM6yVq//VgKLaBRB6Ul9GdeK3tUnMv32cVDMd3RKk0tybbrBkEBVaXR5G8TEDSGTmSBFB94F
	VF1QBzlR4etFJwNTG+le9nu7m3EQuFyHFFAJmKA==
X-Gm-Gg: ASbGncsHZdmjUEl3aKIDj8Q9jMXHIjA0RU8+cZ+y2Ph30XvYkQ1qbtIY5pd2LZCtOeZ
	EtZ8MTgnC8g/wH3ejtA7THq9uZvz6ArGIiXauMwN5rvNarioB3pvY/GmDBVBtK/Y7i5iDrvgg33
	O4yP99m7etoS3gRNabh8V2xehgIw==
X-Google-Smtp-Source: AGHT+IFinsjUmVMQLT2zwdJ4SFAabPxwf+IIVy37I6UpJF8Ii/4h255n8As1DyOfJHUeM9IApQ+FMpbagJsAZpctEOM=
X-Received: by 2002:a17:90b:2e42:b0:2f7:7680:51a6 with SMTP id
 98e67ed59e1d1-300ff0a4593mr4513741a91.6.1741697460991; Tue, 11 Mar 2025
 05:51:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250310170447.729440535@linuxfoundation.org>
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 11 Mar 2025 21:50:44 +0900
X-Gm-Features: AQ5f1JqE5Y78tUwLtePj2OHVcXEnFp4En8VZ49aac9Rm2u-wJhTW-_RzlHHxcMo
Message-ID: <CAKL4bV4MCTujqjkg5A4DYR5UoOUjYQ9zKpQsvrcGJQcbfznSDw@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
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

On Tue, Mar 11, 2025 at 2:09=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.13.7-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.13.7-rc1rv-g2fe515e18cba
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250207, GNU ld (GNU
Binutils) 2.44) #1 SMP PREEMPT_DYNAMIC Tue Mar 11 18:49:13 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
