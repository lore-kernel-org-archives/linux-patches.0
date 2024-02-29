Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC7B2E410
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 01:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709171175; cv=none; b=HAwsfIqG3hvOlXjx9onh7fqTGr3S6r+OMHdBdVK9su48aTDMy0xovtuwci1Tbb7cTQXguP/EbGpbWH3UQRh7UzG50Edw1fH2YGjJsb7tNHOL8DHna1/1ehi9CTjvsf6xckW9PoHy/wvjnIn/4gfi+aYtF/pXZ0NiAmplIpVkdP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709171175; c=relaxed/simple;
	bh=OWe4oUBOmApqxp6RuSwzBaqEjECsstdX9gvjE7NjtL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CDDJ1iOFpKdawJM7qNbTEAwKAjVfIudcJ9Mbe9anA/SfxyfwNv7cnZBIMoLucAzlveAikhgX54TOdEB0nTzzYVuR5yKE8YtcX+tH6hEgkcTALkba8lUZof3RkdqB+oBLqbd6cqvd5uMGXHd5Ue9VaOJaorNSz9b9Qw62fEqONLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=e9twwrmO; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="e9twwrmO"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-564fc495d83so543090a12.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709171170; x=1709775970; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4l+dEcSZUPzIQHrYPeg5QRKPOIlq4y/RNg3JOxmjZQ=;
        b=e9twwrmO9vPBx5TFTQI+T4Nh1i79IgNNkwsqMpHY1Rv4t3gdZbfPDJycrouEIYqEm4
         J9pYTippuQb6Fj1W/Y9xLOF6/kujhUjPGJXlZt73CncKrCPeCxj8jqMcgefjD2Ud5xdz
         DXd3dRjEzZgFLfL+mXXYVR99xWHUBMjixjoH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709171170; x=1709775970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f4l+dEcSZUPzIQHrYPeg5QRKPOIlq4y/RNg3JOxmjZQ=;
        b=QyAGg7JjtLN6EECR/su9i/gE5uWV0RGGzrXIogTFPH72SwNi24gApGnmgkirYQ3AWP
         LjoSfraH0H3OhtgDYbcYF62Bj3lO54lZaSB1uhtU3kJygLso6bLxjk8DEkyGlCI2kiL+
         AvakTuipxLXTGSFR+DDC3kCP3CNI8PyXd7tZdXGVZ1RiXvbIl/+7malKaXuToMwVGx21
         roX4Af9dxh3/KMz1vH7B/vGK9pSepl+hF2PX/kma8i08ZS++qvvRtGLq4+r1om1uQ3xD
         lUWt3sPts6w7A2oZwGczeoRKEP/yrmzTBJ7M+CSHhfZJzaSd6iN+M9glDVcKJgwnl9Nj
         2QdA==
X-Forwarded-Encrypted: i=1; AJvYcCW+V3zCXqEGSOYOrob6XPJS0aRY7FWP4Sqn9HUOgiAuTDnF1KpJ0Z5AQkv2qB6OHb8jnxXhKyZs9E7sBL/zSOepmp9Z/4VtFQ==
X-Gm-Message-State: AOJu0YzBwbUeGCLsknOxIYysx5cPVJI1ix64UV/Q6jWtnznoSnMBnjvg
	rjD2BlXFYgLohDyDozuvinQHNlKIlSKHTH6RBcJeLK7uEzC/LV+xFPOEGftg12FmwpK5Z6KGLGU
	B69D7
X-Google-Smtp-Source: AGHT+IGiehgiwJtbHJMNBKiQAF54ZIvMofmdUblfwMvBGgxfqhSQbWTVCTwsrnKtQBis2d5N3P+vhQ==
X-Received: by 2002:a05:6402:2228:b0:565:1049:c013 with SMTP id cr8-20020a056402222800b005651049c013mr440840edb.10.1709171170511;
        Wed, 28 Feb 2024 17:46:10 -0800 (PST)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id g26-20020a056402321a00b0055fba4996d9sm115453eda.71.2024.02.28.17.46.09
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 17:46:10 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4129a748420so38655e9.0
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:46:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqbju1udfIx1BzHqhqQKJKer20fJxKdYFtIpXD7pon4JbogsaZC+/IpAImJETgT7aWOhFkVjYjP7xIp4ijR4FPPSLjTRqQ6g==
X-Received: by 2002:a05:600c:1d98:b0:412:bb83:bc7c with SMTP id
 p24-20020a05600c1d9800b00412bb83bc7cmr14062wms.7.1709171169334; Wed, 28 Feb
 2024 17:46:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229012828.438020-1-swboyd@chromium.org>
In-Reply-To: <20240229012828.438020-1-swboyd@chromium.org>
From: Doug Anderson <dianders@chromium.org>
Date: Wed, 28 Feb 2024 17:45:53 -0800
X-Gmail-Original-Message-ID: <CAD=FV=Wy9pPqFGhU3MGoNXFVrCpyy8Yk=FTNa2MV-DTVLWQdUQ@mail.gmail.com>
Message-ID: <CAD=FV=Wy9pPqFGhU3MGoNXFVrCpyy8Yk=FTNa2MV-DTVLWQdUQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: qcom: sc7180: Disable pmic pinctrl node on Trogdor
To: Stephen Boyd <swboyd@chromium.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-msm@vger.kernel.org, cros-qcom-dts-watchers@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 28, 2024 at 5:28=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> We don't use this pmic pinctrl node on any Trogdor devices. The
> AP_SUSPEND pin is here, but this pinctrl device isn't a supplier to
> anything in the devicetrees that include this file. Disable this device
> node in the DTS so that we don't waste time or memory on this device.
>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Douglas Anderson <dianders@chromium.org>
