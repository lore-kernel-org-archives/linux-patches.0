Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4A05F46A
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706799521; cv=none; b=a8EAWRDIog0/UWbL/zhHsVSgjwwKFDYuFRApepppH2BK0PLhguZMwQwRYi5uKGjukr16/4fxb5X5zZX83gpUH8zAX7EYVuMS14Terqswa3+rtIpmop932uUtAHiIos7+kVcdgsGL0kJoOia1O2MY1K+gkIIy7LBkIHQM9J2YkIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706799521; c=relaxed/simple;
	bh=6cQNP6TfDmd/3HC3Btlnfj+skXdQYDQjZQxFx0JIFYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c2d/BWq/CgGl16hpnbTzoBuPSodz5KZEHM1t9ZA7YO+hA9kK+X7DyjiMyhU0FkThS4sgUmSaHPL+cQLb4myav0EM1+Obr25ddnXpoPyxdQ7b6mIh6ZsNlms3am6iITvKdx6k7d3+90ooZHu+6ITjdY+mWNV/Q3dB+OQ92Tf+4pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=UwvtEL6t; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="UwvtEL6t"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7c0365207fbso4977839f.2
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 06:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706799518; x=1707404318; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dU+MsCzscQ6UONm8tpF2vrsbrHPrj73OELKoVqq4DUk=;
        b=UwvtEL6tTpgzxi/42VhXVHFwLuFZbg7YkXGLITjo7+g8uiP1BV1sj266ekWrETxSUY
         JVd/pl3YwYFFENv+NSzYJPcOqfcdaIGQT0CMxeCgf6CHsiMVJHLf3OXu9BvH6P5Yl8LV
         OdRgBG35KmXXSoBJk7YV2oLRPkK4I6JjjoeTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706799518; x=1707404318;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dU+MsCzscQ6UONm8tpF2vrsbrHPrj73OELKoVqq4DUk=;
        b=PzCsC/NmihpaWE96Uc4QMVrM/ZkVVOJ6PGRhv/JozWFTnsq9EU7ISEburszz0QirbU
         vT1FbpqIl45/CNrM4wrIOjyoev+zzRX+6E/Ge4ME3nkc4U7kJDOWYSerG9xLDSMpspZk
         7tex0sDv0+7ykNA8NU7lL5dGg4Diu1E38ylwin7ZTLZA2VDD+cpM+MWSXBmjBtz8/1Hs
         Vc+EJ1aQSNEtJSqxi99OYowDr+xt9AF4JJlFg/0Mm0j8RV6xaU0qX7R8ODDHtP0bjiL4
         GhwcBH5QNxrYzzfgnesqxz6PNxF25jO0xyss4LwArsjntDj+oeCZYFrLBrHgG0Oa8nku
         ak9Q==
X-Gm-Message-State: AOJu0YytHBKcIrMl0bV8eC+/8qgQPvuvlJAPxFu8ApFFM/wuKXOnNuMy
	oL84A4tlMsOvlkbyZZBgrgGGzI7W+5sQlR1QCgEOKC/psWziSVIO9hsM/R4Ayb6S2m+s518QbUB
	G2g==
X-Google-Smtp-Source: AGHT+IFSPkOC8RNLhYMQ8fmZBcUOy3z0T/idOyg4kpRimruYJ6h37LmcUb3XlZklcXeolVGrqLqrkA==
X-Received: by 2002:a5e:8a04:0:b0:7bc:202a:bf9 with SMTP id d4-20020a5e8a04000000b007bc202a0bf9mr5578529iok.15.1706799517996;
        Thu, 01 Feb 2024 06:58:37 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWCcbanD74btxkSJNKWx+LaiO+gUpoRxXGcKjIsicbL2Q4I14Qsi7yjOLzFPbd7ps3wA9XaatjdfOWoEKE5WJTbesQWeKKYKA==
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com. [209.85.166.42])
        by smtp.gmail.com with ESMTPSA id fv11-20020a05663866cb00b0046f0e3d3f83sm3343357jab.157.2024.02.01.06.58.37
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 06:58:37 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c009016d5bso35983539f.1
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 06:58:37 -0800 (PST)
X-Received: by 2002:a05:6e02:10c:b0:363:7f00:8072 with SMTP id
 t12-20020a056e02010c00b003637f008072mr5640322ilm.28.1706799517108; Thu, 01
 Feb 2024 06:58:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170014.969142961@linuxfoundation.org> <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org> <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh> <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
