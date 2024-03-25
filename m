Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66D03DAC1A
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711386970; cv=none; b=nw+r8Hn5ipd9bYlwELFxE01NRODrvVBr8jEwdlTzTAaYauKblVcEEyAgxvhADOHUTBJ/AgNBPnz/Wh8NsNFzfDuMydDgXFzK03NeM/une54cqVLVcwSMX8GoOy0N655tpgDibbWPJyMiAB6kUBAPNQPnas6ljFbV5utdOdcArp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711386970; c=relaxed/simple;
	bh=5z7JWgRm+prE8c9r61qKqkGGuVaMbLVUWLsiDunLhpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HK26E0IwQWti661LXTyTJ0KxGTIiEKfzEod/SfsyhEwH/TI0TNzUiODw/+umyBJJtLTYTlFqZWjTpRoWoeOFzpEBvLhJKVNxEwS456jGsaBM8Pk0/wAUSH5WUKKlSbSn6G7aUtAQW3Xfp71qq2qmnZw3m0dLZzGPeLFuL44wOKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=bbgNOlFZ; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bbgNOlFZ"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-690be110d0dso30625956d6.3
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711386967; x=1711991767; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5z7JWgRm+prE8c9r61qKqkGGuVaMbLVUWLsiDunLhpA=;
        b=bbgNOlFZZBfl+kc5QeRKXbMPQ7Lh9c844CEdiCWchitJhN0IamY4p9/aGF+VyRQT78
         KpgaBZUs+LBWQi2jQJk5artHGRZGmd6r2WzQHHIk2lHsugB4k3uEsztlbHxYPt0GMGpZ
         mZExIKjIbazepxAZ0HoqaLXEwkjx8DFTZhkVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711386967; x=1711991767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5z7JWgRm+prE8c9r61qKqkGGuVaMbLVUWLsiDunLhpA=;
        b=jo/hncIQgDEjPRT6QgX9syZ14ZiYu388GxhWYtDeeR9KdrggB5DZmQNFl8gCj3VvoJ
         uUkdIpVr1CJy+2EaFD5cVpyw9uK8QmM4FSh2jXXtnXIomspajGw5OrD0a7n3cwy+clTo
         sggfMXcGSW1vtC/J1ubKaL3lnuLKhqEJTBwvrzsJqARDJ/rPE+WrW382ZUtVPiNY8dCY
         GFyXjXdUl11eXn5Rjqd43+qwfr7ScBA4okznkLnXZVLTRbFI5gLebh+7Dd3m4uNDWh+V
         6IaRBuOw6GeLssZ4IqU87qbsXxSAOcD0GASlCdf1IU+4/hZWIso2LIZzDPgVnOmdg6cN
         cHHg==
X-Forwarded-Encrypted: i=1; AJvYcCXITvtimj1phnfWCB3Jcjw3dW7dg3/lYeB9dfvgfMXZZX5SvMkxuDFTJNQjAxZOxcu16GN9B5FtulGj8qSOR87NrWNj1YfsyQ==
X-Gm-Message-State: AOJu0YytbnpRdLzEpg5/iD2k9Na9YducJn5eDLNWRqpKvqz1I25mlS1g
	+CewqwpS0GEw/TnVtI3lV7YsgNJSbF6a+jD13E3lHwL+kNteTn5CL1uWeRI1tUpqMzwZiGDFyY8
	=
X-Google-Smtp-Source: AGHT+IHEV/hvcCcN+41HVwRtNXhlU2MgiA+Bd8vSUUW3YnlqlU5e0/kbLaGQ8IJTEczspSaorV7cTg==
X-Received: by 2002:ad4:5969:0:b0:691:1a11:3122 with SMTP id eq9-20020ad45969000000b006911a113122mr479633qvb.44.1711386967101;
        Mon, 25 Mar 2024 10:16:07 -0700 (PDT)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com. [209.85.160.176])
        by smtp.gmail.com with ESMTPSA id u5-20020ad45aa5000000b00696127dc878sm4308273qvg.12.2024.03.25.10.16.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 10:16:06 -0700 (PDT)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-431347c6c99so14741cf.0
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 10:16:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUJJLDKrmQ2h/CBViNELR2eg64gBu2ZBIlsOb0CJVd8HeuPncdnXOxadnt46F/nQhz4l9IIiVLKAa+7J4VV/8C00twTI5yHQA==
X-Received: by 2002:a05:622a:2a06:b0:431:baa:825 with SMTP id
 hc6-20020a05622a2a0600b004310baa0825mr1246888qtb.25.1711386965873; Mon, 25
 Mar 2024 10:16:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325054403.592298-1-sboyd@kernel.org> <20240325054403.592298-5-sboyd@kernel.org>
 <CAD=FV=Ws-LYcpiitibPBPRhqrbS8rTo_7xtPPw2kA+qBzybOxQ@mail.gmail.com> <42ae624ca2289fb82e00f3ac8938d05e.sboyd@kernel.org>
In-Reply-To: <42ae624ca2289fb82e00f3ac8938d05e.sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 10:15:50 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XcHdEiMf8Z228sT=ChvjJs8Ujw6q8Hcf4b588ocwJHiQ@mail.gmail.com>
Message-ID: <CAD=FV=XcHdEiMf8Z228sT=ChvjJs8Ujw6q8Hcf4b588ocwJHiQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] clk: Get runtime PM before walking tree during disable_unused
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 25, 2024 at 10:06=E2=80=AFAM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> > > +/*
> > > + * Call clk_pm_runtime_get() on all runtime PM enabled clks in the c=
lk tree so
> > > + * that disabling unused clks avoids a deadlock where a device is ru=
ntime PM
> > > + * resuming/suspending and the runtime PM callback is trying to grab=
 the
> > > + * prepare_lock for something like clk_prepare_enable() while
> > > + * clk_disable_unused_subtree() holds the prepare_lock and is trying=
 to runtime
> > > + * PM resume/suspend the device as well.
> > > + */
> > > +static int clk_pm_runtime_get_all(void)
> >
> > nit: It'd be nice if this documented that it acquired / held the lock.
> > Could be in comments, or, might as well use the syntax like this (I
> > think):
> >
> > __acquires(&clk_rpm_list_lock);
> >
> > ...similar with the put function.
>
> I had that but removed it because on the error path we drop the lock and
> sparse complains. I don't know how to signal that the lock is held
> unless an error happens, but I'm a little out of date on sparse now.

I'd settle for something in the comments then? Maybe tagged with "Context:"=
 ?

Thanks!

-Doug
