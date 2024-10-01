Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B959F1CBEBF
	for <patches@lists.linux.dev>; Tue,  1 Oct 2024 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727792041; cv=none; b=OidVqxbB1HGJ5PW4Dcq93Ej7PncZmIuj+Clx6aKPdfpZQ6lO1KGFeecVWby1tqq7nUlzw3Ys7t5HTtsg/PDa/U/SqRPDNdThj48O9XcFSxJOEZAqLkgoHY98m9S86EMJn04xRL7KP9qKrA7RJcEFPk6TCbWXmdARRREzIUzf4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727792041; c=relaxed/simple;
	bh=+FKUddij/gxQNpHjW2/b65NyFWE/k6zemBV6DcE0H+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G8yQFqCUkUCMzR8I9Zua/N4r49cLpRh2Uph9Uk5eDI32EczKodyjPvh3KTJEA7Xu8AYIlIDBXKn/65XvQbtsO9OojhrEDVkYCDN+0IX37YyJRfyYtWEmpe84koD4qoTtoQwxFW681ulOA4tKXX8z7xFaJ2kpXrDZGArmTq1eu1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=H/9exhTP; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="H/9exhTP"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2689e7a941fso2677463fac.3
        for <patches@lists.linux.dev>; Tue, 01 Oct 2024 07:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1727792038; x=1728396838; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GXNRv4R5VmvPOl/Xct8Si1vB9z90P2avYuEV2rget7M=;
        b=H/9exhTPbG/U02uGY9by0fUf7UXIPyktl66pUqQmn0UP3yEr1TvTrlwpfNEurw0/iM
         HsbxOcey0Ai1BPXCuAHdemgfc4UkfjF0DCQrBU1cNgGWvxH8BDBZmIRxO8NFsCvxDr+l
         mGVST2ZTpwUZDH1fPNuXzR9/+wmNcxb2rWW9Tbo5PrqdEA+gtXjfLWlts/JPOc1vHjXV
         pzhsfrZd0BycGucsX2oWzOJl5GV3nEDzC/uAUESpE0d1j5pjrW98rscZSoyW+uRva62H
         sbO/pw1qbmA1G8mSn890B/n+sioiKEHDRSOUtBd8P2g1TM60K5odi47r/SfqZ+sZVW5Z
         w/9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727792038; x=1728396838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GXNRv4R5VmvPOl/Xct8Si1vB9z90P2avYuEV2rget7M=;
        b=fI0A+9QaA3S/Zzz3pjOeBYhvYcviZD/cGQ3lphJoIqwOl7ot7eG0HUE+FphWwsdURI
         9q/Dl+iTASvLJ9Wm9/kNmmninhoJQA6PJWzliGCSBuQ++2lrXhMlNtOsOItn4X/PdBPr
         1GgRn7TG3bBAAHl2piy+pZdmAvdsg/GgcoyQZprhPLcK1a5QLqNt/dI+CDxZRbSEWUFm
         NTPnkLJWmr7jlFIll+903En2zLk4kacd80o2VVVSZkgYhdxlUIvBiQJFPbKme0JriWpZ
         bUcZHeDd9P4nQGsxlXchwqSnGgya87OkLu37OelO9k5PYpvfd/j9WnKThlGy09lHPNbh
         gbnw==
X-Forwarded-Encrypted: i=1; AJvYcCXQoOCIIHyjBGWX0vzwYatybSW+f9AgnwQobzoCJRo0aXygD/grpZu0ED6xJX0ekfTHZIDwAysI@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/qTi+PCt9z/H0jhGR4+9chSJXiZgBetPxLe3Nr0Y7+bxk6RuO
	R6yBsWwJVgDqLHZqDNp7LsX/R6QMTLuVc45wkGpklfh2N6h2SS7P/IIkwWb5/HgfymqLNxj59iE
	+4YIY2pLr/3GCHv27h4X503+FkFNs4wYSRHnR
X-Google-Smtp-Source: AGHT+IFMGvyp3IY12n2ve9jQjiLs86OcN1H193F2bZNg+PAFq+kScDkFEWvxGnsgYNZpsi7YFM4vdBKzpoYT5KslJgA=
X-Received: by 2002:a05:6870:5b88:b0:261:1f7d:cf6e with SMTP id
 586e51a60fabf-28710c45c43mr8810649fac.41.1727792037867; Tue, 01 Oct 2024
 07:13:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240928-maintainers-security-kconfig-hardening-v1-1-c8c64071cc02@kernel.org>
 <1923f716100.28a7.85c95baa4474aabc7814e68940a78392@paul-moore.com> <20240929210004.GA1300946@thelio-3990X>
In-Reply-To: <20240929210004.GA1300946@thelio-3990X>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 1 Oct 2024 10:13:43 -0400
Message-ID: <CAHC9VhRqevog8t4+D=t+d7+bvMs9jrW99Kvd_JF-1LSH0YN2VA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add security/Kconfig.hardening to hardening section
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 5:00=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
> On Sun, Sep 29, 2024 at 10:20:59PM +0200, Paul Moore wrote:
> > On September 28, 2024 8:26:28 PM Nathan Chancellor <nathan@kernel.org> =
wrote:
> > > When running get_maintainer.pl on security/Kconfig.hardening, only th=
e
> > > security subsystem folks show up, even though they have never taken
> > > patches to this file:
> > >
> > >  $ scripts/get_maintainer.pl security/Kconfig.hardening
> > >  Paul Moore <...> (supporter:SECURITY SUBSYSTEM)
> > >  James Morris <...> (supporter:SECURITY SUBSYSTEM)
> > >  "Serge E. Hallyn" <...> (supporter:SECURITY SUBSYSTEM)
> > >  linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
> > >  linux-kernel@vger.kernel.org (open list)
> > >
> > >  $ git log --format=3D%cn --no-merges security/Kconfig.hardening | so=
rt | uniq -c
> > >        3 Andrew Morton
> > >        1 Greg Kroah-Hartman
> > >       18 Kees Cook
> > >        2 Linus Torvald
> > >
> > > Add it to the hardening section so that the KSPP folks are also shown=
,
> > > which matches reality over who should comment on and take said patche=
s
> > > if necessary.
> > >
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > > MAINTAINERS | 1 +
> > > 1 file changed, 1 insertion(+)
> >
> > For the sake of casual observers, the reason James, Serge, or I haven't
> > merged anything in Kconfig.hardening isn't due to any malicious intent =
or
> > lack of appreciation, rather it is out of respect for KSPP and not want=
ing
> > to step on Kees' toes.
>
> Right, I did not mean for this to come off in an accusatory way, so my
> apologies if it did. I merely wanted to codify this arrangement so that
> patches get picked up or acked by the correct people in the future since
> I had to send one earlier and I noticed it did not match reality (with
> the data to prove it heh) ...

No worries, I had hoped to make it clear I wasn't too bothered by this
with the 'for casual observers' remark, but I guess I should have been
more explicit.  I wrote my original reply simply because I've seen
people take snippets out of context far too many times and I didn't
want anyone to think there was a problem here.

> > I've happily merged KSPP related patches to those subsystems which I'm
> > tasked with looking after and I plan to continue to do so.
>
> Always happy to have as many KSPP allies as possible :)

Hopefully the LSM folks can consider KSPP as an ally too ;)

--=20
paul-moore.com
