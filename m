Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783BD2475E8
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 08:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750234331; cv=none; b=PzR1It3eO/DNiMYiX7q+vSuB83t+zXiAj6ifj1Hcr7FvYlIwSCb9sILhtF01Zprfzsubg9X871kYq4uoTkBlNLakbVIJJsD1HAQcA4YVY8Ghi9X8/7wq/tkjgabbSHS2IeiR2JGW33S6dXFxqAwlTZa0cv9KyzCw/r4+4ZoqXNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750234331; c=relaxed/simple;
	bh=0RQPUVwvAOsk5IBp82srvzdKvozlrwpTmR5FjAY3tkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UcdXdxHer/PtqpqyUsWfF+LTwqBPc2fo68+NGkDPn/eSF0hDvMU7QH251RP4tRVIfBIphQnKPNcIyY7sW6cfvi/n9eVZjI4JGC6CPBzM0Vqo80+3hMp0z5EemNkEPgnT9VrkG40z1zJFHDRqb5+yBD+P0vHpjdil3E4LxLVa5ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=crKLo3Iz; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="crKLo3Iz"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2350fc2591dso4216705ad.1
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 01:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1750234329; x=1750839129; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=brjF5TFgyuOObGUl0vP/36GKYjNLHFU9TL+BiTpUMpo=;
        b=crKLo3IzOZ4VVoHkQi/mB3Xc5v41BNSlxrcyhrzepBAh1p7R/U9CZYLQl8hV1is3lO
         zYTc2Qr1FMcYF0x8KfZD8pjeNUr5hWo/GoOlCgAkB3+5YkG7r0rt3MqLV0ZqdTFl+0+w
         tumC0g43plpzrYldO+WRzo0K62OrNKXkaPhffsME2LjczzNbFKpWtiRpI7t+5nzpokWf
         pE3PWmkgAuk4Df2Ii5hUYst4skDhPQ3EkCFEJeihCnF4WLhSg2JIKXXj7y8uKWYd08z5
         4gsAUkEhx0bf2o/7mgR1+lZvmao5PqinEADnHAzfWnqaDqceQdg2KWEntOswLjhQ7XNk
         UHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750234329; x=1750839129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=brjF5TFgyuOObGUl0vP/36GKYjNLHFU9TL+BiTpUMpo=;
        b=ALqxE7zxGruEomJB8OFO1Vy9asHZhpKrTIyrgFA8uFbiyg8tM0Er1pyv9xPufXtirh
         K9gpPtGk862KhhDQmZ8fn8nDFAEjc8a7lGn6/e2EB0HOv1OqkxZdgxi1PiRdpv5JZzoR
         tkhZGfKnzLBlRFzAStQB/u5duWF4Zijyrqca5F/oro9Dm9bj/MCrOl06WMC/eASL+t5c
         jzhcchJoaAuetaaOQTc7CeAbfUvyJ+WBHg7OxzO5rPc4MfeDCXtPzAxJbLjjUto3dMvA
         RVpchfXXsziDBZ62ynKs3D+GZrE0J0j+DJdrCt5oaI/weUAB1OhF0urtHKBRIPdpHy2Y
         Jx5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHfWSUOQ//ssr8ALXQcno8tOZQJyX1h5SU80efwxndDII84wyu05+s749blB7wm10bGx6mwLIO@lists.linux.dev
X-Gm-Message-State: AOJu0YwB/RWAlJdtzwq8AscyAZksFOfTtfsb8sMaLs/IRcs6RDVFgJ4F
	36p4+UOawDGJr3uZPgOAau67Mlx1s1Efw00RUY7kdnN2vNvufqXT4kddfr79E2iMk2A9H+MkwOq
	NLR2FeaJFDJj1ow708qXEU7AsV/Ch8iMQ1Qt4TEi3iQ==
X-Gm-Gg: ASbGncsUKdkvLPKn2O/tBsTcTQh6TfFlQFssTlSrDSdQbJ+jbjcigdKT5WrdpiD8OIh
	pVvxD9ZzC5LhqUm4TJoJBqykdhr0aP9jCwNw5HCSaV9PFJS3P9qaRYkOWjIB8GEbZz3mITKJmbd
	fxC77cOI3ZM2xL91GgwEOAtwcXAVLL93qqZDgO7jF7QCE=
X-Google-Smtp-Source: AGHT+IGpJLHZtnqyqQh2JhkwSxrOCuHgk1TDDY09x7fcoLDuh3vm/ooqXWD5JEagbJwkl/efavMkytyKfGh/yNK0AJQ=
X-Received: by 2002:a17:903:228b:b0:234:11e2:f41 with SMTP id
 d9443c01a7336-237c2046e94mr26764865ad.6.1750234329638; Wed, 18 Jun 2025
 01:12:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617152451.485330293@linuxfoundation.org>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 18 Jun 2025 17:11:53 +0900
X-Gm-Features: AX0GCFvsu6UCDmq2tIZWb5YR-nmqe-aN02_fZ-ldFZkqfeOhcwzzccegmgganmE
Message-ID: <CAKL4bV7fgF4uFC04rDjjAYVYG9vJHhYzfwq4yB0s7ns-kqdvXA@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Jun 18, 2025 at 12:29=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.15.3-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.3-rc1rv-gd878a60be557
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.44.0) #1 SMP PREEMPT_DYNAMIC Wed Jun 18 16:32:09 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
