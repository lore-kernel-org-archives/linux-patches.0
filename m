Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7023D17B50A
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767057900; cv=none; b=t5Jv9S8EO2JuPZSWYrMT7MeJxD+Tzc8KsOOlgKH78T1lQdiz9FxzYsrKKf9KUbMRb+BerRttqpwX2TChTO6IXQ86Mf6xJChp++Ut7t2ZzBt7Bka0ha7M4wb+m/DMUN/feimbOXU2PmS+mV+IMA//XNS4X3HxLEP/RrfEbv3gVn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767057900; c=relaxed/simple;
	bh=XnvqjMaiUc+Sy+LYGVlq/1ATh5F3Ya328kk/v9t6nwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpIT68i3wiCQBLWpjXG0HM6pXVLhsozKbmhZBGDp561b74E1g3nzmtkRWYq1+nYaZMvmlPlJ7FGIwkQUvMdP4NDU5F/DxXLpZV3wDBjagtAfHRtdkE3b4TLwtKnOs9HCC0iq7hMzVOHPJvRXDiomjK2eGCMlknSpBam/Nzi1v74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=tObA4K6a; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="tObA4K6a"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34e730f5fefso10465110a91.0
        for <patches@lists.linux.dev>; Mon, 29 Dec 2025 17:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1767057898; x=1767662698; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rkDlLrOKzmeE1NzM8OjRSerJUrVzndot1jq+5lzrCxQ=;
        b=tObA4K6aaKpGwU/ay5LXkZHmcwjDLwcmLEh+tXXgTSgp1FeBwOCocz3vSh8p/QgtNO
         gq5HafLpvMbZGm+cWDgylvRxDBWwkHsSTuzqWnRrYeR75ZWb6Ju+Fv75jXKYIO/ejKyn
         pMAk6w8AT+p4AsJhXk1gVzjkhh9iSw4SoTeh8tdCKiDI3eiiLxRb/aPbI8aH4h/V1MKS
         23VQJU+w9er+6ucYAH2MxYVEesMRngo95Qu1pMxswtcMXcq37QM80oLYCza8xh5yLxxx
         AqVICsZzhbypeyIwOpNjl3RHDWU1JVIdSnAlIWjgvKCnOF7rRn9dYSr5+KoGQlkubXVo
         etHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767057898; x=1767662698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rkDlLrOKzmeE1NzM8OjRSerJUrVzndot1jq+5lzrCxQ=;
        b=nMMqwrm19HXg2+/KSZiI6qI5Qs3jWrosmoRmVU/MevGd340b+7Hakl+A93HcV86Pfk
         oC6Dl9f/zYH3yr+eIr+yrewTGmYHdhSSFnf0SjJkfWVsI6KVnS+N6nB/d6491jPKpUJK
         5OWNhWqohNsdz+ZHohTpdyhHIf3W7CXcSNWzkch7fs7PMGxVi5vaqW1Jd7N9XSEn2nRq
         wu2juRu7/V/chkfCQWOakq1oKL6ffxXqQNBOPeYqd/w0sKtoN6UazqI7Xe7G1ahdBSj3
         1hxvJ/Eu54+PMjw+WrogaJM1QC52IOg1igY72/xgq1b6OGM27+qZBptiJ7ydfj+zOUfZ
         l45A==
X-Forwarded-Encrypted: i=1; AJvYcCVeH+zM1/SNzRPLOg6u5WBqeTz5KYmfFDrYzsO9wB0pXZ5xZ9aEuPhTzR4Nvxp3e7VZor9btIk2@lists.linux.dev
X-Gm-Message-State: AOJu0YxZcdS7oZkbOYJdE5mDwWmxzStuPTzeapRMWTYgA8N17m9wxvjA
	8nYOTxQYcc/OWXtpkqJJfwfulpADrpHs5wDMPrQMaz5QGWiiCiVjO2fFuuWedp5Lr2d3AcmKjem
	/9s4XeG580iANDla6Y00dlDUUL6s/8fnD9/4cRBTDKA==
X-Gm-Gg: AY/fxX4R0IJRqopj7G4SxszKUhlL6OMFNmJYG77mN5Qp6nCWTt8wXnnV8CoDyZTOdSQ
	YMA1D1jvNTcP77EHCOSEPxwmzIIKS0bJEa0YSlPjlZ7jytdBz714YFdgfT/ZgXoQlSEOD16wMtn
	63Dx8SCSJANP2rndD/MUTeq16qY5yyNLsRczI539ZGRwaVVCRnl+abeE90HWMQvAKBh148JWLhN
	lbYD/lS7vt6FCeDSr/ERsZhjmJnpIWe+vqLMXVpft7AJ/ZoEZk8y/6QTElx+1a8IB/lUB/Si7h/
	SbQkm+rsR5mjdSZQAEIpbfQI0bTu
X-Google-Smtp-Source: AGHT+IG8F/k6zKiBfEuwX6HywPSeruCDQhXoUfFg196y9Xj48+6yz/3hDo1v+exV5XkhVG9MewYODh4t751+soQHnK0=
X-Received: by 2002:a05:701a:ca01:b0:11e:353:57b0 with SMTP id
 a92af1059eb24-1217230d0a8mr28358184c88.50.1767057898459; Mon, 29 Dec 2025
 17:24:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251229160724.139406961@linuxfoundation.org>
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 30 Dec 2025 10:24:42 +0900
X-Gm-Features: AQt7F2ruUxrbMit0zX9U7RreFobAepBpC0VPLVPoDW6OVs0XRTCJoXsy-2AZcvo
Message-ID: <CAKL4bV6Kai_2yBWY2HSECrm0MNQpE+XO1BcLXhKHrk14JhSPZg@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Dec 30, 2025 at 1:16=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.18.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.18.3-rc1rv-g685a8a2ad649
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20251112, GNU ld (GNU
Binutils) 2.45.1) #1 SMP PREEMPT_DYNAMIC Tue Dec 30 09:19:52 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
