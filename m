Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B1747D460
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 12:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789042068; cv=pass; b=B1Rt58nFz9HIJVWGKqUyOvuJ+yDY5Gky3Ms1MwR6lw9YmxBX4gis3k9jGJxnCtt8nZVkRH8ZI63dd39LvRpyWWtBQ36ZiEkiLR6bSxLqYWFA3uR2osoLAZvOay0yCH1RnC7L0zn8yc7PBR68nWSUcd013eKJ+0WyWYDY7Sf0VLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789042068; c=relaxed/simple;
	bh=tSzuqoYB9TXawK7iVxpqBGLCSAEWlfbPZXo1ULqmVg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJUTSeY5uwVamPq2KhqNpiA9//jXrGlPcr6Z3v+72JQYb6e69om92XbIjdhGN4FQHHKyu0ltH70OxIKYXvWNGzW/ygapyU4uMjwkn88IV9s6tddlpiNGw3osTFKQ3PGhFowGi4bQ2EkCBjV62qTt1nt4YCaNwQLJGG80wA7O4Os=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TjCblySc; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjCblySc"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b4afc8465eso1338064e87.2
        for <patches@lists.linux.dev>; Thu, 10 Sep 2026 05:07:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789042064; cv=none;
        d=google.com; s=arc-20260327;
        b=ARvXGiEILY/P/StFVUx8wYKR+fu50VBcS0h6dxsiQlSqiShGDM7SR3gBLITaDD7WMH
         iar96Fqyocymrsjzq2b2EnKPEFTmW/cCW16mz/8C98pETfT+ZtI0GPBG4TWxGk3p1Jpe
         GKv/i/dtM3Kbykbu5BK2P2UMMoKhDvscaS5EeWLIDKdAsJh0br4NcwJ0Jx/ldzyp2eyI
         DBh+1bfY1V3723uXFQM/OZiweVgagHo3+eU8iA7u3Ag0GJ/iibWAjSyvQEjZA13DWlXM
         kgzkw7MX/k6W3+0I8M6wez62b80PiJDM8Y/Q96PEPQiJAcbY14CBcWZIUp9jE30h1z0p
         wvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/nSVcwff+CVcVUGrv8pukezXki6t7yHP2l4nc4EnAh4=;
        fh=xPeGT/IndvAk+1Uq1ssqaaj9t/MKMw0jM1MN2HYdEGo=;
        b=JjbpQXs+cnemNt/b/gYrI87FYeAdG1uU2ur0GUyVgHcgNFTmh3IdEOM3WSTekZ749y
         /eo6BeajZjiQYcqZ615nJ6dqx7WrsBdlIYHWRaobFd8KMI8Zw89fbGUWZn8VmyjIEJhh
         YtuBRlJYTewXGpohUmLxRIukqfnKsRfjxuslCNrFvYb7xds4S+ZGwzR429t1BVpAbRKY
         VO+b9n1muwOS/L+Co7P9vhJF+6OboB3kU0ndk73CYDE43YpRkCqlyfa56F3gboV3dLIr
         9DYRF6aOE/sLqqiD2vgeOS7GwZcojiLmBqGWUJUOPtRK8sqx3fcMcAR7I3KZ1kXBLyHV
         Ta/A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789042064; x=1789646864; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/nSVcwff+CVcVUGrv8pukezXki6t7yHP2l4nc4EnAh4=;
        b=TjCblyScY3A/7MyAnBiYhv9BOp8EEbkk5thKrQ6i9PFtWBKfF+Y8v4iXwwa28Jhehf
         TzZzy+cWy9v7QrOn2IACypvzmmY2DR2jZ2Rcz9dgm1sSMSkzXgNcxGDBJzJ1z4bMve0Y
         lC8kiFAlno6Uv2j50Yv4frGYLzukNZNHDFYvfzI2jBw7CnN6LyNIQgfkiuxpizOePyDH
         bgiYZc9lsmVVz7NMUY93x9TfsfCegpXL4X8s4BN6eqwY4BWpGwl8DM7B2lfzjVNdglJK
         alT29gTB2Y4vmFpmFrjEtmJh39IhA7AUGpDCTjaaJ7TtcUs+ywYQx/fw+l/gBv6RCG7X
         jtcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789042064; x=1789646864;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/nSVcwff+CVcVUGrv8pukezXki6t7yHP2l4nc4EnAh4=;
        b=RpwoH9GpBUaabiBZEIhkA8hx/TmS/168EsHVcsu7TKSA3+YZctcAvjkkK9hAr5unbD
         UKJpN2/YzBAUXriH7P4InX3TGLaGBKiIQ3MxYte6MvqFZNk7vSOPezKYko20Y2FRgUSL
         VLZkyHwMeD0KbcXqfFG1qnyA4bYCJI0V4YBmHqcwqsG0XjBcuP+XvsARYN5+W3VMP0bU
         wWlvP16c4xi1uejYMO6KqzHbqe4Z9WH/cshYu6v2l+7YbFARl+v85whB5LqSf8A68qVd
         0WryEI+K2ejpgZyyM6odtUmu/ajtolm9bk+H5lON1lts4JaMYoJ94c8RDA1ivsel/XIe
         FUpw==
