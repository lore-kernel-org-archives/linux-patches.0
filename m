Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747CC354ADE
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760733088; cv=none; b=LHNKJIw/XAe+5X+I31v5OLq8PAqdyP4dpTnAma6VxfqerwpAGsD3bXqsfI4mpAJkAgFat5dxLbopKK+ew7RF0ermiGlFMrPBDrgFitIZGA2PxwMsBiWxNGtWoLAvSaeZpKW3KOEUQwxRVjqpI5INqs+RcTvHr75EQtoKLRL30wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760733088; c=relaxed/simple;
	bh=MKk7ulg8THfN6IMYxwH8fJ0oDGq7pR+r1xwzI/IoyqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tS8Hr3iGCHSFyufjtwLbiwWOU/kW8lkOmxmShewOYrzmZFygnqH2eHpiUz44gIfCNKcV4uArQxxSNvhnNRaa/pkbLG9xuqfkMl7VbaakDuymLWJ2d95RA7HCL/RPbKIWul7f/ek3QcWvgbmU/MW4SvEqPmDZb2DEp3We4yvHNCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=T8/AO/kY; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="T8/AO/kY"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-87d8fa51993so2673066d6.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 13:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1760733085; x=1761337885; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0lPpXtKNC8Pcljol6lZmI6XFoGZEJXZUpwOt8AD0/Gk=;
        b=T8/AO/kYmqVSyY3w9glmLA2kzUTro+eSLQR7bvlPylXka6dWZgao6KHjx0fa9Au3nf
         3GH1ySrteh9eNkmPe7Wolw4c9fnJgafchuGZ34WipuSi5OdMgmV9RbTUcY16kl9UAsrb
         W0Lg34zyLvV+uZtZGELcgiLgXKDRd1oS8kx9rgYTo2iY+uarLREXCQ6KZ6v9oTC3KOGp
         aWFgGI0MMe+8v5rLyq+aA2YXVU/q98IyJRY+EaqLFzvVibcoGfWQXr2ML1cSzVJxaeTd
         8Pda3Cc4pjZb31Z9Fg/ep63V8x1b/Y1f66zlKle3Ziz6ziQF+WpeY4rO2lNyiwyH5Cnh
         ZjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760733085; x=1761337885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0lPpXtKNC8Pcljol6lZmI6XFoGZEJXZUpwOt8AD0/Gk=;
        b=jv5qtSy8vo4X6JoSwCGBxJ9x33O0dertXnMsQiVisAjnWjK40GHAYchdnLVzBwE9IP
         BcY4s9imvIvB4B5CGusG+XKd3QdpdTCkNC2+w5OVrkvAd6meop6sK63RyW4FUOJ2MlIJ
         WMkiA+d+2WZaQ+9MX84RGeOMqvpZVBp7IA1LMtpw+A5PPVl4PEkXXeGm/rB8ToSaKvw6
         62MTRRdEG+NfdDw/ag5iqKM2BC/iuC+tvD2wPcWqR75q7HFK5EnJOyJBDRRg3vOUDRQ7
         fHg+HYnVMWvW+/Nx4sNwoEE9NiJiL7dQgbK0VlHLLhKcdznEbXsIUODdwRaSXvOQpPok
         0vgA==
X-Forwarded-Encrypted: i=1; AJvYcCWYHBHT4mgjqmAi7YiAY86B6qtg9ACjYmVgjOYL8NqFbUmx/l0EVALzaN6E2zXXbeOiQvxiS+iB@lists.linux.dev
X-Gm-Message-State: AOJu0YzYVcey/JIeQBEbNhNklKl6gJdbxOogTBEYrbwSQQN9Vg7Z8Nkv
	jyoDhRE2wHAV0Q3tMsE/EO9NuJj9Gn09OC6mw/MW8MY5fDz9tWuMnoDYN5+YMVouN2+ZY+FDvjo
	vlL503UMNkzxasiUs/Qdh4DZgyH14WRnvsKaxgyQ3nw==
X-Gm-Gg: ASbGncuePlHdbBdC6Tx18wvWRqVnpnxP4xneaP7QRVFNRMPbSkiKg/GnQCeEYyX+9B7
	8RLM0/CA3Z6BsQo9nmoySYRZGc+/hDqZaW6vUplp2wyRyc94YCGSPOmR1o4i0n7WrFtOTNECHLA
	Vh+nUYRGSE6zgRlJ/ESwZ0r437jFbaQVs/GpFORpcOKIhti5GRqgCldE8A2XnmCntgSKmIB7TXE
	U8OYSu8im0kDwPXdk4QeTj9zw1h08LcfmlnA70Ugh7PYsX0cIJedo+56soJug==
X-Google-Smtp-Source: AGHT+IGQFfaB9wOSLxDZqrYjsq7EvvuhGYx/LCDuuPQUSKlNN3GFBd2FmzvCC7AVAg1tdTIrtigxUrv4wdP7WpBC77c=
X-Received: by 2002:a05:6214:c64:b0:87c:a721:42f1 with SMTP id
 6a1803df08f44-87ca72143c0mr20321786d6.52.1760733085286; Fri, 17 Oct 2025
 13:31:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251017145147.138822285@linuxfoundation.org>
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 17 Oct 2025 16:31:13 -0400
X-Gm-Features: AS18NWAWVvdm9jPTS1ddtyd-wd5oGJSWRBN2RKy5mD95QqYr0wV-qU9IWXqpvdI
Message-ID: <CAOBMUvgT47EEqCi9_np-Fx6j7dR9=RhqY_tsb7+gMYi7Jb05WA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 11:16=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.54-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
