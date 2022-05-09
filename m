Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4932567
	for <patches@lists.linux.dev>; Mon,  9 May 2022 21:39:36 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id m6-20020a05683023a600b0060612720715so10985545ots.10
        for <patches@lists.linux.dev>; Mon, 09 May 2022 14:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+KkqknBI/2K3Eq7hGd53E0RZ8mZ5a02S480GCyvqwzM=;
        b=LFiQ+kxMta1VkNKN9svzEbNEI8d6BUcVrN132wD6aFj6LYCBkcOlz608Bt8gYItcG6
         5c23t1YGDAWWnEKgbhV4TkrvjbCIOyydr1OaJf95DcVFIFcqpBKa+0wI4OLvYDBFGkx9
         Z9ahxKXY6kswt3kKHcWny7Ii3hIIeZx7VhogY0dzlNHY0B6ubr4budkUnUiIH4tiAWfg
         V2pGBEJxhtJ4pb8kkrDugE/pfwJ5uha6Oun/jBCUpY1Zgf3CMq17iiswalGh0BtuuR8E
         pDCGagBmk53kFJYeslUnm2+x3FGNHDqqZHcZJbXGKF5ZnAW3AwqN/H5WfQRwIOK3vbj2
         jwcA==
X-Gm-Message-State: AOAM5301XOZDCf2YAq+1ZQElUzONDXCWAwBK+1iSMy2RwjPxU47lkcn+
	Bdn3FutEuEjiRzCc1clDOA==
X-Google-Smtp-Source: ABdhPJyBKwsYVpF+613L3NjhkodjdhNhTlNBEVF4zad8+lj7S3V5mZuzad0b7ALO+n88vjbc7x+Mqw==
X-Received: by 2002:a05:6830:310e:b0:606:638d:cf00 with SMTP id b14-20020a056830310e00b00606638dcf00mr6415474ots.76.1652132375719;
        Mon, 09 May 2022 14:39:35 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o24-20020a9d6d18000000b0060603221271sm5086642otp.65.2022.05.09.14.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 14:39:35 -0700 (PDT)
Received: (nullmailer pid 243241 invoked by uid 1000);
	Mon, 09 May 2022 21:39:34 -0000
Date: Mon, 9 May 2022 16:39:34 -0500
From: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, linux-iio@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Message-ID: <YnmKFiFqiR43I7Bb@robh.at.kernel.org>
References: <20220503193937.3794477-1-swboyd@chromium.org>
 <20220503193937.3794477-2-swboyd@chromium.org>
 <faaa4ab4-8190-3cff-998e-3b6a6d3ce27c@linaro.org>
 <YnKVzvAITXAHqSiX@robh.at.kernel.org>
 <8aef897f-fff0-526e-62d0-6a92c301eb08@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aef897f-fff0-526e-62d0-6a92c301eb08@linaro.org>

On Wed, May 04, 2022 at 05:15:55PM +0200, Krzysztof Kozlowski wrote:
> On 04/05/2022 17:03, Rob Herring wrote:
> >>>  
> >>> +  semtech,cs-idle-sleep:
> >>> +    description:
> >>> +      State of CS pins during sleep mode and idle time.
> >>> +    enum:
> >>> +      - hi-z
> >>> +      - gnd
> >>> +      - vdd
> >>
> >> You need a ref to type (string).
> > 
> > Actually, it can be implicit for single strings.
> 
> Is this a generic preference?

I don't have a preference, just noting that both are allowed. I like 
having a smaller schema, but then it is a bit of a special case.

Rob
