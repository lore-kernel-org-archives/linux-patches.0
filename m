Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE722727FD
	for <patches@lists.linux.dev>; Sat, 18 Jul 2026 04:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784348164; cv=pass; b=DQ9AmWDeLW/bp7T4t90x/eZo3Y0w1KAMfeuoh4QhqjAez9+iS8AnJDcipFAayeyOqmYGScNkaY/ygDHIX+/b9qebtqcWlN93pj+BxLzd6PegD0WW/284eIQYUc9t5lviWmEQZXwFxcl/IYXw3K4bhJWqpwES38pmKWsoFsA2RkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784348164; c=relaxed/simple;
	bh=qKK/SAkfNDjEwhZj7QR5KfgdanKDibPFiEyI626ERqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sgiNBXfCwM0WPuftelNn6zFL0Ke+4ISKuQ/mNU0y6V+VAU/fbOzIybejxkYx2M1MzQzt3AgDAjegIeBwTd8hhd4sKsu3lr1Fry8KSOLnYQJXoCBAIFzw5lF4CaCbIY+yHOGryv+jND6nGf3ZtXZkgKWolUxRVzOQgEuCOoxIahk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=Pb2MUX7F; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="Pb2MUX7F"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-384c94c9414so4358488a91.3
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 21:15:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784348149; cv=none;
        d=google.com; s=arc-20260327;
        b=Xs5qne6N3/HQOtAoiN6yIHoeCIOSJfLA0VT0tmMANjEVRRJNpZOdZ9A7MMAF/rwoBN
         uBxuwkIZIyEd8rTyLNRoNkj3T7aaA1rdFXyHGGMd/C4YdVKvCr52oUiRdHt1n2NGGNDO
         sAfk1n815kU7h5PIBYgN4yR+UefMJNZTtQHl6pfbbm43FF+hj6Fyi99k1rOVLEYHyXDH
         cJLmvW7uQPs+/BEnWAva0E9r2cH7tBqRVjaJIvPjISXDxg++gCNBifdnh5ACRt4oJLtn
         M1pk8bB65+OXLHXDFEbLZWQJl3N8a+Q1Xfo7qxU3wcLiViMqEW07m3NNND3NR8LTuTTk
         C7/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QEm1JYtQbugO6JFmVFknJJLCZpeLY+qIl9NQioPuxJE=;
        fh=30Tq2m/e0t6K57Rp2Q9WMiQcVhWTXw3/0LfCwWypi1M=;
        b=As55d6v7EB2ndl+s3/xjwDZ/MSxClqApVvJLVMuUUGIu/S04gA7rJUvP39cn8WjPkH
         VgHM+3Wy2LO7/PH9PZA9fPCbFbPcuFZRZfuoDint91LEapYzUSCFgDkjQESIYTs6sO11
         uOf2emyTCFqI2O7uewhJrk15NHfNHsts8QWr7d1juH/O2jY1lR3zKa4YlJoR2lzZnMGB
         wrIIt4xlRJxy41tRH+oxVylAIOZX6Vnod1EFOYXGTtZ/FDkk814WlXXWPwzaLgdFpQpz
         Qpc1RKoB5DyBi2pW84AjMyxoc1fYa2Adm0Z2suOrbazt+sUHB9qw/Mq6w/Sq2o5jG4B9
         68LQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1784348149; x=1784952949; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QEm1JYtQbugO6JFmVFknJJLCZpeLY+qIl9NQioPuxJE=;
        b=Pb2MUX7FVxSfeG+jmaNV9O60o3AA3DUfut1xl3P4qYp+6lHOVqye8p0BG5DsxzEU6C
         nolI+j+ytKvPycU7h7cbPMP9L6QAxYM1XgnIe52HwzAKd7uhcLhms/Kg/TFqyjFToSh4
         Khc+zP9jPpQAL0UvIoXKLzEF4N0pT5hMDytFXUy3phavFgowForwkc6/xj3LSF/bB9In
         4fOGUlfBswUtwYYEYz4JmYm5j6RvgNhXf5wWL4mfsFyfx5qEn14zIUQ8YOMLo6FIP3eE
         zwDvQ2SeQTZ91vbKfXewlvA1emKZAbatVj1eOeaNQYOK0dbE3OEhGOUbUNjx0+IEg69n
         y1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784348149; x=1784952949;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QEm1JYtQbugO6JFmVFknJJLCZpeLY+qIl9NQioPuxJE=;
        b=TMYrvCQavcPQu7ELLGJ1Bq5wFSSbHcSpduTQ8qvxsrEQkQj9atcn1+Z0Bh/eXKu0q0
         qUULncvDQJHVSPUQxGnB/DhqsqUNHBRZQzwQ4tA+60h1DpaKZK4zNVD2nU8/w9+kKew8
         TaeMwy0m36g+SlesiWtiJpnlMG4qi5AOtNt3gQCXCYCYXrghqfHpYAueXkh6hPFa3C+z
         zfePa3kzJnFp8qsxggupzfIq7FIZ42x3wZe/NbAKGPSB9BMvs5yajqpZlGs8C2+KfAm8
         Cl8JuSVJOMUD/sz++atj48dXnr7GeHFdr+JvjumgZloXm11F+tRKuECQ/YfLCcyMSumI
         2alA==
