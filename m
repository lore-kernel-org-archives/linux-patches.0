Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665F5195802
	for <patches@lists.linux.dev>; Thu,  6 Jun 2024 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684133; cv=none; b=imWiex8++roU6c1JHjxUfyYuKex7IOfzbaAjwHDbL97aJBud8SkI4Yey3pzCFxNHdFeifZfv97bWzwdv/SZyOHoG33xXIyl6t6rcBsrLA7aIpicQ6GCMXIJRGxarrKhtKfEpzMX6cgUtBfE+IGTix1ujwUN8A0VNo6MIBHEQ1NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684133; c=relaxed/simple;
	bh=SuESpoipjH2XBuKfLdMHPYPL7Cn4gPPdzQBAHmXOeUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fPuog/wlS8/PkX9VYWwb0b0RV/qRpb7VTAIfTPc03iWPyO0vUYxDmVJ99N3kldaaIU5qxlUmxKGWK1k5nFdb72dUkgcuqZjIQ8quNyzR+0gCpIIWTD/jkzUe/Tc4+FifQ5XlSc0VYF3ECbmqUxfza5xZi1i2NPGWdlOVKMD9PS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ArqiXD26; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ArqiXD26"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57a9a3bc083so510564a12.1
        for <patches@lists.linux.dev>; Thu, 06 Jun 2024 07:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717684129; x=1718288929; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eWeMi1z4JCK+XMEvQCFUyZ6qEqWXaYSEpXs/63PCyO4=;
        b=ArqiXD26j31O8E5ASB1cDdSxAZiawPH9HBoNq7IOoJUh7G+Ct/LQJ/4TjkV6g8xgWA
         8RzDfTOUi2p5Q5fynYjJmBG0gO6mk7WDJLboGiOFlgyve6+F37hihyvgT2Iaja4AMffq
         /Hu4u1Z98tSD9fxrZTj1fXL7KxeFOzzIC3os3EVDUvl23rBdgduDBMVYiaOupbXQwJv2
         /9HjNB1+r7lzTWBYdQD9UTpOsOgUXdI1wtUc4yPAOFE0wH/CL6zRfnGnHqgAFCknhW/0
         YjV5lI5O7FoZMY+uJaKk6A9JAi/s8JTj7tno5Mb07jkDd3h8J2DwMJDGKA12L65ibWXa
         8ChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717684129; x=1718288929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eWeMi1z4JCK+XMEvQCFUyZ6qEqWXaYSEpXs/63PCyO4=;
        b=OWUk6pxsnqHp7fBmej4CIEGfBI28gDiY8c2jjjln1QxhXWlh6CXR3OM91IumUMl1gt
         EqmlUlUtdmj7lRyLo+d242QeGV20V/qmCvG5nqkcfPXlgKDdXL0Wk8LJEo8HAHetT2EU
         +ihhoYw5MC3RazmjQUww26kIegRDU6maoXiiUpyWljMQ7VBj6rDMdeal0K1/ZsM38neR
         SYwv+dG9iYBrzL/ih9ppWASOB+Pni0fDvESlct8wjZr+Krt6Xz+GvthN2CXyVOrgKcv3
         w0RUEW4XnylXeRVjUvn57r11HBELSxHy8kklP2eUmgb7JBNBo0ZQgz8rGxKj8CiTvB0M
         hpLg==
X-Forwarded-Encrypted: i=1; AJvYcCWdmE9OVSU2iOfEhohIDUQE44yUKQNrxumPDqM4mkQfVdwUfxyTuO5FYQwflTs2qSOJeBFUORAPk8EJCvBXTisFVD+KHoXtvA==
X-Gm-Message-State: AOJu0YxniaMWFYD776v28NpPc26U93GTrUuke/GS3BaL+E5HuVKcI9xZ
	gtprjZ6wP5CYHzAJXBW/Z6UiNq2hakUvAPDlaYY1KCCNeLpfoEMyK6+q8/NPEPI6H0yqPgCAmx+
	sBnYenj5dSXKBP0PNWkQOkU3PaxjH9V1kAV2V2w==
X-Google-Smtp-Source: AGHT+IG8pQ7JMnVsI3Te2WeC+Hdtmyjd7l9vtYflmm0/97yZOaS7cvIZtnWYmC1G8hdhlyHcRvLuuSiYPVSyaA6Wfbc=
X-Received: by 2002:a50:c315:0:b0:57c:4200:a958 with SMTP id
 4fb4d7f45d1cf-57c4200af44mr1264695a12.35.1717684128664; Thu, 06 Jun 2024
 07:28:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org>
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Jun 2024 19:58:34 +0530
Message-ID: <CA+G9fYu2_bDqLixtW385KX5Vsnrmsi=FxQVgwUgnZ9qztSLW=A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Jun 2024 at 19:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The Powerpc build failures were noticed on stable-rc 6.9, 6.6 and 6.1.
Powerpc:
 - maple_defconfig - gcc-13 - failed

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/powerpc/include/asm/inst.h: In function '__copy_inst_from_kernel_nofault':
arch/powerpc/include/asm/uaccess.h:177:19: error: expected string
literal before 'DS_FORM_CONSTRAINT'
  177 |                 : DS_FORM_CONSTRAINT (*addr)                    \
      |                   ^~~~~~~~~~~~~~~~~~

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2-803-gfcbdac56b0ae/testrun/24217279/suite/build/test/gcc-13-maple_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2-803-gfcbdac56b0ae/testrun/24217279/suite/build/test/gcc-13-maple_defconfig/history/

--
Linaro LKFT
https://lkft.linaro.org
