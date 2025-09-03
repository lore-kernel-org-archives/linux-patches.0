Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753E3305062
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756906140; cv=none; b=LgWhjdvgmkUcLg78JmYBmCAgM4DMaIfHJZ6refn4d2WAmxYZsQFwXferv7AQmfBR+0lzKbmHEhOF3bO7fwylpUxcNutjPGJiauB2B8rAHtHteOFtgGh4SdpGqpHjoK/JWEEnJAcZUgieKj+DIOY04qZBlcm5YxNuGrJUE0CS1I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756906140; c=relaxed/simple;
	bh=izk0IZmyI3MpZX8dah1iAMq8tH5iGUvz2zunPfvcQnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EePTGYEQB/UEAbzFhtvJlkYiM54deAlkAgZBCkciUXJD93AxcD0jkbr7gOq7jzWQo9h6qAFt7nUUXCRo3mouUh0lgrOyFn+f1/lxRbSm1dPqLTpzXB4VG9oNnmGGDQGUDA3eRv2PTDNfA9dPLqgS5VeEXeNpbduZQAg5sHrxY4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=oLKnxh3B; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="oLKnxh3B"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b307179ea4so46740771cf.2
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 06:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1756906137; x=1757510937; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1xV/deyqGkmJxLaaOIY+1qBi2UrFX9CrtK1ZvKF0rs=;
        b=oLKnxh3B48z5twLvb5Q4yxCajsAumAlsrhmn3fkyfUweewxwsS/WQh1c3rH+BOMNlr
         zOVFfRyYTMLKRZS6vT5UF7d5T38yp82x1yY93wXdBsQBkkXzhlOvy+0JIktv5V0qmreM
         9W9wyldMz0ihT+dPWxtGJ0tWJ0YpMuzEFb4yGyO0lUDKSn+czJETXsMCchqe1ZrsOYpz
         nopaoOxKOaxNK8MWtKLuuNvQ2LOoqXMyc7fuq2Px88UiUi6lxhHMKh7oMk6FnqJCtABi
         e+RJHQFMMgZ+QzRL1+h0cPzC02Zmuah0ptFIVlSjUhLlBs12ebHsWUCaoMwewoPjcL60
         GjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756906137; x=1757510937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1xV/deyqGkmJxLaaOIY+1qBi2UrFX9CrtK1ZvKF0rs=;
        b=oYXqQJYltBq6zlcIKurn8L30sZ6lLz5iuKN7tw/SY501NloCxWZNrCcjXLaGgISjIP
         aOQ2mhGV0WiNhxLi2fnE2PUmoPLi/wUtQ1Khti4Rv7n+cduMRaoxfweeIyXyLSuQfYOR
         M7SxOru/YzGEzIPWpmG9mA5FLHUDae3dKlgtKck5DSTmrWUJy9rP0IzY+HafG7R2BJPV
         SYDBus+HSpnyN3CgMlgPc6Od5y5dUZTXf2KpYVgL7hm2So9YrO9hlgfHYZctQUWh99jD
         Le/fAeIFPLxebILMpvrReaQ9rJ4LT7oAafdlNDRAPoR5qCrVu4Pw2N+g8y4hbOFNlvra
         /Rwg==
X-Forwarded-Encrypted: i=1; AJvYcCVMxTYMDkMfJ9bdn4JS4qMk4IlQHY6xd3wGiAyWziM1keawVSZqb9F0FofuwrjwVn5hPYWG/01y@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/qJLYSA6klmkNeat5d28wyiLHaHTUb2ZUGjw/et22vi+MqKM5
	HIU2X2kvEK/oFwqYnOuGbm7rHrmKQE0clMF7DH/R1jxSG9kS71XmGfx02C69eeZYnLCXSelMBLs
	DUe0Jg2jBfIqM24byUdNfo2mLil2/5YLHVPXdBcqaBQ==
X-Gm-Gg: ASbGnct0UKl0PHOj2XVlByIR9U+eSWOPUsiCdfHJh1tdm8hpcXoWslLhO2P+RUgyaul
	Id6cogJklmPn5QWKY+kAPo55jPNGoFlkC6UVhNBb02os6FXbyL42e+3p++D/Ru3EoagjR0g8KtI
	wO9SI8qgY8suzx4Wwk1kHvowLKVEXaz2JOrpfZ1UdEyOQ7vGqVD/bqq5wz/2XMB1sIVIiEnHpuy
	53IZbys
X-Google-Smtp-Source: AGHT+IEb9SF0ZAQ/gl70xHietNZGoqqgRbcYfcZB8vu3mSrxASuhTzMLNODi+2ufxi3Kb5/VCv5lEH2P3alFHmyuJUY=
X-Received: by 2002:ac8:5d87:0:b0:4a9:c2e1:89c4 with SMTP id
 d75a77b69052e-4b31da3d038mr183413971cf.47.1756906137150; Wed, 03 Sep 2025
 06:28:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131939.601201881@linuxfoundation.org>
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 3 Sep 2025 09:28:46 -0400
X-Gm-Features: Ac12FXwi4i5s22HaICVQk8Zg7KdU46JZLCzhgfwfvZeR0OQqZCIwhAezRAG0Tdw
Message-ID: <CAOBMUvi4yUWxMLU5usvYsCVd_cKd9iQHBqSzVp4sW4Kc9Z3fTg@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
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

On Tue, Sep 2, 2025 at 9:40=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.45-rc1.gz
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