X-Forwarded-Encrypted: i=1; AHgh+RqA477Tiy1bM/xc71xKeZRhgpL2DuhEOvY9NBaXOGoypteoMqJuo4rwnC4k7MxOv7gS2vDTG+ET@lists.linux.dev
X-Gm-Message-State: AOJu0YwlGs2zF1ByR7W344rNdp+yeUu0LLEnSgLmkd6mBQ0Q3bqTdDXU
	JWiL+o7PRt1PJ57l0J9C/RrRPhELwniguk+StfDMv1mGT+8JsBcFHxZiCUFNw3692bTSj5km4Sx
	MhWntTPz06/fKTlT/Y6jSi15OMUVIr/ZJN2qUwwroyw==
X-Gm-Gg: AfdE7ckAtWXav5nxjEQFwe2Un9CkIwR0+ARceDarmnAIhXgLvg0EwNAZXBEUUDVVCMD
	lODN9UQBCqblZkh6Ixxp2a+hDZBt+LndLZI6lDhCDmG/FbEID40z02tdaQp3yjlGbguHEKGk9/B
	a3e1blUZN6DcYn/iJTRhDuo2v2cLjL2Y7MpJdV61vmbxy9q89iBE2adMZXxK3GawER1jWTsfEcw
	qZBvlLl7uxKlfdQ8HCbCrngTq0Q2ywnJ1zGpCpVy4US/Q1yp/blGtCmxDdF/YUz/68X93j2ghpj
	AMdNx9yBYNsg3cTWKqM=
X-Received: by 2002:a17:90a:d008:b0:387:e0db:bc26 with SMTP id
 98e67ed59e1d1-38e4b578fe9mr4982966a91.38.1784348148997; Fri, 17 Jul 2026
 21:15:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260717101912.682013354@linuxfoundation.org>
In-Reply-To: <20260717101912.682013354@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 18 Jul 2026 13:15:32 +0900
X-Gm-Features: AUfX_mxTM3XDl7urQpLrIfeHKNjranHdbqHS1C-wZDgPl8qmNJpsI-3TZ9HhlRE
Message-ID: <CAKL4bV48m4ZnL-Upd34Y1hOX8VeWHJR0xrs2x0WO_GZCCqqECA@mail.gmail.com>
Subject: Re: [PATCH 7.1 000/533] 7.1.4-rc2 review
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

On Fri, Jul 17, 2026 at 7:44=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Jul 2026 10:18:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.4-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Linux version 7.1.4-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 7.1.4-rc2rv-g2ae9949ee672
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 16.1.1 20260625, GNU ld (GNU
Binutils) 2.46.1) #1 SMP PREEMPT_DYNAMIC Sat Jul 18 12:47:10 JST 2026

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
