Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D167242D92
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760185621; cv=none; b=sT8CyGwULKS1OWHSqGUjd0+DDpK3yS4UFfAtj9fd/BaLZ/At9g/Lp9qzDQIzcOBtnXoLMygAEdXR8yjxY1e2r/Yyfod3cg5OFph2DjK+rloZWhj+Ct2t3sgQ4G814hvu2cSSBtsLln/LGZssPgo67+N63D1Zg2hbXn+E0WXFALA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760185621; c=relaxed/simple;
	bh=d/gW+e3GHHoTmcok1pFTm72qSk5L+TUgVsoAgcd1XhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nHfYOoAh/nvoIocVFfWPCj3YDpQgQKBKRcYbmyxRQxq4GjvZX5Wfc9kikdZclALxis7UB+iJTrXu57HWgyTsI4q0MEi+6Mkb7eBwlsVvywxhf6FT8riRSYMgooM3navcp4aDPQEDckscTzGoVZatsl4kqOd9pUPXC3NXPXRoAS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=IzZlOV+P; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="IzZlOV+P"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b553412a19bso1801722a12.1
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 05:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1760185614; x=1760790414; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NAHnoAtDAEnsbgsmp2/eZQvCq9Zlcq/EHD9Uesa57g=;
        b=IzZlOV+Po5z/0rHKdijxDrmZIS+Ly+tZqL1uCWojZ3u6iW3KENfk1dgDhi9dlbcaCw
         zczXNVyaVPfjGau80YFV1OfNuRncErd95yMUJyzdsS7+AbDUOgHZnKDHpBHTDZmCPZxY
         V+HpBvbWSPI3eV6KNyKCFiZ5OiM7vYdozQjyjnm3+iqUboHnevLMSQkhzPGm2gWNjXkZ
         vYTjC3BCepjZYlUhIBscLL6myYe04cZNAk+dEy3T4FtzJZHhHmG5rO6FZM6uifAz5gL3
         5Aif8AhGTCGjhqe8GqbPo6W2QR9v4aspaPbhAOMUIfCvox8X/LVhlIXdLNWaTxYv+V0Z
         by0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760185614; x=1760790414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2NAHnoAtDAEnsbgsmp2/eZQvCq9Zlcq/EHD9Uesa57g=;
        b=k75KAZlkPDrj75JL2NpT9+icmT5RR3I3qYKHzCXAb51SPpv+lGk5N0tccGFzeHdmFL
         ohuadC3ICYgYIg314OgsSi+9pHZNvZxVMUbsrgg9Si40p+bdP6jYh3Zq4+or20tcoZhk
         HpMYAWWjdADvHuOYk4I3XQ1cNBLbidG982DZYSo2YNvwKBmdD0wZq16XwrcFqvhYa32H
         oHwAu4SdVWwLr90XWkGpSWxXPIh2WrQ0nh8h5pGHyQ6tGXNUFB/W3Z5Jy1Fw4PjKPEyZ
         a9vD9+0Bj/s9yERYqNpuApbe+MuTjEykXi/aNx5Ztt/VOmMNuExjSXEWmvXprwr4bFJS
         3K6A==
X-Forwarded-Encrypted: i=1; AJvYcCUFf80xVghT1SvaRLTC8TGHJqPSvIbL2oRL1WZCEJ0+btfqw5QrpeXXX0BcgMkZFyPMmAfhVzHq@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+mVzA6b5I2xY90Y7tDrZZyVTLp1YIAY74NrMvb8fYYygbtz7j
	QIUnd+AU6eyIl0C9pfWWxc6rbPb2ftn7YnGQrtCAdbewwQscpwkpzbqXYCoKdV22ujxJv74Bacd
	hoHzlKInCophou2rY9yypALBGYKL6ztX9a3tTT3njqA==
X-Gm-Gg: ASbGncsxbK3/wMyez88b0QEKj89F3A4PZM+yIcukxczaMMQ3mJrqa9wCNlUmXRw4yPC
	PPhBPdvaYlH/JsFutoD7+qyKQSVadxEvowHVx85gCpEOHz9yr5AMSNAngTTzF8EYbtehMFrcw5m
	XLK4dlkYUf8G/tYXkbXftGND6AK1MBDWHHKH/Atwl/V11jkOb+llwXNMsavm8pRUMifDFPoLp/j
	wmZn05RuuPCy2NusDbyU5Nf9Q==
X-Google-Smtp-Source: AGHT+IGB0K9uNg6w4xUEupnOm6RlbrvNDms4n9KNEcFdqdNDe2QcuThbe/3xmLTU+Ir4S6Gd+o3uf+iQiYX4+WiWYgQ=
X-Received: by 2002:a17:902:f650:b0:276:305b:14a7 with SMTP id
 d9443c01a7336-290273ef0ebmr198786305ad.33.1760185614491; Sat, 11 Oct 2025
 05:26:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010131331.204964167@linuxfoundation.org>
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 11 Oct 2025 21:26:38 +0900
X-Gm-Features: AS18NWDBFvwGIZ0Nwu0A830RD6bwht5kpABe3Vi9XiyKw1xcSWYW82-8SOUaM2I
Message-ID: <CAKL4bV6WEAjVSDOXoh4KPUNjfK=QJ=1RjuXGn7_Eo5Z3VK90SQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Fri, Oct 10, 2025 at 10:18=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.17.2-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.2-rc1rv-g8902adbbfd36
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Sat Oct 11 20:59:52 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
