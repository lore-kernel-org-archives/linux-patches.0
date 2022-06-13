Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EB3139F
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 15:40:10 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1011df6971aso6425870fac.1
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BGAIi+/Ft53DX8CUrCtDAbQTz9ZPUzipX2JK4m40Fyc=;
        b=RPluaBvzdSvJ5njD15mxkw0ob6qmuyOBJo1hMaQ2AFBjUq++UqkyqjMZzoFpoAhmIr
         ec01sWqSFKsJB6FZgwGP7drgPr4gYSWF10aZZIvHqpTM4uKuRPArOtlTZ65e2oWlcIJc
         0gAKcSwnh35acodyjWgGJzwhHUz3FRGrcu+tA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BGAIi+/Ft53DX8CUrCtDAbQTz9ZPUzipX2JK4m40Fyc=;
        b=ZI3YEENnR33t32pdDKFLkzxWxwC28quqtj7AmjBSBCv2M3NX4Wssfd28+8GJ5Lam0Q
         aCn66YLVdeUJNZReNWC2Eccp81OH/IaPC9XPLHVYnduKm4w63UL6Nv/MRioxQpBxKCWl
         X0xGSSBJsUzR6U24Y3M1cna4kLKj6gUUb2OWlskTBZ8ZhfMgyyCVfr+ci8M8krH6QSTb
         DuQqpulqkIh6uxejBL/0f5eBW+o2AxU6GrqkDbATPPzH43yGp1Omd3Rtw8Vc29O2Obb3
         zY0YhIQQUkeyBbvphNMXlyjw29ak3yA0X/aceL8fUcQivdWxEU70zrLWBPg3pVr4Lsos
         cf5A==
X-Gm-Message-State: AOAM530lSjVBNmSkYeqSFwK3no7VzItzgUessaQsiIZ2AMizwf/jwj62
	SImS5yfJ48BlgZ5iarNFsGzOo9R0q9zsbA==
X-Google-Smtp-Source: ABdhPJxPEXlzyiU5udV7JuNCN3A81NYUMgQu5DYeOQuhYeMcA8SiQVIbUgBcr9RiPhSqOxc1TiSxOg==
X-Received: by 2002:a05:6870:8193:b0:f5:d85f:8bf5 with SMTP id k19-20020a056870819300b000f5d85f8bf5mr7956832oae.206.1655134809922;
        Mon, 13 Jun 2022 08:40:09 -0700 (PDT)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com. [209.85.160.41])
        by smtp.gmail.com with ESMTPSA id x21-20020a056830115500b0060b0b638583sm3546100otq.13.2022.06.13.08.40.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 08:40:08 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so3186143fac.13
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 08:40:08 -0700 (PDT)
X-Received: by 2002:a05:6870:5247:b0:fb:2e60:26c6 with SMTP id
 o7-20020a056870524700b000fb2e6026c6mr157351oai.241.1655134808192; Mon, 13 Jun
 2022 08:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220611061825.4119270-1-swboyd@chromium.org>
In-Reply-To: <20220611061825.4119270-1-swboyd@chromium.org>
From: Evan Green <evgreen@chromium.org>
Date: Mon, 13 Jun 2022 08:39:32 -0700
X-Gmail-Original-Message-ID: <CAE=gft7ZJ3PP=A8FMUs1O6FnRacjrceeYzeoJ8_9q5AffuLBPw@mail.gmail.com>
Message-ID: <CAE=gft7ZJ3PP=A8FMUs1O6FnRacjrceeYzeoJ8_9q5AffuLBPw@mail.gmail.com>
Subject: Re: [PATCH v2] platform/chrome: cros_ec: Always expose last resume result
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Guenter Roeck <groeck@chromium.org>, 
	chrome-platform@lists.linux.dev, Rajat Jain <rajatja@chromium.org>, 
	Matthias Kaehlcke <mka@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jun 10, 2022 at 11:18 PM Stephen Boyd <swboyd@chromium.org> wrote:
>
> The last resume result exposing logic in cros_ec_sleep_event()
> incorrectly requires S0ix support, which doesn't work on ARM based
> systems where S0ix doesn't exist. That's because cros_ec_sleep_event()
> only reports the last resume result when the EC indicates the last sleep
> event was an S0ix resume. On ARM systems, the last sleep event is always
> S3 resume, but the EC can still detect sleep hang events in case some
> other part of the AP is blocking sleep.
>
> Always expose the last resume result if the EC supports it so that this
> works on all devices regardless of S0ix support. This fixes sleep hang
> detection on ARM based chromebooks like Trogdor.
>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Rajat Jain <rajatja@chromium.org>
> Cc: Matthias Kaehlcke <mka@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Fixes: 7235560ac77a ("platform/chrome: Add support for v1 of host sleep event")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

I looked at the EC code for firmware-hatch-12669.B, which is I think
the oldest board shipping the suspend_transitions support, and saw
that it correctly initializes resume_response.sleep_transitions for
both S0IX_RESUME and S3_RESUME. I think that mitigates my only concern
that we might be interpreting garbage sleep_transitions from the EC on
some older platforms. So,

Reviewed-by: Evan Green <evgreen@chromium.org>

> ---
>
> Changes from v1 (https://lore.kernel.org/r/20220610223703.3387691-1-swboyd@chromium.org):
>  * Fixed typo
>
>  drivers/platform/chrome/cros_ec.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/platform/chrome/cros_ec.c b/drivers/platform/chrome/cros_ec.c
> index b3e94cdf7d1a..3abef9747482 100644
> --- a/drivers/platform/chrome/cros_ec.c
> +++ b/drivers/platform/chrome/cros_ec.c
> @@ -135,10 +135,10 @@ static int cros_ec_sleep_event(struct cros_ec_device *ec_dev, u8 sleep_event)
>         buf.msg.command = EC_CMD_HOST_SLEEP_EVENT;
>
>         ret = cros_ec_cmd_xfer_status(ec_dev, &buf.msg);
> -
> -       /* For now, report failure to transition to S0ix with a warning. */
> +       /* Report failure to transition to system wide suspend with a warning. */
>         if (ret >= 0 && ec_dev->host_sleep_v1 &&
> -           (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME)) {
> +           (sleep_event == HOST_SLEEP_EVENT_S0IX_RESUME ||
> +            sleep_event == HOST_SLEEP_EVENT_S3_RESUME)) {
>                 ec_dev->last_resume_result =
>                         buf.u.resp1.resume_response.sleep_transitions;
>
>
> base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
> --
> https://chromeos.dev
>
