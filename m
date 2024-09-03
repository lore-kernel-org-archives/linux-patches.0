Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8241A42BB;
	Tue,  3 Sep 2024 11:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725364676; cv=none; b=D8+OMDeqvxO5bDM+AtJyJTyr2/bJg5nEN26RVyjcct2ex0mQvIJ1DIzUOpEfW1ePFXDw+QGs+6TW7D97eFqjJFnVDU3OHbCHSfW9ftEeALuqnHP5swBRq6sR5cIKvsZZvTHGMDJLNWbfJkHLF9O3kaKPszfiM8vJI4g/H1Cy/Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725364676; c=relaxed/simple;
	bh=pYR/4xqMSDopVbTkWH4Grl03ykIHCeaM7sZywKn0npc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cU68NWEaAbT3v6APYZT4wlGmFCDzg5+5kyy5n+bO3QpjoSRcsJMCTjm3zZYm0MgvOv9vlV0dyUgH3DnceNL4uJHOkEj7nFZPqtPwzGSfwI9GqsYa2zTyu6GmXGUbljpp9mKY7farX1Qkp3ET8pmRTra2Bj1Bo3L+QqAgAgu015w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MK25J7t4; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MK25J7t4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725364675; x=1756900675;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pYR/4xqMSDopVbTkWH4Grl03ykIHCeaM7sZywKn0npc=;
  b=MK25J7t4kEQLracRb6W7wKAiKemOdjY9WD6AblWwFSnkhRHWqigjUs1+
   LaevWap/X9oJUQyeCgWYOdghlUu8svC0Q6UjQ3Yc8PTBzWI1GYQklbQne
   3g45ikVZjbwkTT6c+jcN061hN9Dr7aPhhCQsGPMU4l+9b7RvcmjE/fAas
   jqILyAcx7oQhbIU6juaD9URjK9W33PJdWExJVnCQCbRgB03TnTu5sV1jU
   PB5Of9V5ipyMYanpq7QPX24quRNaDCVGh9cOVbdL960JDuptSDHV2fO6b
   N0JBQK7+8Ik/q9e1MeqBfYO93Oi/kHG+1OXKKh9WKAzZ05pm5rGRs7+Tg
   Q==;
X-CSE-ConnectionGUID: Fg58VnfXThC2RI/gHVWaUw==
X-CSE-MsgGUID: Icpv830fS2qnps+hRwRZ0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="24074710"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="24074710"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 04:57:55 -0700
X-CSE-ConnectionGUID: AN3CRyX3TEyjq+2mjWOAVg==
X-CSE-MsgGUID: tescbFueRZCiRT1Yv66pUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="65249228"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by orviesa006.jf.intel.com with SMTP; 03 Sep 2024 04:57:44 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Tue, 03 Sep 2024 14:57:43 +0300
Date: Tue, 3 Sep 2024 14:57:43 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Benson Leung <bleung@chromium.org>,
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Guenter Roeck <groeck@chromium.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Lee Jones <lee@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ivan Orlov <ivan.orlov0322@gmail.com>, linux-acpi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH v4 04/18] usb: typec: Add device managed
 typec_mux_register()
Message-ID: <Ztb5twUp15phr1H5@kuha.fi.intel.com>
References: <20240901040658.157425-1-swboyd@chromium.org>
 <20240901040658.157425-5-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240901040658.157425-5-swboyd@chromium.org>

> diff --git a/include/linux/usb/typec_mux.h b/include/linux/usb/typec_mux.h
> index efb5ed32b813..08431f0896d5 100644
> --- a/include/linux/usb/typec_mux.h
> +++ b/include/linux/usb/typec_mux.h
> @@ -99,6 +99,8 @@ int typec_mux_set(struct typec_mux *mux, struct typec_mux_state *state);
>  
>  struct typec_mux_dev *
>  typec_mux_register(struct device *parent, const struct typec_mux_desc *desc);
> +struct typec_mux_dev *
> +devm_typec_mux_register(struct device *parent, const struct typec_mux_desc *desc);
>  void typec_mux_unregister(struct typec_mux_dev *mux);
>  
>  void typec_mux_set_drvdata(struct typec_mux_dev *mux, void *data);
> @@ -123,6 +125,11 @@ typec_mux_register(struct device *parent, const struct typec_mux_desc *desc)
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
> +static inline struct typec_mux_dev *
> +devm_typec_mux_register(struct device *parent, const struct typec_mux_desc *desc)
> +{
> +	return typec_mux_register(parent, desc);

Please just return the error directly here.

> +}

thanks,

-- 
heikki
