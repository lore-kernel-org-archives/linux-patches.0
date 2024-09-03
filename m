Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935B53A267
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 22:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725402018; cv=none; b=XvR6lFvPMLOT8kpSjJYT9JA9m4lOXywap0SVlfyo7nJ5PQe1WAlWwRf0Hc4F3vuKijdork6+t2gLb6X77bU9S3AHCrzrwE66Njsi2Y67QJvOWha4dN005d4XNNjSaVGQMUQ3/Nt/iHDgIme9qUH/6TtHA2e0CCcS5Ue5MNre8qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725402018; c=relaxed/simple;
	bh=VgukLIdAqyeSxA2DG9cLyohXbxxYr/YDX0u8EHAwkCo=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XzwmHJDziKcocTUKe2dS+9UN6IlvFMpc3sTD8O3LlOrT1mwosT0v07rYU+SbMkKsyo35yGyjc17AckbSMx9nZFH2zC8DRhdaSjeba5IDxtfT2ANv4F2lFdd7jUVvQ1fJFdERa12kAPRO0/yrZOjWBIg3eXn463DUGHg2nptKI8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jKviTMFM; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jKviTMFM"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6d74ff7216eso23101987b3.1
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 15:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1725402015; x=1726006815; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+hY8C/Csnv3M/LgsDuLYd+cu/lwq52aGSpQU/ytorc=;
        b=jKviTMFMH9Zs2jFtyEtmIpih1Q1Anj1/OGdjcdaGOjMoW3mrx/44quVA9298Nhd+jF
         8dPtoAsCULuOXBlw1NIcHCVqDPpOBM9YHjOnjmtgZsRdNebJ/ut9pgr5cbXxxezgR239
         pbVvP5D3aSuE9s44v3bsTUJAN40Ke97IrI4aI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725402015; x=1726006815;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+hY8C/Csnv3M/LgsDuLYd+cu/lwq52aGSpQU/ytorc=;
        b=EtRVtIPw7lSR9hqeNXcvqXs+WCa7vMhcahXrAgfnY471oGfRCWgcJGqCkpuovbOHWm
         k4qMtkKuD21NwTgadaEcYryzxB1HSmJ8llKfPMXgH0OOHXA6kzZ/cdeiFsNhoUre1HIx
         QBWZHsgdG2vnapAOtvIS0PCBXZOFNRXlSMq13L8w+4+hHqV7aWF3UjsXPZTifpkhZTCN
         EO6rhJY2Waf02weJmreYQd38i00+e1XsqnlIsoyjH+M91UBidi0VqqMstI9Aezbv94D9
         XToGNEI0fxUOTTneWNSvW2ITOGwXUODoY5GjDdnXw8S2Dx92r+sxH6U3kXbqaXiVySYA
         B8aw==
X-Forwarded-Encrypted: i=1; AJvYcCWO1AepH9yhkfAkyKOr/wM0pWArroS4d5583J/SKG2w2tMqu4tqLEPadKq3/lji6nlxv206sjQt@lists.linux.dev
X-Gm-Message-State: AOJu0YxwYTDVC6oK82yC7tUlo09aAbzbHulvPwUSnHIsLUnkiet7xoZU
	D5aCEUb48xxT502JqAY5VVBriC7s9CeF1B+IRaPCbqevUF2ptrgH6vtyqreawlH4cx7QR12+yro
	YQD9A2Q11L+Z8E2FIKx54KmkFf+Bfn1pkYUjM
X-Google-Smtp-Source: AGHT+IFwXAJ53tzp721XKIBWOOUK4nFlwB+WIRkuEoAHaKs0HLbFhY0QtOfcaSBF6O58JI106A7GqiGJo71sW3vWmWA=
X-Received: by 2002:a05:690c:fca:b0:6af:8662:ff37 with SMTP id
 00721157ae682-6d40f82a5e9mr204127277b3.21.1725402015390; Tue, 03 Sep 2024
 15:20:15 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 Sep 2024 18:20:14 -0400
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZtWjEudmlR51zkU9@smile.fi.intel.com>
References: <20240901040658.157425-1-swboyd@chromium.org> <20240901040658.157425-7-swboyd@chromium.org>
 <ZtWjEudmlR51zkU9@smile.fi.intel.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 3 Sep 2024 18:20:14 -0400
Message-ID: <CAE-0n51eSxxvnJXwnfPrXx1=rei=8OGGEtCAgw6nhCktZ0iQDw@mail.gmail.com>
Subject: Re: [PATCH v4 06/18] drm/bridge: aux-hpd: Support USB Type-C DP
 altmodes via DRM lane assignment
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

Quoting Andy Shevchenko (2024-09-02 04:35:46)
> On Sat, Aug 31, 2024 at 09:06:44PM -0700, Stephen Boyd wrote:
> > Extend the aux-hpd bridge driver to support assigning DP lanes to USB
> > type-c pins based on typec mux state entry. Existing users of this
> > driver only need the HPD signaling support, so leave that in place and
> > wrap the code with a variant that supports more features of USB type-c
>
> Isn't the proper spelling "USB Type-C"?

Perhaps in a title?

