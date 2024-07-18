Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40CB145324
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 16:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321870; cv=none; b=mu03/XXnVriOqE+d+mFApou4OaBq7UHEcfIdIzO12+mo/34c5L+BPj4zfLNI6jfQh7uV4NaUvv6Qlr8VaU2erHcSbTi9HJA62kMy289WtXD6x6ErK2awji5LvVFh8qWTE6cVqMV3PR3TaSlEJKdWONxnbuoMITmIy8EXcyR0s1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321870; c=relaxed/simple;
	bh=yOZ2lVrysGgsrLNNF3fu3XFM79WD3lMVMxlnAodUu5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DclkFbg51foifNRxYxFxAhuWVghX+u3+b3HmbQE4EGJgwLcAP4lrrEB2FGzv5IQBY/PT76KH4UCbHiKJIi5hMiFNbjsbOCRQNx7jBgHJMb5qqI1MFd5FBd+RCDfiW0AXx4I+Vsc14sj3jLLsH6gHINvr+PReCRGvDZQ4SMGEpIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYvVuIq2; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYvVuIq2"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-8205ceff95cso326972241.1
        for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721321868; x=1721926668; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Xpom6bl9hEnF3mAmDgfplew3U5KLsgSWL4OUoqlDDVc=;
        b=mYvVuIq28RQpex8qDHIO4SWJoPppeKyt5/ZsLrDIhCnfCDPnOamHIC1uJpbSJzqZWI
         XTaU0oC0jHt1xAmgmJojES8ifYrBwEp1ckO7Lcm9IPC5zdr7QFPWlNhJuVGP0BIxGFmk
         FB1zHQfg+WeYXxRzldntoLYWl2lRG6IDP8D57Fw6nmcs7/N7rnIGQDsQtXfF3xXaC0z+
         kEsLvJpJNUozPKr80C6xamMOwQn8MhrjnBhkNyretQniFHqQLh4c642yJNzeVcl9lmHr
         vevqXt00lIFlL4yimMldE+3rc1UP5sOI7CDBNtUZotTuUWirhLc6e3U6xBojd2NeHhfM
         TC9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721321868; x=1721926668;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xpom6bl9hEnF3mAmDgfplew3U5KLsgSWL4OUoqlDDVc=;
        b=gSzjfqxbvtBKmKhTb8HKagpw7pRyF+RVkdLXbvPL7o/UhknBmHqqD52xqrz5EyC49q
         +ZtgQSCjAcF5k3T8vGSZcIhJlAhLysIqedFj+JkKzp/KLb9QGnGpmAKkBU5On1ELpacY
         2uTR36jTl0BJ3gYLYznD7lOkd7X+wcs0gLgb7IijZGm/GitTKFc4+8+mjqupqDbofhO0
         KWi5Z9RrEuWmaU5Hd92Wwh/AfAvmEDcgwal24GmUXEnH0Z3sO10hatzTgDNDq33b9nsO
         DV4j90n8HZWw2CvGMuRK1pvkWnnOjxVwglRWy2jjOFiM4uJCUpZBLFbHSKsGaxLNyt4r
         5R4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUjmQ7dHDcoKjF74RHEUV+rde1SqZoPPVOkx/jHyZkKzfBf6ounUIoKw2O0ORmp5wZqYbLY9TsAgu8FNpyaHpVPfLu5ngkObA==
X-Gm-Message-State: AOJu0YyQZxIJTGPldlXckLKfUInGckn39/ou3Yzzbm3qcUsVVtqr6rc4
	ZwJ5E//iIdVMBzuQqz02SmRiR9gbWokchiKAG7GFNlZo9Mcrg2hW3d+aGmg5grjCkIw6s25M8sh
	U1iAf0+jvMG9gqcbv4C2rfso+D8Q=
X-Google-Smtp-Source: AGHT+IHR6ThkLua6HIyn2QhH18U8FmhK7U8KNC6CQNV7Xsj3RxN9U+naSfkElXcxTQzC4BQqqvkGQQx3iFlgdJRnaMA=
X-Received: by 2002:a05:6102:15aa:b0:48f:79de:909e with SMTP id
 ada2fe7eead31-49159849e1cmr8033869137.18.1721321867791; Thu, 18 Jul 2024
 09:57:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063806.741977243@linuxfoundation.org>
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 18 Jul 2024 09:57:36 -0700
Message-ID: <CAOMdWSKHSaQm-nEdRykxVfWXGM+ehBD6xfH6vk_ZGNJyVxoZaw@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
