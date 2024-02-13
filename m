Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A191F63099
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 23:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707866668; cv=none; b=fMzNfYW38OzY5dWZcDh9VGewRKvY3hIl9yUr/E19ldqjeIbK5/VLUaWenXIky43pPyVwRNnYZJV3UYMzA5UXgt/DROTR4k907HWkPmgZQPgkxVwWuw7TN/9Y/cxmukmibZUEa44qWgwD1UdMCNI8db0G0J1t2N+rDVRv1PB8PPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707866668; c=relaxed/simple;
	bh=SNOVFhian0wSmfjQUWbhIZH1oLKhGuatN3RQQaM/zI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DTfIU2MgsmMOhPsLUkPMjipvQ+gxpfAk+u4ONueZSyTqoWizMoTpoXkzFyMQqWp9w4BopU6NUX18xiSKUFonBg9JPF2WjyntEcnCMiNUmVihCCZm5TiQRzEDQf+QMSGoVwAmiehFVJh1P9opGoRm88zbet9CLwVGq6akTToSXoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=e5oZr/SL; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e5oZr/SL"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a3d39b2c269so21734066b.3
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707866662; x=1708471462; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyzkdDn36VkqM4HUW3/5Yc8FfYXf+Vgri3xwPCVSUsQ=;
        b=e5oZr/SLT2iVLvFq8KnKF3IJnPfpNrThTRHTzJA4R0zTJfJJeucXOhB1eAlJ4N3DUX
         YJYxItnC25FbQz4Tl8+MxmOPCMJ6jPPYUplbyzjXE3EITIKLWKhZBYFnaKlTWqq3eNhm
         0xgeoMT9SYIgpq3hWlCGPqnDwE6zQPCX3HUSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707866662; x=1708471462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyzkdDn36VkqM4HUW3/5Yc8FfYXf+Vgri3xwPCVSUsQ=;
        b=J6OO/wJHpXkchv2zURaWIMd6izbA4GRvROFXTvwAb5fa6aG0nugHDZfuTJOhg3Gn7N
         Kq4ej6wM2b5Z0u/GeverKJ5qkdQwIhMmj92zYDdD4No8kSNmL+0lxoAMHin4Wt+kUSGc
         bL6FzMED7FOucQn7l/zDfrnHJWnfL6oTdvMNa4cSITV6H+KxDz5JVV1IcQI4ZHadRxs6
         BZ0ivhIsCO0yViH896folrkAPs0lk09qTSbKvDru7WkBpOosnagp6AipAf0R/Qoei/Hi
         KP24wVLre8GId6pIlPltl4cd1aMiGlhtBRT9byDk5sj1QVCCkEmATwKqZ3+4A5mkNtTz
         470Q==
X-Forwarded-Encrypted: i=1; AJvYcCUpmMaoIMrzHSpfKNOQ6TYPPGlogpSM2/aPr/qa4kcgwYja4Pe2vbho5hk7JI9O0EcD+3b8oZc5uZsypyRHWpj/awR2b7bIwg==
X-Gm-Message-State: AOJu0Yw7xrTeRNOwKSUBNrUWQZth+ySMaEd5D0V8xscYMT8+X0speCSC
	uOTMqRcyHbMChVCjz+AXG2aeCoCJQhDY8Z4ZkMqYXsso3EtedMA0mhJbjRs7Vy8fLAxoDUQu14R
	JoBVn
X-Google-Smtp-Source: AGHT+IF2p4VURA2kANw7WRiuSQHxNEKJPqt7csrzfzzXAtNOC/vWvOOqurRvVXHv3pAyh6Oqjr/7ng==
X-Received: by 2002:a17:906:f8cf:b0:a3d:421:c2a3 with SMTP id lh15-20020a170906f8cf00b00a3d0421c2a3mr534177ejb.24.1707866662365;
        Tue, 13 Feb 2024 15:24:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUYGkkVW48VbJ5webbtxnf21WmVYylWKcS0vK5eKto9/bCiKQCreoVc9SVIBf2I0fQXuJ1Go0/urPgtujpz/PSnnXEhxgYpOg==
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id rg14-20020a1709076b8e00b00a3d1b3c5f1esm678609ejc.77.2024.02.13.15.24.20
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 15:24:21 -0800 (PST)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-410acf9e776so96375e9.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:24:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUABmUdfjSvrXn4H451LsCRY5nDF495/bIgTJ5yzGwWPVojZCgA5svK/9M/r995osFHy/L17sx+O+e1el08kCxFaSozMpIHNA==
X-Received: by 2002:a05:600c:a16:b0:411:cf85:9549 with SMTP id
 z22-20020a05600c0a1600b00411cf859549mr57493wmp.3.1707866660353; Tue, 13 Feb
 2024 15:24:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-20-swboyd@chromium.org>
In-Reply-To: <20240210070934.2549994-20-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 13 Feb 2024 15:24:03 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XxX9wqZdwf9Wtq2=KOKgTr5FhyJJWp8S9W1xFW3cY80Q@mail.gmail.com>
Message-ID: <CAD=FV=XxX9wqZdwf9Wtq2=KOKgTr5FhyJJWp8S9W1xFW3cY80Q@mail.gmail.com>
Subject: Re: [PATCH 19/22] arm64: dts: qcom: sc7180: quackingstick: Disable
 instead of delete usb_c1
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Pin-yen Lin <treapking@chromium.org>, cros-qcom-dts-watchers@chromium.org, 
	Andy Gross <agross@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 9, 2024 at 11:10=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> It's simpler to reason about things if we disable nodes instead of
> deleting them. Disable the second usb type-c connector node on
> quackingstick instead of deleting it so that we can reason about ports
> more easily.
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
>  .../arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Bjorn: happy to see this landed any time to shorten Stephen's series.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
