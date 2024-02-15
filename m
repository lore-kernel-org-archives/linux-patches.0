Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3BB389
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707955668; cv=none; b=sjnc2Jfm3zMCM86LM9GSfB+pEXpdIEOuffKcvT2JPAPCLA/Y1jKTk7OKIodJZRlkuddm0KXbRWM5uNFUUm9BAYGXA8oapDG120AI34mpzKhjy+q3DKKBj3wJ3wQYPnfYMiO581kmDrtJBlSkqwWm6NQoUXsQLMkUp5VnbgX2Bt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707955668; c=relaxed/simple;
	bh=mqihVnhqmNxSJUbv/RGxqZmC0xVgRGexMSCP0Ns7bYU=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jIr4qiAOsBp6mj/v4YBC/zglGrZJLojIse6Q6gkWJIrjXRreDLaBgZoHL7haKQPYiZMUJtM4SWMkGzNsnf9SV/aadv7ECHCRklpNJDIYn3GVx34m1uZhcfxUYtCuR4QUpgYtbiYti+CrM6jCVqkD4NPT5KSadQGYMvxRl87AYmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ncvWl5wu; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ncvWl5wu"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5114b2b3b73so360102e87.0
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 16:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707955664; x=1708560464; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Er+ESEKbgXvc1t5qmUg/dKRx14VLf4dPpeD7i9BwE5I=;
        b=ncvWl5wu65jGyezVrNFU6a5eRwiA1/nLYmL3i0I28I8Fi4LVyqjVe49sUrJ/0jWlXk
         LFJxDn4SHkGJ2U9E+c0ZSy1dcpduQ9nvRqQnmpiBnsZJtlPboBcOBYdzTHjLW6Gs0cYk
         frpgavUED3Cq60dQILpGI5CnMx0frZ/ZFfej0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707955664; x=1708560464;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er+ESEKbgXvc1t5qmUg/dKRx14VLf4dPpeD7i9BwE5I=;
        b=jnma8lIk/Vt7lR3VMUnOOTo6RdwkhInl+Qnr8XLnU/W5nbS/pnHs7CyxBraadUhAMP
         kjK0ZAF2gYsJeytsmcodVyYQqWSOTJw4cDaQF7gpV4UwAJV8EaLcdgCtd5WlpQ3M5WIz
         3a5VXM6XfzAPWhOaInUuBD2C6LGNN2NAmer8PEYDdxVCB9/JeK/EfIzV/WdphlxNXRJ7
         kOOV3Rom313XhTlGtNkkyu8JZ3u9UP1M7kfJ/BIvrRVMXs97YOlYPiqEGfrZKjwDBEYH
         3lNeEjb5wS8aJnux8jd9smxBl7+mf2hFOYN/UIHsWcaBIJF2N9/BkLb8c7tiwTkjMFIQ
         Bx9A==
X-Forwarded-Encrypted: i=1; AJvYcCW5CETmRxNGtgAqSrgwRCp1j54AYrO0qCtFXQZiMgPfhqpVOeRmmhjkFbXn4K218VHkAh+7HOnG5ZzUTelWFP8G2fpcmFJ0Ww==
X-Gm-Message-State: AOJu0Yzlz8oGaD3v5uaIoGbzg8y8IHYCo5FcXht+z0whpl5wsW89kyQA
	+GODEjMdCBAkrz3nEFub9QFNeXGubXI+8jgQIiJSuKioPOMDR+Zn1cZmiFQOti0YmwRnesHyh2C
	6eSQj6B0ITOj5vUxHf7gtVFKRybazI+ECjvR4
X-Google-Smtp-Source: AGHT+IFV146fri/yEai625WOmmn4P92hjYL0lv0BuNrjWlIcprz/viy3Rv+xCRbYoWq6nvQJZDmqN9KcjzHIR0bVyZk=
X-Received: by 2002:a05:6512:77:b0:511:7292:c4db with SMTP id
 i23-20020a056512007700b005117292c4dbmr243676lfo.12.1707955664213; Wed, 14 Feb
 2024 16:07:44 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Feb 2024 16:07:43 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <18ac05fb-a78d-4e95-a73d-461f509cdc5f@linaro.org>
References: <20240210070934.2549994-1-swboyd@chromium.org> <20240210070934.2549994-19-swboyd@chromium.org>
 <18ac05fb-a78d-4e95-a73d-461f509cdc5f@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 14 Feb 2024 16:07:43 -0800
Message-ID: <CAE-0n50Y_GRMt8km=XjGC5Zm5dvb2t4gccznJn9HEFS4p7y8fQ@mail.gmail.com>
Subject: Re: [PATCH 18/22] dt-bindings: chrome: Add binding for ChromeOS Pogo
 pin connector
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, Douglas Anderson <dianders@chromium.org>, 
	Pin-yen Lin <treapking@chromium.org>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Krzysztof Kozlowski (2024-02-11 05:39:36)
> On 10/02/2024 08:09, Stephen Boyd wrote:
> > diff --git a/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml b/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml
> > new file mode 100644
> > index 000000000000..5ba68fd95fcd
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml
> > @@ -0,0 +1,61 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
[...]
>
> > +properties:
> > +  compatible:
> > +    const: google,pogo-pin-connector
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +  port:
> > +    $ref: /schemas/graph.yaml#/properties/port
> > +    description: Connection to USB2 port providing USB signals
> > +    required:
> > +      - endpoint
>
> Drop required.

Why? I'd like to make it so you can't have the node defined without
connecting it up to the rest of the system. Is that bad?

>
>
> > +
> > +patternProperties:
> > +  "^keyboard@[0-9a-f]{1,2}$":
> > +    description: The detachable keyboard
>
> If this is detachable why do you define it in DT? Only hard-wired USB
> devices, which need some sort of special handling. are described in DT.

From the commit text:

 We expect to find a keyboard on the other side of this connector with a
 specific vid/pid, so describe that as a child device at the port of the
 usb device connected upstream.

ChromeOS userspace is checking that the connected device downstream of
this port has the expected vid/pid to quickly rule out USB keyboards
that aren't the detachable keyboard. I wanted to express this in DT so
that it didn't live in ChromeOS userspace forever.
