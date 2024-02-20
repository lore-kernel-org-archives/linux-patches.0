Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2275D46B
	for <patches@lists.linux.dev>; Tue, 20 Feb 2024 08:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708418338; cv=none; b=GZOZwZXnYgeRItI9IGOXgiXVbSzMV3DmLUOXsdhtMg+Jl+quzQguCUijvCqzqMHUKyz2H56akjoOrb8wcaHvU/cQQ0KwBeRBObvK5crmFlridJZOmRJdK8suAR9tgv1craBVS0wfiwqX5/+JXPx2Egf1YFSf6F2/wRijDc2/+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708418338; c=relaxed/simple;
	bh=xaQQvYpzmBVHnCracW1/zWSt6cgfuwxk6XJIuCevoKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z8eYcmVvi/HIQ7hexE5StHtgnJO5dyWal3dimwXI6BRgqVF4bUDf6RXRAi8YoraAc/dLaiAT2dCdzFXRtBHGCdh3OtAMlMeXPSAkxo7gn8wWIpz7r+89xvp6ulUihfPHkkm0NswvGm1cV6A4JHGLHe65xswAXA0oG4x6Rwpz+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u5ctaNuf; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u5ctaNuf"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dccb1421bdeso4843408276.1
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 00:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708418335; x=1709023135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaQQvYpzmBVHnCracW1/zWSt6cgfuwxk6XJIuCevoKo=;
        b=u5ctaNufKP+d4oUrcE+PC1kdk2QqlxFV1+dhxpVuI/VlQQ2bUW9S5J5CMnSlA5+KqM
         5oNm4Q6mhly/aD93Yh10T1xlOLxF8cKAc/6+N2b0IKvLXNHgGhGv0+lxRVZOKsH04NJO
         4nxnJA8xSf3TtlIEm4tc8CqnsInppFDbXQiyvp/boCePc7vrqQfuLfYj5Rf4e/LvuMzj
         MH5PIr65s3lbSO3i6hucc/8U6Cql47f/KU5asnjLCOFCG8Q+RbQ0f1hHRUUjcT/zKpno
         PYMkgrPjth3zkGqQf8BCBcjqJ18wIP/ArnzW6gQzVh19cbf0UNeZ55QUqs7iqALo9Gnl
         uCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708418335; x=1709023135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xaQQvYpzmBVHnCracW1/zWSt6cgfuwxk6XJIuCevoKo=;
        b=AtEm8dOIbiLECQY+FWUU5nSlVCxn1ak+ECzuBa8NI2hmYu63toRFwYf4faSHhB+KEx
         O9gMPSLA75g6Lktw0Vqj80YbAUpmv5l4MXW2ixekQBU9i5l65T3JwF1bhqp3D91ybMOW
         cqongikFmZdD8q7/1wO5OdPuXIhrsHV7dmhcvkXWDdB/AzOjQ1wRWMrCf+cmF1R6Bpaz
         QApFEPR4yW3wOr23MyO19FuB8yekSYigmRw4iushfBe1Xs4U26/FE7UjVNkQgHY6DWsB
         N8d+sS+qLgsZIQF+vEjdopMRWPopn4FguQJ+FDeo/bDM1Px7T64oZWh44hKvZRba7YIo
         vyKw==
X-Forwarded-Encrypted: i=1; AJvYcCXz8rYmuXjalE0i0eCqpqjZkZpTA/wySs2For2Zh8KlI9W2BEIKfy+jOUSle17yvTyxifuaRsCwFWKkt8vXDHAHvkLjl0eEBQ==
X-Gm-Message-State: AOJu0YwhYxrQ6fDET8pdmaURtZD5M4TceeL6G2KBL+swY/zRTo0AzPgR
	Nuu/7krH3eYVzynGZsMtjOOSZA74Yg4AvrbIT0RfBnfZtN3eWkJURtVICHxf7JOf+tHlvzj+pxD
	4fHfWlsdFaNnEOdriT1mY1BTOeGdBU/j7CkFICg==
X-Google-Smtp-Source: AGHT+IENmsrAW3hNZ65FtN4Wch6Ui7UqnKl8CYVsXo+LBVt7opEcneA5tQP/7szbzlwQuVHBwtF33xDyl73OiskgVQo=
X-Received: by 2002:a25:83c4:0:b0:dcd:59e4:620c with SMTP id
 v4-20020a2583c4000000b00dcd59e4620cmr12705446ybm.49.1708418335046; Tue, 20
 Feb 2024 00:38:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220045230.2852640-1-swboyd@chromium.org>
In-Reply-To: <20240220045230.2852640-1-swboyd@chromium.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 20 Feb 2024 09:38:43 +0100
Message-ID: <CACRpkdY0DE-XxPO3vj34zmMvGj-sfGrjkkwGLuCKFdj=ksMJAA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add ChromeOS EC GPIO driver
To: Stephen Boyd <swboyd@chromium.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, chrome-platform@lists.linux.dev, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	linux-gpio@vger.kernel.org, Lee Jones <lee@kernel.org>, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 20, 2024 at 5:52=E2=80=AFAM Stephen Boyd <swboyd@chromium.org> =
wrote:

> The ChromeOS embedded controller (EC) supports setting the state of
> GPIOs when the system is unlocked, and getting the state of GPIOs in all
> cases. The GPIOs are on the EC itself, so the EC acts similar to a GPIO
> expander. Add a driver to get and set the GPIOs on the EC through the
> host command interface.
>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <brgl@bgdev.pl>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <linux-gpio@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

This looks good to me!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
