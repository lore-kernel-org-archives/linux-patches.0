Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC3F779E3
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706800043; cv=none; b=l2NMet/GAyBrGzSSwpqe+IIkGljkxl1NusFzM2Lar9dnbo9kZKGS7tch4IfGnMswu+oo0z7dymx3hbei4bP2EW8qGsRwU28smbqiKAsI3LmFx78txtijMqK1DTP+OC10ZSoaiwwpSX3Tmnde2Phk1QxfXJOkplrs/jWjJgUuWJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706800043; c=relaxed/simple;
	bh=zaytTEy7jy+6/KAaNuv/FUOFXtbhnd7Urpe6lXnk5JA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JjuqbsV1I/JNy6OcizUQlMsNOuXrBaReKxz+9fUo1mZgdOjH4E65cGSyIbgTl2W3d9ugq9PqKNr2eLkqe8icOZrLu+pIoxZuj3EwFK/4Ty1IJJHOE/3So1KNbedfu83DBrgOmrbMZLTeRvMkB3T9CtFVN4qvaeDJAkh/94i1O/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=R1MDN4KG; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="R1MDN4KG"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bf7e37dc60so37784139f.3
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 07:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706800040; x=1707404840; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgY/d12dFm2Xinyu0loyuGVBVDNk704GiE0Jx7MBIao=;
        b=R1MDN4KGMLrX6axA5HLHu+iCIt/1jYzFBBy/tl+do2Cs+hD+QmmdVooXrr6C82k4UD
         fyQ3yW8TUMy4O4qN4j+Vt6KZVViikozzlmsoNhxJ9e2k5qvmMOQpDDevHwyTzdg6L4ug
         chjTx7r9rGBoPMiXIOqjQ7lZLZ9KtO1kFvOO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706800040; x=1707404840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VgY/d12dFm2Xinyu0loyuGVBVDNk704GiE0Jx7MBIao=;
        b=FbuvooJkTT2z1dEzSbxF4RdExrdYpARd074wPJM/mmUnZupbGUBg3urVRp1HdSbPdh
         VpeAX0jwhdu1pm4x9nKhdf95KeLyWIF+OPveWKaRtKuZA9+K6exWdgf/lhXkh/dY6kJe
         BsFifci2qP0+yRvS8imkZ04JveuLdob16JagZRrpqs7ihvEtJxOtOfR6x0JI7yPjBXH8
         mcw2FhBi1qwF7lN472NLrd7VuqZHsGFZjwnIVSzgRaZaWu48rTp0GH2n8rT8DFRT2QQZ
         mn+m0EtUB1tyLLz+CYB70+eoAgHHflPatJpXesJgby3p2w1ulxMH614nZ+pmBigSmOdQ
         v0wQ==
X-Gm-Message-State: AOJu0YzqNrP/C/2tPXsBBA3dGIK3rGmjiZHoQ555KnvtQQVre5RWXP1x
	tdUaJ54+TNGnjtWVeddMhKaYVkq965oCiPNT9KoUusuRn8iLoms3IfZ10Mm3jy7c/G9JV7l0fBw
	I/w==
X-Google-Smtp-Source: AGHT+IHUN7wY3Bk4I2YLnqR2KohtNwFPzMleWzVKSWVn8D6rRtv6L2QGr2w4VF67zJw8QcCb6m2m5Q==
X-Received: by 2002:a92:dac2:0:b0:363:76be:a65c with SMTP id o2-20020a92dac2000000b0036376bea65cmr5238115ilq.13.1706800040201;
        Thu, 01 Feb 2024 07:07:20 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUJqpIWdEKuWBM31yOKFcWrzj6Gi+s27PvjYksWgI8c26r2Wy5f0PzzFlPp3sKpKhcM/PXZFjXW2wmWZ31t/UoxIhjVIYOBUw==
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com. [209.85.166.48])
        by smtp.gmail.com with ESMTPSA id e15-20020a92de4f000000b003638d562059sm2015535ilr.73.2024.02.01.07.07.19
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 07:07:19 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7bade847536so44177139f.0
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 07:07:19 -0800 (PST)
X-Received: by 2002:a92:cf48:0:b0:363:9280:8912 with SMTP id
 c8-20020a92cf48000000b0036392808912mr5067103ilr.27.1706800039409; Thu, 01 Feb
 2024 07:07:19 -0800 (PST)
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
 <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