X-Forwarded-Encrypted: i=1; AKwUvBxK+Jyqnkbfw5mpsRtSnLkeN1URhDF35huo8F3KlYnFaSL207oNJduA6etH2tj98SbI7uVbBLOp@lists.linux.dev
X-Gm-Message-State: AFuF++neJo4PEGWDQKBIUi9ZHkMPZdfHR/IfK5hPG6FSX4WjqnJVKCn6
	1QSwx//jh8wBpikZXerVj+hSLb5ugDWDKbp+DD3mxLYQvRYQS+W0uMOfcf/Gf/rPKuevfvw6xdR
	I6ISZpNkwRjI+IB/8f1bSeokV1ZZ6Nds=
X-Gm-Gg: AYBFou3Yy99hEsi1QOvGu0vICD0C2PsA/4TIoz4RKmMAngiorGvJtOgyyD4dTb7Yo08
	1wMWLJueII1ANFKsoMWEQcoUL+zFRpM4A0969FmVbMn5wnNK6/Zau8UpdAbmx/7Z2Th8FghelpE
	e+o5tigfVACLmWhTICnh5hoy665KPViAq+X45ss/vxuxgp2dkvVOQuy5V1TfboUWgl7WEaxoCO8
	Z0rjkgSGuul67QSbNHn9slWlU3ARKjQwcA5snanxKZgLrVtdQyK7rFhtjOnpdIjJyN4IS4ZI6KX
	umw35JHXJFkdQa1ErR1Kmz6oDCEojX0G8BicTJuMqLIbfS7NjI0isT9LvtUIWn51VxxB1VRREqv
	nbfN4LYu3aWUyEg==
X-Received: by 2002:a05:6512:224b:b0:5b6:1a7c:fd8b with SMTP id
 2adb3069b0e04-5b61a7cfeebmr7039690e87.49.1789042063842; Thu, 10 Sep 2026
 05:07:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260909134230.441546314@linuxfoundation.org>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 10 Sep 2026 17:37:31 +0530
X-Gm-Features: AcwNN1VDrzOq3YTtrG0etUeC6fialLxE7RZyO0hylbbPOfOu-9j4MEH0Rj6kjX4
Message-ID: <CAC-m1rrWxAUSOw3H8jiztm5DbXFk--LopHmhyB040WA5ieAtMQ@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
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

On Wed, Sep 9, 2026 at 7:48=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.2.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
tested Linux stable-rc 7.2.5-rc1 on both x86_64 and arm64.

The kernel built successfully and booted successfully under QEMU
on both architectures. I also checked the dmesg output after boot
and did not find any regressions.

Kernel version: 7.2.5-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: e01c81012950bb7454e595765197025a0fcbc0d5

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
