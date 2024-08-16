Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7013B286
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798372; cv=none; b=lEeeSGnQ2c9x+mfKBCtT4sQJY1ou+qvF16aiTMCcsetes1bmA87bIfWSvbXmcoOHd0tcvV8hEonsNK2FCzXUsP2oUM+iTV9Wzftyxl0zN5UhJSmnt86a6Odm2zaW1nA37yn7BEdiJezNuMUMlfcsKrv0sJGPseXA+dR0ZOE04p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798372; c=relaxed/simple;
	bh=b5VjYZomUq4QLo7azRFOK7rbYbpMDyOD2BeliqnLSEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S85ThbMzyjvGXLbeE7BzptDs2xnSW/xC0sOljlMTwuzfOir2+Irt0KX05YQIrARaqcFKyhRbPJBR9IAKTn4EQXUWMe9lHPaFoR6TeAAW+vOufpVSGIuktVSUrQp6V3mmR0HQ4CECsKYuJXMkCfAWIpEQ02KnTvTrbORVkQuhx60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n+bpstdP; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n+bpstdP"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7ab5fc975dso189028766b.1
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 01:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723798368; x=1724403168; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e65/T9qUroc+GcaiwE/lqgYH/wsQj1WvG1P77AhxpUg=;
        b=n+bpstdPVXS/yiKOUuY30WARFjhZLv3GEY+9xHQV/7fJqZxo6vrDXon3peKM1UBC93
         C000Xd8GqY4pW6PeJJgXbhpqgcEZKW6L+fJ/wVxJsW15gqLAFPqbyC+wY1D6kGXdha93
         Zxa8XMe6hZKy/2l8h6Qtuobmrfz+p5JsADW6aWJ8EB6QQJ8tyFBL++BizuUQCCik+mbc
         cZ2Iyz5wxzwrdQlvj5d35By6OQKxtyfxH2htnSnHjDKUg83kYBpjBWudl2P/zgC2A+AS
         eruJXocEJNJzIyffylvLX5htrY0sqhQpg8GpUHZwa6o4HcGQWikP4mRPEJaSouskYZ8k
         vZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798368; x=1724403168;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e65/T9qUroc+GcaiwE/lqgYH/wsQj1WvG1P77AhxpUg=;
        b=ilsWBIAo37nPcPELvEpW1jpArfKObMRl7/CDDAq0dK5kt8Bgu2VMOE0T5Rtx8SNGm4
         bScrSNSOjS8hIYS87c1rg0DQn5WzkZ7ln43bV3+WBlEDMn83+f2N0aF2IUJChUUZdccJ
         Gwfziyix2paSoLLyHjZxPUeG7iOYvZo1VKaaKpCGklJqTMMj9dmB6ifeSEcU7dFYs7LI
         Pg+7poNFAbIN6qH7oetepSGFRSzgI5DslharGSCPs26YP64jv/Ebe2o7zXQo6Va0mvR2
         PygBIW1+HFD//9C16ZuVFO2uM/kuT8DAtgFHDoN5bncv6CQBLU2FUPJb/7NMODT3iYpd
         tTJg==
X-Forwarded-Encrypted: i=1; AJvYcCWqvsjRDqlRH2/tnwMyBWCVBvYYihawNEFPifSotXqEJeYq9gnRtyrnO4kF+j6WxL6rCRHkbMrzcYX58KxKFc/rZiLZv5nNlQ==
X-Gm-Message-State: AOJu0Yy4VcVHAm/v3rjCPsnIGhvRN0K0oCvo0gzKeEsVKfUosbtlV80E
	BDoVVcf1pI0S6veXi1Y63KNSoQRb0XWGk0B6Hn3trsGc301X5d5eb02lQ4RbelTU+tf0aEj2RR6
	tbuJTyfN7V1G3A4oz3+OgwhCFtqeqnZFur7VPHl8wu064cBiOeYNOcQ==
X-Google-Smtp-Source: AGHT+IEiGLOupo2idMEIYgeBEEhwpy74x2AZzsa9raRzuh+5+yX/DVQkWeGNuYisVyq0HUy+LQnKGZPFddeuMn+7bKg=
X-Received: by 2002:a17:907:e25e:b0:a7a:a892:8e0b with SMTP id
 a640c23a62f3a-a8392930f95mr145350566b.19.1723798367668; Fri, 16 Aug 2024
 01:52:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131941.255804951@linuxfoundation.org>
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 16 Aug 2024 10:52:35 +0200
Message-ID: <CADYN=9LRUpKMbBebjkcy3qo3O_1UFevA=x90SGZQ7ja5FXHG3w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/484] 5.15.165-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Aug 2024 at 15:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.15.y with gcc-12 and clang due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig
    * clang-18-defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Bisect point to 85cf9455e504 ("KVM: s390: pv: avoid stalls when making
pages secure")
as the problematic commit [ Upstream commit
f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].

Build log:
------
arch/s390/kernel/uv.c: In function 'expected_folio_refs':
arch/s390/kernel/uv.c:184:15: error: implicit declaration of function
'folio_mapcount'; did you mean 'total_mapcount'?
[-Werror=implicit-function-declaration]
  184 |         res = folio_mapcount(folio);
      |               ^~~~~~~~~~~~~~
      |               total_mapcount
arch/s390/kernel/uv.c:185:13: error: implicit declaration of function
'folio_test_swapcache' [-Werror=implicit-function-declaration]
  185 |         if (folio_test_swapcache(folio)) {
      |             ^~~~~~~~~~~~~~~~~~~~
arch/s390/kernel/uv.c:187:20: error: implicit declaration of function
'folio_mapping'; did you mean 'no_idmapping'?
[-Werror=implicit-function-declaration]
  187 |         } else if (folio_mapping(folio)) {
      |                    ^~~~~~~~~~~~~
      |                    no_idmapping
arch/s390/kernel/uv.c:189:26: error: invalid use of undefined type
'struct folio'
  189 |                 if (folio->private)
      |                          ^~


Build log link:
-------
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-485-g0a33b8afe07a/testrun/24869919/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.15.165-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 0a33b8afe07a366222228559e4dd1de564dbdf13
* git describe: v5.15.164-485-g0a33b8afe07a
* Test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.164-485-g0a33b8afe07a
* arch: s390
* toolchain: gcc-12 and clang-18
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2khLvf8Vv5pS66ldvXrSWZd6CHa/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2khLvf8Vv5pS66ldvXrSWZd6CHa/

--
Linaro LKFT
https://lkft.linaro.org
