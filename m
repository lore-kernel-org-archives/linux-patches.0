Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8317A33CA
	for <patches@lists.linux.dev>; Tue,  3 May 2022 19:13:06 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id bu29so31984187lfb.0
        for <patches@lists.linux.dev>; Tue, 03 May 2022 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=gScoDEP6H/e2lI5aewxp6CF++a7zPjIJd6rBgjg+7gQ=;
        b=g80alIQgcsogfvNR+vlagnVLLLFaTSdEq7aWHE+TvhjlAxM19YDbjJaC8hvBvUSdd6
         X7qzLkX0GNkwIsgjX9VVMTMJp4MllktFpVGEJC+YDwT/qfXsSFTmD0i0+wtnLcEoymqh
         om5phHKEqnUn/1oPFtYow+DFIxFH0Agn5hj2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=gScoDEP6H/e2lI5aewxp6CF++a7zPjIJd6rBgjg+7gQ=;
        b=yRdhLZW9551l9KaO4L8QKk706yzFDYnhszwNnQ0gmSVNjn2Ajwy2sB06PDVQdmBtLL
         cJOVpA+7BUOo7XLat+xZ+ut5skHX3ODyOB8e1MWgJ6NBRFlIW/x75h4Dd5jg3WA07Dkb
         N10lD79etE3M8/b4FgGk9el5emeVWyMTf2lYFhlIlP5jGzq64TBBZX3xBp9UNWTMrMj2
         GExr8jD8aVzUS84RjocWyfecJvNz/GFvjG69muL85sP8bPnJEUWKP2gmmO1CnXbxeHbf
         MD1PyJqUCp4GFZoN+CAVi/hZAuTgpUPbJ0eswHSMx2zE+IBmNpZS3PlvAZEaxQTcVX58
         3Z5A==
X-Gm-Message-State: AOAM5339jclnrhx9toRlplrxm6HXZJ5S8j1yK0fqHHy1bQHAybnjNeOb
	9qeT9VuuJk981ify9R3pqsN8F6Yxk4wBjn2kKRdZyQ==
X-Google-Smtp-Source: ABdhPJwhnIwiZGhNfy9KvY44aruMr9TzFcBKZpVBHorn7YXHX7AMFkY5pxuQW/7NoScJrtPcWBFyjRS8ez2p4ADQUFY=
X-Received: by 2002:a19:ac42:0:b0:448:1f15:4b18 with SMTP id
 r2-20020a19ac42000000b004481f154b18mr12184218lfc.32.1651605184466; Tue, 03
 May 2022 12:13:04 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 May 2022 12:13:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <YnE5xMS13oSuR5rx@robh.at.kernel.org>
References: <20220503004156.3559940-1-swboyd@chromium.org> <20220503004156.3559940-2-swboyd@chromium.org>
 <YnE5xMS13oSuR5rx@robh.at.kernel.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Tue, 3 May 2022 12:13:03 -0700
Message-ID: <CAE-0n50OM1mV0xc6RrSAo_rC63hWbM6fH4+9pJuwvBCG4YeqwA@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
To: Rob Herring <robh@kernel.org>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	devicetree@vger.kernel.org, linux-iio@vger.kernel.org, 
	Gwendal Grignou <gwendal@chromium.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Rob Herring (2022-05-03 07:18:44)
> On Mon, May 02, 2022 at 05:41:55PM -0700, Stephen Boyd wrote:
> > We need to configure the sleep and idle mode of the CS pins for this
> > device. Add a DT property to do this so pins are in a proper state
> > during sleep (either hi-z, grounded, or pulled up to vdd).
> >
> > Cc: Gwendal Grignou <gwendal@chromium.org>
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >  .../devicetree/bindings/iio/proximity/semtech,sx9324.yaml | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml b/Documentation/devicetree/bindings/iio/proximity/semtech,sx9324.yaml
> > index d265eb5258c8..6cec3481c8b2 100644
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
> > +      - hz
>
> I was trying to figure out how Hertz was a pin state. 'hiz' or 'hi-z'
> instead?

Sure. I was following the datasheet that has "HZ" but hi-z is better.
