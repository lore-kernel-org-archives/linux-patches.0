Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2397F
	for <patches@lists.linux.dev>; Fri,  6 May 2022 14:31:00 +0000 (UTC)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-ed9a75c453so7332910fac.11
        for <patches@lists.linux.dev>; Fri, 06 May 2022 07:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=Z3BhvNnZeKv1IcmAFTPQ8BjykroeJGCMjBhzdl/UNHM=;
        b=jO3oHxuDXU4qKNmreCjjYaiO4yOFVMLlHvrgsIknXQpO28ujlFHIX+YGJMNDAohf0S
         DZNeyUI7z2EDLgUqTLJxUWdlh1QK08j28ZN3csKfsdDpAqlRFloCzirijmDCbWZLcZyE
         C6gdUaugeCxwk+y28GBfLl9pvOmB54KmpIvUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=Z3BhvNnZeKv1IcmAFTPQ8BjykroeJGCMjBhzdl/UNHM=;
        b=pj97hUqvbTwIzIOH4uLd4gBM7MNMGivJ9jzUaCjuommVJUciWExlaN/TVOyU2RRtlQ
         9fhcsLwB9cbjbb80jyf2YczbsjQueX7U6lcvcOmnisnONAAAFNCWdRM3UPQlT2HzzkgA
         f0V40mWGpwa55PSO2fCnY3Zq1Sl39v51Pc1/AGdhoCpqbwnQlEROpjCiqNjdaV8xg8oC
         XMw3ZnbyWKSF1W1ogix7VuJ2415pZtYH16nWo/1nV1JNEF5OTvaBI0ACAaynaYCMJKHI
         UzXK/Rlyr0lo2FiPOUaoewHxYdJ/28/TcqTMa7nWeFk8Na5xFWkmK40gVWKrQuSUHkWx
         34Bg==
X-Gm-Message-State: AOAM530FwJ6nHczRWHHOjp7GxbwFwfab/KSZ581LqPs7TY4wfbDrNHXv
	jvREHqFjv/bdcB6nzdq3J9nY2KkxK7FwFUCmytVDpQ==
X-Google-Smtp-Source: ABdhPJzE+vXk1hqtD9UBfXOO2I3rdrl0PyEIZMyce2ypHXN0n1NbIBLqFN65uSkfs/ck6n2qBT6ImYvZZMQRqp20FeQ=
X-Received: by 2002:a05:6870:40c1:b0:ed:9a12:3f95 with SMTP id
 l1-20020a05687040c100b000ed9a123f95mr1383802oal.193.1651847457937; Fri, 06
 May 2022 07:30:57 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 6 May 2022 10:30:57 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YnSYppSYwaoZRXb4@builder.lan>
References: <20220426225748.324759-1-swboyd@chromium.org> <YnSYppSYwaoZRXb4@builder.lan>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 6 May 2022 10:30:56 -0400
Message-ID: <CAE-0n50PaacK_zT1NPoj+9YA9GX4oqpADEHObFdK+Zyu67Guig@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180-trogdor: Remove cros-ec keyboard
 from detachables
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Douglas Anderson <dianders@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>, 
	"Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Bjorn Andersson (2022-05-05 20:40:22)
> On Tue 26 Apr 17:57 CDT 2022, Stephen Boyd wrote:
>
> > Trogdor devices that have a detachable keyboard still have a
> > non-detachable keyboard input device present because we include the
> > cros-ec-keyboard.dtsi snippet in the top-level sc7180-trogdor.dtsi file
> > that every variant board includes. We do this because the
> > keyboard-controller node also provides some buttons like the power
> > button and volume buttons. Unfortunately, this means we register a
> > keyboard input device that doesn't do anything on boards with a
> > detachable keyboard. Let's delete the rows/columns properties of the
> > device node to indicate that there isn't a matrix keyboard on these
> > boards.
> >
>
> As this seems to directly relate to the final design of each device,
> would it make sense to push out the &keyboard_controller from
> trogdor.dtsi? Or do you think it would be too much duplication for it to
> be worth it?

I tried it out a few days ago but I'm waiting to see how the driver
patch goes before sending the dts bits. See the WIP patches up to the
end of the chain on chromium gerrit[1].

[1] https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/3609017
