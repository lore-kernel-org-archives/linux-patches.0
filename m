Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BB917DD
	for <patches@lists.linux.dev>; Fri, 20 May 2022 00:01:08 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id q10so8292332oia.9
        for <patches@lists.linux.dev>; Thu, 19 May 2022 17:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=92AxFLkh/q/FX9UmsoNYgJF83tRzojToGDNuCJ24uZ0=;
        b=bo0gcGIt6u25nCUrj+KKTjCtZjursTAzZwGdLe12izgAiX4vfWUkn5zhB/fpHNZZXu
         ffV2CsDnb5kqmNvtFgBKZ6sdphsLw2DoD+tSOP9j47XZtOQhfLTzSVcMwFlXMnEo9y3A
         2Tj5duPiKtA5P5q6a9kjjzMdqWO4T+kDEcprA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=92AxFLkh/q/FX9UmsoNYgJF83tRzojToGDNuCJ24uZ0=;
        b=LtbsMT9K2t08dp7IRlmTwLXYca55ageXQw/jLxhlaTNIiMPVOkhSY/LeHbHY8ndleB
         KFGAvBh2u5A/4okU4ZQkciCasn91AM5PPwy1A3SPc4al09L5VUv26qRCx2n9UQ1PgmJg
         EAjfx3dasw+xDk163app8N8TNUMhN/Za/TI4oXRB0PKmjGvJZkAzQIhve1HIV99Z6Wvi
         KDaKmuH6gJDjIYaov3DzqSDG3bJ37fdT+w26nHSiIx+LlFG+D7mHuPJiOMQiXNROsQQp
         rgFiG8YWyXRP9Yvt+5w3ezvT4bS7AwUQon0oM+jBIqwCgJk5IjZceoAq8CzpARJvvX5t
         6kiQ==
X-Gm-Message-State: AOAM532kuWeBvTP2TTM5kX5720S9WN/7fnX52prBLCfUomr4kBEnprDi
	IXpYqgFY8Yl/5LtN9aQu0X06LUGDXY07PKArpgnjCw==
X-Google-Smtp-Source: ABdhPJwXFVId+BJT6e8QsIMYPh5FZTQiKs/FmvmwsuevLaX6bwx6IXCj3kFOWDoz82GeH1m1xws6w7TB8qgOfVq2blU=
X-Received: by 2002:a05:6808:14c2:b0:326:c129:d308 with SMTP id
 f2-20020a05680814c200b00326c129d308mr3746471oiw.193.1653004867457; Thu, 19
 May 2022 17:01:07 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 19 May 2022 17:01:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220519164914.v3.2.I6418884d8bab6956c7016304f45adc7df808face@changeid>
References: <20220519164914.v3.1.I71e42c6174f1cec17da3024c9f73ba373263b9b6@changeid>
 <20220519164914.v3.2.I6418884d8bab6956c7016304f45adc7df808face@changeid>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 19 May 2022 17:01:06 -0700
Message-ID: <CAE-0n5025-q8H944gdFNQBdZ32jUVb1WCS0MYJ64+QmpqDm37Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] dt-bindings: arm: qcom: Mention that Chromebooks
 use a different scheme
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Douglas Anderson <dianders@chromium.org>, 
	Rob Herring <robh+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>, 
	Andy Gross <agross@kernel.org>, Alexandru M Stan <amstan@chromium.org>, 
	"Joseph S . Barrera III" <joebar@chromium.org>, patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Rajendra Nayak <quic_rjendra@quicinc.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Julius Werner <jwerner@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Douglas Anderson (2022-05-19 16:51:06)
> The qcom.yaml bindings file has a whole description of what the
> top-level compatible should look like for Qualcomm devices. It doesn't
> match what Chromebooks do, so add a link to the Chromebook docs.
>
> Reported-by: Stephen Boyd <swboyd@chromium.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> The link added here will (obviously) not function until the
> documentation patch makes it to mainline. Presumably folks who want to
> read it in the meantime can find it pretty easily. If there's a better
> way to link this then please let me know.
>
> Changes in v3:
> - ("Mention that Chromebooks use a different scheme") split out for v3.
>
>  Documentation/devicetree/bindings/arm/qcom.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/qcom.yaml b/Documentation/devicetree/bindings/arm/qcom.yaml
> index 5c06d1bfc046..df5230792b37 100644
> --- a/Documentation/devicetree/bindings/arm/qcom.yaml
> +++ b/Documentation/devicetree/bindings/arm/qcom.yaml
> @@ -90,6 +90,11 @@ description: |
>    A dragonboard board v0.1 of subtype 1 with an apq8074 SoC version 2, made in
>    foundry 2.
>
> +  There are many devices in the list below that run the standard ChromeOS
> +  bootloader setup and use the open source depthcharge bootloader to boot the
> +  OS. These devices do not use the scheme described above. For details, see:
> +  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/arm/google/chromebook-boot-flow.rst

Can you use the docs.kernel.org link instead of Linus' tree? I think it
would be

	https://docs.kernel.org/arm/google/chromebook-boot-flow.html
