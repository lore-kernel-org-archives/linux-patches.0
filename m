Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C93619AA5F
	for <patches@lists.linux.dev>; Thu, 19 Sep 2024 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726742427; cv=none; b=bUecuehjxVBh2q3/FghfP69V0ITSLTscw/GB8Zfslm/X/GgDwaeCJs88IrP0gHBwo9h9sIcWSZB6mqYPP63IQtSAjrwQE74HydkyV/AG4yR0dd6TOoDvgILyyO6s+ETIMKIK7fcEWRZNBx/u8uAQYhJ7jiyeDrwXmeuZEOdmZhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726742427; c=relaxed/simple;
	bh=qoDUajQehGlYjPE+EFxWKCbmqWSP7/qcihd+c2Gym3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwKo4rQaVdpZoySmL+8OJUJbfO66z1CLaAcddRZYJKDOEl9gtocsYiLU8208QYDPv3mknDJ7DL4oVyd4ClId/VEDbZiFpRLyOhrW7SDGRyDBKsg54wKkgR6poFBBfnfv2NsWzwvc67SCZCzRFBY8BVdpE2HxUq0f3iGhl1CscoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XV6igX9C; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XV6igX9C"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5356bb5522bso848675e87.1
        for <patches@lists.linux.dev>; Thu, 19 Sep 2024 03:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726742423; x=1727347223; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tlp0Vtf+ppPpgYrefgR4cL8ADFuvH9H5/WfU6RLRJKw=;
        b=XV6igX9CH49lwR4T3MA0FWf7jsFr91qpElGleSIhLs3L3mzHumvNczxzQjKrhvF1SP
         8JTQlv3nqaoryCPFYDTbrSD8fgq9R5Tijy+2NingaMFCBYgwJjw4NIAfaxVx0aw/8jaS
         67LAEHKqCT0AmJcz/fA3E8RXYm01lZ5YxmERFQ0kRuo/cM97+jB/oVx+x8OfLYAgEz5i
         b82n53HrJvLJUglYGmuJfjF9puauJYIrPnO9XTrQ6haxe+LImGTV8X8ovE51cTzqPObJ
         HTHi8QSBhZuoHTUdsgHZDegcKXRBZnx2RIz5XBNo+T/IKxalO3ujdnQdsVlNN4jb0R+S
         NxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726742423; x=1727347223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tlp0Vtf+ppPpgYrefgR4cL8ADFuvH9H5/WfU6RLRJKw=;
        b=jIqDTM4l7q2PEMKA+mg4BpiIXFut1rJqbELzYjFZT73ei2j8sEy66g+9Ph7q979U7q
         KhZT8F0ZA+EqtuGyuuVFyt9MPyjFPHyQnHTbk0gUxnzY7Asb9o6CTDu43zlOPGlyU83y
         95wLfZ1Q6zgDjPZf2btGZ6fTGZ33Nc87LDZ9MaU9XcM5oA/slxshfvnLlgd7kDPCrdsm
         EFJh4gSqnKq5OHwWCI8YS7yVDqWcw+rh4jIZTMiR6FqolVDzenKukdHd/0wPC8jWfAFe
         ws6aoW+5aevA7YzRi4meI0JURSdjjvIbzZ9UB+hL+3wP6fVYV4sBtc/UucIZeS3pnNPZ
         hKMw==
X-Forwarded-Encrypted: i=1; AJvYcCVi+C6DLfEaJlsbY2XtaQh9990e1ga9IhFt3ungvFYqKTVg/JguvAfDKLa0Pooit/NJ+c9p7UuU@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1xGUkN751qxaawmk0gROd6jN+AKUt3d61ea0o3BDnSsIEY7ia
	2XYrfkN/tHdbv4tyAxNen4j7z2LigRH5eHB8oIpU0Y/8ynyf9k7dEo4OtC5qh3c0F9Ij/pYJYi6
	fIio=
X-Google-Smtp-Source: AGHT+IFsBfQFVXZbIJ+oDVW1NrcdVcEb6a89r2YZcMp056f8arAvyaJffZux2dBaqfrkRNgZ76BvOw==
X-Received: by 2002:a05:6512:3d87:b0:535:82eb:21d1 with SMTP id 2adb3069b0e04-5367ff329d7mr11826771e87.57.1726742422532;
        Thu, 19 Sep 2024 03:40:22 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536870b421esm1839803e87.254.2024.09.19.03.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 03:40:20 -0700 (PDT)
