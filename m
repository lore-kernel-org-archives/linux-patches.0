Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE2E18757D
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 09:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718357816; cv=none; b=m82iJoXmqlKzSj3M1NhkEzWDN6weFNlCAPFimfUT2aTu1Qf7E4Ag2hOLE/ZHs9Bd1uqToE2eqOG42Fbt9OznfR258Jfu1gqzvNXwivzQ8JO15vOIfY3ZetUNrPPvFkaznlixultEndEy5JVeCbC8N84KLsYjW5aKcKCyULhSttY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718357816; c=relaxed/simple;
	bh=rm5AVC8tE0clXXvcUm+tJMPWlqDx/DlRU0dqbjejEBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r9qMX/fgpeD5NPalipLGmMXUTyt5BXFB9ufU4CpZeOOW716Ez2UMtz6+BQs6+X9OM2BACvQaUvxCeOnJlrFxeEcA5Dk2rZs+SnEkL+4OeNe2Viw7q2AGztSKUe48y0X406gsVCmwo3FyCDiyEMA2lSZyxJr6XHAAgMStM8I6Oys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QJDFcVtK; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QJDFcVtK"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2ec1ac1aed2so2791561fa.3
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 02:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718357813; x=1718962613; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUsTXLHqULhXlNokLnYidcv/h/2pMwfX66ciJcJII+k=;
        b=QJDFcVtKAP+UfFt8UFF/bRhJjz58B7bz8icDfKL43liG7LQaxM4Ay+SO6QI3fmGOYN
         hURtCobH787yaqYM4sSkrnvRv18VVPHNy2L+EfIAcH0GH+JNsWjpReTX/GBVFww/HBN1
         vddy/+l5kZTJgrBk6bB4/ITiD6KvT9/eMhmME3w2Z5i+j1flvSkaMZeISD5pk5FG34UZ
         R056lBPfxaUadrBZhn54lC4ipS28YO1b3Wbwmh/Q/Nj6kpw2kYVBihJe/Jbf1Shy7XZb
         hC7vpX1Nlpp8BPoVGv/c8/IsYDC5jdt9zr18ofwTWymGnlcRdr1D7S0/7kv8fLSSUVYG
         qS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718357813; x=1718962613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUsTXLHqULhXlNokLnYidcv/h/2pMwfX66ciJcJII+k=;
        b=mDqTDVM017ssUhBxGzsej3acJeEhcvr0YqXnj0Wpg5IzLiUPwazbqCXS22dRf4Zg4p
         vh45u+Yny1sPHZz0h7xIy6W6z0YrjS+p7wz53kcxMQKAaYSrCBWS2WjOaARyCGBL9Zk5
         KDK9VXg68+86WL+WDilZo//YTzuaNqbOXuIMiL9bCtylu+qCa1O2+yVjBvV9mZKHhMa9
         o9ZUVOJJSy346Sjavc1WBU3Er+MyxMk6cOs6aj+FfNCYir4rSAgwlMTE8Dt/R1LCx7lO
         8Yhd/5VGUEMm4KNEcok1BE1Vk639eP/runcoGGEVM/b8Dqk8dulcJD+QDlvF1N93fYvh
         C8jw==
X-Forwarded-Encrypted: i=1; AJvYcCXglxZvmzQSE37gNkzMfnjkq1bFDxgN9gWlkMXAJrQJBf4YkSFomoQabm7vJc+OEALnaJWwZHKO8DWheyH6puOo7L+/ki5pfg==
X-Gm-Message-State: AOJu0Yz+bEP9te/hSjVVdyoQuv4Z2P16r8QjxF4cExcGpOqp/L3DH/AM
	nuQ8PltGMfw7uRAv//6Cw5XLUJ0+7fTI1GXqzB9IFypRA/lEWI7puu0x6ZezZs6el7lfe3H7dgY
	3NeRsbnjTOG0PTkpZ3riKclVBmxc=
X-Google-Smtp-Source: AGHT+IFNei/zgel8iT950goVTjeeVbkj4EnwLZtUp721PDa6gefpcWXhXrHiY4nCk34QMhYUWMyD6wNsTci/1G3vVf8=
X-Received: by 2002:ac2:58c8:0:b0:52c:8b1a:5513 with SMTP id
 2adb3069b0e04-52ca6e90857mr1358869e87.47.1718357812749; Fri, 14 Jun 2024
 02:36:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113223.281378087@linuxfoundation.org> <CA+G9fYtEkcPasc62FH170nPyJTS83jfdAtHUfgwG+QDuQP060g@mail.gmail.com>
 <CA+G9fYvwJxJdsSeTGsKjKonkiJnDC13t1+mpjHhyCvc_2r3=-w@mail.gmail.com>
In-Reply-To: <CA+G9fYvwJxJdsSeTGsKjKonkiJnDC13t1+mpjHhyCvc_2r3=-w@mail.gmail.com>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Fri, 14 Jun 2024 11:36:41 +0200
Message-ID: <CANk7y0i5919ih8UML+YtTr6MomemiJVu+4rpsU95TPBWv7bmeA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, 
	Puranjay Mohan <puranjay@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg and Naresh,

On Fri, Jun 14, 2024 at 11:15=E2=80=AFAM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Thu, 13 Jun 2024 at 20:15, Naresh Kamboju <naresh.kamboju@linaro.org> =
wrote:
> >
> > On Thu, 13 Jun 2024 at 17:35, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.34 release.
> > > There are 137 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.6.34-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The powerpc defconfig builds failed on stable-rc 6.6 branch due to belo=
w
> > build errors with gcc-13, gcc-8 and clang.
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Build log:
> > ----
> > arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
> > arch/powerpc/net/bpf_jit_comp64.c:1010:73: error: 'fimage' undeclared
> > (first use in this function); did you mean 'image'?
> >  1010 |                                 ret =3D
> > bpf_jit_emit_func_call_hlp(image, fimage, ctx, func_addr);
> >       |
> >          ^~~~~~
> >       |
> >          image
> > arch/powerpc/net/bpf_jit_comp64.c:1010:73: note: each undeclared
> > identifier is reported only once for each function it appears in
>
> Anders bisected this and found following patch,
>  first bad commit:
>  [2298022fd5c6c428872f5741592526b8f4aadcf8]
>   powerpc/64/bpf: fix tail calls for PCREL addressing

^ this patch can't be backported directly as it is using 'fimage' that
was introduced by:
90d862f370b6 ("powerpc/bpf: use bpf_jit_binary_pack_[alloc|finalize|free]")

We need to manually rework this patch for the backport.

Thanks,
Puranjay
