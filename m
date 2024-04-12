Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E3F149E01
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712938122; cv=none; b=ADlM5+HgEIXt7E1eL8fxIgOumH5zhcrv0OZQkpUsGm/+XpMBRsZeVRgQnMOA4HLp7q96jgwwNIAS77du2ml/5JBiD2Oazv1YHP1IV4tXNa72KwUJYgxcZRi6UfgC0GB2UMxtSIgwEm/uGSUCICY7J3NXZDdHFehi6H4a8qFv944=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712938122; c=relaxed/simple;
	bh=aZ/P73mUhmx64gcqfpqiqbfDua3KGlA/ZWvGXvrP2Qw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqhfieFyFuGYFYdmriKTzDif14Ul5HC/f+SZg8V1rSNr01uVk1ls2t4pMMeurozroZ6ayhb4CNFpEaWbc36KSH+osuWNhvU2CC17csX5sLUF3oGjD1jf4bElVuI5fJgqog/QvGSpDsuvFNrzr3M7U0lEasiC7dgxf17CmZrQ88c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nQbqAosc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nQbqAosc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-417e326fceaso79435e9.0
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 09:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712938119; x=1713542919; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FNYirPwNVr+GTWxU7VfrVwFiMeqJyrofCKy1YE+ANNY=;
        b=nQbqAoscIXyKCINetr9k3/gugpdqUdG6sPd1KDxNNMW2TOolC+LJRbXl1vJS3lD78Z
         qEuiewTU8myci2uhJ/M2nzmLI9Ya9wR1MAOEcRkVaL4gMNuHk27JaEzclUQJXy0Jltt8
         b64da7j4myBDG23dj1+2r6ohEAWT13CjnNwSG43g1mYXjspOnUYTNjbTf/NokvACbUdu
         OBF6DVTG9p2LlBkmM7UaO1UIc4LREPYzU98P1KFMoJ03BLOdevh6B1TJbgs5vAoXhx79
         yUCIQsF5vVp2bEVz12Ydq0lvsLb5kF2j1jFbAEFbT3y2IbR33BpvRn/GwBiHL6XLUfST
         iEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712938119; x=1713542919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FNYirPwNVr+GTWxU7VfrVwFiMeqJyrofCKy1YE+ANNY=;
        b=GTfnJjorBFvlTRD+OPLLf2OPwe1VANg7VxTJyqNkhi00lv8+RQzDqWTGJZje73V6nz
         p0/rdsMsZniNhhec8MWKKQRXLhkKvLrts1jUbeudnUgoNLTQCwuOVJlEl0oqk0KocFRJ
         YhfsYuym571OTB4jnISWdk1So4DLzXzH+Ybik2kXYT6MEfpJdHr91tc785tp8P1aXFck
         fW3WxMzE5um2ON15VydAGR5hqZfmA/70RqirhZo92D6qj4dsrBjqYzcI9S3ZkE3EtelD
         55qVTtZ86hITj5A+Gx/LCWVnuUgcJMd1G6sUosLqYG7vHon+Xdzu9Ataw8xk3jWhXj/V
         sT5w==
X-Forwarded-Encrypted: i=1; AJvYcCW8tEor7k4Tt9HTXq8vUENcmADtQRupmEQSDG9sq/FuWtIbneBZfwle164d1O34hiC+dYkIdJ8yoN6essa9rRkuMnEAynaumg==
X-Gm-Message-State: AOJu0Yzjhig26ow9XyetXWZTVGtknsKC2X380tiyRAqL0XhLU/1VCVon
	OZ6B1vRXtO2bw9kgrv0ItithRbarzpFWyOnVZT5qTu//r42acwXR7z81wlQGem77kILjKQEy67S
	as1t60AxxxVF+3q1zy7R7mYziHq/HF5LW0s0=
X-Google-Smtp-Source: AGHT+IFVDRZZizAvAAJdzt4RivJzgfJ0OODeVjij/yWDYakPFhhDIwnAAwlI5ZQ7ZkMZMDlD2eoOIKw5yvDXbHLUd5c=
X-Received: by 2002:a05:600c:19c9:b0:416:3014:63f8 with SMTP id
 u9-20020a05600c19c900b00416301463f8mr222985wmq.0.1712938118606; Fri, 12 Apr
 2024 09:08:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411-mark-kselftest-exit-funcs-noreturn-v1-1-b027c948f586@kernel.org>
In-Reply-To: <20240411-mark-kselftest-exit-funcs-noreturn-v1-1-b027c948f586@kernel.org>
From: Bill Wendling <morbo@google.com>
Date: Fri, 12 Apr 2024 09:08:20 -0700
Message-ID: <CAGG=3QUNPGtQ7OqzEtNW9BQET+a+1WW=h++CqRTHRY=YLrOAcw@mail.gmail.com>
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

