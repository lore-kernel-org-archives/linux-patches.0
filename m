Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52362583
	for <patches@lists.linux.dev>; Wed,  4 May 2022 15:03:44 +0000 (UTC)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-edeb6c3642so1446733fac.3
        for <patches@lists.linux.dev>; Wed, 04 May 2022 08:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0XSZeXWgi4scPvbVkMMEIf9HkEBqk/lFaT7ukZmszpk=;
        b=sBBCaw63HQDnA0eBSkBuQQjopZNhYHR0hK2mCrSpDNaH6IpE4fdu/EJBDaErv2EjKd
         sSAosCP/AXevP4bmRlO2PVVCtoCqmI/ljNBujau8HnDdjrQqZUY0s+fK3PhZV82L7gDG
         5uYPQP4dWya8Y84ReadfeVVchIdKYjEAhHDV3k8pWP/qkyPTd20jz6TSR2kyaVLgXUCE
         5emMf92OcXLQI6tfPN+fNAiunECKZTtJgR4JuiZTUMmr8aVuTIPx3b2Ki+jYOnNnZWRj
         xsyUQ8qcY3lOEdi0EoGagBTd+w8cCxHkOGtALSlV2LwRLXVdGOAczjaSlfuxhE+8+Bj3
         9ARw==
X-Gm-Message-State: AOAM532hKfEKDJQ/Cs8y2wr8lZqs3wAUhxe9nwmF9OPh7evuWmrpDjrj
	PfMkwxnlBYHWddNnWlWzWw==
X-Google-Smtp-Source: ABdhPJwyXyp8l3/4eYbxsDquSInxw4zswI4vbcnE0ZLs7FRe5OuFOWyn3uGDkvricFp3AuWNeqamNA==
X-Received: by 2002:a05:6870:6196:b0:e1:e1a2:5c65 with SMTP id a22-20020a056870619600b000e1e1a25c65mr4042232oah.190.1651676623681;
        Wed, 04 May 2022 08:03:43 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j5-20020a9d7685000000b006060322125asm5350223otl.42.2022.05.04.08.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:03:43 -0700 (PDT)
Received: (nullmailer pid 1707807 invoked by uid 1000);
	Wed, 04 May 2022 15:03:42 -0000
Date: Wed, 4 May 2022 10:03:42 -0500
From: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, devicetree@vger.kernel.org, linux-iio@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Message-ID: <YnKVzvAITXAHqSiX@robh.at.kernel.org>
References: <20220503193937.3794477-1-swboyd@chromium.org>
 <20220503193937.3794477-2-swboyd@chromium.org>
 <faaa4ab4-8190-3cff-998e-3b6a6d3ce27c@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faaa4ab4-8190-3cff-998e-3b6a6d3ce27c@linaro.org>

On Wed, May 04, 2022 at 08:20:40AM +0200, Krzysztof Kozlowski wrote:
> On 03/05/2022 21:39, Stephen Boyd wrote:
> > We need to configure the sleep and idle mode of the CS pins for this
> > device. Add a DT property to do this so pins are in a proper state
> > during sleep (either hi-z, grounded, or pulled up to vdd).
> > 
> > Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  .../bindings/iio/proximity/semtech,sx9324.yaml           | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> > index d265eb5258c8..b3aa2ebf9661 100644
> > --- a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> > +++ b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> > @@ -126,6 +126,14 @@ properties:
> >        UINT_MAX (4294967295) represents infinite. Other values
> >        represent 1-1/N.
> >  
> > +  semtech,cs-idle-sleep:
> > +    description:
> > +      State of CS pins during sleep mode and idle time.
> > +    enum:
> > +      - hi-z
> > +      - gnd
> > +      - vdd
> 
> You need a ref to type (string).

Actually, it can be implicit for single strings.

Rob
