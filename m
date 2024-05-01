Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D30712FF67
	for <patches@lists.linux.dev>; Wed,  1 May 2024 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714587089; cv=none; b=oxU+w//tBV2ySxW0lJopk3HAuZ1gKJb7j8Qnms5uRYpQATqpvbmKFeaEdN+SQY0DuaWsu48vtIQCzO9R0t0c8VasqvacdcGhlQDzkX8NH8mtBQw5RHxaz3Wv57JJHefkiYdvP6Z1/9vzOT7P7RzTzfwGXKXTm+SDYeEoV2FSB+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714587089; c=relaxed/simple;
	bh=nFKXvXLadFn2sb+yZv1KYPN17au5eDoEgdinwHBjegs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H1j5a4D4tYAi9rje3cauKFVBDspUDAdmYGakPS6DEj4yqQScLsw8/9+jk2PcCHBpMj41bku0LYtjZTe9vJvSsMtVelPE8iwT6DEeP6PAApbydzuueBJiB76BDBbO5exJtcdy8SJloNopxxzHHz8FKUcStHvQcrV23OK0F6DQ5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ti4pPMMU; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ti4pPMMU"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-de46da8ced2so8055150276.0
        for <patches@lists.linux.dev>; Wed, 01 May 2024 11:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714587087; x=1715191887; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nFKXvXLadFn2sb+yZv1KYPN17au5eDoEgdinwHBjegs=;
        b=Ti4pPMMUrbTTY5D5ln29vYSZHzntQ5t/hA/Ab6lllbZez50us4VpMCfSfGdcQw2s9l
         m57XPUu/H6gPDC4HUJBAr8fFWrV+8q43eJvU/NVK2jtZk/t/AlzNSj3igw50qrKGFKgB
         Yvbbh31RYa6YZbWwxO/XIzz12Zcs5yhOFHVQPaenN2XKgGb2i5er5xiKVTgpENjju3XX
         ZczqzIT+Q0cG9MPC1+Hl8IC2hfLYlk/TkxkMMWcfnGVNqQO5u7zO6HxK+O79pE9yxDBR
         KUTTmP/TjFId5pz6iQbcf1sLXy6idvchwhDsGElK01reZ0cwSek00IWUa9CIQYi3igEI
         b+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714587087; x=1715191887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nFKXvXLadFn2sb+yZv1KYPN17au5eDoEgdinwHBjegs=;
        b=OSIhPYpSver9rGLsYMAte1tj6MnFeIE9T99S7v8ih7DKqI0WuscI1jhWI2QbPfZbM+
         5pkED7fME5zPuKZs5toqFn2P2TVp0TJZAXXEfpIlMhdpUdcl0P3tJvypH36dGfrpCu5g
         LUOKdi96VCofBatD8JrKdKg5d2ZuAUbahQDc1QMBQesdjNktvrsb5Q8B0UvK5tcNd2CO
         Yzq/JR1kmR+ZkcIqTod0NMNRR+K11LhjjkHRiksXMC1mHkkcneAa3HCIYPgvv80U/9ev
         tUM+pBlD+hYd0NSoZinOv7cZYDp9RXdLNnVAAauyTFLxUQFSHT6I1uFON0wzY05OdehC
         uDMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUI0/GGwj28EG4eBOjibBcX87floApvHIFAqw4ti/DCyHUxJDq9saExC/TvXF08I2VoP+j0hdM81xlNAiNCQHMt5JydWiUIhA==
X-Gm-Message-State: AOJu0YyMcHgoaWGKcarx6HxRly8CYdZu0gax4ekwYUCWhESpgn4cEnz1
	NI72ldG9dhYEDpO0ybLZxgVPDlcBMBSPBKzy9EIVevCAocgl/0fJFvqBkOri0d4q0rNrap43VG3
	503hrXVmQQdJWy7vF0KLtG3RG3H/v95zMsoJEEw==
