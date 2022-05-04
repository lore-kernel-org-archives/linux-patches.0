Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27B22583
	for <patches@lists.linux.dev>; Wed,  4 May 2022 15:15:58 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id k2so2470435wrd.5
        for <patches@lists.linux.dev>; Wed, 04 May 2022 08:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1ryHoF3GX29l2BbumSx4LLa3+CSQ3y1WeeuUCuu7Qa0=;
        b=Hcb/GxMIWz+LONYPEzve61zizt92isYqwX/yrmvvmtjTOdN26bELSBXrfCatavY/i9
         zO0Oqvr3zwHUj40hzHgmV8SEvusTerF2fNSIN7KHYATj3tSBtZU9Rif2P38pyjfg33cd
         guYC+H53g+0lZzxOYl2ZNspXpcMIslsrmSObD8wYTFb1O/eopStRxiyOYSwA/8OgzD+k
         V7sIdiAaHrWrvBt2P+ESUMSARxGs2dG9a4B21L0sBP4/Luc29Q7Sxew/ri0Na2lHqyal
         v6xDIUSvDBbq8ATjzHHHiiwFmojz0DUAr7kKlOmFsDxI3cr5ZK9CETnQMIPp5lWlFDTb
         Aa/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1ryHoF3GX29l2BbumSx4LLa3+CSQ3y1WeeuUCuu7Qa0=;
        b=uiWFTMqj+hP7JqiDEPF8SqTtxSXaFMNOQ4Ac0hkPubH7xlYrIok51Hx31BOL+R73TA
         QBOGpMsffPhhiDqDk2jUI55zWz2DVKkWYrHqHV8oa7uiH73/gryWbTx2z6UCiPYPZo/s
         KKPCW0FMOH+42+1rDuebu8Otfkfb8++Tiz0KAYuig13YlrV70C8QaUumNkEPTfTy+nkt
         qsI+gTVfr40czRPXZg2MuDINdttsltAteIWjaqLWjMp6nDrWehNavhF9bUtVqSrsUxIk
         SESfXnMq+QUUxwem18LRa0y4L8scZXHiYk91BFW3uDs/kH0uJbicU6lquNu8XI0+E0EV
         ydSA==
X-Gm-Message-State: AOAM530wSI/gXOJ4u0cV0hf2DdEfKLdO0wqRi3901Yq9otg+OgbdPUvT
	Nt1LGMAeli+0S7E9SRKuObwV3Q==
X-Google-Smtp-Source: ABdhPJybnL0RWDbmurfP0kvKpvO+WERTEmjRBhnccgIeENQnFqTbkIhbjnxVsk2LUs7nrd7EyXVXoQ==
X-Received: by 2002:a05:6000:1814:b0:20a:cb21:8781 with SMTP id m20-20020a056000181400b0020acb218781mr16683539wrh.488.1651677357085;
        Wed, 04 May 2022 08:15:57 -0700 (PDT)
Received: from [192.168.0.215] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id j30-20020adfb31e000000b0020c5253d8bfsm11578357wrd.11.2022.05.04.08.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 08:15:56 -0700 (PDT)
Message-ID: <8aef897f-fff0-526e-62d0-6a92c301eb08@linaro.org>
Date: Wed, 4 May 2022 17:15:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Content-Language: en-US
To: Rob Herring <robh@kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Jonathan Cameron <jic23@kernel.org>,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
 Gwendal Grignou <gwendal@chromium.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20220503193937.3794477-1-swboyd@chromium.org>
 <20220503193937.3794477-2-swboyd@chromium.org>
 <faaa4ab4-8190-3cff-998e-3b6a6d3ce27c@linaro.org>
 <YnKVzvAITXAHqSiX@robh.at.kernel.org>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YnKVzvAITXAHqSiX@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/05/2022 17:03, Rob Herring wrote:
>>>  
>>> +  semtech,cs-idle-sleep:
>>> +    description:
>>> +      State of CS pins during sleep mode and idle time.
>>> +    enum:
>>> +      - hi-z
>>> +      - gnd
>>> +      - vdd
>>
>> You need a ref to type (string).
> 
> Actually, it can be implicit for single strings.

Is this a generic preference?


Best regards,
Krzysztof
