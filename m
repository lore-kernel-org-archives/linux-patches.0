Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E29213776C
	for <patches@lists.linux.dev>; Thu, 28 Mar 2024 16:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711644019; cv=none; b=bmpRvubosEH4Kv8xSLRU1KsK/QvDaxG6Pv0kSmqPlMpaoRKqwLHEPN5RMKgtop/4mO/RxyD1mMuhyOjPwJ8BvfNVmtSaii7ve4wB7S0zZ+MDpgejurL1b0VRtmv09Vgmt2EcyP63RNP9XBURIQUtLHOoFxNInuZiv+P4PEKJQLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711644019; c=relaxed/simple;
	bh=JukYux1lE2QutH9NWRSXKyGW55kBvsXf0kklaYf/Sz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WQNxKI7UCg1NwU9NqUMn8dX2UjD8kv7MZlQPqSQdw45rDAHJxZoUfXtCU3e6bXSq3ZFhQd+vvXH4+blqDvMYMCp56xN8GDCpsCRa+0AjjMje3CdZVaok+2ND21Dy+K8Kr9FGlEQFazB/FIa9kUcp7QyTiaYypnxvisGG7bU0w50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Juk6s1QA; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Juk6s1QA"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-690cf6ecd3cso5806436d6.2
        for <patches@lists.linux.dev>; Thu, 28 Mar 2024 09:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711644012; x=1712248812; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPv1IlNNd25MIWO2snW+UJ+Z3ASjHN9LM0c86t+nKQY=;
        b=Juk6s1QAyaNdKMnmLfz1VD3NQfj+yVm0wNgud+1MzCFv6CFdmv4Bw+h3o046HHwB8j
         SRiEJwAXuxx36dF7xXqZdticNljcCkUas6gttECQtd1sXZKdbN7CQZYi8n8LPaaBe4+v
         aOZ0+9SL9vI2rn+wStjK44P0BOI9qBL3KrQBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711644012; x=1712248812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPv1IlNNd25MIWO2snW+UJ+Z3ASjHN9LM0c86t+nKQY=;
        b=MYoEA8p2R9zCqvz1hghC/d9AWbMvU4sDqDLW6Sdm2JO50u29B8MEw1hrzHKMwaYh0X
         /gnntmvA42w2O5ZE9DTTxOHZk+UvlowduYiLTKBYCBShak+SSGDL5zLrSUtdEbVfLwh7
         lrMlfg7Wslzm24/RkX0yLQ0ZJbyaWpoohw4dELlv/pPaYn4PhA3FTCO24Tbq2eAnuvkx
         0zbpshfMdtxKNIaz4NtdxahnPPiP+9WggLFqACF6FOxkxOt45IxoLvt1KP1xP6Z5jPLs
         CHceZ6UYZ5FeIsJO4c2zaMTyT0wMOzMTDyvUL+lIAwf9OTklDpbPOJaT89Az2r5xab/p
         TGfg==
X-Forwarded-Encrypted: i=1; AJvYcCWwyBPxQOO/1rY1u1cvAbN/dxKhuh097AyUcngKF89MXpkD6jPDJg+iLj+5wOYxjtNIwP0kepwu+9PblV+jhrzy0ee664ijDA==
X-Gm-Message-State: AOJu0Yzu/Ed7mSMOji40lrHKxx0QBJsVqUPaZxtv0+XjOZF8OAtFF1yf
	HqknlNcUguO9CymLH/qN4IrCK2mKyqXJSTxkJTSKuD7cXrLYHg/Py1hJYSXmSjxOjcYx2vP25bM
	=
X-Google-Smtp-Source: AGHT+IESHrujJwD2QyqX98+aA2EToUDJSHb6ZG2f8zQsVU3/hN7Eo3SuK7BjFn/E0q/pfVt0bSNxjA==
X-Received: by 2002:ad4:42c9:0:b0:690:c79a:2d35 with SMTP id f9-20020ad442c9000000b00690c79a2d35mr3081404qvr.9.1711644012034;
        Thu, 28 Mar 2024 09:40:12 -0700 (PDT)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com. [209.85.160.177])
        by smtp.gmail.com with ESMTPSA id gv15-20020a056214262f00b00690dd47a41csm781718qvb.86.2024.03.28.09.40.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 09:40:11 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-431347c6c99so5451cf.0
        for <patches@lists.linux.dev>; Thu, 28 Mar 2024 09:40:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVAfMHcc/jPVCf9R75RnTnqSqB3wd3rniMT6PDTxXzv9yYlQnBJknDeeD1LiBJb3aA991fGbX3xyw2RTNJx1PIOTuozuUJlnQ==
X-Received: by 2002:a05:622a:410a:b0:431:8151:e7c1 with SMTP id
 cc10-20020a05622a410a00b004318151e7c1mr379066qtb.4.1711644008766; Thu, 28 Mar
 2024 09:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327202740.3075378-1-swboyd@chromium.org>
