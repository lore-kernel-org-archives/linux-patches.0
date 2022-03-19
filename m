Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758B817CB
	for <patches@lists.linux.dev>; Sat, 19 Mar 2022 02:16:45 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id t2so10979666pfj.10
        for <patches@lists.linux.dev>; Fri, 18 Mar 2022 19:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D08Z1IWz9Rg3EovO3txrE4trNz8pfjrO3FiGHLe0fY4=;
        b=ytR4qg4s2SdaHw8/60ZyYsEL+o0MRIroK8t+4vd3vQGGQXaeBVDHvH3pTQABA9fGBi
         bCihyBF80s3Jpjh7Y3DKCl1KKyHOqNwKxbGCwMxkRVjqURzdZOy5VjsXqZmJ3WJOIFQu
         q3wkWe/21ZbamwCwCyZI3wE31PY6RjER+iWkg7Ab/Gsv8cbtaZSqwt6ykijphlJNyr5Y
         F34gZ2L3GPCIeZXOUSTanaVMCf4xg2fvwi3J4JzTia3YvOPbvivj5GyOJ7f55UeUgKS1
         +KOYwGEYtOhQMS2diwevMr/AG+aD4LXvyI5cQN1YRWtRR5HeeaS6fGPwB4WdOtxofgaW
         /56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D08Z1IWz9Rg3EovO3txrE4trNz8pfjrO3FiGHLe0fY4=;
        b=2CTNI6RsJGAw0U2/2nEh+pGqmxWzKmIXDbGTEvD01BiNpSBmxV0qp+gzOP1sIkh+ux
         Q7cS9peD9uEDOV0ljZDOa0f6XVE2bxxRWTK5EotwLATL5jek2pHmCQzk0twXKpK32Y3q
         IJFG9RQX+UHJzD5ewf5rQcVIe2+EzxCl4WDc55jz5NPpu2qiYS0OZJxkHOtyo8g2XkrL
         EcPbT6POgldjbQhSjB//abxitkeJSxSB0gybBY6bmTNAYfp/pV4NwEo3MIMqvSxPjeX2
         H/CIWPNHuMpvfxpCFqFWCjco/6OiejquIXGTd13FJpXkBIGLDLITbjcGMSCtBIugAMxf
         NCgA==
X-Gm-Message-State: AOAM533cOl5Oqp7vC1GDJr0c3A11AhMh/1jAj51veGWdWC3hfYJULfCJ
	rzS7VZvU65lzhyJHPplaFAiarWOWg44g5/DYIioeUjOeIeo=
X-Google-Smtp-Source: ABdhPJxjbPpaLzce2F7SnkU2gEItaDUIRrnZ3crLSMqW3AEXDwWPeMMccffFTXzj0DKBtHO4MLzewIY5EM3Jnp2zXkU=
X-Received: by 2002:a63:2a43:0:b0:376:4b9:f7e0 with SMTP id
 q64-20020a632a43000000b0037604b9f7e0mr9919730pgq.437.1647656204978; Fri, 18
 Mar 2022 19:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220316230303.1813397-1-ben.widawsky@intel.com>
 <20220316230303.1813397-3-ben.widawsky@intel.com> <CAPcyv4j60_puoCe6q2KqWo8f-HzfwumRtgXqyj1Jr9ht+SBhKg@mail.gmail.com>
 <20220318221200.2zj3b7paamsecshb@intel.com>
In-Reply-To: <20220318221200.2zj3b7paamsecshb@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 18 Mar 2022 19:16:35 -0700
Message-ID: <CAPcyv4hVepdg06c6hFF5PL1UjeoHgB98CG-dsNCU-7biL3Un4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/7] cxl/core: Distinguish cxl_decoder into types
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, patches@lists.linux.dev, 
	Alison Schofield <alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Vishal Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 18, 2022 at 3:12 PM Ben Widawsky <ben.widawsky@intel.com> wrote:
[..]
> > > +struct cxl_root_decoder {
> > > +       struct cxl_decoder base;
> > > +       struct resource res;
> > > +       struct cxl_decoder_targets *targets;
> > > +};
> >
> > This is what I had started to mock up, I think the only differences
> > are no out of line allocations, and the concept that endpoint decoders
> > need to track hpa, dpa, and skip. What do you think?
>
> If we're going through the effort to separate them, I do think it's beneficial
> to pull out target also. Are you so much opposed to that part? What part of the
> out of line allocation do you dislike? It seems fine to me and keeps the alloc
> function fitting on one screen, for me.

Missed replying to this.

What's the benefit though? The size of the targets array will be zero
in endpoint decoders, so it's zero cost to keep them common.
