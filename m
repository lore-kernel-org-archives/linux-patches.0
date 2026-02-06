Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7791C30CDA9
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 08:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770365021; cv=pass; b=p9f7G2GMyrJt8fiPnlqvWBxjPjsiWKv75XRthRXAVVS5cv5e9uSmCejXWSJZXnlMnhmYmboR/9HHOVQVAnHxoGFPGGxxBYAqQ/8ATzoHh/d6zr60gge0Hc90oyqT/fYu48wYggmjZ/a0muk6xAEjkNvyLbrU5czJolwLya3QANQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770365021; c=relaxed/simple;
	bh=QsKcB0T8JN7X3zlFV8+xIhURzxq51vgPi2dHmjDOEcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IzpKeP07HZKPbuni3P/cUvHhvdpz8IFpZeHHfFbW7qIOrUueC59FaP9y4RFLjfO4LagupfvGCSWtyCC9V4SsfE8GJ+uGy4yBdCvE1msvrNngfZ5xonEfsiqbZuz0t8fCej0DNFavGQFYGmoA522koja1A0couImhKoAjtpVRy34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AtC6fc6Y; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AtC6fc6Y"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59dd4b602bfso2328745e87.1
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 00:03:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770365020; cv=none;
        d=google.com; s=arc-20240605;
        b=GR9Bc0ng/ZsvZn66ov2m/TfdNhwDf0Q8WXeEf/NRK8sV0+YoDDyjvL4illPxncM1qn
         9550sregFwqJMOt1+xMDxTw6varW5fh6HRjX9XIQooHRkqLq4/aTThdoz4EhYxLwI89Z
         CbBYAakfVgKs1tNwB8n4cgVAEdKjdcmy23YqksXavTcSahgTx/hJtD6N/NNWw3QODkYd
         5KZvfRJcAr4SOpH5aeBn4d+J9/lvxyOfrgIDiDydK2vFNComEzG6YQ1VO2DCFHsxywnW
         ShNFECKsGd2GesDxnSn9Fz5AodMjwPZc0am30BnK+v1YYfixA4Y0uXGSZH3Gl8M8a3O5
         HWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s5ENqevh88Ydsd2wEXZ9939rHOfrTJlZPKJrBfilDvI=;
        fh=A1IvCSfhILJqXnViayVcDl7jSn+OzEri9ib30r20Nwk=;
        b=Q8k0YT8FSkW/izZ1V6nSfo+AUC77wReJEvdRwMuYBQoa4P+oZOPIAQUJNNEr51DWMq
         GSZH5b9EUSziUokTTkyUwu3znsOufM3xRSlvs7tYqUTaXLF+yXIlo5nqM/HEYu4r1GOo
         H2zCJX856Q7dzc6tuzfvk2rIVLaM/DTzYJaMaHbBsPdcGAz8a5MuehrLkx++WtBvNR3M
         5k+PncZ2/LSkvxswoejYAgJj6EbOa377xh6NyAEXxA3G73ncaEUHFd1DelX/Df9geE1E
         KXe6ZyrASkFBwtphwkEx7pQC4g9YyTWXvwUr8EEMY8S+eZdRt4Vj7xoSl/oAg6gpKqsy
         l5lg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770365020; x=1770969820; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s5ENqevh88Ydsd2wEXZ9939rHOfrTJlZPKJrBfilDvI=;
        b=AtC6fc6YmYnzcssEUxSWLrNaSTLGcRU/MycZ8PnXUkrCOzFI7ABwi2Xo79yf6L4ML0
         BolnaFwk+xFIulIoAD9MkXb6OG1GapCasm6+0M9C3wW5qk1KRxNr/hNZliTLYWM71cQy
         UC+ty1GWwtTauRxPoYGX3ak2KaR8mioAbe6/qHTRyrjHtnSpVYnEkzOSIhhQDIj5P79f
         gaVgpdCeAuG2gKzt4vrauhIhd9ZLcpHTsokh4glOzkJBiUr98qJOWupgkxbYEma9By7C
         p1yvNm/CPy/prnFsaZfTVxNyWDdfEjRRjhLElhrqAFamSdIPE/BeJeTruG0yiCBaFErQ
         k1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770365020; x=1770969820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s5ENqevh88Ydsd2wEXZ9939rHOfrTJlZPKJrBfilDvI=;
        b=BFImXiHm/8sElL/FhANWzanqSvvtE0yDt9AsWBOk/w9UdFDIEqf/8XwHEFixD9u8QF
         Q5iUUh5pkk5jAlL8SEXXKK3XYL9Uv2RHUH0JxDQueYewpzTvVdooFbaNxdLuaMrxB7KA
         oZz2k5wO4D+ndOEGMCCGiO4y5uaXKGxF6Uu22nZ4pbUYjOf0NoLKE9r228ACZkNQf3In
         AH+4v6/0XMXEBHkdcC6fCmTBnY0Q6kk1Ja2lKNadB4KmzVAmQoMsLeO4H6oDC9WQz99Z
         12Ek45EhlyA8Bb795YrPe6AmDbdezdI1V9WmYvLJtfzzxmDvkZ/vlJ0fJfT8rl3uUWFD
         c/iA==
