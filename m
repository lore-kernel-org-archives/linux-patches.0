Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673933271F5
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765474649; cv=none; b=Nk/ES/qDlMHumkPOJuBerf0RDWLs9PBllaj3d+SCqCVQ4B+FDgsHtUk/arhwyrFqGLbdcvB/ZxOZuRsFNqFklN96MqNsP6LMT5CxAwFdEqHOt7viUVUYJxF39EThF67Q+Tef7Es+pv/nsFnpkcXJreLwM1ExGpnma2Lefsf8Uaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765474649; c=relaxed/simple;
	bh=o17sRyxm7UIDmprl4aZGfoSnq3QhFyWV1enFXSD4gps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xn2os7OF45m/sUNEj25STi8YbUpM6kIjJUnEhx9dwVh0OOVR63+ZLWYnGdsf7B7Sld+Ym5os8xPqJq8K6qVXaDN522zPQV4hFfdVNwumcuasdrpt0rlC3HN0K90JeYofxWEuAtek9TZDgddBHw/W5N4vADJ8CZMELYRswo9KSSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=jXunKdqQ; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="jXunKdqQ"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b736d883ac4so69357866b.2
        for <patches@lists.linux.dev>; Thu, 11 Dec 2025 09:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765474646; x=1766079446; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1yff4bc0T45kril10BQxgoSw39c1NrtcFM6PjLf2Ls=;
        b=jXunKdqQkYvl72EWntXguW0hWvaqIm1Qlly5DWnv3C+auQMH3PZ7KI7CuL+E4aV/EK
         0Nk6ualcbojaIhKKOC2GPXgK2802VRBxrhNTdsIxunmk4CTj8sTkXrV7bzfyav5fn0hu
         K/BVO2dca1p2lpja5z7kZub02n3UXzPDkL3/moEjGB6WESAHLP8qWWmAZYne/EFLcAB0
         E0oBmNVDgH03i1s2GHVn4nIUmXbya45AhW3roMaugUZAYT6znx6f2gF1eaPWwdIKdBe+
         4sV3I/ZU+/Bu0CPvlzOlDL3oq7sTyeN41gBxTn3rdL+r4n5rp4pm5YiXukCrPm/Ofj7S
         sMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765474646; x=1766079446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E1yff4bc0T45kril10BQxgoSw39c1NrtcFM6PjLf2Ls=;
        b=FpP3Qo7MiM+xLOfZyVxBfgwhNUGEmtkE/WSXgTa4Lf1jWl2pycymOACN3LCQWfyGy6
         H1zF3Dl99oRlK+DqR08BK3NNGX1BbntsbUGuSWyd7HpzOobP+NUrZHKnoK0Nj/MgOeaV
         XhSqaDpBQgfHUm4dWtht4pnBc0w8/0cK3Cueyh7SIRC9I4j8uhjCQI3UqLBhvPemUb8F
         XSNBcB/mdR5dW+2JZlFpNmFltReYHtjqJrBU+kSkgUy9RbaiKcfrPJ33ZuzPYyy2MC25
         /6metzFeuzbdTA/hMo2gIr767dppFbH/fA/0aTTi0KQq9QJtQXBa5PEXQhyMaEy4PQyI
         2BMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDgMor3A1VqyuNjyKn5vBUXlLlt1agVUFNEW78kjOcgJwhPgt0pES+8MpdkAX/+JdIkXMO2n5s@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5fmTHqATSQs0F8t4o3wUAp4oPQz6O/ClsoYxU3f+6dlUTxbV8
	Pc+WY44F3yko3BIGjild1G+9xyvryqPF9KF7mPUplth18SUBFyejmDL+YYw1UuzFEtVxYxRJcw8
	n5jTXkbokuT6n8b0kkpr7MYvG6fKvI+fHr2CRMFZEyw==
X-Gm-Gg: AY/fxX4Un0xr5upyh2UGmIF25h4ReO4AWJEbPUIINjFRlaW45S/XC2v9kfH2/ymaYHJ
	xupBjoUqNVOVL7BnqWu+bnvE081WkOXZ5Eb5lxE9yaditcGySxkAIFJOQU+v22ILnpXboDs6Kfr
	PhjAQ0cPoC5y87lFIZkLpdx6aW74RqPitzn1THlzP5SlMV4kiFBmTWDhfnBDJ0GQw97Qm6VW8Dy
	jAipfVLBB03yWXNG3nag09eBYGX3xAMtgzJ77ah3hcXh+ao+alTKr9YQhz3h34qbyDAvW+Z
X-Google-Smtp-Source: AGHT+IHmdQwa8POPlNPzaUDlA7ppJ6M8JtOU+WZGPZOtTvMBOBTTwYlrmIuWhcAfLkYTxf70odorGU+gj0Q9+QZGFl4=
X-Received: by 2002:a17:906:6a09:b0:b7a:1be3:a582 with SMTP id
 a640c23a62f3a-b7ce84d135bmr722249266b.63.1765474645609; Thu, 11 Dec 2025
 09:37:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072947.850479903@linuxfoundation.org> <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>
 <2025121046-satchel-concise-1077@gregkh> <CAG=yYwm0bVzYoccKKcdheGOc-exuxVCPeXSftDixS68qZZ7W7w@mail.gmail.com>
 <aTnET5C2PGiKsW_2@auntie> <CAG=yYwnYgw-MYea3yEfwSRiLL+PsKPdQdejotyFTpme0LXc-Pg@mail.gmail.com>
 <aTr0NpEHWSCrGNTS@auntie>
