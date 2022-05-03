Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415D33CA
	for <patches@lists.linux.dev>; Tue,  3 May 2022 18:45:26 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id g23so20845152edy.13
        for <patches@lists.linux.dev>; Tue, 03 May 2022 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G8p7yldKtTr1PNOn8wgGIMMVK/LhdITnIisacE3JNHw=;
        b=YGDEzllOPX0H7yHdt3Cd+P/OufKVIhQ9fVyXiIjA6hOhBxwJV1tHelxKWqvzp/oE8/
         W8V0LDSTLA3y0/gw38XOZvhpv5JZ1wd3859Hw2dSVJL1NP63+1exFvVWv0mPnOGswUoB
         kFxj5ZtfXJX//arKuEKnBzN03av8B/XppcLxPHn0ydki3x/aritvrQK1QeR/aOTp8Ar/
         NDGa4XlR+d/rYfB4+Pl/aQLDtbdxPgE3z8XYryZLoOyn93bzz3OvkRi2UMndCNUEG2vN
         uUOIgRxzfs7VQY2tEijbizsu/S/algodvp5heTlR3482b0BmF2s6I5V+wR+SxD4jY376
         kDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G8p7yldKtTr1PNOn8wgGIMMVK/LhdITnIisacE3JNHw=;
        b=CERflJaXt6sPPxcCGnb4863ycmY4btR9mPreOazLvjjJ1JTFUVt0kgkSu0J4AesbaC
         dmWntuofG7RD8Fci9qIiJq2ngguEtNFNJ8s284InZZPhJLXc1MrKW+5ENK5/3ymbgiwY
         o9qPUb0HlDD5mcXPTmXQ16Q6zQhEkjNa7PrxGLhy9gUkS563CFVPUttQnNulCHFx+GSW
         u+qQwsMd9lwMkPCNGc4x9khFSkMr5L937Ioh9QLnG751c2kilC359CIlvVNtZo5Hr1rW
         gUuoFLqhJE01kkRMl8cRjo1zEVkcXZ7iJmgWTxOEsSkwzEfKIujYNpoLjneWCwyx+7Ct
         TDyg==
X-Gm-Message-State: AOAM530vDkIBvVG9Z8uPIkJi2xAjx3Rjlf8/Te3+lHYdeS2W8pLqUFNt
	/1Lkm1aT3KZY5HfDXw3UFQQd9w==
X-Google-Smtp-Source: ABdhPJzI5A1uJNgod3x8D6YTKaAahyJjif8qzzhmrGUNRzQTxJzrMZfdsh/nkKu29nRLM9x/jCMPIw==
X-Received: by 2002:a05:6402:42d4:b0:416:5cac:a9a0 with SMTP id i20-20020a05640242d400b004165caca9a0mr19742244edc.86.1651603525309;
        Tue, 03 May 2022 11:45:25 -0700 (PDT)
Received: from [192.168.0.206] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id ia17-20020a170907a07100b006f3ef214de6sm4862679ejc.76.2022.05.03.11.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 11:45:24 -0700 (PDT)
Message-ID: <4ff1354e-07c6-5518-879d-1ad55f04e22a@linaro.org>
Date: Tue, 3 May 2022 20:45:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
Content-Language: en-US
To: Doug Anderson <dianders@chromium.org>,
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
 chrome-platform@lists.linux.dev, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Rob Herring <robh+dt@kernel.org>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Benson Leung <bleung@chromium.org>,
 Guenter Roeck <groeck@chromium.org>, Hsin-Yi Wang <hsinyi@chromium.org>,
 "Joseph S. Barrera III" <joebar@chromium.org>
References: <20220503042242.3597561-1-swboyd@chromium.org>
 <20220503042242.3597561-2-swboyd@chromium.org>
 <2280875f-fbd8-0dfd-5a0a-1d7fceb856e4@linaro.org>
 <CAD=FV=UEBi9dctmhaAi1z+c+Sj5gtcRrc3FRW294T55dTiAidQ@mail.gmail.com>
 <cd1da207-1f15-f3f1-7190-56b983e75024@kernel.org>
 <CAD=FV=XHNuvhekh=hepGePftaMXnDJGeJP=Lg8VfqmGdKt7HEA@mail.gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAD=FV=XHNuvhekh=hepGePftaMXnDJGeJP=Lg8VfqmGdKt7HEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/05/2022 18:14, Doug Anderson wrote:
> Hi,
> 
> On Tue, May 3, 2022 at 8:54 AM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>>
>> On 03/05/2022 17:46, Doug Anderson wrote:
>>> Hi,
>>>
>>> On Tue, May 3, 2022 at 8:42 AM Krzysztof Kozlowski
>>> <krzysztof.kozlowski@linaro.org> wrote:
>>>>
>>>> On 03/05/2022 06:22, Stephen Boyd wrote:
>>>>> If the ChromeOS board is a detachable, this cros-ec-keyb device won't
>>>>> have a matrix keyboard but it may have some button switches, e.g. volume
>>>>> buttons and power buttons. The driver still registers a keyboard though
>>>>> and that leads to userspace confusion around where the keyboard is.
>>>>
>>>> (...)
>>>>
>>>>>
>>>>> +if:
>>>>> +  properties:
>>>>> +    compatible:
>>>>> +      contains:
>>>>> +        const: google,cros-ec-keyb
>>>>> +then:
>>>>> +  allOf:
>>>>> +    - $ref: "/schemas/input/matrix-keymap.yaml#"
>>>>> +  required:
>>>>> +    - keypad,num-rows
>>>>> +    - keypad,num-columns
>>>>> +    - linux,keymap
>>>>
>>>> else:
>>>>   properties:
>>>>     function-row-phsymap: false
>>>>     google,needs-ghost-filter: false
>>>>
>>>> Because these are not valid for the non-matrix-keyboard case, right?
>>>
>>> Isn't that implicit because this file has `unevaluatedProperties: false` ?
>>
>> But they are evaluated here, aren't they?
> 
> Only if the "if" test, though? 

No, they are evaluated always. They are listed directly in properties,
not in "if", therefore they will be considered as always evaluated.

> ...ah, or is this a difference between
> "unevaluatedProperties" and "additionalProperties" ?




Best regards,
Krzysztof
