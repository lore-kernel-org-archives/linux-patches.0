Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7372437714
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 01:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171485; cv=none; b=muGKBCj0VVBAnZ0Fq9hnRlq2VkuLHlYQrofFesXmhJrHwUz/FbUVzXX8gv6bbSe7kJVhQE1Dg56Y2cXaO7IBY6Tv5f09BQpfgX8CBpRwAe8OuytLm/luMcU1wD8Lp3VXiFdhrzH0/S5t2sJ/dBAB3wpBiFl578ZFZLxAUl3pl1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171485; c=relaxed/simple;
	bh=dyNQOsNqoX691z3lmsUE0UqeK3j+5UYGTMnTcRHjwiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eP2Ep5FiRaJAEnmmcDLOCGgccY1CpZtgb5vdcv4tzW9fg4+D4CIVXwGBF0kaZ8qBy6te6UYlAbm5sEwoxGfhgW91l0RT6e6KLqOMClHftlQoJeNl7WfNHhKKAMieRlDouauWUCWDnuy4L0vyLQ3mYvww3YZDx5qaWGVZgu4JpxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=h3Gwg93c; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="h3Gwg93c"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56682b85220so700425a12.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709171480; x=1709776280; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BA3HNtaKQLlopR5HvEpA7g8ezYuwOK+W5LJ79NFDZrw=;
        b=h3Gwg93cIURFNP4ENjw19KmKt74gqHZL9Ppv6FWpemDnIEoUTSO2aqffBpfpMH263o
         V/LehpYQusdkK+kdSaNUEfyJkrAdI5Dhx3B6wLSi9AxMF8wF3rO4zajlAl3hSkUG6szd
         6mb666gKeYRyXFMo2tK2+G0eBCmCgPoLbGlqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709171480; x=1709776280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BA3HNtaKQLlopR5HvEpA7g8ezYuwOK+W5LJ79NFDZrw=;
        b=ZOClIcsDR44fZdBhzImUlyAlJVVel3dO5yfuXxQQlEeOaB+UHwz1VzkVBTL7eO91ZX
         ZRQdijMkieB6PdR4JpxjQbELTNO7fwRbBUtb9ICXSLQDwxC8+ljrYOgCEoeT6sbFsUfh
         n7vfQgVCFVkV3uf+MCJhwKCMPvt8IjIgfdugPjkwsb+z0KEX0yEu/rE0ZoUHd7yYidju
         oY6K6RviY/0RWX+Oo9UfC98mK6pAOUbqNmxOF1Vg42IJvoYwsDVnL7rsLlG/ZEZY+S+O
         wTKW64TcbiM67UbCeGYSUhP0mNoBC6hYYpVCtXKK3pcFBcSeoIseZKeH+TktMwGZLbnq
         NuhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVUR02sxfAoq8WkN5fQg2NLrOuA6riQKU8BuiFG1m7wnbLEIUTRjPJ83TsGSaN5B+cGmTbR3vwtCiPd0lt3XT25ADG1TXjFw==
X-Gm-Message-State: AOJu0Yw7m3SKwaRg8OP+sYHCjUj5FlewHFSs95axpX44Z7uMZBOlT9II
	sPCC2BMOQzvOUhNlWbOQY5P9EgH4tzQI6VUQy40CKstIRJjIG30MHFwqBLGtYrpAuDmEsK6dkto
	lXJOj
X-Google-Smtp-Source: AGHT+IFq0r6axz+CMgoxOTq0TG2/frtizfGFPw6fZs7x8f62qpHpwCeNUADAv0b6/b7lyoxKGGUL7Q==
X-Received: by 2002:a05:6402:1e87:b0:566:4ccd:b81d with SMTP id f7-20020a0564021e8700b005664ccdb81dmr480182edf.7.1709171480061;
        Wed, 28 Feb 2024 17:51:20 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id i16-20020aa7c710000000b005662e63cbfesm118043edq.55.2024.02.28.17.50.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 17:51:19 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-412a2c2ce88so19495e9.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:50:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUEYpo8dS/Aywdasgdxe9okcLpdbWotxm6ix0SPsa+f8oOpwQFtbcxohU8Fm7qcZ1aE229xClXpsQYn2jg91CKNTgDrvaqiuA==
X-Received: by 2002:a05:600c:a384:b0:412:ba22:fe90 with SMTP id
 hn4-20020a05600ca38400b00412ba22fe90mr11378wmb.7.1709171458829; Wed, 28 Feb
 2024 17:50:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229013503.483651-1-swboyd@chromium.org>
In-Reply-To: <20240229013503.483651-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 28 Feb 2024 17:50:44 -0800
X-Gmail-Original-Message-ID: <CAD=FV=Xba76ZER=rqWm8H6dQTgkTRM38Edi81Y8-QXETvsmDCw@mail.gmail.com>
Message-ID: <CAD=FV=Xba76ZER=rqWm8H6dQTgkTRM38Edi81Y8-QXETvsmDCw@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Disable DCC node by default
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, cros-qcom-dts-watchers@chromium.org, 
	Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 28, 2024 at 5:35=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> We don't use this device on Trogdor boards. If we did, it would be
> enabled in the sc7180-trogdor.dtsi file. Let's disable this here so that
> boards with t he sc7180 SoC can decide to enable or disable this device.

s/t he/the/


> Cc: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
> Fixes: add74cad7c9d ("arm64: dts: qcom: sc7180: Add Data Capture and Comp=
are(DCC) support node")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180.dtsi | 1 +
>  1 file changed, 1 insertion(+)

Seems fine to me. I guess the driver never landed, but if/when it
lands then it makes sense to just enable the device it for boards that
need it.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
