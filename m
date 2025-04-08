Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC3A2236FC
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744124843; cv=none; b=mHzNIHZ7hbdVTiI8lR8RzFmHAlaum0U4xDh4lmuJEpuFoIPzRvdVQaoYFkZu+YqSVfHOJlJBE4qjSP7NZAKRZCyd5Q62ac5/gpthIxHGI/1Sa199mcog9jSH3Aa8LC20t30roNrxKSbKFAogDy7m8K0R7Y37Gf1XvkzDAAF7kqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744124843; c=relaxed/simple;
	bh=S53wWg6EVuiCl94q6KeD9ibvuRkH7pkNwygNbzLdELg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aBLv2HNYEdPlkn0B0z4fDbF+TOqxXTJi3YL1Bqn+hYRSqleW3uP8y6QUDOcWkuV9ggj+FAOjetWD5Y9bJ9SjsEONz7bATmVQ7pJvDOi/dvUSaPKVjrUK7GTwy4qJIOq4/UBKlG4ZXEBO9eZYMhAOBn8mtqol41QWhpm7s1LI0dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3dci/T8n; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3dci/T8n"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2264c9d0295so222315ad.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 08:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744124841; x=1744729641; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unlVTFrgXvzgDf2aayfiA97WI+Y8WYBYEfd6y5NTwTE=;
        b=3dci/T8nBT2cv/G1u2qbnlpV7CPY7S3aI94BGZgp59qyfG7ANfNQOJGwgeXF8UuYCP
         yIMuoMC7FOsGBSakHs15IMJsD+yypXdWKyBVlxcKQEp7v8s7p38I+yXQfPac1jKv+PqS
         RETvuKroXcHBuyuGzHajCY5TEo88LBQQVdZ/rgG/XL5Isw0mLnKasaAbtDxNTVNCyoyI
         lPQ1eeCcU8axIiJauBGoYLm4neCxW142Vzi2tqwFsIpQhKqkBzBlAO9SeEzjpCh88tOt
         Y3WJJjEGb9IlIxAzhZW1z/OfpVnRiiJyKuQnErigdGztMQ01CRxJb15liwuJx2oW6KzR
         1M3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744124841; x=1744729641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unlVTFrgXvzgDf2aayfiA97WI+Y8WYBYEfd6y5NTwTE=;
        b=pSywf4qXNOiqGG98G428RapS3DYaQEhWzy7F1wqtcMrVLFQghu6WsIieu/sDyEf3qs
         4PUFrAPrpo+cqsjk9wtfZC+6y5f2+l33bFufnzye5plwLTBckOo+5SfKMErXbqULna/H
         ezPXCs4f6faXQUVr/CLl4lpFWQHWtwUTTHsL0FA5CN1EsTBsVfMDFkJXPktiYEk3XmbI
         G9iEJfhZTWQCaQoc4MD+MsOhVmT/Nwt798ICPS0oII8ozPek4Kmy/Q+dFSGaXRizA9Sx
         CL/mToFf1jRPuYSeoXHgtbplwf/B7rgTDkMTtyNG8Fz2NkZgxeFFKCptxsrQG+PXWiA1
         BPjw==
X-Forwarded-Encrypted: i=1; AJvYcCXhsZwFs1Hc49FToN9R4MRhseydZMPsPCQ7C8gopvMRj7toxSZs90yvWh5JM/K1H9DY67n4jxeH@lists.linux.dev
X-Gm-Message-State: AOJu0YzUbpsUq487doiH5oMF8h8EZjP30LX6xSOWQf7duib96sYIyxv9
	FYh256pC2zKeto1OBKo3cT5t+Cwy6ztlYZHlI5UoXaSSaEEj9EglULIslnZIzwQdYcO4zlypwUz
	iAgTqMl7l072s0vyeZU8rVSbgGHnjDu7EVGv3
X-Gm-Gg: ASbGnctxygoN8+SWHXZ4UcgIbPwA8GZ/aO9w+e4bMnor0SWHdBf4RjoYcQWp/6Lqsuu
	G3tmvlgmBJV3Z3RSt8C0Kfn5oTFGeRIthcddAaLAwufbXi7JpCrKiffb1mYdbGS2mWDrS7Ew0NQ
	bhu38MlsBEkjOJ6HJNf64/iUGC4O0CNyNcv4cB5f5NuK35xTgp8x9lVUg=
X-Google-Smtp-Source: AGHT+IHFvpD+UYJr1rf7dkMEUUfZYlYA2D8wwBs41XpEWpKcKPQk1Z5yF1J8r08XTvksa7AT4b5xjMDYxJPxKmrPCzA=
X-Received: by 2002:a17:903:3d54:b0:215:aca2:dc04 with SMTP id
 d9443c01a7336-22ab711fba1mr2414715ad.26.1744124840778; Tue, 08 Apr 2025
 08:07:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104851.256868745@linuxfoundation.org> <7d11f01f-9adc-467c-95bc-c9ff4bbf6a0f@leemhuis.info>
In-Reply-To: <7d11f01f-9adc-467c-95bc-c9ff4bbf6a0f@leemhuis.info>
From: Ian Rogers <irogers@google.com>
Date: Tue, 8 Apr 2025 08:07:09 -0700
X-Gm-Features: ATxdqUFsPT9ssGEEy4_cYrt1sV-fWT0gbYl4L_w8VJ-E1PwhOl7_XOsF39WP5YY
Message-ID: <CAP-5=fVCADCyXeeLZT4EpU1OtOxMKB8omf5FFpDHmKgOWetW2A@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Justin Forbes <jforbes@fedoraproject.org>, Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 6:09=E2=80=AFAM Thorsten Leemhuis <linux@leemhuis.in=
fo> wrote:
>
> On 08.04.25 12:43, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.11 release.
> > There are 499 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>
> Compiling for Fedora failed:
>
> util/stat.c: In function =E2=80=98evsel__is_alias=E2=80=99:
> util/stat.c:565:16: error: implicit declaration of function =E2=80=98perf=
_pmu__name_no_suffix_match=E2=80=99 [-Wimplicit-function-declaration]
>   565 |         return perf_pmu__name_no_suffix_match(evsel_a->pmu, evsel=
_b->pmu->name);
>       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> From a *very very* quick look I wonder if it might be due to this change,
> as it seems to depend on 63e287131cf0c5 ("perf pmu: Rename name matching
> for no suffix or wildcard variants") [v6.15-rc1]:
>
> > Ian Rogers <irogers@google.com>
> >     perf stat: Don't merge counters purely on name
>
> But as I said, it was just a very very quick look, so I might be totally
> off track there.

Thanks Thorsten, I repeated the failure and reverting that patch fixes
the build. Alternatively, cherry-picking:

```
commit 63e287131cf0c59b026053d6d63fe271604ffa7e
Author: Ian Rogers <irogers@google.com>
Date:   Fri Jan 31 23:43:18 2025 -0800

   perf pmu: Rename name matching for no suffix or wildcard variants

   Wildcard PMU naming will match a name like pmu_1 to a PMU name like
   pmu_10 but not to a PMU name like pmu_2 as the suffix forms part of
   the match. No suffix matching will match pmu_10 to either pmu_1 or
   pmu_2. Add or rename matching functions on PMU to make it clearer what
   kind of matching is being performed.

   Signed-off-by: Ian Rogers <irogers@google.com>
   Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
   Link: https://lore.kernel.org/r/20250201074320.746259-4-irogers@google.c=
om
   Signed-off-by: Namhyung Kim <namhyung@kernel.org>
```

Also fixes the build.

Thanks,
Ian

> HTH, Ciao, Thorsten
