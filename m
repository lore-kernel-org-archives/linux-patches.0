Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD7DC8C8
	for <patches@lists.linux.dev>; Sun,  8 Oct 2023 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZtDDVbPL"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5041bb9ce51so4674607e87.1
        for <patches@lists.linux.dev>; Sun, 08 Oct 2023 07:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696773689; x=1697378489; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFEz00dZt8b8WAE9A9YPgyljR1B8wQKrMenQPX4nHKw=;
        b=ZtDDVbPLNx41SDQbTsA8p56wphjOI34/obCf642kf8YEy9WmTKyvQFscJ66Dj2uuhH
         9cgTa2RSpNi4igDzQrsvv68eKNZ9po0ukvftHrURZ+TKNN7aUI+aCWyTBtjEFTtQ7jPX
         0KkWoavLZU5q5WkgMyjXutOFBeupw228Cue/cAz6SJljjZiUxGY6A7fNQLxBaKSKinX6
         OQdcg4S8N7LH7F5kJA1kdaCD7IzRlSWXtlmW835iaPN4fsGl+xY4+dezQPtWONUwOwkl
         /eJTVRBqsEBcEhEQbYVYP1XvLiuHdPk37VrI9Gbuv4h4xvAGMPCFUyqztaBbPMjROeqB
         y+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696773689; x=1697378489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFEz00dZt8b8WAE9A9YPgyljR1B8wQKrMenQPX4nHKw=;
        b=GoLQaWoPh7nzqbwVy+8tyVHq9WabRwEBh4KmLpz9Ma8MK3IUhG/9ZFiHy0/LER4HLU
         P6d5B+4Ra4mvhfrD/rRaYyQLDDnUgjoF5fcre6PZRbngL9EHTCziI5diV9JD/4a17FZM
         iYLHsF/7p28L0Mlglp7e3nFvd8DuZwJN26f7RTllC7bZl1pWtCVNPKfAgRjP0tmi34Z4
         akgTeu2BRbUtFO/9AjxMIju8UPjC17AsiALSeSVYp9dJlj+KzxJPy33PTWg3UsiXQbrm
         9UXyvNAbswu7nVYfXRBZW4/zGXIHPWhSVLSid7bsiXozYwlV74Xx7ecnSuLB4wXs+zQw
         Ui0w==
X-Gm-Message-State: AOJu0YyOIF7FHIx2W8Bh0EoeqbqbFlCHDW0wN/cmb81ggSgbGYsZqiDX
	b84k0Fzin0oQ/T0TLHfcN/Ds5g==
X-Google-Smtp-Source: AGHT+IFOU5uXWmhXrIYbhgEpr4JZ8+yZty98yxpFi9UjGcKnTHEbTZyEkAOOOPx1Erbruxp2wwdBBQ==
X-Received: by 2002:a05:6512:68a:b0:503:26bc:b08f with SMTP id t10-20020a056512068a00b0050326bcb08fmr13838821lfe.24.1696773688970;
        Sun, 08 Oct 2023 07:01:28 -0700 (PDT)
Received: from umbar.unikie.fi ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id q14-20020ac24a6e000000b00504211d2a73sm1080455lfp.230.2023.10.08.07.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Oct 2023 07:01:28 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Rob Clark <robdclark@gmail.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Sean Paul <sean@poorly.run>,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	Vinod Polimera <quic_vpolimer@quicinc.com>,
	Kuogee Hsieh <quic_khsieh@quicinc.com>
Subject: Re: [PATCH 0/7] drm/msm/dp: Simplify DPCD related code with helpers
Date: Sun,  8 Oct 2023 17:01:20 +0300
Message-Id: <169677306906.2570646.11717295539692431609.b4-ty@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230829184735.2841739-1-swboyd@chromium.org>
References: <20230829184735.2841739-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 29 Aug 2023 11:47:25 -0700, Stephen Boyd wrote:
> This driver open-codes a few of the DPCD register reads when it can be
> simplified by using the helpers instead. This series reworks the MSM DP
> driver to use the DPCD helpers and removes some dead code along the way.
> There's the potential for even more code reduction around the test
> registers, but I haven't tried to do that yet.
> 
> Stephen Boyd (7):
>   drm/msm/dp: Replace open-coded drm_dp_read_dpcd_caps()
>   drm/msm/dp: Use drm_dp_read_sink_count() helper
>   drm/msm/dp: Remove dead code related to downstream cap info
>   drm/msm/dp: Remove aux_cfg_update_done and related code
>   drm/msm/dp: Simplify with drm_dp_{max_link_rate,max_lane_count}()
>   drm/msm/dp: Inline dp_link_parse_sink_count()
>   drm/msm/dp: Remove dp_display_is_ds_bridge()
> 
> [...]

Applied, thanks!

[1/7] drm/msm/dp: Replace open-coded drm_dp_read_dpcd_caps()
      https://gitlab.freedesktop.org/lumag/msm/-/commit/f906b95755f7
[2/7] drm/msm/dp: Use drm_dp_read_sink_count() helper
      https://gitlab.freedesktop.org/lumag/msm/-/commit/284a245d8bdc
[3/7] drm/msm/dp: Remove dead code related to downstream cap info
      https://gitlab.freedesktop.org/lumag/msm/-/commit/8bddc2d12e9c
[4/7] drm/msm/dp: Remove aux_cfg_update_done and related code
      https://gitlab.freedesktop.org/lumag/msm/-/commit/62ebb19fb32d
[5/7] drm/msm/dp: Simplify with drm_dp_{max_link_rate,max_lane_count}()
      https://gitlab.freedesktop.org/lumag/msm/-/commit/a9905b469931
[6/7] drm/msm/dp: Inline dp_link_parse_sink_count()
      https://gitlab.freedesktop.org/lumag/msm/-/commit/d89ce4cdb7a6
[7/7] drm/msm/dp: Remove dp_display_is_ds_bridge()
      https://gitlab.freedesktop.org/lumag/msm/-/commit/b41c5ca70684

Best regards,
-- 
Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
