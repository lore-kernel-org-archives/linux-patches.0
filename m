Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A753D87
	for <patches@lists.linux.dev>; Fri,  6 May 2022 23:24:16 +0000 (UTC)
Received: by mail-oo1-f42.google.com with SMTP id f2-20020a4a8f42000000b0035e74942d42so1492140ool.13
        for <patches@lists.linux.dev>; Fri, 06 May 2022 16:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=/ElELV4+QaCmbQivuCO+s3nmw20xVvpsLHj2VQCOczQ=;
        b=Q/mL5LmBEmb9tU2w0cn5NhXVWbyWIiPZkShqLXDDa+rVYo+1WH5J6y4cbFsJ/GHnIC
         cRQnPAAT2Uuv1KT9qQMyQhEBwSwfFhY1cgAJT+RawLfPkt8k09bvKbPuhGRMAXoU9bmo
         oaM+z+Z1SZgTAZFMlrKYNiQUFUqDmFkNmJnYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=/ElELV4+QaCmbQivuCO+s3nmw20xVvpsLHj2VQCOczQ=;
        b=sbOk80ngUkRz5KpL54BnHUc0p7a3pNjgMuKg7te4SCTnhwE/8n5FBTifHdvXhIVX+v
         /TMc1y72IAzCuF7xwtcCLsjG9wxLlsEAYT3f1nf8rFnrcPMX2Ux0+EXb/5AHqjWnB+Mm
         T3gXLz88QcTNEa1sc9SuKOGDgNSlIDGRLFUlniV2RqfUfs7e5A6AjZhIfG/JDZ8AJIAp
         RQqoABc5ZNVMO8iCy1FYT6w4aflmGmHDRFHNkerunlfeOJv0nvPguHx+RcmX4yf1temu
         m8W/CS0+4wAqtw6Dq2yrdF6ZcFZr56jwQAwEahpi5hwK/tT81DzLdiBqYtVvZZI1WyWp
         qhSA==
X-Gm-Message-State: AOAM533XX1bmggdtc6OKv5t4TZvuQRZ7qCMP3aSI3kSdZNSe7QA1jQPn
	ww28NRcV67Ksj+a6KLX39WiSy/GsCcrq/TAXxI9g/w==
X-Google-Smtp-Source: ABdhPJyUJ6tVOobOozeBnxyxa8RgSY9d+Hm2+Rmx0y+yjUzUjdvUB/hoshBRw+G0Dpmcp5sPU11pJETcqoz8VXu5aq0=
X-Received: by 2002:a4a:6b49:0:b0:329:99cd:4fb8 with SMTP id
 h9-20020a4a6b49000000b0032999cd4fb8mr1917932oof.25.1651879455825; Fri, 06 May
 2022 16:24:15 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 6 May 2022 19:24:15 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YnKvoh+h07at8b65@builder.lan>
References: <20220412194505.614002-1-swboyd@chromium.org> <YnKvoh+h07at8b65@builder.lan>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 6 May 2022 19:24:15 -0400
Message-ID: <CAE-0n517iAS9KSdunMX18LpqDrQ4ac-yRCZq82j-XdExaGjCXA@mail.gmail.com>
Subject: Re: [PATCH] clk: qcom: rpmh: Set wake/sleep state for BCM clks
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, patches@lists.linux.dev, 
	Alex Elder <elder@linaro.org>, Taniya Das <quic_tdas@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Bjorn Andersson (2022-05-04 09:53:54)
> On Tue 12 Apr 14:45 CDT 2022, Stephen Boyd wrote:
>
> > Set the wake and sleep state for BCM clks here, not just the active
> > state, as the active only state is dropped when CPUs go to deep idle.
> > This ensures the clk is always on when the driver thinks it is on.
> >
> > This was found by inspection, and could very well be incorrect if the
> > RPMh hardware copies over the active only state to the sleep and wake
> > states.
> >
>
> Taking another look at this patch and now it makes perfect sense to me.
> Sorry for not grasping the problem earlier.
>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>
>
> Will you take this in fixes, or do you want me to pick it for 5.19?
>

I'm waiting for Taniya to reply. For all I know this has no effect
because there's some sort of copy/paste from one state to another. Until
then it doesn't seem like we should do anything.
