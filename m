Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC7F10FF
	for <patches@lists.linux.dev>; Wed, 20 Mar 2024 00:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710894657; cv=none; b=U2JOPjcxtELswHpauhm2bVnOYn77KT970dJZDRYF7MTl+ME5BzlpNJgacIyljBqJD0LkTaqXtXPqA3zhy4fllOqf48MTWf6+0DBNpAIGlWlTDpdjbyJl4JH1qMtY9Kr+MIJBNDfj5efTT/H1w/QLPtJ2zvDCcuYOEY5FlGgsGYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710894657; c=relaxed/simple;
	bh=w6xT7TQIIw629OsLA2mpj4+Cm8CL0j6xp7UsXUzQdAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QzFJ+sYDJPr8CpPfU3aq6N+ALyppFgGg7roIcqnjvHDXlGXlSadW115bTS85u41qaybh8qDRoe5gIRHS3tyS9l+k56f3CrAVcv2OV7jpdGOCTRi+KhA3iQH33d0FGvNnwRAKIfZqeBQt7seE2CFdfDkPzVcHYrCb2u6eFnNBUrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z7Uuaa2q; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z7Uuaa2q"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-56ba72fffd6so807031a12.1
        for <patches@lists.linux.dev>; Tue, 19 Mar 2024 17:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710894654; x=1711499454; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZl/MC6G04dgdXWq6n8Jo9rFZ4kdECi4eDf/v32uMoM=;
        b=z7Uuaa2qfcingz9PscqKz1BStrqLekPMJ/8DTsinIyg69XcgY7TyUtJ10STfgAurR/
         e4ntkq9961RabKjBeXPtq+kwppKv5g8JV+5prBcBO2DMoIBmqiPxO8ZZy/MVk5Y8wDcK
         nYT0sC/B8FDeNW3Rektt6UJpcI2wePuVPSqtV/kA56NLDwQQJB+BJTLFh49eG5RUKxhI
         N4qcD5GnJLFDzQ41MEnV7X2Qzb2WY4z+BklxGd18hZjIApL2HWyd+RzWsSVwBJib4m/r
         A/Xzal4oGx2OGgk1m3nTGiFvI8shD3oECslxY/8Uq0dMFSbTyoN9SeIq+htuitGtfaHD
         R+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710894654; x=1711499454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IZl/MC6G04dgdXWq6n8Jo9rFZ4kdECi4eDf/v32uMoM=;
        b=h62w3hmhRQaA8gOCtydvsFcz2lOnu8UwGKD0gL0LOsrTUw9atU6zx567UKlpoEn3/b
         orlG9sJiAmdETprDBJqnfe2+UUKw+CURD52xyOUu9qi0nR7jmOTcw/X/KS6LEucLXHB6
         e/vX8Gbr6E2SkGCKV2zx8S9RBrhpCUVZ3vARqUXyviTonMiipZmjZT+Nlwwfr+j0S7e2
         9v3mtDP9egxvnfBqbCVJaRPOzbeUQtkZuY3TTd+6TGXOCBneVnbhaBmb1630lsaXvPWs
         h4d+NG0n+Q4uIcVLVPRDKo0+0Aakf8NI+j68Ay6guZo9EYdgxta2JC8oDMQCWoZQUbep
         yrDw==
X-Forwarded-Encrypted: i=1; AJvYcCU+INMyJDNmA/V3Yn4SmqFKf97YU4Gyks1ILdIpVaayZzQlB8huCYBzhevzMJxm8j2aHzDueaqDY/2WOGVe3N7B1plIFVze/w==
X-Gm-Message-State: AOJu0YxgMmsWfMywFCmW7P9XUiSP2D/6PPW1NEc3UvXwqEsHDg0KlFGu
	gkAYXbMASWn15m1M1+6k9cLZe87pjtI546zRO/7eP4C0tqvwbXOjimSTzhHsxhZscpVK26y8qOv
	C0y4p5S9VbFJCkQ9DrF5B7QWLXesuC94fISKu
