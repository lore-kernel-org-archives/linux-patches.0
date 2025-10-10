Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5B324BBF0
	for <patches@lists.linux.dev>; Fri, 10 Oct 2025 20:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760128227; cv=none; b=DYyTvwfaMMANm8zCPG77n7RP3wkAPx4GR8Z2V2WJMUp4bBPOcishKGnnOz5FFANS7xLOnbRLyMMlADRose2KL1wmNftQ96RPijyF3tQUmo01Qp8/4JHANUId4NA3h4jVrJ02kx2ylLunq0Lg+Z6cz3DElnJCWLMl/ybCFa0AVtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760128227; c=relaxed/simple;
	bh=9A/LumBEIKcjOP6VHI6kMCIyzUnl5vaceti643YJJpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qu7HarmDjzunOm95QtKK+duc0bQ/Db++6gDV6da68JHn94vBwaRQOTUUL27cCSLXHrIma3QvE9JxdEur2JsY2/NA3L3c29e5s6PG4BVAQfCAMgZnf2wek+MAsJVGg7JV6iwwd5MPwPza56Kmq5Y7GU0+2jrQIkVnOOd0Qylwwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=WqBVfkxA; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="WqBVfkxA"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-85ed0a1b35dso221979885a.2
        for <patches@lists.linux.dev>; Fri, 10 Oct 2025 13:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1760128223; x=1760733023; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+senocMrwmKsaXZeJzB2jZ0qaAjcExrF8jnru4WCps=;
        b=WqBVfkxA6L/eaVt66gcY6wFKivJeIVr3y4eY190Tsh1B4LW3UkzFhIPS+T+7ZaduZW
         DTc5zASOqcoJTIE2yvgjM8mg4Hfm7ZX0s2oEhG7rm48353IS2Fx5Mjyhv19IjgxeM6gg
         0hyC9ZYurRB+6+bGUkmp9f09vbP+MzeCiSUW/3WcX426ueebfIAnD8FrCelABmOzyEwv
         UkQjPfQOvhKoy+hSRw8kjgQzgnDGvhyzzS6ixZex1qLc7jDr6DeJzOHZ/zA1aY3GxHlY
         m0NNeA5QP5Emad4YAg6Nisur8qMW4dIzZQ8WRi0KBybN68OhnAuE2YACS7naInnv9mQs
         45Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760128223; x=1760733023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+senocMrwmKsaXZeJzB2jZ0qaAjcExrF8jnru4WCps=;
        b=v342e0Cz1mcAsQ92zIeZwncFcn55oTBY2P8eLvYzfLSSH9ozoyzYxtvBmHQyXbOsF4
         pVGsBBCHzqKCaOmsJ7zmhkUjwuaqgk5GyuK3cmV9z7bxmHrJHCIriaSVod51JWVFqgay
         zYzIqmh56TvGNv2LN2usNSTa5X1wyJbJ7n4hggCAlD4qRjn/etxOWAOnd0aALUfM7b9K
         cvqAxq9wQikWSTgUkpNsmimhpvP/dKW+oq5S8hYXLQcQkk82n/yos0ajS5BAKYR16A2M
         kMBjXWwcSR2bdsRs5hAgEivojmEMW1js3rG3T4GF2BN3QHdvK7GY1e6iOUaHYiP11niX
         UMfw==
X-Forwarded-Encrypted: i=1; AJvYcCUZG/F5MTiy74dUX+hqpZu3OL5VLjA7qRl6hqZWebkotISFrKtbV/0FP0Va1wJIOTS9d/GqMVe2@lists.linux.dev
X-Gm-Message-State: AOJu0YwZmGU7nL0cFiIbfkXaWePQX64N/UiHjmhDSEkmNgbPb4SVJHqb
	a7sEONX968z3VwbU58jAVesn1cwZkix0x4KT9shqju2H4nTOmNo6UhNgVp8G614GU5k2Oo9o/aT
	X0Ssa87+c8nT4PpvhIkN1xk810ryuXcBDbA+ZoBsQIA==
X-Gm-Gg: ASbGnctquDqVTjHpd/Kx44av+QJaCrHhsEQQHhKamJBvWKYXSBkkljbP4bhax/6GiQ+
	aKEQwkcEWJdb6DsiYToZsRo0DhvNksqRzwoK7cq6D3ghhVJAcUlHAE5MlRruFr6gcaxS3WH2lpg
	jpHEXroThPKbwRTirIGR6Kjb8HdgN8SHDKiswNEH2ojkpgJZQiKsqYEnio96SEcp6FsB4OgJ6ek
	zDIhdq6c3GNYHAkyAkBgRCzkxP1+PifRKwCa+5KSFA0B+xm
X-Google-Smtp-Source: AGHT+IGaDT2KJRVgn3V2uHg5JrdMPPQc76Kr/F3VIFR8OseRONCHJrHCaP7mg/1pCqM9GqIYlzx1MsO81oon8uA+GHA=
X-Received: by 2002:ac8:5d05:0:b0:4d0:bc99:16d7 with SMTP id
 d75a77b69052e-4e6eacccf83mr179102061cf.18.1760128223369; Fri, 10 Oct 2025
 13:30:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010131331.785281312@linuxfoundation.org>
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 10 Oct 2025 16:30:12 -0400
X-Gm-Features: AS18NWBLUvy4NjkY7UZ1PNbxMzBt3vi-RAZIn1RsDpjfgXc3METhIL69fv1WqAE
Message-ID: <CAOBMUvjKaFZ9Y1+WYc4EkaQeMU+vP5bvV_Fx73JJ=P2fANztqg@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/35] 6.12.52-rc1 review
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

On Fri, Oct 10, 2025 at 9:24=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.52 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.52-rc1.gz
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
