Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B7E2BAF9
	for <patches@lists.linux.dev>; Sat,  9 Nov 2024 07:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731135926; cv=none; b=lA6XDCDVK6aFszhSAiKtj2geMXNY4YDL/ABVdt239ZIY0Z4vY8v83ZJ+wZJylVWjuGL5W/FNRPoM39/Imv/DUuZZ70Xb/9vTiZyB/2fy3Pvv0u+wskJAdDf6sCrJi+gcVVNyaN9h0BbvJLiAg0Kml5cexbYsfw2a9bddkxDFWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731135926; c=relaxed/simple;
	bh=QBWrQAZe4RkfnNpuxREn7Ccetz0FPBegWZvSqiF28qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEQbeaUFKie8B5RdrCxeeQw1cAMLTbrbQFc9gcCSyOReHOYe+846Zg7eVJESiRGSEi4WnqAU7R/tQI9pjyZECM3vSSkHCM3cCJVxCk2OxX1n8KU/mIleWYQ682kdgWT5RpjxXHSD10z23jSuXFauPJFE3HWEUDQSWGF5v5X1/48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ja4PNQWX; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ja4PNQWX"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-539f2b95775so3943634e87.1
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 23:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731135923; x=1731740723; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qK89Gn/2BNMULqn/Te3QgPk+7HsFVw5alc1hlF/PKtw=;
        b=Ja4PNQWXRWjl2qB5dJIZIm1+naze3KoVXzXa+zsYLdL3+Mumi6pnwm0G5YVqtm7b0m
         +8HK9Yk1Kk5oFZOpjfkV3jdoKOphtbhkHl/q5QBIc0/NuZs74fTEe7Cp+qzMEeLJL3mW
         CwmCnxOc4mW1V9aAZ1BbJ4azXwk8g8ZctF4F1mIxS9i3/AWjaudkhsvej7c/K/4HcPQo
         r2FmclDUxu3LKqgX5vhONjS1G2tvqWxPki/yKkco30JsUvf7CwvXOn62JJN06yZGvpVc
         W48nzEqvpjrfwNZrADswCtcSIIVSppw/rwMKkMvvXzJBnYyy2FBev0CqMqjU8XoyF/Dt
         xhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731135923; x=1731740723;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qK89Gn/2BNMULqn/Te3QgPk+7HsFVw5alc1hlF/PKtw=;
        b=daXaYAEhs0AqY45sXclMWmEhKbKQTl65sgKV/xB5XPGLeemDkcNrzWTPTA8sxUCA2s
         +YhqK9Jl9PqkBJiBX6HcS9IJwjJV2OiNt7NUWfdq2eRVGqCl+Od16YjENVeiBuIdVnaH
         V9xGOddBkBrbJk2AcQgKYn2P99scst+h7ZadFFgZ+qAWvlkprOXwY9w27Jyhz5N62sf2
         Pkt405GYi5ca82aje4ChyTEpPPD+mtAE4mWI8Xhx3PG/F7fyNzzGvvp8b5pG+GoLw0vS
         Rodg1ZdDR0u8E6KlTPo6szAuUOof+UbRMojFUxt2iTBq4BhjeOZZIsAtUCtm+13I/6Y6
         7GFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMaGknk4qjBMEC+UxI5CH0DG6nUYOUq+95R9Rd7nx9y7UKOY5BYCEKGuVzzbsEni5Kzdga1pYP@lists.linux.dev
X-Gm-Message-State: AOJu0YzI4F+oFaxjFq91lv5eX+2jCqjPUmCi7pW/V0R0SZv/4gx6wPkI
	9JskpUScl+5ioXNLt6kqxtzs59L+3/T5jljiHWXGUp0NqQhHCC9snqcED0X7JC4=
X-Google-Smtp-Source: AGHT+IFDj1LLmHbRZOO+/S6hnT+C0wYhtqnCl28IZmhVg58DIluM8aGKuUuRjj41zc6/5ThGI4Rqiw==
X-Received: by 2002:a05:6512:b83:b0:536:53e3:feae with SMTP id 2adb3069b0e04-53d862bebd9mr4269153e87.11.1731135922597;
        Fri, 08 Nov 2024 23:05:22 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53d82678641sm852333e87.10.2024.11.08.23.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 23:05:21 -0800 (PST)
