Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC6F45945
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 04:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757393880; cv=none; b=TF6GEwT3IaMzUvQMeBeZlSq/HLVYwoYCwi0ItM5DIa6NQhTNdyoMUt3TdIjtDvSkeZggNLMyyPt3m6Z2lDOM+70KOaCr0GQqWt489doTGM67AVz3QOsySP/txHV8I980EJMtxYWuhT7cOqCMJrbcuIfeAPkb5gvkgNF38pG1PRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757393880; c=relaxed/simple;
	bh=Tb/9I9r3+HRBGBPJda2/t0vKpz6/1fF1C/OCaKN9U4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RP11KVaXDb6glsXLVLzDa/WI95EBBYasK6fbeW0CeDi/j/4HbaTPBbZMTE1J69fl4mN8oqITtzeTPQxUePKt3Iq+pL1VPAUbObqR7Va6hAcgehlaOaRm4WCI2nfO8b5+KxmFEBC4oZjnFPUToy3C++muNjW2QVDVyWq/smqAAXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QXaEPJdA; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QXaEPJdA"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-567fb8be044so341882e87.0
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 21:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757393876; x=1757998676; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l25NFxExAUe1eqmMOMVfFw3dzd2Dt4hw0Sr3RoaXfRE=;
        b=QXaEPJdA4dYO8c5n3VO6627KJlc5kfoG3l13MbKpgzyEnLegSofCzJUFBOGLC45ONE
         8i1VH2zDxZqnvCisymYzsgUiP0u1UujBTLusVxac9G56gGEzYfevkvsYhWGd8ivLRsHK
         9P2xLYMbpAVFIeYbIQCLwR6nBgxJQPw4aNInJqtPr2sx/IaeCwBtoHhkWqKGkI2K5YwC
         7+M5PHUnVFosNO6Yrm53aQPkYi4MBMZ6QDnAJ0yFCqYqQTYaMbHzbIMJEPJKwR1hskmV
         hrjk0ikIqqZ3j/8GFrPjLp4LUyrWNQFjLBoTFLk7kkipK+kQVvSF/d6wox3/hgWRC8aB
         loDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757393876; x=1757998676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l25NFxExAUe1eqmMOMVfFw3dzd2Dt4hw0Sr3RoaXfRE=;
        b=W5lC+hXnilQYpPjgGh0yO9F1TY0Fgg0JQOFQtW87JF/RyxROyG4SNaxwZ8nWBGJjuM
         9d3qyjJcZImNzysyE2U9FJPdGhs0Tg5NFuXyr+2c9MlT9DB0xTNDULKjEsxXkaKfJze8
         i/yWG4TmPRvEzzGy9Z2wAgUpvfwAwWoJU1KCZIolVBrWYG9xY5cpQWUS7ZtkVqok1Uak
         6QeBLHaYfITZPA4zlnHcIGZzsI78w9zDTuXR/KUWiSjnufD/hKsENKFbNvVlJmQGjq7t
         X2OoV7xYHRbvm3wRfIxJaf97Tcac3L/I0nIfo0lbovf64Wwua/ISczl75m6l2AHOWAhf
         Au3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrSXRujljAl7gTe/osHERUUXk5haGugkGyUn7rAB5h6BJHS3X3ZYJwb0V3H5Xf7Q8ZbvRXkUfG@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnb5Aj3OGdbUia9JKXGef4xVK2cb52ul8qv3gp62Pet2dXwbKK
	BzBN3LFrcGauY9uAt02oVByJBU6VZHhudNW6CQZ2Qc4EHdrQQ+54ZiBkWcqQtPq6CcR55h9zL5X
	Q+bE0MX7B1kTutVgL0KOWG04c0Zp5FbE=
X-Gm-Gg: ASbGncuqIbPKiN3F5h2OIJ2/2MLYk9FNyfPGXkR60XV7ogMUzzWyKiM0al9JMDxDoK7
	E9BnCZ7RqKzSZsWDJ17cejZz5ehpJWVDxrLY+sWuuZdl69P1pKEFG/UZ3+t/tz+8zB/143PF482
	ovNogMLH0ARB68hX+Ps4ytWZK1mf6urD5L5Ku6rpzJlz/g3TEDx+EDx5IDyoftL5F3AiQrJbnl3
	K7WN+ueGj06nYfpbDOk9ZN4LCucKjU8zWVHPOyuie+Mq1qzab4GFLVOLLvCjWxHqLAA3pyF
X-Google-Smtp-Source: AGHT+IE4aJVhuUj7txtOnsYYhZRub3AWkInGLQh7N4cBU32Yoh4aAHd3WHdXBY7fRpvJ76Yz+6786ilhvVSEk1wTKAY=
X-Received: by 2002:a05:6512:3b94:b0:55f:3ddb:2306 with SMTP id
 2adb3069b0e04-5626310e5bdmr2842619e87.45.1757393876318; Mon, 08 Sep 2025
 21:57:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195615.802693401@linuxfoundation.org>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Tue, 9 Sep 2025 10:27:44 +0530
X-Gm-Features: AS18NWC-8lpDwDSXRJI-52ZPSz8rigrQ13cs8hdUtHhPutYSVIO0pan4rBPN_Ww
Message-ID: <CAC-m1rqeq33V5JU2HuQ+4iw4j41CZqCpocgKG2uLjnuTnf4w0A@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 8, 2025 at 2:08=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and boot tested 6.16.6-rc1 using qemu-x86_64. The kernel was
successfully built and booted in a virtualized environment without
issues.

Tested-by: Dileep Malepu <dileep.debian@gmail.com>
