Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3436B055
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 07:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522524; cv=pass; b=NIGyZsuee/73ZOEDrqva/utVX7QlkEb6HUXiRcOZSgtU2zj/ALZzqPbpHpMtiglTHcn1y0wzan/1CHnIZewkuIL6jMNkEmsZ7NwRODy6dco4nq0Pczu1TSA9Q+yfBVEiUUIJ2UPy+5TxCTC1SELTPLifvXk0hNUbvptFtBCDxxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522524; c=relaxed/simple;
	bh=DaPOI1Mv6bKKrULXy2EhlDxH1FPw92QbA69rAURdUnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EACqB8gZCHeqC+AEyV/hw29OJrRU/9QNaGwnGE0JFjs95Fh5pllQh+IJqxZom5s6PNBMwNu2z1cPkN0j6erDEZWTK3wZqrUOcKYpxqylnufzIBZyfhPZzD/d2sAsSfWqOT4Twa0+W+obqhmoGdoUKPC722rZxNKxCM3E6Yr5Z5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=d2/1ogSu; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="d2/1ogSu"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1270adc5121so6636316c88.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 23:22:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772522522; cv=none;
        d=google.com; s=arc-20240605;
        b=P0+AUFl05JYSTEDo5I+YgLrTiBzJFARAnLsA8acdJ95XJ37QCEARN222ViY85GlG8a
         01U/D02o1htMjwqVF/MwKnmsDWRLWFyB3+0pCN0C37nTxcBIw+2wIccRzQCdMPZJwDSk
         BSM1Phce9A0y+jDEcvN6gQHhHDsmtJ5IdPZ91x7qi5mDMZlzd9qcjY1HnMdhiRMejgts
         kBNmAFF/4Iy4qvqwMcBVK8FzQ45N4OcuOKTsKvZGUkl+DxHvNhyaM+maZUJevLqMsVUl
         Lt7pCUYFSJstmij9Y/1CSc/+jQYzMRoYa78X/hNbH8Ue1l6op8c55/zMDZzHy7b6FIBU
         xuPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GsOnAqebSbbx0Py4ZeW5PaPfQNodCzjWlp52P/rwY9o=;
        fh=A28AQZOxGdbxbtt5FwIZfJrVTVGT8J3PL/Cca56iq/w=;
        b=XPNjvjxBxfW5U6ka8AzgZ02/GKvFgVu8byWhoIunNKPIuL4BOkkJRNM3yyu5ODnEoB
         Le0YpLXHAca/5ay6gAw0w6oNqyZcdaoDI4DuCeOutGH/lQk0TvT+OHqZOrfSmc41694F
         M5suU636LGd6Uuz/2cLgIWaeW8nbClRI+Sqmp58hOm7K8iJT/gXATMjhkfye6Ak17l8z
         WkcjC7/YDrpF0s9ggLyPAbVsdSu2S0QTxcqnHFHmpe694Mic5X65WoX76Dss8rikhMhV
         sldt1ATJY9A61JTYcEdmqNxzKhcIALHiXOogIuypO+DoVKIUKmAN3nTsxkIKNkgUCIkG
         Ai3A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1772522522; x=1773127322; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GsOnAqebSbbx0Py4ZeW5PaPfQNodCzjWlp52P/rwY9o=;
        b=d2/1ogSuee4xFDu2McLZxOdYcYOK19HJern+/0eei53+Z03JEyhV0z+Z6BGVKPHe0Q
         0qgm1EUJNz+rUKwdQ1WHuRH6qcJGI2deoEH5oWo8djd8/G8Rb3s5zmsrD+s/M6uYJ469
         gwB4VCZa35Qowa16FPGaMdAv7E8vJsPNoL4Yjn/f9RN30BLQXYjlOaVSsfq07DMHH8g8
         nDwV2otHwF+hFUsIs21R7YocZvfqwZHPDOLj05cb3/caE5AYw1re+eWJnACt9HYU5iJ9
         VuDLWVF4gpblboQKDpLfNGtUGeoHcNWchuKAz3QJknSR6VbfVzMS84SVIskFfjxXA5TA
         FZkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772522522; x=1773127322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GsOnAqebSbbx0Py4ZeW5PaPfQNodCzjWlp52P/rwY9o=;
        b=n9B+Ijy3Mxyn5iUjOjMjEtNHYeJa+yV4s/f1rPzZoGZEjSWMspW9nhCiyfKRH9aPj5
         eJRUGR11fX9I+n+40RI0uqqQknB8ub0FC7xKhr+ED8LhS0JWM+v12zGW4hVR77VfQk+I
         6PiDkSsn7E3WOgNiVJqx5kpgTYZDdZ1w1ooqeIXIc2NpEaR1LThRmjUiwWJTNz/NCHNH
         yQTTJlUlPt5BJcKV2TdbxyP1UORuL6+ck+4kTm2I7FBPuuNNrPvY8NBkqLPu0zIf6YFH
         HfmflUky3B07J4p+qjfxAItXV/Xro8wuxSblNzh12Gaq+NS1iCLwU6OlpPHx3Knd39I3
         z4Pg==
