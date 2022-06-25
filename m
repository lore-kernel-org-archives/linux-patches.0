Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021727A
	for <patches@lists.linux.dev>; Sat, 25 Jun 2022 00:29:44 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id 59so6941255qvb.3
        for <patches@lists.linux.dev>; Fri, 24 Jun 2022 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJj2jKLrKWKYCL3G0JVCzxE24zzw7IepY2Hipgb7xdU=;
        b=ItIXMMRXGzTB4SAjQ/ljwU3he2WFwrwfNYqNw6nx/LVB1pEkb5GqVhkJ0CGNJZSFh2
         9uvGcLACEQw+x0kHvxWYM5t5IhpCmS6jXGVatAX2Of0e5ohhlghwwgrOIFGZZ/UcmSXD
         Ii1eLOobes6KSm1te90jx4zGT+10O/yHwiFJuX+d2laYGZltRSvs0HilbQkhW/rgexcQ
         GNMwF5CiSGe/2jQMVJvrJXAHvkCluoUoJRperjbVF9eOIvetr30WEkpnV03Ierh+9i9E
         ONExAocAHSxDRAEKUHbd7I1K42nlVAxH2cYewU0r1qiuDVNSLz+G8Eaa8Hz2lBKLQ7Th
         BkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJj2jKLrKWKYCL3G0JVCzxE24zzw7IepY2Hipgb7xdU=;
        b=SpHHc8mK1TYmV+g81wPbD/g5S7dcHoZmIN1TYXwMpDE+ztjAdlQjpd8GX8ZRFPjPA/
         Bm+YD3jgrXFpv0DVW8qDCwQ+hXeJvLdSVw5EKEi3JkWbS3kpCf/sgQ3kgPun2fgt6aSw
         NaJUUIFIzuqHZTFiZEfh2tSyIxpnloT1+zCnAtjZ9oxC0elWo+dIvva820ib0jHsc9cl
         wWSqJS53A8jifFQbx/umXeZ1+0xsUBJlYnzQzO9ekEgp6dix8dhabZgj3T2Eh4bpxkrz
         logwyTlnhJkX4XXKF0HT0p7AYjH429tIFG2Srw7XjqTTi/KpqskQ2x+AGgM3didOAztE
         ilFw==
X-Gm-Message-State: AJIora/tQtnkRINcCLNnLLtFhMgFpK4tXfS9GpyJ1pKrSrmZsg7v35dT
	TtbayaK13Un0Fa1uw35c8tkKtH7v/XpZhDiQhYZ83g==
X-Google-Smtp-Source: AGRyM1t1LNe3ggUGTtV/WfBEzzJamFsd40RNO/gCCttMTGrOCrn1bQ/LPwHe0A/36/p2hLFpcB3urShWjF6qtQ+zjFY=
X-Received: by 2002:a05:622a:1351:b0:305:2e58:939 with SMTP id
 w17-20020a05622a135100b003052e580939mr1422121qtk.295.1656116983913; Fri, 24
 Jun 2022 17:29:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220625002811.3225344-1-swboyd@chromium.org>
In-Reply-To: <20220625002811.3225344-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sat, 25 Jun 2022 03:29:32 +0300
Message-ID: <CAA8EJprV_wqFrG6TVV0SAyxN9WHfC-vU-B_31toiWOYMqeNeUw@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dp: Remove encoder pointer from struct msm_dp
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Clark <robdclark@gmail.com>, Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, Kuogee Hsieh <quic_khsieh@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Jun 2022 at 03:28, Stephen Boyd <swboyd@chromium.org> wrote:
>
> We don't need to stash the encoder here. Instead we can simply pass it
> around as an argument.
>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>  drivers/gpu/drm/msm/dp/dp_display.c | 4 +---
>  drivers/gpu/drm/msm/dp/dp_display.h | 1 -
>  drivers/gpu/drm/msm/dp/dp_drm.c     | 8 ++++----
>  drivers/gpu/drm/msm/dp/dp_drm.h     | 2 +-
>  4 files changed, 6 insertions(+), 9 deletions(-)

-- 
With best wishes
Dmitry
