Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609B42F43;
	Thu, 12 May 2022 10:22:34 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id e24so4759219pjt.2;
        Thu, 12 May 2022 03:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E6IZ0JJc5m0aq/8SHpdc4cXSMXVdXk6ybd09b5VcxZo=;
        b=jaFXXvhZgi7pQZsqjsiN7ExzaMY4FC6PbyviRfgj/rI7KDPpqiKF9Qe22s4IFcdYTK
         NpkPijwPubv/q+KLP0JReczZ/9WN+qRePp1iuXyYkbrAXRTEJgcMz2QB8pk9hHuMKkcR
         GxyOZ26Qjydr63nnOCxvkS17Yep7Ee8XYQc8WlrD6+oaGpdC9GWt7Pgz1HpoVJIlYbS6
         cpjHl3sBz7SOylii3OGzR+zQZjtZrg4/5Eoc4ZGe4AOli4wXXbDJ45398Z3H8b/WGBSh
         oEQC+mSJXJAFgQ/HGjQ2Sns9FVfrdsHcE3u3cSZJck5vs5LEBo5C1daxDT0MaJs1XPk5
         +Vzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E6IZ0JJc5m0aq/8SHpdc4cXSMXVdXk6ybd09b5VcxZo=;
        b=stZZPoTEM+ZEuK7/YS+FIjr+MCuyyV+2Ls0Whr4NnFw6syyZjSRojLZkJ3yBnqY8F+
         2j9nvdNR5+TzwRAZYD7CHtXJerpvgvoqOylLI85nDy0N6tZ7pH8/ua0iv01xYKOZksjc
         Uu1k0Ys7Hpj44fgbLBuUKq89fpQjZWIDMX76QiQgi1kZURF9zJOl1k4mxSvzp0aTikP0
         GBws9mvHL3KCCN+B0HzKLGaWbKJ6KSqH0csMMzdA8w7YSaJf2wK1LW3eoPGjQTMBy8F/
         Du3WDtwOa6QTDkU/rSKibW0V6BE5YrAC2gyJnqzH55dR+eg6zGwDjNB4A1Q7NEq44F0l
         nMpQ==
X-Gm-Message-State: AOAM5329VPPS2XKBBv33fUJ/K5qO38Z110WNtI+O8A6XboCPAuNi/oJ4
	jRs9XSIYYKpA0ucMZuUQriU=
X-Google-Smtp-Source: ABdhPJx9KgymB6uUxieDp/mDnUNHiGy5kalJZ9YWcy7lBuxrC8hrqDib6NY00rXn8txCLkcXS3TznA==
X-Received: by 2002:a17:90b:2243:b0:1dc:3f08:8316 with SMTP id hk3-20020a17090b224300b001dc3f088316mr10371638pjb.194.1652350953722;
        Thu, 12 May 2022 03:22:33 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:ad76:8fc:e2ba:172])
        by smtp.gmail.com with ESMTPSA id h11-20020aa786cb000000b0050dc76281fcsm3334694pfo.214.2022.05.12.03.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 03:22:32 -0700 (PDT)
Date: Thu, 12 May 2022 03:22:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>,
	LKML <linux-kernel@vger.kernel.org>, patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: google,cros-ec-keyb: Introduce
 switches only compatible
Message-ID: <Ynzf5jEIECLmELK7@google.com>
References: <20220429233112.2851665-1-swboyd@chromium.org>
 <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
 <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>

Hi Stephen,

Sorry for the delay with my response.

On Mon, May 02, 2022 at 01:41:33PM -0700, Stephen Boyd wrote:
> Quoting Dmitry Torokhov (2022-05-02 10:43:06)
> > On Mon, May 2, 2022 at 10:00 AM Doug Anderson <dianders@chromium.org> wrote:
> > >
> > > That goes against the recently landed commit 4352e23a7ff2 ("Input:
> > > cros-ec-keyb - only register keyboard if rows/columns exist") but
> > > perhaps we should just _undo_ that that since it landed pretty
> > > recently and say that the truly supported way to specify that you only
> > > have keyboards/switches is with the compatible.
> > >
> > > What do you think?
> >
> > I am sorry, I am still confused on what exactly we are trying to solve
> > here? Having a device with the new device tree somehow run an older
> > kernel and fail? Why exactly do we care about this case?
> 
> Yes, we're trying to solve the problem where a new device tree is used
> with an older kernel because it doesn't have the driver patch to only
> create an input device for the matrix when rows/columns properties are
> present. Otherwise applying that devicetree patch to an older kernel
> will break bisection.

Well, my recommendation here would be: "do not do that". How exactly
will you get new DTS into a device with older kernel, and why would you
do that?


> 
> > We have
> > implemented the notion that without rows/columns properties we will
> > not be creating input device for the matrix portion, all older devices
> > should have it defined, so the newer driver is compatible with them...
> >
> 
> Agreed, that solves half the problem. This new compatible eases
> integration so that devicetrees can say they're compatible with the old
> binding that _requires_ the rows/column properties. By making the driver
> change we loosened that requirement, but the binding should have been
> making the properties required at the start because it fails to bind
> otherwise.
> 
> My interpretation of what Doug is saying is that we should maintain that
> requirement that rows/columns exists if the original compatible
> google,cros-ec-keyb is present and use the new compatible to indicate
> that there are switches. Combining the two compatibles means there's
> switches and a matrix keyboard, having only the switches compatible
> means only switches, and having only the keyboard compatible means only
> matrix keyboard.
> 
> It sounds OK to me.

Have we solved module loading in the presence of multiple compatibles?
IIRC we only ever try to load module on the first compatible, so you'd
be breaking autoloading cros-ec-keyb on these older kernels. I think the
cure that is being proposed is worse than the disease.

Thanks.

-- 
Dmitry
