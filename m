Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B133570A1
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762860664; cv=none; b=i/WDLE8J/Ii0my691KRe3oW7ACcxA7UdqJUVan0DRTmSOaGmh/J8e0xAatYfNBG3UUfioz6Ts5x5hRIGqt5M+AOWPdx6KwC8YjFNuY4vuXK4EY+3bFFt3PhEvWoeVHTLIC66kLJ4e3EJOCii32BFTHzIjolm9DWn8VR45iPqvns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762860664; c=relaxed/simple;
	bh=oGk/zlDW8GMau27Eh++Wjt6SdcJwmeKA0N5l5WwtFRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3kjIu4rjLas/LXHOztlKm4AwF0XT+gfy+j/N+4BS4gZhtnovbeINQSsRK7na1O1jRNmQ4BRVitTaPc3aGqeYDXP4YCD+evt5qI1eZHZzr3Zpe2fjdUKdyVGzLINkAipA2xHD08TnG+Nh9oIwC8h/YrCVW6EeouL0WzUaSUU2UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=t/PvV2/J; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="t/PvV2/J"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-298145fe27eso25347665ad.1
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 03:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1762860662; x=1763465462; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=buuCBtLu5sjBaUd1cQkdvhP5ydCgS09SCl514m5o+t8=;
        b=t/PvV2/J2llG4LEuT3Lr299W3TrgYWPSlQCUJu4C37o7ado9JQQwn7hRE48kFKbvGH
         5eOW5R63g2YbH1gloBqgsC/8b8I8QGK/l7XXtSg9eZGNGtFfndYa01b3X+TgpGorMS1p
         Cfsq+VeNa4NojiZKH1SipUvfNmXg7ZrGD+svvH79RYIHfabapT5oKUaT7Fkx9JAO2D9n
         skvzmia6Bcpthz6TamsD/gItchothIcq3oAh2ScaaIL4ewqjVM8CgcOjGGSLNF/iXWym
         RhvrBIEXd4yCIyyufzxsxj1jNYnzxMHITRg6zMBADpU5XulH+muAvklTv12RKcNdA+PF
         gwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762860662; x=1763465462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=buuCBtLu5sjBaUd1cQkdvhP5ydCgS09SCl514m5o+t8=;
        b=XUYqPhW3UKZrMwfB8Om7NC8OCpIvafWIDBRnOC7fcUQYfXQA/90lDNhkXO+jJXDTvm
         YzFPDaMi52Af3XhIHXyIraHO80fg8NQ8bFRQR4kUZQQpFC5d5cp/Jg5iN41Vedmot+aZ
         tfb5iia+5DGLtO5lbJCS771ZsIyIxU+6VbgJD9swhSGkcE5U7+vKdylfK06QWHs2NrZM
         qfWlzRuu6ghT583jP4GiNMvhvZdoTCwPWAyY9wxjUCBr/lnb3cBqAsRZZGTEeLmGIB97
         uO9Wi40zkvPoVbWEbOA5R8MoZVR6tuTWuoMBAt+oiygZXAvdywS7CiO4MKwJbG7MnP1w
         0cjg==
X-Forwarded-Encrypted: i=1; AJvYcCUljDn3I0e2B7WuDn/1T7hBQjZ3poelVvL+omm5M09dy2C24/1loPAIAP3qpfO8oA3QfGhN+H3Q@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2EwW1gICZ6f1MVdxX3PPWZIbyplITONW6Cv9Z7Nkmifvq3v3I
	zkYgCzST9DU1GaVj7qgo7N6AjyUcD5U0F9AjN8a27ylRCTZpZQBcfa6ZXdND/Fl3sd/BgN91PD8
	hhd38GjDVF0AnuXiqZ6f13zHzVQ8X4Us1Dqeg1SfU6g==
X-Gm-Gg: ASbGncsXOMxS1DJdQ55my03+Cr2w3WOsvdS7fghQ355eDE/kHKzf66ook6SfOUIZkwA
	0OezCrWnTtnlGIAl0AReRs7dz/7pWlx4T1qryGw/MUElpbRtRYVmLgbbClf75+CPEingv2AM/lT
	6415pYvRKVMC0vFHInUWD7bZLO3Hp4QONZr8NSOkBuWHMyu+q7c6DRV4ZkX9hUY7qE+2mnYEcib
	epjJLtH7hfdFv2abXiItO4J0/WI0rT7MnfVwvoBjsMK+p0PqmfX7UIcBpZFaEw=
X-Google-Smtp-Source: AGHT+IHUdTUrobfYmqXo6iySsvYGHYHvfn+aYtawmVY7dBCZg8aZm/C88dV8apc+dpmQBFkcG8hKPnDtE6uO7icYMik=
X-Received: by 2002:a17:902:f702:b0:297:d777:a2d4 with SMTP id
 d9443c01a7336-297e570dd5cmr115319535ad.46.1762860662025; Tue, 11 Nov 2025
 03:31:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111004536.460310036@linuxfoundation.org>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 11 Nov 2025 20:30:44 +0900
X-Gm-Features: AWmQ_bnVvBCJCVRVuQAMNfJ_GsU_ylMILLdsbbKVvbUi6q-EDqMxAg2oZ8sVGHY
Message-ID: <CAKL4bV53PARj8x8zWf=h0MRg4yidX2SX0wH88fDHMGvC1GLuKA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, Nov 11, 2025 at 9:47=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.17.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.17.8-rc1rv-ga0476dc10cb1
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Tue Nov 11 19:30:54 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