X-Forwarded-Encrypted: i=1; AJvYcCVeopf156jlX25TR8QIxh7jXw7QAu9L9lkSpJ4nOrQkmPhR3Pu76YULB+019mMEIkxGokzH/kP6@lists.linux.dev
X-Gm-Message-State: AOJu0Yzx9q0k0NTVZ9VqrFLER2xZGYlkjktr41p4LgFkmKCOggCpN2Oy
	JcWI3T/l2/oLsL5ZxBVWhwMLZP/+XrNV5+xLvPK8HkevzQnOiw8Wb9SBx/w2xa3IxVe9rJjXpKQ
	jkFWFItcUL6rtOsOSiiu22o1Oz5DVQ30=
X-Gm-Gg: AZuq6aLNXk5ymmWWfLUsfWAk6aZ262yCOdjCi5ZapFfn1wLuH7EjvsHSG9mDczwhyoK
	EVpgt5hLTMz0HcVL0V4em1HLVvVhszLo5A4JjGaM/fnEORe7OiE5QgfS7QTzQCEfx2ba9xJ6eVv
	k/UtID/KR9H9bQgIKrae+h8KGnr4B/NpPLl5qkYRue52qPF/YvLDdqzvPOb6ugdqulwRosTJgO1
	+7csWGB+qvyWrbb1dAsmMbwY4mbUR1cd/mu4OJv+Bcf4Tyj1McJxe7hKqr3o0/Q997j6YY8o62R
	OFumLy7vHFPgkDxbqsRpx88wrNkZJQ==
X-Received: by 2002:ac2:4f04:0:b0:59d:d50b:aa8b with SMTP id
 2adb3069b0e04-59e4504cda9mr514236e87.15.1770365019362; Fri, 06 Feb 2026
 00:03:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143851.857060534@linuxfoundation.org>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 6 Feb 2026 13:33:27 +0530
X-Gm-Features: AZwV_QgTkF9QBheRUHy2upwkFWmU_UvU3JThLDwW5NlyLjdFl4wz8m3mJk4lOBY
Message-ID: <CAC-m1rov-iBcwJBkPaPPVHmENc31gAXYTZF=WCT90Son8JcirA@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
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

On Wed, Feb 4, 2026 at 9:11=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
build and boot report for Linux 6.18.9-rc1.

The kernel was built and booted successfull on both arm64 and x86_64
architectures using the defconfig. Testing was performed in virtual
environments,
and the system ran as expected.

No dmesg regressions were found during testing.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.18.9
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: 28a73c31d7f5d9d2276c92e1d4891c18a5631e6e

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
