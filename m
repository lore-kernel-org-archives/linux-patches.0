Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E023B19A
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 03:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732763728; cv=none; b=bAKQmXaFHoG0DBcjfVWxgF2yh9KzmWeRCbMC38i7SrorkCk3kLhRRy7MGk5EaE+XvlTpDQP34VT71AtKIWlYVRn16Ogt8hNIhjp5c1hIefYK+bPobPd6LZ899BLz3GYfyS2mI5/ndc5rN41ZWqVbB/Z31dY89SRWY7az5RBF6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732763728; c=relaxed/simple;
	bh=3KPORSOgye9V7mlhDMwS8f+UOYgTd3WwJRxNqx/RErg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b+43VtFauC0aTq0aLcItSMLGv0QE8k5Ptf9LfQOFz9SD/a4BSFAaw80gBhpLAySt/Lb2ihX+M0SLrqmv8Wnpiv0c1A48LUkuIDonqvdo2HvElmX9wqS2fQqCFKEOtLsZKOOP2S7HscHf39m38TKrwbDi7sPkw5kneJqtx5v6gVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjzC4fGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjzC4fGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27EEC4CED4
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732763728;
	bh=3KPORSOgye9V7mlhDMwS8f+UOYgTd3WwJRxNqx/RErg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IjzC4fGHB94VFLl/fkWo2opcDPRDQqLhrVht0Uctaql5LCTlr+/q3jsLNDUlYZ3w+
	 lv6ChxBRNM0Va0VHIQEJS8ob2wqt/X4GxQoSCxcM5ex4GEAJp0yyDcjW2KCcU2/rac
	 ZNJ8cPq3+mrQRhvMsX2yt3DQnkA6HmK55FD9QKRWK1flQZAktQyJ0Ts7Xb12OYB6Al
	 XhqwIAdUrLhYrQH5UdJIwT9APvbe6CL+nLK+31xUkNA8GZKOQn5c4Fa5AYvv7CqKdV
	 tcIqFklq3E0myHCCw4d/nrBu4JGprbFIGG9jc7cGi81hj2kt0HdIoGtl9IRK7h2B9R
	 TFrRlstBdT8cA==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ffc86948dcso3169621fa.2
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 19:15:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVCE29N0XVgbSfBjZydo4Qx4Wht7g8zbfMvYsx158yDs5TYCbEP2ir/bAiPBMKJlQxHseC3hGJ1@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+d5/g4mxEYOdRj/Be8UCsBCXGgkBtS/FTg56NV+XyfRd+k+4/
	50R/9MhRDiu7cigQfNB/D07muNcjMe8SLvnoAPzut5gJUB92OL3MroEFGvXvXjDwAuiKdF7RN4M
	Bu/f+gJopmmgKD1qnlEb2saJFj04=
X-Google-Smtp-Source: AGHT+IGbhHQ1ENBEVbV70RiDRFMrbSKM8OMvLunCuqf6c2DKpLb9Pv0BjaaGl3vtNJ4IMAJVjVQO2JmT/KgCYg5/OFo=
X-Received: by 2002:a05:651c:2211:b0:2fa:c18c:faba with SMTP id
 38308e7fff4ca-2ffd60de22fmr29525351fa.30.1732763726655; Wed, 27 Nov 2024
 19:15:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org> <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org> <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <Z0fT4hC30NISjmi_@bombadil.infradead.org> <Z0fYqZutUzDdxTGf@bombadil.infradead.org>
 <CAK7LNARDwBmvKY4fDmr5K=WLEvWLhFgg50ibu7etJykiRxohOA@mail.gmail.com>
 <Z0fdX6i3inNVJf-e@bombadil.infradead.org> <Z0ffD62YLuVVrCGR@bombadil.infradead.org>
In-Reply-To: <Z0ffD62YLuVVrCGR@bombadil.infradead.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 28 Nov 2024 12:14:50 +0900
X-Gmail-Original-Message-ID: <CAK7LNASj1j5xSP2Df88h2nRUxMbX1WkshrVXdZCa3hrRuOnNkg@mail.gmail.com>
Message-ID: <CAK7LNASj1j5xSP2Df88h2nRUxMbX1WkshrVXdZCa3hrRuOnNkg@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, 
	petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, mmaurer@google.com, 
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 12:10=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
>
> On Wed, Nov 27, 2024 at 07:02:55PM -0800, Luis Chamberlain wrote:
> > I did. Multiple times.
>
> I've split this up now in 2 parts, one with your fixes and then the
> other boundary fixes which are not related.
>
> From 8e4c903fa3079e1c05c9585f78c57e8067024d99 Mon Sep 17 00:00:00 2001
> From: Luis Chamberlain <mcgrof@kernel.org>
> Date: Wed, 27 Nov 2024 14:10:57 -0800
> Subject: [PATCH 1/2] selftests: kallsyms: fix double build stupidity
>
> The current arrangement will have the test modules rebuilt on
> any make without having the script or code actually change.
> Take Masahiro Yamada's suggested fix and cleanups on the Makefile
> to fix this.
>


Fixes: 84b4a51fce4c ("selftests: add new kallsyms selftests")

> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>

Closes: https://lore.kernel.org/all/CAK7LNATRDODmfz1tE=3DinV-DQqPA4G9vKH+38=
zMbaGdpTuFWZFw@mail.gmail.com/T/#me6c8f98e82acbee6e75a31b34bbb543eb4940b15



--=20
Best Regards
Masahiro Yamada
