Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D474D9FE
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383554; cv=none; b=it+rc+CEfsOrTHRRrxDUMFEsZ4BwB4baufH4QYFU1rhgB/E6pL6nJvwTryy2b1tN7RmQrxc9mZj0XoCkOFtRBViek2GZpvtFZMt8icZZINBR1XaHXmH6+0HlyboKD0EsqtfF+xXfShbnh07bnj0p29vbaXUg2cp1KkzPvIvRX/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383554; c=relaxed/simple;
	bh=C0yANzAlSzgND8qqihTlSMXwQ/R0JMuPRLxdKZ8jvZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I6drupEYPbVZqfhnwJJxk2KqozcXDuFOrQlcBWwnytsdZr7VfTCAZueLKHn/s609gWqtE7HfprsHMm5N0KvmdxAJiqIi0ni6qOiBvr4rwlTq7u/lLRVDcAJznUhF8G+zJGTaJVcLVveMGZz6XWd+J1gFAX6j8+baPuJcwR8TyVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FfnGvUke; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FfnGvUke"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-430acf667afso27502731cf.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711383550; x=1711988350; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKP+i5jnsTv1b1X+grUsnmPFecRRLS4nYrDFL9hNpXg=;
        b=FfnGvUkeydzUpDdxXTdDkMmWs7EWkJ137vJVPbJnwBkm4hB6leYxjs6vLoeMs0oZL4
         gtnDKq8fxm3R3rCbglX7ZNhcgwq/lbeCYVtZvHk68tE9ZDBu6Y0uQ1ndldpKL608HzLM
         vcMuMC3MQT4ELmXbe6bPTNiq5f2N7bjhoFV0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711383550; x=1711988350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EKP+i5jnsTv1b1X+grUsnmPFecRRLS4nYrDFL9hNpXg=;
        b=pPcdhO9RSG9PuIsie2+nS0f2WAEhlPtk++gk1UVY1meQIug13WferKcywFJVjZX9DV
         vBkTebOkJWupTKtiNEuBUBIlcmZvY5Q3QlgKZc4/lp5iUhaElNjXINSMWEJhu8+Dl/Hq
         MkeDUXPoKroPbam7kKuYWZM6WrFirPsEpMNDoGVpbJyApKU2cgHjLgmveDfjw+0gPDFR
         /l3/ppiI8vxrpxY7RJsnZu22uzjzR6Y2hQc2v0hTnVwCL40PLgK73fzE00pdc3Gz3SPl
         U/g3dqXYAJFTM0U9sJMHjOq9cGJZbg7jNniPxGX9+kyWGxwarid/r4z1dU7xwvF4xPwk
         SY3A==
X-Forwarded-Encrypted: i=1; AJvYcCVuzMsDb9xPm6/eVszl+KWSU72HW2W/QwOP4F9y3NfUl709OaWtgcYp0xaaQO+crLZjOSFQInqtHerzXgTNtrfEOdihtgfsnw==
X-Gm-Message-State: AOJu0Ywf/bJv0RFpYibkQWV36Xi/Nw3xWVcolCx/GFyCeZMYgKbguTgW
	aYtDXJqrBxjwMKYIwBgUvdrlvJRcJspOWBNpoUFNkuZPsOiV7T4Iq2FrZloWbXA0lCxDNiw5kM0
	=
X-Google-Smtp-Source: AGHT+IEezCYokdokWwN6d0hKiEzCnCUCTXh2enKEH18WSoxF2SIbCIDSfge+D1BcsxQUixKdz96k5g==
X-Received: by 2002:ac8:59d5:0:b0:430:d4fc:d5a5 with SMTP id f21-20020ac859d5000000b00430d4fcd5a5mr8802986qtf.35.1711383549728;
        Mon, 25 Mar 2024 09:19:09 -0700 (PDT)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com. [209.85.160.170])
        by smtp.gmail.com with ESMTPSA id eh15-20020a05622a578f00b004309cd26bedsm2729745qtb.72.2024.03.25.09.19.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:19:08 -0700 (PDT)
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-431347c6c99so487261cf.0
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:19:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVh/w6wLhVjT9bw+SGGBm9XgxZpXZYHZ+y/KjTPbm2TZVnDGad3GWn8XgdGvGNR9lzG0kzJDpkoLau7CK8RC4Di11Ov2ZULZw==
X-Received: by 2002:a05:622a:5447:b0:431:4eea:ef20 with SMTP id
 eo7-20020a05622a544700b004314eeaef20mr283279qtb.16.1711383548431; Mon, 25 Mar
 2024 09:19:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325054403.592298-1-sboyd@kernel.org> <20240325054403.592298-2-sboyd@kernel.org>
In-Reply-To: <20240325054403.592298-2-sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 09:18:52 -0700
X-Gmail-Original-Message-ID: <CAD=FV=Vo2vpemyH1ChdHtUdaeKnGckBUeqKfL11xn3WsN5+BUw@mail.gmail.com>
Message-ID: <CAD=FV=Vo2vpemyH1ChdHtUdaeKnGckBUeqKfL11xn3WsN5+BUw@mail.gmail.com>
Subject: Re: [PATCH 1/5] clk: Remove prepare_lock hold assertion in __clk_release()
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 24, 2024 at 10:44=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> Removing this assertion lets us move the kref_put() call outside the
> prepare_lock section. We don't need to hold the prepare_lock here to
> free memory and destroy the clk_core structure. We've already unlinked
> the clk from the clk tree and by the time the release function runs
> nothing holds a reference to the clk_core anymore so anything with the
> pointer can't access the memory that's being freed anyway. Way back in
> commit 496eadf821c2 ("clk: Use lockdep asserts to find missing hold of
> prepare_lock") we didn't need to have this assertion either.
>
> Fixes: 496eadf821c2 ("clk: Use lockdep asserts to find missing hold of pr=
epare_lock")
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/clk/clk.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
