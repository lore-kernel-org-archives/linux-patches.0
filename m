Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9633CA
	for <patches@lists.linux.dev>; Tue,  3 May 2022 19:02:23 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id d6so20910244ede.8
        for <patches@lists.linux.dev>; Tue, 03 May 2022 12:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GhPVwEXFQlelT1ahoVdVsco/ScoxIkg+GwxOC7eOaEc=;
        b=fDLZyyRvAVx2uEW7lTQEdGpwpsEEMgifXHx1C9/rgxLbrANjCct8AdZwl/Qu6HnS3c
         ST8BJSWUC4PeNzfvHcS4SzTosKYkqRVV1q/PLeQU6ZYP/i0TluoWpLUJ/nAwZpga0VP+
         9I9oRIM1y0bq1B+ykLn4cCL2mgQgsLWbYCjCBe1R5ka08KFb6H/k8fk60AiINMewytvH
         5yFp0efCueZ7dSZ+hlAwfjSB/l3TM0CR9eT6GQXZXsPdUe0cKH47Dt7A50+5JbBCt00h
         VX0JrvhM8HjEG4VrxQVhkuMOVjnLP+JYM6dE1qSgWF473zICXaZud9XySu3acZ+v6yQ+
         k8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GhPVwEXFQlelT1ahoVdVsco/ScoxIkg+GwxOC7eOaEc=;
        b=cBNVUBBM01jWxvFq27R96q46/1FBSfWpG1IS4CJI11cYn9+R54Xj5pfTBnYTDJPAMw
         srKe3clcRTJ06XfrK9HpCofWLsxHUaPSPlJXoRP0q8k3261SKXlK2N0yRekAFXo9KmMf
         mqRRJxqVoqklfb1VbIa0hQHHBzU7z/pRFH0+OqpRs+lqcxDquH/4DP40GqrJaOeU4AQ+
         a42BVd7n05JxiM4tGRHi/fczVs4zLsOk9V5c9/GPQDruqjUWLgtE+JdaDgQS0u3wvFer
         AEsVOH0nU45aiHAdNnq6jB2egs91Ldl0qrVgn4Dx+9DexymNlKlW2RPGQHsGdK7uPcH9
         3v3w==
X-Gm-Message-State: AOAM531VjkxIRVN5hFR3m/hBoVoQfiLpfdOn2V8BmpH0GBwI950IVY6L
	yQtX8Wn/xbhFlrf1IM+DRj2aUw==
X-Google-Smtp-Source: ABdhPJyUSOv9kitRm7ExswRN8j6l5yHt0jx+r/ntr8DNAq2Hp2E0qOX+pl3n3b+8w7WVKhKXNuKfVg==
X-Received: by 2002:a05:6402:2714:b0:427:b9bb:a179 with SMTP id y20-20020a056402271400b00427b9bba179mr14199065edd.102.1651604541458;
        Tue, 03 May 2022 12:02:21 -0700 (PDT)
Received: from [192.168.0.207] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id ig11-20020a1709072e0b00b006f3ef214e2dsm5061552ejc.147.2022.05.03.12.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 12:02:21 -0700 (PDT)
Message-ID: <ee8416a3-64da-bd03-6a88-978fb095cbea@linaro.org>
Date: Tue, 3 May 2022 21:02:19 +0200
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
 <2280875f-fbd8-0dfd-5a0a-1d7fceb856e4@linaro.org>
 <CAE-0n50oGX8jBzfNjYFj01nZkuYbk6ZPsqDj89-zqxHhib=vaw@mail.gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAE-0n50oGX8jBzfNjYFj01nZkuYbk6ZPsqDj89-zqxHhib=vaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/05/2022 21:00, Stephen Boyd wrote:
>> else:
>>   properties:
>>     function-row-phsymap: false
>>     google,needs-ghost-filter: false
>>
>> Because these are not valid for the non-matrix-keyboard case, right?
>>
> 
> Yes, but they also depend on linux,keymap so they're not possible to
> set because the matrix-keymap.yaml schema defines linux,keymap and that
> is only included if google,cros-ec-keyb is present.

Ah, right, I missed that one.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
