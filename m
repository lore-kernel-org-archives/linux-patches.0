Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2607E
	for <patches@lists.linux.dev>; Tue, 26 Apr 2022 14:18:15 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id i5so6633654wrc.13
        for <patches@lists.linux.dev>; Tue, 26 Apr 2022 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QSMHNNrnsR8koCz4I/MAVE7jHgZ2vngvdAnPvXcE8V4=;
        b=eF1ZX99hrvwLGKFjWE2bHa7BOo4o0mgiL/eES/8mpJX35PfkcVvjN/iGyFrlng7SBO
         FgDcCp8z180yemEF8GvoPl59axKEttX2xhP7wLwPpYZGkbbUFz1vuOCIzwX0GJRodj0F
         LZkyXAfnvOJ4/ry/8fwIDtyeTNIYunqEFKimy5fukW5ZLU6ml7KmraiLnZOMFtkHxr/I
         8ziCWAPPYkmfOOqhFD3LQQG3JAYCz5G6Bd07ooNr7WkXCx9+PS4S9HNt1doYS6mi0bvj
         bza/jgka4UtlgK14BJDPisJspfCq6jEhznRqtDRAwiWmMUXHmVFdB3YpQwmux3/Uv3G/
         2JDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QSMHNNrnsR8koCz4I/MAVE7jHgZ2vngvdAnPvXcE8V4=;
        b=4Iaan/mSwoLvPt/P48161l5gPjhTTAxBxfFQoM+CtHXT9mMciZNWwHhOeNSorvUVL1
         GRdJM8rtdL76UBCxpVi103joGPDr6PWzY7UfR2bAxVZMnxlVBxAQD+TDCx+d1fa2ACnx
         NH++szJIAqnJntPZVw1HsN4JDm+XPEBqIrBL//NBFJ8DxkbnrNuS8XfkBK57NPYkr4Cq
         8MWEhJI3OTf0rQvlvWAVUi/jiJhkeCZ0WCcZymheOVTs+Wi4wbWUi51ESMZ1XBWx7yRU
         v29KIlSxQgHEHAsq/jdTbnEgP3JoWI664P3krjYODTBVsT7Ydh1Usr5Io2jAMuZkBAkD
         TI/Q==
X-Gm-Message-State: AOAM533zYhtKGSJOxqPSwX2z7r1ZAFhBIcDEkYiPg/Um/g6Stp9xLYdJ
	ri/16ztmeTWvbvkkrpb5WWxSgQ==
X-Google-Smtp-Source: ABdhPJw68HazkcGoyCsJQjRqFg3wV2ekNgFAHyBXGKpvoB4V9/rxPcE/2CSldmD2q5Z6eFQk3rS66A==
X-Received: by 2002:adf:f346:0:b0:20a:c23f:fb14 with SMTP id e6-20020adff346000000b0020ac23ffb14mr18701627wrp.25.1650982693829;
        Tue, 26 Apr 2022 07:18:13 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id r3-20020a5d6c63000000b0020a94e82a3dsm11969254wrz.64.2022.04.26.07.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:18:13 -0700 (PDT)
Date: Tue, 26 Apr 2022 15:18:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Daisuke Nojiri <dnojiri@google.com>
Cc: Prashant Malani <pmalani@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
Message-ID: <Ymf/I4WAF8CmEqQM@google.com>
References: <20220419000408.3202635-1-swboyd@chromium.org>
 <Yl4Au/O/am/ZbX9J@chromium.org>
 <CAE-0n507D9W5BFfG2vXqN1cqvnrQKLbLw7YejGb5_kH+7X62sw@mail.gmail.com>
 <CACeCKac83uiwdAf2RWqc9DxEft2+BSBn5Kp5PMR23UGKJyk5KQ@mail.gmail.com>
 <CAC0y+Ajf2GTG=ir=gu9T5Q1TXBHMC5qzzA_MEzWAvW5D71Yv8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC0y+Ajf2GTG=ir=gu9T5Q1TXBHMC5qzzA_MEzWAvW5D71Yv8g@mail.gmail.com>

On Tue, 19 Apr 2022, Daisuke Nojiri wrote:

> The patch v2 looks good to me.

Please place your reply in-line. Top posting is generally frowned upon.

Also, please reply with a *-by (Reviewed-by in this case).

LGTMs do not carry any weight and will not be applied with the patch.

Thanks.

> On Tue, Apr 19, 2022 at 7:59 AM Prashant Malani <pmalani@chromium.org> wrote:
> >
> > On Tue, Apr 19, 2022 at 7:55 AM Stephen Boyd <swboyd@chromium.org> wrote:
> > >
> > > Quoting Prashant Malani (2022-04-18 17:22:19)
> > > > On Apr 18 17:04, Stephen Boyd wrote:
> > > > > +             retval = mfd_add_hotplug_devices(ec->dev,
> > > > > +                                     cros_ec_pchg_cells,
> > > > > +                                     ARRAY_SIZE(cros_ec_pchg_cells));
> > > > > +             if (retval)
> > > > > +                     dev_warn(ec->dev, "failed to add pchg: %d\n",
> > > > > +                              retval);
> > > > Tiny nit: Can this fit in 1 line (100 chars[1])?
> > > >
> > >
> > > I'm matching the style of other lines in this file (this is copy
> > > pasta). I'll let the maintainer decide what to do.
> >
> > Quite a bit of that code predates the char limit update, but OK.

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
