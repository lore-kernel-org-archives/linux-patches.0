Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F3E3D65
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 23:31:59 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id t13so21637197pgn.8
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 16:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u9HwDSu3jkL7GJkxdCGm5YU8ByJmgH0nknQ3b6eIwRs=;
        b=k0TMbaYzoa+OpneeXjXULYrDQlTSjIF+F3LakzftsYDwdrmPYjl/VyFfYJI2HfdCGA
         OT+k+eak3/T/cCFkYLP8k4W8e88ZFlObRsuM6NogdC6+D3Vpidz4HLP/TAiPtNXyIQoI
         Yl0YWKbPRXDAvLag5neYUgdEm0xLQJ2AVw9Mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9HwDSu3jkL7GJkxdCGm5YU8ByJmgH0nknQ3b6eIwRs=;
        b=tqCRN6qosAPdaxLvsED9I8TEnBGlZUzxm2UoY/pLzYPLUdMPLoSG6zkvnnKiNK0lv1
         G3VdroF64B2FFjYSlkCT1GM9DoWoZhJsUA8udY/iDQjjWEHwlUNXUv+dORMLeJsCrkOs
         BR0F6qr4jTcZXO0bE1gef6+FM8lieUlBCQJDfo9euXUNQsSh4FGI2CMu/kRQ+kyweI2m
         wyOHl3N6BoYK3UB+xSG4FQDB0IBNkkbdEyiGDSlwNPSF78RxwPquAOR3a1FILQCSXQm3
         mbsNAOsmMpQw4XDM7CfH5qMnHNdtZBy7ZR96rA4nRzSVEEnIlkctIgg4UCr0ZGX0saDO
         mMRQ==
X-Gm-Message-State: AOAM531l7tmX0Ojoz2d/FlpyjgGdlW1RcBFhWKDF+d+Me1pe/li5Q8VR
	OfRAkIMaah4d23MhcDVBrYRdqw==
X-Google-Smtp-Source: ABdhPJwxK5PaPInu/IR4v+tY4NZnK4X/5TSAG8oOcafdt4PbOYXt5YvZ4a1LKPMfOXWyZcuYYlyz5g==
X-Received: by 2002:a05:6a00:2391:b0:50a:3ea9:e84d with SMTP id f17-20020a056a00239100b0050a3ea9e84dmr14999727pfc.21.1650324719179;
        Mon, 18 Apr 2022 16:31:59 -0700 (PDT)
Received: from chromium.org (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm14283141pfc.78.2022.04.18.16.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:31:58 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:31:57 +0000
From: Prashant Malani <pmalani@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH 1/3] platform/chrome: cros_ec_proto: Add peripheral
 charger count API
Message-ID: <Yl307fUo09z2/M+w@chromium.org>
References: <20220415003253.1973106-1-swboyd@chromium.org>
 <20220415003253.1973106-2-swboyd@chromium.org>
 <Yl3vd4kfgwJXMs/w@chromium.org>
 <CAE-0n53N1k_b9vWJ84nBdm9sxpYV3o4-FLJQM1HGqEhQsdr19A@mail.gmail.com>
 <Yl3ykMvfCaQlQ7t9@chromium.org>
 <CAE-0n51PX1SgqiB5vgoOLunkrxiWxH2O=jCCM5gNL97O8Ltt4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n51PX1SgqiB5vgoOLunkrxiWxH2O=jCCM5gNL97O8Ltt4Q@mail.gmail.com>

On Apr 18 16:29, Stephen Boyd wrote:
> Quoting Prashant Malani (2022-04-18 16:21:52)
> > On Apr 18 16:16, Stephen Boyd wrote:
> > >
> > > Sure. I take it that I can drop this function entirely then?
> >
> > Yeah, if it's a simple response, should be fine.
> >
> > > BTW, why is
> > > that function name the same as a struct name? It confuses my ctags.
> >
> > Yeahhh, didn't think about ctags... :/
> > Topic for another series: probably can be renamed to cros_ec_cmd() (just to keep ctags happy) ?
> >
> 
> But then there'll be two cros_ec_cmd() because there's a
> cros-ec-regulator. Fun! :)

Ugh :S

I think we can get rid of that one; it looks to be the same as this
one :)


I'll write up a cleanup series if it all looks OK.

