Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5281F3D82
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 20:31:32 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id m11so3235896oib.11
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 13:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=BTjDu2WbVSkM+THogaOPND5vYJC+rnL9QDTnicnezHw=;
        b=iedhSo398MjiEuM4wYL0tNDNEjO1emHPQEG0jx4oFdbHMSN0Tbr73uPmbWBHNoClx2
         gf/Xnyj9fe+RYgCwlA8jRXCNu3ZdfMq5WKktloMpp8SeucsFMyn/KzuTGz76BGy5vUAX
         HkUD96ZEQ3hhmhG56vDqh8Kj45d2jczHNXwQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=BTjDu2WbVSkM+THogaOPND5vYJC+rnL9QDTnicnezHw=;
        b=zlAIsv7nFYKV8zZTHteMBfwc1hTItSVNp+0rpQxpBYm+tyDgRqWNu9nqs57MiidpIa
         +hwOvChwETHpazxViw4GCoupT74evcYefnid9WxAsf9ACf9htZrfnO4EgW7LklBZodoP
         fsqJlJPX1WC7+t/kRdRH/4v8MmvXW7zIO11+kbAblYrMnrHjQ757cWW8/CbBJIAnyE7R
         SwB5HohWvlBqJu6AUHe7fbnQ2/6p3t4uRQXdC/vypZCoitJ2vpAt4NzNUZ0rTq4wVIkp
         GUUialj1ddrJL1lahgoWGEYs1ytrcHgLD2EL6CEBghNjRKwQgZcrUZd1wZf2fn9sxK1n
         Rbzw==
X-Gm-Message-State: AOAM533GeOIgCPaymp7mQPRBrgmBcaynRdeYMsXlxyweL/8tKTXJFX/G
	8x+GCbKRreBKTTOsu4MogsD4ezGtTGRfdICDETqx4w==
X-Google-Smtp-Source: ABdhPJxs40QvWqeyF3wGk8ZFJb/2UJkHTTGaB8uPg3ULNPuOuUNEUYmGXTbvA8Z4QNZzDDPKDXVVt3/sEqPIqJjowlU=
X-Received: by 2002:a05:6808:1296:b0:325:8fb:68f3 with SMTP id
 a22-20020a056808129600b0032508fb68f3mr10065713oiw.193.1651091491393; Wed, 27
 Apr 2022 13:31:31 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 27 Apr 2022 13:31:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAE-0n53sfUMiCzEgRwVRuxwnf_BLJi+cL-PoZ_ha_3EfEW1X_A@mail.gmail.com>
References: <20220426225748.324759-1-swboyd@chromium.org> <CAD=FV=WMf0Jc9oD7CGoLthguzt2aV31sZmFoenbjn72MfwFYEA@mail.gmail.com>
 <CAD=FV=Wey2P_=3Lp6M8GEaoyCn1XcYFhfJwfx43a5f_8H0obwg@mail.gmail.com> <CAE-0n53sfUMiCzEgRwVRuxwnf_BLJi+cL-PoZ_ha_3EfEW1X_A@mail.gmail.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 27 Apr 2022 13:31:30 -0700
Message-ID: <CAE-0n52vH91zgK0iHiyG5EZtS1KbddUjHgOj2Du43vvnWNJDzg@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard
 from detachables
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Doug Anderson <dianders@chromium.org>
Cc: Andy Gross <agross@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, 
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev, 
	linux-arm-msm <linux-arm-msm@vger.kernel.org>, Benson Leung <bleung@chromium.org>, 
	Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Stephen Boyd (2022-04-27 11:49:25)
>
> Yes, if the driver patch isn't applied then we'll skip registering
> switches when these properties are removed. I suppose a better way to
> gracefully migrate the logic here would be to add another compatible
> string. Then we could make the compatible be
>
>         compatible = "google,cros-ec-keyb-switches", "google,cros-ec-keyb";
>
> on detachables and the driver can skip registering the keyboard if the more
> specific "google,cros-ec-keyb-switches" compatible is present. The
> driver will continue to probe and we don't have to remove any
> properties.
>

I implemented this at
https://lore.kernel.org/r/20220427203026.828183-1-swboyd@chromium.org
