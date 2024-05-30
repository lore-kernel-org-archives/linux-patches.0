Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBB0176198
	for <patches@lists.linux.dev>; Thu, 30 May 2024 08:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717058604; cv=none; b=KhaRgmWkv5Kdu7gJK7UtwSK0t/ZuxTCeXaIXR+xRv24IaQaZSNcSNlZIXRVeiSm06qsdBLVcFO+5YAy4IqyHNQmmwnG9IncneRUQlBi5jvTyOplukArYWNDqfdFmI5m2R83fg1Gi24APM9Z0fbeaq+O/F7gpS4UCA/8eUxigkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717058604; c=relaxed/simple;
	bh=5lPEc5yVvXfy5xHN7NJ1MGi4/BA5kf2rdtCVoPXAHLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBw4rbbXbgunjLAVDTVG+Ev47Jjp2rfAR+eoHpy63UY9DKHPWEFl4I+1b26yqA9U8pVdGHNBVetxe3SmU9HKite3+GINeu3S7hl1ruikh25ZtwDh/otLDau2/KsaY6YV+TlRJZgylVQn0CW7uss6wRC/Y9MEVMUKKBkmUv0WfJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LfR53lYz; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LfR53lYz"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57a1b122718so4669a12.1
        for <patches@lists.linux.dev>; Thu, 30 May 2024 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717058601; x=1717663401; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIungYlLLm/88bUfHAWA9yyqvj5B21yLMgFZirqe2GE=;
        b=LfR53lYzXQlPAEv4qaKDuT1bcJdWWHImo5vBiHRwJ4Ejr3AID1ZsuVXQ9uc9j1d445
         CqWfHtji7Ot1A4CTaFmajcKBmJwzOO7oO9poVXydidyzOZVV7VUcfcQu4vZ6/mqsLjCe
         U64q8yNiwz979W6xCisJjWJPYtgsTzvtx6Lw3K6ZkwGrP+KzhxMT+JaRJHDthCQCz3/S
         MizE6u/YHriCd579n+1YVjGDzPSbVf66/PVWxO9d5yspUWEKCooHF2Dvatsv+uZUCtPT
         Rf8x1ih8h/KRPXfsehCtPd4TraUZ5AQguADQMgV6075WxSz9l8ZBEHYAMIDawZwhmka5
         z1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717058601; x=1717663401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIungYlLLm/88bUfHAWA9yyqvj5B21yLMgFZirqe2GE=;
        b=XI0mJzsyKMSoBtBktn1+mbA9Du9QQQJm8lzByxJyvYySNLtCsiYiK1lrl572kALwaK
         ma5SlhNazjhHWfZhyGxPTLXUW6PqpdvxqITrIrR5dFDq24InTiS1Ii8qIVhxG61QaL+Q
         ridBedlextUFH5ey5dQpjhiOUDTEU1FEG+VVPbhj0EvxpnxANkjGIq7/AjPiKWgeqlYq
         t5Mb7L/JDlnUNbdmiLbMF/xPYwtc/YuasfjWUyXJmmZgAgsMyqvz0nIrEqClanOjwukw
         BYee4hfWGPiPyNGkjHKYkSYv9oDJuLZmnXzHS/2q8CEHqUtdjXL5ioOzafCw7QL2Jhnc
         CsVw==
X-Forwarded-Encrypted: i=1; AJvYcCUUrcqbX2nASGZrMW003ODQpBrXLese0b0HRor2k9BuvF+P05Q4GaE4b6rHBl60Jda7ATrIITBr3yr1Cn+Xdmmg2klXMLrGiw==
X-Gm-Message-State: AOJu0YyTtMZCcLI+5dlzfMsOS4czNxhZPu+yUlkpErK/nPu4hJbebxQ3
	LEEeoG3UyM45ASgvnyCji3KJz3++vm0UHPF6FHpieUzTa7q/gM7WdGRDndrTEwAhEu4iPjkvYbM
	7g+VaDqUrki4gXPXhm323/PFwhIczR1Ks6yo=
X-Google-Smtp-Source: AGHT+IHx8Dydq+riFuMhZGjUR/rHUsDceSADAwx6lobyo5M6S2EYM9iJat5JNucibeh4gaWqYkUQDP3ROcddvlVakTs=
X-Received: by 2002:a05:6402:31b8:b0:57a:1a30:f5cf with SMTP id
 4fb4d7f45d1cf-57a1a30fcd5mr81193a12.0.1717058600679; Thu, 30 May 2024
 01:43:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org> <2024053008-sadly-skydiver-92be@gregkh>
 <09445a96-4f86-4d34-9984-4769bd6f4bc1@embeddedor.com> <68293959-9141-4184-a436-ea67efa9aa7c@kernel.org>
 <6170ad64-ee1c-4049-97d3-33ce26b4b715@kernel.org>
In-Reply-To: <6170ad64-ee1c-4049-97d3-33ce26b4b715@kernel.org>
From: Bill Wendling <morbo@google.com>
Date: Thu, 30 May 2024 01:43:03 -0700
Message-ID: <CAGG=3QU6kREyhAoRC+68UFX4txAKK-qK-HNvgzeqphj5-1te_g@mail.gmail.com>
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
To: Jiri Slaby <jirislaby@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <keescook@chromium.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Justin Stitt <justinstitt@google.com>, 
	linux-serial@vger.kernel.org, imx@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:41=E2=80=AFAM Jiri Slaby <jirislaby@kernel.org> w=
rote:
>
> On 30. 05. 24, 10:33, Jiri Slaby wrote:
> > On 30. 05. 24, 10:12, Gustavo A. R. Silva wrote:
> >>
> >>
> >> On 30/05/24 09:40, Greg Kroah-Hartman wrote:
> >>> On Thu, May 30, 2024 at 08:22:03AM +0200, Jiri Slaby wrote:
> >>>>>   This will be an error in a future compiler version
> >>>>> [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
> >>>>>       291 |         struct mxser_port ports[] __counted_by(nports);
> >>>>>           |         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >>>>>     1 error generated.
> >>>>>
> >>>>> Remove this use of __counted_by to fix the warning/error. However,
> >>>>> rather than remove it altogether, leave it commented, as it may be
> >>>>> possible to support this in future compiler releases.
> >>>>
> >>>> This looks like a compiler bug/deficiency.
> >>>
> >>> I agree, why not just turn that option off in the compiler so that th=
ese
> >>> "warnings" will not show up?
> >>
> >> It's not a compiler bug.
> >
> > It is, provided the code compiles and runs.
> >
> >> The flexible array is nested four struct layers deep, see:
> >>
> >> ports[].port.buf.sentinel.data[]
> >>
> >> The error report could be more specific, though.
> >
> > Ah, ok. The assumption is sentinel.data[] shall be unused. That's why i=
t
> > all works. The size is well known, [] is zero size, right?
> >
> > Still, fix the compiler, not the code.
>
> Or fix the code (properly).
>
> Flex arrays (even empty) in the middle of structs (like
> ports[].port.buf.sentinel.data[] above is) are deprecated since gcc 14:
> https://gcc.gnu.org/pipermail/gcc-patches/2023-August/626516.html
>
> So we should get rid of all those. Sooner than later.
>
Yes! Please do this.

-bw
