Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B4B223DC6
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745493053; cv=none; b=IWpGHGsQzKlDnU5pCoXul4sdQRfngUzkMBaULwkD3AD+/+aYiQOlqDz6shL1XZGrP1KaVN1+sTWIWw2UlFbsBI4T4NPNT1seEczj4eB4O2MLhOhJ6XWYv8ZxQoSkYDbfqBM471CtvqrNhWImKZvJ2Xy/sECYVj1r9HIMX6UuhE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745493053; c=relaxed/simple;
	bh=vHlM7vyyhvHO69IvXPugtFCtr96bxOcLbYznJ/LXqxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GMduHFbfYxKLE/hz8aqiiFm+XItSf7QI6SCQCKMeF0NeyvPKELWDIBPlpeZ1rl5/XdlYtQb3AT9Osgcgq0ukcEW/p8/CqTCMxkBDkK/QVRu4JjigAKROdZefSkysrucxGyxbj0MhHABWGO+UIsyQPSncV0BXz0gFG5BmwGf2Qy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W1sDJeMk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W1sDJeMk"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53OAMrFX003456
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 11:10:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SbXkZiQgoCeol6j703bkn3BaF0gN+b66VO3cL6uNuA8=; b=W1sDJeMkeeGJXqJO
	Q0V5h5Wq/x3Mmm87v5ouH/9p2pYIVCjPcN9BVgpehGBCpRNoKUB3AFRE5vYxK4WF
	wHq0pa89xsBaj0XK4s3b+nWqoIjSGU6M7tFrusLwQ9iTcOS2x3cLnC3u3SKd5qcW
	3gUsrgrDI7vNpvcGlCPz+zEzn5ZIJnFXRSBiybIYBE0dMqNq6qeEKG2uqgxWnLbZ
	zoAIM+LDJVPGY7Ibd4TSsZvzk2RaVszqIakZPSW3e8wyDexcmF+zrmumTzzmdZHX
	MCZnOy+uiWySiRZESlo18c19oI7y8kx3BfRgRNve+KkOaWOC+nr/4iXfE4KCLbht
	vLKw8g==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh0n9ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 11:10:49 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c955be751aso145318485a.2
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 04:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745493035; x=1746097835;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SbXkZiQgoCeol6j703bkn3BaF0gN+b66VO3cL6uNuA8=;
        b=iH+9Ih0fTPO/pIsWXg1A5cEIt1i58Dds6He1N1sSX9VYw9ZR9qmA4aKmdow+roOjRr
         JD+iYRtRsjUqfuqEk9g6U9koiyepDnlAueMq2MfDkVSgEZIc2aUubcPKVkJ51HFQQJGF
         mIsj1rgq1xxUpmvblsh1ogq79fZOKlZPR19xDKhKe8TfBzNsIXrxQxr8gUnu6wZURonK
         ycKAJ75gqWMrwZO7Tc/9D5WsHcFur0Z9DyqYLCfa/59XL5bcFjvhJT1K4SpSOM9Sdqvz
         MFgqr2nT4VMb32IyrqhUFw4wuS1lyRca5VMaZeB21iiMZesjzTfjWaFST7B2U92REkxl
         LASg==
X-Forwarded-Encrypted: i=1; AJvYcCW9durYwKep4Vy+P9f9s1FpskWas9n7C2+P3HJvVonU+iFahcnwA/mqbrslrfXMhNwmNBOx8GLT@lists.linux.dev
X-Gm-Message-State: AOJu0Yz77tTScy30p7iOu7tgO2qySU9QKBmkdKpPZf4/mfivRvtSJYi+
	oD0WyoHS5OqOeaD+M+zKrSX9f55zCqry1avxPyxy+JAhKCuOks/32aRXTfpBM+KN3zLqIGIz+tC
	fCFBo4dl8488ZCjhogfRJoDwdAD98Gyoyk6ssLqRNrEF7JR+vYeGRmx+a