>
> > DP altmode, i.e. pin configurations. Prefix that code with
> > 'drm_dp_typec_bridge' to differentiate it from the existing
> > 'drm_aux_hpd_bridge' code.
> >
> > Parse the struct typec_mux_state members to determine if DP altmode has
> > been entered and if HPD is asserted or not. Signal HPD to the drm bridge
> > chain when HPD is asserted. Similarly, parse the pin assignment and map
> > the DP lanes to the usb-c output lanes, taking into account any lane
> > remapping from the data-lanes endpoint property. Pass that lane mapping
> > to the previous drm_bridge in the bridge chain during the atomic check
> > phase.
>
> ...
>
> > +static inline struct drm_dp_typec_bridge_data *
> > +hpd_bridge_to_typec_bridge_data(struct drm_aux_hpd_bridge_data *hpd_data)
> > +{
> > +     return container_of(hpd_data, struct drm_dp_typec_bridge_data, hpd_bridge);
>
> + container_of.h ?
>
> With that said, can the argument be const here?

You mean 'hpd_data'? Don't think so because then we would want
container_of_const(), and to return a const pointer from this function
when drm_dp_typec_bridge_assign_pins() wants to modify struct
drm_dp_typec_bridge_data::num_lanes.

>
> > +}
>
> ...
>
> Ditto for the two more helpers, added in this change.

Ditto.

>
> ...
>
> > +static void drm_dp_typec_bridge_release(struct device *dev)
> > +{
> > +     struct drm_dp_typec_bridge_dev *typec_bridge_dev;
> > +     struct auxiliary_device *adev;
> > +
> > +     typec_bridge_dev = to_drm_dp_typec_bridge_dev(dev);
> > +     adev = &typec_bridge_dev->adev;
> > +
> > +     ida_free(&drm_aux_hpd_bridge_ida, adev->id);
>
> > +     of_node_put(adev->dev.platform_data);
> > +     of_node_put(adev->dev.of_node);
>
> I'm wondering why it's not made fwnode to begin with...
> From the file / function names it's not obvious that it's OF-only code. Neither
> there is no explanations why this must be OF-only code (among all fwnode types
> supported).

When in Rome? The drm_bridge code doesn't work with fwnode today, and
making it support fwnode is a much larger change. I'm not going to make
drm_bridge work with fwnode. Maybe when ACPI describes elements in the
display chain we can convert drm_bridge to use fwnode.

>
> > +     kfree(typec_bridge_dev);
> > +}
>
> ...
>
> > +             return ERR_PTR(dev_err_probe(parent, -ENODEV, "Missing typec endpoint(s) port@0\n"));
>
> We have a new helper for such cases.

Thanks!

>
> ...
>
> > +     adev->dev.of_node = of_node_get(parent->of_node);
>
> device_set_node() ?

Or device_set_of_node_from_dev()?

>
> ...
>
> > +     ret = auxiliary_device_init(adev);
> > +     if (ret) {
> > +             of_node_put(adev->dev.platform_data);
> > +             of_node_put(adev->dev.of_node);
> > +             ida_free(&drm_aux_hpd_bridge_ida, adev->id);
> > +             kfree(adev);
> > +             return ERR_PTR(ret);
>
> Can cleanup.h be utilised here and in other error paths in this function?

It looks like we can set these later and save on the of_node_put()s
until after the auxiliary_device_init() is called. Doing that allows
them to be in one place, the release function.

> > +static int dp_lane_to_typec_lane(enum dp_lane lane)
> > +{
> > +     switch (lane) {
> > +     case DP_ML0:
> > +             return USB_SSTX2;
> > +     case DP_ML1:
> > +             return USB_SSRX2;
> > +     case DP_ML2:
> > +             return USB_SSTX1;
> > +     case DP_ML3:
> > +             return USB_SSRX1;
> > +     }
>
> > +     return -EINVAL;
>
> Hmm... This can be simply made as default case.

And then the enum is always "covered" and the compiler doesn't complain
about missing cases (I don't think we have -Wswitch-enum)? Seems worse.

>
> > +}
>
> ...
>
> > +     for (i = 0; i < num_lanes; i++) {
> > +             /* Get physical type-c lane for DP lane */
> > +             typec_lane = dp_lane_to_typec_lane(i);
> > +             if (typec_lane < 0) {
> > +                     dev_err(&adev->dev, "Invalid type-c lane configuration at DP_ML%d\n", i);
> > +                     return -EINVAL;
>
> Most likely typec_lane contains an error code here. If yes, it would be rather
>
>                         return typec_lane;
>
> If no, why not make that happen?

Sure.

>
> > +static int drm_dp_typec_bridge_atomic_check(struct drm_bridge *bridge,
> > +                                        struct drm_bridge_state *bridge_state,
> > +                                        struct drm_crtc_state *crtc_state,
> > +                                        struct drm_connector_state *conn_state)
> > +{
> > +     struct drm_dp_typec_bridge_data *data;
> > +     struct drm_lane_cfg *in_lanes;
> > +     u8 *dp_lanes;
> > +     size_t num_lanes;
>
> > +     int i;
>
> Does it need to be signed? Can it theoretically overflow as num_lanes defined
> as size_t?

I guess it could but seems highly unlikely. Using unsigned is fine.

>
> > +             port->typec_data = typec_data;
> > +             if (of_property_read_u32_array(ep.local_node, "data-lanes",
> > +                                            port->lane_mapping,
> > +                                            ARRAY_SIZE(port->lane_mapping))) {
>
> > +                     memcpy(port->lane_mapping, mapping, sizeof(mapping));
>
> Hmm... I'm wondering if direct assignment will save a few .text bytes
>
>                 port->lane_mapping = ...;
>                 of_property_read_u32_array(ep.local_node, "data-lanes",
>                                            port->lane_mapping,
>                                            ARRAY_SIZE(port->lane_mapping));
>
> Also note that conditional is not needed in this case.
>

Ok. I'm fine with either way here. Maybe Dmitry has an opinion.
