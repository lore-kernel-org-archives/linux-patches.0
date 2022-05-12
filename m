Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF803FF1;
	Thu, 12 May 2022 23:31:13 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d17so6391062plg.0;
        Thu, 12 May 2022 16:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eYpdJ90sIk3qZfEgX1a80cpN/dFwOCIJBaG2OIahXBc=;
        b=qKp7BG8mXAqZXqb/q+PqxvmItgFgFMkAAnwKz1ZHXkZUzAmYP1HhV7uDIrl8P5ETsq
         wcXGlgBZT6WcjLF4FbrqrsOPbP6NYQLlPiTVFfR+/fdNCoT+aOUjWHFviEiJEDWPRe8M
         QAZVv4pIpo4JlGexYJ02gmNzrN7VyihR6x7qLYq1mKKzPKPZZoiql485/sL4mdIcSlaH
         qXl8S8sFG43zr08JWElKyp6uI8TS5HgtN4WwArQ9QPt7WWqnpi5JwOLaoVVY6il+NlE4
         Aft7cZSdhohv0lDf1inYoo0+fKqi5aFjNKon+ogLso8wmA2p1Z/RWkB02i+JU4p0uBbL
         Vwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eYpdJ90sIk3qZfEgX1a80cpN/dFwOCIJBaG2OIahXBc=;
        b=4bwsE+as5+kp88UJgOKSxHy99sddo22YSVc9QKWicNTmrn4Ui1OfcrJHVlPYfaMIBy
         CZGKsYhGAqPQeqsW7IkW3cIrTiIXb5X7Ww0VQs/qG7a+wg1e8/wWANIwazoVqtQ/QWjQ
         ZdG6Q9mwwv617B7OGmiX8rs3aJS4CD1bkIaEwZowE2n5Q6PUZYKHo0BPhU8UPEoV3VT5
         T+THEQah/N3brRgyWVHu/QSEctbCcRsFpqy+OcHG5oLfw3j5aytgcGPgJpAD5PpDMP+G
         zsEekwACAYm+lZ0RYqVvdcAt2o1DU5sKBBR4yxJZPZpQMqrZsod9WcVGFMSczU3zbSqt
         nc7g==
X-Gm-Message-State: AOAM5317ldQAJWTxV2cCBN9yYfWXmgH3vcG+rZVPUy52X04WD6zCR6u+
	WBaFZgPARYAFRjnkUFS+gqg=
X-Google-Smtp-Source: ABdhPJxGwDjAa20EhqPaHUJXCC4KPV0xgsDoyqJN1XWSOCehFaWL3975iAR5D+4hE6C6ezwHizsd1w==
X-Received: by 2002:a17:902:f24c:b0:15c:b564:e4cc with SMTP id j12-20020a170902f24c00b0015cb564e4ccmr1893884plc.137.1652398272481;
        Thu, 12 May 2022 16:31:12 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:88fd:a79c:b005:79b1])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902710300b0015e8d4eb22esm443677pll.120.2022.05.12.16.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 16:31:11 -0700 (PDT)
Date: Thu, 12 May 2022 16:31:08 -0700
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
Message-ID: <Yn2YvIFNhaz5GmfI@google.com>
References: <20220429233112.2851665-1-swboyd@chromium.org>
 <20220429233112.2851665-2-swboyd@chromium.org>
 <CAD=FV=VX8EEgkeLgKwyKvjztcjbA8UhKOUpTr-sS1_Ec=QcWbA@mail.gmail.com>
 <CAKdAkRSOtAD6u_cwKhHeMLgz5dC2hfPvVvqmj+17b4i-nspfgg@mail.gmail.com>
 <CAE-0n50Y8tZD9Djn9TVaAiHxehFJ2cZKZ1Z09piDk47uw3nK+Q@mail.gmail.com>
 <Ynzf5jEIECLmELK7@google.com>
 <CAE-0n50+obQ5qgPNPtUY=OmTgU9bZQ3hNw+MaG9Wi3SQSc-i4A@mail.gmail.com>
 <CAE-0n52WVNru5fnyaB_7wcBOk4twL0Q92YpRbd40-o6ZBmbXWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE-0n52WVNru5fnyaB_7wcBOk4twL0Q92YpRbd40-o6ZBmbXWQ@mail.gmail.com>

On Thu, May 12, 2022 at 01:11:39PM -0700, Stephen Boyd wrote:
> Quoting Stephen Boyd (2022-05-12 11:58:02)
> > Quoting Dmitry Torokhov (2022-05-12 03:22:30)
> > >
> > > Have we solved module loading in the presence of multiple compatibles?
> > > IIRC we only ever try to load module on the first compatible, so you'd
> > > be breaking autoloading cros-ec-keyb on these older kernels. I think the
> > > cure that is being proposed is worse than the disease.
> > >
> >
> > The first compatible is still cros-ec-keyb in the driver though? Or you
> > mean the first compatible in the node? I'm not aware of this problem at
> > all but I can certainly test out a fake node and module and see if it
> > gets autoloaded.
> 
> I can't get this test module to fail to load no matter what I do. I
> commented out the second match table entry, and kept it there and
> removed 'vendor,switch-compat' from the DTS. Module still autoloads.
> 

Ah, indeed, if the module contains both compatibles we will load it. It
is broken when we have 2 or more modules and DT lists several
compatibles for a device.

OK, it looks like you feel very strongly regarding having a dedicated
compatible. In this case please make sure that the compatible's behavior
is properly documented (i.e. google,cros-ec-keyb compatible does not
imply that there are *NO* switches, and users having buttons and
switches in addition to matrix keys can also use google,cros-ec-keyb as
a compatible for their device). We also need to mention that with the
2nd compatible the device still can report key/button events, it is
simply that there is no matrix component. Should we call the other
compatible google,cros-ec-bs?

We should also abort binding the device if it specifies the new
compatible, but EC does not report any buttons or switches.

Thanks.

-- 
Dmitry
