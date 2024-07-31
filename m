Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A1715884D
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 07:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722409648; cv=none; b=qxddhQRH8o1YNmHQUT1dXeQdJ0DMJLoe2RmdjnaCqzhQnKOz3dp9GryqrOJJy3ycLgDN451gstP87cwq7kaAup3+lO8T+/yeLm4PRhCqb3PHGO8WGfkKn+Vq+DASvQDbWmr06Gj7YelPM1bk851GQuYjb7AQqb1QqzmTF5mrvAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722409648; c=relaxed/simple;
	bh=YPyvNeoLsZV/8SRLmt6tzoyEftxMwY363Jj6/4Cvt9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T+UlTTB5Umr+f90cyrhZVjUQHStHCq2bvHfzWlPDI7o4lEp7CS4IMCaXKuE5RtskmAua8dhA/V5OIbYk5H2iTnB87ST69AmQUZi2NM+QzToqzVt/QwBiDt+AJao6zsh1Gq8eY1i5qeMaCCg+SOhp6yE2J+rQV7wfnfvT3wELaQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L7hr+4vy; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L7hr+4vy"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7ab63a388bso416448766b.1
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722409644; x=1723014444; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tpy+nnibbUxT24aBwgVje1ug92d+vgtxsaPNSOQztMA=;
        b=L7hr+4vyE4pDdTw5FSkwIBBV3VaD+RbZhm/A/OcG+PoyMjEAUG/fbFIVihV5wOdZBN
         exO1yDCDdmxe6U4pWQHw1vbs3o5XFvRjV1Snwu1A5k1vfWj+9fpEnKzV1/3zkdEJ6oby
         4NakS3CJUKA+4UPJhhkQ3Kaffg56LPiCKSebQjj5UJsFy3Ps5kgnCCQ82qejXaBue1Rr
         QolWRfwIDS/N1N4QgKkESllRbaN93yPoGiQxMC7V8VVuX1lk3gtc1qJaVzoPE2OaRO6Y
         bcrRPDhORZTSoFnZnsnyQvof/E+HSvMoBBMyB0aTSswDQgyoBWcoaNrKnjtKSzg66z70
         2kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722409644; x=1723014444;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tpy+nnibbUxT24aBwgVje1ug92d+vgtxsaPNSOQztMA=;
        b=tjt+YOjV5ObHBb/+nnrp53aYaRsriomYlpPNPwNu1G5Eob+WHfV7vt2xvSeL2j6Vhn
         9B1tJJygB82Lfk3qXUJDxAd7GyMKzib/e+YXzKNNDML8X29j0KSrpDNG4kp7tRofuMUL
         p5lgyKfaYXDrzxHQsniqmwS61kqtMabWWpUqr0giuHY5gZKLV5pYvqoFcfrtAPrZpJz8
         o4ub3jPd1WoP4G4439fk8a+AflhjXgu9KgIF8RGymBmLw7qgY01JOt0clFXfmEP14hE9
         7E3LTSeuQQpgu5G7UhbOKLwjCmVQFyewuldtOg6RHP+413eYGnhmySDV3Ugk385gDo4a
         1wXQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7Pq1Epgj4usxuMYLbNWRn4NfSV9ozknK8QlpRYxpwXzwjJvJ5R2vw0iowjOIRoyXlnPphUFxdoFVX3IizMDOAlluWQBPGvQ==
X-Gm-Message-State: AOJu0Yyhpgpap9MDidH3lb3Rn5Xg+pmdUFsXlFsR60Z048z73ydXqQQg
	P5xf8qXa5M56bdDvqqf6oHCZzjpplGRzbaQmGSR3WtDjyA9KSZnl6z2t0Npbe3B7+MhOYb3hUY3
	yrOK/tXgum8SsuCDtz+pb4EdoheibFutcToz4vg==
X-Google-Smtp-Source: AGHT+IGZexRCl8N0H7iNZBGguludMOGdSOIQzKBFKm/K8c3Qp5kaS9pSyHKHgpZH79otFq1q9zgflZQKxZFwQLjP0Sw=
X-Received: by 2002:a05:6402:51cc:b0:5a1:de88:a5ef with SMTP id
 4fb4d7f45d1cf-5b02317f4c0mr11460864a12.27.1722409643609; Wed, 31 Jul 2024
 00:07:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730151724.637682316@linuxfoundation.org>
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 31 Jul 2024 12:37:10 +0530
Message-ID: <CA+G9fYvDT-Ek263796cuaOLCPMDAC3Gu6OkG=dSAP9CfBPYU5w@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 30 Jul 2024 at 21:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


As others reported,

