Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE651C68A
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711395613; cv=none; b=nuK++ww3TasYyuxy0DPk5J/kt0VvujTzmnhJAkr/BOzGku0NS4wW9m3kF65/7x/G+da80DwH95CBHQ7QQSvf74CSj2Lf6QWRdxQSjx/QXeu/A34U80r7kFiGYHqlO9F7m/YBYC+tr4sKjBIcolrojPWny5xhWBbu6n9MtKd4FYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711395613; c=relaxed/simple;
	bh=KlDcReSHkzr3q7MI7ZjcywQz9k72vldHzd9nToqdlAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=udur6ocMqRlxeerIYYqWhT+CHUUEr4jrihQpi786tD6pKbFFQAs+XM+FTYghqoIxDeZgjBvGKNV/Ml/DhxWc4ed5VI3V7P96fDRCUrNuAh13GpneXZ/C1285SfV9FFnxK+HcRqFSuF2++pyIaRv1qY7YowdC3RSRSGqOz4Z0spI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=IYM6AgzL; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IYM6AgzL"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-789db18e169so367400285a.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 12:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711395609; x=1712000409; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rCSW8ugAsHBM7+R2hVkV4HgvR3WEY/XblW4OKhzKjhs=;
        b=IYM6AgzLKDumkbLRziAJK04JO7L/Mjja1iZhFpYsy30G6OZmL3oLmqXmFRuiCt9LaY
         ymMYBfL44Nuxm6wA+ar8sSnxBG0XUo0PHNpfzQwJZ2RJLE7G3YF3JMvUHS+r56U0VeBU
         ehAN7PsjepRqr/y1ODf13wYvdlkilAhvqajjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711395609; x=1712000409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rCSW8ugAsHBM7+R2hVkV4HgvR3WEY/XblW4OKhzKjhs=;
        b=oHPvQ81OeKE61Hyhb86cQPWPvZQPfM1qWcC3UN9uaRN99Lml96BbipPvycT2aAhF6g
         i66/rTHf0AyxZh30tHWT7GXoH7wevK0nPi3UcowBjBxkh1THyhlWRH+BKmp65fRsHyz1
         zdEuG63UpEYrLD9HU7mTw7gu92I8g+a04Nvt/l4/smXrcCmlBOLLymiY7z+gBtJrkJS9
         Oukwk8q0uPmAZhDTD5TSl+BsRbiiaURVKAHwe+zjlXqL+o5NQ7Gg87hNCotA+JBKRldV
         jkv+fd7iwT+NlWzAycu6IQJdL9HXz3zBVUJmbFlFFo1m7tTl4DL4gK6lgdCgputuzqM8
         CXfQ==
X-Forwarded-Encrypted: i=1; AJvYcCW32tiWvx9hdk4H1u5Z8pS7TPKy8VLQlNHqqVKRbCgTeFOrkonbc+wju7edsQrLX3OsWb2LrCgkXi2VAP+U8r/rpX+bhFRFkw==
X-Gm-Message-State: AOJu0Ywl6mOZ8XfKqxOyv7SNgSzf/yyOs/8UHBegqckTKi2W7XZQuSzN
	RRN3F3Qx0ahX/FF4JX7wprLMDuIuicaEcIqrCP1v3fzuK51Uq0HFJev2PeUgk6w57FSMAe8tuoQ
	=
X-Google-Smtp-Source: AGHT+IHvIwpGLAzNKr60Nvk9RG8OBfrYY0Iq7CNEphm4UpPiJbYXdpb5xePTGVVRWDgFyJsgZXqmJQ==
X-Received: by 2002:ae9:f401:0:b0:78a:3437:f22f with SMTP id y1-20020ae9f401000000b0078a3437f22fmr8570432qkl.12.1711395608793;
        Mon, 25 Mar 2024 12:40:08 -0700 (PDT)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com. [209.85.160.174])
        by smtp.gmail.com with ESMTPSA id c9-20020a05620a134900b00788357d6759sm2388510qkl.11.2024.03.25.12.40.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 12:40:08 -0700 (PDT)
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-428405a0205so62121cf.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 12:40:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX06MyTdbOmXA9G+UxXCfIdre/LItcm6DmpllBzfCaReZYZqhIDkK7zMcggQLDRYwkTHPK9Oq9IQsduioskvr79P3l196Wt2w==
X-Received: by 2002:a05:622a:553:b0:430:b590:e88c with SMTP id
 m19-20020a05622a055300b00430b590e88cmr1295243qtx.6.1711395605673; Mon, 25 Mar
 2024 12:40:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325184204.745706-1-sboyd@kernel.org> <20240325184204.745706-6-sboyd@kernel.org>
In-Reply-To: <20240325184204.745706-6-sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 12:39:49 -0700
X-Gmail-Original-Message-ID: <CAD=FV=URo0V1JGJ=sOz4i7hW9EqrCHyEwW4Bc1P7hsoxdw5tAA@mail.gmail.com>
Message-ID: <CAD=FV=URo0V1JGJ=sOz4i7hW9EqrCHyEwW4Bc1P7hsoxdw5tAA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] clk: Get runtime PM before walking tree for clk_summary
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 25, 2024 at 11:42=E2=80=AFAM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> Similar to the previous commit, we should make sure that all devices are
> runtime resumed before printing the clk_summary through debugfs. Failure
> to do so would result in a deadlock if the thread is resuming a device
> to print clk state and that device is also runtime resuming in another
> thread, e.g the screen is turning on and the display driver is starting
> up. We remove the calls to clk_pm_runtime_{get,put}() in this path
> because they're superfluous now that we know the devices are runtime
> resumed. This also squashes a bug where the return value of
> clk_pm_runtime_get() wasn't checked, leading to an RPM count underflow
> on error paths.

Ah, interesting. Thinking about this, I guess it means that a single
device that returns an error from its pm_runtime_get() will fully
disable the entire system's unused clock disabling as well as the
entire clk_summary. Crossing my fingers that doesn't show up in
practice...


> Fixes: 1bb294a7981c ("clk: Enable/Disable runtime PM for clk_summary")
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/clk/clk.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
