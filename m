Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A0612E1E9
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 08:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798561; cv=none; b=Ui0huwr2UWUuS/+m6eBmjN3zrCKI4jr9c0WpXXnR9SgEBLQMBEea3Dektao2HuoPmVrDPEFH6BrHl0KB4wy0mI2dOm7m5jzDZQGx9ynJbhwzcHtrFTnvnjrlsQe23yezwO4FGIfeMz8zUQNz5Jsj65jurMhTX6/EteCH1wRTzhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798561; c=relaxed/simple;
	bh=mjQpM8uJCD7eyFye+z53uA0Js+MvGo4jYaTp2h//ROg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npoJNzdkXc/quSO3Hgc+5o5c6LlK88TRpSwBeyPlZd2MdbNLcLcoCmrdpwfnWDk04syQjGgWOle7rTgby5gsmLabCHO1wPxghvfA7N68pxsV/4qWEYSyfD2No6F7BfCaY0QDqhpHfoiW0LgTBuu2mTCGVmqObIRXfGPe8Zf0fHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pqtUXX9h; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pqtUXX9h"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7a81bd549eso163641366b.3
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 01:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723798558; x=1724403358; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WoJE6qKRAZwDfoJxwthtCXkhettrA6+z4VsWqqQmsO4=;
        b=pqtUXX9haleqdOcLZWsi5y85p/uLk5OSzm0h9YDBezaOBXpQ+7Z490dMlQoyc/wUMd
         HDW/fC68Rz+1h8bgAz6zwu1yzGCT9+ly/1WiP0thZQvuYnJOXU1HNC4s3YvWvJ8DiJII
         dFh5HsccPB3Q8ph0TZQ64KFYeuT+WUrPjjKz2r21HB41fhT1ls/y0M7g5t6PPCHg4dNI
         sVer9z9w+JQPQKYm8WruGnUxQmobcN0goHAEEL0TIZHgVDyS1IOJCctQpIHo2b71amgI
         OPVlJ94IwspxD1qsi6j68lHlaxJTvR+WwfNPZQ77iM4YPGcPYyGqSjAEgzyia27SyJId
         Fl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723798558; x=1724403358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WoJE6qKRAZwDfoJxwthtCXkhettrA6+z4VsWqqQmsO4=;
        b=qXQ1niJR6AtqRg4HgzxMEB4gFhjKofkCxQ3OYy268fXpFOYjxv5gr5omAiISuZoe7V
         8r/RyrEE7orUZxIzgumZSmLNRfnlm8E7rEw8PF7GJbt39gVXgdrWqJhJYZhbuVr/SOav
         5IgbaassNN3WqELfRC+USKh7zfW4CMUiN5X84DEdka7XC/nJ4OFZZ+R2C7Ynul8mmL5m
         sKqVT/fwQGH+aRA78Ka59rq9p/MiNc0goGfeFasRfC4jSQdMsJbD11/fuqo2FMa8F/tu
         Hw6SxbsyLrJyLl6N4xL3+yi+towCBDWYbTAtg/ZiTi4owwzG1POOYmksUOy1GSyUBfxE
         bCpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwfJCoHWbWWYI2qUIuKUAIpQNuFqEUjsmdntr2Uqr2NRI4ng3iSzlnkGMHiwasxUnfptKfFx1KJc9kkdp3oDLM7oku58VPhA==
X-Gm-Message-State: AOJu0YwDUCaKBW84YBH8PxHw9OvsJVin10T0CrmqXq/HaAii4NYzglKh
	HVIIkKQt9sXlpzcRFDetlOOEYdgYKzT/ZPfudqO6cJJJgs5fu4AOTXZOTzin16g0h5wr/SvFtnv
	YW4HyHPHmz58O9tglmduY7WuduP6t3lQwGGbXYA==
X-Google-Smtp-Source: AGHT+IFrl9O2aVZpsRSlg68IlGM1qKW5ruuvScEIT4Tazv0d8eLt4WP3OnNdG9x3zIM9/rrZHqWKBiXe2s8ieqbnOAs=
X-Received: by 2002:a17:906:730a:b0:a6f:1036:98cf with SMTP id
 a640c23a62f3a-a8392a0393amr169160366b.54.1723798558229; Fri, 16 Aug 2024
 01:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131919.196120297@linuxfoundation.org>
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 16 Aug 2024 10:55:46 +0200
Message-ID: <CADYN=9+=+af8c=_GWSsFHoL7qX0=gFA69g_8mmJiJ43=p-2kzA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/352] 5.10.224-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Aug 2024 at 16:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.10.y with gcc-12 and clang due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig
    * clang-18-defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Bisect point to 0fbb54ce4bff ("KVM: s390: pv: avoid stalls when making
pages secure")
as the problematic commit [ Upstream commit
f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].

Build log:
------
/builds/linux/arch/s390/kernel/uv.c:205:15: error: implicit
declaration of function 'folio_mapcount'; did you mean
'total_mapcount'? [-Werror=implicit-function-declaration]
  205 |         res = folio_mapcount(folio);
      |               ^~~~~~~~~~~~~~
      |               total_mapcount
/builds/linux/arch/s390/kernel/uv.c:206:13: error: implicit
declaration of function 'folio_test_swapcache'
[-Werror=implicit-function-declaration]
  206 |         if (folio_test_swapcache(folio)) {
      |             ^~~~~~~~~~~~~~~~~~~~
/builds/linux/arch/s390/kernel/uv.c:208:20: error: implicit
declaration of function 'folio_mapping'
[-Werror=implicit-function-declaration]
  208 |         } else if (folio_mapping(folio)) {
      |                    ^~~~~~~~~~~~~
/builds/linux/arch/s390/kernel/uv.c:210:26: error: invalid use of
undefined type 'struct folio'
  210 |                 if (folio->private)
      |                          ^~


Build log link:
-------
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-353-g4dac9055c10c/testrun/24874277/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.10.224-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 4dac9055c10c8973c91824a692ed00f3f650e5f0
* git describe: v5.10.223-353-g4dac9055c10c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-353-g4dac9055c10c
* arch: s390
* toolchain: gcc-12 and clang-18
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2khPV1GrHYOypPzmwQE6yACrEg5/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2khPV1GrHYOypPzmwQE6yACrEg5/

--
Linaro LKFT
https://lkft.linaro.org
