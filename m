Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAC81DF27A
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728398461; cv=none; b=VHWXxEb9wgXc2T+lhkfdLfsBoFpaQJheJglGyC8Z8xDK3iXh/W0j/ykATsyOUiLilZVxmFxxZvMgsF8rbzb4K/Py2MIuqMmvhCyEjnChd+ch79rtccTpuzgbd/n+aonn9jWzS17rPSL/WFOdnDL/85UtOL3PhJ+ZQqfpganCNu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728398461; c=relaxed/simple;
	bh=PFjVtz4inbM50WtUyHtYw0Am2Az3EpMC8mLk1Ellgr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QfEmbEkHV35xJdnUXRsI2jTDpgjPDsBugm4PIB2cMxXQrzQjZygRKL1Xwe6zBIXUcZfQ4K82+MzcD56uBGES/oyNqbhGyUyy+YEoBFd4fAuP08oeYr1uj/XS4Dh1e/DSDXZ5KS97cbib19tslI3eYKAb+2LHlCbhwP7ut3Fo6rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EhtiiPQd; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhtiiPQd"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53993c115cfso7303087e87.2
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 07:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728398457; x=1729003257; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZyeaaLdT9Ra809qAoYWtXxMYfajBYOU3xJzmen+kJX0=;
        b=EhtiiPQdPuwzidm1MPkNGsQAVIt7iJPkp7prAAT4JEHcEh9bZkxGUNqsZ+KcVmT3Nb
         YcWZ/gYqsg9tmAHaQCwts5vIoXEkxKzgvPZeNpAKAjGsk0Vx9Zzm0XwaBpox2Ue8X0Go
         M4P4UFyLYx8q05hbh/VRjS0JOCFuVmExbeVs6bR8Ndoo5Y3/RW9RIAE0jYAQI0LcyxsY
         D8uzCZysfmi8uiRDQp/zsHqHgCKHAFwy4Qo8JNUfgg9J8CbO1CCrrx9iL5w134118OJE
         DZM9Wp0qIP9ig546x5mYGNg2kt8YBT9OkzzH6q/g1m2ZAGSTPzk95G2weY6tBkPg5Mvc
         y40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728398457; x=1729003257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZyeaaLdT9Ra809qAoYWtXxMYfajBYOU3xJzmen+kJX0=;
        b=Ef03l1xV6bpikEaoHNQEO0yXrbzvIoOsyXses9n8m2jN3FHky+nG+Dl33UR+zUcu7Q
         2GWKNilHTiv3Z9iw7+e+5qM5XYqa9qcPG58eIMEZSksNut1UA5d98tW3+Kg0ZSG8nouM
         VDvLeDulWKmc3pBzb6KmDCiJPuQQb5p0ka8ewlSjMjo57Hlhp5jV2w2GPVKzQ5UkyXMn
         HKVVTp4OTo4AgnQ8VEFK6N79pSsyaJk20c3fpJHOeUdLdbJkVq7JiClPkJ0hbeHAK0hR
         /VJh/p0aZSGpzs0C06yE5Y6X5fxuue/cPjTSr2RHgorszOxkpTRPwG6HhyEYCDvQpY+r
         YLFA==
X-Forwarded-Encrypted: i=1; AJvYcCX9W2wKkqvQ3anwNcTMlz9sUc8sdFwa8O53OkCWAy4RSCRxOlTQDZSTOEN137iadripYlxLuQE7@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw5bW+KOTC6LaFa6/puUBQ4k2AAQ6mKkKogoFSa8DHS+JATt0u
	ztJJrmuOxMfbupdqRJZfm0AcbvfBvgYqOjQ0opBxMf+kNrq/4usKQI5K+05CVZhU0L164LQQjzj
	AIfsnhzxj6c7R0Hq6GwDVlKiKs2g=
