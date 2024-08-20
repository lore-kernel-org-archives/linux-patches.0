Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CAF1C37A4
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724174691; cv=none; b=ZuDwpgcwgh0f0aVWauIPy9EQiOOlc8mN3FwpbJwVlaYDAMioAuCQbjhOhBau7SdqXA2igOjmyr2vVvVnDmiaHBHktc8LUi5/ss7xqHh1RRvE9CkIpdVVvoTenkVvCjpeWNgPDghrmsOr42haPjaN8wVOTcmbWQuqaMWuUcvbFd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724174691; c=relaxed/simple;
	bh=5jI+2p5tO5nOwZs3G8vuy7obODZwjARI/RidWxG+P/0=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNHEz5FVnO7ugPwmVQvEQjV1DwpOE9LnijWsLMQxQdv6K+R8Tp68hRoCdjtlxOW60TcaMmFRxnr4BCXNEJUbTpYEXPKhmILArt/8mt35tICsQ40o/xyQgm4XQS8+zpiQ0lsoMzcknj5Eckc3yhEVviZlXtJalENoceBJOA32xKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=PjlrPaoO; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PjlrPaoO"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a1d024f775so430391085a.2
        for <patches@lists.linux.dev>; Tue, 20 Aug 2024 10:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1724174688; x=1724779488; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kivk6OVMCb2Ic/WQYTSiSJ7knOT9aLnIRhStn7/b1EY=;
        b=PjlrPaoOHh0Vo7Edw3Q9C+LhGoFYmrlOdXwZEVCmkmkANC9kyXvxTyAIrClwdw+Q/4
         jjcjhZBWbyNUcSabdEU7T08L6WrUQHPsErhdUGDk+poujE/NmYDlBdMJ1ncKWQ1Umi33
         yFV0HVgyVaDLa5Zw5rw/Fujb0GzQ2TKvYad+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724174688; x=1724779488;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kivk6OVMCb2Ic/WQYTSiSJ7knOT9aLnIRhStn7/b1EY=;
        b=m3AFEiZJQbwknsibFttAoZjHq+82gCLDpisBGeT7xRQpD/2XQTJvKC8tqOFiGiR/eb
         Xfi/1/fFll7yeV+nGZeDjja9vHYdiq8d/8e+nkKgxEySKmLE05AfN7hwWKP4sutDYqmf
         dEp8HeW5tZ7r7Cui5K1YUgLzBcrzYC41eFwot9AojX9JmWiJKg0BASGjtO9dVLn3z3/q
         JkJKU5MDUiPFq2ZZ42Y/J9Wkp9R8NRqm9d/rYOnBPx6o81Ha55n0NTCZKdoIXek/1vnF
         mh2TDyKWudl+FSn3iYErfb9fQD6Y46gqXQkJczHnPu2XKYGIjcUEKqEGz5f1VJaYeJss
         WNlA==
X-Forwarded-Encrypted: i=1; AJvYcCUHmYrbq9ATgcly/4JLwZFcHVagFS/6sWOT4gFU6qnsDV/4skGzhoJqUTIZbUQOC3oZSEgFp8skZh7A/vVHQsHKqmZevKWzpA==
X-Gm-Message-State: AOJu0YxKoYDZslxRzVmYz5nl/aS5VSoM90YmDbpUU/srz9b7foPfjuSz
	17cYr0YHRawB4Kp8nIYYK7WLQ7cAja0S4dG2n/FPDcfBZIP50S41wmtb2KqtPZu4b+Se0D6YAOh
	Bo6Nl9/R5lLHPoCg9sxlcumt3Dqd0Vmu+76FE
X-Google-Smtp-Source: AGHT+IFPnbaIpKnJbRF0KVl+CpiSvIEMrBAyBLBBnH5HxEKdAtvNgsfFmldfo1C+7jIx6Rn++JaBGcZOF4ZPpQUlOKY=
X-Received: by 2002:a05:620a:319c:b0:7a3:6dd9:efbb with SMTP id
 af79cd13be357-7a50695402emr1528659285a.33.1724174688344; Tue, 20 Aug 2024
 10:24:48 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 20 Aug 2024 10:24:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZsTPuvoTIFVFHw6o@smile.fi.intel.com>
References: <20240819223834.2049862-1-swboyd@chromium.org> <20240819223834.2049862-3-swboyd@chromium.org>
 <ZsRrWfoPPVGC4Dqy@smile.fi.intel.com> <CAE-0n536OWtoOoRSM=6u=wA75A+0WtBktiY=6Y6VjKKTQWPcNw@mail.gmail.com>
 <ZsTPuvoTIFVFHw6o@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 20 Aug 2024 10:24:47 -0700
Message-ID: <CAE-0n50xcj21WiPHW9ATE7BfxKpOWvdV7of97G_U5ZrMV0zUUw@mail.gmail.com>
Subject: Re: [PATCH v3 02/17] drm/bridge: Verify lane assignment is going to
 work during atomic_check
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
	Thomas Zimmermann <tzimmermann@suse.de>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Daniel Scally <djrscally@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Ivan Orlov <ivan.orlov0322@gmail.com>, 
	linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Andy Shevchenko (2024-08-20 10:17:46)
> On Tue, Aug 20, 2024 at 10:12:55AM -0700, Stephen Boyd wrote:
> > Quoting Andy Shevchenko (2024-08-20 03:09:29)
> > > On Mon, Aug 19, 2024 at 03:38:16PM -0700, Stephen Boyd wrote:
> > > > +     /*
> > > > +      * Ensure this bridge is aware that the next bridge wants to
> > > > +      * reassign lanes.
> > > > +      */
> > > > +     for (i = 0; i < num_input_lanes; i++)
> > > > +             if (i != input_lanes[i].logical && !num_output_lanes)
> > > > +                     return -ENOTSUPP;
> > >
> > > Besides missing {} this code is internal to the Linux kernel. Is it okay?
> >
> > ENOTSUPP is used by select_bus_fmt_recursive() so I simply followed that
> > style.
>
> Okay, just be aware of that side effect of that code, also checkpatch may
> complain (however it might be false positive).

Yes checkpatch complained but didn't enlighten me. Please tell me the
side effect as I'm unaware!
