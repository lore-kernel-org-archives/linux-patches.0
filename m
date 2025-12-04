Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0F7346E68
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 16:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764866509; cv=none; b=lI2sOz9hj+xUUo6GZRKS2TEimvC0TimRa1nomQjJArm1m0UCqRt8X+cZo/EC2ogZcSMjxQaqjwF46FVLV9X47PUxLoqeyyUoHVFH6rW7fE9PUYyvvjFQYzesnu8tYxG7tnwT3vo01FtpYi/j0jR3WayWySJ0d/L9Jg8dJZXgZuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764866509; c=relaxed/simple;
	bh=YB1C7DkMSinNdnzH7I3t3ZAHZwfsDDhhtbZkbhvfSNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CNdD8VUwK0pQ8xa65skha02YsxQ+/uWCpgJNUn/zH5tIKLxH9hVE8mFgv6kRjE9uy0k002VY9NzM7hWtb66zQT2lf2kZB6bctcWOQ4Ow/F+bGyPLEQMKddOKWiZvp2Rpk7jDAr496P3s21MqqMgzipIf14HJ1AFgY5Ma0JWjU0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uQn7eArV; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uQn7eArV"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-297e13bf404so246405ad.0
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 08:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764866507; x=1765471307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjuSnkBD0IVIOLRTQnrL0682xix69tJWGGO5uidnVxE=;
        b=uQn7eArV/8xemleGX8rwxyLlP20aWScy9ljWyqLvSEIBwPNJFuUcJvJF28Xq4hQdLw
         aaO2XSwBHQhpvaHurvbSP6VkMnqyt1mu5zYI1NeTwU5K2qaYX4Fezx8kPCVEnAnp7sNU
         ZCDcxxtos6YLjsDKlRM8Dphb09WGbBuPKdM9ij1lNWQBfDQS19RjYwX8wzJHVj1vqSzl
         4Zk0GooFAAWeTK2YiLDx4XUYYEtC2+guiOyHRtEciE+bELRsQ9nB5S6d3xsjBbHaQgrB
         o3TPgFbBxRXkf+9os6QPM/eSkoULFk8cCzwRrrxtgqYdXDlnQzkmNkW2BA0OANuorQrj
         ct7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764866507; x=1765471307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EjuSnkBD0IVIOLRTQnrL0682xix69tJWGGO5uidnVxE=;
        b=R3wKQsHhYHV56e/SGG98Jv1RIdUtiEy1YDgH6zuM+fGtha1YDFY00t1bKg20LFy7XQ
         x9lTW5fd5rtgCeTbyDI6jkNf/PZ21Dskfl0S7XaHHMjpePv9O48Ni+jompRT82+GbLcT
         f6IBqOBbeU5BNzzU8QxhtWKpkYRqbmHgYTPe3uOuTOBD1zDWdJqB96v9EY5qERhSo4/D
         Qp0/WwmORDzKnLbOeL5Y0MyLNxtFZexq4TmTOT/1QKjxcmG9QUFeYHAJKlgZWyVId7DN
         +925heCskHlz8RVqS3212SHkBqiDS3+bFSk8bWdsMo/3dGMY9AIeBp6JB+Aq3zCXmg4/
         iuVg==
X-Forwarded-Encrypted: i=1; AJvYcCXjA0gpViHeDj4ja3he/j/aJsLSNlAJaWOzlcBPN55TmwTRxk8UNUMRiOr047zGDuRqoJGnIer8@lists.linux.dev
X-Gm-Message-State: AOJu0YyE0TqWnWJR8+oQMTYocYQGaYIl/g1ezZEHtBveCMr4asElM3CT
	KU7F4qJM23Z4Te/kulD5m/PWw9u2r7xvlJbWjPgqpw/dp7Orbd+jhcZLp6q5bWzKqaoL4xGqq1e
	0msoWQurS1maGrN5sf2m0fMblG1vQtf+dhFKrybkDvyyArssKmtI/7x0z
X-Gm-Gg: ASbGncvdDOVYdAqmUr/MCrCv7YwbZLjwwAD7elZ8eSz0lLXDrVR+vBrBTvUwcoOjuT5
	ZnWl14J0Cqyd9wWVfmXCzD+O/a3iJRJIkqHd5NCPzL4jsCvCnN0PIcHNV5IB0uX8rnJNA4yk55q
	XRTtosgwVZCliZ9xir7OWgZGypLPAhDQcqW/WOCmUHq1o2tEPSg9jSD2hA5f7qIVg+2bNGOKasj
	djurL7JkdL7ObZKvPCiHjg9gOv9eFQtbtGsQeEkL8hIIku/5DbJ74j6/8wZ3DdIG2x1EhpMvPW1
	X6HyIH8sxpQOXMEvPUwcLK7Wrg==
