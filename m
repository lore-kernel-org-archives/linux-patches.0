Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E28F49
	for <patches@lists.linux.dev>; Mon,  5 Feb 2024 02:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707100603; cv=none; b=EbnmBpklGzTwpadb3WYt9BMsVTIPHvt21obe/qdv3+rH7Tc/uC9w1fhqO6v55xNbpDn4zVnLfp2JhnMm7OdPFDOAibkuaNDxZbtHjGVQnwYrazuLbjiXeRy5ekvZWvHmpZ363MoR/rBhgEZKDa6+Su7kL/aDmQno4DzSQGcBx34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707100603; c=relaxed/simple;
	bh=moawmu/R7SkvIszsNA58WWtFqtAPtbcjuG7SFFT/lew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NmR0HhT10jqXYZtFwX57F+qPJre394/MRauPsZLdPDKZPMJZqRuneKKOBqDig+yVAJDrMgEVH63gbWx4o9ZVj+pvnMyt3Oixlmpr43sX1gUT2Aq0z/h1CZMwviHqzslow2BEpV73AKgVo4aLUwdpRJixhdxUJxeOXOPLKV5BpIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=ENc8L2L6; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="ENc8L2L6"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-363afc38a1cso8917335ab.3
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 18:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1707100599; x=1707705399; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qU9GWODvVKB+EFUVXJYWQXMFFmQ70Fyp511xtLl9Zc=;
        b=ENc8L2L62VV1VzVsf+gxSue/DbE6nuLZZiFRWdrwfaG1NKRV5K3dWLZUo1mqrc3doT
         8izS4VA2tXABYQRnArbHcnPmT+a6OfCsDd3fn1+fVXEzt0GWda6qCiXGMxvaS2f/iDJI
         9XYvs7kJL+j2uy2uwsiag3u/49Sqx8d6VrALg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707100599; x=1707705399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8qU9GWODvVKB+EFUVXJYWQXMFFmQ70Fyp511xtLl9Zc=;
        b=X3hbXjpSPI9vXq1q3y/l7r+WzBFUk5cEXTzhjvA9fBc++oxgGAP/UvdyJGNb+qggB/
         vR7qquRYaer2ZQqU37w9eqcwUBrp+H4cm+tAsXZIZQYeAZSW+Z51J5m+Q+AnXn0Ldct1
         Q3RAxTZ4u7CslphLm496B3HLrlcoB6MP3Q4nR4gZZ+F7kcNMTawAgZ6DzewRoYA8wCO9
         bKKgWIvq6f5EcMEmW64UA7sHNCy6pvje5SbHiaF9nQ5WO7ptnufrcKtiAWYF1Rxz97Tw
         tyL0YzVdkKf9KNK3s5ABwkOrcIutBmsaYFmwHvpqnmaiyPKKTT/ncsodwJJLtsL3USTS
         IyjA==
X-Gm-Message-State: AOJu0YxMOQf/GzK9mmX3q8i9qQqx/FLJn4eEPP6aLJ7LWmSMa1Jgochl
	5bqv55Etcw0eMIyHSRZnHWOTRWanF1f6AwNishhbKeXvPhlkQVom8wQ3R4r39hpzfPDnsZt2vhn
	QVg==
X-Google-Smtp-Source: AGHT+IHIpFM3BYPiUiSdQUs2evjbAqALGiHta82d9OtTU+kpyfUjHZN146xhYCVX3ADg8GvXnPGLCg==
X-Received: by 2002:a92:c56c:0:b0:363:a747:932d with SMTP id b12-20020a92c56c000000b00363a747932dmr12051214ilj.26.1707100599467;
        Sun, 04 Feb 2024 18:36:39 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWjFhEbDz11NITDAWaRKm/iWd3TJ3Pl/UpsKGNmpEuWWdzyXbxrSNh0xZdHKo73ofE9RlH3fN9J/7j/cgbVvSzKhRgk0N0m5A==
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com. [209.85.166.182])
        by smtp.gmail.com with ESMTPSA id x7-20020a029707000000b004712b208136sm468983jai.79.2024.02.04.18.36.38
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Feb 2024 18:36:38 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-363a47b810aso15863815ab.0
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 18:36:38 -0800 (PST)
X-Received: by 2002:a92:c612:0:b0:363:8560:977d with SMTP id
 p18-20020a92c612000000b003638560977dmr9984128ilm.3.1707100597756; Sun, 04 Feb
 2024 18:36:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZbkfGst991YHqJHK@fedora64.linuxtx.org> <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh> <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
 <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
 <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
 <1a160e5f-d5ce-4711-b683-808ab87b289b@oracle.com> <Zb_DwdZ3PUr1VbBg@eldamar.lan>
 <Zb_0NEeCqok8icwz@eldamar.lan> <2024020402-scotch-upchuck-9e11@gregkh>
