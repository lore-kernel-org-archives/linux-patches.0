Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CDE1DF96E
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 22:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738879766; cv=none; b=Ldt0u7WnOMKnO4GbAvMkm5FgvgOBjkYwDNZGiM56W+2QIYiNT7dHbeo/sly8CPkdDCyTUVHfj+clPfkJjNZ6IwFn0K4CZqdIuTsUwIkXU2OWQGhMjR7A5q9wozcDYJwzEFE5TsXL79+1od/0Vo9VAl22btKNbqEktVZeveZFlFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738879766; c=relaxed/simple;
	bh=v8Cb/I97cbYSHojVbzWOcSDJMzlNFCCIVvXaYBcMZxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MXBDp0Hjqzj1QCaQ+hUAr/vThx+eE5Ou5l3UDYHLBw8L+a0PpCz+ds/lE8wbFtFXMTkOS+t+sM54giVAxUoVaD5HCCCdDmOZpu3tv69YzVlGGu7DDGkJaNmReEeld1GJDq5LIfZviqHtFmUoBN180++5DedVNN4rs/2IUzrVDhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=iS+Zd650; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="iS+Zd650"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f49bd087cso10620995ad.0
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 14:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1738879764; x=1739484564; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YowFV95RzqYpXXncaW4VNnhPzNA0mgUHkVJDlV/Z4no=;
        b=iS+Zd650gdb5lwODRgUBclnmfHrcQyutmP4tY+0Tc0jsTZOgHzvozLtW75Dmgo6FFE
         IdZ4WEVC/j5vD9NGOuOWL8JByMBJKZysl8UtzKsJ3L8c2vIrm3GEo7RGTpWCtqs7gYDy
         FUkjxWgZ2TpXy6otkfA2MB2HT6p4+gbR2ZVI2GDX+WE+zK2Z1wns/I0v1uGPfP4MiBAf
         ceirXvFwjt48GlwlqLjb/e01ukccgFBjZ3qIz3lxiMu8FF+kD/j0+Dj9OSDBwCpNAimB
         lV6ZMdNQU4+AvHqcUWs2RviYU1o+mtkomLxo9dg1Luiq1YHHFbvPJkt6vU76lIuv1e2P
         9xcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738879764; x=1739484564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YowFV95RzqYpXXncaW4VNnhPzNA0mgUHkVJDlV/Z4no=;
        b=vYXLL5nlzTejB0plgwygduLyvOh/zZxZMRPA4nRz9bG6BAW0BjWzzL8Bj4uoiX86uI
         bjCqrPi9+Rpy2Z77dAWP6KIzgxg/yCIMejdnEUD/mOFs9jzPmzTzr6oJS1X/svu2mbrg
         bhXHWJnBdt9kCXOvaEj7cXhscB8uIF39RTsTaUC68QsYP+9ProwyegnMUBipeePaVmio
         eVH/FqVcJRbGkxEmmBqZ+doAOgrgAZEaa1dPuG+BEv0TXurS4RDww22XS6mgHbFGlORL
         +PXGHjeV1xCRwIRhvUtn+7gt0qaRTapFqmVfyoIy7rd9VGREBOmz9UYqLf5eH67Ariel
         b05A==
X-Forwarded-Encrypted: i=1; AJvYcCUuzh058n+IOEO/d5strjxhY59HWLLhCgo02fmyqt+5wq+JlL6d5IpR1LExTfDDAYJU2qx5oUdY@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9X9XJtJlMF7C7rktkc2CaWnsYYwUrH468TYjIJV/+X3nR+8hg
	JhlrSY1yYssCKqA1Nc53tbQQLlLh2EhO3P4Fls9xLf+lA9CilDRboKaSe7s+r3vMOi4O/TAjrAN
	FXKDvsnnvGHlFdaPwxH/B+bOWbJL49v4pC8xO3Q==
X-Gm-Gg: ASbGncsiCV6qKgl7nHQwidwLWTBh5A4Go/mIBQ1GbHGRlWkrF+g08YYqO1wD826qyKN
	FRca8Myg/jTFHLHO3FCfYsERXU2Q1SxbkAU73L4RUAw1npU/i9Q3aL0KhoZjJ5Q5Z3kvgKg==
X-Google-Smtp-Source: AGHT+IHVA3aLLUHBjvM7tBiT/JAeRIG715XqkMU23ZlOgaA1/IPqLSTPkVNA5hE3GgpS2Sq6STuEQ8GQr00qCN1MoNE=
X-Received: by 2002:a17:903:2a86:b0:212:6187:6a76 with SMTP id
 d9443c01a7336-21f4e6afbccmr15332045ad.14.1738879764518; Thu, 06 Feb 2025
 14:09:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250206160711.563887287@linuxfoundation.org>
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 7 Feb 2025 07:09:13 +0900
X-Gm-Features: AWEUYZkqc_QFPDa0cmxptap1fL55qjlShAz2QJJR1zciPi5pSP-77julnD_XuYc
Message-ID: <CAKL4bV5Ks9OCh8SrgkoF=UrK3KW+POAXOD77L1kD0P9fOiNC4w@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
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

On Fri, Feb 7, 2025 at 1:11=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Feb 2025 16:05:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.12.13-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.13-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20250128, GNU ld (GNU
Binutils) 2.43.1) #1 SMP PREEMPT_DYNAMIC Fri Feb  7 06:24:00 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
