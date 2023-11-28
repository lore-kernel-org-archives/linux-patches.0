Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFB77EB
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 00:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P0TIZBJb"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-54af1daf6a9so6773741a12.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 16:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701131030; x=1701735830; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CITKlR0CufWKC9XKPtJeX5JTUygQCHjXuf0lX1a+I9k=;
        b=P0TIZBJbroOpdg661a14OSQCw/HplbvSzIxpa5UFf3lBlNapIU1cf2y7d5QIOkbSMY
         B5sIyTrf35yb0mGKewcUPntXaMvSJsKyUOs12D+FijW3Dbdfk7UEiYAWcoWJiie/F6Gq
         iTxDpHfvzW9O5nPv6EoNj9zPf31uOfDUGqwAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701131030; x=1701735830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CITKlR0CufWKC9XKPtJeX5JTUygQCHjXuf0lX1a+I9k=;
        b=ZXZszjCI1QpNHi066RISP48qyoSZlzznBzkzTXdEAHAgdQw2wpWY/G9Yrz8FXkosaO
         juIxTl9cJezRuyzpHwzQZIut9+APuKZKbcxRjw/lCSBR5sdlAJkHklxmJW7F+OE8E+kw
         eB1IgFtchObTmqM3YdW4ASFvdfuvYS7QVxy9li+P8IYMZQTWWdcmaghlXnrZfsASN2Dg
         l0qMD/uWMylbRCbY1bsjbeeODNIPS2RQQMo2jXjOS9I5xycYW57hOIdEhD4bJ+RUxeGy
         WVvnggJdd32Xur/cvavBrfHWlNt4XF2tgbNuA7WCDC2M9Zu5BXzE2xok9/YtvbmquGJW
         AZNw==
X-Gm-Message-State: AOJu0YyFZUAWptfHtTTzDSVC7xo4z8MIuW5NzR4CgDmn5cXFXL3XVffL
	U1bElk2FDI3zeA8Srn2OiLBHZLrL3tFKyrLwL6gpuQ==
X-Google-Smtp-Source: AGHT+IFvazAGSPEvth60eBg6IH4GYNmo3lOUkNagRvOlEKJB0ElTm2bPcG88dD4EFBdLHQUL5yc8sQ==
X-Received: by 2002:a05:6402:3481:b0:54b:6786:3f74 with SMTP id v1-20020a056402348100b0054b67863f74mr5158051edc.11.1701131029767;
        Mon, 27 Nov 2023 16:23:49 -0800 (PST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b005401a4184ddsm5687893edt.27.2023.11.27.16.23.49
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Nov 2023 16:23:49 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40b422a274dso12955e9.0
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 16:23:49 -0800 (PST)
X-Received: by 2002:a05:600c:3b13:b0:40a:483f:f828 with SMTP id
 m19-20020a05600c3b1300b0040a483ff828mr728526wms.4.1701131028845; Mon, 27 Nov
 2023 16:23:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231128002052.2520402-1-swboyd@chromium.org>
In-Reply-To: <20231128002052.2520402-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 27 Nov 2023 16:23:33 -0800
X-Gmail-Original-Message-ID: <CAD=FV=Xbd7q=SZqje+hW7jfH3Fk7k1ZN-FzE7VrqOZ+rP0a5EQ@mail.gmail.com>
Message-ID: <CAD=FV=Xbd7q=SZqje+hW7jfH3Fk7k1ZN-FzE7VrqOZ+rP0a5EQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: arm: qcom: Fix html link
To: Stephen Boyd <swboyd@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Alexandre TORGUE <alexandre.torgue@foss.st.com>, Yanteng Si <siyanteng@loongson.cn>, 
	Jonathan Corbet <corbet@lwn.net>, Bjorn Andersson <andersson@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 27, 2023 at 4:20=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> This link got broken by commit e790a4ce5290 ("arm: docs: Move Arm
> documentation to Documentation/arch/") when the doc moved from arm/ to
> arch/arm/. Fix the link so that it can continue to be followed.
>
> Fixes: e790a4ce5290 ("arm: docs: Move Arm documentation to Documentation/=
arch/")
> Cc: Alexandre TORGUE <alexandre.torgue@foss.st.com>
> Cc: Yanteng Si <siyanteng@loongson.cn>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  Documentation/devicetree/bindings/arm/qcom.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
