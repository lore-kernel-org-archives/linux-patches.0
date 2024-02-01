Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002E2B9AC
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706798513; cv=none; b=XSVi0YrpvHE3Gx02TH3rOr+QB0KQtyomdQRZ1VjB34bwRah0H8VzExUAQae2+0oHGDdDG3rphNdhU3xII+FsTlE3FUvkp/ZVUTl0Y/EEo956zKBnRZ5VXVVQj+4n8u501V7PUNk55bBf6LTahqyg+3VgNt9wNByKfZB+PJn/4P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706798513; c=relaxed/simple;
	bh=doMIEKjhlaw3cSONB3YjMbb/GGYi2CZhyJNDxYux14c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dfm+HIfI7/E0Gg2s52LRovxECl/ShguZOSkULZDeTm4Ct07w4G5yXDLh+t57Ve228XZTWQhVMb88HAuWh3pztDrQ7hE1xsZpczJIPb5jETjEh35ma29ljS8WowHT+kOEEKGvYjQS/1ZFNf5+RacU8IPq8mF9phPHKYmXGIfsAI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=XxJk3HVI; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="XxJk3HVI"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bfdbaa135bso38814239f.3
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 06:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706798510; x=1707403310; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsOO2ZkkdcJTbF0BB2qngAJPCReDSBqBxrVox/Wl9y0=;
        b=XxJk3HVIvqP0/3Mvhx72So5yyel2n6ICbWe5i4C9mLAlux5aZyzWnox6t+m8Eu7BhW
         T+kl5mifWfBhbx93QniccSgSxzmAWe4UEbf6x+mxnMqm1Hzv4JTAuog9ebjDxaYN9A97
         ULsGI8mkginNewu0k+fIg3s1VT+fRGP6SK2iA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706798510; x=1707403310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zsOO2ZkkdcJTbF0BB2qngAJPCReDSBqBxrVox/Wl9y0=;
        b=JL+gli+GVBc5pweX0m+doivbO8AxXBXqh1KtmqjeVFNrZJa7oP5ij1u/zFLxUUN7Kf
         dB/12Wv0swolKEHr6bSWmuJ3uNr/jF0tUBp1ClfAZ3+Mg+mFMZrkzw8cesi32xO6QB9D
         CMncDAapbfP7Wrgu2fWDeKrTMSmDQ4NLr7B84eABOlHEaim4a0eV5y6lHAiO5EQiuNi0
         jOomUKJsfII/iFZjMfe+rVkaYFUgMyyEQiuz/wdQ23vHyiiGPflbMB+WSwZvFLYoaGfD
         UtlC7BT0kQA+l/qbp4W4ZE80eten0VykxiUL8jhzVqMkNL8vbM1fjpbaYbyyElqsudKM
         2cpQ==
X-Gm-Message-State: AOJu0YxCsLvUMjiu00CanJ8DDD44wUpeGEE5N7qKRDsMPz8spPb+vG2B
	XziSVC0gf47ptqTAzTo+lfZdCao3UrZ5gbvMRz9+zNJxayRYdUWjy+7P49CxtsJYb8HAfGLYxFg
	sOw==
X-Google-Smtp-Source: AGHT+IGbT6KGTfH4FEMBrylFxzznijw5ZBUBUZ8yPoibbtBPO6g4rXEul7Tg1M36fafeTUUiPblPxg==
X-Received: by 2002:a05:6602:5c8:b0:7c0:56c:1706 with SMTP id w8-20020a05660205c800b007c0056c1706mr4869606iox.16.1706798509787;
        Thu, 01 Feb 2024 06:41:49 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWFjKZo+Hcx5gl/oJDOuL0kineugzgGAp6n2YEd6rDw90y/h1Imw/EhQ6f58Khysd3GnEgfFIJWdMZnbpMHOsqFMrLGFmUu0w==
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com. [209.85.166.174])
        by smtp.gmail.com with ESMTPSA id w20-20020a056638139400b00470fd5f9d8esm374460jad.54.2024.02.01.06.41.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 06:41:49 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3637d8ec873so4617865ab.1
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 06:41:49 -0800 (PST)
X-Received: by 2002:a05:6e02:2389:b0:35f:b61f:a8a8 with SMTP id
 bq9-20020a056e02238900b0035fb61fa8a8mr7594283ilb.26.1706798509204; Thu, 01
 Feb 2024 06:41:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170014.969142961@linuxfoundation.org> <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org> <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com> <2024020151-purchase-swerve-a3b3@gregkh>
In-Reply-To: <2024020151-purchase-swerve-a3b3@gregkh>
From: Justin Forbes <jforbes@fedoraproject.org>
Date: Thu, 1 Feb 2024 08:41:38 -0600
X-Gmail-Original-Message-ID: <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
Message-ID: <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command injection
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Jani Nikula <jani.nikula@intel.com>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 8:25=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
> > On Tue, Jan 30, 2024 at 10:21=E2=80=AFAM Jonathan Corbet <corbet@lwn.ne=
t> wrote:
> > >
> > > Justin Forbes <jforbes@fedoraproject.org> writes:
> > >
> > > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
> > > >> 6.6-stable review patch.  If anyone has any objections, please let=
 me know.
> > > >>
> > > >> ------------------
> > > >>
> > > >> From: Vegard Nossum <vegard.nossum@oracle.com>
> > > >>
> > > >> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> > > >>
> > > >> The kernel-feat directive passes its argument straight to the shel=
l.
> > > >> This is unfortunate and unnecessary.
> > > >>
> > > >> Let's always use paths relative to $srctree/Documentation/ and use
> > > >> subprocess.check_call() instead of subprocess.Popen(shell=3DTrue).
> > > >>
> > > >> This also makes the code shorter.
> > > >>
> > > >> This is analogous to commit 3231dd586277 ("docs: kernel_abi.py: fi=
x
> > > >> command injection") where we did exactly the same thing for
> > > >> kernel_abi.py, somehow I completely missed this one.
> > > >>
> > > >> Link: https://fosstodon.org/@jani/111676532203641247
> > > >> Reported-by: Jani Nikula <jani.nikula@intel.com>
> > > >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> > > >> Cc: stable@vger.kernel.org
> > > >> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > > >> Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegard.no=
ssum@oracle.com
> > > >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > >
> > > > This patch seems to be missing something. In 6.6.15-rc1 I get a doc
> > > > build failure with:
> > > >
> > > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-=
0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: S=
yntaxWarning: invalid escape sequence '\.'
> > > >   line_regex =3D re.compile("^\.\. LINENO ([0-9]+)$")
> > >
> > > Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
> > > string escapes).  That is not a problem with this patch, though; I wo=
uld
> > > expect you to get the same error (with Python 3.12) without.
> >
> > Well, it appears that 6.6.15 shipped anyway, with this patch included,
> > but not with 86a0adc029d3.  If anyone else builds docs, this thread
> > should at least show them the fix.  Perhaps we can get the missing
> > patch into 6.6.16?
>
> Sure, but again, that should be independent of this change, right?

I am not sure I would say independent. This particular change causes
docs to fail the build as I mentioned during rc1.  There were no
issues building 6.6.14 or previous releases, and no problem building
6.7.3.

Justin

> thanks,
>
> greg k-h
>
>
> >
> > Jusitn
> >
> > > Thanks,
> > >
> > > jon
> > >
> >
>