X-Google-Smtp-Source: AGHT+IGB4VDrYuoPAUMN4jdtPF4MsiTB+YfIIGTM7FDzOCTr5PbhMfbfHwGSSFWdn7xBIbJUGur0zLxxwwAbeW3miIM=
X-Received: by 2002:a17:903:18d:b0:299:c367:9e02 with SMTP id
 d9443c01a7336-29dbf0d1cf3mr662555ad.17.1764866506966; Thu, 04 Dec 2025
 08:41:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152414.082328008@linuxfoundation.org> <41e4124d-8cb3-44b9-871b-8fa64b54b303@sirena.org.uk>
 <b4d4d33e-07d8-4868-abc5-4161a63bb948@gmail.com> <2025120440-evaporate-crawlers-ac2a@gregkh>
In-Reply-To: <2025120440-evaporate-crawlers-ac2a@gregkh>
From: Ian Rogers <irogers@google.com>
Date: Thu, 4 Dec 2025 08:41:35 -0800
X-Gm-Features: AWmQ_bk-K1qeRoUMPQSlwjJdae7gffM_FzBGnzxiSDL13KhmyHwTUpQOp0fU0SU
Message-ID: <CAP-5=fWpMfGHina4t_=wSTRX2V1i1zCyv2dRqve8nYLugsj2Gw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, achill@achill.org, 
	sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 8:38=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 03, 2025 at 10:51:17AM -0800, Florian Fainelli wrote:
> > On 12/3/25 10:46, Mark Brown wrote:
> > > On Wed, Dec 03, 2025 at 04:22:30PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.197 relea=
se.
> > > > There are 392 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > >
> > > I'm seeing a build failure in the KVM selftests on arm64 with this, d=
ue
> > > to dddac591bc98 (tools bitmap: Add missing asm-generic/bitsperlong.h
> > > include):
> > >
> > > aarch64-linux-gnu-gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -=
g -std=3Dgnu9
> > > 9 -fno-stack-protector -fno-PIE -I../../../../tools/include -I../../.=
./../tools/
> > > arch/arm64/include -I../../../../usr/include/ -Iinclude -I. -Iinclude=
/aarch64 -I
> > > ..   -pthread  -no-pie    dirty_log_perf_test.c /build/stage/build-wo=
rk/kselftes
> > > t/kvm/libkvm.a  -o /build/stage/build-work/kselftest/kvm/dirty_log_pe=
rf_test
> > > In file included from ../../../../tools/include/linux/bitmap.h:6,
> > >                   from dirty_log_perf_test.c:15:
> > > ../../../../tools/include/asm-generic/bitsperlong.h:14:2: error: #err=
or Inconsis
> > > tent word size. Check asm/bitsperlong.h
> > >     14 | #error Inconsistent word size. Check asm/bitsperlong.h
> > >        |  ^~~~~
> > > In file included from ../../../../usr/include/asm-generic/int-ll64.h:=
12,
> > >                   from ../../../../usr/include/asm-generic/types.h:7,
> > >                   from ../../../../usr/include/asm/types.h:1,
> > >                   from ../../../../tools/include/linux/bitops.h:5,
> > >                   from ../../../../tools/include/linux/bitmap.h:8:
> > > ../../../../usr/include/asm/bitsperlong.h:20:9: warning: "__BITS_PER_=
LONG" redefined
> > >     20 | #define __BITS_PER_LONG 64
> > >        |         ^~~~~~~~~~~~~~~
> > > In file included from ../../../../tools/include/asm-generic/bitsperlo=
ng.h:5:
> > > ../../../../tools/include/uapi/asm-generic/bitsperlong.h:12:9: note: =
this is the location of the previous definition
> > >     12 | #define __BITS_PER_LONG 32
> > >        |         ^~~~~~~~~~~~~~~
> >
> > Yes this also affects building "perf".
>
> Now dropped, thanks.

Thanks, fwiw I agree dropping is the right fix.

Ian

> greg k-h
>
