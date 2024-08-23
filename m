Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B28F1C6F7D
	for <patches@lists.linux.dev>; Fri, 23 Aug 2024 20:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724446078; cv=none; b=GpQKdygWPA1sDR6aS/RVtLHDBo74/7f7ttVqopu4tfD/dmgvXW4af1wqfzeSlIfcfkTreh2tkM6NySGLIlMS/Rz4Gb1yFEr2sjyIq9eRW8MJAcI+BziQojDu0MfBUFEO7CDL1AafJuhKN8yGmh1O01/YdTRCJdR+WjdlyTD4alM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724446078; c=relaxed/simple;
	bh=id4PXH6g6b5ygcEfz+3/ImyFmiTcss8b3qGEx/u76XI=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S9GHDgj6lmhF5JxoO/a4yvniZCEkbci9x6PIagAavgNCvjvE48EecGJFcLm/Qk1Bf9kx9asxAGyp/Z/lGKjNmRMWuvXPajAzO4S1OzNIONBMhqRwdrplhOPSSV7aBvnuWI8B4vQzpSe4bQp24frpthKFH6+KMXRXj1d0HUzzww8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=igIf95L6; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="igIf95L6"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-26fde6117cfso1836718fac.1
        for <patches@lists.linux.dev>; Fri, 23 Aug 2024 13:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724446076; x=1725050876; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=id4PXH6g6b5ygcEfz+3/ImyFmiTcss8b3qGEx/u76XI=;
        b=igIf95L6Q0RqkeCjPoaTwCHD8rmvbB9sHs0BpME1k7jm70e2k5a8xjILb7E61HwNZs
         4b3S6/gaPtSs3jA7iG0JkfJDvom4hFgoZ7ALlRVYf2fpp37Lry8/sJag7aNfhdVQM63T
         lNQ2B+WqMIabqofxATSkOSj81xI0FCvEGsGgA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724446076; x=1725050876;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=id4PXH6g6b5ygcEfz+3/ImyFmiTcss8b3qGEx/u76XI=;
        b=UlsxDHgEj0e4FwyyWB+s67+ARfcvfYy/QbFLrln3QP2r/irLIVTjsCTqw0RES/T8wh
         r/H5XCngbDPnPQzN6NS2siNk6kCqzQhCPnMrbLH6ZbMqs9ycDLFHZ4fQ6f7GW73uhNN4
         ur7dJWLB94tfrRezzfRNLFgOSckUoxbsjmK/iWb3mt/B/mddBknfF+nhO7I33KPYZOmM
         wvSAr/ZOAm2C8ghuHKw+k2S7W92a2Xt1jVZJrLmRYFbwcRMz+q1v5Z4TnZxM0EPgWGFp
         mnDvTGwVa50B0Gy2aluv3bJFjbT3BuNX+yTLUTPlsd67PaiKmVKQ7sAP9zCq/uDbfsif
         LqKA==
X-Forwarded-Encrypted: i=1; AJvYcCUuKWcdYULoXCmo3950l6bycGVHJzmAF5lN5lX7aRxV1UcG6GOBwRlgxCOZH73/NmNoGKktcQ/A@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm1CIG3Wyi65hJyhl6N9dUGwdlUy7AQWpl1C64iqpJTB5E0wG5
	axzUg3PzKL4GX/dZKzt96rDf5zQX+lEft/Lsp6fI5OvF0Jq49L3LwqXmxFRA7VTIna65q4kaUEI
	prl9/s2R9sZ7y2yX0acriUWJutq1l3LT7YPL+
X-Google-Smtp-Source: AGHT+IFTlK1vgqPsQn2j9voF5J39I5gTTTzWpu4wouRlEDJLxZNqlw4ZgBfIqTn3IqcZNBM8n7tlqF0zt3kueWkW4Ac=
X-Received: by 2002:a05:687c:2be9:b0:265:b32b:c45f with SMTP id
 586e51a60fabf-273e60835d0mr3142337fac.0.1724446075865; Fri, 23 Aug 2024
 13:47:55 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 23 Aug 2024 13:47:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZsdMd7Ywa2b-GDT6@tzungbi-laptop>
References: <20240819223834.2049862-1-swboyd@chromium.org> <20240819223834.2049862-14-swboyd@chromium.org>
 <ZsdMd7Ywa2b-GDT6@tzungbi-laptop>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 23 Aug 2024 13:47:55 -0700
Message-ID: <CAE-0n53zPV8QHf7DxSDO8E4-kvsP=unFvevjo7i1ZjE1v6UgAA@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] dt-bindings: Move google,cros-ec-typec binding
 to usb
To: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	Andrzej Hajda <andrzej.hajda@intel.com>, Benson Leung <bleung@chromium.org>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@gmail.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, dri-devel@lists.freedesktop.org, 
	Guenter Roeck <groeck@chromium.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Jonas Karlman <jonas@kwiboo.se>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, Lee Jones <lee@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Prashant Malani <pmalani@chromium.org>, 
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Ivan Orlov <ivan.orlov0322@gmail.com>, 
	linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Vinod Koul <vkoul@kernel.org>, Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Tzung-Bi Shih (2024-08-22 07:34:31)
> On Mon, Aug 19, 2024 at 03:38:27PM -0700, Stephen Boyd wrote:
> > -title: Google Chrome OS EC(Embedded Controller) Type C port driver.
> > +title: Google Chrome OS Embedded Controller (EC) USB type-c port driver
>
> Given that it gets chance to modify, how about s/Chrome OS/ChromeOS/?

Sure!
