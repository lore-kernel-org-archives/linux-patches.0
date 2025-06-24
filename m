Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCEF252287
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766244; cv=none; b=DvHhVq48kFV41OmdYSVugM+ZtL821Q3xLgxzKc+vQewtw+Tp0L1ALsoNdznPrTgqysiYAmgl80v/VTYpbLBRk7+g7snOj0dUvYPr0KKgH6Mu31ua4uE+mnIuHcSVYJq4EZH/LNgTinOgv84qLxHmCQi6QVPgyScFUVqmCcpfI4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766244; c=relaxed/simple;
	bh=tRy1eXVSAZ56E3F4ovZPdbmpPSsxWjWS0y1a7XOGytg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aM4gYDhanUmRPPGspLLAhflUKYI2WXVa3Uom9Qrgm7y6ef5fCulpgk8ZmqWjNMerKedLfLRXw+hJaNO4omplolej9FGKcbaYJ1yXNZ9SNcJmo5F4GhSSYdFlvMsPHoE8Lw2zSRtdAVd4W+fSxzCaMeLGHhOqStXxfnXXO/xqLdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Bu9GSaRK; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Bu9GSaRK"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-315c1b0623cso2345909a91.1
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 04:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1750766242; x=1751371042; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q86PY0wC/gj3dz8RRxO/iauAyWxBGEaS/86SENs7hZg=;
        b=Bu9GSaRKptqMrrXsB4l450K/Z6W3+1xXX0F42TLNYb5T8xmw8ICOiva9ILru9WJ8tr
         Iiu4Lq2gCVw9NZeJ2bHcFsEuuhC+AC5mDoljYqspPcmRJMP4/ZD3SFUK6P+J5HvxVAOd
         iu5SHp/osYRZYYgQ2Hni0F5mVNX/bI/Y9B/+5oIdVkBDpuUSHrcHm1uJVhwqSUiyak8R
         czN19hdqJfbLDNF3wQn8vDzHIUli0P6+YtckFCGkGo75MVNd4KRqJ19FP8EttgEQW0GG
         PWXKjpXUL0mKSZH+vLQYElM1keAtjA1MEtW3d1UEF2oI9qPoh5lw3ADZWxXOS9kRSnb7
         B/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750766242; x=1751371042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q86PY0wC/gj3dz8RRxO/iauAyWxBGEaS/86SENs7hZg=;
        b=SA+TYdbxhki9gd2LMa6Hzoxe85Hp3Bf1NGMCyw1Qs9WvAMtab0j5vh9gE1Qv5MSkuW
         sin6ZVQTS/9PFYqwPYHFtSRc+i7ngwMVuQH5nNo/P3m863YpaHolfQ5hEF/gj2+m9rw3
         aFzDGnI5TN785NaIxEvYVMsIRC9MNago/f1WqznkODiZOgVUxWRIiBW2lpqHrND42XO6
         QGn17raeOHuLyKfh4xZgm26uPm5uQjVZjZ6PMft+jUK1xZavkYLVVtZIGObJX6YOSyyf
         2iSu/SAfvE5A0Ed7gFA/SReg/JxBww9/YGWi4kMDpzmG/0Iqp8sG1GF/MzzWGwo8Xfuj
         THZA==
X-Forwarded-Encrypted: i=1; AJvYcCVbgaBPgyG1EptluWlgxvq8t2kWbNX2PSkN+7NV4pGKvEdS8vl4rGgX6HAnvYu/FJ7fT5jKCUGC@lists.linux.dev
X-Gm-Message-State: AOJu0YykQuaRVOjVggBj6YdURvsgRXdRFFK0GQEIi7KbRN2ZgYH2LEit
	C6svyua6Vussd758Kj6uYP6OmP8MnjNhCr6RkwUPhoFIwVJsw1AFaSxwwXZ8xK/AVdcb9JQ4CL3
	agw1l21x/p2u3OARLCtFOFHnZOdlKP+yWFplgQFOpQg==
X-Gm-Gg: ASbGncs9b+egZtmoLq+EVj0c19tDjEJwNMvAaAjh3xko8WbunRVxm6zq+QjOYMuXRAo
	SCgas/KQEaIcXCLeRXLCq4gkGsqBC16h9cI/A/9b5jCPo0BAxk/mTMmwkeCxPhgL2q4K7pQ7KWZ
	+UVmExTlnkZCe6wLUF3e8P8dRJC14IOcGYIoxwzorA/vU=
X-Google-Smtp-Source: AGHT+IExtPp2I2mFB0A9OeofBQzId6Ui2rK6a6yZnOAvbn0MCJF3aNmFF52R/DaW0iRmuQwDOo3jMJSYi3yRrmIXxCw=
X-Received: by 2002:a17:90b:5690:b0:312:1ac5:c7c7 with SMTP id
 98e67ed59e1d1-3159d6257b4mr24312771a91.2.1750766241983; Tue, 24 Jun 2025
 04:57:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130700.210182694@linuxfoundation.org>
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 24 Jun 2025 20:57:05 +0900
X-Gm-Features: AX0GCFuTEjbibu-8Tjw0fKQGwh7s3i7RYXmZdiawgw2iqWdvIFiSW0TkstL5ynU
Message-ID: <CAKL4bV7Ce1J2xVQNbsgWwNm0ekUiny6TxtSvaXa8dQ=-tT-mCA@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
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

On Mon, Jun 23, 2025 at 10:09=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 592 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.15.4-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.4-rc1rv-gde19bfa00d6f
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Tue Jun 24 20:14:32 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