In-Reply-To: <2024020402-scotch-upchuck-9e11@gregkh>
From: Justin Forbes <jforbes@fedoraproject.org>
Date: Sun, 4 Feb 2024 20:36:26 -0600
X-Gmail-Original-Message-ID: <CAFbkSA08Wo-rWJiOXf4BmNu_nXFX6gQriW5J09L8KzSHUU1j9g@mail.gmail.com>
Message-ID: <CAFbkSA08Wo-rWJiOXf4BmNu_nXFX6gQriW5J09L8KzSHUU1j9g@mail.gmail.com>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command injection
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Jani Nikula <jani.nikula@intel.com>, Sasha Levin <sashal@kernel.org>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 4, 2024 at 7:29=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Feb 04, 2024 at 09:31:48PM +0100, Salvatore Bonaccorso wrote:
> > On Sun, Feb 04, 2024 at 06:05:05PM +0100, Salvatore Bonaccorso wrote:
> > > Hi,
> > >
> > > On Thu, Feb 01, 2024 at 05:34:25PM +0100, Vegard Nossum wrote:
> > > >
> > > > On 01/02/2024 16:07, Justin Forbes wrote:
> > > > > On Thu, Feb 1, 2024 at 8:58=E2=80=AFAM Justin Forbes <jforbes@fed=
oraproject.org> wrote:
> > > > > > On Thu, Feb 1, 2024 at 8:41=E2=80=AFAM Justin Forbes <jforbes@f=
edoraproject.org> wrote:
> > > > > > > On Thu, Feb 1, 2024 at 8:25=E2=80=AFAM Greg Kroah-Hartman
> > > > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > > > On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wro=
te:
> > > > > > > > > On Tue, Jan 30, 2024 at 10:21=E2=80=AFAM Jonathan Corbet =
<corbet@lwn.net> wrote:
> > > > > > > > > > Justin Forbes <jforbes@fedoraproject.org> writes:
> > > > > > > > > > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-=
Hartman wrote:
> > > > > > > > > > > > 6.6-stable review patch.  If anyone has any objecti=
ons, please let me know.
> > > > > > > > > > > >
> > > > > > > > > > > > ------------------
> > > > > > > > > > > >
> > > > > > > > > > > > From: Vegard Nossum <vegard.nossum@oracle.com>
> > > > > > > > > > > >
> > > > > > > > > > > > [ Upstream commit c48a7c44a1d02516309015b6134c9bb98=
2e17008 ]
> > > > > > > > > > > >
> > > > > > > > > > > > The kernel-feat directive passes its argument strai=
ght to the shell.
> > > > > > > > > > > > This is unfortunate and unnecessary.
> > > >
> > > > [...]
> > > >
> > > > > > > > > > > This patch seems to be missing something. In 6.6.15-r=
c1 I get a doc
> > > > > > > > > > > build failure with:
> > > > > > > > > > >
> > > > > > > > > > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b=
/linux-6.6.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerne=
ldoc.py:133: SyntaxWarning: invalid escape sequence '\.'
> > > > > > > > > > >    line_regex =3D re.compile("^\.\. LINENO ([0-9]+)$"=
)
> > > > > > > > > >
> > > > > > > > > > Ah ... you're missing 86a0adc029d3 (Documentation/sphin=
x: fix Python
> > > > > > > > > > string escapes).  That is not a problem with this patch=
, though; I would
> > > > > > > > > > expect you to get the same error (with Python 3.12) wit=
hout.
> > > > > > > > >
> > > > > > > > > Well, it appears that 6.6.15 shipped anyway, with this pa=
tch included,
> > > > > > > > > but not with 86a0adc029d3.  If anyone else builds docs, t=
his thread
> > > > > > > > > should at least show them the fix.  Perhaps we can get th=
e missing
> > > > > > > > > patch into 6.6.16?
> > > > > > > >
> > > > > > > > Sure, but again, that should be independent of this change,=
 right?
