Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BF17E6
	for <patches@lists.linux.dev>; Wed,  1 May 2024 00:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522641; cv=none; b=K8e4V8DyrJ2t+8xqaIpm8zGZGNYjeMhpcGltAophkOalrSzq0mSa6d5gr7UAszaVD+D4l9jqGek7zPpL4bDDdbxRy96lR3oTLlLwx/KjumoCqf+jq/rbAE5GBSIljjRPoOlHIjn/A9qpTXebTCUZeaZksKwDRyqbrFx2Rm/XGGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522641; c=relaxed/simple;
	bh=1ywHP957dN7QN6N91q0/xp7S+y5cWqGySegerlSjGbo=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZwB2BzV374kbQUgnBbDKuxunIIRhXbndUXXsyrarQg5MEQAtYoHi4XFcv0byTMlL6mw+HSZT2xRkhCQ/N9497IQhHrXi1nDRvTtuq2GkNcDwKZQQpbJf4v9AHOu9Rli6I2BsCVG4inkTEiLFm13W1BL4ACmDUbpV9HOwL4IPQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=UBqcczW4; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UBqcczW4"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-78f056f928eso478227185a.0
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 17:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714522638; x=1715127438; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ywHP957dN7QN6N91q0/xp7S+y5cWqGySegerlSjGbo=;
        b=UBqcczW4eGtztB2Jp3YON05MhsxVSBtJtDONhKf25hIM9QrxkpJe8p4nM8jiYLLwbn
         3M5oBQFxc+78C7ynyVcopWDYliFiHSo6fvZzKK/LGq/+qlbuTKchyZfPtJbrGbL7Dm+o
         5qfyw9wnjFnSQOCWbSQqcOIIdpfclb5/tlYQE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714522638; x=1715127438;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ywHP957dN7QN6N91q0/xp7S+y5cWqGySegerlSjGbo=;
        b=T66t1XiCSnPGI7aEHOQkS+tBsJ5BnwYneMJGLWX4O/unw4DcB7Sm1lvCWoXz6QTGFa
         MEA5gmlYsc/f/A4fGM++AjFMP2WMshn8OoN27TPun2D/lOUpi1+mdtauYvfYRrRcBoCA
         prOZ3KxzLMSSpzcAtj2sDLVh7dfO6HBKOmEtOOTVfkXX0mGoMNutpH/hglqMHPz/gHlC
         vT4eAWy2FcbgW6gyU9YbrYmXhaJf+vJdxn+g4xe7E3z/X/8mXC6Gw1Uj3QrgHelgQPi8
         pdN98GIihblSXq8P8rqQ06A7/iASRezkV8dtbQoVQ0mMwzZ9OVNXDCA6EUkI/FmEldGn
         ayQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgUMVtRlxMUhUVaFGemuNak8z0PBiwzp2pITXn2QklQfxPpk6RSHPE6Rd1fkr28RKctLp7SOy5b24gJSzgUt+14m5zP8cBGA==
X-Gm-Message-State: AOJu0Yz9k6QkUpnMOgSvghpYZ38Lim5Yc90NVIaCYhYdUw+68XHWByTA
	DlSBSfK0iqfpxIDcDsEM9hdcXgJnlenOLBOpoCkdU43t70DY570sb2AnY1PZmkbwIWRJy9p1oSl
	DsGcf9C3ac3RpNsU0fa37rjecdkWQgK7vjK7q
X-Google-Smtp-Source: AGHT+IFHbVqJvW5Quh1nKokc7DOIECNmTOz55NPM4sjfdsU1vArTv7tsX5xChcnAkiqJBSUd0f3wLcvCxkKHa97Wo0U=
X-Received: by 2002:a05:6214:62c:b0:6a0:cd28:ffaa with SMTP id
 a12-20020a056214062c00b006a0cd28ffaamr900368qvx.25.1714522638644; Tue, 30 Apr
 2024 17:17:18 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 30 Apr 2024 17:17:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VLwa0AFsrXXxKGG+hcyW+h7u7-tyg3uoDB8M_XdPti_Q@mail.gmail.com>
References: <20240327202740.3075378-1-swboyd@chromium.org> <CAD=FV=VLwa0AFsrXXxKGG+hcyW+h7u7-tyg3uoDB8M_XdPti_Q@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 30 Apr 2024 17:17:17 -0700
Message-ID: <CAE-0n51osUcpqqh6o9OhURLbRKjcWbRZT-5oHLi_mwfJsUngEw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix a black screen on sc7180 Trogdor devices
To: Doug Anderson <dianders@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Taniya Das <quic_tdas@quicinc.com>, Laura Nao <laura.nao@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Doug Anderson (2024-03-28 09:39:54)
>
> I spent a bunch of time discussing this offline with Stephen and I'll
> try to summarize. Hopefully this isn't too much nonsense...
>
> 1. We'll likely land the patches downstream in ChromeOS for now while
> we're figuring things out since we're seeing actual breakages. Whether
> to land upstream is a question. The first patch is a bit of a hack but
> unlikely to cause any real problems. The second patch seems correct
> but it also feels like it's going to cause stuck clocks for a pile of
> other SoCs because we're not adding hacks similar to the sc7180 hack
> for all the other SoCs. I guess we could hope we get lucky or play
> whack-a-mole? ...or we try to find a more generic solution... Dunno
> what others think.

I think we should hope to get lucky or play whack-a-mole and merge
something like this series. If we have to we can similarly turn off RCGs
or branches during driver probe that are using shared parents like we
have on sc7180.

Put simply, the shared RCG implementation is broken because it reports
the wrong parent for clk_ops::get_parent() and doesn't clear the force
enable bit. With the current code we're switching the parent to XO when
the clk is enabled the first time. That's an obvious bug that we should
fix regardless of implementing proper clk handoff. We haven't
implemented handoff in over a decade. Blocking this bug fix on
implementing handoff isn't practical. Furthermore, we're relying on clk
consumers to clear that force enable bit by enabling the clk once. That
doesn't make any sense, although we could use that force enable bit to
consider the RCG as enabled for clk_disable_unused.

An alternative approach to this series would be to force all shared RCGs
to be parented to XO at clk registration time, and continue to clear
that RCG force enable bit. That's sort of what Dmitry was going for
earlier. Doing this would break anything that's relying on the clks
staying enabled at some frequency through boot, but that isn't supported
anyway because clk handoff isn't implemented. It avoids the problem that
the first patch is for too because XO doesn't turn off causing a clk to
get stuck on. I can certainly craft this patch up if folks think that's
better.

To ease the transition we can make a new clk_ops for the RCG as well so
that each SoC has to opt-in to use this behavior. Then we can be certain
that other platforms aren't affected without being tested first. I'd
prefer to not do that though because I fear we'll be leaving drivers in
the broken state for some time.
