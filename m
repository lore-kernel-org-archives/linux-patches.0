Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BE633DED0
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 12:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761134565; cv=none; b=Hp0OgJRW6S/cv5wyfY8Hjr1KkJi3/r1xMs2s+w5Hbl4fAXE5iFD5I5H57YXjX9opO15zDvue1JLC8f2FzG5f1PPAPtobyTO7ukcY+ZkEaTzIPdbIPHkNULhl45/TbDEMyx/KfbkgPqDAVQxYCqsJsjYEwNDk5PHe1t/uPuQr1fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761134565; c=relaxed/simple;
	bh=qc+TGmxJjDR8e93EuCMFZsvuB2trJNVKy1yWPZqivBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CR8ZxNWS9O3vuApfEUxtHlZQx6sHrIk0t3Wnbzl4zqvaYBxKxd3bkWMPajQesQ2Usz9ETrVFOFGOaIn95xorl7At9bpbnwNFZSW8s1jJgJr2KgoRp1TXIpt+zpjZiJdpM8H/PSiF73FI5FGEQzy8xLYuvZDidpayJUD2C50i230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=rJF5/lLo; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="rJF5/lLo"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-290d14e5c9aso64759565ad.3
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1761134563; x=1761739363; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d5/wbf6GFhoGu3668TdoXMB0FT53GKQn1LtblB+CeVA=;
        b=rJF5/lLoKFaCr6Q7veYQ8bof5aUBu+8UdCq9+JJw4gudVEgiFBExo3fDu5s+I8dz8O
         2QkicbH5Y6EwIER3Davb3guEx1f3j2Bw2KYoHNhE1aBq5PQ8QXWORXY5s1J1eBdoDOk2
         8vZVXZqAOnHvY3uz93T+uBSD1b+Ma34KaiQQktSetUmgd3NMJWKqW2ZcivSJ7Z5kZjC2
         YqUvLjvxqQLfPBoHg91B/sRYFwV9n26CnLm+MBnEJDICAvuuXocqDKr+vaxzEQXubF27
         wKZk/8DBIIrjbVSUG9aesdqmOp6XM1qzakcxmbmRHdu1yzwf66WrRfGBFVLVs2PKevhv
         S53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761134563; x=1761739363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5/wbf6GFhoGu3668TdoXMB0FT53GKQn1LtblB+CeVA=;
        b=pcGUOYACKc747rN0g4dBweWYJNcG/Zs9c50eYORFhGPdSDPFnfKGwrKIsb5vwSjSj/
         Jcd+fdMnP9hsDM6WhCWqA/okUs785UOA9NXY1Y9sJegRiSHlu+ku0q5rXrUqNQOf//Ih
         ZKw5YcLw00QQlahxX52DceEV55oCogF+ardi9P9/qgtgkBHZOG3XR/HWhwSyKBYwYj/J
         gdrZ0E2jxmVYNvvxJ75SvUsPWExr0sF+skR0Zx1ODVtQfQSK9b21gQYwo/Yv1lxzaozj
         W3C/ue4HiKNdHjzZanP28//l2ZIL9fZWwIExdQhw7SCeySiu43jfytRKjwgtarXW6VRU
         csrg==
X-Forwarded-Encrypted: i=1; AJvYcCUaVpC8WI1+q4KK32gEgl0OWidn9gYMzzYwzupUsiJhU77ikMKUMqFqQ/+WLOAZJlJkLJMGoANJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo7+ScEAbw/sW6uhyJR7d6vmbDd+hBKfhuAoZOS+dxxXHxXEFD
	dV1vgalZcbBHgayPljaYL+8FVrtXhyELZIIQx4in0DesZjJztEACxGjtxnpLprnXUxSTWcIr5vL
	A0/FaLbDPA9Mf1KPb9jguGNGYmgoyZj4MANfnJagP0g==
X-Gm-Gg: ASbGnctb2gzEhsKUWLFD/N/6zsPxAHNr39k5GoToZiSZm4DuM+2fU3/ewwM7n+2snMD
	mMuRPfRXwsLZmLDTyfRoUayVYr9fODOdu5vNFGQvssdmGAJDsaaFOHCFDEffykreTIZmGMGplGJ
	uZLaEIRwyfby9Scspadj34UPM+bE3c+Vs4j6s6EMMRACbX2tA3zEVkbFpXeiNSy4ftnzyhPoYTX
	wNmJ5E4jW2741IFKpK9uN3ZeH77EaZl1j6po+E8bUsk+vcukkl54giB22MezFM8NoFr/TEz+/iG
	poZuw6pqBHTRC0lL87IWTfiUEGYp
X-Google-Smtp-Source: AGHT+IFL5t8enG2Zw7oK7pknpiCUZ9vYUeXHaONtu4SrU5QNhCELXo3GPXNs5SlUx4N7/HvLFJQcnXzAdCHO9w8JdQ0=
X-Received: by 2002:a17:902:cecb:b0:290:c94b:8381 with SMTP id
 d9443c01a7336-290c9c89dbbmr301590825ad.7.1761134562657; Wed, 22 Oct 2025
 05:02:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251022053328.623411246@linuxfoundation.org>
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 22 Oct 2025 21:02:26 +0900
X-Gm-Features: AS18NWDUgkoVTtfgD8dgXCgAaXo5KDUPhO3XXcd_9Q3gWO6keur8-RT4nYB1Nl0
Message-ID: <CAKL4bV747Ucee17YwB4y5L_We7Kk5aRe4REckptqgfH2+o2LxQ@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
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

On Wed, Oct 22, 2025 at 2:34=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.17.5-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.5-rc2rv-g3cc198d00990
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Wed Oct 22 19:52:46 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
