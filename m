Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886638AC7A
	for <patches@lists.linux.dev>; Wed,  8 Apr 2026 21:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775683681; cv=pass; b=brro+ROM2ZrbXdUFe8gviC3BpgFvKicu5azW1AKk4xM8Ufo+si6m1NNU8o33gfBioBYcFDnu/c63iYh8LSHz7a61qv7jSuD+JXna2AagVOeD7T02sr+y6FRFU7b4ALiHhy5p0Yi882o4J4OUrt33eOP2gueKImwkVkkQcmK88c8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775683681; c=relaxed/simple;
	bh=aPnizP9b0OD1NHWgBL8tQ7Q3pBsJWHAwmODj1zIl+lM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TDqoOZNRnuXH5SGRvwqK/vOCAa9B3e+TtNURTBURVGcZcSNypxXb4+OLnLq61W7CISTCJZP0u87FcuHwYX2CwQgGBA4pZGv5JgQA5fmsEwyT878jwn53FS35KExtiPspzHKvYCUdwhDXwzTSAxkCAwZqDQeU65jzvTJ7M6UyRk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQivphou; arc=pass smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQivphou"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5a0ff30b240so237234e87.0
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 14:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775683678; cv=none;
        d=google.com; s=arc-20240605;
        b=YaNYH/z3YuttYP2hYks4RR9viJXMh3gaWcPSVaozOzuDFj/hHqtw3nxwHjqCIUwnvp
         3nWMsUVCLcVnNtblcWdrEGgiWYUAQWkc/WZqBfnZPgP0Wyx9nbq/zldJtiMWKS7E7Ct+
         PJjVjQy+8IwygQWeXYJR5ENMdztE2jLstVuz9gthIvEKyEjZOy3PXXMbKd7vP0Jjz8xl
         3s0EiPg11ren/wy0DYCbRDZNsIJ+1L0QFHIpDrBHS8ezqqud15EAUvjBuuq1GGv7HIXe
         tR1YvUcZFh4+MlOef52qsQAk4ui+d0J8cSWpUwF3j8keMvFhcIFeeuviRK2scwaG0sFT
         sWfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5iGEsgY4r8/Vrve1iS7BbNBntHcD0tK+fgBtch+C2/4=;
        fh=5Z8Mu9JqwUsXhNpbbFiwl6z6OpLlU4eX8zeW3HXdGOY=;
        b=ZzxfvuVde6rCaM18tx54Q/4F+NYsKDmmqCpOOY6rLPVxrOBboxzXbB9QovYoU7gw4z
         Ohn/A3PUbkr9iTE1/4MycA0V4e9V0Zz7Hwl8zlBU6giJBlkskMck+zzAFM7Py9GGlvnF
         OIKQbbd1GyLEWGyrQBtHvtjnmo8+HktPbGjzlv+k/+jlS+ejnC7e8UvfuAluYMyi4gtU
         6sV6abXTlOoJlSmzTgKAneP9YmsPW2V02LQkxr2XYB9AVrbGrr0iXW2+nsoc48LNAwom
         PfFzY0oEwJPPy7g0zZVDcUIJQ584MJxiRkpmdsQy8R4VtsoMb7uPXn9VlEbUzkMUsjxc
         Czqg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775683678; x=1776288478; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iGEsgY4r8/Vrve1iS7BbNBntHcD0tK+fgBtch+C2/4=;
        b=aQivphoujELCdb8OKLg//xr/GjK59fSn84c7cWgyTA8euvZalTZCxyD9Otu1yEa6/g
         mH13rhFhRBhaBnLloSac5kfwMwGphMUU9sxA3HzsPePL9113F1ZywSoMBbaGfJYTEi4T
         SqyjBPZYCy6ySGgs05Brh7rceARdGg7wsmmy793/0ZPuFWmgYZ4ltao+ufHmGzD58o4T
         MTzc4EDCSo2f2+/TCOPinoWGoqkLsJKZGeoC99UpfYa9oSnPjsHXu43d31VSAHBgdmFL
         KobhUq3aZcCKFNGO9O6Dkzd2xklRrppJXsY+h9nMIdmBFwDFYCZGOY+QDUua8srOvo2s
         zwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775683678; x=1776288478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5iGEsgY4r8/Vrve1iS7BbNBntHcD0tK+fgBtch+C2/4=;
        b=eq7v5fKRaVtUNZIRw45sWM+9jZ4wTg/PN9JJ+8LZgoZQxWs7dx4vBWGx8Nb5DMrQsy
         neDKprRMJUszSHDgU7vTx88RtfhBzLtebvwLyB2TQOlL3tQisJEgFiCYxHlI17SKFL9F
         IIYbvVKfdmPdFYEX9gv5GGu0eUqmAxSt8X//K55PNjjPmXcClL8oSRnpTtwSrWIOw9HN
         bFzXtLEayZb44VIb7E0idD8VtYo/9UyAX+4JEX0CYN1UyBvDJuzxcVDUGWVX8SBdMl9J
         acbq4I5eW82piyGmCvKa7fS8PQcvHcLDdGLbD0XdGDMn7wXICqpNUIU4VzLhGm8XwU9j
         zcHA==
