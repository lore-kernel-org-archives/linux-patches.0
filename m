Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A223D54D
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707565913; cv=none; b=aeMafTTIzdWumTgS/6ZRg72L/WLsareLubhboo6lkolgnS0c4rka8JAKBQpHqwYVUf6sBj2gAA0hk5lmZalPshHnSbhAswhBzER93Hgml6JaFuqskp7CA+GXwdZQ38ZvZk8wilIqpZjobpphxTngqy4FqzalLRXkhyrQwZnFAdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707565913; c=relaxed/simple;
	bh=7rc3pZKZQ3h12KuocOBjke7RPf57CY1ulO+EwZZN21A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GourNhyEJnZhLkpMFLXN1kjwT/IoovK24corHwkHoUYIJIvE83v1h5N15cL3WLAT8oselyvAU7WowXDqG89B5yEiP6JggsgEv2/kLzYAEhLKv8GGgZpENPtXrj/UC6x0s4AAmukBpcks1wrRemv+g9fqHSlhiX85EcCAupsW6Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bh8odkm+; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bh8odkm+"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dc6e08fde11so1921094276.1
        for <patches@lists.linux.dev>; Sat, 10 Feb 2024 03:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707565911; x=1708170711; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/RWQV9SF+U2wQY2whqhrKlZUzNhMlpaeidneMuAvWr8=;
        b=Bh8odkm+giSOg5+1mHydLdjVBXWlC2ve018Df5LnQW9LBv98taelqmpR4TO9a83Fxo
         xwEYT5wnw0IKmV+QHpaNVvG9bkIh57spLXGoerIB+MqoYnXaDd9Mped00TYGwgJrVayH
         282nUEe4Uf0FTLU0+O9UBukMHHR3VKrm7gdYfYGtBmLGhxfl8miRhDsuIhvPqo4I+kI5
         Qiki88W7TQApM8gEX4zsT3StFTg/dXW4M/4ulufmHq1ra4eXirk6MvnwOQ+JsgAi9tiJ
         GqKHRVLFDXix6Ljo2KCECWjIzG1NqQHSOhU2MacKGM7q72wZ4r66n2W/QPvxaxK2MmSS
         6RDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707565911; x=1708170711;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/RWQV9SF+U2wQY2whqhrKlZUzNhMlpaeidneMuAvWr8=;
        b=T+LABhdcLxlwRmSDq2PneDt/MY2aMrw3Hh+PGTD9nLfibyc+tG6k6u3Jn+p7jKtBy2
         0bjPjHKPQS92flwoJlVyraRglEhRBLMzqyw9fqusGi/OMXYtlXA/iCgiSgg0H1tBw0h7
         fe1msWfiTo+5Xs11JtIuPWixIHAClhvi6jy9KmoDjy7jsZc0okMpFepCg0MZNXViIxJ2
         ++De8H0YWfuCfZbpQlCOE7tJ5c34sS6V3LBUKoaIHyGzKZh6rK8JDcVA0kWevyCuWjgO
         1Lv9KTYQ3mSQr6tC1pLUkx9LDvO3wy+DMvFjREQ2hBWLEWOgDCQAed7TiAnspnBZx+1D
         6EFQ==
X-Gm-Message-State: AOJu0YzLYFlNS2DpqQRXBJT/mekKtlcrEK9zA2Tf7SwbXkiY/X1hN7os
	7MpKznN9XCaGXb3yxsQvo26ybqBRDcAwYJbZtTKhFssEFm/uBO0YrbXPbt5ZbRxhA8MjFkEQNW2
	lMWAoX++B0rjlQfFaJEfcoiDUmQKHcbulakHYVA==
X-Google-Smtp-Source: AGHT+IHFyIHD774MV2fP+SnSwgZs21+HYOwYBlaQnlLEfF4zRO80UDtJtaZAZIQJ+wWMOfEhJRsDBXclS9ily9CzMOU=
X-Received: by 2002:a25:bf8c:0:b0:dbd:2b6:6cfd with SMTP id
 l12-20020a25bf8c000000b00dbd02b66cfdmr1415270ybk.2.1707565910913; Sat, 10 Feb
 2024 03:51:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-21-swboyd@chromium.org>
In-Reply-To: <20240210070934.2549994-21-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Sat, 10 Feb 2024 13:51:40 +0200
Message-ID: <CAA8EJpoS3+NJCMnR3HhGrh73W39ivz9O6PX3Fov_an3cY+sLLw@mail.gmail.com>
Subject: Re: [PATCH 20/22] arm64: dts: qcom: sc7180: pazquel: Add missing
 comment header
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	cros-qcom-dts-watchers@chromium.org, Andy Gross <agross@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 10 Feb 2024 at 09:16, Stephen Boyd <swboyd@chromium.org> wrote:
>
> We put a header before modifying pinctrl nodes defined in
> sc7180-trogdor.dtsi in every other file. Add one here so we know that
> this section is for pinctrl modifications.
>
> Cc: <cros-qcom-dts-watchers@chromium.org>
> Cc: Andy Gross <agross@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: <linux-arm-msm@vger.kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


-- 
With best wishes
Dmitry