On Thu, Apr 11, 2024 at 11:45=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> After commit 6d029c25b71f ("selftests/timers/posix_timers: Reimplement
> check_timer_distribution()"), clang warns:
>
>   tools/testing/selftests/timers/../kselftest.h:398:6: warning: variable =
'major' is used uninitialized whenever '||' condition is true [-Wsometimes-=
uninitialized]
>     398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &maj=
or, &minor) !=3D 2)
>         |             ^~~~~~~~~~~~
>   tools/testing/selftests/timers/../kselftest.h:401:9: note: uninitialize=
d use occurs here
>     401 |         return major > min_major || (major =3D=3D min_major && =
minor >=3D min_minor);
>         |                ^~~~~
>   tools/testing/selftests/timers/../kselftest.h:398:6: note: remove the '=
||' if its condition is always false
>     398 |         if (uname(&info) || sscanf(info.release, "%u.%u.", &maj=
or, &minor) !=3D 2)
>         |             ^~~~~~~~~~~~~~~
>   tools/testing/selftests/timers/../kselftest.h:395:20: note: initialize =
the variable 'major' to silence this warning
>     395 |         unsigned int major, minor;
>         |                           ^
>         |                            =3D 0
>
> This is a false positive because if uname() fails, ksft_exit_fail_msg()
> will be called, which unconditionally calls exit(), a noreturn function.
> However, clang does not know that ksft_exit_fail_msg() will call exit()
> at the point in the pipeline that the warning is emitted because
> inlining has not occurred, so it assumes control flow will resume
> normally after ksft_exit_fail_msg() is called.
>
> Make it clear to clang that all of the functions that call exit()
> unconditionally in kselftest.h are noreturn transitively by marking them
> explicitly with '__attribute__((__noreturn__))', which clears up the
> warning above and any future warnings that may appear for the same
> reason.
>
> Fixes: 6d029c25b71f ("selftests/timers/posix_timers: Reimplement check_ti=
mer_distribution()")
> Reported-by: John Stultz <jstultz@google.com>
> Closes: https://lore.kernel.org/all/20240410232637.4135564-2-jstultz@goog=
le.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> I have based this change on timers/urgent, as the commit that introduces
> this particular warning is there and it is marked for stable, even
> though this appears to be a generic kselftest issue. I think it makes
> the most sense for this change to go via timers/urgent with Shuah's ack.
> While __noreturn with a return type other than 'void' does not make much
> sense semantically, there are many places that these functions are used
> as the return value for other functions such as main(), so I did not
> change the return type of these functions from 'int' to 'void' to
> minimize the necessary changes for a backport (it is an existing issue
> anyways).
>
> I see there is another instance of this problem that will need to be
> addressed in -next, introduced by commit f07041728422 ("selftests: add
> ksft_exit_fail_perror()").
> ---
>  tools/testing/selftests/kselftest.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftest=
s/kselftest.h
> index 973b18e156b2..0591974b57e0 100644
> --- a/tools/testing/selftests/kselftest.h
> +++ b/tools/testing/selftests/kselftest.h
> @@ -80,6 +80,9 @@
>  #define KSFT_XPASS 3
>  #define KSFT_SKIP  4
>
> +#ifndef __noreturn
> +#define __noreturn       __attribute__((__noreturn__))
> +#endif
>  #define __printf(a, b)   __attribute__((format(printf, a, b)))
>
>  /* counters */
> @@ -300,13 +303,13 @@ void ksft_test_result_code(int exit_code, const cha=
r *test_name,
>         va_end(args);
>  }
>
> -static inline int ksft_exit_pass(void)
> +static inline __noreturn int ksft_exit_pass(void)

Orthogonal to this fix, but why does a "no return" function have a
non-void return type?

>  {
>         ksft_print_cnts();
>         exit(KSFT_PASS);
>  }
>
> -static inline int ksft_exit_fail(void)
> +static inline __noreturn int ksft_exit_fail(void)
>  {
>         ksft_print_cnts();
>         exit(KSFT_FAIL);
> @@ -333,7 +336,7 @@ static inline int ksft_exit_fail(void)
>                   ksft_cnt.ksft_xfail + \
>                   ksft_cnt.ksft_xskip)
>
> -static inline __printf(1, 2) int ksft_exit_fail_msg(const char *msg, ...=
)
> +static inline __noreturn __printf(1, 2) int ksft_exit_fail_msg(const cha=
r *msg, ...)
>  {
>         int saved_errno =3D errno;
>         va_list args;
> @@ -348,19 +351,19 @@ static inline __printf(1, 2) int ksft_exit_fail_msg=
(const char *msg, ...)
>         exit(KSFT_FAIL);
>  }
>
> -static inline int ksft_exit_xfail(void)
> +static inline __noreturn int ksft_exit_xfail(void)
>  {
>         ksft_print_cnts();
>         exit(KSFT_XFAIL);
>  }
>
> -static inline int ksft_exit_xpass(void)
> +static inline __noreturn int ksft_exit_xpass(void)
>  {
>         ksft_print_cnts();
>         exit(KSFT_XPASS);
>  }
>
> -static inline __printf(1, 2) int ksft_exit_skip(const char *msg, ...)
> +static inline __noreturn __printf(1, 2) int ksft_exit_skip(const char *m=
sg, ...)
>  {
>         int saved_errno =3D errno;
>         va_list args;
>
> ---
> base-commit: 076361362122a6d8a4c45f172ced5576b2d4a50d
> change-id: 20240411-mark-kselftest-exit-funcs-noreturn-17d8ff729a7a
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>
