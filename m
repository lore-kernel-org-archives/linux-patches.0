Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A90C2773F
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765473155; cv=none; b=C3IyWxck+HVEt1tvc/9IzMizyUVk0M3ls3SvgUrDapbn0N8sPuWIL0EsN76AtxC2S1+8ISFD/nTgghomU4MTNpJ3SEiVJgg7PIeviwul/L+4jC9jjDoSnvox4V6+1/+PZ/wZ4IbReLu2V7Sfy+CHv7XEx4M2DvpdE3NTQO49s78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765473155; c=relaxed/simple;
	bh=LCBArnabRQFMZVjlBsPXwG8CAa4MoJfM1+Gbv0GxRhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VBM/ajtSOo/soMlupi1Uku8mzj8BdvhfETcBlzMsp7m433STlrN5vYZTVP0fXeobbaQ2GSRTvBJQePQVCjOqvK07racb+879cn8YbAqkdwb7J+s7Va3x5NqTvKiMr20UYg/l1hChfl+6yxsh95dpan4k+xpRz5CkEi6LcX8Iwns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=TSOfUMDs; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="TSOfUMDs"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b7a72874af1so56477666b.3
        for <patches@lists.linux.dev>; Thu, 11 Dec 2025 09:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1765473152; x=1766077952; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YluR+HMy8tJ6YWi/6IjZPi5ROhpB0HU8qs5yyDUOcKk=;
        b=TSOfUMDsjDVDykWZHloPNHAs+vx3CPnPE3V/rA9VO/QP75F8FiK0ULzqct4lWi60+u
         b8/4ABaEEAIPt0Vm6kU0jNeEVE3h7+UKCeA0Mzw754PNyVjqm7WKCnFKyDphKYTeE0iQ
         oipE225hU3WvEr4a4yEvRtryuIKbsQ2iGWwgfhL7hYgRDLktB9H51eHVwpCMvqbZG51g
         K3Ugt+O77gw8bAncH7rMe4ID7L1iiGGO3MqDdHZBVTL+W/SrGhP9+JdzByBMwClJFbIi
         wlpCul5EPNp7c7SdNPXLVj434xc4Ssf7XTm9QS9jMP2YYV+4m5FgChIJlBwpXAog5kri
         oJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765473152; x=1766077952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YluR+HMy8tJ6YWi/6IjZPi5ROhpB0HU8qs5yyDUOcKk=;
        b=Anpu52Do/Tcpmrm34GtNZUmxgCfh09gTXGGAPKUZg4vTcs/mdTdDXhu25FG3cUhdFF
         VcejSFBCBHoaT3Vcf6y665WkQJPZ3kVbXW17SaSytHd3+UAl5o7YS6bHHWqYCnEh3Cra
         TBjZN/3LZkSo1Tm+KFyFHjRzABusSXgc5cDcbl9Q9oQteh7ho7/XtTQFQ4U63yC/9gB0
         KjSS/I8hl87HQFb8cpqWb+OxCt0bEHXdA/253Sk5Ucc1HXaSR9rDH8mNpjc+Si6/DBDF
         O9qM61If9Nkz3wYbcqS4RWQzXPrejSuKzeWGiws/AfxAp+7iKV2nD3+IOyx4FkleXCYj
         K6HQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4VMiTKd93vNSQ3jwVFm35+EqGmcRXd/cWjXWvBKzfD+b4xRTk7UFV5wym7RL85fHw75iTydBN@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1gWL1YPhqRhb+S+o3jHAFKjCkXwTsTi7Dd84mMrGEArteA6/z
	vPfeySKnWFPfj/s3nMnqE9z505R/YMji3NKBjPBGo6bzluYQS/EhgyCy5dXQ3RQNm71pt20aBcR
	i0yvUP+5Y/8+wnnPWuaFkqtIZQutYDujFbsXVHpd2nw==
X-Gm-Gg: AY/fxX6idULjakJK1GGG1YZXW3xWgyLO8KR9lfAouLFTYmITshhc+/B6h2AHlfy4Rjb
	XOPboZ7heXQtOQuOzA/aBxz4+3UBYiFzoT7qbdjCTphircYWyzJffV9yomRi1rfy6KuvHQIJlbJ
	F8FLZzpf6KE84zti4FAea6OdsP6SXUL7Tcro1XgdVkys1CBOpd1pq8kSJLQHZjFP1vYKgzBs4aR
	A/yOygkueKqknvKLMyE/2S9fccMKrWxxZV7SP5ujenN+s0PYAzNydZRdhx+u2/x/k8W85ZX
X-Google-Smtp-Source: AGHT+IHxujA97LFKbJtJbuGheZkwmUxCCwGNJTvfmx+MVC6q9VIKG4ivl+R79GTx2IchlThH9PpjBCAb5t2jcFPjKRc=
X-Received: by 2002:a17:907:3e11:b0:b6d:3fc9:e60c with SMTP id
 a640c23a62f3a-b7ce8348a1cmr847912766b.20.1765473151939; Thu, 11 Dec 2025
 09:12:31 -0800 (PST)
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
Date: Thu, 11 Dec 2025 22:41:54 +0530
X-Gm-Features: AQt7F2oxX7qofuTdMKfB-KdQYtphHJCDKdH8cG92r0Z36jIIutp4FudW9w5kxD8
Message-ID: <CAG=yYwmoUfdV1yR5j6Q6pmENagwFWpP9nn2FX-QKnrgUepHyTg@mail.gmail.com>
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
Now i  have a much clearer vision. Thanks a  ton  !




--=20
software engineer
rajagiri school of engineering and technology
