Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561D62F44
	for <patches@lists.linux.dev>; Thu, 12 May 2022 18:58:04 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id a22-20020a9d3e16000000b00606aeb12ab6so3355899otd.7
        for <patches@lists.linux.dev>; Thu, 12 May 2022 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=Zhd0MG3OMKsxCCS0DxHYWS6OhXTHRYI9udewsQ9wKKA=;
        b=a5lZ//ec8iMYjwZDAFJviLOlhtuK/zOhkJ8yY1fP9EOuCDN7H/DKHGYMZLTVmLaSbH
         7zDVMTp4gtAb4CDJ1R3EfmEKDkhQHR8HOMF8u/8PtjJUzecXveh/v9O18YV7oMq+yfQB
         7+9QKdmKM/AnFBuJIvt9RolrCx3FNraGV4Zl4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=Zhd0MG3OMKsxCCS0DxHYWS6OhXTHRYI9udewsQ9wKKA=;
        b=RVSTDTN/rUAj21SdNzfVArSWKA277sYbRJFZ2jdRrBjUADwR8qBp2mKwtPywSWKed3
         iGoA8UEkhLsF8/NAtgkUCDiJPGEakkeNAjIu4NIbZ1O2nE6NVy9S2mTWQdX+iYWW2tYY
         Utwi7DY2oP/+aX06JvHk/cj4tNKTsSmKIue8SOUlVR4vdq2pkZ2/0Li5ns3DB6ATNVpv
         Q729F2FxYiktBvFXK5bUkbjTg8cX33mWhKaBXr9CuWTWLQSY3HbOSlOynfVZ6oMkll8H
         TmB0hGIJMa/Yyr2AE0vDf/VFfzmalLsZ77weN7xLH0bZgBiRsFoy2rE2pDQaOFvz46xd
         /u0A==
X-Gm-Message-State: AOAM532IpOSu1tykOfArpq8KE2n4dM1Z+wwobL0U5TBIZBj5aLlVcQQ8
	ijvn9n9jmtUArTP/vjcNsJSajciWCU88sVi5WMS4sw==
X-Google-Smtp-Source: ABdhPJzuIqTTJcobedsUUMtgNSQxvFm+eNCNAvbYJtV/SGE93UY7OwlQcTO+QqsTxk2XA3PsD5OaOpa6i/+EQ/taytI=
X-Received: by 2002:a05:6830:13ce:b0:606:702b:87f0 with SMTP id
 e14-20020a05683013ce00b00606702b87f0mr535356otq.159.1652381883398; Thu, 12
 May 2022 11:58:03 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 12 May 2022 11:58:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Ynzf5jEIECLmELK7@google.com>
References: <20220429233112.2851665-1-swboyd@chromium.org> <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
 <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com> <Ynzf5jEIECLmELK7@google.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 12 May 2022 11:58:02 -0700
Message-ID: <CAE-0n50+obQ5qgPNPtUY=OmTgU9bZQ3hNw+MaG9Wi3SQSc-i4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>, LKML <linux-kernel@vger.kernel.org>, 
	patches@lists.linux.dev, chrome-platform@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, 
	Benson Leung <bleung@chromium.org>, Guenter Roeck <groeck@chromium.org>, 
	Hsin-Yi Wang <hsinyi@chromium.org>, "Joseph S. Barrera III" <joebar@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Dmitry Torokhov (2022-05-12 03:22:30)
> Hi Stephen,
>
> Sorry for the delay with my response.
>
> On Mon, May 02, 2022 at 01:41:33PM -0700, Stephen Boyd wrote:
> > Quoting Dmitry Torokhov (2022-05-02 10:43:06)
> > > On Mon, May 2, 2022 at 10:00 AM Doug Anderson <dianders@chromium.org> wrote:
> > > >
> > > > That goes against the recently landed commit 4352e23a7ff2 ("Input:
> > > > cros-ec-keyb - only register keyboard if rows/columns exist") but
> > > > perhaps we should just _undo_ that that since it landed pretty
> > > > recently and say that the truly supported way to specify that you only
> > > > have keyboards/switches is with the compatible.
> > > >
> > > > What do you think?
> > >
> > > I am sorry, I am still confused on what exactly we are trying to solve
> > > here? Having a device with the new device tree somehow run an older
> > > kernel and fail? Why exactly do we care about this case?
> >
> > Yes, we're trying to solve the problem where a new device tree is used
> > with an older kernel because it doesn't have the driver patch to only
> > create an input device for the matrix when rows/columns properties are
> > present. Otherwise applying that devicetree patch to an older kernel
> > will break bisection.
>
> Well, my recommendation here would be: "do not do that". How exactly
> will you get new DTS into a device with older kernel, and why would you
> do that?

It's about easing the transition to a new programming model of the
driver. We could "not do that" and consciously decide to only use new
DTBs with new kernels. Or we could take this multiple compatible
approach and things work with all combinations. I'd like to make
transitions smooth so introducing a second compatible string is the
solution for that.

Another "what if" scenario is that the rows/columns properties should
have been required per the DT binding all along. If they were required
to begin with, I wouldn't have been able to make them optional without
introducing a new compatible string that the schema keyed off of to
figure out that they're optional sometimes.

>
>
> >
> > > We have
> > > implemented the notion that without rows/columns properties we will
> > > not be creating input device for the matrix portion, all older devices
> > > should have it defined, so the newer driver is compatible with them...
> > >
> >
> > Agreed, that solves half the problem. This new compatible eases
> > integration so that devicetrees can say they're compatible with the old
> > binding that _requires_ the rows/column properties. By making the driver
> > change we loosened that requirement, but the binding should have been
> > making the properties required at the start because it fails to bind
> > otherwise.
> >
> > My interpretation of what Doug is saying is that we should maintain that
> > requirement that rows/columns exists if the original compatible
> > google,cros-ec-keyb is present and use the new compatible to indicate
> > that there are switches. Combining the two compatibles means there's
> > switches and a matrix keyboard, having only the switches compatible
> > means only switches, and having only the keyboard compatible means only
> > matrix keyboard.
> >
> > It sounds OK to me.
>
> Have we solved module loading in the presence of multiple compatibles?
> IIRC we only ever try to load module on the first compatible, so you'd
> be breaking autoloading cros-ec-keyb on these older kernels. I think the
> cure that is being proposed is worse than the disease.
>

The first compatible is still cros-ec-keyb in the driver though? Or you
mean the first compatible in the node? I'm not aware of this problem at
all but I can certainly test out a fake node and module and see if it
gets autoloaded.
