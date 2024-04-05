Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F476171BB
	for <patches@lists.linux.dev>; Fri,  5 Apr 2024 02:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712285793; cv=none; b=W/LpxQ6m/+8R43df9mFJygZtSDAlbagju5ZPl3+NyaXuAWqrRYlu9KnvpMxx+zed1o/sr38ROkuZ2H1HumfqxhfoQYZTszAkD6UTo1Ecx6bBqgDgLVAeBAEGt2gi5oDrISHXjTk6Tnmhq+9S7lcnKEJUMLEcWpDCPzPzTXqu0pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712285793; c=relaxed/simple;
	bh=kM6XH+bKgyVxIo9DuSq7aqXJXv9/t19xjoc9OIcTDSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTmSuDDM3Lwrqjidab6VusAh05tYvkGQfhhpDp0KqOsvczFhZlAgKlUQqW15Mv/Yb8aQuU6VGmCJ/exFQKb1fu9WVLXjoJFJPKZ1Zebq80MBYV0oNLQUhP58EygnjfXC/fSXBXveQYHVm2bVOzXRjqjZk7KA5mkIlSt/AH06UnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YRtLyQ1x; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YRtLyQ1x"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6151d2489b4so19492217b3.0
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 19:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712285790; x=1712890590; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dEsqNh0qk6wjxNfe1EBS/5T4PtCYN6iMohqr+1wRzko=;
        b=YRtLyQ1xEYsQOhrwJo1VPXz81k1wQeJrX1ZUs7kMEmp3rNZJyT+y1eRDnOUIuFl3Qd
         PJaRBK2ZqhCeXnRAN94p0yeztLnS60xThXKkBW9vFDE0MyfCdPyWsOjkHgIqoEAUxtNr
         4Xz4T/PQZZQwQpm63hE28W4T49mQrNnJ43Xv+bKaV9isLA195IcDq7J5XBN/A4y3U1+1
         Js9JYnMnzRIU0LoDjnvS1ydt3cnPCFAg6T2pkRc7OTIqbToV3WpgwRnlW+t6BRTtuN34
         FvXfGBn81VhAySnfA1lL+fiFD/fceZdbf7sxOdaIQx1V+kBLwCnFhiCsbUdE7lYZ/0CL
         xdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712285790; x=1712890590;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEsqNh0qk6wjxNfe1EBS/5T4PtCYN6iMohqr+1wRzko=;
        b=li8o1O/kOCFcp9ilDuMr0djisxXncDZYOdLPPWbqjbTYvga00uM20/rc2dbJQ4tAgQ
         yWiUrAIIIp89rT0Ik6nJEjHkz2Af94fDRKRwbZv2M2yS4vLRf8unUqfuR3wujalGgJkK
         eLI+DbMeQXdhSZMtzuCxH2BjPJWdOB8F5/20QqsXpc/fiYQsa9lUBR2iBJ5iF69YEAbl
         oOjw1ZfcqnMOEV/hzZhMLVfSaqIfVyd9V61b0brmODmRSuDLgTwDReMPqFhzt/VLMQeN
         tpfgyEM9SfUMU9Lr2t4HoEWi+ua5nyRPCn288y/oz3rhuMrguSol0j1rnbpaEmtTQkfr
         zTuw==
X-Forwarded-Encrypted: i=1; AJvYcCUe8crrpHizqNgZK/m5HX2aohpVQayuOu+uJmJhuzKtSqnoD37mQMiohTtx/jgWsvgDKpY09rDfwno4MkgGtf7Oq31ZiheBJQ==
X-Gm-Message-State: AOJu0Yxyl672ROKXCDSO2dA7Z1AzzDGkHs1e3IRu2TN3bieIH6RIyxIr
	J4TK3r/bphH+809MaLNS3tOnaryF9N5TShLy3E9Oc2stifaiAMgRRypJolA2Wllfh6akxw6JaJO
	qmabHHveQ2TIyIMt09gFaWtLynUIMv+aN9pJZjg==
X-Google-Smtp-Source: AGHT+IG4u2Lg5AEQseN8XhnyCdvNikS9yjicoQQjhDBxxVZhO/lMnvhSuSj5pAzYdpOCxOv9gcRM1CyMxY7VDXAbmhM=
X-Received: by 2002:a25:aace:0:b0:dcc:c279:d2fa with SMTP id
 t72-20020a25aace000000b00dccc279d2famr88256ybi.30.1712285790527; Thu, 04 Apr
 2024 19:56:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405000111.1450598-1-swboyd@chromium.org>
In-Reply-To: <20240405000111.1450598-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Fri, 5 Apr 2024 05:56:19 +0300
Message-ID: <CAA8EJppHXkTNSNaCoYWZaRmKw=AfWL4N0WCqR6uFgNdbkw4VUw@mail.gmail.com>
Subject: Re: [PATCH] phy: qcom: qmp-combo: Fix register base for QSERDES_DP_PHY_MODE
To: Stephen Boyd <swboyd@chromium.org>
Cc: Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I <kishon@kernel.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, linux-phy@lists.infradead.org, 
	freedreno@lists.freedesktop.org, Douglas Anderson <dianders@chromium.org>, 
	Abhinav Kumar <quic_abhinavk@quicinc.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Abel Vesa <abel.vesa@linaro.org>, Steev Klimaszewski <steev@kali.org>, 
	Johan Hovold <johan+linaro@kernel.org>, Bjorn Andersson <quic_bjorande@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Apr 2024 at 03:01, Stephen Boyd <swboyd@chromium.org> wrote:
>
> The register base that was used to write to the QSERDES_DP_PHY_MODE
> register was 'dp_dp_phy' before commit 815891eee668 ("phy:
> qcom-qmp-combo: Introduce orientation variable"). There isn't any
> explanation in the commit why this is changed, so I suspect it was an
> oversight or happened while being extracted from some other series.
> Oddly the value being 0x4c or 0x5c doesn't seem to matter for me, so I
> suspect this is dead code, but that can be fixed in another patch. It's
> not good to write to the wrong register space, and maybe some other
> version of this phy relies on this.
>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Abel Vesa <abel.vesa@linaro.org>
> Cc: Steev Klimaszewski <steev@kali.org>
> Cc: Johan Hovold <johan+linaro@kernel.org>
> Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
> Fixes: 815891eee668 ("phy: qcom-qmp-combo: Introduce orientation variable")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)


Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry
