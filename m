Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61863101
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707867299; cv=none; b=is2WzEB7LU/AwLvsmyK1lXTdXgOEbQpovi69bg2qgbM3vLCglUH4h4zdrP6SRpBj/g9wBpIaQbZ3PkDsuuW8L3L5Vlw2aBGPlLzewppVPHPQxnjksESUpon6n8yyvNgg+aMpBcPnV2Scdf2rmPTGwwpvCI4UVAi7t8jzcSraCVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707867299; c=relaxed/simple;
	bh=hZDX0moxKA2jr0nQXnCCS4aPrBUL93MmvQjXD7Vlbz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EAm7jjnJN+0iu9UkR0lHE9MG4fN6MF+PVNbXtd2TUygpez2O0u86dW9bfICm3rWNsokXp70VpaBOIqOgpPEgHpc1zvl9UMosRFdfTDfrJs+Ys0M/Smclbt4mOAYvtntXKQWHdWBBj/1eT0oj2exrgwtt4RnN1+bcw2n8vQRaOeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MaFGKuPj; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MaFGKuPj"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56003c97d98so5866120a12.3
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707867295; x=1708472095; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egLJA3w8XbBkzhBhvJeKiOGztHliZVh9q//fDQHtqjA=;
        b=MaFGKuPjAMLb9Ffj+mGdiZlDw+qbA6x4HX62/QMPVn8eIl/k29moXLUOXotW+9ImL4
         eDyCiPjzf4g2VC5fS2ZGekXgqCVBhO883IBhBNbJ0QBOOBWJeWfuWmSQ1/qPUB07G746
         yvBlPm0eIis1qpd/og375rijxp7YHu+P8W31A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707867295; x=1708472095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egLJA3w8XbBkzhBhvJeKiOGztHliZVh9q//fDQHtqjA=;
        b=s5Oi5pa5/hQQiIkY5BnxeYa0sKpzEkqG6kbdEW5kq9Tp3TVJxugdMRVIYEjXC/X6i4
         q8gS+mr4B3SDE2GwTE0mY+FhJv0Mw8BvFjZxbFq1tJuPl2ReXCsb4Zqjj05G594jujnQ
         No/x7ZPeC6uDuRKPVulc0Z2MGXp1NFWNsCaXFayC+wKsBZ53o18f1Oxbt7xsj9i+O0Sq
         pxFtUHqJ+cpiXJuzGnPqRSynAk7+mqpeN7Zo3y3qoc1mZzI6Z93tQxVwuCU+JEupSvFF
         4MzFaXoVilPs6vMzpEmgrM/yzz7Q7170+hXNTpVXTj9IsMnXwkgw+28TjVVgT1/k9BEb
         80Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXrIEvKgFG+dIugRDwrGdZwxUjwwWyiDZdNlkrffbLZb+SLRp5M9MW1hGhsFPUxvuB/y5lfFuBacbVXXls3C9RXxRwT0xjAyA==
X-Gm-Message-State: AOJu0Yxbp9W+a2UjgaOSzTKVuzTRKq1X497Ul/lV74lwhe8cHoVf5fqr
	Af/OH+RsoJdw0NChxU84M0AZx3M7OSuQeWi/8lw6Ezq47lojXjGpbr2FjUEt9EtCkcQYKFRpNpW
	0q0Pv
X-Google-Smtp-Source: AGHT+IFLalTxwsypPrkVOwmKWlABlUPtFO4IQDrhB/v+cFnnbLZPVx1TMXV9axvn+OXgR9PXnmOeQQ==
X-Received: by 2002:a05:6402:3d7:b0:561:4238:e6e2 with SMTP id t23-20020a05640203d700b005614238e6e2mr823078edw.29.1707867295475;
        Tue, 13 Feb 2024 15:34:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUrSOuCy/ymvEJhXgcVHVfJGGq4Czp0ivAmCnywVDTsiaD0ig60zqdmdBHwpEBzYYXMjAJTreYDica74eDaUymrBmH1Ygb9Hw==
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id p10-20020aa7d30a000000b00561ee313634sm1091546edq.51.2024.02.13.15.34.54
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 15:34:54 -0800 (PST)
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-410cf70a057so98205e9.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:34:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCURIDzk2VJm4X+p39MWC8uQB1pfJdbSvw6EYBoA0mCHhFT2VN9fuMKfClsoV7J9GdCHY6KfHsshIK90W/UaieRISjOpDAd2DQ==
X-Received: by 2002:a05:600c:a01a:b0:411:e72d:e5c9 with SMTP id
 jg26-20020a05600ca01a00b00411e72de5c9mr9514wmb.5.1707867294378; Tue, 13 Feb
 2024 15:34:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-22-swboyd@chromium.org>
In-Reply-To: <20240210070934.2549994-22-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 13 Feb 2024 15:34:38 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WovmtKFiG0OMzpus9=z8UJ+Ev3TrwsVia8pSegvjwUiw@mail.gmail.com>
Message-ID: <CAD=FV=WovmtKFiG0OMzpus9=z8UJ+Ev3TrwsVia8pSegvjwUiw@mail.gmail.com>
Subject: Re: [PATCH 21/22] arm64: dts: qcom: sc7180-trogdor: Make
 clamshell/detachable fragments
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>, cros-qcom-dts-watchers@chromium.org, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 9, 2024 at 11:10=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi b/arc=
h/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi
> new file mode 100644
> index 000000000000..bcf3df463f80
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Google Trogdor dts framgent for clamshells

s/framgent/fragment


> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi b/ar=
ch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi
> new file mode 100644
> index 000000000000..ab0f30288871
> --- /dev/null
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * Google Trogdor dts framgent for detachables

s/framgent/fragment


> + * Copyright 2024 Google LLC.
> + */
> +

Tiny nit: should this file have a comment like "/* This file must be
included after sc7180-trogdor.dtsi */" like the clamshell file?


> diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/ar=
m64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> index e9f213d27711..c3fd6760de7a 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
> @@ -5,8 +5,7 @@
>   * Copyright 2020 Google LLC.
>   */
>
> -/* This file must be included after sc7180-trogdor.dtsi */
> -#include <arm/cros-ec-keyboard.dtsi>
> +#include "sc7180-trogdor-clamshell.dtsi"

nit: Not that it was terribly consistent before, but in lazor you
remove the "This file must be included after sc7180-trogdor.dtsi"
because (I guess) it moved to the clamshell file. However, in other
dts files you don't remove it. pazquel has the exact same comment and
it's not removed. Pompom has a slight variant of the comment where it
explains the reason (to modify cros_ec) and it's not removed. Could
make it more consistent...


Everything above is either tiny typos or nits, so happy enough with:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