X-Google-Smtp-Source: AGHT+IHYNIdvTb4iBMDLqUY1RqQeF19T75NgRtsKlfmqPhm1TYOhVCTd8FMhMWbpI1r7ar+/niUA1T2KEBeRinx6paM=
X-Received: by 2002:a25:bcc5:0:b0:de6:1245:c3d5 with SMTP id
 l5-20020a25bcc5000000b00de61245c3d5mr3406926ybm.60.1714587085478; Wed, 01 May
 2024 11:11:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327202740.3075378-1-swboyd@chromium.org> <CAD=FV=VLwa0AFsrXXxKGG+hcyW+h7u7-tyg3uoDB8M_XdPti_Q@mail.gmail.com>
 <CAE-0n51osUcpqqh6o9OhURLbRKjcWbRZT-5oHLi_mwfJsUngEw@mail.gmail.com>
In-Reply-To: <CAE-0n51osUcpqqh6o9OhURLbRKjcWbRZT-5oHLi_mwfJsUngEw@mail.gmail.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Wed, 1 May 2024 21:11:14 +0300
Message-ID: <CAA8EJpqVGHqufKo1kV52RzQCNL5D92mmnCzUwKZn4o+5=wF9pQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix a black screen on sc7180 Trogdor devices
To: Stephen Boyd <swboyd@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Taniya Das <quic_tdas@quicinc.com>, 
	Laura Nao <laura.nao@collabora.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 May 2024 at 03:17, Stephen Boyd <swboyd@chromium.org> wrote:
>
> Quoting Doug Anderson (2024-03-28 09:39:54)
> >
> > I spent a bunch of time discussing this offline with Stephen and I'll
> > try to summarize. Hopefully this isn't too much nonsense...
> >
> > 1. We'll likely land the patches downstream in ChromeOS for now while
> > we're figuring things out since we're seeing actual breakages. Whether
> > to land upstream is a question. The first patch is a bit of a hack but
> > unlikely to cause any real problems. The second patch seems correct
> > but it also feels like it's going to cause stuck clocks for a pile of
> > other SoCs because we're not adding hacks similar to the sc7180 hack
> > for all the other SoCs. I guess we could hope we get lucky or play
> > whack-a-mole? ...or we try to find a more generic solution... Dunno
> > what others think.
>
> I think we should hope to get lucky or play whack-a-mole and merge
> something like this series. If we have to we can similarly turn off RCGs
> or branches during driver probe that are using shared parents like we
> have on sc7180.
>
> Put simply, the shared RCG implementation is broken because it reports
> the wrong parent for clk_ops::get_parent() and doesn't clear the force
> enable bit. With the current code we're switching the parent to XO when
> the clk is enabled the first time. That's an obvious bug that we should
> fix regardless of implementing proper clk handoff. We haven't
> implemented handoff in over a decade. Blocking this bug fix on
> implementing handoff isn't practical.

Yes, that needs to be fixed. My approach was to drop the XO parent and
consider the clock to be off if it is fed by the XO.

> Furthermore, we're relying on clk
> consumers to clear that force enable bit by enabling the clk once. That
> doesn't make any sense, although we could use that force enable bit to
> consider the RCG as enabled for clk_disable_unused.

That patch seems fine to me. Will it work if we take the force-enable
bit into account when considering the clock to be on or off?

>
> An alternative approach to this series would be to force all shared RCGs
> to be parented to XO at clk registration time, and continue to clear
> that RCG force enable bit. That's sort of what Dmitry was going for
> earlier. Doing this would break anything that's relying on the clks
> staying enabled at some frequency through boot, but that isn't supported
> anyway because clk handoff isn't implemented. It avoids the problem that
> the first patch is for too because XO doesn't turn off causing a clk to
> get stuck on. I can certainly craft this patch up if folks think that's
> better.

I think this approach makes sense too (and might be preferable to
boot-time hacks).
On most of the platforms we are already resetting the MDSS as soon as
the mdss (root device) is being probed. Then the display is going to
be broken until DPU collects all the coonectors and outpus and finally
creates the DRM device.

But I think we should fix the get_parent() too irrespectively of this.

> To ease the transition we can make a new clk_ops for the RCG as well so
> that each SoC has to opt-in to use this behavior. Then we can be certain
> that other platforms aren't affected without being tested first. I'd
> prefer to not do that though because I fear we'll be leaving drivers in
> the broken state for some time.

SGTM

--
With best wishes
Dmitry
