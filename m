Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E1C6CDA6
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 21:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711401405; cv=none; b=tmq259Fqtguwgr4xYWnfaNw7Wy1mw4+t3w1Ckenezy5EviXGWjGz5NIuh1DVocc3pb0BgakakY7ps/K8cYRqlNpyh0R1TMPfwkTx16IN0MCXYwnONztCRHMbIofM/ftqj0ljMnlR96x1/DFf9lgsKPHp9l7Ok1veJwfOgCFL9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711401405; c=relaxed/simple;
	bh=XnYxg44n9UmMwx+BfT1Lx7/A6qiY0HCS3q4AwEZrM1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5FgjI9mxHbFAFUDQLwxBpDN+53yOre62nyLgYN9fAFevJGjmbTskVIWgk/cCSiLcdcjKcMrXWW84jom5OgpPM7iZdavRrdPBlhEsgjqksXb4MaxsW1rCEZoBWOiBPpGPmM+wQErR+jVhAEn4JIJ7gVLgPRjLQAyKsCqZ7804iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NCY4UAt/; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NCY4UAt/"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dcbcea9c261so4859638276.3
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 14:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711401402; x=1712006202; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A8IFRn6aSsHl1VGtupM1OXfTkfRMf//PoRLv8D0xq6c=;
        b=NCY4UAt/8JmrO7JrmcmWYgCatVk8TiGojPSz0xSdG1W9El92CtN+iWlDsoEMUH7uF3
         Tt67vUBXE2zYZXQvCsWaezzWbSm5O0t7u4TkmrTipQiyeIrh90fR8kpLyegh7YtZSLzB
         7SXey5ly0OppGz7a1dwtXQT5RGV2GaTJmTKIR+s0+bFq7L1eUZwYL0aZlY3gBFpNdW+8
         UpxwtRxkYhiewwJ4IsI32ws3bDwlA2niLiMlWy+vHMz0t2dalxqT6PgRu4UsOMbPNlvU
         UTMlZlysUaHbnKWGfXLNtC+eng7S0oR+oVub+ivoSv9jGbVFhw3cVaAeJf55eSxnlNb7
         IuKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711401402; x=1712006202;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A8IFRn6aSsHl1VGtupM1OXfTkfRMf//PoRLv8D0xq6c=;
        b=kuQuSvXZ3jknXUoMM8w30eAhrEH7wLv4GRMc/u74qjs76Ty8JE6QnZep2eUugOWRH1
         c+lu8o4WxXfeoLUbCb3YZ/GXSPEO+vdANieo4EwKpWtt6/6X7xrg+M/ZKhCexPV9vMEI
         fKSOhrA1UXCulQQZF69G1WoIpVhTEjJp1FpO/yl+q1W1R8asW7fmTkXloj2fGFIGa8p8
         b2CW/5FHMgG9txNoP+nxAfcPeBRWHTkGXDZ12Q3r985vXiqe8iiP3ICj3vIf4vpIpT6t
         Q3emdSrjSrx1hSVdDOT9G7pAGHGCU0kpN4ZIoygoCZq3fb8X9Zs6Vh23UNEkWDGfLIPH
         7zOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1dMqShOIHFa6ZHQ38N49sD6qJ47PX78WvKPjC0NOGLw4bu2N8os0tb8jtCWK7MOgFdsjQ7G20LvBtfRINntoEn2Yr+wCV7Q==
X-Gm-Message-State: AOJu0Yw9/KBmGyIyFb4A28nhcKV0VM0yPCvzgRM/SBuk84rgn7Hp2soJ
	vw9sfai0g+2schnXohfpMrL63NKc3KPp54J+m6RfP3tv37/NRhxIGquQJ7e0qKrJrBRLpRZRuve
	tYkjCrSaud3CzbIqoa0ongK6vy5vt5GKIQDowBA==
X-Google-Smtp-Source: AGHT+IGmfJuEEZK0xXYu1atPPd7gdTrXAHTMAqXWgAFibdrfnqzHArI0XM86kbZ4hMgAFB1mDKzR3VsuVkcuM2xu2sk=
X-Received: by 2002:a25:a1c5:0:b0:dcc:52dc:deb5 with SMTP id
 a63-20020a25a1c5000000b00dcc52dcdeb5mr5391964ybi.20.1711401402341; Mon, 25
 Mar 2024 14:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240325210810.1340820-1-swboyd@chromium.org>
In-Reply-To: <20240325210810.1340820-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Mon, 25 Mar 2024 23:16:31 +0200
Message-ID: <CAA8EJppFc7+ca1JA9cbtAEV3+Ln6BoTkzdqyq88_gfN+m9fiPQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Add newlines to some debug prints
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Clark <robdclark@gmail.com>, Abhinav Kumar <quic_abhinavk@quicinc.com>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 25 Mar 2024 at 23:08, Stephen Boyd <swboyd@chromium.org> wrote:
>
> These debug prints are missing newlines, leading to multiple messages
> being printed on one line and hard to read logs. Add newlines to have
> the debug prints on separate lines. The DBG macro used to add a newline,
> but I missed that while migrating to drm_dbg wrappers.
>
> Fixes: 7cb017db1896 ("drm/msm: Move FB debug prints to drm_dbg_state()")
> Fixes: 721c6e0c6aed ("drm/msm: Move vblank debug prints to drm_dbg_vbl()")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>  drivers/gpu/drm/msm/msm_fb.c  | 6 +++---
>  drivers/gpu/drm/msm/msm_kms.c | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)

-- 
With best wishes
Dmitry