Date: Sat, 9 Nov 2024 09:05:18 +0200
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
	Sakari Ailus <sakari.ailus@linux.intel.com>, Vinod Koul <vkoul@kernel.org>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 15/18] dt-bindings: usb: Add ports to
 google,cros-ec-typec for DP altmode
Message-ID: <hqmx7jtkvrwvb27n56hw7rpefhp37lhr3a5fawz7gsl76uuj5s@h7m6wpdhibkk>
References: <20240901040658.157425-1-swboyd@chromium.org>
 <20240901040658.157425-16-swboyd@chromium.org>
 <phdcjgqqpjpruxp7v2mw446q73xr3eg4wfgfbjw5tasgr2pgg2@77swbk47b2tg>
 <CAE-0n514QMaQC2yjKP8bZqyfbv6B3AQm=+NJ87vxo6NdYiL03A@mail.gmail.com>
 <lf7y7wpuca6kzqcglgs5d443iusf7xjocum4adi7t3npfavccx@zgsp37oyztme>
 <CAE-0n53-KmOS3zXmJPvOOZ7xxkek9-S=oBExgaY0PDnt_HjdNw@mail.gmail.com>
 <yk3xidaisbd56yndaucax7otijjauqmm7lqm6q4q633kdawlqo@qaq27lwxmvwd>
 <CAE-0n501j+8bMnMKabFyZjn+MLUy3Z68Hiv1PsfW0APy5ggN8g@mail.gmail.com>
 <gstohhcdnmnkszk4l2ikd5xiewtotgo5okia62paauj6zpaw7y@4wchyvoynm2p>
 <CAE-0n50z6MNa7WOsg-NU7k8BpFeJJyYfHX3ov6DsthLWauSNpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n50z6MNa7WOsg-NU7k8BpFeJJyYfHX3ov6DsthLWauSNpA@mail.gmail.com>

