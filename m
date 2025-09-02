Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFD4275AE1
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 22:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756851904; cv=none; b=C/FptJF1GmnTy8fcFhpWRQcjpmP6Jh7+aVMKkjR7PlSD3+0R8lCJse+4ODtXtSsq8867ByUNlk5e16r6snY48GFowLozcSaT6G8RMyWBeiiZM3eiybEtXlBs+x2DlfP3g/SH2D7675hAl9mTKtlAr3LHYZzQ4fDZAcMj0e0P3kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756851904; c=relaxed/simple;
	bh=1iy1UuTw6lEJ2NwgCGNoKYrNukFmN3deNRw2dmxMW9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glFqy/y1/lpTSeSTrMnwp1i3wIYe4i9J8sU+9ytBio5OlUn42qkk5iOPSxMivvMlPoQw0QDUhNBVuubFYL5hXZGOaj/xmGeJQQMBYDplAgtBAGYAr6JYBc1grqxyRlnVEflFSnG3Hmgor4Vqi+0rs7BvljtU8rT1gGC6e1jwL5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Ofqg6ExP; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Ofqg6ExP"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b4c29d2ea05so304746a12.0
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1756851902; x=1757456702; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goWE8+4wadNs8Lr3ZlBGwSTIYXLGfMy0Q3cAuxNQchA=;
        b=Ofqg6ExPIZ8Hi0nqlE6F7FLBdbhdBhoNOyGGHh2ZB0QpIdGa5BiG9xhiRwhjSRnvp1
         jMSOAmVuRA7PD8auAQDWjNewfeXwo2uYWzjrPbs+UaSxiV3OMnjzPvD9vAxm3I73Fh8u
         ePvIYTMFhJmvu8FUWbgsEng1zyREfrKCfCSyRh6NydSTwK9uM4TxiXUI15++32odIjKm
         X3gGyoPjeBtOvJB4KlE3YxD4fCl7W1kwv5ERjyCWWa7MgUVa5H2vGdS6QsvbnQ68HIay
         1lAcqwT7M9K89DugGR9Sctvf+K00wyzbAddmZDZ2UaLu7u8AS8m/4xb9y/6MJjxYizwp
         7fHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756851902; x=1757456702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=goWE8+4wadNs8Lr3ZlBGwSTIYXLGfMy0Q3cAuxNQchA=;
        b=WRSu0P1bKu6UAQ6yLLDSyhllWdd6HChagFxYPsRakQv8Z3i6hbaWZfKvkV3wcxOSd9
         CHhy4oZVhmcVT7hZpRiWHFyVOKQBDo0dz3dLnL7f8TehQdIh+gY9PPp4aJd9UO06LZsi
         KDRCSjI2hVvA52sJtbpT7Hbb8/qD+mYc4bBEr0BEuRPsgs5mVbdGlkyxoPHRpA8/UC9F
         Mj3xcY+vB/4fYaXkTf8qoMxARrbCVjZWblEG5KHAKgQiAF/P4T8omnssp+v2sUyi/02F
         6JLXGA1Tle0vq8iimXFHyY0f9k9cLayy/v1Kvqm4Ytl1Jbe5qA0Hz0rCzIjuiNOxfoz7
         6d8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVAyLH/UobEFoikUBTqRXMxuYdfYVkutsc9cRktLRy8QeFS5Ikp3lIWFWLSflsbRvCF7ZmAl65E@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4cgkZmhY5/0XCL5zxcTJzqLwy/ydZ8QK8v96xPSI5h4BT4tHu
	yiIbSp/9LLsDCmaMBJVcQCv2D4+ikESnST0l1G35FEbqX4RjTbZaKHxL5lKIfNT03FP7t+jRGQx
	XBj57SufrP1LwltigZo0Cnw9+y9a5wd4/npA8XoryPA==
X-Gm-Gg: ASbGncsEz1Bqa/ccxgwKFkj37h9lA9B11HxsTHifsqH9tnaeun6XSczZ8FSZO76zv6D
	r2jIuSt8VwIdxx/SMP5K2GpY3hg3myffrvEqmuhW1aEQ5Q83pRImkBQ3bpu2pWVjVdnbx8mCzls
	YCyfVMEEE71ciM6vwEgYPvlqT1P5NVuwmd/lzE4altyzNvnn0Ia0PKSoNjc3Y27q92k3RLq9NHe
	k2X50GTeIaqaSmK3Q==
X-Google-Smtp-Source: AGHT+IE+GuPuwIi0HALNRYE7COclZsdxu+LtC3uR80YuYT0Ap6u7TRJrOcZjbn/+xL05gLgJGPzhKrW2ZZxS44wSvgk=
X-Received: by 2002:a17:902:fc8f:b0:24a:4560:49be with SMTP id
 d9443c01a7336-24a45604eeamr165939475ad.28.1756851901619; Tue, 02 Sep 2025
 15:25:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131948.154194162@linuxfoundation.org>
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 3 Sep 2025 07:24:45 +0900
X-Gm-Features: Ac12FXwiesQX507YxRyjZkNgjnZMjLVD0vNTuMmrfDECGQRtT0AQVZvnJkRsc7k
Message-ID: <CAKL4bV5ZuM9J9-6oy27WVMrmA-sX384NowBacG57x+t+Ydt60w@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/142] 6.16.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Sep 2, 2025 at 10:27=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.5 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.16.5-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.5-rc1rv-g6a02da415966
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Wed Sep  3 06:18:52 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
