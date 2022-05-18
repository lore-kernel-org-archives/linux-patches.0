Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D924233C1;
	Wed, 18 May 2022 22:06:18 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id v10so3334084pgl.11;
        Wed, 18 May 2022 15:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4rG6qTLRtp+Qy/o3xN0lJs3wPY8YgHEhLV/WzQjfOA4=;
        b=ZVEbKgaqxO90+2qR9ud8/rGbquDAMoO6D83nv+/tt/uvJJIOV6xtU//t9sncne+PRx
         1JEc6D9xrs/lmMJZ59qWI7G4PCvFCVHqV5DZDUl7U2k2AqjxAVIwfXcSok115DbuFyWV
         mN9L6kRlGTEs7l5YLztBVsOSJNST74Px7w5wE30UuHY2pPD4s7SUgMAgb/yXmQ4/UjUL
         CPkalHpsdLy4l9qHgmtJUTEKzghLvkVhUTejdqhN8Bx1hPas73K7Jb5tle1H0DrAgprU
         zvjPC/4y/fZwRMJQZDIXGIisZVgYsPq89kCgL6uxpseK52aeqoMoITwuGOelStMDhk8A
         vbyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4rG6qTLRtp+Qy/o3xN0lJs3wPY8YgHEhLV/WzQjfOA4=;
        b=GXSF6EpAaV01ONkbYU4p0QibAIl35N8sch1wIabJCNJkxgRNu9gt7J/2XqjU8onOcW
         LAqFigv57K2gOVNhYf2nosUQ/V5fV6cOequ4pMfIzR/XcnbC5TP0wOlfqFZl7IrJzSDI
         KQoIEkt4nnPY7rgjiy8PTL19UyfXvO10Yk02Z+9C/RfHQUzr9jCSLvxVrG/c+PiLAYw/
         ulo72wF4HbWZ90ZwXzPc+QyO0MncZb7uU3rNcLypyFKUVnjJdCHTQI0odbbDtV4rFKAq
         m6UwGcRYuVJAZgwy3mbKuM3Fvu42Zb6U3Jbh6UasoklTBy4VBgAMxbVrEAYV5CqW1WU5
         c9dQ==
X-Gm-Message-State: AOAM530ok9XrQ8TEcAPYDoH5MewJbF23kRYhK1b1NFG2N7UfvHSkyK7q
	IjEVLvmQ3thSQLvSZF1HZTA=
X-Google-Smtp-Source: ABdhPJzuyfa8L8oYdtY27Fs3LI5/GJqrJWA464QUwISpSXYP9MJgvA+oFA2VPdak6eJ1SxgZj8lYNQ==
X-Received: by 2002:a05:6a00:4486:b0:50d:fc41:a9a with SMTP id cu6-20020a056a00448600b0050dfc410a9amr1687533pfb.71.1652911578269;
        Wed, 18 May 2022 15:06:18 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:1a53:727c:6847:3659])
        by smtp.gmail.com with ESMTPSA id j9-20020aa78009000000b00510952c52e3sm2342418pfi.180.2022.05.18.15.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 15:06:17 -0700 (PDT)
Date: Wed, 18 May 2022 15:06:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	"Joseph S. Barrera III" <joebar@chromium.org>
Subject: Re: [PATCH v5 0/2] Input: cros-ec-keyb: Better matrixless support
Message-ID: <YoVt1/PdtMHI4RKE@google.com>
References: <20220516183452.942008-1-swboyd@chromium.org>
 <YoR+w7CSqN0aAE5b@google.com>
 <CAE-0n50KE9bkqZvCOLtCGiq3g1jYhK7zpVcVFBzinaguNhNaPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n50KE9bkqZvCOLtCGiq3g1jYhK7zpVcVFBzinaguNhNaPw@mail.gmail.com>

On Wed, May 18, 2022 at 01:07:55PM -0700, Stephen Boyd wrote:
> Quoting Dmitry Torokhov (2022-05-17 22:06:11)
> > Hi Stephen,
> >
> > On Mon, May 16, 2022 at 11:34:50AM -0700, Stephen Boyd wrote:
> > > This is a followup to my previous patch[1] that skips keyboard registration
> > > when the matrix properties aren't present. This adds a compatible string
> > > for this scenario so we can ease existing DTBs over to the new design.
> >
> > As discussed offlist I massaged the binding and the driver code a bit
> > and applied it to an immutable branch off v5.17:
> >
> >         git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git ib/5.17-cros-ec-keyb
> >
> > that you can share with DTS maintainer(s) to accelerate DTS conversions.
> >
> > I also dropped the original patch as it did not make it to Linus' tree
> > yet.
> >
> 
> Ok thanks. Doug noticed some problems with the dt binding. Here's a
> follow up patch that you can squash in or apply on top.

Added to the same branch, thank you.

> 
> ---8<---
> From: Stephen Boyd <swboyd@chromium.org>
> Date: Wed, 18 May 2022 13:03:58 -0700
> Subject: [PATCH] dt-bindings: google,cros-ec-keyb: Fixup bad compatible match
> 
> This uses anyOf which is wrong. Use oneOf and move the items under the
> description. Also drop allOf for $ref.
> 
> Reported-by: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../bindings/input/google,cros-ec-keyb.yaml           | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> index e11cbf508723..c31a02149f37 100644
> --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> @@ -20,13 +20,11 @@ description: |
> 
>  properties:
>    compatible:
> -    anyOf:
> +    oneOf:
>        - description: ChromeOS EC with only buttons/switches
> -      - items:
> -          - const: google,cros-ec-keyb-switches
> +        const: google,cros-ec-keyb-switches
>        - description: ChromeOS EC with keyboard and possibly buttons/switches
> -      - items:
> -          - const: google,cros-ec-keyb
> +        const: google,cros-ec-keyb
> 
>    google,needs-ghost-filter:
>      description:
> @@ -58,8 +56,7 @@ if:
>        contains:
>          const: google,cros-ec-keyb
>  then:
> -  allOf:
> -    - $ref: "/schemas/input/matrix-keymap.yaml#"
> +  $ref: "/schemas/input/matrix-keymap.yaml#"
>    required:
>      - keypad,num-rows
>      - keypad,num-columns
> -- 
> https://chromeos.dev

-- 
Dmitry
