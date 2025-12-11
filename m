Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8C330BF72
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 15:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765467632; cv=none; b=dCqK+NwHZU6Vn47K0HDn8sqvVmeMlHbELs6LbZ8XMZGmJTjY0/WZHO0pMmuS+Gu8yHEr0N9QR9Ixgdl4TdjodfVoD5zUqzyioskfd5CJfmWOeQPYholc1KsvaaUJB4i+tPSjqjudo3tCsW4ni+TX7N5CA/KbRVARffYDkhLBZT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765467632; c=relaxed/simple;
	bh=xY1BmqLej6LdL8opPSvDdksuAPvCJXAWVUx/9fU7It4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FIR2ElnbXXDbUBA1HYI3j0a+hGQ75Az7bQxUNrzDqA0g/v2DkEW82RJyUKgR/Z1dgg1O6KW5CWZbX6B3I/xXjpxaY/xnO0sjwBB9TDJYrgPLlocg+hmEkfwJONdGSvnxHq1IXqmrJ7hPdP75GWRXYBlANrBK+cAhOuyrZ7bvM7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=pxykAa6o; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="pxykAa6o"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6496a094ae1so379963a12.2
        for <patches@lists.linux.dev>; Thu, 11 Dec 2025 07:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765467629; x=1766072429; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqPScvJ4WBIuB5P5PUVnKmLK9/PY1poWwXCsEBmV7EQ=;
        b=pxykAa6oIGx2gKecEiROiejsRjxJ40FfQTvaS5O2RmIEmIXQ6HPEdwxCqvwWOZNARt
         TBv6wjwDHe0WmAdeIPuCkR1wJf88YnHf+p3sYlWu4OsGZ5tsBcYk3ZANgKXkXFp6lsgo
         Yj/WrnpaT9kBVZoDi25kdgHh/gd9cHLqavPrSaI00Dnd+TXKOu3aHwifNUGf+MxTenD1
         Vcpodn/PU/cFVi8PRNteuAM61RMbCxOadfJFOOvykPAaBloRCV9FON325NYMFvot/fSG
         PVzY+QfmYaKMEqF/F9GLe50wU34O3n/yVWBIqP3SUPpo7kXI2/Ve2eDtMV3wG7pPYYct
         39tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765467629; x=1766072429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZqPScvJ4WBIuB5P5PUVnKmLK9/PY1poWwXCsEBmV7EQ=;
        b=OqBL73zSzGMhXvjHLbsC0KHSdtYufcpLSwE8J97MY5NIig7BzGRF9Vl9ELYKg7dC5w
         kTER7pCvjUOtBdGV5VlkRsYqn8Rpi/TNCgp5YVp+tEQERbEqhRaPHsmn+onTZ3B4R6Mo
         YLN78t/oXFK4QOnU3ULei4XeDhkPqVuBg5jtBCkA6T60oecFzlHynaJr+3/fJV42/1JJ
         SVLcikxkcNkANriYYDSvKZyouOEVL54WTH0cXmUzlwqQMFbs/hm0/kv5O5Dsn/LKGukr
         KNGKkDBHZDyN/An0LV6HxtIP9eqFg89djG1tH9LpsPPOG5Ne+XQj2GaDR6gRcyed85Qm
         FuFg==
X-Forwarded-Encrypted: i=1; AJvYcCXlJue+cPMsab2kY9W8s0QdJX0+Wir9Q2uk8ia/7egLsMBOuoGMMx4keYwYK9Qv066nhKH+He/P@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6op6TXy4FW8Q3UFq3l4SJX0aij4RdwTQudz74JcIbsM0Fd006
	fgQSbpEVTNxVLcmKhA0BNR86xyzVNPdz5nHHJM3KpF7ONvyNqI66OlAyKJOOJUufnr7XVLM3EV/
	NmA/hoZ1/nqyldOHWLMV3SGQl9sUF+8/WTeIyYpibBg==
