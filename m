Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A68D198AA
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 23:30:53 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-d7830c5b20aso1713030276.0
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 16:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693006252; x=1693611052;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ey6d5gZX4O+5Ormvdw+/edKbvFqUfGvPPdAwBns5XZ0=;
        b=YHweFZN6GWWe9k+V0XvG5rYvHDivYVgMTQvoLW7JqGs9V57KqEMh6nTzyqMyJL6+/c
         s140AfjtRqHCG1/0hCF6C9gMhAY+tEA2aYYkowHtj1IKRtu5k7c40MK1YyUtqmVqZAYF
         VDBXC2/ohxwnd83Z1nFnA2SIed4XNoM918BSHyBRJNkUQQXXB/AeV7anRnURqmWmj5oB
         DkFvwRIu8uavah6wkkOOelblaW4sDJRrCAVmX+IApCje0g0Myy2CIMg4fMoaVli9w6eh
         a4EZZyD/MlvDAiYn2i+hOeIIAgxn+ctWAVAlg9j4LiE7bmAxEmPctT1CsDKNdLFJKodV
         bgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693006252; x=1693611052;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ey6d5gZX4O+5Ormvdw+/edKbvFqUfGvPPdAwBns5XZ0=;
        b=g8ugNzlc9wtVOTysXgTLEWgjkfbGixIm5b1DojJTF6WRqsNUgOLmCcsubK1VQZ8xGU
         oP5zc0/E651y18dlRHn8+rlEUb1/iJ9Wddlhcyr6/rJcUoPaEwSaXqNR+NkW+kV1CDbS
         FFk0e4KVX1KWgvrNvgxkeJfFPxhPovCfrvUDF14iAkgIsO/7m8rslJ+7Cj1eVC/JvFt/
         i+UQXf+QJr5FMF2sIJR14iiyfqFXyvm1FEM78VaNwkEO7MCzg+PHmFFb9XT0t2VqUue6
         S+nAfQdyQbDuJW5vzsug1Nz1mQrypWkn66vkvpnuUl0G7PF3NLkrcSDGZvymPvQ/YqnL
         YIDQ==
X-Gm-Message-State: AOJu0YzsRSqDdpjajaV0DouyrnQB/mnF9BSqxKM7b12Z2GSVuDDq3r7e
	8C+3/FGR2G4w1LrmzYvrpzRwNHUzjwT8HT/4xcOe+w==
X-Google-Smtp-Source: AGHT+IH96iZdBFBpub3t9rZ+AHNDzp0KpWqQfScrAOFxIgwNDRNv8otji8p9J6NWQaVh/hdaQCLvseVk6BJ7yxkTnWk=
X-Received: by 2002:a05:6902:185:b0:d4b:a962:76a3 with SMTP id
 t5-20020a056902018500b00d4ba96276a3mr14239474ybh.29.1693006251979; Fri, 25
 Aug 2023 16:30:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230825230109.2264345-1-swboyd@chromium.org>
In-Reply-To: <20230825230109.2264345-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sat, 26 Aug 2023 02:30:40 +0300
Message-ID: <CAA8EJprmvczug0zxuhrHuK2kBYtnkLfkZmYwS78hdVRe8waDXA@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dp: Add newlines to debug printks
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Clark <robdclark@gmail.com>, Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, Kuogee Hsieh <quic_khsieh@quicinc.com>, 
	Vinod Polimera <quic_vpolimer@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 26 Aug 2023 at 02:01, Stephen Boyd <swboyd@chromium.org> wrote:
>
> These debug printks are missing newlines, causing drm debug logs to be
> hard to read. Add newlines so that the messages are on their own line.
>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/gpu/drm/msm/dp/dp_link.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)


Fixes: 601f0479c583 ("drm/msm/dp: add logs across DP driver for ease
of debugging")
Fixes: cd779808cccd ("drm/msm/dp: Add basic PSR support for eDP")

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

>
> diff --git a/drivers/gpu/drm/msm/dp/dp_link.c b/drivers/gpu/drm/msm/dp/dp_link.c
> index 42427129acea..6375daaeb98e 100644
> --- a/drivers/gpu/drm/msm/dp/dp_link.c
> +++ b/drivers/gpu/drm/msm/dp/dp_link.c
> @@ -1090,7 +1090,7 @@ int dp_link_process_request(struct dp_link *dp_link)
>         } else if (dp_link_read_psr_error_status(link)) {
>                 DRM_ERROR("PSR IRQ_HPD received\n");
>         } else if (dp_link_psr_capability_changed(link)) {
> -               drm_dbg_dp(link->drm_dev, "PSR Capability changed");
> +               drm_dbg_dp(link->drm_dev, "PSR Capability changed\n");
>         } else {
>                 ret = dp_link_process_link_status_update(link);
>                 if (!ret) {
> @@ -1107,7 +1107,7 @@ int dp_link_process_request(struct dp_link *dp_link)
>                 }
>         }
>
> -       drm_dbg_dp(link->drm_dev, "sink request=%#x",
> +       drm_dbg_dp(link->drm_dev, "sink request=%#x\n",
>                                 dp_link->sink_request);
>         return ret;
>  }
>
> base-commit: 706a741595047797872e669b3101429ab8d378ef
> --
> https://chromeos.dev
>


-- 
With best wishes
Dmitry
