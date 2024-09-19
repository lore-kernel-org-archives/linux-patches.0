Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2B8194AF3
	for <patches@lists.linux.dev>; Thu, 19 Sep 2024 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726740747; cv=none; b=qs3kFNVpfsDcuzVIJkX9BZU+MRucYqVetdaaWJoFbsGV4S6WIQaXUxwAuZfrH2LbHfpNAMEYJnW90bdWWV/Wd2zPqh2jbG+Z0HOL9I1cLYrPGPdycu6q0JHCFbXruuQ8c9RKlC3m9/bGCR3p/VjOie7ZtZ5b1GI5sbUbd1oRLZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726740747; c=relaxed/simple;
	bh=DIkAJir5JfJORJ5MkFp4kEfthpXf2iDOkp5wt+Yfn7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OVwCEBXCPnORubJCij4Co+qFzFQP9H39E4iF6ZpCOy65pD/PIR0x3L10JKtbAm87SP+Vc9D8gA0QAT5E1tsFU6FPGM7VHUWOuqBcRY3UOehQAE0Io2gO6lmFGM0feHaXcCsQY53P48CUKFjqDJd920jIcXtBrHyhYR8UGDIQe20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PEib4m4h; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PEib4m4h"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f75428b9f8so8907221fa.3
        for <patches@lists.linux.dev>; Thu, 19 Sep 2024 03:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726740742; x=1727345542; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GLFjOu5wJvL2rv+0CoDa2SB5UCn11iYd9z/GnY6i9QI=;
        b=PEib4m4hCLIkXRB+/qOzwpwIR1KDFYwQxW/acNoyhQiw72HlvDf/MGdpv96i+Hs4vs
         hRgR+uE7/3fVpZcblKXVTvrJHNqxvzWLPwxiDRDk3afNRvEe+ssB8sxT4WHGPb12W//u
         +xGgemj4ppM0jUZVt0F0kNDjPgyIRBoXAaaI885XHQm7OzQtsEIq5RCeEnFTz3VN36dT
         sZ5+R8mp9crwlO4dUdsI7c9EYUrIA7HElxvz3gjd9KG4uJLze5wvO382eDKGpQl852vK
         uXeI0UojtK2y0GWJjyxVjXOdGk7bJzkX/uY6RnLxH1ugQmhFnOGMurkHhftWNcwokJfD
         qXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726740742; x=1727345542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GLFjOu5wJvL2rv+0CoDa2SB5UCn11iYd9z/GnY6i9QI=;
        b=KAnM1/Zzfuo+Appc88Ir7Pt0umxffvSqXuW89GZbLKoDRx6+WCDhp4fOMblGGHBzUS
         HMYoD0aF5RgatfDERvZKAQ7s6YhnwIXpxHsTymrP8h/zDctkUd38sV/vNRS/9eGMkCKT
         hsK97fVKKdCxiA/mz9spfTCzjCUHe+rwf5pg85bAgB8+BN3hIuuRfHiBgQJTG1sA1xa/
         d4C+OAYRv49lq3F/QJAwRLMlm8O11yhnLFrCs1CwBpN6Kk6jU42AEn3mhkofsAC3H1tR
         3qsC5cJs3zekZOyZDLiT516an/VgfzF07tRZidtIQUpL0Vwlo+YltEMSGyqwBHApJmvN
         LOpA==
X-Forwarded-Encrypted: i=1; AJvYcCV91nbADD51T/WQnQ4CNhOVz4uIXVTubdr8hLeKSvI4+eiJnoWO7sf5IPj80XXLM5mw3RCnRi9b@lists.linux.dev
X-Gm-Message-State: AOJu0YzLXtpdkOu6DQj8MG79anBXkgZukMBZXu0B5TAQjqNx3DaN4len
	VLJZw8AWHUfICTdR+y198HSHl49V3lsXjM/ajTkAhFMZ9lrcPqxtj7lbsFjitpk=
X-Google-Smtp-Source: AGHT+IFs8u88LihqDZIZ2JBPSh5x0leTTbUiKEPgu3X0utw4O9nD7aokz6LHJhifGnBWperW+atYZw==
X-Received: by 2002:a2e:84a:0:b0:2f7:5777:cf14 with SMTP id 38308e7fff4ca-2f7935c342bmr109006111fa.35.1726740742024;
        Thu, 19 Sep 2024 03:12:22 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f79d59ba9dsm15593971fa.128.2024.09.19.03.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 03:12:20 -0700 (PDT)