X-Gm-Gg: ASbGncv+pMxAEHkFhkbJNF9lVtXZSmvoaRJh/5E2J5fBodGt1j06W9xaii2w4Gij4z4
	t/+zIZ68TFDN3opNjtWFATtzQ3dbDKlsVoilLqiYkZReFQvCvWUXZCqNXHeTk3OkP3mApN4/TBK
	jZnjxPoPQgTOreZYQ8kWtAeOGEZg43bMihQsVYrahM1FvhxfQXslnbBZAy/OtDJ0YLW/OlabPLr
	Ijd8vXhBCWntqAa7Tf0yOrcgHgg4fGNgM1fmcx9XnHOsacv5Y4BIS3Bf2upOHUOi80xERfxwUjf
	1f4ntp+vAB+2N+iN8gOLqxpeuvOK9Ee9idDQD8nAgNTKIek5N30ZhO+rJBB/w5M6t3l/oLd0BkI
	=
X-Received: by 2002:a05:620a:2890:b0:7c0:be39:1a34 with SMTP id af79cd13be357-7c956f32b80mr335217885a.43.1745493035179;
        Thu, 24 Apr 2025 04:10:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEIWSfSeagQCMxeexreJGiDfdJOejTbjRJi9VCGDNZjfVdsS5Ak1Wfu+3rMCEHoHHhMDdWtg==
X-Received: by 2002:a05:620a:2890:b0:7c0:be39:1a34 with SMTP id af79cd13be357-7c956f32b80mr335213485a.43.1745493034794;
        Thu, 24 Apr 2025 04:10:34 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54e7cb2627asm202514e87.16.2025.04.24.04.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:10:32 -0700 (PDT)
Date: Thu, 24 Apr 2025 14:10:31 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Conor Dooley <conor+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>, Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>, chrome-platform@lists.linux.dev,
        Pin-yen Lin <treapking@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        =?utf-8?Q?=C5=81ukasz?= Bartosik <ukaszb@chromium.org>,
        Jameson Thies <jthies@google.com>,
        Andrei Kuchynski <akuchynski@chromium.org>
Subject: Re: [PATCH 5/7] dt-bindings: usb: google,cros-ec-typec: Add ports
 for DP altmode
Message-ID: <air5bftw42xfc3ikm3zmcd2u7jwjya3wkqgw6ojjpf3v6q2d4y@djmxtnhzosed>
References: <20250416000208.3568635-1-swboyd@chromium.org>
 <20250416000208.3568635-6-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250416000208.3568635-6-swboyd@chromium.org>
X-Proofpoint-ORIG-GUID: bvLr633MkBUiPwP9gAP1uccMIHHJWeGK
X-Authority-Analysis: v=2.4 cv=ftfcZE4f c=1 sm=1 tr=0 ts=680a1c39 cx=c_pps a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=cm27Pg_UAAAA:8 a=1XWaLZrsAAAA:8 a=xgO1mOz0IQAmAFag51MA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: bvLr633MkBUiPwP9gAP1uccMIHHJWeGK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDA3NSBTYWx0ZWRfX3In5uTLaLVzx 2co3S41Ctd0MQGu302iNkvZLEMijBNAaGkwflnmxZElxK2e6X8V+Bn5X4SqZSG+Gtx88u5VYc6k 6w4Gpimg/xOj636yiS2MBRKqg1M0urSW9SzTFa3LDtH61Of+XnwohVP9DJ2+tteMxz3jBXOj/x0
 WLclL74sYEZdrdwQ9nvxgjOwOUoc6s1FznRsvIkDY1tQyqP/27Cqg8DiGBxYMg8iUMrFpUQCua4 g/rM+uBN7TLRv5sfRR5QkOUdiJQcJ4BIV0AxocutmvEkNrQL+5KvMCsI9vzku82pO5+uNft/h5p aNNYRVpGBjDQ267ziwiCmvhXWSux6P0JsnIG/dMvpU1rapmdgCnaIhs/kLae4LbLWvzj0OTsR5p
 aeEwNeM7lCh3mJ92TtcVAwBESjvIRSRb6SSS8KR67o4KlWOopCecWIM515ziSwYdlqB3x2C8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-24_05,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504240075