In-Reply-To: <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
From: Justin Forbes <jforbes@fedoraproject.org>
Date: Thu, 1 Feb 2024 08:58:26 -0600
X-Gmail-Original-Message-ID: <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
Message-ID: <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command injection
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Jani Nikula <jani.nikula@intel.com>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 8:41=E2=80=AFAM Justin Forbes <jforbes@fedoraproject=
.org> wrote:
>
> On Thu, Feb 1, 2024 at 8:25=E2=80=AFAM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
> > > On Tue, Jan 30, 2024 at 10:21=E2=80=AFAM Jonathan Corbet <corbet@lwn.=
net> wrote:
> > > >
> > > > Justin Forbes <jforbes@fedoraproject.org> writes:
> > > >
> > > > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrot=
e:
> > > > >> 6.6-stable review patch.  If anyone has any objections, please l=
et me know.
> > > > >>
> > > > >> ------------------
> > > > >>
> > > > >> From: Vegard Nossum <vegard.nossum@oracle.com>
> > > > >>
> > > > >> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> > > > >>
> > > > >> The kernel-feat directive passes its argument straight to the sh=
ell.
> > > > >> This is unfortunate and unnecessary.
> > > > >>
> > > > >> Let's always use paths relative to $srctree/Documentation/ and u=
se
> > > > >> subprocess.check_call() instead of subprocess.Popen(shell=3DTrue=
).
> > > > >>
> > > > >> This also makes the code shorter.
> > > > >>
> > > > >> This is analogous to commit 3231dd586277 ("docs: kernel_abi.py: =
fix
> > > > >> command injection") where we did exactly the same thing for
> > > > >> kernel_abi.py, somehow I completely missed this one.
> > > > >>
> > > > >> Link: https://fosstodon.org/@jani/111676532203641247
> > > > >> Reported-by: Jani Nikula <jani.nikula@intel.com>
> > > > >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> > > > >> Cc: stable@vger.kernel.org
> > > > >> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > > > >> Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegard.=
nossum@oracle.com
> > > > >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > >
> > > > > This patch seems to be missing something. In 6.6.15-rc1 I get a d=
oc
> > > > > build failure with:
> > > > >
> > > > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.1=
5-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133:=
 SyntaxWarning: invalid escape sequence '\.'
> > > > >   line_regex =3D re.compile("^\.\. LINENO ([0-9]+)$")
> > > >
> > > > Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Pytho=
n
> > > > string escapes).  That is not a problem with this patch, though; I =
would
> > > > expect you to get the same error (with Python 3.12) without.
> > >
> > > Well, it appears that 6.6.15 shipped anyway, with this patch included=
,
> > > but not with 86a0adc029d3.  If anyone else builds docs, this thread
> > > should at least show them the fix.  Perhaps we can get the missing
> > > patch into 6.6.16?
> >
> > Sure, but again, that should be independent of this change, right?
>
> I am not sure I would say independent. This particular change causes
> docs to fail the build as I mentioned during rc1.  There were no
> issues building 6.6.14 or previous releases, and no problem building
> 6.7.3.

I can confirm that adding this patch to 6.6.15 makes docs build again.

Justin

> Justin
>
> > thanks,
> >
> > greg k-h
> >
> >
> > >
> > > Jusitn
> > >
> > > > Thanks,
> > > >
> > > > jon
> > > >
> > >
> >
