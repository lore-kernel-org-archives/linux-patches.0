Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FBC31CA68
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 13:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755696404; cv=none; b=XE9kAgCPvNizfDhm6cpzGYVGsempPzUI5VudORcYMIhwhZtZoLOaK46Z5dG97U4cHlf/kpEfjl2tVCeVycGPrnkZHAOGjrCyr9nqx58M45QaiotVn2TJlfAv/wtWHz/nQdTjU5TZdjE4/A9JtZuU/uWm1nZlDxtvGaCgLj0wXg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755696404; c=relaxed/simple;
	bh=0uRCBa5DuHokeAP8b7en3IxnvVTDcb0IQO3SjWgln30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uF4Xi579NEPBW8gQJu+UqZ+VavsKoBlWS/d6GkafcOjGhW9EdZ6KqsnOssvLFSTovvTYQFb15ZORxjzrjR1J6gm7rntPaGHkpLQkNxpikedhdXbmx9r1Zrnbc4gtBNnvrI0FpYYoJlxImkyFZxdipI72rQ5sNLfbpPpmZM7qo18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=EZBQnZHp; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="EZBQnZHp"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7e86faa158fso126700885a.1
        for <patches@lists.linux.dev>; Wed, 20 Aug 2025 06:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1755696401; x=1756301201; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pduMkEptKdLVMmJZmH218CFcitvFhjXDFeo33s0r6g0=;
        b=EZBQnZHpA8+tzMwggT3/NHGhbeADMoYBeEd4j2knWtHrjk+BdOPBDCZldCzKUxn5Ls
         wuu1Szm2RFiQW0JQRaMIps64P6GkwtjvEJEkAPiSBU/BizurXUDYQHDYg3fb6h2HkoQ0
         QT47TCkHYJ8ulfPil4iwUcvbI5La3o0AQZJFRhwRXaCM0sdH8I4kP2ZqfUtg+KOJqLi3
         cH8gU2S9EVS48dRwN5XjGYM29xY+oDlcfDLbYwuXc709UiYSpZrOhGnMj28U3ec1Zeup
         egeuszG0KFLyZLZka+jAWCaFf2STH0HA1ZedtSn4sm1jVUuXh3iIbVaZ3hWTXqJjJTjx
         TyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755696401; x=1756301201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pduMkEptKdLVMmJZmH218CFcitvFhjXDFeo33s0r6g0=;
        b=F2aFIIjO07YecO3YRaMLlLpaoNWCofw94CtDaUGXYnjS5gL8r1k+kJsihJ2Ik2CVYn
         VXN75jGx+Yr6BarL0BIXOeEtalda6aT+qfJ0eTB1A2VjJcyYvAgOJZaol3mRRQYV1iid
         JDq5iTnq5PubO4piZky+fNMnLJsvGgvPD+QZ1I1UJmkXyE1RNiLfwSnavVOk58xzQo1K
         l/DEY5agg+Tod+9wWSUUG+Ji7u9qp2fADiFLnEZ+55P4xh2OXzh8muwupslFULXjppQK
         GMpjmAim1QOaLitLDTdOKektCoFKtxu9rI7DzkW7m3US0HMZikMiK4XF4TW/60/DJb57
         rsIg==
X-Forwarded-Encrypted: i=1; AJvYcCXdIq+/9GEcRdd/CfLWn8wJoyA0ofwHQD6KffwEPHamG5X3cPTxwgKgGPTdPlruRwhakXRkuYEN@lists.linux.dev
X-Gm-Message-State: AOJu0YyzkOTXYpqOWhkK0OrAu0rXzF8B+NBV3UAoIZyl9A8Mw2Qog2cY
	vznoqeVO+4m0lV/bGCflXt88oyNx7J984rlJ1Efbu30rGcPQgQ7kcVXq9fSmA+qg+kOvy1AOtfq
	/c1i/KNzArKRdUS6toR78i5jCgo5KZpFd7kaOpiWkhQ==
X-Gm-Gg: ASbGncthYaVg6lODJ22QHaRX3O75wbifIH9VGk+5WAEtDPPD9Gfahw3BGGvCZ+Mc2fM
	2De6ZSKjMBMZpH0awwPcmDIqtTiBoEL4c2o1ws2kT+yEgaPXDYG6d49qvuuQ5O2iLSHzRTithgM
	2PJGE+PSqIR7O8Li7UZVo3CPLFwZt6nQqsZNfVGyUveXi8vi0/y/r5z09iAle031jE2b8leCQ5K
	AFAU8HhGLu8SL7MXA4=
X-Google-Smtp-Source: AGHT+IEFuP7zEWHJoh21HjBk2ylXFPhv4P+z+9swFEB6pv8mUDeiqmBE0z39lKhQPdd5eiXvNYtv0J4LLfK1tyaY6YI=
X-Received: by 2002:a05:620a:4105:b0:7e3:2c53:b28a with SMTP id
 af79cd13be357-7e9fc7585acmr318667185a.16.1755696400716; Wed, 20 Aug 2025
 06:26:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819122820.553053307@linuxfoundation.org>
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 20 Aug 2025 09:26:29 -0400
X-Gm-Features: Ac12FXzu8URN-aar7Ixa8xJWtMgHFMvicrS2nfeoiQQtmUGUKz6HliO5RbQkSeU
Message-ID: <CAOBMUvjakzTF63pwX0_GGswgKR+0TT=V4gPVZOOBuBbESqsbpw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
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

On Tue, Aug 19, 2025 at 8:35=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.43-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

-rc1 and -rc2 build successfully.  Boot and work on qemu and Dell XPS 15 95=
20 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
