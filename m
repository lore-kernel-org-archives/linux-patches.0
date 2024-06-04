Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04781442FE
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 23:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544843; cv=none; b=pWhb5yrYgBzkSOACeum8WGm4o0WyvMhISYYsSkrjeByRRHPXmQksulcySjH3ccYdP1FKT2INRV5yuY0k26I5P0rWJeESMXGR5fmE/xlHBwiET60fO256Uqwi7upj6HPZDl8nwv5WV6wKVxQmgIwzQWYsEuSHSAs85O+MUdQvK/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544843; c=relaxed/simple;
	bh=mmylbRfB4KEKXyGBeR6H9S03CC6T+tHFQPGAlkjagrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrCmo2Xdm2s9VxireWaifJZdNxQjkp9EBndzQ2/U2+LNJptq5Zvxm9t0adQLakXvMgjHb1bTxjayXpJljOwE9tlwYKFpoeaB2hJT4alYtak5dxHuvp5+ieq3KOLLySF08ehS/XEqZMkUHYYO3QIrr7KfbFahd9eiIvSCv65NMsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Wl6I5jtn; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wl6I5jtn"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52b88335dd7so6164860e87.1
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 16:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717544840; x=1718149640; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBt8eFQEo5ebAofL3QZI5AwFoi6fSHWEjf2SqXfLAIY=;
        b=Wl6I5jtntlABaPuMtzdtJJeNwJrFnnI10cfntAVqhNzz1Vzcu3ISA4ApayppiFln27
         EPXYXn+005Z5zdhBvHU5bvzkbwDE4w4VoF3cBaATqilOAXo4v77Wm2KAlZJZ1pkKwp32
         VsimWmZqN/k81wbG+DKX7SBXN43REbs0Obyc0GtSZFVKd6aivUt/Ok+e/MTV683M/EAH
         gwycUdCDfBW8lLbcS7WuUo1Wdhtb4U76wuEj3FaBH+wtGmvNxRrJ07lfGsfGoD1zxvLQ
         I5j6+c/LcO+Kiwk7YQbni+l2JwUqTdfOTuEDrPeR1R7P4FqSYzV5cjQWbYniwmCfmgQ0
         SIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544840; x=1718149640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rBt8eFQEo5ebAofL3QZI5AwFoi6fSHWEjf2SqXfLAIY=;
        b=J0W2rHZtcrytdHJvSr/wsLbewuiiH78NqY71sc4JtTg6bz+j8toNXgWdz+g52Jctw0
         UJ7jHbyNTreoOJ5Bdf2P6ksYfLeEAjcwbH421smjcs0dilwPZtfELwmM8A3eNsdIvNL3
         xZ5yKAh/FZnO5tR0TqEIianXoRvLJT9A09D3uh8HfDrEvJobjRrso2j7PjFntwvHEuCd
         o3ouRYkDAtCYgp0wWZ7qbZcQJ5+tidDZ3g7TckckPB6e5Uszr7FflRoZCBj6XxB3KMQu
         8x7quGOhCQWjNIMIDRCGtwCAzwvP2w2XVguP96iqOZfPD0ikjTSXrrt+1tGR6uZmWbVP
         vhWg==
X-Forwarded-Encrypted: i=1; AJvYcCV2BPfEiCJiEv2kj8ljkR19/j6PG72DkjxZB8FDgDTUjKlUdLYkDdDjcuKjjw1RkOPggYaed2dzPZOAVXR6YWxLeU3PYCsj2g==
X-Gm-Message-State: AOJu0YzuEZRXB6hQZW2baU5HAEytW7f5AOj9TO1XoCGqAQ8udNw+eiBU
	2kY/aq+tCg8sKTgtDqv3enSLHfHddYmNq66t1ve2zN6Mjx6s0h/L/mPnSUYWw+g=
X-Google-Smtp-Source: AGHT+IHbuLGX10F/ysmCrzCCkUQnoJywch6uPTMMgJQLv8uC1wFTg2UN7uiqWbEABiv2i8OZph92fQ==
X-Received: by 2002:a05:6512:12ca:b0:52b:86cf:91b2 with SMTP id 2adb3069b0e04-52bab4f6fbbmr565864e87.46.1717544840076;
        Tue, 04 Jun 2024 16:47:20 -0700 (PDT)
Received: from eriador.lumag.spb.ru (dzdbxzyyyyyyyyyyyykxt-3.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::227])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52baa95c304sm111154e87.276.2024.06.04.16.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 16:47:19 -0700 (PDT)
Date: Wed, 5 Jun 2024 02:47:18 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	patches@lists.linux.dev, cros-qcom-dts-watchers@chromium.org, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org, Pin-yen Lin <treapking@chromium.org>, 
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH 1/3] arm64: dts: qcom: sc7180: quackingstick: Disable
 instead of delete usb_c1
Message-ID: <4ksgrgsmbkze3m3sv2ikajvkv5asehzzhuw3c45hob275alvfo@yctbxgiv5oe2>
References: <20240604214233.3551692-1-swboyd@chromium.org>
 <20240604214233.3551692-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604214233.3551692-2-swboyd@chromium.org>

On Tue, Jun 04, 2024 at 02:42:30PM -0700, Stephen Boyd wrote:
> It's simpler to reason about things if we disable nodes instead of
> deleting them. Disable the second usb type-c connector node on
> quackingstick instead of deleting it so that we can reason about ports
> more easily.
> 
> Cc: <cros-qcom-dts-watchers@chromium.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Reviewed-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


-- 
With best wishes
Dmitry