X-Google-Smtp-Source: AGHT+IFVRbRtTK93+JswPYwn75sDfz6NqIQ9pLfPvYXf2GKGX5xRtCwHXsSI1NF/q7+RSh2ICglMKo8eb6X0v/DUYE8=
X-Received: by 2002:a05:6402:5d1:b0:566:b09e:80c4 with SMTP id
 n17-20020a05640205d100b00566b09e80c4mr242572edx.19.1710894654186; Tue, 19 Mar
 2024 17:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319-tracing-fully-silence-wstring-compare-v1-0-81adb44403f5@kernel.org>
 <20240319-tracing-fully-silence-wstring-compare-v1-2-81adb44403f5@kernel.org>
In-Reply-To: <20240319-tracing-fully-silence-wstring-compare-v1-2-81adb44403f5@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Tue, 19 Mar 2024 17:30:41 -0700
Message-ID: <CAFhGd8q_4QfjPwGhtfOA40ZGNF7_wf3V43rAvcb_qXQnz1TFOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] tracing: Ignore -Wstring-compare with diagnostic macros
To: Nathan Chancellor <nathan@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	ndesaulniers@google.com, morbo@google.com, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 9:08=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Commit b1afefa62ca9 ("tracing: Use strcmp() in __assign_str() WARN_ON()
> check") addressed a clang warning, -Wstring-compare, with the use of
> __builtin_constant_p() to dispatch to strcmp() if the source string is a
> string literal and a direct comparison if not. Unfortunately, even with
> this change, the warning is still present because __builtin_constant_p()
> is not evaluated at this stage of the pipeline, so clang still thinks
> the else branch could occur for this situation:
>
>   include/trace/events/sunrpc.h:705:4: error: result of comparison agains=
t a string literal is unspecified (use an explicit string comparison functi=
on instead) [-Werror,-Wstring-compare]
>   ...
>   include/trace/stages/stage6_event_callback.h:40:15: note: expanded from=
 macro '__assign_str'
>      40 |                              (src) !=3D __data_offsets.dst##_pt=
r_);       \
>         |                                    ^
>   ...
>
> Use the compiler diagnostic macros to disable this warning around the
> WARN_ON_ONCE() expression since a string comparison function, strcmp(),
> will always be used for the comparison of string literals.
>
> Fixes: b1afefa62ca9 ("tracing: Use strcmp() in __assign_str() WARN_ON() c=
heck")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Closes: https://lore.kernel.org/all/CA+G9fYs=3DOTKAZS6g1P1Ewadfr0qoe6LgOV=
SohqkXmFXotEODdg@mail.gmail.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  include/trace/stages/stage6_event_callback.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/trace/stages/stage6_event_callback.h b/include/trace=
/stages/stage6_event_callback.h
> index 83da83a0c14f..56a4eea5a48e 100644
> --- a/include/trace/stages/stage6_event_callback.h
> +++ b/include/trace/stages/stage6_event_callback.h
> @@ -35,9 +35,14 @@
>         do {                                                            \
>                 char *__str__ =3D __get_str(dst);                        =
 \
>                 int __len__ =3D __get_dynamic_array_len(dst) - 1;        =
 \
> +               __diag_push();                                          \
> +               __diag_ignore(clang, 11, "-Wstring-compare",            \
> +                             "__builtin_constant_p() ensures strcmp()" \
> +                             "will be used for string literals");      \
>                 WARN_ON_ONCE(__builtin_constant_p(src) ?                \
>                              strcmp((src), __data_offsets.dst##_ptr_) : \
>                              (src) !=3D __data_offsets.dst##_ptr_);      =
 \

What exactly is the point of the literal string comparison? Why
doesn't strcmp do the trick?

> +               __diag_pop();                                           \
>                 memcpy(__str__, __data_offsets.dst##_ptr_ ? :           \
>                        EVENT_NULL_STR, __len__);                        \
>                 __str__[__len__] =3D '\0';                               =
 \
>
> --
> 2.44.0
>
