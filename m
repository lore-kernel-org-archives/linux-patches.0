Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B8D3D68
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 00:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706573565; cv=none; b=VwcQRDtJeuWkKLDaYjVOdPHbJ3SfepjUnJ+V1G50yP80xiGIEMf6pPR/kU0Kx/ixVpjS0kTXcPIXA64vfkAQ+atsKIt7PUb7721erfBKVmWFabxctuDh3PVvTsRef+MBrSihHPafZ+kpVeJfID29Jc5PXSScvYFGMgnrhTQXU8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706573565; c=relaxed/simple;
	bh=qFY9pvpSAh8/gTd6U+ZRGFBZtHBuUqVyYA/q01yohwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ocRhydAg9wtUCboSFZGpKQ2c99MTLpuEnlJEweoFWFya6uORJImpwBK8dU0K3lVQxr54rxXdL1XAxMHgybCdtG22jvlFDXWv+vxL0+El8eqGcoUhOwzzpJTqUIEwtmxz7oXs1jwdSWKZQVAmaEOrUEANfQfPTELDfPPoN7p8W3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CuydLgTR; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CuydLgTR"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7d2e19120b5so1431305241.2
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 16:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706573563; x=1707178363; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B0ayNobXDIvlzXhxPnNo/lChDplPwaQVlQw1cYzK7mw=;
        b=CuydLgTR8e0rHQAfBlsuZLb+kJie/dAYXbPjZUJFNP/l4o+pIOe93sdU1BRs0mguZd
         f8YQiYQfIr9eUaz79OI6frARV4TQXtoRjmC9E+A9epP17WULTczw3WQBt4ncWjJY4r6e
         tyL5L3kZQW+2YuHu9K1KOJtCUI7AyRZnDKAf31JJm9LxF4cDpQo3i+noTYDr34/I9opM
         ySEAavBzcNC4S5u0GxmDC8jlV9bJMfV+1Put3Iwaqy/P0SrqXRyHyp+0J5PuxDRHC+Cw
         9Mru3XQIQnY2p8u0GsMMMzUhufRzAtDglCSQBt7gd1Z3S7yenCRwfq/9EN3X5mYvpEaz
         9eog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706573563; x=1707178363;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B0ayNobXDIvlzXhxPnNo/lChDplPwaQVlQw1cYzK7mw=;
        b=nRfWuPdmXuPSzUZSyFH9Q+5z+7pP911klL9GFbFgGVCyHYbAW1Z/HWokVm5DZDHUN2
         6Kz9+fj2D49rQXYfrwgwcv1tyVR1jVfbeXymfuzNgUj/p6YKjWVGZU5S3tHx9XlcqTqm
         iCzGSG8OINYm/mRAVPEuZ/anzwGGeSUxWu1D+iXr4pnTu3frLX9MZ9e6dNkhjPzGYvoD
         FdT000FJAQeh8xXp4Ed/Y5cd8tghNL6YExYWWuZ0X6zL8FLrn8igTJ5MAQRr/119JFQO
         HxX8O9fxilttiNK47Hy2r+K7+qtnwnDGHG2IIYutddyC05BeLMQz2sf8q+3B6dBl4UYK
         NMkA==
X-Gm-Message-State: AOJu0YwP6t/aulBnQmDKnA5TTAjpR7LRuMef2PZMwzagAyEHenLOZ/72
	E/zR+yCZOTvGU4EMQF+gO8FzBn0l1kKqx4MsRlNvMXH5iJctf4Lz8yvWxSMY5GoMOgBjQ9DbRCj
	JusoTx4cSzEJvwO7ErvjfZTyfbAk=
X-Google-Smtp-Source: AGHT+IGrqkqJqJ9naDETyV7iL4vzSRMYrGIwK5tCdF0UslTpl75d6dZ6B/x5ega8sa2iXpABKPK69EuVSGZmXtU1sR0=
X-Received: by 2002:a05:6102:1953:b0:46b:22c5:fad0 with SMTP id
 jl19-20020a056102195300b0046b22c5fad0mr4993454vsb.19.1706573562808; Mon, 29
 Jan 2024 16:12:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170014.969142961@linuxfoundation.org>
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 29 Jan 2024 16:12:31 -0800
Message-ID: <CAOMdWS+Nvj_9z-2tL5UZNBpw1pMzBC4DXPT2dp=okuKV+gZ_vA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/331] 6.6.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.15 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
