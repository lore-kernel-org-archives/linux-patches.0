Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EF22F877
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 16:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321929; cv=none; b=N0bcI7EVFx1nBT1+0ZtMAJjAwMxBMRT3VTqdFIsAn3rq80IBvN9Q98EDkaD+OnbviP+17BMwJ5qxO7WJMo2WX9aBKln5PAVe02yq2zy4XoDrLTZ2Wendk6CZn/s6jrwR3BnI0wNbXUtXXZAmEdIFmoluuzc6Mh1cDxa5aZ5hIWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321929; c=relaxed/simple;
	bh=sPrkjq4MxcMtTeBM9AOiDMAaXq4/Evz6Mnhyir3JBjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AoB2YWRS6/mGYJtHDYiJP8YtBr3Kui1tRPvB4GIHKGUdRtvucd9kh5GIiyt/kqfnSkk9atN1oy2LcDxsrkrRc7J+/DZjIuv2+0CXznjGAKqqvD0roOVSGaSLeSWUeJZh5yC7zfkvslC2o2dIY6DVlFns3hNvcGvNjP0D4FoloG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IYyKDpY9; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IYyKDpY9"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-810177d1760so306912241.2
        for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721321927; x=1721926727; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iatpE1s6t3358QopSVpoJVx3bTQcHGBKmfVMA9RyACc=;
        b=IYyKDpY9DxwSn+AZQbA06JQ1RgCdy1WF5K0c1FF88sCN0lMXMjZ72x/Dbv8qxtWDw2
         EWD2AT3FjSSfHItsgNOIgRP/YwR8Mv8rcKXzzvCObXK/KvLpg7rHNI4aJnUYGw7ny9Ig
         zLP2k3hxYkdaDuC/c402DJbzVtAvIh/3hH7kyD7RcyYWGKC+XGW6GJcd4cvbnCBNipwP
         2zMCci2svC0Ob+FXvREbYisXA5fcHN3X6K59WU9E9l3bXFJjLqC4nDmLcCgsLykXe3tf
         mRGK9vhzaXZqzUZDK0xKNsIWixDcKZt8L17FOAPf91hz3Sm1RRQIZ1sLQVF8RoJvlYg3
         4GZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721321927; x=1721926727;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iatpE1s6t3358QopSVpoJVx3bTQcHGBKmfVMA9RyACc=;
        b=n1Vwxz/atYAXCH6Za12ek405EE0uTUQAF85PaKgrUupHHO7Y1V6lQ9z1u4nBHLmw+1
         JqRpPYcqs2zpipjdYoIyd72t3pO4rOvLtmx2RNHWFcmRhWwTWzpSlGYd/xajCYPw2gZT
         yuaCAoD317VLML7C4UNlTEH0KWlK3MZzsJ+JimhP+r6MUxGdZ2Dkp4WwajlCFXTKnVZK
         FE81vNFskXwwair284JcPTkyUYZesWUAWrnGReweVWtsXc1Hilt6zm8j61foQ0eWwwZh
         kV22WeWa385X7EBg+TAZjuS5GuNTHHo0krHhNPSkI8gszBOD5Qr7jJ0rZD1i4UwiE0Gu
         4dcA==
X-Forwarded-Encrypted: i=1; AJvYcCXAcv8km7eNdyJiLFJMsQKqFit/tP1zoiXpUW7gYKP/6TEgk7bvQrGF71ne1a+igG0xS0akSvxae+TXnHjAmwbpZXSQ013vdg==
X-Gm-Message-State: AOJu0Yyz2oZ7P5AO6eRfrS48dpVTPi/Q7VAqthRBWN6z880lmXkGQWqb
	iHtdFIOdg3k1OJA0M7oU6VVDoE6IKNPBFguagekbyZB2vr4R637AptPKqtJGUK5Ohljp4DkCdoe
	I49Le8SKOTsmeQAAU50Y95LVtFuo=
X-Google-Smtp-Source: AGHT+IHLI2TTdbav+PZksYfVFsQFkSooWRDxySwqWAUzlJDd0jgmIdJpOeEu2mjaW9YxU5SVvf/aLAol4aGLiUS24Rg=
X-Received: by 2002:a05:6102:15aa:b0:48f:79de:909e with SMTP id
 ada2fe7eead31-49159849e1cmr8036750137.18.1721321927351; Thu, 18 Jul 2024
 09:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063758.086668888@linuxfoundation.org>
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jul 2024 09:58:35 -0700
Message-ID: <CAOMdWSK8dur4dx1+TRFjqD_bFu73+-nFMAPcEZCCuv_xtEr_gw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
