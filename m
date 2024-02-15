Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3215A64D
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707957320; cv=none; b=uuXs7BkDSXCAx9IIL7R0GS9AFZqbtv2uDc4MFs31MZtQXYzByuAp8mz73ZrCY0zx6YmPKpcL+NFXweWguKsBkrZyW0G/McrCyfdrNJQt5DvAWw33DDcnv/BtIXEEw+nL9kk5UVtC5C0WdiulWi598BBp0Wo6JW+00g8f/6P88Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707957320; c=relaxed/simple;
	bh=w4WycQ34mbgOk/JR3FYy5RCHKedOUbdj9qbAJSxWePQ=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gw3j8geDcCYHBbhh5JFAkNwedZRvvlltUMtsDS6JPIComjjKsJsDMAc8KJjPSpKSVA9s9f2SHvq8DWToNqR1qigP3OWhWsOM7iI7GGr4KqriYFchlyq99Tp9+RepWXb25b4dp0aIzS/MS7gSFKWDCSSl6cOCCZjuE6ILupwke6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DTz/8pzG; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DTz/8pzG"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5116b540163so540220e87.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 16:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707957316; x=1708562116; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNL4nxS/kOZUdb+wGvan9grg7BH6Hi7Yz7Ks7Xp1aQE=;
        b=DTz/8pzGZSIyuJ5KRHMIJQzv6ybzOurvnOM+F3Re68phhIOlgJXOw9HNbzqfoEAhN6
         T3BAnfsVaiXh9m2vdz7ZWuZlGkgCarIamwPwjeqAQ+iB5TyRHBLqZQcj3AqLGPJPfZ0j
         8W0f8UkWnU4tvBM5Wy4O/ahXo4Tl8AEPn4gHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707957316; x=1708562116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:user-agent
         :from:references:in-reply-to:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UNL4nxS/kOZUdb+wGvan9grg7BH6Hi7Yz7Ks7Xp1aQE=;
        b=HCTJZpay0iZNAZCRQ8o2sq+oTuy2ExH9xjP4lGfbsyg08aESIG23ztgfTgGNWwAhOa
         9tkcOs+jlrdt9j1GCLZ/dYhx48dtDTFlx3yQkCeiQJFQ+YimlUrAwy+aNEEpeL1n9CxG
         cCrldKGcr6PV1PBi+vIufY4olxvehkuTdNxzgP41aBm/ZQroODzRRH5P6/UcVsphKQ2+
         57TXWVvyXaEJXvnjKhMEkZO+6pSm4BJZzeAuRy4gtYxRJbZhhLz2LHutH4W40Gb8v57M
         W9mfk2Ce6O/zVLdSUwhC/vKyd7qFyBj4voEpxp6bu2NJqLls3gAw3sGPkb5Qb3P1Lfjs
         qFlg==
X-Forwarded-Encrypted: i=1; AJvYcCWxWhk4NIxxldltq70+Y4nolESrkZq/4wFWyIqowvnQEfM1W4hofQxKOZjr79x5/xr6JT6rq9pFreCINdOyor6QfYqpz5efKA==
X-Gm-Message-State: AOJu0Yy1xLIIAvsTGWl81G63IQsLWgNvew07YfjzblMxkIrfSgRG1Y7b
	ylCmoVk+2JoEM8hy6MZQIP7weuoPQV6xW0MMfVReqZQB7pylvCJ96Q1UDr9s2M5bv494YDeAPCG
	S5/ZnL9o3ssQUsEYUUdHlGtzaNstuwcGFrtGv
X-Google-Smtp-Source: AGHT+IHXNYpsYAXuGfn6hjikUWsm1VP4Gg+Q/g46rMXkjUWx6LaJPjIh5nCyPdW7FoWi+tNkxkSyFEKZ9ECBKUMe82M=
X-Received: by 2002:a05:6512:48d3:b0:511:9bab:d424 with SMTP id
 er19-20020a05651248d300b005119babd424mr209887lfb.39.1707957316266; Wed, 14
 Feb 2024 16:35:16 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Feb 2024 16:35:15 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WovmtKFiG0OMzpus9=z8UJ+Ev3TrwsVia8pSegvjwUiw@mail.gmail.com>
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-22-swboyd@chromium.org>
 <CAD=FV=WovmtKFiG0OMzpus9=z8UJ+Ev3TrwsVia8pSegvjwUiw@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 14 Feb 2024 16:35:15 -0800
Message-ID: <CAE-0n52qgKrasAw1AbZ97zMk1xz6P4KkxNLi4cBpNKy5wWu+1A@mail.gmail.com>
Subject: Re: [PATCH 21/22] arm64: dts: qcom: sc7180-trogdor: Make
 clamshell/detachable fragments
To: Doug Anderson <dianders@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>, cros-qcom-dts-watchers@chromium.org, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Quoting Doug Anderson (2024-02-13 15:34:38)
> Hi,
>
> On Fri, Feb 9, 2024 at 11:10=E2=80=AFPM Stephen Boyd <swboyd@chromium.org=
> wrote:
> >
> > + * Copyright 2024 Google LLC.
> > + */
> > +
>
> Tiny nit: should this file have a comment like "/* This file must be
> included after sc7180-trogdor.dtsi */" like the clamshell file?

I was copying the comment for the keyboard include file, but the
detachable doesn't have that include. I can add it here though, that's
fine.

>
>
> > diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/=
arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> > index e9f213d27711..c3fd6760de7a 100644
> > --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> > @@ -5,8 +5,7 @@
> >   * Copyright 2020 Google LLC.
> >   */
> >
> > -/* This file must be included after sc7180-trogdor.dtsi */
> > -#include <arm/cros-ec-keyboard.dtsi>
> > +#include "sc7180-trogdor-clamshell.dtsi"
>
> nit: Not that it was terribly consistent before, but in lazor you
> remove the "This file must be included after sc7180-trogdor.dtsi"
> because (I guess) it moved to the clamshell file. However, in other
> dts files you don't remove it. pazquel has the exact same comment and
> it's not removed. Pompom has a slight variant of the comment where it
> explains the reason (to modify cros_ec) and it's not removed. Could
> make it more consistent...

Sure I can make it more consistent with the explanation. Which way to go
though? Remove it from the boards and put it into the fragment files?
