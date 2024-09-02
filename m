Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B379F176AC3
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 08:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725266216; cv=none; b=cGKs1J3Mr5hxQMotMTEKudfl/hbdh7rSd/v90QZPwOx5Hz4+nQ4VqrTNMxhQF5VnabCQeWZFVh2xqUIUxqo/g69NNGnbnIedQPcvpGQG9EtXYcRZnE7cuWfeteOp/EZUhQabaEWmxFonipSQu6rYRH4Xpd2otg9S4kbdPIz96VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725266216; c=relaxed/simple;
	bh=xy3Z9lAOzZ45z4zrLrPCPDOJApY6xNM5ad9KMplBiCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BcoY6AJd8JvfXu7JTHsnytnkZsiKIKZA3Ft3EmnkT3M8QT+hy/fBOJJz78JLVBggfENvsa7DcqCw10q5wIskbA1znEHMtgl5AWLYJsa8x0+BwYxjFafSc6CLVEMWwfsgnOuCwbkkwq5x/o/43ec4Zz3scjRlaZjviPf0o2L/wfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=liCqdG5O; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="liCqdG5O"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-498db1fe5ccso1502240137.0
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 01:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725266213; x=1725871013; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=izgwLH91JZbFLA7uRSiQZxwM6vVQO4Q8Uz2oK9o3XyU=;
        b=liCqdG5OwJRpgHA4bI6dgh1Q0Kg5DPyZ3YS4oOXRUrgaC6yN5tWMZWQyvpf3tOCJib
         h+50GEYeSShL11yy/QDhMJfW3toyySLIjQ7bLZH6IuLBSDnm4l+pn4/7wC/y0ESmHI2L
         gyzz1ANwZJWYSecQXk/E+Ywz1IV56abbi8iWG6x6ZwevW+OQjWyC1BiiI7kYRbrk7ya4
         5yCHU6FK2T9wFW/7DJpyNGVoBdVvxA1kMukYjWIgdEYsC5dEB7IcVit3u/4pa7e6RlB7
         N41+J8PhgingaPjzVTIeVXWl7OBBZadtkSaqeZ9iLqcFUBUBOfGKC5dZhLTzEO55QvXj
         kP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725266213; x=1725871013;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izgwLH91JZbFLA7uRSiQZxwM6vVQO4Q8Uz2oK9o3XyU=;
        b=wjSAsu6DgHixp+TQPz+lT096huqr8Vqs03uimhwDr1+3VdaxheIL9cJjUwKl83YsA5
         WOWY+hBMrDnS5ifjFbBRVfxZcGpL4O0WsxzdaVn5xLO++xbH/WUs/XpusefgKwo2c1z2
         0p72kGE1+JDiS9IIKkPzy1ZhDNKrT94G1hjaAgy+hL/kPENf2oFWz8JKlJvdPc00ZU7M
         hhjHJk+QKxyPIAVKMJOWmlRzn3eZQG4xbuH0bx+TbCMc6Jm1XblWHyr6iFXu4Og2KC/6
         BSv7hX5yY0M7+JIH8jgZO17RJIsMkyuclZ0yPDsR6pJKwS8BGUJsL+6cOzgBLTN3w+ea
         Fxuw==
X-Forwarded-Encrypted: i=1; AJvYcCWjqPi4WtP0yzj3XigZnhCH1CHgN/KncIKEFi0ROUAPm7B26b/5Z0IOYPSSTyRNCsohOvxlUXZi@lists.linux.dev
X-Gm-Message-State: AOJu0YxzkNR7xWZ2vdMFPP+oebm4+aZr5CB6m4sXoK+xAQPqsbAyT2b9
	Mwr3VZ5Uvtn13k4sENxD9vHR3OWiGBQ8C9N6AYDiUwT+ei1Pq2FhbOa/7rlp105wwPWZ6in+/58
	X8quugr90GcbGIUddPQgSs01ePeBq9MI2Awa04w==
X-Google-Smtp-Source: AGHT+IHr9d4uGJaINXYhlYol6A9FJjb6MMNb9yI6s2d5LmfEr5luCvl4+OTH0rW6lSrtvbYTbS2AdcEhIMsVx/v6eXU=
X-Received: by 2002:a05:6102:3050:b0:498:c875:ffaf with SMTP id
 ada2fe7eead31-49a5ae5b461mr17121501137.12.1725266213517; Mon, 02 Sep 2024
 01:36:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240901160809.752718937@linuxfoundation.org>
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 2 Sep 2024 14:06:42 +0530
Message-ID: <CA+G9fYszuNTqPzsX7cw-2_7D0tFUMeroVKeza4gASmUEbcxcqw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/134] 5.4.283-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, abdulrasaqolawani@gmail.com, 
	Helge Deller <deller@gmx.de>
Content-Type: text/plain; charset="UTF-8"

On Sun, 1 Sept 2024 at 22:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.283 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.283-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The Powerpc defconfig builds failed on Linux stable-rc due to following
build warnings / errors with clang-18 and gcc-12.

This is a same problem on current stable-rc review on
   - 5.4.283-rc1 review
   - 5.10.225-rc1 review
   - 5.15.166-rc1 review

In the case of stable-rc linux-5.4.y

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Anders bisected this to first bad commit id as,
  fbdev: offb: replace of_node_put with __free(device_node)
  [ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

--
Linaro LKFT
https://lkft.linaro.org
