Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C43202
	for <patches@lists.linux.dev>; Tue,  3 May 2022 14:18:46 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id g11-20020a9d648b000000b00605e4278793so10768456otl.7
        for <patches@lists.linux.dev>; Tue, 03 May 2022 07:18:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/aMt+iUL1CVqIgS6yg9mheyNXMFTAG1uctDwp9jLpck=;
        b=6AVcpOIg9u/lp8e3fnVRhHZ6sbThfC6OYKnf7dgVlwkHAyabOHhSTvsxWIP6tWhGyJ
         FJj4fyRzFCy2YBNUqeZ8Xw/hFSoYMGQSiuBk6orUDYchsu92S1qoRIWem7IANCU1ETao
         i91R1nlj9YmSuLRo5n9tdYRFCSfERUm3gxODlRqibo+g71lUsik50LwMotp7eyHhPKM2
         xyeZRToBuiINhIbLqcTZeLcWfU6ddJV3YlF5mFEriQJkETMM/0Tybh8sn0sLcQaMBA+Y
         gltzBp/lWuKlaD6k+iNYT0b3CpuVngWvze9WSHHqqi2Vfd6x5UYXVMUOYWolXiMLhtPM
         TygQ==
X-Gm-Message-State: AOAM532Pz5E+EWP0iUWuVHV4vJ0JpsktMcTnYYDFDi79BkpbfSRA3iO4
	r6X8V4hKBmsK/HNg8NNK1g==
X-Google-Smtp-Source: ABdhPJy2p5eNvTSK+e4lPTi3BIf7IcquwGcze73MguD+vpeB8vzEjETxR5Ny0gGxkZHOQEReDlENHw==
X-Received: by 2002:a9d:5913:0:b0:5cd:a050:8f55 with SMTP id t19-20020a9d5913000000b005cda0508f55mr5967584oth.44.1651587525443;
        Tue, 03 May 2022 07:18:45 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l24-20020a056820031800b0035eb4e5a6b0sm4984867ooe.6.2022.05.03.07.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 07:18:44 -0700 (PDT)
Received: (nullmailer pid 3575356 invoked by uid 1000);
	Tue, 03 May 2022 14:18:44 -0000
Date: Tue, 3 May 2022 09:18:44 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, linux-iio@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Message-ID: <YnE5xMS13oSuR5rx@robh.at.kernel.org>
References: <20220503004156.3559940-1-swboyd@chromium.org>
 <20220503004156.3559940-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503004156.3559940-2-swboyd@chromium.org>

On Mon, May 02, 2022 at 05:41:55PM -0700, Stephen Boyd wrote:
> We need to configure the sleep and idle mode of the CS pins for this
> device. Add a DT property to do this so pins are in a proper state
> during sleep (either hi-z, grounded, or pulled up to vdd).
> 
> Cc: Gwendal Grignou <gwendal@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../devicetree/bindings/iio/proximity/semtech,sx9324.yaml | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> index d265eb5258c8..6cec3481c8b2 100644
> --- a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> +++ b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> @@ -126,6 +126,14 @@ properties:
>        UINT_MAX (4294967295) represents infinite. Other values
>        represent 1-1/N.
>  
> +  semtech,cs-idle-sleep:
> +    description:
> +      State of CS pins during sleep mode and idle time.
> +    enum:
> +      - hz

I was trying to figure out how Hertz was a pin state. 'hiz' or 'hi-z' 
instead?

> +      - gnd
> +      - vdd
> +
>    semtech,int-comp-resistor:
>      description:
>        Internal resistor setting for compensation.
> -- 
> https://chromeos.dev
> 
> 
