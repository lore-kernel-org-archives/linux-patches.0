Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0F4EA6
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 07:27:56 +0000 (UTC)
Received: by mail-ed1-f44.google.com with SMTP id z99so4479331ede.5
        for <patches@lists.linux.dev>; Thu, 28 Apr 2022 00:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G0t5M5PTY98V2pFU2BrLfjWZQRkfAzQU7O0JRiBUSqw=;
        b=EnjYsneRkqpWt31PWaAmunHv2Pd+bvgHqCNmsTRgS+A2YVMnSz/CmM89rjAHECAXAk
         mBiY1zaeOhw8ZPeZV2wNl8LNbJ33Qpz3wjJfLKPYxi3b138/mS3V4UQufIs78RugB0Ap
         7kbifk9oseSfX6SAjwOJP2QsIRcToBXSgngvYQKZjZOYyuMD22P6lP1ONCK6cjil3nzw
         VeviTCKgSiUp/w+N5Cc/TdV0zc8RqAssHPOHhVDJE1nahj6KQksXd/yPyRQ/5+HlpvWH
         XTXveEezTBCSoY5UdcdILBF6Sl01ro2IfxUtkaAI+FQNimFtxxgZ0hT7O9s03shgwd+x
         Go0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G0t5M5PTY98V2pFU2BrLfjWZQRkfAzQU7O0JRiBUSqw=;
        b=RCUjjqR/wUKo2b5UDrxoxx0VC1TDjNSNiB+AQjeiJ5VmxiTRKZeqf8fmxC4yi0q4vj
         HCahhpiDrnqXmEzVhmMljMaD0A/TxlK4C9EjkMVkamTjadQgTFv8wTBbDCiyNjSjXdq/
         E8yxzs+L4lxzuYEjW6o2+LXXZXEwzKT42hlVJA+2JTl++OtAa7DCiYW32I3x6EWi1qDz
         3FxnFz7iGiVb8GBrrp1vo7LMO7j0lW5nKA4bV03WALdOOn3yfhWybJGXe94YfgoeLbkS
         fPUIXTrXD2/l0/bEP3IO/M7vf0hD84KpLCoJf1Wq9Cs/NjIkqhyUmgt1/RdN2a4QpKsj
         WBSA==
X-Gm-Message-State: AOAM530hSryKEzMiitLN2FOOsYhF6xMasyaahD1l5a8MsB+TU9O2zIsM
	uoJBcG4F5R4hnRiUKDdaP98WEA==
X-Google-Smtp-Source: ABdhPJz+rgiwJv2clzp+0bE6ukQ2dupp6EhAp0O3l3QpWIyJToypY1ME9sHL2y6X8oWR56UUJjOmag==
X-Received: by 2002:a50:d707:0:b0:425:e37d:4ef3 with SMTP id t7-20020a50d707000000b00425e37d4ef3mr22319371edi.167.1651130874526;
        Thu, 28 Apr 2022 00:27:54 -0700 (PDT)
Received: from [192.168.0.160] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id z3-20020aa7c643000000b0042617ba63bdsm1044782edr.71.2022.04.28.00.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 00:27:54 -0700 (PDT)
Message-ID: <29cc62aa-2995-ea96-0e7e-242f9ddaa87e@linaro.org>
Date: Thu, 28 Apr 2022 09:27:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] dt-bindings: google,cros-ec-keyb: Introduce switches
 only compatible
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
 Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>,
 Douglas Anderson <dianders@chromium.org>, Hsin-Yi Wang
 <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
References: <20220427203026.828183-1-swboyd@chromium.org>
 <20220427203026.828183-2-swboyd@chromium.org>
 <9248da4f-ca04-82f0-2840-a20797c25d2a@linaro.org>
 <CAE-0n52Y=3EEZ6qguNx=hM44BahbH3cuq7x6Bbe5HELKkkvrUw@mail.gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAE-0n52Y=3EEZ6qguNx=hM44BahbH3cuq7x6Bbe5HELKkkvrUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/04/2022 08:24, Stephen Boyd wrote:
> Quoting Krzysztof Kozlowski (2022-04-27 23:12:47)
>> On 27/04/2022 22:30, Stephen Boyd wrote:
>>> If the device is a detachable, this device won't have a matrix keyboard
>>> but it may have some button switches, e.g. volume buttons and power
>>> buttons. Let's add a more specific compatible for this type of device
>>> that indicates to the OS that there are only switches and no matrix
>>> keyboard present.
>>>
>>> Cc: Krzysztof Kozlowski <krzk@kernel.org>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: <devicetree@vger.kernel.org>
>>> Cc: Benson Leung <bleung@chromium.org>
>>> Cc: Guenter Roeck <groeck@chromium.org>
>>> Cc: Douglas Anderson <dianders@chromium.org>
>>> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
>>> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
>>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>>> ---
>>>  .../bindings/input/google,cros-ec-keyb.yaml          | 12 +++++++++---
>>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
>>> index e8f137abb03c..edc1194d558d 100644
>>> --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
>>> +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
>>> @@ -15,14 +15,20 @@ description: |
>>>    Google's ChromeOS EC Keyboard is a simple matrix keyboard
>>>    implemented on a separate EC (Embedded Controller) device. It provides
>>>    a message for reading key scans from the EC. These are then converted
>>> -  into keycodes for processing by the kernel.
>>> +  into keycodes for processing by the kernel. This device also supports
>>> +  switches/buttons like power and volume buttons.
>>>
>>>  allOf:
>>>    - $ref: "/schemas/input/matrix-keymap.yaml#"
>>>
>>>  properties:
>>>    compatible:
>>> -    const: google,cros-ec-keyb
>>> +    oneOf:
>>> +      - items:
>>> +          - const: google,cros-ec-keyb-switches
>>> +          - const: google,cros-ec-keyb
>>> +      - items:
>>> +          - const: google,cros-ec-keyb
>>>
>>
>> In such case matrix-keymap properties are not valid, right? The
>> matrix-keymap should not be referenced, IOW, you need to move allOf
>> below "required" and add:
>> if:not:...then: $ref: "/schemas/input/matrix-keymap.yaml
>>
> 
> Eventually that sounds doable, but for the time being I want to merely
> add this new compatible in front of the original compatible so that
> updated DTBs still work with older kernels, i.e. the switches still get
> registered because the driver works with the original
> google,cros-ec-keyb compatible. 

The bindings here do not invalidate (break) existing DTBs. Old DTBs can
work in old way, we talk only about binding.

> Given that none of the properties are
> required for google,cros-ec-keyb it didn't seem necessary to make having
> the google,cros-ec-keyb-switches compatible deny the existence of the
> matrix-keymap properties.

Maybe I misunderstood the commit msg. Are the
"google,cros-ec-keyb-switches" devices coming with matrix keyboard or
not? I mean physically.

Best regards,
Krzysztof
