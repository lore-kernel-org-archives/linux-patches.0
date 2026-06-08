Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C77A3B3C1A
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 09:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780912535; cv=pass; b=V5HthAMJF5tURfKHsZWm/avaUCaA5/Hq8zVfjB+CB1fpJ9SWJz2egt0+dQyJ2hBAJ7g49hEuKYCDYlFqSqyS+83/3cqvs+iQYbTo0nUpj2ho7JEqvpORENhWwn6fcXqZI3VK70+n1yZFTSlssbGKPEE6Q+t5jzqCApYGojQhbxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780912535; c=relaxed/simple;
	bh=nEe6Hp2P+fr54/g8RIpCfyjhQRc1tqxdIbRPosUg3Nc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BjV/v8X3Xl8lKMP0xK7IAb5qmUhDmrihCd9YfUrCySzJGbju3mZ+sxh8azPe8dlfzauX5bBlB/GqEOXuBkHhSl0Cn9O8BIIFznVJfb213KeoTRKQIJK0smXxGrn4/tGKQkfgDRGcl9p/km0kjS8SYNTo9UlQlrY8k+MzLmLwkbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=bh/oRcU2; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="bh/oRcU2"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8419ab3a297so1679389b3a.2
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 02:55:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780912534; cv=none;
        d=google.com; s=arc-20240605;
        b=hePEDbmq8nTxFzDejWhVhEktBOd7I+RRBATwjeUzB0UXvCg4UBv0njOTJVruBsZ7mP
         hpHIh1T8I1PqR7Nq4NGw9t4Zf+2ncDQLwfyY159Ck3MNG8USa5zX2WSLZXlM8KV7bk1T
         C1Y1m+ArTEXGDg3ph717cDCZ5B2Opf2DL1QtB7WGG1h84Um27xLepv4PVR40Cm//cKEV
         ljvb1fGONUzGlQ6vSe0QqL9V1RHdPd6RxRABV66X8/AvJTwGcwKMF0Uxch7vwV2vgqV5
         xQCNoFt5VLoG4AA3nz43YolADPaB+215JarMCvZ5RpHChVlwx6vFnetaQ28PAKf8kDmb
         r5oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YhR32XRkG8GtOPOWI9COuVD7tE9ztEbEqFhQoZ5bTrU=;
        fh=rWQiHHNwBAHbkp+V3R65xiLaDbBk/8N6na95SU+myOQ=;
        b=DlaYw5ORPPYrASOYEIarLuNv/fwQQymidzlvDyuekwBpTVWEjwJV2W3qtz94Qrz3N8
         TrzfOn7U6PEb5w2hhX94+PUmY3FGSoG6cT1WbftdlXsAthYcljogAYd6kWffWIzN6rf0
         rqa22KKPy8p2+mEGIfMBUOEgWiXNZ6M227tzQ3Ao88f6+TQjGg1tS6kmYZCtv7AJnM19
         oSX5ELzksppUNwDyD6dwIdPM4JpGu7X2VVK/i4Tosam+ipg8oUaZ6pJxkwWm5Ofg42nv
         Y6koRptSrRFMMmmTHcq/J+NbqkVT7Djur5s10vjrWNVlpxbUKdwOnfwgE7l2vLJbvJe5
         xZtw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1780912534; x=1781517334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhR32XRkG8GtOPOWI9COuVD7tE9ztEbEqFhQoZ5bTrU=;
        b=bh/oRcU2o7eFjvYBuDqLa+0gNRl3RJwRGYjBcZGTVDqY0CRine6S5N2xZ4xNcaJTUP
         ank5RMWAy9lFnc/DXLYNQ+qN9YGHDmpmzOQNy2grvjJ5pifPFqwk5IkNfI5NKYFOVduF
         cbchWcxH1bdjFmNS1Z2Ld+CyAsQ1zApKkYDdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780912534; x=1781517334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YhR32XRkG8GtOPOWI9COuVD7tE9ztEbEqFhQoZ5bTrU=;
        b=YS8uauo0jDD9opMtVR6707NAExPXg6xs2xdHMRpvXrL/12odMr7JRygNjLp/8DwqBq
         xC4uJ3iaV1QHriZ32M8jOAWOUpebcBjcc6qxFV0sTZc1YNl4xZS6Ch8KPJZiVNnuVqT2
         qPGguKrUX8XbL7zFDuYHNgUWYz1sq/snXgWW0KqHjfkkY2+yQrlW7SSfaWQf4JheGDWT
         O2CJFPIUitZQ4OVlfvuhUqjIjrDNKS+/oFO+OQaaqfwoke1kz0yWVJP/NAVVGOtIsame
         sSWw3tNxK3Meo538U/YS50eXVrybrSc7YHxtMm6LcYhETjWdaRIbopNMOQ8q2fT9z29v
         AqJA==