X-Forwarded-Encrypted: i=1; AJvYcCURwov2DG2pnTsNWBDT6JFsCILQKIrqFY320up3yM5FusvCfzyZQSElpy5giooiCDD4QQAlFjc/@lists.linux.dev
X-Gm-Message-State: AOJu0YzJwHH0G+7Xn6oX04GwvuHHOzSjRub4zI1S5SUmCsCxqp31X9q7
	otmA/kxRv67DspitajVEt7HWnQowQTmeEARHh6LXcFgZJj6HqN3+6V7Us4hCOeLKATwLf1mqF/S
	+vaAex/v4HMOyYKHDJx9y7DDhPnlt2lo5M7RZ0qcmbw==
X-Gm-Gg: ATEYQzzVcrvJhbIN9I4XuIIIR7L/4zNgCD2+qmAosq18proWzhXHA0B9kDxaJzHURU4
	7yyRJT0imwuzGi/RwMolTwuFEiVqzyZBc2eJ4nkYok/Nek6eSEkm0ufYRF4TYVMbX0pW8f3omqf
	04HY4OOXR31fuqZ9yOrlNJ9Lv8CA7JebUf5Y54m4xLzpag9ZSIE7obnCXzxTlFVLr7njmtr4m+8
	ucUT/qAMAmvmYTN7nuMVfrzGd0e92IYLhySYGH/ZtLL4Z6pY1zF1tXZl8jQZ1P7R0p2U/dt2EW0
	DGZLOAWsTsvrV3xtA9BbUXcijiil8CVIc6jJGtyd
X-Received: by 2002:a05:7022:4591:b0:123:2d9d:a90d with SMTP id
 a92af1059eb24-1278fc21264mr4699765c88.17.1772522522025; Mon, 02 Mar 2026
 23:22:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302160834.2518716-1-sashal@kernel.org>
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 3 Mar 2026 16:21:46 +0900
X-Gm-Features: AaiRm539i4FiCURsUwOuA7oKH1UqWI2seltZqOWXbmwwDS1Si9xERFmvBVnq75A
Message-ID: <CAKL4bV4mzN=j-i4pDWp02bEMARUwf-uB3NKjAdt1MoS3QX5oLg@mail.gmail.com>
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sasha

On Tue, Mar 3, 2026 at 1:25=E2=80=AFAM Sasha Levin <sashal@kernel.org> wrot=
e:
>
>
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git/patch/?id=3Dlinux-6.19.y&id2=3Dv6.19.5
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha
>

6.19.6-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.19.6-rc2rv-g6e57a110e7e0
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20260209, GNU ld (GNU
Binutils) 2.46) #1 SMP PREEMPT_DYNAMIC Tue Mar  3 15:57:32 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