In-Reply-To: <aTr0NpEHWSCrGNTS@auntie>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Thu, 11 Dec 2025 23:06:48 +0530
X-Gm-Features: AQt7F2req17RppecxU0d8GIiJFE8Wcg_BugBfal6e-qcSTyFvfx5VN8m8i6sM7w
Message-ID: <CAG=yYwmqMSV7xQrL_Nrx06QO_f_61MigB-2eL1kiDO4Mt=4uew@mail.gmail.com>
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

On Thu, Dec 11, 2025 at 10:11=E2=80=AFPM Brett A C Sheffield <bacs@librecas=
t.net> wrote:
>
> On 2025-12-11 21:09, Jeffrin Thalakkottoor wrote:
> > On Thu, Dec 11, 2025 at 12:35=E2=80=AFAM Brett A C Sheffield <bacs@libr=
ecast.net> wrote:
> > >
> > > On 2025-12-10 19:13, Jeffrin Thalakkottoor wrote:
> > > > On Wed, Dec 10, 2025 at 6:17=E2=80=AFPM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Wed, Dec 10, 2025 at 04:22:21PM +0530, Jeffrin Thalakkottoor w=
rote:
> > > > > >  compiled and booted 6.17.12-rc1+
> > > > > > Version: AMD A4-4000 APU with Radeon(tm) HD Graphics
> > > > > >
> > > > > > sudo dmesg -l errr  shows  error
> > > > > >
> > > > > > j$sudo dmesg -l err
> > > > > > [   39.915487] Error: Driver 'pcspkr' is already registered, ab=
orting...
> > > > > > $
> > > > >
> > > > > Is ths new?  if so, can you bisect?
> > > >
> > > > this is new related. Previous stable release err and warn disappear=
ed
> > > > (i think i changed  .config)
> > > >
> > > > can you give me a  step by step tutorial  for git bisect
> > >
> > > 1) cd to wherever you have your kernel checked out
> > >
> > > 2) `git bisect start`
> > >
> > > 3) if you're already on a known-bad commit, then mark it as such:
> > >
> > >   `git bisect bad`
> > >
> > > 4) Mark the last known good commit as such:
> > >
> > >   `git bisect good <commit / tag>`
> > >
> > > git bisect will choose a commit to test.
> > >
> > > 5) Build, install and boot your kernel as you usually do
> > >
> > > 6) Run whatever test you need to determine if the booted kernel is go=
od or bad
> > > (check dmesg in this case)
> > >
> > > 7) Mark the commit as good or bad. Git will choose another commit for=
 you.
> > >
> > > 8) Goto 5.
> > >
> > > `git help bisect` will give you more information.
> > >
> > > At the end of the process git will tell you the first bad commit foun=
d.  You can
> > > dump the bisection log with:
> > >
> > > `git bisect log`
> > >
> > > which you can reply here with.
> > >
> > > HTH.
> > >
> > > Cheers,
> > >
> > >
> > > Brett
> > Thnaks for the tutorial  :)
> > 1. should i start with the bad commit first ?
>
> You start by marking one good (past) commit and one bad commit. It doesn'=
t
> matter what order.
>
> You have at least one "bad" commit you know of: 4112049d7836ad4233321c3d2=
b6853db1627c49c
>
> This is the 6.12.62-rc1 commit that you reported had the error.
>
> So, in your kernel worktree:
>
> `git bisect start`
> `git bisect bad 4112049d7836ad4233321c3d2b6853db1627c49c`
>
> Now we need to tell git bisect the most recent "good" commit we know of (=
where
> the error didn't occur).
>
> If you already know the commit or tag of a previous version where you did=
 not get the
> error, mark that as good. If not, pick a previous release, check it out, =
and go
> to step 5.
>
> > 2. how to move forward or backward in commits ?
>
> git bisect will do that for you as soon as you mark a good and bad commit=
. If
> you want to manually test a specific commit, just `git checkout <ref>` as=
 usual, and
> continue at step 5 in the instructions I gave you.
>
> > 3. what is the point in re-compiling the kernel  if it cannot narrow
> > down and  test news lines of code
>
> We're narrowing down the error to a specific kernel commit. Once we know =
which
> specific commit introduced the error, we can look at the lines changed an=
d try
> to understand why.  We need your help to find that commit, because it's
> happening on your system.
>
> Please do read `git help bisect` (man 1 git-bisect). It explains all this=
 better
> than I can.
>
> Thanks for testing and good luck!
>
>
> Brett
>

I do not see that error anymore. may be  i have made changes in configurati=
on.
THANKS



--
software engineer
rajagiri school of engineering and technology