X-Forwarded-Encrypted: i=1; AJvYcCV1k+dhGB0cqyCuq4N0OZ4LdIqIK32aKJC5jDA+X3k8l7UnRLBEkUpaunTzL7D1tUnjxn2jaurH@lists.linux.dev
X-Gm-Message-State: AOJu0YwvurKDrwXNgzpwj9asnfUmZhVQUDm4jcYqY+hr5W8wt7Q4Lmug
	Gm8B+p1OMPCgyL0ER9KjqeLos3Am3FEcNfKpnyn+lvdfwre7U24vUr1eh5I8G6lc9b+q68z/9aX
	ufUz4Lg21QVad2Y0YV4UYDC/YBbj4uSc=
X-Gm-Gg: AeBDiet7vzbRrMpvF9K59SbIbhBmzLzTH2jb5m+e+wQekIWYqv69vZ8B2IoBVs5glKK
	Ix3Kfa6scdv2CKw1pS0swLcsAtvJ4JvF+r8t+lsxWfP0piK3zS8JmVjVtSTbFJxM1AAvjtOlr8O
	BwR3+EPsLXijqam+inGqrza4c1cmC+vPzJHB0aHaYdONorqga1SL+C5F1G4Qt4Pr6d8QUMlmBkN
	/X3lEIGXecimeeRd7VmHcHVJevPq7cKU9A3shGyP9yoDtVUDLk9B8F5pcWpsd93FojZE+6OkMih
	G81UoSTLux8TeqqWT+m14dgmx/Kqxdhgz8m4aGw=
X-Received: by 2002:a05:6512:3b0b:b0:5a3:d38d:c303 with SMTP id
 2adb3069b0e04-5a3d38dc68dmr5885884e87.41.1775683677609; Wed, 08 Apr 2026
 14:27:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260408175933.836769063@linuxfoundation.org>
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 9 Apr 2026 02:57:45 +0530
X-Gm-Features: AQROBzAzdjB6HUBtd7EKhqAAVT_KbcstgZfWFRM-qg5aEgQ1Dx5PfNSrQguo58A
Message-ID: <CAC-m1rrNc30MHbYJPDo1t4Ad3C3TkYv1+ZjB4LVTT0_MTLHV_g@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
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

On Wed, Apr 8, 2026 at 11:58=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.22-rc1.gz
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
Build and Boot Report for 6.18.22-rc1

Build and boot testing was performed on version 6.18.22-rc1 using the
default configuration on both x86_64 and arm64 architectures in
a virtual environment. The kernel built and booted successfully,
and no dmesg regressions were observed.

kernel version: 6.18.22-rc1
Configurations: x86_64_defconfig, defconfig
Architectures: arm64, x86_64
Kernel Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: ef4577f805c0b4438b7900b9949ad1adc17cac9e

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
