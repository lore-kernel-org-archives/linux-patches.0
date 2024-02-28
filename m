Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B294C7003E
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 21:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709156338; cv=none; b=JlAOSFgIQJqoGj67lo/MDNH2m7hPhEMbskWVinePmh7tDvhzoE9FOtaVIdag6zptNnlxs/w/0MYdV8FtlhkKX/Jd1Wr2DklOF9wYyyExFhLDaQ5ZcUF9N19YkcRERKambdFrEQ7wvuDpVRmjJbrtwyXpqB4JJa3p9SQh8Ilz1Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709156338; c=relaxed/simple;
	bh=ZZYMMkvnT8rMcTzALb9auQy9jBxDCGxw/nkLNgFjKsA=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oEKxlGt7VFO/miZTEYTHM4YtzwPPMeKzORKoKtAXJSLuffUUtI07fHInMM8EnT6BcVPym/VPewhSaC6ywZlWsYaJfc5+G+mTwIcLm04MOdBSs8p9EZEvxbOa7qjfd9tmgL/CZMQlzxth5qWriz2vvtaQ0aVAoVxZJmN6OU4NrvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Mg2jqR4H; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Mg2jqR4H"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5131a9b3d5bso164634e87.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 13:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709156335; x=1709761135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZZYMMkvnT8rMcTzALb9auQy9jBxDCGxw/nkLNgFjKsA=;
        b=Mg2jqR4HoSuJqccINIVHijmyZF+gcQUlimJTRHoFP9yupfyC00mWWC4H4IT3Z7oevv
         57nA4rnQGH2ty2qa8a31OeQbfZVx73+51fBqKy2NNgSng/waSnv8eOYIdiLDYRucGfjw
         3H2i2wqrGeRwKpzCG2wDAGmEMR8z3SjKFRycs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709156335; x=1709761135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZZYMMkvnT8rMcTzALb9auQy9jBxDCGxw/nkLNgFjKsA=;
        b=ezAQBcEjUrBcMsA8G1r5ijygRvOtE2D8Fqu39ulRgITe87hmIGOipl+BzAkxobgPSE
         l2scFlWuIk3mxpyyQoUZWIVuA0BEFBvr9IPmKzkTdzeTJl+KSWSX8DY/NlLUgGE2VomO
         JCEaCl3gckJOZLnMfKqnAg955CVN/+ek0HG/7Q2PAy6rfiOsT49c3Cw3m+XmiQl2VZmn
         ZtPmBkS0fOQt++WcvDRA1aBdKQKEtPMotrG6HyNQTqyhyVdiWz0qXrxjD+Ug9arK2GWt
         F3NqZdtpSyhkiq/rbTGtS8dhX4kWJgcu9qKy90DF2ks/lkDKcXohs5zobLDsY0Co975D
         Cuew==
X-Forwarded-Encrypted: i=1; AJvYcCXf5g/oIPbDM4wnrJBeEu6ucxv1fbP2CTwjzzLjeJQif9REZ6lR6D+sAk1bMc0rFtGXr9p9Wbyl70WnJJp5OAKF1o2AWvRqSw==
X-Gm-Message-State: AOJu0YzInWWya4uk139wT89mNz2/ysgD0Ps+phy2uyLTI0ud/ufeLP+k
	5JRXseFw/oErdjSBTOyX5a4y0eT+bI/oeP4Mp9CrnsFyIo8jAuo3ESjcgrxLoGvn3HzZh29tLF2
	6Q3Rw8nZ9/tXh5OWJTSzJMK0kIcFguyiPIHXo
X-Google-Smtp-Source: AGHT+IETIffCFIqYQK+u9ZTlRcZaGK6oBiJ82QRaqg2mZdkQFQuCEw+hnjwQN/Y1e0VJoJC6rZCYqp34iNcxXmVtIdg=
X-Received: by 2002:ac2:5976:0:b0:513:1a38:2406 with SMTP id
 h22-20020ac25976000000b005131a382406mr159441lfp.13.1709156334984; Wed, 28 Feb
 2024 13:38:54 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 28 Feb 2024 13:38:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Zd-nI9XoYW3hrPXx@smile.fi.intel.com>
References: <20240223065254.3795204-1-swboyd@chromium.org> <Zd-CJHkCHpuIEnWh@smile.fi.intel.com>
 <CAMRc=Mdapd2jTACGqm-ujZrAunRmNeJ8_3+bpsN4ieCre52yrg@mail.gmail.com> <Zd-nI9XoYW3hrPXx@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 28 Feb 2024 13:38:54 -0800
Message-ID: <CAE-0n52cgFvaHPDLBd-cn0WMisxX41-fPJHkroTucxHNk39SZQ@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: Pass consumer device through to core in devm_fwnode_gpiod_get_index()
To: Andy Shevchenko <andriy.shevchenko@intel.com>, Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-gpio@vger.kernel.org, 
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Quoting Andy Shevchenko (2024-02-28 13:35:31)
> On Wed, Feb 28, 2024 at 10:28:07PM +0100, Bartosz Golaszewski wrote:
> > On Wed, Feb 28, 2024 at 7:57=E2=80=AFPM Andy Shevchenko
> > <andriy.shevchenko@intel.com> wrote:
> > >
> > > Have you seen this?
> > > https://lore.kernel.org/r/20231019173457.2445119-1-andriy.shevchenko@=
linux.intel.com
> >
> > Clearly yes as I queued the first one in that series. The rest did not
> > make its way upstream for whatever reason. What is your point? You
> > want to respin it?
>
> It was a reply to Stephen. :-)
>

I saw it but it hadn't gone anywhere for many months so I fixed the
problem I saw. Will you resend it?
