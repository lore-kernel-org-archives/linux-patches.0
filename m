Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7441991A8
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 12:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734524197; cv=none; b=NbKP9QeiSCW8XZCN5o88jZxnW93lc+mn4RpHIEJSGs0vndVw3KdUSsW+sUCrr94gjR3cqtZkIHYXatYkISLP5kUaQPqLFYFTu6UvIwEKUXAJPsEi4hH89kHz5jBjZ2VJb3OvV2gSvpW0oMTPrqxBhhH7zRrC6IzcZ+Nu3MBBHLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734524197; c=relaxed/simple;
	bh=twiqzmfa0k6rVvwKb4kVKF0U5mkPuRFri4eXv8g/B18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1ACLIQAUlSd/J+jXRbYkFCsAUCF1pHIu0AHrRW2vO+vk4MPIL9vxxG324uchunTdYhdgh7VP+l6qOFt6CsWGt0CFxQ+KoE6QTmOfP9Fu8oQIxYqOAg9R8mPy0rqS6+D2THqm3YaqqE7wCpppjmW0XXgVzdKd26zcHQpwv8We8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=Db1iOhI/; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="Db1iOhI/"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2ee74291415so4476678a91.3
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 04:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1734524195; x=1735128995; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LMgJ1n37qBMrXii59hNg/ts/KUZiMWLlRfTJDT3i1i0=;
        b=Db1iOhI/mMvbeFwKCF5YpHXPW7zd0w89+0GqUfKV0Fq8n0chGwnFMQiO6vWxBVUfk8
         abQnxuOEwWDajm5Dza8/LRhyEUThBUEKzlM9zuajHycaF8WBsWalpSR+rdv9wEuXe/Rl
         ExTBgLEL8pWIwVBXVDof+MEz4cGRAp/YEarYILwVeGTO2hQdvJFlfSqH5/lpsKxnPwQa
         oeJX91hxIHfyFvl56WaQgy4Lq/H6kUWNVrz0JBjjmKapMTSwh4885rxOuDePfk/7ShX2
         BtXwp3EKcjQ+nmiPnaI0eykPEvJDQwZR8Hk7+QzslftncvK+2OkJz7rkWJnheEXQ7zMm
         2qDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734524195; x=1735128995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LMgJ1n37qBMrXii59hNg/ts/KUZiMWLlRfTJDT3i1i0=;
        b=RaFpmTbuhO+ovS2u4qvKOISqKeYo/Zoglqmiu7D55MHOceLvi2A5jlcbsBZxuLQ7H0
         m46ZhfmIwydpVbJg74zPLY49Kr0h4UUHuNqmQ7a5O75PsyTRmWVuKVC4VEUpzzwAqNkJ
         ZSIjUAyVThKhB6kZ71v/sslinzAR8qUuzGdNVh0vYKm9/5sz2X7DuVrljMQsZRILoyKe
         ZkvKASCgzT3kMEKRoSfWXk7yZ5L8NwFtsA8ia+ykw9JFakUwe5pISD0x7MQgLiYS5Tk6
         tYHmm7Y5DC9O856zol/o9lJnJ9bvT50/fu5qDEdzRDs5MGan6XgkP2KrtzPFU+C/Usxl
         vJWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKfzD3z9NpnKr7PmoMivqoGvN7teiWA68ZAk9/pqxjxcCTRMYoxyDpFeb64XTq/gyURh7Gkm7Q@lists.linux.dev
X-Gm-Message-State: AOJu0YwyNvazw1GlEnXwefuh4xhx6BU5clwQ22eDeOYatCNjBq1ggDze
	nYYF5t0xvJEzLnf/UR0gacTXNnE01sKZ+v1MBuD6J8kbGBGG9oxg2KGFao+grnA5L7ip79L/GK0
	bQ42C6tmFy0QSKmQbU5cKJzREXOLVkfLaUf4gLA==
X-Gm-Gg: ASbGnctB3euHOgMz16Pa4DrUOh41Z/CHQFkNnWsY8f+jGzRG4cE8pCAbytxiNpujBEU
	JJPXZduDaFXucN5GWAdTS6yr6IgM8F+rQE59rGw==
X-Google-Smtp-Source: AGHT+IEBr6Q2C61/Cq2TVUTgG/Vgl3/i/ZI+3fCMzOgertDix5jNgYZxiglfunJ639kL2OTiIFRgnaJThJHfZbgwMLA=
X-Received: by 2002:a17:90b:2d44:b0:2ee:8008:b583 with SMTP id
 98e67ed59e1d1-2f2e91dd1cbmr4300861a91.16.1734524194844; Wed, 18 Dec 2024
 04:16:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241217170546.209657098@linuxfoundation.org>
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 18 Dec 2024 21:16:23 +0900
Message-ID: <CAKL4bV7TKtmtu-2omRa9U8u9x7rdNKN7dZcoJHe7=iv5yjC=vw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
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

On Wed, Dec 18, 2024 at 2:28=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.12.6-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.12.6-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.2.1 20240910, GNU ld (GNU
Binutils) 2.43.0) #1 SMP PREEMPT_DYNAMIC Wed Dec 18 20:05:26 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
