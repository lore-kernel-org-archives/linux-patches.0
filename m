Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76CC5491F
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712938326; cv=none; b=caWhwpF8Kg0CkoQhI3VCa8jkBCd+A3Y0UHTsU7hB0TPxaepwsoRL92LjwgSynbvz45AwKI947n8O75CneUMhtd4ttqC10Va5iGrk4nUvUdrr2V//QSTVF/6rFC2Cdl3Z4jvxh9uivpEkZ8Fn6K6Oytu27YYpwSJX0Dr5QOTLHuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712938326; c=relaxed/simple;
	bh=CyDf6s1oBPX3vBBot9QW9Bfdy/AMFlPJrHMpAv8DVOU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eWt0kJYxEACNE8p9d0sraSI5yfui6jIw54yvFp5O5ZnMwqu9lfJgGvHg/TJgihmM2q8zVB55u8TVFUD2LIkgv3p78XLF3TDXCn260bMUKoMWiD/bWZi7MP/R1t2SmY2i6HCwAHT+wCk6Daep6TFX+LNWpsTdprGPOsmB1NRVBhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v/2qyScQ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v/2qyScQ"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56fe56d4d9cso15658a12.1
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 09:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712938323; x=1713543123; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5JT8K7AvdRwgx51et4e9LWrdmVm7FiW3UD4VOlrp94=;
        b=v/2qyScQpIx602VW77G/nUKG6hLG9SzOxZq7XfkM4WYAfP8kAbyiugFi31vNvt0NvK
         WUUBBtPx/BKlRvVfTB3jhJ3GszD/f9p6XowuEKdj49irSQ/jslWTnduPHal9PQsSDcxu
         OJdwjhcljG+PG6eRzIpB47uBxzk3bjz2VjTrbP4AUmo5ZhZqaWpaNB0TDkB0JHBf+A8s
         2D8KSYnBIpmj7q1c4B0S4OMjitJzrLHOC0abYezuiR5pMmzzlobsIYz6cXEMnLMbDoKM
         EH87fQc5VQIUieL0oWj42N6VfDcp114+HRRmwOV8bAwsyVr871+Oj2GbjV0stgDoucTM
         KCKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712938323; x=1713543123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5JT8K7AvdRwgx51et4e9LWrdmVm7FiW3UD4VOlrp94=;
        b=wX/L3njGbNrv2NMw8I1tCDOrK4qAoOIFGiJua7k2AVHNubPriaprdKJdFicBMws6gn
         Hao7I9sZcX2W3LW58VkbKtbYOy5GRC4orAfipV+eEpEZwqYyEVLHqs5Biuh+oUiaXFQM
         uRB6eKuTKtpWmhY/eTYOT1Gf3TjfdcRiR19pGk25tNU5AclahxjpfQfONLWpfqh1ZVft
         a/9mEcXCBGWd9Wy28l1NNC90kYF9kDDWh48S7PXkZMz5WBFRZC+5vlVJHL8AgKKA+3aT
         H0FBcMbGvMO1pHoHx7NmPMXx2fWa+07lswfPMFdzFfKxwnqZrag4kXXyrqXe1fGI0/b3
         4YbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVj9oUnNXCINn2jBuh/Q2Etz00snBdk/onRnFqmDXO7nMdEhUNZr2HNCDOs27sITuF5ron1ElnQj72FzS1XYwllUEv0FYtddg==
X-Gm-Message-State: AOJu0YznyIoJnc/+CbLYcRMO3+ivpgN13N+bZxZXu2yY66uFUj1uJUo8
	fVZ52pWhfSOj7L1kHv+Kg9c+ysPUZ0PbAecAjy4D2bqIlhhX5ToWEDalsK5DF78lOO/NZSCKFWX
	peF6nCtVnXrf005njk2SltgZ+A5VxDhG7dTA=
X-Google-Smtp-Source: AGHT+IHRBVk7zH7YF+KtpjONjNtA7XUyVLa+CfCQyQPDJV89nxPfsVYooQGyNelh6x30YUHFeLeDGJ02K9QJnqgTZ9o=
X-Received: by 2002:a50:ccda:0:b0:570:99f:6c2e with SMTP id
 b26-20020a50ccda000000b00570099f6c2emr45146edj.1.1712938322737; Fri, 12 Apr
 2024 09:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411-mark-kselftest-exit-funcs-noreturn-v1-1-b027c948f586@kernel.org>
 <CAGG=3QUNPGtQ7OqzEtNW9BQET+a+1WW=h++CqRTHRY=YLrOAcw@mail.gmail.com>