Date: Thu, 19 Sep 2024 13:40:19 +0300
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
	Sakari Ailus <sakari.ailus@linux.intel.com>, Vinod Koul <vkoul@kernel.org>, 
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: Re: [PATCH v4 13/18] dt-bindings: usb-switch: Extend for DisplayPort
 altmode
Message-ID: <27acewh6h2xcwp63z5o3tgrjmimf4d3mftpnmkvhdhv273zgsp@i6i5ke4btdqx>
References: <20240901040658.157425-1-swboyd@chromium.org>
 <20240901040658.157425-14-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240901040658.157425-14-swboyd@chromium.org>

On Sat, Aug 31, 2024 at 09:06:51PM GMT, Stephen Boyd wrote:
> Extend the usb-switch binding to support DisplayPort (DP) alternate
> modes. A third port for the DP signal is necessary when a mode-switch is
> muxing USB and DP together onto a usb type-c connector. Add data-lanes
> to the usbc output node to allow a device using this binding to remap
> the data lanes on the output. Add an example to show how this new port
> can be used.
> 
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../devicetree/bindings/usb/usb-switch.yaml   | 89 +++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-switch.yaml b/Documentation/devicetree/bindings/usb/usb-switch.yaml
> index f5dc7e23b134..816f295f322f 100644
> --- a/Documentation/devicetree/bindings/usb/usb-switch.yaml
> +++ b/Documentation/devicetree/bindings/usb/usb-switch.yaml
> @@ -52,6 +52,14 @@ properties:
>            endpoint:
>              $ref: '#/$defs/usbc-in-endpoint'
>  
> +      port@2:
> +        $ref: /schemas/graph.yaml#/$defs/port-base
> +        unevaluatedProperties: false
> +
> +        properties:
> +          endpoint:
> +            $ref: '#/$defs/dp-endpoint'

Is it a separate port or is it an endpoint of the same upstream-facing
(non-connector-facing) SS port?

> +
>  oneOf:
>    - required:
>        - port
> @@ -65,6 +73,19 @@ $defs:
>      $ref: /schemas/graph.yaml#/$defs/endpoint-base
>      description: Super Speed (SS) output endpoint to a type-c connector
>      unevaluatedProperties: false
> +    properties:
> +      data-lanes:
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        description: |
> +          An array of physical USB Type-C data lane indexes.
> +          - 0 is SSRX1 lane
> +          - 1 is SSTX1 lane
> +          - 2 is SSTX2 lane
> +          - 3 is SSRX2 lane
> +        minItems: 4
> +        maxItems: 4
> +        items:
> +          maximum: 3

What is the usecase to delare less than 4 lanes going to the USB-C
connector?

>  
>    usbc-in-endpoint:
>      $ref: /schemas/graph.yaml#/$defs/endpoint-base
> @@ -79,7 +100,75 @@ $defs:
>          items:
>            maximum: 8
>  
> +  dp-endpoint:
> +    $ref: /schemas/graph.yaml#/$defs/endpoint-base
> +    description: DisplayPort (DP) input from the DP PHY
> +    unevaluatedProperties: false
> +    properties:
> +      data-lanes:
> +        $ref: /schemas/types.yaml#/definitions/uint32-array
> +        description: |
> +          An array of physical DP data lane indexes
> +          - 0 is DP ML0 lane
> +          - 1 is DP ML1 lane
> +          - 2 is DP ML2 lane
> +          - 3 is DP ML3 lane
> +        oneOf:
> +          - items:
> +              - const: 0
> +              - const: 1
> +          - items:
> +              - const: 0
> +              - const: 1
> +              - const: 2
> +              - const: 3
> +
>  examples:
> +  # A USB + DP mode and orientation switch which muxes DP altmode
> +  # and USB onto a usb-c-connector node.
> +  - |
> +    device {
> +      mode-switch;
> +      orientation-switch;
> +
> +      ports {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        port@0 {
> +          reg = <0>;
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          endpoint {
> +            remote-endpoint = <&usb_c_connector>;
> +            data-lanes = <0 1 2 3>;
> +          };
> +        };
> +
> +        port@1 {
> +          reg = <1>;
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          endpoint {
> +            remote-endpoint = <&usb_ss_phy>;
> +          };
> +        };
> +
> +        port@2 {
> +          reg = <2>;
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          endpoint {
> +            remote-endpoint = <&dp_phy>;
> +            data-lanes = <0 1 2 3>;
> +          };
> +        };
> +      };
> +    };
> +
>    # A USB orientation switch which flips the pin orientation
>    # for a usb-c-connector node.
>    - |
> -- 
> https://chromeos.dev
> 

-- 
With best wishes
Dmitry