Date: Thu, 19 Sep 2024 13:12:17 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, devicetree@vger.kernel.org, 
	Douglas Anderson <dianders@chromium.org>, Pin-yen Lin <treapking@chromium.org>, 
	Andrzej Hajda <andrzej.hajda@intel.com>, Benson Leung <bleung@chromium.org>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, 
	David Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, 
	Guenter Roeck <groeck@chromium.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Jonas Karlman <jonas@kwiboo.se>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, Lee Jones <lee@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Prashant Malani <pmalani@chromium.org>, 
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Tzung-Bi Shih <tzungbi@kernel.org>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Daniel Scally <djrscally@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, Ivan Orlov <ivan.orlov0322@gmail.com>, 
	linux-acpi@vger.kernel.org, linux-usb@vger.kernel.org, 
	Mika Westerberg <mika.westerberg@linux.intel.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, 
	Sakari Ailus <sakari.ailus@linux.intel.com>, Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH v4 03/18] usb: typec: Stub out typec_switch APIs when
 CONFIG_TYPEC=n
Message-ID: <kvm44f4c2lejbvfviuykxvcyo3ofcncjt5ssesn7ldequfeymc@eocnaacw425i>
References: <20240901040658.157425-1-swboyd@chromium.org>
 <20240901040658.157425-4-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240901040658.157425-4-swboyd@chromium.org>

On Sat, Aug 31, 2024 at 09:06:41PM GMT, Stephen Boyd wrote:
> Ease driver development by adding stubs for the typec_switch APIs when
> CONFIG_TYPEC=n. Copy the same method used for the typec_mux APIs to be
> consistent.
> 
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <linux-usb@vger.kernel.org>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  include/linux/usb/typec_mux.h | 43 +++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/usb/typec_mux.h b/include/linux/usb/typec_mux.h
> index 2489a7857d8e..efb5ed32b813 100644
> --- a/include/linux/usb/typec_mux.h
> +++ b/include/linux/usb/typec_mux.h
> @@ -3,6 +3,7 @@
>  #ifndef __USB_TYPEC_MUX
>  #define __USB_TYPEC_MUX
>  
> +#include <linux/err.h>
>  #include <linux/property.h>
>  #include <linux/usb/typec.h>
>  
> @@ -24,16 +25,13 @@ struct typec_switch_desc {
>  	void *drvdata;
>  };
>  
> +#if IS_ENABLED(CONFIG_TYPEC)
> +
>  struct typec_switch *fwnode_typec_switch_get(struct fwnode_handle *fwnode);
>  void typec_switch_put(struct typec_switch *sw);
>  int typec_switch_set(struct typec_switch *sw,
>  		     enum typec_orientation orientation);
>  
> -static inline struct typec_switch *typec_switch_get(struct device *dev)
> -{
> -	return fwnode_typec_switch_get(dev_fwnode(dev));
> -}
> -
>  struct typec_switch_dev *
>  typec_switch_register(struct device *parent,
>  		      const struct typec_switch_desc *desc);
> @@ -42,6 +40,41 @@ void typec_switch_unregister(struct typec_switch_dev *sw);
>  void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data);
>  void *typec_switch_get_drvdata(struct typec_switch_dev *sw);
>  
> +#else
> +
> +static inline struct typec_switch *
> +fwnode_typec_switch_get(struct fwnode_handle *fwnode)
> +{
> +	return NULL;
> +}
> +static inline void typec_switch_put(struct typec_switch *sw) {}
> +static inline int typec_switch_set(struct typec_switch *sw,
> +		     enum typec_orientation orientation)
> +{
> +	return 0;
> +}

Just my 2c:

The stubs above look fine from my POV, they help us to cleanup the users
of the API. The register/unregister callbacks are not. The switch
providers should clearly know whether the API is actually available or
not. Compare this to how other subsystems (regulators, interconnects,
etc) provide stubs for consumer API only.

In other words, please consider sending a patch that drops provider-side
Type-C MUX API stubs.

> +
> +static inline struct typec_switch_dev *
> +typec_switch_register(struct device *parent,
> +		      const struct typec_switch_desc *desc)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +static inline void typec_switch_unregister(struct typec_switch_dev *sw) {}
> +
> +static inline void typec_switch_set_drvdata(struct typec_switch_dev *sw, void *data) {}
> +static inline void *typec_switch_get_drvdata(struct typec_switch_dev *sw)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +#endif /* CONFIG_TYPEC */
> +
> +static inline struct typec_switch *typec_switch_get(struct device *dev)
> +{
> +	return fwnode_typec_switch_get(dev_fwnode(dev));
> +}
> +
>  struct typec_mux_state {
>  	struct typec_altmode *alt;
>  	unsigned long mode;
> -- 
> https://chromeos.dev
> 

-- 
With best wishes
Dmitry
