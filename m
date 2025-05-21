Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEF0235C14
	for <patches@lists.linux.dev>; Wed, 21 May 2025 08:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747814801; cv=none; b=kOCjVzcXGeS2cYrHHHcQ31Uax3ay3WNNuIZjK54FeGlBxRkXmI60j+gFvFMxLkO9gDCKUkfFFhw28e2FESdKsNdTuwZjscgd45j4kpwZwGfkd9VcxpmApoOrslEfh4+NuspPyS9Uka87VcFogg8kti2lNCnV/CtgVhfHX86ojkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747814801; c=relaxed/simple;
	bh=vZqa7QqgtnSp55HuRvtuDX+8vOfAactf7efmJjZGr04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j050j55rmO2fUdyz2Ewh0bwbrdhuFmwERkc3vc4WFyVBEL4Jw477vRU995d1M9IptwXwgngf6UGgJqnoWKvNsgbMnChOV14eH6PVT1pFSGJcncL/hCTVDI91Ea8rMwlk1VT6P+gMfCcslcHkjDFadoVnIijnnhJkB1f69oMBLK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=d1pitq6J; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="d1pitq6J"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b1ff9b276c2so3922290a12.1
        for <patches@lists.linux.dev>; Wed, 21 May 2025 01:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1747814799; x=1748419599; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pdXlyN7IyvbDBMyrxaqm4MW5jGasMnJapEHCIL2mBk=;
        b=d1pitq6JMR/r1eF9OpiPb3VdJZXCD8+jwSIdRiVcCWYEFag03o2VJy8gk3sqF+DlIG
         Th2+WUyR/dHXJxOV6/18cAWs+018LMar+GCiYeZHklENxZO6WzInkDn5Kkr3TQfJ4Saj
         wpOhWD2ocpU6qOD1CSo+JQo2bSO3xfQ7GHQu6+GSEvTbWsxkTOOxCf1+p6SVf4IpxRwb
         iU/PAi0gy6veEIeFVDvCudCM2Wmlg6lJaXYE7J7jDP696ijn3wJeqGiIMkKNkNcVQ76g
         EgkiDxtl353KXqyK7AJkO1wC0nPge7pk+HaxYGUqHkqxb2jFHzgz6t8a/XVcTCk1mgKB
         gfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747814799; x=1748419599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pdXlyN7IyvbDBMyrxaqm4MW5jGasMnJapEHCIL2mBk=;
        b=bIKkgx3/3NjON2vMn3YLXF1IHTF73xZKXOlNhkqi+1YJ9XYoqC3pc5Yd0rqt77A36E
         MAENOmE7SL094vU189ZyA88xG8a/xTmaXMoiCAMtwrzkB9hoHPsKsXCM5Zl7NfYf3hyI
         OF9YhQySsMjY5ZkYvt3+l6BmATvPeUUc8F8E12GKNGPRvBZIfuRyLEiH+3OEp2Pc6Vv2
         XmVO3DR5RcfR81YHj/EkC4ec9XmHNjIxB7QPTEHDxf3909m99oRFUSV32oyZiR8OyeRo
         pb2KzBdqLx27PwUeWpz3wQrkYWaE0KX30PQIJf89p7055b1JfbF+b/7YCnSYXGd963sK
         8/9A==
X-Forwarded-Encrypted: i=1; AJvYcCWznxS+zx7yPNIvP/jFVFgAyMVw02yo1VeBGXCs/XQ3RtfhYurNhWo1uCFUXpdkPSF/2CZQvTr8@lists.linux.dev
X-Gm-Message-State: AOJu0Yy74Ktats9x1IiOXJQbxTJprkScgNdPNstOXjnSifLE7xjclyDv
	3ZspeHRnC+ARTxBwuOE+ZsAq9kkkRdrhHw93PbrF+8/etk+SYmmaD3y/Qb58uexqhsGXrqikcbS
	Ez5aSgyJ+bUCKjoOdSvvFxjjtgDA5iu2OTfGxwPqkMQ==
X-Gm-Gg: ASbGncsRgmYaXch1RrZReIQfunk3OuS1i2K/wgF0WlLGV71tfNm3QVsRe67cceUFGxj
	X5q8ZMNw3pgTiZ2GXhBHrgA8iD1Iy2qJGmhfdXJwUm0gx5XCzlNlGOBH7GrayDDBOtleJN5I85I
	omGbP1DO7n+KPpPzUHD+v4G8Q19/lGuUVK
X-Google-Smtp-Source: AGHT+IH8DuEEvWdJYePRJFj9EsmVuI3c/VF6QNMD7FNOGA9tqxrDD1VHeHav+B3+xGsZ7taklXBLW/jmBwwiWEj+LHI=
X-Received: by 2002:a17:902:e54c:b0:224:216e:3342 with SMTP id
 d9443c01a7336-231d45ab600mr292557845ad.43.1747814799030; Wed, 21 May 2025
 01:06:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125810.535475500@linuxfoundation.org>
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 21 May 2025 17:06:22 +0900
X-Gm-Features: AX0GCFuegfYXgvNDF5A7pd3344VsOpt3BHbZs1QL3qKaXeOd37d7EocBJK-bb9Y
Message-ID: <CAKL4bV4vnUVisBk1OZtJU7LF6h3RzKsTrTkY1pPfExJymC3x6A@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
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

On Tue, May 20, 2025 at 11:24=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.8 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.14.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.14.8-rc1rv-g75456e272f58
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed May 21 14:31:31 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
