Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0CE66ED
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 21:20:59 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-11cb3c811d9so16685353fac.1
        for <patches@lists.linux.dev>; Tue, 23 Aug 2022 14:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc;
        bh=cE/HKSS1gcJ/bSLjCPtdvFIQrahyJdohXOdk9AJy+aE=;
        b=mdjPFrvRatkM6bSBrHyob39+vqOAM+OJ6yFbe7pKnEtneYvZ3AEyvA06mzPFI6C6xz
         b7wJf9XlaDnvGBReC4O4PjzPxfIqTp4enKLhhjyhON7LiW7T6rDerkr9nyN5k1uBDb7Y
         1V6kQ1zGUz+p+3DtkgHtsAB7vf+Cws/EsgFFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc;
        bh=cE/HKSS1gcJ/bSLjCPtdvFIQrahyJdohXOdk9AJy+aE=;
        b=ETXYLVg1Sx1hJ/+Ds8UQJPqifXRKqvDe3RsVEu9Pz1k/zNygOxgAtmqFoKjip8nHrK
         B9U8Vq3ywJ+NW47P++z8H2myDrK4Th0NvrBU87CwVy6G1OHFs3E34dmkjdhp6Hah/9VM
         t3V5dMhSLZfPH/cfDLPeL+WjS4dxbriEZTBSIUPfts7V3TiUjhI8Ou6hO/D+XTTpcs0Z
         1nLLWJ8mbQlPkZiVulNPoFymc6BkflKzmUdT0TKzs1eJHVc+e+cTyqq9Dq8jZHSR/Jug
         Ozr+VMsiEhVtfY7t4w/d1cIUjk7UptyTUGRBU8jHY8L+Rofyv4WsD4OCwXyNKh5srOsR
         Yy9w==
X-Gm-Message-State: ACgBeo3YTRfqk8NWCC702aMEcKt2Xga0p/aj/BJwiIon2FqTN6Fqf/hZ
	MlhSggtRFj4u56f7+BV+6LxvfbMiMv26jfGWxzYiIg==
X-Google-Smtp-Source: AA6agR4QQoa2UfnPHO//dTdnEb86cOYZdqaGouJSF8NHaTF9PTibAwUV01BupM30k+6j+7cZ0tchO0CNdnY1ihMsSfc=
X-Received: by 2002:a05:6870:a99c:b0:11c:2c37:3d03 with SMTP id
 ep28-20020a056870a99c00b0011c2c373d03mr2264277oab.0.1661289658829; Tue, 23
 Aug 2022 14:20:58 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 23 Aug 2022 16:20:57 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c8a2f675-4d69-58f7-a603-5e810f0077fe@quicinc.com>
References: <20220823024356.783318-1-swboyd@chromium.org> <c8a2f675-4d69-58f7-a603-5e810f0077fe@quicinc.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 23 Aug 2022 16:20:57 -0500
Message-ID: <CAE-0n50YsdeipC=shDnhyTbHaCctGEmZixLKzcb4DyOng5QhWQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/dp: Silence inconsistent indent warning
To: Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Rob Clark <robdclark@gmail.com>, 
	Sean Paul <sean@poorly.run>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, Kuogee Hsieh <quic_khsieh@quicinc.com>, 
	kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Abhinav Kumar (2022-08-23 10:47:02)
> link->request.test_lane_count;
> -       link->dp_link.link_params.rate = link->request.test_link_rate;
> +       link->dp_link.link_params.rate =
> +               drm_dp_bw_code_to_link_rate(link->request.test_link_rate);
>
>          return 0;
>
> Since we are fixing up this commit, can you please fix this too?
>

Sure.