In-Reply-To: <CAGG=3QUNPGtQ7OqzEtNW9BQET+a+1WW=h++CqRTHRY=YLrOAcw@mail.gmail.com>
From: Bill Wendling <morbo@google.com>
Date: Fri, 12 Apr 2024 09:11:46 -0700
Message-ID: <CAGG=3QXzs0VdaQjNtGD6aKEPXCy1dGQ06BSKww_HutB-x7BuMQ@mail.gmail.com>
Subject: Re: [PATCH] kselftest: Mark functions that unconditionally call
 exit() as __noreturn
To: Nathan Chancellor <nathan@kernel.org>
Cc: tglx@linutronix.de, shuah@kernel.org, oleg@redhat.com, 
	anna-maria@linutronix.de, frederic@kernel.org, ndesaulniers@google.com, 
	justinstitt@google.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	John Stultz <jstultz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2024 at 9:08=E2=80=AFAM Bill Wendling <morbo@google.com> wr=
ote:
>
> On Thu, Apr 11, 2024 at 11:45=E2=80=AFAM Nathan Chancellor <nathan@kernel=
.org> wrote:
> >
> > After commit 6d029c25b71f ("selftests/timers/posix_timers: Reimplement
> > check_timer_distribution()"), clang warns:
> >
> >   tools/testing/selftests/timers/../kselftest.h:398:6: warning: variabl=
e 'major' is used uninitialized whenever '||' condition is true [-Wsometime=
s-uninitialized]
> >     398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &m=
ajor, &minor) !=3D 2)
> >         |             ^~~~~~~~~~~~
> >   tools/testing/selftests/timers/../kselftest.h:401:9: note: uninitiali=
zed use occurs here
> >     401 |         return major > min_major || (major =3D=3D min_major &=
& minor >=3D min_minor);
> >         |                ^~~~~
> >   tools/testing/selftests/timers/../kselftest.h:398:6: note: remove the=
 '||' if its condition is always false
> >     398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &m=
ajor, &minor) !=3D 2)
> >         |             ^~~~~~~~~~~~~~~
> >   tools/testing/selftests/timers/../kselftest.h:395:20: note: initializ=
e the variable 'major' to silence this warning
> >     395 |         unsigned int major, minor;
> >         |                           ^
> >         |                            =3D 0
> >
> > This is a false positive because if uname() fails, ksft_exit_fail_msg()
> > will be called, which unconditionally calls exit(), a noreturn function=
.
> > However, clang does not know that ksft_exit_fail_msg() will call exit()
> > at the point in the pipeline that the warning is emitted because
> > inlining has not occurred, so it assumes control flow will resume
> > normally after ksft_exit_fail_msg() is called.
> >
> > Make it clear to clang that all of the functions that call exit()
> > unconditionally in kselftest.h are noreturn transitively by marking the=
m
> > explicitly with '__attribute__((__noreturn__))', which clears up the
> > warning above and any future warnings that may appear for the same
> > reason.
> >
> > Fixes: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_=
timer_distribution()")
> > Reported-by: John Stultz <jstultz@google.com>
> > Closes: https://lore.kernel.org/all/20240410232637.4135564-2-jstultz@go=
ogle.com/
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > I have based this change on timers/urgent, as the commit that introduce=
s
> > this particular warning is there and it is marked for stable, even
> > though this appears to be a generic kselftest issue. I think it makes
> > the most sense for this change to go via timers/urgent with Shuah's ack=
.
> > While __noreturn with a return type other than 'void' does not make muc=
h
> > sense semantically, there are many places that these functions are used
> > as the return value for other functions such as main(), so I did not
> > change the return type of these functions from 'int' to 'void' to
> > minimize the necessary changes for a backport (it is an existing issue
> > anyways).
> >
> > I see there is another instance of this problem that will need to be
> > addressed in -next, introduced by commit f07041728422 ("selftests: add
> > ksft_exit_fail_perror()").
> > ---
> >  tools/testing/selftests/kselftest.h | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selfte=
sts/kselftest.h
> > index 973b18e156b2..0591974b57e0 100644
> > --- a/tools/testing/selftests/kselftest.h
> > +++ b/tools/testing/selftests/kselftest.h
> > @@ -80,6 +80,9 @@
> >  #define KSFT_XPASS 3
> >  #define KSFT_SKIP  4
> >
> > +#ifndef __noreturn
> > +#define __noreturn       __attribute__((__noreturn__))
> > +#endif
> >  #define __printf(a, b)   __attribute__((format(printf, a, b)))
> >
> >  /* counters */
> > @@ -300,13 +303,13 @@ void ksft_test_result_code(int exit_code, const c=
har *test_name,
> >         va_end(args);
> >  }
> >
> > -static inline int ksft_exit_pass(void)
> > +static inline __noreturn int ksft_exit_pass(void)
>
> Orthogonal to this fix, but why does a "no return" function have a
> non-void return type?
>
Oops...That's been asked. Sorry for the extra message.

-bw
