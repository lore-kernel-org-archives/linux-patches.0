Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E13666B4F
	for <patches@lists.linux.dev>; Tue, 20 Feb 2024 11:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708429633; cv=none; b=XM6q2r8JGjXH++Dbpx/H3UpXvjqOKJZRzghq7BCxumvJFbngx2twMT9zlRT5y5CBUSn1rt/o9X+pxVRWJQkNy7Uk+NFkvHBrYvd2wV8pMl6ttV+OQM6Dypqx+j7us1W8cDsvFYXJFU34eCWbJ0Lhlz/JZQ6xSqzHnxy4WxL5N2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708429633; c=relaxed/simple;
	bh=sfltWzyTzAdCakZmDcZEIFogRIcduk+6sj+HuSfY4kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dem1VROtTGj/Bulxo1pg2qbaL3wuVmSFES6G0FKhfPhUDidFQgVXaJZQoHKvMXEKxrfwgFn1RofqUerGv56Vk8ynajnIbgdJIrdLT/Hk2+olWwdDDNpzR1EZiSekT5c6XJqKRwqK/ZMa3FFhjPovfhXL6HBNRbqVHWM81ewpZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=YpOv10lW; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="YpOv10lW"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4c90bdfc8b2so267088e0c.2
        for <patches@lists.linux.dev>; Tue, 20 Feb 2024 03:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1708429630; x=1709034430; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6RqJSPI71QVegWMkFBgsdGc3en2Z5VC7xej49dSawM=;
        b=YpOv10lWaM/Ax0tUqkWzmxMEjavh5WCI5oycTDCQiSA3/AJgLdVnPon0Ir/t5Ne7Rx
         nc/eu8kpTDKNMFkWwVHXryvv8KqWwi72Rw0YoJMUJifXg071PJcrn5GhEAgWbvlPthak
         hlYQvBfhUf4ycnLiM5w3gei8nLm5OeIjPWjLDTetdhmMjZ9KeHilULFksDs9HA5sx/Yg
         Ttd25ZB6rulvowaINj4IHS6wvjivlbbceIY6QuMcDSZF1tKOCvh46pQfPThbpNjA4z0T
         MqvXHVQFBR3OSdN5RvPmoWGvY6rcgcS7UgumtoWijm/ZrC3vU5ZOGBzZnsdF7/kz+1Is
         Hq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708429630; x=1709034430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B6RqJSPI71QVegWMkFBgsdGc3en2Z5VC7xej49dSawM=;
        b=TKTNMQIEhXIBmavBcdaFVsooZmLAds8HHtZImqUV3rY1fW+eHAHVnV/PJ3CC7uWAUd
         muSe+qFHwlWQ3voMJ7UlRv91hnlOoyUGd6BMyaLiwe/mZl6xvestGQDCDd39+FeQ/jLm
         3gzhcDuhmgf7LUjy0BOpSGTSGU3OxtDskqok32m6hlJNacP1pEVpDz/iudc3OvI9DIm6
         JKEHZUCm+tGmsOaR4vtDmMot9s0QZBh4ZEdRcwvrE2R3RyxMS8Do456MydXcvH8lU3qT
         JapVoMYEkV3y3izlp4am9x3U/g1b8qQ9tLBAyYQ+nQma0vy8AGxBPeutyx4JRwKPC7WN
         n5AA==
X-Forwarded-Encrypted: i=1; AJvYcCV+ZH7x3HXhpxnPGrY4k7q0g7bsp7FJKBXs2Hhbcd5R4n7+o6yoAlY9+XVIP1DgHIeKXZK0Rd5+vfEo6ePLklRLqPBx9JaScQ==
X-Gm-Message-State: AOJu0YyLu5JByO/K6Llp9ugU0fQjHY+UUiOx2HPMzWEhQuvmufVuCgC7
	2v5Z4B1B/DSTnSoU0tCYLqg8kxfzY00MQgDBz1PGjPMddE9X5XB+8gpS/AtuOjdLB75gZ5df1Jj
	kQvrtrb2mQ50KN2EreuGor0Mbhwrn93Qz+8mVhg==
X-Google-Smtp-Source: AGHT+IGyaajNwux1BxoocFGntAKIhbXCIQZpJVCgvuYjClY4ijqOqxgST9Zp7zbc8nri052IfntLGRfd+b6JFHGT8Iw=
X-Received: by 2002:a1f:eb02:0:b0:4c7:b048:bb9c with SMTP id
 j2-20020a1feb02000000b004c7b048bb9cmr4873813vkh.15.1708429630233; Tue, 20 Feb
 2024 03:47:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240219202325.4095816-1-swboyd@chromium.org> <20240219202325.4095816-2-swboyd@chromium.org>
In-Reply-To: <20240219202325.4095816-2-swboyd@chromium.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Tue, 20 Feb 2024 12:46:59 +0100
Message-ID: <CAMRc=Mft4R83NSknze0BMMvJd7Yz3yNGqaBSRVBePgh_S3QU1g@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: cros-ec: Add properties for GPIO controller
To: Stephen Boyd <swboyd@chromium.org>
Cc: Lee Jones <lee@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, chrome-platform@lists.linux.dev, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 9:23=E2=80=AFPM Stephen Boyd <swboyd@chromium.org> =
wrote:
>
> The ChromeOS embedded controller (EC) supports setting the state of
> GPIOs when the system is unlocked, and getting the state of GPIOs in all
> cases. The GPIOs are on the EC itself, so the EC acts similar to a GPIO
> expander. Add the #gpio-cells and gpio-controller properties to the
> cros-ec binding so that other devices described in DT can get the GPIOs
> on the EC.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <brgl@bgdev.pl>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  Documentation/devicetree/bindings/mfd/google,cros-ec.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/=
Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> index e1ca4f297c6d..aac8819bd00b 100644
> --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> @@ -93,6 +93,11 @@ properties:
>    '#size-cells':
>      const: 0
>
> +  '#gpio-cells':
> +    const: 2
> +
> +  gpio-controller: true
> +
>    typec:
>      $ref: /schemas/chrome/google,cros-ec-typec.yaml#
>
> @@ -275,6 +280,8 @@ examples:
>              interrupts =3D <99 0>;
>              interrupt-parent =3D <&gpio7>;
>              spi-max-frequency =3D <5000000>;
> +            #gpio-cells =3D <2>;
> +            gpio-controller;
>
>              proximity {
>                  compatible =3D "google,cros-ec-mkbp-proximity";
> --
> https://chromeos.dev
>

Applied, thanks!

Bart
