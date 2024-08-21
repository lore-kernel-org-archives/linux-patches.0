Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C313B28D;
	Wed, 21 Aug 2024 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724256780; cv=none; b=ZZZE/M5TGG1WpNaf7io75fqmdKcJ0hRWAOQIXIdYzxK/XSYy0UBjohvCdcI8JbMonvi9+pfptdqtE1P+Tbwpyh0zD6KHLMeSlLRpJaHVldP07j4h6dHmBCNorXxlb7U0u/CGOtGQitUVsAmhQbFQKJ6BtEx2ZDo1R6NmIP2Teeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724256780; c=relaxed/simple;
	bh=Flc3xbOyZEOgbPFXhXlvBwVlAGJrm2mYMm8ucdPm/xU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=akLHo76f81dGhBUcTmhaYJywRMvtAGpsF8PebGnEMlA6xavmw4LunHUTzltBEz0RX9k3YubDM/DoqPP6sHXgUhvdeW954P0bXkaqWFFReOtclmzyvH44moWCF2ai+bWJgxg8VerJZb8jJ8wF3Rl5Tf0fFvF7pnmKUga6eXP5skk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdGOvond; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdGOvond"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDEDC32786;
	Wed, 21 Aug 2024 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724256779;
	bh=Flc3xbOyZEOgbPFXhXlvBwVlAGJrm2mYMm8ucdPm/xU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WdGOvondpt9OBELJ5oRMPbgeR7j9EAmtqpseYb448Ex+iLf8u+j3oJVIKh/uKC9Q+
	 1McHcxJlnMGDLm7uhZSQWmdfVHHmY9g0pS8zqiztjlU9yN3D2e53whfG8RZcdLEF22
	 MkVSRnzDDXeCQlbtQgxQjVrMY6DO8WGu1pUuaFY8uI4+EJZ4fXzIJtEZV6KzJxp2D9
	 K9qFfWQK8+8NfT/GoNMYRyRPZWmzFS7o9augM8r0z3xvLad8mUeaBK1T17lXXxXsah
	 XfRZOqHIwZcTahIyvfAvNKNvfEnrfF+EfEOKaQ/MbYHwOU65bhkdWLITcuNmWJUziN
	 9X35K1WZU0SmQ==
Date: Wed, 21 Aug 2024 17:12:52 +0100
From: Lee Jones <lee@kernel.org>
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
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: Re: [PATCH v2 07/11] dt-bindings: chrome: Add ports to
 google,cros-ec-typec for DP altmode
Message-ID: <20240821161252.GD6858@google.com>
References: <20240815003417.1175506-1-swboyd@chromium.org>
 <20240815003417.1175506-8-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240815003417.1175506-8-swboyd@chromium.org>

On Wed, 14 Aug 2024, Stephen Boyd wrote:

> Add a DT graph binding to google,cros-ec-typec so that it can combine
> DisplayPort (DP) and USB SuperSpeed (SS) data into a USB type-c endpoint
> that is connected to the usb-c-connector node's SS endpoint. This also
> allows us to connect the DP and USB nodes in the graph to the USB type-c
> connectors, providing the full picture of the USB type-c data flows in
> the system.
> 
> Allow there to be multiple typec nodes underneath the EC node so that
> one DT graph exists per DP bridge. The EC is actually controlling TCPCs
> and redrivers that combine the DP and USB signals together so this more
> accurately reflects the hardware design without introducing yet another
> DT node underneath the EC for USB type-c.
> 
> If the type-c ports are being shared between a single DP controller then
> the ports need to know about each other and determine a policy to drive
> DP to one type-c port. If the type-c ports each have their own dedicated
> DP controller then they're able to operate independently and enter/exit
> DP altmode independently as well. We can't connect the DP controller's
> endpoint to one usb-c-connector port@1 endpoint and the USB controller's
> endpoint to another usb-c-connector port@1 endpoint either because the
> DP muxing case would have DP connected to two usb-c-connector endpoints
> which the graph binding doesn't support.
> 
> Therefore, one typec node is required per the capabilities of the type-c
> port(s) being managed. This also lets us indicate which type-c ports the
> DP controller is wired to. For example, if DP was connected to ports 0
> and 2, while port 1 was connected to another DP controller we wouldn't
> be able to implement that without having some other DT property to
> indicate which output ports are connected to the DP endpoint.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Prashant Malani <pmalani@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Needs to be accompanied by a DT review:

Acked-by: Lee Jones <lee@kernel.org>

> ---
>  .../bindings/chrome/google,cros-ec-typec.yaml | 260 ++++++++++++++++++
>  .../bindings/mfd/google,cros-ec.yaml          |   7 +-
>  2 files changed, 264 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
> index 9f9816fbecbc..1238adfbea21 100644
> --- a/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
> +++ b/Documentation/devicetree/bindings/chrome/google,cros-ec-typec.yaml
> @@ -26,6 +26,137 @@ properties:
>    '#size-cells':
>      const: 0
>  
> +  mux-gpios:
> +    description: GPIOs indicating which way the DP mux is steered
> +    maxItems: 1
> +
> +  no-hpd:
> +    description: Indicates this endpoint doesn't signal HPD for DisplayPort
> +    type: boolean
> +
> +  orientation:
> +    description:
> +      Indicates this endpoint assigns lanes based on altmode and
> +      type-c port orientation
> +    type: boolean
> +
> +  ports:
> +    $ref: /schemas/graph.yaml#/properties/ports
> +
> +    properties:
> +      port@0:
> +        $ref: /schemas/graph.yaml#/$defs/port-base
> +        description:
> +          Input port to receive DisplayPort (DP) data
> +        unevaluatedProperties: false
> +
> +        properties:
> +          endpoint@0:
> +            $ref: /schemas/graph.yaml#/$defs/endpoint-base
> +            description: DisplayPort data for the type-c port(s)
> +            unevaluatedProperties: false
> +            properties:
> +              data-lanes:
> +                $ref: /schemas/types.yaml#/definitions/uint32-array
> +                description: |
> +                  An array of physical DP data lane indexes
> +                  - 0 is DP ML0 lane
> +                  - 1 is DP ML1 lane
> +                  - 2 is DP ML2 lane
> +                  - 3 is DP ML3 lane
> +                oneOf:
> +                  - items:
> +                      - const: 0
> +                      - const: 1
> +                  - items:
> +                      - const: 0
> +                      - const: 1
> +                      - const: 2
> +                      - const: 3
> +
> +        required:
> +          - endpoint@0
> +
> +      port@1:
> +        $ref: /schemas/graph.yaml#/$defs/port-base
> +        unevaluatedProperties: false
> +        description:
> +          Input port to receive USB SuperSpeed (SS) data
> +        patternProperties:
> +          "^endpoint@([0-8])$":
> +            $ref: /schemas/graph.yaml#/properties/endpoint
> +
> +        anyOf:
> +          - required:
> +              - endpoint@0
> +          - required:
> +              - endpoint@1
> +          - required:
> +              - endpoint@2
> +          - required:
> +              - endpoint@3
> +          - required:
> +              - endpoint@4
> +          - required:
> +              - endpoint@5
> +          - required:
> +              - endpoint@6
> +          - required:
> +              - endpoint@7
> +          - required:
> +              - endpoint@8
> +
> +      port@2:
> +        $ref: /schemas/graph.yaml#/$defs/port-base
> +        unevaluatedProperties: false
> +        description: Output ports for combined DP and USB SS data
> +        patternProperties:
> +          "^endpoint@([0-8])$":
> +            $ref: /schemas/graph.yaml#/$defs/endpoint-base
> +            unevaluatedProperties: false
> +
> +            properties:
> +              data-lanes:
> +                $ref: /schemas/types.yaml#/definitions/uint32-array
> +                description: |
> +                  An array of physical USB Type-C data lane indexes.
> +                  - 0 is SSRX1 lane
> +                  - 1 is SSTX1 lane
> +                  - 2 is SSTX2 lane
> +                  - 3 is SSRX2 lane
> +                minItems: 4
> +                maxItems: 4
> +                items:
> +                  maximum: 3
> +
> +        anyOf:
> +          - required:
> +              - endpoint@0
> +          - required:
> +              - endpoint@1
> +          - required:
> +              - endpoint@2
> +          - required:
> +              - endpoint@3
> +          - required:
> +              - endpoint@4
> +          - required:
> +              - endpoint@5
> +          - required:
> +              - endpoint@6
> +          - required:
> +              - endpoint@7
> +          - required:
> +              - endpoint@8
> +
> +    required:
> +      - port@2
> +    anyOf:
> +      - required:
> +          - port@0
> +      - required:
> +          - port@1
> +
>  patternProperties:
>    '^connector@[0-9a-f]+$':
>      $ref: /schemas/connector/usb-connector.yaml#
> @@ -35,6 +166,38 @@ patternProperties:
>  required:
>    - compatible
>  
> +allOf:
> +  - if:
> +      properties:
> +        no-hpd: true
> +      required:
> +        - no-hpd
> +    then:
> +      properties:
> +        ports:
> +          required:
> +            - port@0
> +  - if:
> +      properties:
> +        mux-gpios: true
> +      required:
> +        - mux-gpios
> +    then:
> +      properties:
> +        ports:
> +          required:
> +            - port@0
> +  - if:
> +      properties:
> +        orientation: true
> +      required:
> +        - orientation
> +    then:
> +      properties:
> +        ports:
> +          required:
> +            - port@0
> +
>  additionalProperties: false
>  
>  examples:
> @@ -60,6 +223,103 @@ examples:
>              power-role = "dual";
>              data-role = "dual";
>              try-power-role = "source";
> +
> +            ports {
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              port@0 {
> +                reg = <0>;
> +                usb_c0_hs: endpoint {
> +                  remote-endpoint = <&usb_hub_dfp3_hs>;
> +                };
> +              };
> +
> +              port@1 {
> +                reg = <1>;
> +                usb_c0_ss: endpoint {
> +                  remote-endpoint = <&cros_typec_c0_ss>;
> +                };
> +              };
> +            };
> +          };
> +
> +          connector@1 {
> +            compatible = "usb-c-connector";
> +            reg = <1>;
> +            power-role = "dual";
> +            data-role = "dual";
> +            try-power-role = "source";
> +
> +            ports {
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              port@0 {
> +                reg = <0>;
> +                usb_c1_hs: endpoint {
> +                  remote-endpoint = <&usb_hub_dfp2_hs>;
> +                };
> +              };
> +
> +              port@1 {
> +                reg = <1>;
> +                usb_c1_ss: endpoint {
> +                  remote-endpoint = <&cros_typec_c1_ss>;
> +                };
> +              };
> +            };
> +          };
> +
> +          ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            port@0 {
> +              reg = <0>;
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              dp_in: endpoint@0 {
> +                reg = <0>;
> +                remote-endpoint = <&dp_phy>;
> +                data-lanes = <0 1>;
> +              };
> +            };
> +
> +            port@1 {
> +              reg = <1>;
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              usb_in_0: endpoint@0 {
> +                reg = <0>;
> +                remote-endpoint = <&usb_ss_0_out>;
> +              };
> +
> +              usb_in_1: endpoint@1 {
> +                reg = <1>;
> +                remote-endpoint = <&usb_ss_1_out>;
> +              };
> +            };
> +
> +            port@2 {
> +              reg = <2>;
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              cros_typec_c0_ss: endpoint@0 {
> +                reg = <0>;
> +                remote-endpoint = <&usb_c0_ss>;
> +                data-lanes = <0 1 2 3>;
> +              };
> +
> +              cros_typec_c1_ss: endpoint@1 {
> +                reg = <1>;
> +                remote-endpoint = <&usb_c1_ss>;
> +                data-lanes = <2 3 0 1>;
> +              };
> +            };
>            };
>          };
>        };
> diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> index aac8819bd00b..c860eb7ed3f5 100644
> --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> @@ -98,9 +98,6 @@ properties:
>  
>    gpio-controller: true
>  
> -  typec:
> -    $ref: /schemas/chrome/google,cros-ec-typec.yaml#
> -
>    ec-pwm:
>      $ref: /schemas/pwm/google,cros-ec-pwm.yaml#
>      deprecated: true
> @@ -166,6 +163,10 @@ patternProperties:
>      type: object
>      $ref: /schemas/extcon/extcon-usbc-cros-ec.yaml#
>  
> +  "^typec(-[0-9])*$":
> +    type: object
> +    $ref: /schemas/chrome/google,cros-ec-typec.yaml#
> +
>  required:
>    - compatible
>  
> -- 
> https://chromeos.dev
> 

-- 
Lee Jones [李琼斯]