X-Google-Smtp-Source: AGHT+IHkZ5rKBCsEBpDfsa1I3/8Mm3hBa4OOzVnd8soxtgOcDmi2R/2AKM9AT4MMrOEK8Pcdjg0UnOxJtpMlkN1DQOM=
X-Received: by 2002:a05:6512:124d:b0:539:9ee4:bab3 with SMTP id
 2adb3069b0e04-539ab9ed195mr8513939e87.59.1728398456989; Tue, 08 Oct 2024
 07:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115702.214071228@linuxfoundation.org> <20241008115719.272201292@linuxfoundation.org>
 <CA+icZUUjDD6r1NMQ6Kiscq8Yt0a-vBYjh1SiW1oNMQEKPWXQbA@mail.gmail.com> <2024100859-enviable-phony-9be8@gregkh>
In-Reply-To: <2024100859-enviable-phony-9be8@gregkh>
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 8 Oct 2024 16:40:20 +0200
Message-ID: <CA+icZUWV_ooRHbSmxj6JuaOGXhdkr1jUSK+TkfdvX-JaiG5MyQ@mail.gmail.com>
Subject: Re: [PATCH 6.11 432/558] perf python: Disable -Wno-cast-function-type-mismatch
 if present on clang
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ian Rogers <irogers@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Namhyung Kim <namhyung@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 8, 2024 at 4:06=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 08, 2024 at 03:05:41PM +0200, Sedat Dilek wrote:
> > On Tue, Oct 8, 2024 at 3:01=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 6.11-stable review patch.  If anyone has any objections, please let m=
e know.
> > >
> > > ------------------
> > >
> > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > >
> > > commit 00dc514612fe98cfa117193b9df28f15e7c9db9c upstream.
> > >
> > > The -Wcast-function-type-mismatch option was introduced in clang 19 a=
nd
> > > its enabled by default, since we use -Werror, and python bindings do
> > > casts that are valid but trips this warning, disable it if present.
> > >
> > > Closes: https://lore.kernel.org/all/CA+icZUXoJ6BS3GMhJHV3aZWyb5Cz2haF=
neX0C5pUMUUhG-UVKQ@mail.gmail.com
> > > Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> > > Cc: Ian Rogers <irogers@google.com>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Namhyung Kim <namhyung@kernel.org>
> > > Cc: Nathan Chancellor <nathan@kernel.org>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: stable@vger.kernel.org # To allow building with the upcoming clan=
g 19
> > > Link: https://lore.kernel.org/lkml/CA+icZUVtHn8X1Tb_Y__c-WswsO0K8U9uy=
3r2MzKXwTA5THtL7w@mail.gmail.com
> > > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  tools/perf/util/setup.py |    2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > --- a/tools/perf/util/setup.py
> > > +++ b/tools/perf/util/setup.py
> > > @@ -63,6 +63,8 @@ cflags =3D getenv('CFLAGS', '').split()
> > >  cflags +=3D ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unu=
sed-parameter', '-Wno-redundant-decls' ]
> > >  if cc_is_clang:
> > >      cflags +=3D ["-Wno-unused-command-line-argument" ]
> > > +    if clang_has_option("-Wno-cast-function-type-mismatch"):
> > > +        cflags +=3D ["-Wno-cast-function-type-mismatch" ]
> > >  else:
> > >      cflags +=3D ['-Wno-cast-function-type' ]
> > >
> > >
> > >
> >
> > ( I already responded to a stable-commits email sent to me, but here
> > might be better. )
> >
> > Hi Greg,
> >
> > You need both patches:
> >
> > upstream 00dc514612fe98cfa117193b9df28f15e7c9db9c
> > "perf python: Disable -Wno-cast-function-type-mismatch if present on cl=
ang"
> > ^^ You have only this one - sets only the warning flag
> >
> > upstream b81162302001f41157f6e93654aaccc30e817e2a
> > "perf python: Allow checking for the existence of warning"
> > ^^ Add this please to all stable trees affected, Thanks.
> >
> > Explanations in [1] and initial report in [2].
>
> Thanks, now queued up!
>
> greg k-h

Cool, that will be a nice stable-linux version 6.11.3 for us!

-sed@-