On Tue, Apr 15, 2025 at 05:02:05PM -0700, Stephen Boyd wrote:
> Add a DT graph binding to google,cros-ec-typec so that it can combine
> DisplayPort (DP) and USB SuperSpeed (SS) data into a USB type-c endpoint
> that is connected to the usb-c-connector node's SS endpoint. Allow there
> to be multiple 'typec' nodes underneath the EC node so that one DT graph
> exists per DP bridge. The EC is actually controlling TCPCs and redrivers
> that combine the DP and USB signals together so this more accurately
> reflects the hardware design without introducing yet another DT node
> underneath the EC for USB type-c "stuff".
> 
> If the type-c ports are being shared between a single DP controller then
> the ports need to know about each other and determine a policy to drive
> DP to one type-c port or the other. If the type-c ports each have their
> own dedicated DP controller then they're able to operate independently
> and enter/exit DP altmode independently as well. We can't connect the DP
> controller's endpoint to one usb-c-connector port@1 endpoint and the USB
> controller's endpoint to another usb-c-connector port@1 endpoint either
> because the DP muxing case would have DP connected to two
> usb-c-connector endpoints which the graph binding doesn't support.
> 
> Therefore, one typec node is required per the capabilities of the type-c
> port(s) being managed. Add a port to the DisplayPort altmode as well, so
> that we can show the connection between the DP controller and the DP
> altmode. This lets us indicate which type-c ports the DP controller is
> wired to. For example, if DP was connected to ports 0 and 2, while port
> 1 was connected to another DP controller we wouldn't be able to
> implement that without having some other DT property to indicate which
> output ports are connected to the DP endpoint.
> 
> Furthermore, this supports ChromeOS designs like Corsola where a DP
> controller/PHY is split with two lanes going to one connector and the
> other two lanes going to another connector. In this case, we wouldn't
> have the graph binding under the cros-ec-typec node, but we would have
> the graph binding in the DP altmode directly connected to the DP
> controller's two output endpoints.
> 
> Cc: Rob Herring (Arm) <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Acked-by: Lee Jones <lee@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Cc: Łukasz Bartosik <ukaszb@chromium.org>
> Cc: Jameson Thies <jthies@google.com>
> Cc: Andrei Kuchynski <akuchynski@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../bindings/connector/usb-connector.yaml     |   6 +
>  .../bindings/mfd/google,cros-ec.yaml          |   7 +-
>  .../bindings/usb/google,cros-ec-typec.yaml    | 165 ++++++++++++++++++
>  3 files changed, 175 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/connector/usb-connector.yaml b/Documentation/devicetree/bindings/connector/usb-connector.yaml
> index 11e40d225b9f..e3d60997c03e 100644
> --- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
> +++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
> @@ -179,6 +179,12 @@ properties:
>              $ref: /schemas/types.yaml#/definitions/uint32
>              description: VDO returned by Discover Modes USB PD command.
>  
> +          port:
> +            $ref: /schemas/graph.yaml#/properties/port
> +            description: OF graph bindings modeling a data bus to the
> +              DisplayPort altmode from the DisplayPort controller. Used when
> +              the altmode switch is part of the port manager.

Well......