In-Reply-To: <20240327202740.3075378-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Thu, 28 Mar 2024 09:39:54 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VLwa0AFsrXXxKGG+hcyW+h7u7-tyg3uoDB8M_XdPti_Q@mail.gmail.com>
Message-ID: <CAD=FV=VLwa0AFsrXXxKGG+hcyW+h7u7-tyg3uoDB8M_XdPti_Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix a black screen on sc7180 Trogdor devices
To: Stephen Boyd <swboyd@chromium.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	Taniya Das <quic_tdas@quicinc.com>, Laura Nao <laura.nao@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 27, 2024 at 1:27=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> This patch series fixes a black screen seen at boot on Trogdor devices.
> The details of that problem are in the second patch, but the TL;DR is
> that shared RCGs report the wrong parent to the clk framework and shared
> RCGs never get turned off if they're left force enabled out of boot,
> wedging the display GDSC causing the display bridge to fail to probe
> because it can't turn on DSI.
>
> The first patch is basically a hack. It avoids a problem where the mdss
> driver probes, turns on and off the mdp clk, and hangs the rotator clk
> because the rotator clk is using the same parent. We don't care about
> this case on sc7180, so we simply disable the clk at driver probe so it
> can't get stuck on.
>
> The second patch fixes the shared RCG implementation so that the parent
> is properly reported and so that the force enable bit is cleared. Fixing
> the parent causes the problem that the first patch is avoiding, which is
> why that patch is first. Just applying this second patch will make it so
> that disabling the mdp clk disables the display pll that the rotator clk
> is also using, causing the rotator clk to be stuck on.
>
> This problem comes about because of a combination of issues. The clk
> framework doesn't handle the case where two clks share the same parent
> and are enabled at boot. The first clk to enable and disable will turn
> off the parent. The mdss driver doesn't stay out of runtime suspend
> while populating the child devices. In fact, of_platform_populate()
> triggers runtime resume and suspend of the mdss device multiple times
> while devices are being added. These patches side-step the larger issues
> here with the goal of fixing Trogdor in the short-term. Long-term we
> need to fix the clk framework and display driver so that shared parents
> aren't disabled during boot and so that mdss can't runtime suspend until
> the display pipeline/card is fully formed.
>
> Stephen Boyd (2):
>   clk: qcom: dispcc-sc7180: Force off rotator clk at probe
>   clk: qcom: Properly initialize shared RCGs upon registration
>
>  drivers/clk/qcom/clk-rcg2.c      | 19 +++++++++++++++++++
>  drivers/clk/qcom/dispcc-sc7180.c | 14 ++++++++++++++
>  2 files changed, 33 insertions(+)

I spent a bunch of time discussing this offline with Stephen and I'll
try to summarize. Hopefully this isn't too much nonsense...

1. We'll likely land the patches downstream in ChromeOS for now while
we're figuring things out since we're seeing actual breakages. Whether
to land upstream is a question. The first patch is a bit of a hack but
unlikely to cause any real problems. The second patch seems correct
but it also feels like it's going to cause stuck clocks for a pile of
other SoCs because we're not adding hacks similar to the sc7180 hack
for all the other SoCs. I guess we could hope we get lucky or play
whack-a-mole? ...or we try to find a more generic solution... Dunno
what others think.

2. One thing we talked about would be adding something like
`CLK_OPS_PARENT_ENABLE_FOR_DISABLE` for all the RCGs. That should get
rid of the actual error we're seeing. Essentially what we're seeing
today is:

* RCG1 is parented on a PLL
* RCG2 is parented on the same PLL
* RCG1, RCG2, and the PLL are left enabled by the BIOS

When we enable/disable RCG1 then the PLL turns off (since we propagate
our disable to our parent and nothing else is keeping the PLL on). At
this time RCG2 is implicitly off (it's not producing a clock) since
its parent (the PLL) is off. ...but the hardware "force enable" bit
for RCG2 is still set to on and the kernel still thinks the child of
this clock is on.

If, after this, we "disabled" a branch clock child of RCG2 (because
it's unused and we get to the part of the kernel that disables unused
clocks) then we were getting the error since you can't change the
hardware "enable" bit for a branch clock if its parent is not
clocking.

...so `CLK_OPS_PARENT_ENABLE_FOR_DISABLE` would fix this specific case
because we'd turn the PLL on for the duration of the "disable" call.

...but there is still the concern here that there will be a period of
time that the RCG2 child is "stuck" even if we're not paying attention
to it. This would be the period of time between when we turned the PLL
off and we got around to disabling the RCG2 child because it was
unused. Stephen thought that perhaps something else in hardware
(perhaps a GDSC) might notice that the RCG2 child's hardware "enable"
bit was set and would assume that it was clocking. Then that other bit
of hardware would be unhappy because no clock came out. This concern
made us think that perhaps `CLK_OPS_PARENT_ENABLE_FOR_DISABLE` isn't
the right way to go.

3. Another idea was essentially to implement the long talked about
idea of "handoff". Essentially check the state of the clocks at boot
and if they're enabled then propagate the enable to our parents.

If we implement this then it would solve the problem because RCG1 and
RCG2 would add an implicit request for the PLL to be on. If we
enable/disable RCG1 at boot then the PLL will still stay on because
there's a request from RCG2. If/when we disable children of RCG2 then
the PLL will lose its request but that's fine. In no cases will we
have a hardware "enable" bit set without the parent.

This seems solid and probably the right solution.


Stephen was a bit concerned, though, because you don't know when all
your children have been registered. If a child shows up after "disable
unused" runs then you can get back into the situation again. That
probably isn't concern for the immediate problem at hand because all
the clocks involved show up in early boot, but it means that the
problem is half solved and that's not super satisfying.

To solve this, we need to overall solve the "disable_unused" problem
to be at the right time, after everything has had a chance to probe.
To me this feels a bit like the "sync state" problem with all the
baggage involved there. Specifically (like sync state) I think it
would have to be heavily based on analysis of the device tree and
links and that has the standard problem where you never enter sync
state when DT has a node "enabled" but you didn't happen to enable the
relevant driver in your kernel config. ...though I guess we've "sorta"
solved that with the timeout. NOTE: if I understand correctly this
would only be possible if drivers are using "struct clk_parent_data"
and not if they're just using global names to match clocks.

I'll also note that in general I believe Stephen isn't a fan of
"disable_unused", but (my opinion) is that it's important to have
something in the kernel that disables unused clocks when everything is
done loading. Without this we add a lot of complexity to the firmware
to turn off all the clocks that the SoC might have had on by default
and that's non-ideal.

-Doug
