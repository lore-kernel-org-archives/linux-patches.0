Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E511E487
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 14:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722435547; cv=none; b=MpWKC105w6gmJsns9e7w4A3D1DlZGXHJ+IjnkL2c9ZOtdY1nNbGm5lkEf9jkxdHcx5tErT0jWbPdoinvjkEmjApP7/F0lQYpEHFJX3ijwbd6WjcH5C9L4dJBb/6mDeQ3UDVnNVVMD4gyyoR8yr4tmnrNXqAr1U6oC9z/MN750Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722435547; c=relaxed/simple;
	bh=tw0+TCU4/jS0AandgOrW7tGxrTSxEhF7HElw2lzzHf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YP65d28VR1QBycKvMEN7I8H7PLMhSJ2NM++/RLsbh3TTa8pG6YU0dizJUG/K+wVEBBNtIZ8X/+X1QKQlHkcSUma0SPHmqXgLdUGH4O9UJL7JBcAVld3L4Me+p8XgDp0/zgUmHIQj1yWvdZgBHA0T0RhbBb3H0gE7SWFZN4EXeTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=wiu1ITIB; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="wiu1ITIB"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7a0b2924e52so2959787a12.2
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 07:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1722435545; x=1723040345; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+olOBTdXwD+ptqnBW2bgMxBC/rcIDKTtdk5vVlb2vLI=;
        b=wiu1ITIBjCvMq/765ykI+qQnMRkyvLTSH4yq0OhdDyLg7cbEgF4zHlOzUASoxAb4wU
         WiFoDkbh2OkWCkAJo2fdIRFOMmWbN0m5pZAQTbT2/MKxBAb3o7VIU5BwAlBtD+lqfLXz
         CBweFIXkxqDMe/nxyyEg2rJE33TNYvTBKvkbkComwQtIIO5D+h0bkJAOFApm3vpIReWZ
         cXo0faOsVKJJRWn/mtNP65E/4Sy5GsYqlaTlh4Cotjsrz4R+xon7GS4nOzokQEqKyZN4
         6r6zXb4HKPcb9CBmqVV2qzt610iC6Ckcsq8yxMlLSYK0TDHHtLqXmSbMwjIOGiHVN/5g
         Trzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722435545; x=1723040345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+olOBTdXwD+ptqnBW2bgMxBC/rcIDKTtdk5vVlb2vLI=;
        b=H01L/oJz7a853Gf473CX7GIQwPgzh4/WO8nro5TSLLthgNEzZHlCvXFkddEYGoX4IT
         Wjf75xD4d6tTnj861+REJ2XOYzkRVHG2IdG+ZeM4Rxywy/uonWQ08f7pxaiNio7Xo2/K
         npI1RXbpGGMzoYmiPSeKFgqWK5SlTqVHYKNSVkmsNipTGJ3XWSUP4u7PUULi6vi+W0aY
         A1VBe879/kYm+WzJyU9SSXMt7rEfWJvzDvRlOMXZ+dYoa3XlE3vXHFShTPkUQKEvbKz6
         4jWBb8NQvW3sgbzkeY/zd5JU4XqWd5gplEpUAdpQARhqmR6DwPAzn7wr5T4uVpYU/kMK
         DmFA==
X-Forwarded-Encrypted: i=1; AJvYcCVu+L7KYWuX2i2YsMK2l5jT6HcBzm3mnOK53beaa7wH4LWzAAXDNUnMWOklJYASwOx6qRU/bCg1lJh21Q+DnCWgRr0oUAncnQ==
X-Gm-Message-State: AOJu0YzEop/3jynjIiQZ6DalkqGUUmFtT3nR5uH9Yzi0aiCzb9pfS3p7
	DnNNWRASh0Q8CsUGLyW7oHBTKKx34SSE9+TSmUDbgeIRXDHd2l3HEePvCCVJ0AnfJJrseyObW+o
	JT80DMsK+SFHaKXe+NuiSWjaoIO3+Z1y09eVGCQ==
X-Google-Smtp-Source: AGHT+IHaZW7cYzfTwRhs0thFGwdQ+qUnbaCYCKW3CFQH5AqF78fGOWlCFqSVRRM9coxyRFyVVFHB6SQjD+FOOJIzTAI=
X-Received: by 2002:a17:90b:1d12:b0:2c9:6f53:1f44 with SMTP id
 98e67ed59e1d1-2cf7e09752amr13328867a91.3.1722435544643; Wed, 31 Jul 2024
 07:19:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240730151639.792277039@linuxfoundation.org>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 31 Jul 2024 23:18:53 +0900
Message-ID: <CAKL4bV6aU9vqkUtOZtL282sUFEKLmo=TpttMRN-Tt79P904GJA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Jul 31, 2024 at 12:52=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.44-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.6.44-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.44-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240720, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Wed Jul 31 22:50:43 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