> > > > > > >
> > > > > > > I am not sure I would say independent. This particular change=
 causes
> > > > > > > docs to fail the build as I mentioned during rc1.  There were=
 no
> > > > > > > issues building 6.6.14 or previous releases, and no problem b=
uilding
> > > > > > > 6.7.3.
> > > > > >
> > > > > > I can confirm that adding this patch to 6.6.15 makes docs build=
 again.
> > > > >
> > > > > I lied, it just fails slightly differently. Some of the noise is =
gone,
> > > > > but we still have:
> > > > > Sphinx parallel build error:
> > > > > UnboundLocalError: cannot access local variable 'fname' where it =
is
> > > > > not associated with a value
> > > > > make[2]: *** [Documentation/Makefile:102: htmldocs] Error 2
> > > > > make[1]: *** [/builddir/build/BUILD/kernel-6.6.15/linux-6.6.15-20=
0.fc39.noarch/Makefile:1715:
> > > > > htmldocs] Error 2
> > > >
> > > > The old version of the script unconditionally assigned a value to t=
he
> > > > local variable 'fname' (not a value that makes sense to me, since i=
t's
> > > > literally assigning the whole command, not just a filename, but tha=
t's a
> > > > separate issue), and I removed that so it's only conditionally assi=
gned.
> > > > This is almost certainly a bug in my patch.
> > > >
> > > > I'm guessing maybe a different patch between 6.6 and current mainli=
ne is
> > > > causing 'fname' to always get assigned for the newer versions and t=
hus
> > > > make the run succeed, in spite of the bug.
> > > >
> > > > Something like the patch below (completely untested) should restore=
 the
> > > > previous behaviour, but I'm not convinced it's correct.
> > > >
> > > >
> > > > Vegard
> > > >
> > > > diff --git a/Documentation/sphinx/kernel_feat.py
> > > > b/Documentation/sphinx/kernel_feat.py
> > > > index b9df61eb4501..15713be8b657 100644
> > > > --- a/Documentation/sphinx/kernel_feat.py
> > > > +++ b/Documentation/sphinx/kernel_feat.py
> > > > @@ -93,6 +93,8 @@ class KernelFeat(Directive):
> > > >          if len(self.arguments) > 1:
> > > >              args.extend(['--arch', self.arguments[1]])
> > > >
> > > > +        fname =3D ' '.join(args)
> > > > +
> > > >          lines =3D subprocess.check_output(args,
> > > > cwd=3Dos.path.dirname(doc.current_source)).decode('utf-8')
> > > >
> > > >          line_regex =3D re.compile(r"^\.\. FILE (\S+)$")
> > >
> > > We have as well a documention build problem in Debian, cf.
> > > https://buildd.debian.org/status/fetch.php?pkg=3Dlinux&arch=3Dall&ver=
=3D6.6.15-1&stamp=3D1707050360&raw=3D0
> > > though not yet using python 3.12 as default.
> > >
> > > Your above change seems to workaround the issue in fact, but need to
> > > do a full build yet.
> >
> > For Debian I'm temporarily reverting from the 6.6.15 upload:
> >
> > e961f8c6966a ("docs: kernel_feat.py: fix potential command injection")
> >
> > This is not the best solution, but unbreaks several other builds.
> >
> > The alternative would be to apply Vegard's workaround or the proper
> > solution for that.
>
> What is the "proper" solution here?  Does 6.8-rc3 work?  What are we
> missing to be backported here?

I am not sure what the "proper"fix was, but as I mentioned with
6.6.15, this patch broke the build with 6.6.15, but 6.7.3 and newer
were fine.  I think the fix came in through another path incidentally,
but Vegard mentioned a possible fox for 6.6 kernels.  Realistically,
Fedora has moved on to 6.7.x now, but I do still test 6.6.x stable rcs
and while I reported that 6.6.16 was good, it was only because I saw
no regressions from 6.6.15. The docs failure from this patch still
exists.

Justin

> thanks,
>
> greg k-h
>
