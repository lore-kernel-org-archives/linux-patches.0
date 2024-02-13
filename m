Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC663103
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 23:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707866682; cv=none; b=sKYiqjFf+SNhKP1PIZmRA5Om3TT54Y9MwEbR9zEqBprbhx277j/JC2odBCc6KUipai2q+W6UQMZErgCTdLdIScnnSbH25FfR67v4rARxfapi0Ba8TEQRhoyqi0qhvZ9PuQKfUi0RhJe7knhXw13IKKiFZWcGx1ZFCG9BnDRjXMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707866682; c=relaxed/simple;
	bh=bcNZkTfy8xF0KWYq2Ov+PCZSbZ3Z6PXo5Nj4PAZaHYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q20Q7BX39Vponr9UQEzLDwqVpCSrf9xG4clbWA8L3ZvRJUeEFQ7+xMG5L9XljL0NFA7Xnr+EeIPdUMiwqmq4JwVWDKyZHKuvJyQ6KA8WzjjVAyk7m0Cg/98bPE6km5/nZpKDhf5X9x3VZf97fyD991CA/u5Yd0dfdFlMmnistcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=lF1fJ2bd; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lF1fJ2bd"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a3c1a6c10bbso427982966b.3
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707866677; x=1708471477; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owV9kvvQ01YV0IOM7V6TZ+A51SR1Xuk2YazbU2H7zpE=;
        b=lF1fJ2bdnnC9lIRIIze5yGngaK6tvldp6mMnmF3MfBX/m8r9Y+gR27BjvW5Y7mLs1I
         VLQ1qDlUZCBXyNm/3yrlSd123sHX5x33A1A82HVPS7lIFlkGuqI13VKwlrVRb10Q2LYr
         wZPMCx/9dYGsUBRwcVuHh7blREmgT2ijh7Vjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707866677; x=1708471477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owV9kvvQ01YV0IOM7V6TZ+A51SR1Xuk2YazbU2H7zpE=;
        b=Ivbof/YMdGUMt60uHFiHQjew3V5j5swHP6NoABvWKKJlPG7XNvFM4IRov8AJud6/A1
         Qr8wJ4Ff5tnZvNkB1fTh663lEN+D87Nc+LNq4rkm1vflCDYQ5qBUhdPTr6i1v4S9oCfV
         qhv5tWIYsT40fVFdGeT4HQvXQvtJUaVzY0qFzlGp4p3ztPtHVm33vOPWXiQ9hAdNf7z9
         p2CFuFv7pY9zepl4+Lig6duGzKEDLrKAWxGp5frRjZpf10fitfqwP7mA7+WEf+T74Sx6
         lfHtzGnvxbLala6bwmHwQIBtVXuf09yCR9GRPuvZ8y76pyRzc8bIyJidjlqqdcJw2KU/
         C7dw==
X-Forwarded-Encrypted: i=1; AJvYcCVrmCmWvV9inpZH02fw0sWEDSbeHTtqR4ubOTW7lMUrxHWclt2QJYBUvA1Ohgh2PWa7eMc18pA7CeC7+h901RfM1g6poALYbg==
X-Gm-Message-State: AOJu0Yy+YsCS7P6pfkjPsbsTSFyajrLoihRerq4E3wwllOy8jpF4af1b
	2PDnGOFOBDvKed+gAhYgkKdedQHApb15+YsOszNHEqYrHeGJi9ENbCQ+/okE5cW/5ssgv8u3Ghf
	GPeAJ
X-Google-Smtp-Source: AGHT+IFckWlA4kdVEgRECP0glI1JByDiDsvXyGUjawzJFzxJ8Yok5kMY9oBeSY7PugGB8dAXgBQUpg==
X-Received: by 2002:a17:906:f10a:b0:a3d:1625:d2c5 with SMTP id gv10-20020a170906f10a00b00a3d1625d2c5mr609105ejb.50.1707866677489;
        Tue, 13 Feb 2024 15:24:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV0EFMx1PHieLRejhpNw5YxTNGa1nvZljzHw7YTc6x3RmUzSvmbkiDnYLmPba2ldZMLUqpBMEA8FQuXC33/2ryZIqfcXsxJjw==
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id tx9-20020a1709078e8900b00a3d23a4e8fdsm508950ejc.90.2024.02.13.15.24.36
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 15:24:37 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-410acf9e776so96435e9.1
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 15:24:36 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUh5gBfyEMezmjSjU7OZNUId33o/zDx2NIA7rCmg1dzhltt1oZ1k/KKHcQ5Uuh1qLF1kK9n4pgpt0SSIHqP79Wr9VDbhagm4Q==
X-Received: by 2002:a05:600c:a01a:b0:411:e72d:e5c9 with SMTP id
 jg26-20020a05600ca01a00b00411e72de5c9mr7584wmb.5.1707866675833; Tue, 13 Feb
 2024 15:24:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-21-swboyd@chromium.org>
In-Reply-To: <20240210070934.2549994-21-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Tue, 13 Feb 2024 15:24:20 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XH=yJdEKSmOq50mXw12hsBc0-oWmhnc4h_itGqfoEjfA@mail.gmail.com>
Message-ID: <CAD=FV=XH=yJdEKSmOq50mXw12hsBc0-oWmhnc4h_itGqfoEjfA@mail.gmail.com>
Subject: Re: [PATCH 20/22] arm64: dts: qcom: sc7180: pazquel: Add missing
 comment header
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

Bjorn: happy to see this landed any time to shorten Stephen's series.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