Following perf build warnings / errors noticed on stable-rc 6.10 for x86_64,
arm64, arm and i386 with gcc-13 toolchain.

Perf build regressions:
----
* arm, build
  - gcc-13-lkftconfig-perf
* arm64, build
  - gcc-13-lkftconfig-perf
* i386, build
  - gcc-13-lkftconfig-perf
* x86_64, build
  - gcc-13-lkftconfig-perf

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Perf build logs:
-------------
tests/pmu.c: In function 'test__name_len':
tests/pmu.c:400:32: error: too few arguments to function
'pmu_name_len_no_suffix'
  400 |         TEST_ASSERT_VAL("cpu", pmu_name_len_no_suffix("cpu")
== strlen("cpu"));
      |                                ^~~~~~~~~~~~~~~~~~~~~~
tests/tests.h:15:15: note: in definition of macro 'TEST_ASSERT_VAL'
   15 |         if (!(cond)) {
          \
      |               ^~~~
In file included from tools/perf/util/evsel.h:13,
                 from tools/perf/util/evlist.h:14,
                 from tests/pmu.c:2:
tools/perf/util/pmus.h:8:5: note: declared here
    8 | int pmu_name_len_no_suffix(const char *str, unsigned long *num);
      |     ^~~~~~~~~~~~~~~~~~~~~~
tests/pmu.c:401:33: error: too few arguments to function
'pmu_name_len_no_suffix'
  401 |         TEST_ASSERT_VAL("i915", pmu_name_len_no_suffix("i915")
== strlen("i915"));
      |                                 ^~~~~~~~~~~~~~~~~~~~~~
tests/tests.h:15:15: note: in definition of macro 'TEST_ASSERT_VAL'
   15 |         if (!(cond)) {
          \
      |               ^~~~
tools/perf/util/pmus.h:8:5: note: declared here
    8 | int pmu_name_len_no_suffix(const char *str, unsigned long *num);
      |     ^~~~~~~~~~~~~~~~~~~~~~
tests/pmu.c:402:36: error: too few arguments to function
'pmu_name_len_no_suffix'
  402 |         TEST_ASSERT_VAL("cpum_cf",
pmu_name_len_no_suffix("cpum_cf") == strlen("cpum_cf"));
      |                                    ^~~~~~~~~~~~~~~~~~~~~~
tests/tests.h:15:15: note: in definition of macro 'TEST_ASSERT_VAL'
   15 |         if (!(cond)) {
          \
      |               ^~~~
tools/perf/util/pmus.h:8:5: note: declared here
    8 | int pmu_name_len_no_suffix(const char *str, unsigned long *num);
      |     ^~~~~~~~~~~~~~~~~~~~~~
tests/pmu.c:405:33: error: too few arguments to function
'pmu_name_len_no_suffix'
  405 |
pmu_name_len_no_suffix(uncore_chas[i]) ==
      |                                 ^~~~~~~~~~~~~~~~~~~~~~
tests/tests.h:15:15: note: in definition of macro 'TEST_ASSERT_VAL'
   15 |         if (!(cond)) {
          \
      |               ^~~~
tools/perf/util/pmus.h:8:5: note: declared here
    8 | int pmu_name_len_no_suffix(const char *str, unsigned long *num);
      |     ^~~~~~~~~~~~~~~~~~~~~~
tests/pmu.c:410:33: error: too few arguments to function
'pmu_name_len_no_suffix'
  410 |                                 pmu_name_len_no_suffix(mrvl_ddrs[i]) ==
      |                                 ^~~~~~~~~~~~~~~~~~~~~~
tests/tests.h:15:15: note: in definition of macro 'TEST_ASSERT_VAL'
   15 |         if (!(cond)) {
          \
      |               ^~~~
tools/perf/util/pmus.h:8:5: note: declared here
    8 | int pmu_name_len_no_suffix(const char *str, unsigned long *num);
      |     ^~~~~~~~~~~~~~~~~~~~~~
tests/pmu.c: In function 'test__name_cmp':
tests/pmu.c:418:34: error: implicit declaration of function
'pmu_name_cmp'; did you mean 'test__name_cmp'?
[-Werror=implicit-function-declaration]
  418 |         TEST_ASSERT_EQUAL("cpu", pmu_name_cmp("cpu", "cpu"), 0);
      |                                  ^~~~~~~~~~~~
tests/tests.h:23:13: note: in definition of macro 'TEST_ASSERT_EQUAL'
   23 |         if (val != expected) {
          \
      |             ^~~
cc1: all warnings being treated as errors


--
Linaro LKFT
https://lkft.linaro.org
