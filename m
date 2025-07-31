Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A3C19CD17
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 02:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753929601; cv=none; b=GCANUHjnJWK6eISY9gYubmNjc2EvkxjpUsy9iwlaenoYMB8oKjxoDD8Zhp8Q1UQBzbdCy1FSheZKynk2eM5Y8ys8ZPrMLMIY/iu7FROlTXF7CtyYkNGdB9TV4IXDnQVMxkNHHwqJfqvpXIoB6CqjuAMOlYC7Onm8V7jAmfaTpvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753929601; c=relaxed/simple;
	bh=/ywKHejRlAU8NaBUfYedjpYE/KbEhNXMYBNdpYwavAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e6PwueuqLQO3STK9PgoqKoTPz5thO9IlwUo063Z8nIQn8LcNd0vbZBfueD0i0cBO9e5d8sx/0Bmip3FZZvDly/8tovgE1dwucGpcC2Be6lkfgpcIuR0rRBYzmAL0mjJB9P2fnvlVKBzGCR3WHVWa+xXv5seyWaKulb7HDKhDazU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=uy+OS3EI; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="uy+OS3EI"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-31ef50d8d57so359739a91.0
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 19:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1753929597; x=1754534397; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gik8kQn3CflT6JngBBYv+kUUKNngOz1ckMzDNY3dGCs=;
        b=uy+OS3EIYFd0k2TpOgWBx6r3MokPkulYX+Pwt+3RXEnjMvD/OwmMaLIUltfytJP+LV
         yBDKxvrPi4sL97TE9xEWz74WnuQEpHNtAdm+lyW4JAlrZLCzM78obQVryOFDyFj/6R/c
         2nYp2CIIPNSqr/lCeBi+Mj+H9CywZNlh56CKIUYQkONGqNcUuszBlt2IjywEe007+1WZ
         Rm8mKOIFIkslfHTlxtdZLbXaYXTnVpY1mCyXsAX8Iw9Bvn6338DQMwJXmbNnrc6brc3d
         lXIS8eUGY6JzOIVDnH38ccnM6ZWdbVIc2a/tsymZ1tpwENRnutT+DK5GlveZOb0op2lt
         aSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753929597; x=1754534397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gik8kQn3CflT6JngBBYv+kUUKNngOz1ckMzDNY3dGCs=;
        b=Xjd/2l611wwMSOIZGwWib3HfOrYEF3PB5yHI85pJztP6SUljzvP0mhxfPxyCdb2j7u
         mKnpTYd6OR+GWti7S0SfEx7uNGoshcyZ1hu2tEwZ07rcW7acT45B7Uq8tM9dUtp/gx5R
         w1aHMez2z2Ah5LqwDqs8Ii5ZotugxUuxsZ8MqblBXnNxS5HMmu76L0wEGU894myxGno3
         kJHsVwBxnmhwmRb7y4LS6wV4D8i0v4bpOJO98ip7rhP3nBhNgoemPeSDv5LTJ2Vvxw9H
         QPZaE0jF1s+T+/mzUY33fzbu+lS4VzkGQFX2awHfnM+jZFfjRxxQu1YpkskjzONvhUb2
         WIgg==
X-Forwarded-Encrypted: i=1; AJvYcCW/AKKKIsp4wMwonqxyft2mSFzfdNRgi573u1q8LY+I9fFH5tMhW81ddkxm7Wrx9ScgYsNRFw2w@lists.linux.dev
X-Gm-Message-State: AOJu0YyBQr6mQWAqSQUajFCC4PYf1mOEeHxwK/4C1vazE2Vd1cV1DhRq
	Vy50XqW7Y7O6C9IL8Zn97izbbha2SQWKzXJNwEbGRtz8SyHAHFItN15lk9S1HZOm2BSib5MtcuS
	nddCZa8L/U+BKIF2OdGpRDB5UwsrPJkBtdr3uL3YorQ==
X-Gm-Gg: ASbGncu0IpZZRYvhCogJZqt8mrMMGxYnProD3jJw8CBA6SztCMqJ48SpMZv0nCur7kJ
	mhvZjJ4tBEKDIentPTSxeyyLv3DaDBy0T9ilgMwrZLfZb9lxHUl9gdlUlNVNGTH54c7rIMfI3zX
	7rokpJdy35XBxn01ZNsEyk/ceQa0fBFI423BtvEJ5piDGc67TWc4lWOi5hfVEMY3vwklYYZm9kS
	h8uo+0=
X-Google-Smtp-Source: AGHT+IG/yzJp0Zgl3QCj8JLwCRCOvmPQJgUimI3WOMMUebwa9O26lDVm5Bh2U+dtqirpR2I3YBUaWNWHtOPoD3Edbu8=
X-Received: by 2002:a17:90b:55c8:b0:311:f05b:869b with SMTP id
 98e67ed59e1d1-31f5de58622mr7607661a91.30.1753929597272; Wed, 30 Jul 2025
 19:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250730093230.629234025@linuxfoundation.org>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 31 Jul 2025 11:39:40 +0900
X-Gm-Features: Ac12FXxxs6pohzDYfR3q2pxRI0B76mYhfNwsHqFTuOdiVngA3WZUVCPz0nIqHHM
Message-ID: <CAKL4bV63xNamSc_5tDuO3uXh7VRnG35F=q5Mo++nivZYWmVH9Q@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
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

On Wed, Jul 30, 2025 at 6:53=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.15.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.15.9-rc1rv-gd9420fe2ce8c
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.1.1 20250425, GNU ld (GNU
Binutils) 2.45) #1 SMP PREEMPT_DYNAMIC Thu Jul 31 10:55:42 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