X-Forwarded-Encrypted: i=1; AFNElJ9T8rWcyVBCfR4BJ5mxb/M73aSCYeXPOagDe/lc7vaVmyayJZSNyRdKIeBQKOaVCJxlnyBVeSpw@lists.linux.dev
X-Gm-Message-State: AOJu0YwMfs2ShgTeDV1xIGXP8YPIQlqN9bgBEDK39OURE3VUXRRwRRab
	LcK6nq2+24aWZwZRDNVUM17X/to249/gKhLEbjxmoHHoagnxsPoBivakSAIRTA/keS/VVshadtR
	eDXpFY7lscmu7Rs2f5vgY5m3+mGsFkqtPlYO+ltBJ
X-Gm-Gg: Acq92OFJlboSBkOdReCU5xJuMy4Hrx0/KlMdSTbCfX5f55R+6mufMZ3PZ53NBjcHxiY
	HCMSrfC+/MJVztJLlnufL7+BVij5aH/zx+e8k4/c0P6yoRs3a/7OVSZJB0ckamWfk1gWoQCj7aL
	9JGlPkqrS65On2CPbwHcSOzHtFzqUyA7okUpK/ZFT7wX2ExfozLsqGmG2qQLlBq7ofV1r0IrNAw
	IZC7KOfw+vb9MEUxKpPozd6pwSPg1EgCP2l79G2CrYQsU+OQZrijN2c19ciZQ1JRnZPL9sCa+jm
	xxtxFTvGMHAe2Vdm/Si8XZjbwYeYpA==
X-Received: by 2002:a05:6a00:2d0d:b0:842:5711:9a2f with SMTP id
 d2e1a72fcca58-842b0fb2273mr14704387b3a.36.1780912533858; Mon, 08 Jun 2026
 02:55:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095727.647295505@linuxfoundation.org> <20260607173214.92693-1-ojeda@kernel.org>
In-Reply-To: <20260607173214.92693-1-ojeda@kernel.org>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 Jun 2026 05:55:22 -0400
X-Gm-Features: AVVi8Ce0VqPP4wrmrfgQDErKpRLi3Z7rbl8b4dCcmWnRvhi1OSTpE0ZX-2GG1EY
Message-ID: <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Miguel Ojeda <ojeda@kernel.org>
Cc: gregkh@linuxfoundation.org, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, "Kito Xu (veritas501)" <hxzene@gmail.com>, 
	Victor Nogueira <victor@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

Thanks for reporting this.

On Sun, Jun 7, 2026 at 1:32=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> On Sun, 07 Jun 2026 11:56:37 +0200 Greg Kroah-Hartman <gregkh@linuxfounda=
tion.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.93 release.
> > There are 307 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 09 Jun 2026 09:56:47 +0000.
> > Anything received after that time might be too late.
>
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64:
>
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
>
> arm32 also builds fine.
>
> On arm64, I am seeing:
>
>     net/sched/act_mirred.c:451:43: warning: variable 'm_eaction' is unini=
tialized when used here [-Wuninitialized]
>       451 |         is_redirect =3D tcf_mirred_is_act_redirect(m_eaction)=
;
>           |                                                  ^~~~~~~~~
>     net/sched/act_mirred.c:429:18: note: initialize the variable 'm_eacti=
on' to silence this warning
>       429 |         int i, m_eaction;
>           |                         ^
>           |                          =3D 0
>
> due to commit a01fbdecc3a2 ("net/sched: act_mirred: Fix return code in
> early mirred redirect error paths") here.
>
> And that one seems to be missing at least the assignment to the variable
> that happened in commit a005fa5d7502 ("net/sched: act_mirred: Fix
> blockcast recursion bypass leading to stack overflow").
>

Unless i am looking at the wrong code version, in the current code i
see m_eaction is always initialized before being used.
m_eaction =3D READ_ONCE(m->tcfm_eaction);
Probably a compiler false positive?
As per suggestion emmited, initializing m_eaction to 0 should help.
Not sure what the process is.
Perhaps, Miguel you want to send the fix? commit should say "appease
compiler ..."

cheers,
jamal


> I hope this helps!
>
> Cc: Kito Xu (veritas501) <hxzene@gmail.com>
> Cc: Victor Nogueira <victor@mojatatu.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: netdev@vger.kernel.org
>
> Cheers,
> Miguel
