Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985871DE8A0
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392782; cv=none; b=E/iHUfZBBl9TtI1h+e0C6BeS2wPDjC4VMXTnz7RmSbNyVRDmV1txGwM0BhOc56ZhiRyTMflwjdFPl3xT4R0xf0oZA5Pf7yhM/Z4ibViDYRZz/4GLq84jpLfleRtvOSdMUd1NOQECP2317Xsjm35gd+phjc1XksR9Z4dlM64XO+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392782; c=relaxed/simple;
	bh=ZKIw9oF7kf8LXffReeWJYdMoxH5f/wyn1hn+qjxWSr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N0/rQUTYEWeQbwFy5RYGAv38b2wB8prdVvcDz0mQ/LqyoIHfBdcay2lgx28EKkyou180kmdjz2+DFtDBkvD7EEeU1Bm8KEOKwzjNgZuP3tch0kIg73R4ELrA/x6qm3csffcRbf4wabg1S25JLqlK9UvesC9ow/WL/lvUZnNgtHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U45nkCDC; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U45nkCDC"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5398ec2f3c3so7059697e87.1
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 06:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728392779; x=1728997579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AZXPuf1MP0+FBM36WN27binVhvXifToPc71Gg+RoyKY=;
        b=U45nkCDC9BiuH8o7zViVhsZ39NZri6Zvx63MaCEn40haLaCRpurcFP/8UoyL6kqbM1
         /rrAgAykp1pJBT9yi+9K7sLEqblNGPlZULWbQZWMi3JKyGOW2BbNR8hbf3t15+K8uYrP
         NI7JV5DHWxW1Pnmc8pCUX1HZeFBXZFvQ5x5bbLlyA3lP5kE1cFg7BvPP+zgQeeowrwLe
         iZ1GHaP6DSCKPQGjdwJCS0NUHbKicow1RkiGP0py9IO2FvjJtvApiehy+YjzGLbWF6n0
         r0QG6AOSJB3RaZSAolHmnZuBcftGngJoTGDd6W66Y7SAK/Acs5C9PpUfU5rSyn4A/ay+
         yWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728392779; x=1728997579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AZXPuf1MP0+FBM36WN27binVhvXifToPc71Gg+RoyKY=;
        b=U4NRdvcbTf4ag8jwpCAUS8ou9Prk571MilI/rl3cZPdpifQQJwlQtZCTE2bIRsg8Tc
         LolX/ENdm05218utcfNV3/JJ9YTQnPdbtO/WZXDmzKLuME8jxbuIsrE6EmzpMUT5Iu33
         0BQ1nDm1j/4ktH6EkLa3L+Ski2NVDpxsZvbrO9U1HOyYmrMi4WeA5IFC1bhtWo7ZgoJ3
         PQeEbAsfiT8vPM/+45J6ySn6ovdaFlUIZ+TPYwfOeN2e7xbqhZMEol4P+0y047uATbdk
         eVd26tQzp+IYNWLPNpDf9+cp3DeVRndnXZdDmN3+p1o+d0tfXCwuyrrjt9Tn4AQ2B2H3
         1wig==
X-Forwarded-Encrypted: i=1; AJvYcCXdGcTDcr685dSy7+q6+lJhuVMr28xIpMBu+sdvNFuVoH7bG/rWE20xMqiS71ZQ8X/dfwTsWYrT@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6C8F27Bmw0W05kK3iq9gVfayiWpgSaj15NcErDTQDQwJ8AU16
	j+TogugVBqxQZTMovtewNTy4dgqGGkM3mimuxO7eoaPfXm2A2bfajHv+NijMOBferRRgPu5VjUm
	xW3TzdRW9LUPWvCweus/rrds2Rs0=
X-Google-Smtp-Source: AGHT+IEV/+IR+5r1Sh95Cy2fpLNjCqLi0ZNRlhsYUJtW8+aX41RKCdv4VBpHsLr5CS2LyUwVAFy1s+L85Tc2Tot+SWs=
X-Received: by 2002:a05:6512:3d04:b0:539:9867:eed7 with SMTP id
 2adb3069b0e04-539ab88c3d2mr8669494e87.24.1728392778418; Tue, 08 Oct 2024
 06:06:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115702.214071228@linuxfoundation.org> <20241008115719.272201292@linuxfoundation.org>
In-Reply-To: <20241008115719.272201292@linuxfoundation.org>
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 8 Oct 2024 15:05:41 +0200
Message-ID: <CA+icZUUjDD6r1NMQ6Kiscq8Yt0a-vBYjh1SiW1oNMQEKPWXQbA@mail.gmail.com>
Subject: Re: [PATCH 6.11 432/558] perf python: Disable -Wno-cast-function-type-mismatch
 if present on clang
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ian Rogers <irogers@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Namhyung Kim <namhyung@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 8, 2024 at 3:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.11-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> commit 00dc514612fe98cfa117193b9df28f15e7c9db9c upstream.
>
> The -Wcast-function-type-mismatch option was introduced in clang 19 and
> its enabled by default, since we use -Werror, and python bindings do
> casts that are valid but trips this warning, disable it if present.
>
> Closes: https://lore.kernel.org/all/CA+icZUXoJ6BS3GMhJHV3aZWyb5Cz2haFneX0=
C5pUMUUhG-UVKQ@mail.gmail.com
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org # To allow building with the upcoming clang 19
> Link: https://lore.kernel.org/lkml/CA+icZUVtHn8X1Tb_Y__c-WswsO0K8U9uy3r2M=
zKXwTA5THtL7w@mail.gmail.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  tools/perf/util/setup.py |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/tools/perf/util/setup.py
> +++ b/tools/perf/util/setup.py
> @@ -63,6 +63,8 @@ cflags =3D getenv('CFLAGS', '').split()
>  cflags +=3D ['-fno-strict-aliasing', '-Wno-write-strings', '-Wno-unused-=
parameter', '-Wno-redundant-decls' ]
>  if cc_is_clang:
>      cflags +=3D ["-Wno-unused-command-line-argument" ]
> +    if clang_has_option("-Wno-cast-function-type-mismatch"):
> +        cflags +=3D ["-Wno-cast-function-type-mismatch" ]
>  else:
>      cflags +=3D ['-Wno-cast-function-type' ]
>
>
>

( I already responded to a stable-commits email sent to me, but here
might be better. )

Hi Greg,

You need both patches:

upstream 00dc514612fe98cfa117193b9df28f15e7c9db9c
"perf python: Disable -Wno-cast-function-type-mismatch if present on clang"
^^ You have only this one - sets only the warning flag

upstream b81162302001f41157f6e93654aaccc30e817e2a
"perf python: Allow checking for the existence of warning"
^^ Add this please to all stable trees affected, Thanks.

Explanations in [1] and initial report in [2].

Thanks.

BR,
-sed@-

[1] https://lore.kernel.org/all/CA+icZUUfk6bMCo+JXUy=3D5g-4qt20rDNR3b=3DHC9=
Ln_47UozXEDQ@mail.gmail.com/
[2] https://lore.kernel.org/all/CA+icZUXoJ6BS3GMhJHV3aZWyb5Cz2haFneX0C5pUMU=
UhG-UVKQ@mail.gmail.com/