> +
>    port:
>      $ref: /schemas/graph.yaml#/properties/port
>      description: OF graph bindings modeling a data bus to the connector, e.g.
> diff --git a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> index ac89696fa649..63d506e88abb 100644
> --- a/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> +++ b/Documentation/devicetree/bindings/mfd/google,cros-ec.yaml
> @@ -98,9 +98,6 @@ properties:
>  
>    gpio-controller: true
>  
> -  typec:
> -    $ref: /schemas/usb/google,cros-ec-typec.yaml#
> -
>    ec-pwm:
>      $ref: /schemas/pwm/google,cros-ec-pwm.yaml#
>      deprecated: true
> @@ -163,6 +160,10 @@ patternProperties:
>      type: object
>      $ref: /schemas/extcon/extcon-usbc-cros-ec.yaml#
>  
> +  "^typec(-[0-9])*$":
> +    type: object
> +    $ref: /schemas/usb/google,cros-ec-typec.yaml#
> +
>  required:
>    - compatible
>  
> diff --git a/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
> index 3272d0e01f7e..611345bbe884 100644
> --- a/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
> +++ b/Documentation/devicetree/bindings/usb/google,cros-ec-typec.yaml
> @@ -26,6 +26,55 @@ properties:
>    '#size-cells':
>      const: 0
>  
> +  mux-gpios:
> +    description: GPIOs indicating which way the DisplayPort mux is steered
> +    minItems: 1
> +    maxItems: 3
> +
> +  no-hpd:
> +    description: Indicates this device doesn't signal HPD for DisplayPort
> +    type: boolean
> +
> +  ports:
> +    $ref: /schemas/graph.yaml#/properties/ports
> +
> +    properties:
> +      port@0:
> +        $ref: /schemas/graph.yaml#/properties/port
> +        description:
> +          Port for DisplayPort (DP) data
> +
> +        properties:
> +          endpoint@0:
> +            $ref: /schemas/graph.yaml#/properties/endpoint
> +            description: Input DP port
> +
> +        patternProperties:
> +          '^endpoint@[1-8]$':
> +            $ref: /schemas/graph.yaml#/properties/endpoint
> +            description: Output to the usb-c connector's DP altmode
> +
> +        required:
> +          - endpoint@0
> +
> +        anyOf:
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
>  patternProperties:
>    '^connector@[0-9a-f]+$':
>      $ref: /schemas/connector/usb-connector.yaml#
> @@ -35,10 +84,30 @@ patternProperties:
>  required:
>    - compatible
>  
> +allOf:
> +  - if:
> +      required:
> +        - no-hpd
> +    then:
> +      properties:
> +        ports:
> +          required:
> +            - port@0
> +  - if:
> +      required:
> +        - mux-gpios
> +    then:
> +      properties:
> +        ports:
> +          required:
> +            - port@0
> +
>  additionalProperties: false
>  
>  examples:
>    - |+
> +    #include <dt-bindings/gpio/gpio.h>
> +
>      spi {
>        #address-cells = <1>;
>        #size-cells = <0>;
> @@ -47,6 +116,8 @@ examples:
>          compatible = "google,cros-ec-spi";
>          reg = <0>;
>          interrupts = <35 0>;
> +        #gpio-cells = <2>;
> +        gpio-controller;
>  
>          typec {
>            compatible = "google,cros-ec-typec";
> @@ -54,12 +125,106 @@ examples:
>            #address-cells = <1>;
>            #size-cells = <0>;
>  
> +          mux-gpios = <&cros_ec 42 GPIO_ACTIVE_HIGH>, <&cros_ec 3 GPIO_ACTIVE_HIGH>;
> +
>            connector@0 {
>              compatible = "usb-c-connector";
>              reg = <0>;
>              power-role = "dual";
>              data-role = "dual";
>              try-power-role = "source";
> +
> +            altmodes {
> +              displayport {

Should there be an svid / vdo definition?

> +                port {
> +                  usbc0_dp: endpoint {
> +                    remote-endpoint = <&dp_out0>;
> +                  };

I think this is slightly incorrect. The lanes from the DP mux inside the
EC are routed to the SS part of the USB-C connector. As such...

> +                };
> +              };
> +            };
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
> +                  remote-endpoint = <&usb_hub_dfp3_ss>;
> +                };

This should be more like

              port@1 {
                reg = <1>;
                #address-cells = <1>;
                #size-cells = <0>;

                usb_c0_ss: endpoint@0 {
                  reg = <0>;
                  remote-endpoint = <&usb_hub_dfp3_ss>;
                };

                usbc0_dp: endpoint@1 {
                  reg = <1>;
                  remote-endpoint = <&dp_out0>;
                };
              };

Would it make the driver significantly more complicated?

-- 
With best wishes
Dmitry