In-Reply-To: <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
From: Justin Forbes <jforbes@fedoraproject.org>
Date: Thu, 1 Feb 2024 09:07:08 -0600
X-Gmail-Original-Message-ID: <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
Message-ID: <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command injection
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Jani Nikula <jani.nikula@intel.com>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 8:58=E2=80=AFAM Justin Forbes <jforbes@fedoraproject=
.org> wrote:
>
> On Thu, Feb 1, 2024 at 8:41=E2=80=AFAM Justin Forbes <jforbes@fedoraproje=
ct.org> wrote:
> >
> > On Thu, Feb 1, 2024 at 8:25=E2=80=AFAM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
> > > > On Tue, Jan 30, 2024 at 10:21=E2=80=AFAM Jonathan Corbet <corbet@lw=
n.net> wrote:
> > > > >
> > > > > Justin Forbes <jforbes@fedoraproject.org> writes:
> > > > >
> > > > > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wr=
ote:
> > > > > >> 6.6-stable review patch.  If anyone has any objections, please=
 let me know.
> > > > > >>
> > > > > >> ------------------
> > > > > >>
> > > > > >> From: Vegard Nossum <vegard.nossum@oracle.com>
> > > > > >>
> > > > > >> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> > > > > >>
> > > > > >> The kernel-feat directive passes its argument straight to the =
shell.
> > > > > >> This is unfortunate and unnecessary.
> > > > > >>
> > > > > >> Let's always use paths relative to $srctree/Documentation/ and=
 use
> > > > > >> subprocess.check_call() instead of subprocess.Popen(shell=3DTr=
ue).
> > > > > >>
> > > > > >> This also makes the code shorter.
> > > > > >>
> > > > > >> This is analogous to commit 3231dd586277 ("docs: kernel_abi.py=
: fix
> > > > > >> command injection") where we did exactly the same thing for
> > > > > >> kernel_abi.py, somehow I completely missed this one.
> > > > > >>
> > > > > >> Link: https://fosstodon.org/@jani/111676532203641247
> > > > > >> Reported-by: Jani Nikula <jani.nikula@intel.com>
> > > > > >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> > > > > >> Cc: stable@vger.kernel.org
> > > > > >> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> > > > > >> Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegar=
d.nossum@oracle.com
> > > > > >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > >
> > > > > > This patch seems to be missing something. In 6.6.15-rc1 I get a=
 doc
> > > > > > build failure with:
> > > > > >
> > > > > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6=
.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:13=
3: SyntaxWarning: invalid escape sequence '\.'
> > > > > >   line_regex =3D re.compile("^\.\. LINENO ([0-9]+)$")
> > > > >
> > > > > Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Pyt=
hon
> > > > > string escapes).  That is not a problem with this patch, though; =
I would
> > > > > expect you to get the same error (with Python 3.12) without.
> > > >
> > > > Well, it appears that 6.6.15 shipped anyway, with this patch includ=
ed,
> > > > but not with 86a0adc029d3.  If anyone else builds docs, this thread
> > > > should at least show them the fix.  Perhaps we can get the missing
> > > > patch into 6.6.16?
> > >
> > > Sure, but again, that should be independent of this change, right?
> >
> > I am not sure I would say independent. This particular change causes
> > docs to fail the build as I mentioned during rc1.  There were no
> > issues building 6.6.14 or previous releases, and no problem building
> > 6.7.3.
>
> I can confirm that adding this patch to 6.6.15 makes docs build again.

I lied, it just fails slightly differently. Some of the noise is gone,
but we still have:
Sphinx parallel build error:
UnboundLocalError: cannot access local variable 'fname' where it is
not associated with a value
make[2]: *** [Documentation/Makefile:102: htmldocs] Error 2
make[1]: *** [/builddir/build/BUILD/kernel-6.6.15/linux-6.6.15-200.fc39.noa=
rch/Makefile:1715:
htmldocs] Error 2

> Justin
>
> > Justin
> >
> > > thanks,
> > >
> > > greg k-h
> > >
> > >
> > > >
> > > > Jusitn
> > > >
> > > > > Thanks,
> > > > >
> > > > > jon
> > > > >
> > > >
> > >