X-Gm-Gg: AY/fxX54SWS24bVRLhD0sAjY9hRGrT9PXQbpsamuqlbj5F5Uyses95qMK/KFcSNstEi
	jUYikGCRcGz6dxlm1RDdkrHd9sdPL+7eDGCQmy4ormaarVPt42qvTQUm/0kmDAO1SR0mwcdAD9r
	vWYRDTS70EvDL2jZrtxgJP/OVZi6SuxKbMpGz7T1DFc7yqQkatDbNeNcek1bdRvxMxK1Stlk1Cz
	IsMOze7i9xatWscFf42TuoFg1C51B+Qc81SRFJFPhfcS0ROwYS7cQT5M8ovBe2TekzlDbH+RQQg
	gxc+OgU=
X-Google-Smtp-Source: AGHT+IFFm/09kODYtVj/jT3L/lBrOy6szLxdTZhvxFXifoxdEQMTCf0vVFebHgTlx3wBbXfRlHweSQTfq5fkyItlL8I=
X-Received: by 2002:a17:907:7ea8:b0:b77:1166:7d63 with SMTP id
 a640c23a62f3a-b7ce841c50bmr757021966b.40.1765467628648; Thu, 11 Dec 2025
 07:40:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072947.850479903@linuxfoundation.org> <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>
 <2025121046-satchel-concise-1077@gregkh> <CAG=yYwm0bVzYoccKKcdheGOc-exuxVCPeXSftDixS68qZZ7W7w@mail.gmail.com>
 <aTnET5C2PGiKsW_2@auntie>
In-Reply-To: <aTnET5C2PGiKsW_2@auntie>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Thu, 11 Dec 2025 21:09:51 +0530
X-Gm-Features: AQt7F2pi6TZXr2dGaZGsLTRBYorVi9P5ROwKyX-pAKDthnXiINq9R-1QmXI1fSA
Message-ID: <CAG=yYwnYgw-MYea3yEfwSRiLL+PsKPdQdejotyFTpme0LXc-Pg@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
To: Brett A C Sheffield <bacs@librecast.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 12:35=E2=80=AFAM Brett A C Sheffield <bacs@librecas=
t.net> wrote:
>
> On 2025-12-10 19:13, Jeffrin Thalakkottoor wrote:
> > On Wed, Dec 10, 2025 at 6:17=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Dec 10, 2025 at 04:22:21PM +0530, Jeffrin Thalakkottoor wrote=
:
> > > >  compiled and booted 6.17.12-rc1+
> > > > Version: AMD A4-4000 APU with Radeon(tm) HD Graphics
> > > >
> > > > sudo dmesg -l errr  shows  error
> > > >
> > > > j$sudo dmesg -l err
> > > > [   39.915487] Error: Driver 'pcspkr' is already registered, aborti=
ng...
> > > > $
> > >
> > > Is ths new?  if so, can you bisect?
> >
> > this is new related. Previous stable release err and warn disappeared
> > (i think i changed  .config)
> >
> > can you give me a  step by step tutorial  for git bisect
>
> 1) cd to wherever you have your kernel checked out
>
> 2) `git bisect start`
>
> 3) if you're already on a known-bad commit, then mark it as such:
>
>   `git bisect bad`
>
> 4) Mark the last known good commit as such:
>
>   `git bisect good <commit / tag>`
>
> git bisect will choose a commit to test.
>
> 5) Build, install and boot your kernel as you usually do
>
> 6) Run whatever test you need to determine if the booted kernel is good o=
r bad
> (check dmesg in this case)
>
> 7) Mark the commit as good or bad. Git will choose another commit for you=
.
>
> 8) Goto 5.
>
> `git help bisect` will give you more information.
>
> At the end of the process git will tell you the first bad commit found.  =
You can
> dump the bisection log with:
>
> `git bisect log`
>
> which you can reply here with.
>
> HTH.
>
> Cheers,
>
>
> Brett
Thnaks for the tutorial  :)
1. should i start with the bad commit first ?
2. how to move forward or backward in commits ?
3. what is the point in re-compiling the kernel  if it cannot narrow
down and  test news lines of code







--=20
software engineer
rajagiri school of engineering and technology