On Thu, Nov 07, 2024 at 04:28:24PM -0800, Stephen Boyd wrote:
> Quoting Dmitry Baryshkov (2024-10-31 15:54:49)
> > On Thu, Oct 31, 2024 at 02:45:29PM -0700, Stephen Boyd wrote:
> > > Quoting Dmitry Baryshkov (2024-10-31 11:42:36)
> > > > On Tue, Oct 29, 2024 at 01:15:51PM -0700, Stephen Boyd wrote:
> > >
> > > Or use a displayport property that goes to connector node itself so that
> > > we don't extend the graph binding of the usb-c-connector.
> > >
> > >   cros-ec-typec {
> > >     usb-c-connector@0 {
> > >       altmodes {
> > >         displayport {
> > >           connector = <&dp_ml0_ml1>;
> >
> > I think this has been frowned upon. Not exactly this, but adding the
> > displayport = <&foo>.
> 
> Do you have a pointer to that discussion? I'd like to understand the
> reasoning.

No, unfortunately I couldn't find it.

> 
> 
> >
> > Thus it can only go to the swnode that is generated in software by the
> > cros-ec driver.
> 
> I recall swnode as a way to sidestep figuring out the DT bindings for
> usb typec. Where is this swnode being made? Somewhere inside the typec
> framework?

In the cros-ec driver?

> 
> >
> > >         };
> > >       };
> > >       port@1 {
> > >         endpoint@0 {
> > >           remote-endpoint = <&hub_ss0>;
> > >        };
> > >       };
> > >     };
> > >     usb-c-connector@1 {
> > >       altmodes {
> > >         displayport {
> > >           connector = <&dp_ml2_ml3>;
> > >         };
> > >       };
> > >       port@1 {
> > >         endpoint {
> [....]
> > >
> > > >
> > > > Maybe that's just it? Register DP_bridge (or QMP PHY) as
> > > > orientation-switch? Then you don't need any extra API for the lane
> > > > mapping? The cross-ec-typec can provide orientation information and the
> > > > USB-C-aware controller will follow the lane mapping.
> > >
> > > I'm not really following but I don't think the DT binding discussed here
> > > prevents that.
> >
> > I'm thinking about:
> >
> > it6505 {
> >   orientation-switch;
> >
> >   ports {
> >     port@1 {
> >       it6505_dp_out: remote-endpoint = <&cros_ec_dp>;
> >       data-lanes = <0 1>;
> >     };
> >   };
> > };
> >
> > cros-ec {
> >   port {
> >     cross_ec_dp: remote-endpoint = <&it6505_dp_out>;
> >   };
> >
> >   connector@0 {
> >     reg = <0>;
> >     cros,dp-orientation = "normal";
> >
> >     ports {
> >       // all USB HS and SS ports as usual;
> >     };
> >   };
> >
> >   connector@1 {
> >     reg = <1>;
> >     cros,dp-orientation = "reverse";
> >
> >     ports {
> >       // all USB HS and SS ports as usual;
> >     };
> >   };
> >
> >   connector@2 {
> >     reg = <2>;
> >     cros,dp-orientation = "reverse";
> >
> >     ports {
> >       // all USB HS and SS ports as usual;
> >     };
> >   };
> >
> >   connector@3 {
> >     reg = <3>;
> >     cros,dp-orientation = "normal";
> >
> >     ports {
> >       // all USB HS and SS ports as usual;
> >     };
> >   };
> > };
> >
> > The cros-ec registers single drm bridge which will generate HPD events
> > except on Trogdor, etc. At the same time, cros-ec requests the
> > typec_switch_get(). When the cros-ec detects that the connector@N it
> > being used for DP, it just generates corresponding typec_switch_set()
> > call, setting the orientation of the it6505 (or QMP PHY). The rest can
> > be handled either by EC's HPD code or by DP's HPD handler, the
> > orientation should already be a correct one.
> >
> > So, yes. It requires adding the typec_switch_desc implementation _in_
> > the it6505 (or in any other component which handles the 0-1 or 2-3
> > selection). On the other hand as I wrote previously, the 0-1 / 2-3 is
> > the USB-C functionality, not the DP one.
> >
> 
> I don't think we should be adding typec code to pure display hardware
> drivers like IT6505. To keep the driver focused on display stuff I
> proposed implementing runtime lane assignment for drm_bridge chains
> because DP has lanes. My understanding is that not all display
> technologies have lanes, so implementing generic lane assignment
> functionality is overkill/incorrect. DP has physical lanes in hardware
> though, and those physical lanes are assigned to certain pins in the
> type-c DP altmode spec, so it's not overkill to think about lanes when
> the bridge is a DP bridge wired up to a type-c connector.

DisplayPort has fixed lanes assignment in the standard. So any driver
that reassigns / reallocates DisplayPort lanes dynamically implements
Type-C functionality.

> Long story short, I don't see how we can avoid _any_ lane assignment
> logic in drm_bridge. The logic shouldn't walk the entire bridge chain,
> but it should at least act on the bridge that is a DP bridge. I think
> you're saying pretty much the same thing here, but you want the lane
> remapping to be done via the typec layer whereas I want it to be done in
> the drm_bridge layer. To me it looks out of place to add a
> typec_switch_desc inside each DP drm_bridge because we duplicate the
> logic about USB type-c DP altmode lane assignment to each DP bridge. A
> DP bridge should just think about DP and not know or care about USB
> type-c.
> 
> This is what's leading me to think we need some sort of lane assignment
> capability at the DP connector. How that assignment flows from the DP
> connector created in drm_bridge_connector.c to the hardware is where it
> is less clear to me. Should that be implemented as a typec_switch_desc,
> essentially out of band with drm_bridge, or as some drm_bridge_funcs
> function similar to struct drm_bridge_funcs::hdmi_*()? If you look at
> IT6505 in it6505_get_extcon_property() it actually wants to pull the
> orientation of the type-c port with extcon_get_property(EXTCON_DISP_DP,
> EXTCON_PROP_USB_TYPEC_POLARITY). Maybe pushing the orientation to the DP
> bridge is backwards and we should be exposing this as some sort of
> connector API that the drm_bridge can query whenever it wants.

And it6505_get_extcon_property() / EXTCON_PROP_USB_TYPEC_POLARITY is a
Type-C code, isn't it?

> What about ANX7625 where two DP lanes go to a cross-point switch before
> leaving the chip on one of two pairs of lanes? This hardware is a DP
> bridge smashed together with an orientation switch (typec_switch_desc)
> so that you can simply wire the output pins up to a USB type-c connector
> and support 2 lanes DP altmode. Qualcomm's QMP phy is quite similar.
> Presumably we'd want the ANX driver to implement both a drm_bridge and a
> typec_switch_desc if it was directly connected to a usb-c-connector
> node. It's also interesting to think of the DT binding here, likely we
> would have one output port in the ANX node's graph that represents the
> combined DP and USB data that's connected to the SuperSpeed endpoint in
> the usb-c-connector.
> 
> In the case where two lanes are wired to one USB type-c connector and
> the other two lanes are wired to a different USB type-c connector it
> would be odd to keep the typec_switch_desc and figure out a way to
> mangle the lanes we want for a USB type-c connector by setting the
> orientation of the typec_switch_desc. The chip isn't really acting as a
> typec orientation control here because it isn't combining USB data and
> DP data for a single USB type-c port. In fact, the type-c port has an
> orientation and we actively don't want to tell the ANX7625 driver about
> that port orientation because the orientation control is implemented
> between the ANX part and the type-c connector by some redriver
> controlled by the EC.
> 
> To satisfy all these cases it almost feels like we need to make the DP
> connector have an "orientation", per your earlier DT snippet it would be
> "reversed" or "normal", even though in hardware a DP connector has no
> such concept because it can only be plugged in one way. All cases look
> to be covered if we say that the drm_connector can have an orientation,
> "normal" or "reversed", and we allow the bridge drivers to query that
> whenever they want with some bridge/connector API. The typical case will
> be that the orientation is normal, but we can make
> drm_connector_oob_hotplug_event() change that to "reversed" when the
> port is different.

The DP connector doesn't have the orientation, as you pointed out. Only
Type-C does.

> 
> This leaves us with the binding you propose above, and then some sort of
> property that indicates the orientation of the DP connector. Instead of
> being vendor specific I wonder if we can simply have a property like
> "dp-reverse-orientation" in the connector node that the displayport.c
> driver can look for to set the connector orientation to the reverse one
> when DP altmode is entered on the port.
> 
> This is what I have:
> 
>  it6505 {
>    ports {
>      port@1 {
>        it6505_dp_out: remote-endpoint = <&cros_ec_dp>;
>        data-lanes = <0 1>;
>      };
>    };
>  };
> 
>  cros-ec {
>    port {
>      cross_ec_dp: remote-endpoint = <&it6505_dp_out>;
>    };
> 
>    connector@0 {
>      reg = <0>;
> 
>      ports {
>        // all USB HS and SS ports as usual;
>      };
>    };
> 
>    connector@1 {
>      reg = <1>;
>      dp-reverse-orientation;
> 
>      ports {
>        // all USB HS and SS ports as usual;
>      };
>    };
> 
> or ANX, swap out for it6505 node:
> 
>  anx7625 {
>    ports {
>      port@1 {
>        anx7625_dp_out: remote-endpoint = <&cros_ec_dp>;
>        data-lanes = <0 1>;
>      };
>    };
>  };
> 
> and then a drm_bridge is created in cros-ec to terminate the bridge
> chain. The displayport altmode driver will find the drm_bridge and the
> drm_connector from the cros-ec node. When DP altmode is entered the
> displayport altmode driver will set the drm_connector orientation based
> on the presence of the dp-reverse-orientation property. We'll be able to
> hook the hpd_notify() path in cros-ec by adding code to the drm_bridge
> made there to do the HPD workaround. I'm not sure we need to use an
> auxiliary device in this case, because it's a one-off solution for
> cros-ec. And we don't even need to signal HPD from the cros-ec
> drm_bridge because the oob_hotplug event will do it for us. If anything,
> we need that displayport.c code to skip sending the hotplug event when
> "no-hpd" is present in the cros-ec node. Note, this works for any number
> of usb-c-connector nodes. And finally, DP bridges like IT6505 don't need
> to implement a typec_switch_desc, they can simply support flipping the
> orientation by querying the drm_connector for the bridge chain when they
> see fit. ANX7625 can support that as well when it doesn't see the
> 'orientation-switch' property.
> 
> Did I miss anything? I suspect a drm_connector having an orientation is
> the most controversial part of this proposal.

Yes... I understand that having orientation-switch handling in the DRM
driver sounds strange, but this is what we do in the QMP PHY driver. It
makes the code easier, as it keeps lane remapping local to the place
where it belongs - to the Type-C handlers.


-- 
With best wishes
Dmitry
