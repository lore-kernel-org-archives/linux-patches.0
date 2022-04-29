Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51087B
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 06:31:41 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id r13so13562896ejd.5
        for <patches@lists.linux.dev>; Thu, 28 Apr 2022 23:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VV4IEsHLUTf4LJBEf6r2x88mFgCM/XS/Mg3GKKEB8y8=;
        b=Ej0VEVTh4EWlFm1B2h8idG9tgLnzuqxDMWwphTEMdC7gDBjRyJt5mp3rN8cX1x0NQI
         S/u/4diHpQQuM/VQUWjyKvp5kXI10XbEjEkSoJC+wdxRQisTWx7fqxBH5tebW5/xsTXA
         kRPSUccgrHhBP4xVBLp593gmyExjeV4O7WKqHgPju6nfr8F4T4eSlIbvBlORnv/TjbcD
         Q0y8asDKVVGgfmVW21ogh13RksGdFlBanff0lKkiJ9LQ6zvq3XG/TjZ5JPNJZyJGZe8c
         OzcJuC8IYQ4+QVe/BCVUFn20DVk/qnuI6cQ/MkYcghByDENn9w/u3xVkgO2WdAgKZBLD
         cAFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VV4IEsHLUTf4LJBEf6r2x88mFgCM/XS/Mg3GKKEB8y8=;
        b=LzvRzJhLqmfiyHyZba5zFPks5gCw9Um+f3QeRwl1x35rXdjGMY98L+3aWoWy54kV59
         mjrEWDVPkB61WS2hOyK5XTw2TbPi+ti83B/EXMP1t4Tp7fArwNYvWOa7cnJJkgKskSfT
         xtSXWaM3OQxFHNSWnZAvlOkZfKrIexV0AjGrNwwoA4uwtCjiCDVrmL/H/5DheVG0I9x6
         FUdOzVVBGPXCHm5DI03vgjieF+ZHmK+HuaEibSgpUNdnO+6PYTYbYmx2jURU55pqbcn/
         ieIVrPsyqGIgvsd88XuySGTg5TQ+Ze5+/XVwf4FRqzOWyZXbwob3k1TZQWO9dMf8M0hK
         Rs+w==
X-Gm-Message-State: AOAM531o2/3/OV9H5rk6IH9JL7phWSnZE90MfWbbwC0VzOQ9NHNvqvgo
	+htGbNoiusDWa1c6G3dyTQzswg==
X-Google-Smtp-Source: ABdhPJz59K7SfWDqQwwv1xsVc/CjFpBb4AMYnq3cmsg5FoKmDuYAaZ/b6HBFgOglA2wN4T2LJBLuNQ==
X-Received: by 2002:a17:906:9b8d:b0:6f3:c659:d3b0 with SMTP id dd13-20020a1709069b8d00b006f3c659d3b0mr11744398ejc.553.1651213900212;
        Thu, 28 Apr 2022 23:31:40 -0700 (PDT)
Received: from [192.168.0.168] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id jy27-20020a170907763b00b006f3ef214e54sm334759ejc.186.2022.04.28.23.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 23:31:39 -0700 (PDT)
Message-ID: <f1e839d5-010b-ddbc-d132-5d0f28c1699e@linaro.org>
Date: Fri, 29 Apr 2022 08:31:38 +0200
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
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220427203026.828183-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/04/2022 22:30, Stephen Boyd wrote:
> If the device is a detachable, this device won't have a matrix keyboard
> but it may have some button switches, e.g. volume buttons and power
> buttons. Let's add a more specific compatible for this type of device
> that indicates to the OS that there are only switches and no matrix
> keyboard present.
> 
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
