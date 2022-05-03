Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2293212
	for <patches@lists.linux.dev>; Tue,  3 May 2022 15:42:43 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id y3so34162730ejo.12
        for <patches@lists.linux.dev>; Tue, 03 May 2022 08:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=11jXtpnvRUPC/KRRG8tH2eowrbQgqPMtLwttUsKdEBs=;
        b=l0UWrpYiK6HwDKRByqNJ3y2uZFFdvaV8ANIW3JNVAItsVDKpa35XU0bfLvkTASkMBv
         +OYfZwDZEyVjpC/rnG1E3dCdtsJ6zJWvIaU0QLAnRYlpGYiWBnv2HGA3bsT55oCtJ8j+
         si18E5OWo0BZ5uAJgB2CIAbB7q9eW9rt7IrK8WmwCeyf+uhQw8rU1BfsSAVEAvmqSACZ
         n/jivP9CyFypRShQX6hr40Kcj2DOzb9bcGMYJgqD+hWAq7Jx/zOVyavrysS920ixUVSs
         cnuasOnTDWOLizp4EDGrpvpTtfKHYNzcFvMk62KyA1/QE0bJJbiGLbg/gNkO/Q4NtPqz
         KH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=11jXtpnvRUPC/KRRG8tH2eowrbQgqPMtLwttUsKdEBs=;
        b=Gr0F1gZapUgdaj52+ptoMHLqXWchqaGy7Q0RnrR9gaAPF7plQl7pgDJtbyro29gkmZ
         WMqufQDeWLpy6OsuBGshIiSKHZ7rPY4m5ajEZDL7BIOj8RAMqBhGWXiM33LmvQPaJzUY
         BVRAlO1hL9zWaFtQ4z4qTbwnygUycdCCHcTrFI5z8+OCRfGOSDPBhp4VqFmEWgj5TzSQ
         ZhlQxJ6uLt6CgyYL5IhWglrXwXssLOAWD9/+zGJChEtG5Mx7Gnj4RXAQNJH9lFn00PWD
         jVbf3+O9+pbcZJxGMzpMEibCe+eog5EBIHRiz1NhJPw08uSWdOGdn8INEfPKbX3lQ1Zg
         hTgA==
X-Gm-Message-State: AOAM531LS+pg6fDZq2m+V3Hnn2nKLpLrRxNUtaYTKOqcvIiLOB7dB8Kf
	WN1zEInlsQEmSZbvnUiQ2AFN1A==
X-Google-Smtp-Source: ABdhPJymi4qyD/go6KagiE9Q2ldpmJnc1Ds2F8U9KW18H1QHIbUQ3tb99imrNDebapNF2Qgl/+X0Ig==
X-Received: by 2002:a17:907:3da2:b0:6f4:78d8:7c23 with SMTP id he34-20020a1709073da200b006f478d87c23mr5396961ejc.233.1651592561803;
        Tue, 03 May 2022 08:42:41 -0700 (PDT)
Received: from [192.168.0.205] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id jl26-20020a17090775da00b006f3ef214dbdsm4701696ejc.35.2022.05.03.08.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 08:42:40 -0700 (PDT)
Message-ID: <2280875f-fbd8-0dfd-5a0a-1d7fceb856e4@linaro.org>
Date: Tue, 3 May 2022 17:42:39 +0200
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
To: Stephen Boyd <swboyd@chromium.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 chrome-platform@lists.linux.dev, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
 Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>,
 Douglas Anderson <dianders@chromium.org>, Hsin-Yi Wang
 <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
References: <20220503042242.3597561-1-swboyd@chromium.org>
 <20220503042242.3597561-2-swboyd@chromium.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220503042242.3597561-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/05/2022 06:22, Stephen Boyd wrote:
> If the ChromeOS board is a detachable, this cros-ec-keyb device won't
> have a matrix keyboard but it may have some button switches, e.g. volume
> buttons and power buttons. The driver still registers a keyboard though
> and that leads to userspace confusion around where the keyboard is.

(...)

>  
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        const: google,cros-ec-keyb
> +then:
> +  allOf:
> +    - $ref: "/schemas/input/matrix-keymap.yaml#"
> +  required:
> +    - keypad,num-rows
> +    - keypad,num-columns
> +    - linux,keymap

else:
  properties:
    function-row-phsymap: false
    google,needs-ghost-filter: false

Because these are not valid for the non-matrix-keyboard case, right?

Best regards,
Krzysztof
