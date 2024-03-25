Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165D12F38D
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383612; cv=none; b=C5taBaqzAgM1WKv+cx0WUg8r7hzVR21SGlGTmyCjqQlT8wguYQXeoBQURPOW85s/ARhKQNlZ2hYpOj/Hz/zMx1WQ+qswloInkEm8zAX2fmk9714zhhcYPh/UNsaSSNA9EKB0JtlTk3QK8gizr5EjcorDE+ZQ3j92IhOI2oQgXis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383612; c=relaxed/simple;
	bh=A843Ssrq3Y9wYnaYppe8XjmG2PpCDGW6HiDXf0QJKws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nqhC3vKIvYke4ObTrdii6xDiVKGjLY00XcvggxylYr+JxhwDvdZPG4V0+p/yosNUf6b2vO/8z41rdtekx0kjdGo3/2Y3eAW9zHf8jRZsup/rNvIreCs/VawDx34W9ZXXaaJoHdGbvutBDTQyS5l3pV9lziSNfhyYIJgCihRhfpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cmfu3f94; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cmfu3f94"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-789e83637e0so290290785a.2
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711383609; x=1711988409; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9xAtZXJvpwpsev5gWghEp0MSIRB0SQuoLdXgBJreDE=;
        b=cmfu3f949dtnzkM7pEa9Zp46TO+2rYeR4iTxuhlMcAhAwBU5sofdx/BfNDTdLcJuna
         nd98o9U9x5+6dUogCq2WuTj/KXErLt20s1kl5faNbwPsbm0eAfHpYNkEBmkX4bYoOa72
         KyI180zKXDu6WC3w0DK7M/2Sist06EaL0o8Mc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711383609; x=1711988409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O9xAtZXJvpwpsev5gWghEp0MSIRB0SQuoLdXgBJreDE=;
        b=Ez8TXSWfjsnWKPS3I3kWsIi2Z0UdjLBGUUBSTuO7ulDiTzRFmRYIe/4fxT8T9kwoqZ
         11ae+qjTDr76jjNzgcv0pCoWQAqRx/+GrcTbQE3ubqNfpKzuzbKenm2C5d6a3+8IRHn3
         RYE5if5XN6izcZ5Q6KgBy2wBNm1szhcDTwwOIkDdap3oOuZlIi90rrS4CKWET0yl7t+t
         4ginxEWCKOb1IJjnpwK0mv1vJNB4di+eR7wnaKKPihtB9c3QLl/F5QZ5ZxBlPCbDKgx5
         aN53D6sdWuJpNHrguwNXz+n808yHjExNbreegwltETD1OxAAr1F5FIjYJa6eI+dqSNhc
         Jd3w==
X-Forwarded-Encrypted: i=1; AJvYcCUOCIucBWP04Jm3IYmh8IbE/b/RjBvaSuTGSWnYB/G9qWjf7Gvf0aEmQfACTDrj03vfxxzGFaii8D2awecA0kUhcyg0xxyo2A==
X-Gm-Message-State: AOJu0YyN/yTlDFOeQcF6rm18jurW4/p1kYQRYAwc+BLracPVR3rHwo1C
	0WC1u7pAkrEDpmAxohoY9YKHOYADdZZLKFIG+9CTpmEm1OyHORrCIdcXzwhYOc0nmlN3+vyZsS8
	=
X-Google-Smtp-Source: AGHT+IHdGEQIaBxa1MpSPgfJOiQZURJc2htmtnpsuJqQyEcc9FrMcRRN9/0H9qtu/T+WqCgmKVXlpA==
X-Received: by 2002:a05:620a:204e:b0:78a:5da0:16de with SMTP id d14-20020a05620a204e00b0078a5da016demr1170173qka.22.1711383608847;
        Mon, 25 Mar 2024 09:20:08 -0700 (PDT)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com. [209.85.160.177])
        by smtp.gmail.com with ESMTPSA id g20-20020a37e214000000b0078a429cc9ecsm2249737qki.106.2024.03.25.09.20.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:20:08 -0700 (PDT)
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-431347c6c99so487751cf.0
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 09:20:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWp7++u3W3brhRmLzM4kL0xwXiFowkrXqi41La3Zv86prbdShBkCo3yuedqfHkm0YQC19X2SmjPPhCW76JvsjFopTnR1slufg==
X-Received: by 2002:a05:622a:3c7:b0:430:a5df:a3af with SMTP id
 k7-20020a05622a03c700b00430a5dfa3afmr1093586qtx.5.1711383607574; Mon, 25 Mar
 2024 09:20:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325054403.592298-1-sboyd@kernel.org> <20240325054403.592298-6-sboyd@kernel.org>
In-Reply-To: <20240325054403.592298-6-sboyd@kernel.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 25 Mar 2024 09:19:51 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X13_5Kubq3A=y8gnz==6tt2bsfc0PiFAj06HX9V7_+mg@mail.gmail.com>
Message-ID: <CAD=FV=X13_5Kubq3A=y8gnz==6tt2bsfc0PiFAj06HX9V7_+mg@mail.gmail.com>
Subject: Re: [PATCH 5/5] clk: Get runtime PM before walking tree for clk_summary
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>, linux-kernel@vger.kernel.org, 
	linux-clk@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 24, 2024 at 10:44=E2=80=AFPM Stephen Boyd <sboyd@kernel.org> wr=
ote:
>
> Similar to the previous commit, we should make sure that all devices are
> runtime resumed before printing the clk_summary through debugfs. Failure
> to do so would result in a deadlock if the thread is resuming a device
> to print clk state and that device is also runtime resuming in another
> thread, e.g the screen is turning on and the display driver is starting
> up.
>
> Fixes: 1bb294a7981c ("clk: Enable/Disable runtime PM for clk_summary")
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/clk/clk.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Shouldn't this also squash in a revert of commit 1bb294a7981c ("clk:
Enable/Disable runtime PM for clk_summary")? As it is,
clk_summary_show_subtree() is left with an extra/unnecessary
clk_pm_runtime_get() / clk_pm_runtime_put(), right?

Other than that, this looks good to me:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
