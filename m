Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A13F19CC03
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727963102; cv=none; b=n6A0hqF4beVGb6oa49ohxhAQeF04Gil6EQZQfSFGTRSVhIF5dEr5UZiq4zP819oTQtiOd7JT+4VN7s+yLkniqAGmdEwsixYtS8WysbS/Iu60VMUypXicalgrugayjbDn1VyROSh3VTmN882w8umjG7FVlbW/y+nI9UZiGpZ0T4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727963102; c=relaxed/simple;
	bh=RD9U78fWEr2OLYZ3hHe/2YSy67zB7CeCkzI3wXX48WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hiYwyN7g9Q2cNZpKClGMexyQuB74nSFRUdSsYWbfMiFKbqhgb9Oxu14FBBLwXxLsmzPr/xMPcNadEky48RBRxMzusPO+t3HwLhTR0oLlE5DnnmgZSA/eP76HXq/ZTeOFSz2/uFGIa3UmTdMW3yWli4iujZT5ZNkZidaH8daswR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=NsyW0M0Y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="NsyW0M0Y"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42cba8340beso12214025e9.1
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 06:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1727963099; x=1728567899; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwqEYZax0+DPVB+o/bD03kfHhlCvltBh2zIbh2geEME=;
        b=NsyW0M0YT4t7fV59BG52aRVAvDnddm4CAxk2LuGgm8uMjGRId/7qkvroJwb8dThIt8
         PivTF57anOd/FYR2/aW7jNfJdnJCcX3xaKv2lZKNkjurm5nF0tg70LUMjy0awoORVFVC
         KoXcQnq/5/Hq3m3JDsBAzvwSJav/eZ8vpW7g5+6Wg5EsjDcZ/8PI2i3UvTNkFsINb77x
         NxzEXi6JeNdVey6oaNsll8qz/phcN/YhzJoVKip3pw0K3G8Bz0BZAyUCRq44vVp1mH5s
         Dv4u9nftXPFFrpILv5BLyEhjq1uZltVglFsG7dFO13apth2v0UDYHV/qWmL5neRhkGe8
         J8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727963099; x=1728567899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WwqEYZax0+DPVB+o/bD03kfHhlCvltBh2zIbh2geEME=;
        b=O1lTlDpMaLMDygo+NUDvw9fcTUeiTr3UrwZw8xycOmqotdBUYJK2438RPKgZSdf9pm
         0JqPkE5U1u6dI11rkQRSZ0RiBLZpjdbk/FgpxPyBOzmmG4vfbr9O26Zh9BLvWOyTyhM8
         4NvbCigHkJDy1KPEkWYM/EUPKpJg+MhH5Ukj+pdAUrSqsU2AH9S72+0/akvtuTgkWhoa
         zy7wBT3QA8/Vks4WRCY54Yhnuj3sjSm/qddMRv1+zNIj70IuRS7ULhFvmqMYQ79BLCWP
         rxctwCfFqOtpKWK/eppFHixThIiqxWzwPiX+hDGK3uGE9/zbSpJIZrEl4ckbBDQ7ImiB
         wh6g==
X-Forwarded-Encrypted: i=1; AJvYcCVhMmDYzJlc+DL3OWxjFrLN+1HEUu5DBKLjiVdsWJfdWkoEjRhnt/gXJ4PUyAe29haEdkpVuPxt@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw0na08xGpMxwPlypkR09mMPkGKA6urzkHIHcfNxf9F9CpkqCu
	gh87ZLwuYnxQMQL8x1MnNUkd35M1Zu8yW1Iqz5xarJG2rHbazPocC7pUFE7pTkxL8rDWq/mqz45
	uI9SOxj6j8Tlfrw8IIFzSLnPB3QAbWDbOzOIHwg==
X-Google-Smtp-Source: AGHT+IHmzkBQRnjRJ/DhHK4cysIpn8dwbmzLNUFnK46MKOshNcu+lFN6+0HCNvQiySIFkEeJ468TQlxLcdVB1Cj84vU=
X-Received: by 2002:a5d:550a:0:b0:37c:ccdf:b69b with SMTP id
 ffacd0b85a97d-37d04a5a005mr2036695f8f.32.1727963098488; Thu, 03 Oct 2024
 06:44:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241003103209.857606770@linuxfoundation.org>
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 3 Oct 2024 22:44:47 +0900
Message-ID: <CAKL4bV5zK5k7uX1DhT-3=AiK1XWzsQe-V-d-vXpyJ31NSHOTLg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
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

On Thu, Oct 3, 2024 at 7:33=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.54-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.54-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.54-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Thu Oct  3 21:30:01 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
