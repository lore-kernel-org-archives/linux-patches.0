Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C087242D72
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690052; cv=none; b=N5IPmf1WH60z1lp4NbXq0i+NfJKIVTr5mJ7CcZxJr9pAtT9sdQ5IQiXlVXGnuGSWli5K8pf8MzSVljwWJ0gZi3EwFjmmPzJwwJja+YYUCaP+W+5XWJd7G0qRL1I5YizLwUhSsmgeBQ8qGHeVTRd+GfUl/umMlQOVohurGjUzgWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690052; c=relaxed/simple;
	bh=JjhHjJfwbaeN+Rcd9I9ii1W+H6PAnjqDFDKeLrmQKQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bCrAdTVE0tl/fTld/cGJR/4VVmUxu7fl6FpN5O2FCoTYEqTTj1yGtTVOpwUTZT0PM7f7cALCpJRVfuRZsEE3Fri76wMK+3YeAgmU3Z5MSdqrXRUYyISNKFyVluk8Mx2YlYTHRTR1cBqsMFgCSPNmk1/mLnOX5B+pCi9tG1t9I0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ecj/Lsyd; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ecj/Lsyd"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24457f53d2eso78099435ad.0
        for <patches@lists.linux.dev>; Wed, 20 Aug 2025 04:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755690050; x=1756294850; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=26dVySXraRVWkX1dA4A+YxZnuQpE5T+9coDuoubCcC0=;
        b=Ecj/LsydoeQ0c5ldxcU56/BQki412kNxY/SlB4yf919bEOHeWAfWXQVpEPqMaAkqOo
         viL/jRbS/C205yDL2QL+HOJWMJG4xaPabhZlmnv6mHDMM6xbPRmWDIG6K2iY6Xx/QwnB
         gWm46sM59Wt2FP9CBKG9JNENADXTNh/JzKxWMejkd+ItPj49MHQjMFVDAA87gS1au714
         H7R4dAqiieTmHaaV/Y776RypS3nAPetyS1212pqabOH/iZUinNisxdMU+Y8I9t9RXEEi
         YeRVX3CtufkJvtgAzq8jEPuBypZRMk3kpdmjZzNNMGsPMUuiYR0TOgUdt34iapcAVNHP
         qkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755690050; x=1756294850;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=26dVySXraRVWkX1dA4A+YxZnuQpE5T+9coDuoubCcC0=;
        b=a1yVeM2yB9HCIEl+vJwjk+4nrLPZDX4Soiz6amqsRbecGHUGo6h9BhnWCDtorhTSRZ
         cjGlSnqSAT+H59Zs64gVNM4U9S1fWTUrZIHMHOZXhS0aS+gsrwxYd76G1NMjXg5CEGC7
         rVwqLeGrOptALw9DTvK7OSMwnPye0KjEqOsP7/+N8mEaatjgbBwhsfrwROt5hkbwgYs8
         nMsw4rEY56kw5z+K3KZUYad6ueW9reCCf5kzwBQkvZcTdYVR7i0jZpi1VtQwWQirmUob
         alboemK+Z3jyAFmwHx5bH0EddoGYigXfKNddOIHtB0B7iCM1yxT7r2hYKuS69/dtrqXg
         k/MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfwYlXVDGhNV/6DmjvMVTjGLq9H3rBfzvJRN7IrqhtRmo28c1FBfokonM36gvAfx86XBK35Ftz@lists.linux.dev
X-Gm-Message-State: AOJu0YzqeCv5nh+xVT1Edlq4IeQtW3KwFM6k9cOFYSfYOmYO3Erv17oK
	5Icn7Xcx0fS9jx6a1UKQn8bLrhpmKcUCRR3dTBjWyMvga946kqsOxarfIw35BzddZHdWHYOh6tx
	soKVuod4wdpJTkJgUHLcsYljbrN1/zCa2xYYdHy4x5A==
X-Gm-Gg: ASbGncv1/Fx0tWrWmJEbqstbX5t7qRjZJ24Q4WUz0JHMFgl4slej7VtWWiV3kpv3w/8
	wBb2dWKYp3gPsO54eIOr2zaEkH/CqMbgfy8rCbgVJ7rY163ydPaytEm95/oerMqJT80aOmCnOeG
	6KUYETV8sYN9I5Pjg0L5wGJhfLWa3y/+62+PXfKWY28jSbRBQWZyW9P9ZP7wxvLrOuuWl/Cj4ke
	RrVxTKgcpsQ6z/PScMco3CEWEIddfffkuEOYSw3
X-Google-Smtp-Source: AGHT+IF8AmOWHIAq7OQoSlww7khUMix7+VlH6RDk4aiFzmID1OwQtiwCZOi9WHpVW5C0l6kM2GONs0FeQiAhF1yLTi8=
X-Received: by 2002:a17:903:110c:b0:23f:c760:fdf0 with SMTP id
 d9443c01a7336-245ef25bb45mr33670985ad.45.1755690050527; Wed, 20 Aug 2025
 04:40:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819122834.836683687@linuxfoundation.org> <bb8ebf36-fb7c-470c-89e7-e6607460c973@sirena.org.uk>
 <2025082058-imprint-capital-e12c@gregkh> <c6232128-6bc5-4f84-af15-43e2fce6d619@sirena.org.uk>
In-Reply-To: <c6232128-6bc5-4f84-af15-43e2fce6d619@sirena.org.uk>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 20 Aug 2025 17:10:39 +0530
X-Gm-Features: Ac12FXwfvMit070C0xIS0xD7Ba2mGdVD4TnOncv3FB6dUHXIhTLgwE-oFgQbp-E
Message-ID: <CA+G9fYua4gFQeXs_SwnRFv=KtAu2o8es7kjA8KRq=KySap1A9Q@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 20 Aug 2025 at 16:49, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Aug 20, 2025 at 01:14:14PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Aug 20, 2025 at 11:57:57AM +0100, Mark Brown wrote:
>
> > > # first bad commit: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] eventpoll: Fix semi-unbounded recursion
>
> > I thought the LTP test was going to be fixed, what happened to that?
>
> I have no recollection of being looped into that discussion so this is
> still exactly the same LTP image as I was running before.  Do you have
> any references, is this something that's in a released LTP?

The following patch merged into LTP master and it will be available from
the next LTP release.

syscalls/epoll_ctl04: add ELOOP to expected errnos

Kernel commit f2e467a48287 ("eventpoll: Fix semi-unbounded recursion")
added an extra checks for determining the maximum depth of an upwards
walk, which starting with 6.17-rc kernels now hits ELOOP before EINVAL.

Add ELOOP to list of expected errnos.

Link:  - https://lore.kernel.org/ltp/39ee7abdee12e22074b40d46775d69d37725b932.1754386027.git.jstancek@redhat.com/
- https://github.com/linux-test-project/ltp/commit/e84f0689cf7a8a77478a0e70aa62560f66c3bceb
